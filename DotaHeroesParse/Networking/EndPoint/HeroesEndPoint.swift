//
//  HeroesEndPoint.swift
//  DotaHeroesParse
//
//  Created by Олег on 03.08.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation

enum NetworkEnviroment {
    case api
    case base
}

public enum HeroesAPI {
    case getHeroes
    case getHeroIcon(url: String)
    case getHeroImage(url: String)
    case getHeroPlayers(id: String)
}

extension HeroesAPI: EndPointType {
    
    var enviromentBaseURL: String {
        switch self.environment {
        case .api: return APIConstants.baseAPIURL
        case .base: return APIConstants.baseURL
        }
    }
    
    var environment: NetworkEnviroment {
        switch self {
        case .getHeroes, .getHeroPlayers:
            return .api
        case .getHeroIcon, .getHeroImage:
            return .base
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: enviromentBaseURL) else { fatalError(NetworkError.missingURL.rawValue) }
        return url
    }
    
    var path: String {
        switch self {
        case .getHeroes:
            return APIConstants.getHeroesURL
        case .getHeroIcon(let url):
            return url
        case .getHeroImage(let url):
            return url
        case .getHeroPlayers:
            return APIConstants.getHeroTopPlayers
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .getHeroes, .getHeroIcon, .getHeroImage:
            return .request
        case .getHeroPlayers(let id):
            let params: Parameters = [
                "hero_id": id
            ]
            return .requestWithParameters(bodyParameters: nil, urlParameters: params)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
