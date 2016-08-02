//
//  MovieViewController.swift
//  Cine Guide
//
//  Created by Jordi Gamez on 1/8/16.
//  Copyright © 2016 Jordi Gamez. All rights reserved.
//

import UIKit
import Haneke

class MovieViewController: UIViewController, UIScrollViewDelegate {
    
    var slug: String = ""
    var titulo: String = ""
    var year: String = ""
    var overview: String = ""
    var picture: String = ""
    
    @IBOutlet weak var moviePicture: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation Controller appearance
        self.navigationController?.navigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Movie object
        let movie = Movie(slug: slug, title: titulo, year: year, overview: overview, picture: picture)
        
        // Movie title
        self.title = movie.title
        self.movieTitle.text = movie.title
        
        // Movie year
        self.movieYear.text = movie.year
        
        // Movie overview
        self.movieOverview.text = movie.overview
        
        // Movie picture
        let urlString = movie.picture
        let url = NSURL(string: urlString)
        moviePicture?.hnk_setImageFromURL(url!)
        moviePicture.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}