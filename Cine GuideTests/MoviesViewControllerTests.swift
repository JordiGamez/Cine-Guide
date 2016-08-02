//
//  MoviesViewControllerTests.swift
//  Cine Guide
//
//  Created by Jordi Gamez on 1/8/16.
//  Copyright © 2016 Jordi Gamez. All rights reserved.
//

import UIKit
import XCTest
@testable import Cine_Guide

class MoviesViewControllerTests: XCTestCase {
    
    var controller: MoviesViewController!
    
    override func setUp() {
        super.setUp()
        
        controller = MoviesViewController()
        controller.view.description
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    func testTableViewOutlet() {
        XCTAssertNotNil(controller.tableView)
    }
    
    func testTableViewCellForRowAtIndexPath() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        let cell = controller.tableView(controller.tableView, cellForRowAtIndexPath: indexPath) as! MovieTableViewCell
        
        XCTAssertEqual(cell.movieTitle.text!, "title")
        XCTAssertEqual(cell.movieYear.text!, "year")
    }
    */
}