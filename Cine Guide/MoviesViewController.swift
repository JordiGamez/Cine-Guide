//
//  MoviesViewController.swift
//  Cine Guide
//
//  Created by Jordi Gamez on 31/7/16.
//  Copyright © 2016 Jordi Gamez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke

// Simultaneously Gesture Recognizer extension
extension MoviesViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

enum UIUserInterfaceIdiom {
    case Unspecified
    case Phone
    case Pad
}

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let url: String = "https://api.trakt.tv/movies/popular"
    let urlSearch: String = "https://api.trakt.tv/search/movie?query="
    let clientID: String = "019a13b1881ae971f91295efc7fdecfa48b32c2a69fe6dd03180ff59289452b8"
    
    var movies = [Movie]()
    var searchMovies = [Movie]()
    
    var firstServiceCallComplete = false
    var secondServiceCallComplete = false
    
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Most popular"
        
        searchBar.delegate = self
        collectionView.hidden = false
        tableView.hidden = true
        
        // Dark keyboard appearance
        self.searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
        
        // TableViewCell dynamic height
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Notification when the Keyboard appears
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MoviesViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        // Tap gesture recognizer when tapping the collectionView to hide the Keyboard
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(MoviesViewController.hideKeyboard))
        self.tapGesture.delegate = self
        self.tapGesture.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(self.tapGesture)
        
        // Connect and retrieve the 10 most popular movies
        getMovies(url, clientID: self.clientID, moreMovies: false) { response in
            // Update the collectionView to display the new data
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        // Change the Title when the keyboard appears
        self.title = "Movie finder"
    }
    
    // Search functionality
    func hideKeyboard() {
        // Dismiss keyboard
        searchBar.endEditing(true)
        self.title = "Most popular"
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        tableView.hidden = false
        collectionView.hidden = true
        
        // If the "Search" button is pressed
        
        // Dismiss keyboard
        hideKeyboard()
        
        // Get the input from the UISearchBar
        let string: String = searchBar.text!
        
        // Replace " " with "-" to match the search in Trakt API
        var inputString = string.stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        inputString = inputString.stringByReplacingOccurrencesOfString("ñ", withString: "n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        inputString = inputString.stringByReplacingOccurrencesOfString("Ñ", withString: "N", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        // Send the input from the UISearchBar and show the results
        searchMovies(inputString, clientID: self.clientID) { response in }
        
        self.title = "Movie finder"
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        // Dismiss keyboard
        hideKeyboard()
        
        self.title = "Movie finder"
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.title = "Movie finder"
        if searchBar.text == "" {
            // When the user writes nothing in the UISearchBar
            tableView.hidden = true
            collectionView.hidden = false
            // Dismiss keyboard
            hideKeyboard()
        } else {
            // When the user keeps on writing in the UISearchBar
            tableView.hidden = false
            collectionView.hidden = true
            
            // Get the input from the UISearchBar
            let string: String = searchBar.text!
            
            // Replace " " with "-" to match the search in Trakt API
            var inputString = string.stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
            inputString = inputString.stringByReplacingOccurrencesOfString("ñ", withString: "n", options: NSStringCompareOptions.LiteralSearch, range: nil)
            inputString = inputString.stringByReplacingOccurrencesOfString("Ñ", withString: "N", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            // Send the input from the UISearchBar and show the results
            searchMovies(inputString, clientID: self.clientID) { response in }
        }
    }
    
    // Collection View
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return number of movies
        return self.movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Collection", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        cell.moviePicture.image = nil
        
        // Movie picture
        let urlString = movies[indexPath.row].picture
        let url = NSURL(string: urlString)
        cell.moviePicture?.hnk_setImageFromURL(url!)
        cell.moviePicture.clipsToBounds = true
        
        // Load 10 more movies when you get to the bottom of the list
        if indexPath.row == movies.count-1  && indexPath.row > 6 { getMovies(self.url, clientID: self.clientID, moreMovies: true) { response in } }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
            case .Phone:
                // Two movies per row
                return CGSizeMake(UIScreen.mainScreen().bounds.width/2, 222)
            
            case .Pad:
                // Two movies per row
                return CGSizeMake(UIScreen.mainScreen().bounds.width/2, 550)
            
            case .Unspecified:
                // Two movies per row
                return CGSizeMake(UIScreen.mainScreen().bounds.width/2, 222)
            
            default:
                // Two movies per row
                return CGSizeMake(UIScreen.mainScreen().bounds.width/2, 222)
        }
    }
    
    // Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Return number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return number of movies
        return searchMovies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MovieTableViewCell
        
        cell.moviePicture.image = nil
        
        cell.selectionStyle = .None
        
        // Movie title
        cell.movieTitle.text = searchMovies[indexPath.row].title
        
        // Movie year
        cell.movieYear.text = searchMovies[indexPath.row].year
        
        // Movie overview
        cell.movieOverview.text = searchMovies[indexPath.row].overview
        
        // Movie picture
        let urlString = searchMovies[indexPath.row].picture
        let url = NSURL(string: urlString)
        cell.moviePicture?.hnk_setImageFromURL(url!)
        cell.moviePicture.clipsToBounds = true
        
        return cell
    }
    
    // Segue to MovieViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMovieFromTable", let destination = segue.destinationViewController as? MovieViewController, index = tableView.indexPathForSelectedRow?.row {
            // From tableView to MovieViewController
            destination.slug = searchMovies[index].slug
            destination.titulo = searchMovies[index].title
            destination.year = searchMovies[index].year
            destination.overview = searchMovies[index].overview
            destination.picture = searchMovies[index].picture
        }
    }
    
    // Search movies function
    func searchMovies(input: String, clientID: String, completion : ([Movie]) -> ()) {
        
        let url: String = urlSearch+input
        
        let headers = ["trakt-api-version":"2", "Content-Type": "application/json", "trakt-api-key": clientID]
        
        Alamofire.request(.GET, url, headers: headers).responseJSON { response in
            
            if response.result.isSuccess {
                let movieInfo = JSON(data: response.data!)
                
                // Empty the searchMovies
                self.searchMovies = []
                self.tableView.reloadData()
                
                for result in movieInfo.arrayValue {
                    
                    let slug = result["movie"]["ids"]["slug"].stringValue
                    let title = result["movie"]["title"].stringValue
                    let year = result["movie"]["year"].stringValue
                    
                    self.getOverviewAndPicture(slug, title: title, year: year, clientID: clientID, search: true)
                }
                
                completion(self.searchMovies)
            } else {
                print(response.result.error)
            }
        }
    }
    
    // Get the first 10 most popular movies OR the next 10 movies depend on the "moreViews" parameter
    func getMovies(url: String, clientID: String, moreMovies: Bool, completion : ([Movie]) -> ()) {
        
        var newURL: String = url
        
        // If moreMovies is true
        if moreMovies == true {
            // Get the number of movies displayed
            let moviesCount: Int = self.movies.count + 10
            
            // Get the page number
            let pageNumber: String = String(moviesCount/10)
            
            // Build the url
            newURL = url+"?page="+pageNumber+"&limit=10"
        }
        
        let headers = ["trakt-api-version":"2", "Content-Type": "application/json", "trakt-api-key": clientID]
        
        Alamofire.request(.GET, newURL, headers: headers).responseJSON { response in
            
            if response.result.isSuccess {
                let movieInfo = JSON(data: response.data!)
                
                for result in movieInfo.arrayValue {
                    
                    let slug = result["ids"]["slug"].stringValue
                    let title = result["title"].stringValue
                    let year = result["year"].stringValue
                    
                    self.getOverviewAndPicture(slug, title: title, year: year, clientID: clientID, search: false)
                }
                completion(self.movies)
            } else {
                print(response.result.error)
            }
        }
    }
    
    // Get the overview and the picture of the movie
    func getOverviewAndPicture(slug: String, title: String, year: String, clientID: String, search: Bool) {
        
        let headers = ["trakt-api-version":"2", "Content-Type": "application/json", "trakt-api-key": clientID]
        var overview: String = ""
        var picture: String = ""
        
        // Get Overview
        let firstRequest = Alamofire.request(.GET, "https://api.trakt.tv/movies/"+slug+"?extended=full", headers: headers)
            firstRequest.responseJSON { response in
                
            if response.result.isSuccess {
                let movieInfo = JSON(data: response.data!)
                overview = movieInfo["overview"].stringValue
            } else {
                print(response.result.error)
            }
            self.firstServiceCallComplete = true
        }
        
        // Get Picture
        let secondRequest = Alamofire.request(.GET, "https://api.trakt.tv/movies/"+slug+"?extended=images", headers: headers)
            secondRequest.responseJSON { response in
            
            if response.result.isSuccess {
                let movieInfo = JSON(data: response.data!)
                picture = movieInfo["images"]["poster"]["full"].stringValue
            } else {
                print(response.result.error)
            }
            self.secondServiceCallComplete = true
            
            // Call the handleServiceCompletion with the movie information
            self.handleServiceCallCompletion(slug, title: title, year: year, overview: overview, picture: picture, search: search)
        }
    }
    
    private func handleServiceCallCompletion(slug: String, title: String, year: String, overview: String, picture: String, search: Bool) {
        // If both API calls are complete
        if self.firstServiceCallComplete && self.secondServiceCallComplete {
            
            // Create a movie object
            let movie = Movie(slug: slug, title: title, year: year, overview: overview, picture: picture)
            
            if search == true {
                // Add movie to the "searchMovies" array
                self.searchMovies.append(movie)
                // Update the tableView to display the new data
                self.tableView.reloadData()
            } else {
                // Add movie to the "movies" array
                self.movies.append(movie)
                // Update the collectionView to display the new data
                self.collectionView.reloadData()
            }
        }
    }
}