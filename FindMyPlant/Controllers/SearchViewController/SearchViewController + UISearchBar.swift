//
//  SearchViewController + UISearchBar.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 03.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        tableView.isHidden = true
        
        if searchText == "" {
            plantsSearchResult = nil
            TrefleAPiClient.imageCache.removeAllObjects()
             
            tableView.reloadData()
            
            statusSearchLabel.isHidden = false
            statusSearchLabel.text = Constants.SearchStatus.noSearch.message
        } else {
            statusSearchLabel.isHidden = true
            currentSearchTask?.cancel()
            activityViewIndicator.startAnimating()
            currentSearchTask = TrefleAPiClient.searchForPlant(searchText, completionHandler: searchPlantResultHandler(response:error:))
        }
    }
    
    func searchPlantResultHandler(response: PlantsSearchResponse?, error: Error?){
        if let response =  response {
            if response.data.count == 0 {
                statusSearchLabel.isHidden = false
                activityViewIndicator.stopAnimating()
                statusSearchLabel.text = Constants.SearchStatus.noResults.message
            } else {
                activityViewIndicator.stopAnimating()
                self.plantsSearchResult = response
                self.tableView.reloadData()
                tableView.isHidden = false
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
