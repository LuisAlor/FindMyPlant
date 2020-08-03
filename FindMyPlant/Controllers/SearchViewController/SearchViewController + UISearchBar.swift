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
        currentSearchTask?.cancel()
        currentSearchTask = TrefleAPiClient.searchForPlant(searchText, completionHandler: searchPlantResultHandler(response:error:))
    }
    
    func searchPlantResultHandler(response: PlantsSearchResponse?, error: Error?){
        if error != nil {
            if let response = response{
                self.plantsSearchResult = response
                print(response)
                self.tableView.reloadData()
            }
        } 
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        print("searchBarCancelButtonClicked")
    }
}
