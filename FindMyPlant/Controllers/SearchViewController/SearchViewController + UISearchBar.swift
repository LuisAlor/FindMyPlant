//
//  SearchViewController + UISearchBar.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 03.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    //MARK: - searchBar: If textDidChange verifies if should load data or reset it to default.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Check if the text is empty (remove whitespaces and Newlines) or something has been added and process the corresponding actions
        processSearchText(text: searchText.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    fileprivate func processSearchText(text: String){
        
        //Hide the table always before processing data
        tableView.isHidden = true
        //Cancel all sessions for not showing old data that wasn't yet retrieved
        cancelAllSessionTasks()
        
        if text.isEmpty {
            //Clear all data from plantsSearchResult
            plantsSearchResult = nil
            //Remove all images from cache data to not accumulate and not used
            TrefleAPiClient.imageCache.removeAllObjects()
            
            //Reveal status label and show "Type in the search bar to start"
            statusSearchLabel.isHidden = false
            statusSearchLabel.text = Constants.LabelTextStatus.noSearchDone.message
            
            //Stop animating the acitivity indicator
            activityViewIndicator.stopAnimating()
        } else {
            //Something was found in searchText, hide the statusSearchLabel, and start animating activityViewIndicator
            statusSearchLabel.isHidden = true
            activityViewIndicator.startAnimating()
            //Save current task in order to be able to cancel and process the request
            currentSearchTask = TrefleAPiClient.searchForPlant(text, completionHandler: searchPlantResultHandler(response:error:))
        }
    }
    
    //MARK: - cancelAllSessionTasks: Cancels every single current task
    fileprivate func cancelAllSessionTasks(){
        currentSearchTask?.cancel()
        for task in downloadImgURLSessionTasks{
            task.cancel()
        }
    }
    
    //MARK: - searchPlantResultHandler: Handles Trefle response with plants data
    func searchPlantResultHandler(response: PlantsSearchResponse?, error: Error?){
        
        if let response =  response {
            //Stop animating the activityViewIndicator as the request already finished and response is not nil
            activityViewIndicator.stopAnimating()
            //If the data is 0, then nothing was found
            if response.data.count == 0{
                //Reveal statusSearchLabel
                statusSearchLabel.isHidden = false
                //Set statusSearchLabel to "No Results Found"
                statusSearchLabel.text = Constants.LabelTextStatus.noSearchResults.message
                
            } else {
                //If something was found then save the data to plantsSearchResult property
                plantsSearchResult = response
                //Refresh the tableView to show the new data
                tableView.reloadData()
                //Reveal the hidden tableView
                tableView.isHidden = false
            }
        }
    }
    
    //MARK: - searchBarTextDidBeginEditing: Enables the cancel button when editing begins
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    //MARK: - searchBarTextDidEndEditing: Hide cancel button when editing finishes
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    //MARK: - searchBarCancelButtonClicked: Cancels editing if cancel button was pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    //MARK: - searchBarSearchButtonClicked: Resigns first responder when search button is pressed by dismissing the keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
