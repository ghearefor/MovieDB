//
//  BaseCollectionView.swift
//  MovieDB
//
//  Created by Ghea on 23/04/22.
//

import UIKit

protocol BaseCollectionViewDataSource: class {
    func refreshData()
    func loadMore(_ pageNumber: Int)
    func numberOfSections(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
}

@objc protocol BaseCollectionViewDelegate {
    @objc optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    @objc optional func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
}

class BaseCollectionView: UICollectionView {
    weak var collectionViewDelegate: BaseCollectionViewDelegate?
    weak var collectionViewDataSource: BaseCollectionViewDataSource?

    private var isLoading = false {
        didSet {
            self.isLoading = false
            self.refreshControlView.endRefreshing()
            self.reloadData()
        }
    }
    var currentPage = 0
    var lastPage = 0 {
        didSet {
            self.isPagination = lastPage >= 1
            self.refreshControlView.endRefreshing()
            self.reloadData()
        }
    }
    private var isPagination: Bool = false
    private var refreshControlView = UIRefreshControl()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        self.delegate = self
        self.dataSource = self
        self.alwaysBounceVertical = true
        self.backgroundColor = .clear
        self.refreshControlView.backgroundColor = .black
        self.refreshControlView.tintColor = .white
        self.refreshControlView.addTarget(self, action: #selector(self.handleRefresh), for: UIControl.Event.valueChanged)
        self.addSubview(refreshControlView)
    }
}

// MARK: - Actions
extension BaseCollectionView {
    @objc func handleRefresh() {
        self.refreshControlView.beginRefreshing()
        loadData(refreshPage: true)
    }

    func loadData(refreshPage: Bool = false) {
        if refreshPage {
            currentPage = 1
            collectionViewDataSource?.refreshData()
        } else if isPagination {
            if currentPage + 1 <= lastPage {
                self.currentPage += 1
                collectionViewDataSource?.loadMore(currentPage)
            } else {
                isLoading = false
            }
        }
        self.refreshControlView.endRefreshing()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            if isPagination {
                isLoading = true
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            if isPagination {
                loadData()
            }
        }
    }
}

extension BaseCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfRow = collectionViewDataSource?.collectionView(collectionView, numberOfItemsInSection: section) {
            return numberOfRow
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.isUserInteractionEnabled = true
        return collectionViewDataSource?.collectionView(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewDataSource?.numberOfSections(in: collectionView) ?? 1
    }
}

extension BaseCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionViewDelegate?.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) ?? UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionViewDataSource?.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewDataSource?.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return collectionViewDelegate?.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) ?? CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionViewDataSource?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension BaseCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewDataSource?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewDataSource?.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 0
    }
}
