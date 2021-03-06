//
//  TrefleAPiClient.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 30.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

class TrefleAPiClient {
    
    //Get apiKey from our FirebaseFMP Singleton instance
    static let apiKey = FirebaseFMP.shared.TrefleAPIKey
    //Setup my NSCache for images
    static let imageCache = NSCache<NSString, UIImage>()
    
    //Endpoints list for Trefle API
    enum Endpoints{
        
        //URL Search Format =  https://trefle.io/api/v1/plants/search?token=YOUR_TREFLE_TOKEN&q=PLANT
        //URL Distributions = https://trefle.io/api/v1/distributions/ZONE/plants?token=YOUR_TREFLE_TOKEN
        //URL Paging = https://trefle.io/api/v1/plants?page=2&token=YOUR_TREFLE_TOKEN
        //URL All Plants = https://trefle.io/api/v1/plants?token=YOUR_TREFLE_TOKEN
        //URL All Edible Plants = "https://trefle.io/api/v1/plants?&filter_not%5Bedible_part%5D=null&token=YOUR_TREFLE_TOKEN"
        //URL Edible Plants by Page = "https://trefle.io/api/v1/plants?page=1&filter_not%5Bedible_part%5D=null&token=YOUR_TREFLE_TOKEN"
        //URL Plant by ID = "https://trefle.io/api/v1/plants/ID_OF_PLANT?token=YOUR_TREFLE_TOKEN"
        
        //Main path for API
        static let baseURL = "https://trefle.io/api/v1/"
        //Trefle TokenAPIKey Path
        static let myToken = "token=" + TrefleAPiClient.apiKey
        //Plants path
        static let plantPath = "plants/"
        //Argument for plant name
        static let plantParam = "&q="
        //Argument for searching
        static let search = "search?"
        //Argument for retrieving a plant
        static let allPlants = "plants?"
        //Argument to specify a page to load
        static let page = "page="
        //Argument to filter by edible plants only
        static let filterEdible = "&filter_not%5Bedible_part%5D=null&"
        
        case searchForPlant(name: String)
        case randomAllPlantsPage(plantsPage: Int)
        case getAllPlants
        case getAllEdiblePlants
        case getRandomeEdiblePlants(plantsPage: Int)
        case getPlantByID(id: Int)
        
        var stringURL: String {
            switch self {
            case var .searchForPlant(name):
                name = name.lowercased()
                name = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                return Endpoints.baseURL + Endpoints.plantPath + Endpoints.search + Endpoints.myToken + Endpoints.plantParam + "\(name)"
            case let .randomAllPlantsPage(plantsPage):
                return Endpoints.baseURL + Endpoints.allPlants + Endpoints.page + String(plantsPage) + "&" + Endpoints.myToken
            case .getAllPlants:
                return Endpoints.baseURL + Endpoints.allPlants + Endpoints.myToken
            case .getAllEdiblePlants:
                return Endpoints.baseURL + Endpoints.allPlants + Endpoints.filterEdible + Endpoints.myToken
            case let .getRandomeEdiblePlants(plantsPage):
                return Endpoints.baseURL + Endpoints.allPlants + Endpoints.page + String(plantsPage) + Endpoints.filterEdible + Endpoints.myToken
            case let .getPlantByID(id):
                return Endpoints.baseURL + Endpoints.plantPath + String(id) + "?" + Endpoints.myToken
            }
        }
        //Returns the URL from the a URL in string type
        var url: URL {
            return URL(string: stringURL)!
        }
    }
    //Plant type to specify which request to send in HomeVC with segmented control
    enum PlantType{
        case all
        case onlyEdible
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
        _ = sendGETRequest(url: Endpoints.randomAllPlantsPage(plantsPage: page).url, response: PlantsSearchResponse.self) { (response, error) in
            if let response = response {
                completionHandler(response.data, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    //MARK: - getRandomEdiblePlants: Requests 20 edible plants randomly from the total of pagaes available
    class func getRandomEdiblePlants(fromPage page: Int, completionHandler: @escaping ([PlantInfo]?, Error?) -> Void) {
        _ = sendGETRequest(url: Endpoints.getRandomeEdiblePlants(plantsPage: page).url, response: PlantsSearchResponse.self) { (response, error) in
            if let response = response {
                completionHandler(response.data, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    //MARK: - getTotalPlantsPages: Requests the max number of pages for the "All Plants" query from the API
    class func getTotalPlantsPages(by type: PlantType,completionHandler: @escaping (Int, Error?) -> Void){
        
        let url: URL!
        
        switch type{
        case .all:
            url = Endpoints.getAllPlants.url
        case .onlyEdible:
            url = Endpoints.getAllEdiblePlants.url
        }
        
        _ = sendGETRequest(url: url, response: PlantsSearchResponse.self) { (response, error) in
            if let response = response {
                let link = response.links.last
                let range = NSRange(location: 0, length: link.utf16.count)
                let regex = try? NSRegularExpression(pattern: "page=?(.*)")
                if let match = regex?.firstMatch(in: link, options: [], range: range) {
                    if let matchRange = Range(match.range(at: 1), in: link) {
                        let totalPages = link[matchRange]
                        completionHandler(Int(totalPages) ?? 0, nil)
                    }
                } else {
                    //If response is ok but nothing matched, then something was wrong with server side
                    completionHandler(0, error)
                }
            }else {
                completionHandler(0, error)
            }
        }
    }
    
    //MARK: - getPlantsByID: Get the info from the plants requested by ID number
    class func getPlantsByID(_ ids:[Int], completionHandler: @escaping ([PlantInfo], Error?) -> Void) {
        
        var plantsInfo: [PlantInfo] = []
        
        for id in ids {
            _ = sendGETRequest(url: Endpoints.getPlantByID(id: id).url, response: PlantByIDResponse.self, completionHandler: { (response, error) in
                guard let response = response else {
                    completionHandler([], error)
                    return
                }
                plantsInfo.append(response.data.mainSpecies)
                completionHandler(plantsInfo, nil)
            })
        }
    }
    
    //MARK: - downloadImage: Downloads the image from the server into our device or load from Cache
    class func downloadImage(imageURL: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) -> URLSessionTask?{
                
        //If image exists in cache the return it, if not download from server and then save to cache
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            completionHandler(cachedImage, nil)
            return nil
        } else {
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                return
                }
                guard let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                    return
                }
                
                self.imageCache.setObject(image, forKey: imageURL.absoluteString as NSString)

                DispatchQueue.main.async {
                    completionHandler(image,nil)
                }
            }
            task.resume()
            return task
        }
    }
}
