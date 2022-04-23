//
//  MovieListViewControllerTests.swift
//  MovieDBTests
//
//  Created by Ghea on 23/04/22.
//

import XCTest
@testable import MovieDB

class MovieListViewControllerTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    var sut: MovieListViewController!

    override func setUp() {
        storyboard = UIStoryboard(name: "MovieList", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "MovieListViewController") as MovieListViewController
        sut.loadViewIfNeeded()
        
    }

    override func tearDown() {
        storyboard = nil
        sut = nil
    }

    func test_setsTableView() throws {
        
        let tableView = try XCTUnwrap(sut.tableView, "The tableView is not connected to an IBOutlet")
        
        XCTAssertNotNil(tableView)
    }
    
    func test_numberOfSectionAreTheMovieCategoryCount() {
        let dataSource = MovieListDataSource(movies: [], parent: sut)
        
        let tablewView = UITableView()
        tablewView.dataSource = dataSource
        
        let numberOfSections = tablewView.numberOfSections
        
        XCTAssertEqual(3, numberOfSections)
    }

    func test_hasOneNumberOfRowsEachSection() {
        let dataSource = MovieListDataSource(movies: [], parent: sut)
        
        let tablewView = UITableView()
        tablewView.dataSource = dataSource
        
        let numberOfRows = tablewView.numberOfRows(inSection: 0)
        
        XCTAssertEqual(1, numberOfRows)
    }
}

