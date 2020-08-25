//
//  SearchViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 22.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusSearchLabel: UILabel!
    
    //Properties
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
        setupUIControllers()
    }    

    //MARK: - setupUIControllers: Configures delegation and properties from UI elements
    fileprivate func setupUIControllers() {
        //Setup tableView Delegate and Datasource
        tableView.delegate = self
        tableView.dataSource = self
        //Hide the table upon view load
        tableView.isHidden = true
        
        //Setup searchBar delegation and deactivate Autocapitalization
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
        //Set the statusSearchLabel as "Type in the search bar to start"
        statusSearchLabel.text = Constants.LabelTextStatus.noSearchDone.message
    }
    
    //MARK: - prepare: Gets data ready to pass to DetailsVC when performing the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToDetailsSegue"{
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.plantSelectedData = plantsSearchResult.data[selectedIndex]
        }
    }
}
