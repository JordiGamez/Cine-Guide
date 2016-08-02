//
//  MovieViewControllerTests.swift
//  Cine Guide
//
//  Created by Jordi Gamez on 2/8/16.
//  Copyright © 2016 Jordi Gamez. All rights reserved.
//

import XCTest
@testable import Cine_Guide

class MovieViewControllerTests: XCTestCase {
    
    var viewController: MovieViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = navigationController.topViewController as! MovieViewController
        
        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}