//
//  NetworkManager.swift
//  DotaHeroesParse
//
//  Created by Олег on 03.08.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case badRequest = "Bad request"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "Unable to decode response"
    case authenticationError = "Authorization error"
}

enum Result<String> {
    case success
    case failure(String)
}

fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
    switch response.statusCode {
    case 200...299: return .success
    case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
    case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
    default: return .failure(NetworkResponse.failed.rawValue)
    }
}


struct NetworkManager {
    static let shared = NetworkManager()
    
    let router = Router<HeroesAPI>()
}

//MARK: HeroesAPI requests

extension NetworkManager {
    func getHeroes(completion: @escaping (_ heroes: [Hero]?, _ error: String?) -> ()) {
        self.router.request(.getHeroes) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode([Hero].self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                    
                case .failure(let errorMessage):
                    completion(nil, errorMessage)
                }
            }
        }
    }
    
    func getHeroIcon(url: String, completion: @escaping (_ iconData: Data?, _ error: String?) -> ()) {
        self.router.request(.getHeroIcon(url: url)) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                
                switch result {
                case .success:
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func getHeroImage(url: String, completion: @escaping (_ imageData: Data?, _ error: String?) -> ()) {
        self.router.request(.getHeroImage(url: url)) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                
                switch result {
                case .success:
                    completion(data, nil)
                case .failure(let error):
                    completion(data, error)
                }
            }
        }
    }
    
    func getHeroPlayers(id: String, completion: @escaping (_ players: TopPlayersContainer?, _ error: String?) -> ()) {
        self.router.request(.getHeroPlayers(id: id)) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode(TopPlayersContainer.self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
                
            }
        }
    }
}

