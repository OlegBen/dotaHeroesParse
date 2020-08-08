//
//  EndPointType.swift
//  DotaHeroesParse
//
//  Created by Олег on 03.08.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var environment: NetworkEnviroment { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
