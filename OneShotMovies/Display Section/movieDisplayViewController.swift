//
//  movieDisplayViewController.swift
//  OneShotMovies
//
//  Created by Adhita Selvaraj on 13/01/17.
//  Copyright © 2017 DreamCatcher. All rights reserved.
//

import UIKit
import Async
import Alamofire
import SQLite

class Movie {
    var name: String
    var rating: String
    var poster: String
    var iid: String
    var plot: String
    
    init(name: String, rating: String, poster: String, iid: String, plot: String) {
        self.name = name
        self.rating = rating
        self.poster = poster
        self.iid = iid
        self.plot = plot
    }
}

class movieList {
    static let instance = movieList()
    private let db: Connection?
    
    private let movies = Table("movies")
    let title = Expression<String>("title")
    let posterUrl = Expression<String>("posterUrl")
    let rating = Expression<String>("rating")
    let id = Expression<String>("id")
    let dbid = Expression<Int64>("dbid")
    let plot = Expression<String>("plot")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            db = try Connection("\(path)/DBmovie.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        createTable()
    }
    func createTable() {
        do {
            try db!.run(movies.create(ifNotExists: true) { table in
                table.column(id,unique: true)
                table.column(title)
                table.column(rating)
                table.column(posterUrl)
                table.column(plot)
                table.column(dbid, primaryKey: true)
            })
        } catch {
            print("Unable to create table")
        }
    }
    func addMovie(ctitle: String, crating: String, cposterUrl: String, cid: String, cplot: String) -> Int64? {
        
        do {
            let insert = movies.insert(title <- ctitle, rating <- crating, posterUrl <- cposterUrl, id <- cid, plot <- cplot)
            let dbid = try db!.run(insert)
            print("Movie Added")
            
            return dbid
            
        } catch {
            print("Insert Failed")
            return -1
            
        }
        
    }
    func getMovie() -> [Movie] {
        var movies = [Movie]()
        
        do {
            for movie in try db!.prepare(self.movies) {
                
                movies.append(Movie(name: movie[title], rating: movie[rating], poster: movie[posterUrl], iid: movie[id], plot: movie[plot]))
                
                print(movies.count)
            }
            
        } catch {
            print("Select Failed")
        }
        
        return movies
    }
    
}


class movieDisplayViewController: UIViewController {

    var requestString = ""
    
    @IBOutlet var movieNameLabel: UILabel!
    
    @IBOutlet var moviePosterImageView: UIImageView!
    
    @IBOutlet var movieRatingLabel: UILabel!
    
    @IBOutlet var moviePlotTextView: UITextView!
    
    @IBOutlet var ratingLabel: UILabel!
    
    var names = ""
    var ratings = ""
    var posterUrls = ""
    var ids = ""
    var plots = ""
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
        
        let a = movieList.instance.addMovie(ctitle: names, crating: ratings, cposterUrl: posterUrls, cid: ids, cplot: plots)

        let alertAddSucceeded = UIAlertController(title: "Favourite", message: "Movie Added", preferredStyle: UIAlertControllerStyle.alert)
        
        let addSuccessAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertAddSucceeded.addAction(addSuccessAction)
        
        let alertAddFailed = UIAlertController(title: "Alert", message: "Already Exists!", preferredStyle: UIAlertControllerStyle.alert)
        
        let addFailAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let b = Int64(-1)
        
        if a == b {
            alertAddFailed.addAction(addFailAction)
             print(a!,b)
        }
        else {

            alertAddSucceeded.addAction(addSuccessAction)
        }
        
       
        
    }
    
    func loadMovieData() {
        
        var movieDict = NSDictionary()
        
        let group = AsyncGroup()
        
        group.background {
            
            if movieYear == 0 {
                self.requestString = ""
            }
            else {
                self.requestString = "&y=\(movieYear)"
            }

            Alamofire.request("http://www.omdbapi.com/?t=\(movieName)\(self.requestString)&r=json").responseJSON(completionHandler: { (response) in
                
                if let JSON = response.result.value {
                    movieDict = JSON as! NSDictionary
                    print(movieDict)
                }
                if let status = movieDict["Response"] {
                
                    let state = status as! String
                    
                    if state == "True" {
                    
                        self.names = movieDict["Title"] as! String
                        self.ratings = movieDict["imdbRating"] as! String
                        self.posterUrls = movieDict["Poster"] as! String
                        self.ids = movieDict["imdbID"] as! String
                        self.plots = movieDict["Plot"] as! String
                        
                        self.ratingLabel.text = "Rating"
                        self.movieNameLabel.text = movieDict["Title"] as? String
                        self.movieRatingLabel.text = movieDict["imdbRating"] as? String
                        let posterUrl = URL(string: movieDict["Poster"] as! String)
                        let posterData = NSData(contentsOf: posterUrl!)
                        self.moviePosterImageView.image = UIImage(data: posterData as! Data)
                        self.moviePlotTextView.text = movieDict["Plot"] as! String
                    }
                }
            })
            
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "Home")
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "movieDisplay")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        loadMovieData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
