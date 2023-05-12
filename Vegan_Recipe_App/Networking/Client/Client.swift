//
//  Client.swift
//  Vegan_Recipe_App
//
//  Created by Jandrè Hattingh on 2022/08/16.
//

import Foundation
import UIKit
import Combine

protocol NetworkingProtocol {
    var response: Recipes? { get set }
    var error: Error? { get set }
}

//enum genericResponse<T> {
//    case responseWithError(Error)
//    case response(T)
//}

class Client: NetworkingProtocol {
    var updatedError: Published<Error?>.Publisher { $error }
    var updatedResponce: Published<Recipes?>.Publisher { $response }
    var updatedImage: Published<UIImage?>.Publisher { $image }
    @Published var response: Recipes?
    @Published var error: Error?
    @Published var image: UIImage?
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func getRandomRecipe() {
        var completeURL = URLComponents(string: "https://api.spoonacular.com/recipes/random")
        completeURL!.queryItems = [
            URLQueryItem(name: "limitLicense", value: String(true)),
            URLQueryItem(name: "tags", value: "vegan"),
            URLQueryItem(name: "number", value: String(1)),
            URLQueryItem(name: "apiKey", value: "ed08370260914c8b88f54e1d719b696a")
        ]

        Client.taskForGETRequest(url: completeURL!.url!, responseType: Recipes.self, completion: { response, error in
            if let response = response {
                self.response = response
                self.error = nil
            } else {
                self.response = nil
                self.error = error
            }
        })
    }
    
    func getImage(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
                
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
