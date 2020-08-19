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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIController()
    }    

    //Setups delegation and properties from UI elements
    fileprivate func setupUIController() {
          tableView.delegate = self
          tableView.dataSource = self
          searchBar.delegate = self
          searchBar.autocapitalizationType = .none
    }

}
