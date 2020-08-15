//
//  TrefleAPiClient.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 30.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import Foundation

class TrefleAPiClient {
    
    static let apiKey = "U8Aaxsf22v1B7wPWnjhafMj6WddhXzb1WkdNJYjz7rM"
    
    enum Endpoints{
        
        //URL Search Format =  https://trefle.io/api/v1/plants/search?token=YOUR_TREFLE_TOKEN&q=PLANT
        //URL Distributions = https://trefle.io/api/v1/distributions/ZONE/plants?token=YOUR_TREFLE_TOKEN
        //URL Paging = https://trefle.io/api/v1/plants?page=2&token=YOUR_TREFLE_TOKEN
        //URL All Plants = https://trefle.io/api/v1/plants?token=YOUR_TREFLE_TOKEN
        
        static let baseURL = "https://trefle.io/api/v1/"
        static let myToken = "token=" + TrefleAPiClient.apiKey
        static let plantPath = "plants/"
        static let plantParam = "&q="
        static let search = "search?"
        static let allPlants = "plants?"
        static let page = "page="
        
        case searchForPlant(name: String)
        case randomPage(plantsPage: Int)
        case getAllPlants
        
        var stringURL: String {
            switch self {
            case var .searchForPlant(name):
                name = name.lowercased()
                name = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                return Endpoints.baseURL + Endpoints.plantPath + Endpoints.search + Endpoints.myToken + Endpoints.plantParam + "\(name)"
            case let .randomPage(plantsPage):
                return Endpoints.baseURL + Endpoints.allPlants + Endpoints.page + String(plantsPage) + "&" + Endpoints.myToken
            case .getAllPlants:
                return Endpoints.baseURL + Endpoints.allPlants + Endpoints.myToken
            }
        }
        var url: URL {
            return URL(string: stringURL)!
        }
    }
    
    //MARK: - sendGETRequest: Send GET Request of Generic Type
    class func sendGETRequest<ResponseType:Decodable>(url: URL, response: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
                
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(response, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    //MARK: - searchPlant: Send request to search specified plant in Trefle.io servers
    class func searchForPlant(_ name: String, completionHandler: @escaping (PlantsSearchResponse?,Error?)-> Void) -> URLSessionTask{
        let task = sendGETRequest(url: Endpoints.searchForPlant(name: name).url, response: PlantsSearchResponse.self) { (response, error) in
            if let response = response {
                completionHandler(response, nil)
            }else{
                completionHandler(nil, error)
            }
        }
        return task
    }
    
    //MARK: - getRandomPlants: Requests 20 plants randomly from the total of pagaes available
    class func getRandomPlants(fromPage page: Int, completionHandler: @escaping ([PlantInfo]?, Error?) -> Void) {
        _ = sendGETRequest(url: Endpoints.randomPage(plantsPage: page).url, response: PlantsSearchResponse.self) { (response, error) in
            if let response = response {
                completionHandler(response.data, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    //MARK: - getTotalPlantsPages: Requests the max number of pages for the "All Plants" query from the API
    class func getTotalPlantsPages(completionHandler: @escaping (Int, Error?) -> Void){
        _ = sendGETRequest(url: Endpoints.getAllPlants.url, response: PlantsSearchResponse.self) { (response, error) in
            if let response = response {
                let link = response.links.last
                let pageArray = link.components(separatedBy: "=")
                let totalPages = Int(pageArray.last ?? "0")
                completionHandler(totalPages ?? 0, nil)
            }else {
                completionHandler(0, error)
            }
        }
    }
    
    //MARK: - downloadImage: Downloads the image from the server into our device
    public class func downloadImage(imageURL: URL, completionHandler: @escaping (Data?, Error?) -> Void ){
                  
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            return
            }
            DispatchQueue.main.async {
                completionHandler(data,nil)
            }
        }
        task.resume()
    }
    
}
