//
//  Movie.swift
//  Cine Guide
//
//  Created by Jordi Gamez on 31/7/16.
//  Copyright © 2016 Jordi Gamez. All rights reserved.
//

import UIKit

// Movie class
class Movie: NSObject {
    
    var slug: String
    var title: String
    var year: String
    var overview: String
    var picture: String
    
    // Initializer
    init(slug: String, title: String, year: String, overview: String, picture: String) {
        self.slug = slug
        self.title = title
        self.year = year
        self.overview = overview
        self.picture = picture
    }
}