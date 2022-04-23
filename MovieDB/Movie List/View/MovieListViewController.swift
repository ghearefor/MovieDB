//
//  MovieListViewController.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import Foundation
import UIKit

// MARK: - MovieListViewController

class MovieListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Var
    lazy var viewModel: MovieListViewModel = {
        return MovieListViewModel(api: MovieAPI())
    }()
    var dataSource: MovieListDataSource!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        DispatchQueue.main.async { [self] in
            viewModel.getMovieList(page: 1, category: .popular)
            viewModel.getMovieList(page: 1, category: .topRated)
            viewModel.getMovieList(page: 1, category: .nowPlaying)
        }
    }

    private func setupUI() {
        title = "Movies"
        view.backgroundColor = .black
        setNavbarTranslucent()
        tableView.backgroundColor = .black
        tableView.estimatedRowHeight = 55
        tableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.register(CategoryHeaderView.nib, forHeaderFooterViewReuseIdentifier: CategoryHeaderView.identifier)
        addFavoriteButton()
    }

    private func setupViewModel() {
        viewModel.onShowSuccess = {
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
        viewModel.onUpdateLoadingStatus = { [weak self] in
            guard let _ = self?.viewModel.isLoading else {return}
        }
    }

    // MARK: - Actions
    @objc func seeAllButtonTapped(sender: UIButton) {
        let vc = AllMoviesViewController()
        vc.viewModel = viewModel
        vc.category = MovieCategory.allCases[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Table View Delegate / Data Source
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoryHeaderView.identifier) as! CategoryHeaderView

        headerView.lblCategoryName.text = MovieCategory.allCases[section].rawValue
        headerView.btnSeeAll.tag = section
        headerView.btnSeeAll.addTarget(self, action: #selector(seeAllButtonTapped(sender:)), for: .touchUpInside)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell

        switch MovieCategory.allCases[indexPath.section] {
        case .popular:
            cell.bind(list: viewModel.popular, parent: self)
        case .topRated:
            cell.bind(list: viewModel.topRated, parent: self)
        case .nowPlaying:
            cell.bind(list: viewModel.nowPlaying, parent: self)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
