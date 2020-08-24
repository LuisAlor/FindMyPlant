//
//  SearchViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 22.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusSearchLabel: UILabel!
    
    //Search Response var from Trefle.io
    var plantsSearchResult: PlantsSearchResponse!
    //Current URL Search Session Task
    var currentSearchTask: URLSessionTask?
    //Selected Plant index from tableview
    var selectedIndex: Int = 0
    //Array of URL Download Session Tasks
    var downloadImgURLSessionTasks: [URLSessionTask] = []
    //The current Download Image Task
    var currentDownloadImageTask: URLSessionTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIController()
    }    

    //Setups delegation and properties from UI elements
    fileprivate func setupUIController() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
        statusSearchLabel.text = Constants.LabelTextStatus.noSearchDone.message
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToDetailsSegue"{
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.plantSelectedData = plantsSearchResult.data[selectedIndex]
        }
    }
}
