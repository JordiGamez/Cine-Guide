//
//  MovieTests.swift
//  Cine Guide
//
//  Created by Jordi Gamez on 31/7/16.
//  Copyright © 2016 Jordi Gamez. All rights reserved.
//

import XCTest
@testable import Cine_Guide

class MovieTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClassMovie() {
        let movie = Movie(slug: "slug", title: "title", year: "year", overview: "overview", picture: "picture")
        XCTAssertEqual(movie.slug, "slug")
        XCTAssertEqual(movie.title, "title")
        XCTAssertEqual(movie.year, "year")
        XCTAssertEqual(movie.overview, "overview")
        XCTAssertEqual(movie.picture, "picture")
    }
}