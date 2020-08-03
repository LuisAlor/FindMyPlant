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
        
        static let baseURL = "https://trefle.io/api/v1/"
        static let myToken = "token=" + TrefleAPiClient.apiKey
        static let plantPath = "plants/"
        static let plantParam = "&q="
        static let search = "search?"
        
        case searchForPlant(name: String)
        
        var stringURL: String {
            switch self {
            case var .searchForPlant(name):
                name = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                return Endpoints.baseURL + Endpoints.plantPath + Endpoints.search + Endpoints.myToken + Endpoints.plantParam + "\(name)"
            }
        }
        var url: URL {
            return URL(string: stringURL)!
        }
    }
    
    //MARK: - sendGETRequest: Send GET Request of Generic Type
    class func sendGETRequest<ResponseType:Decodable>(url: URL, response: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        
        print(url)
        
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
                    print(response)
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
    
}
