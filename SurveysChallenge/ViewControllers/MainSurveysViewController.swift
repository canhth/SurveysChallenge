//
//  MainSurveysViewController.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol SurveyListViewType: ErrorActionable {
    var onSurveySelected: ((_ survey: Survey) -> Void)? { get set }
}

typealias SurveysListViewControllerDependency = MainSurveysViewController.Dependency
extension MainSurveysViewController {
    struct Dependency {
        let viewModel: MainSurveysViewModel
    }
}

final class MainSurveysViewController: BaseViewController, SurveyListViewType {
    
    // MARK: IBOutlets & variables
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var refreshBarButton: UIBarButtonItem!
    @IBOutlet weak private var pageControl: CustomPageControl!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    private var viewModel: MainSurveysViewModel!
    private let disposeBag = DisposeBag()
    
    // Protocols
    var onSurveySelected: ((Survey) -> Void)?
    var onErrorReceived: ((String?, Error) -> Void)?
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        setupData()
        AuthNotification.logIn.observe(observer: self, selector: #selector(setupData))
    }
    
    // MARK: - Setup
    func inject(_ dependency: Dependency) {
        viewModel = dependency.viewModel
    }
    
    private func setupUI() {
        loadingIndicatorView.startAnimating()
        pageControl.customBorderColor = .white
        tableView.addSubview(refreshControl)
        tableView.register(UINib(nibName: SurveyCell.typeName, bundle: nil), forCellReuseIdentifier: SurveyCell.typeName) 
    }

    private func setupBinding() {
        guard viewModel != nil else { fatalError("viewModel non-existed") }
 
        refreshBarButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.refresh()
                DispatchQueue.main.async {
                    guard !self.viewModel.surveys.isEmpty else { return }
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .filter({ [unowned self] in self.refreshControl.isRefreshing })
            .bind(to: viewModel.onRefresh)
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .filter { [unowned self] offset in
                guard self.tableView.contentSize.height > 0 else { return false }
                let preLastOffset = self.tableView.bounds.height * CGFloat(self.viewModel.surveys.count - 1)
                return offset.y >= preLastOffset
            }
            .map { _ in () }
            .bind(to: viewModel.onLoadMore)
            .disposed(by: disposeBag)

        viewModel.viewState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                switch state {
                case .working:
                    self.tableView.reloadData()
                    self.loadingIndicatorView.stopAnimating()
                    self.setupPageControl()
                case let .error(error):
                    self.onErrorReceived?("Error", error)
                case .loading, .blank:
                    self.loadingIndicatorView.startAnimating()
                }
                self.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
    }
    
    @objc private func setupData() {
        setupPageControl()
        viewModel.refresh()
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.surveys.count
        pageControl.currentPage = Int(tableView.contentOffset.y / tableView.frame.size.height)
        pageControl.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
}

extension MainSurveysViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.surveys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SurveyCell.typeName, for: indexPath) as? SurveyCell else { return UITableViewCell() }
        if let survey = viewModel.surveys.get(at: indexPath.row) {
            cell.setupCellWithData(survey: survey)
            cell.onSurveySelected = { [weak self] in
                guard let self = self else { return }
                self.onSurveySelected?(survey)
            }
        }
        return cell
    }
}

extension MainSurveysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.y / tableView.frame.size.height)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ViewSuspendable)?.suspend()
    }
}
