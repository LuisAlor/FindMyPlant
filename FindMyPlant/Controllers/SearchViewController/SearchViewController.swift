//
//  SearchViewController.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 22.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var plantsSearchResult: PlantsSearchResponse!
    var currentSearchTask: URLSessionTask?
    var selectedPlantIndex: Int = 0
    var downloadImgURLSessionTasks: [URLSessionTask] = []
    var currentDownloadImageTask: URLSessionTask!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusSearchLabel: UILabel!
    
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
        
        statusSearchLabel.text = Constants.SearchStatus.noSearch.message
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToDetailsSegue"{
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.plantSelectedData = plantsSearchResult.data[selectedPlantIndex]
        }
    }
    
    

}
