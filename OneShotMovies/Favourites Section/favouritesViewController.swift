//
//  favouritesViewController.swift
//  OneShotMovies
//
//  Created by Adhita Selvaraj on 13/01/17.
//  Copyright © 2017 DreamCatcher. All rights reserved.
//

import UIKit

let m = movieList.instance

let moves = m.getMovie()

class favouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! favouriteMovieTableViewCell
        
        cell.backgroundColor = .clear
        
        if indexPath.row < moves.count {
            print(indexPath.row)
            cell.movieTitleInTable.text = moves[indexPath.row].name
            cell.movieRatingInTable.text = moves[indexPath.row].rating
            let imgUrl = URL(string: moves[indexPath.row].poster)
            let imgData = NSData(contentsOf: imgUrl!)
            //cell.moviePosterImage.layer.cornerRadius = 75.0
            //cell.moviePosterImage.clipsToBounds = true
            cell.moviePosterImage.image = UIImage(data: imgData as! Data)
            cell.movieStaticLabel.text = "Rating"
        }
        
        return cell
    }
    
    @IBAction func searchButtonClick(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "Home")
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backButtonClick(_ sender: Any) {
        
        self.present(movieDisplayViewController(), animated: true, completion: nil)
        
    }
   
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "favouriteMovieTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "moviesCell")
        self.tableView.rowHeight = 100.0
        
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "tableViewImage")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        self.tableView.backgroundColor = UIColor(patternImage: image)
        
            }

    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
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
