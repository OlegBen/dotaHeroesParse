//
//  NetworkRouter.swift
//  DotaHeroesParse
//
//  Created by Олег on 03.08.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation

public typealias NetworkRouterComplition = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, _ completion: @escaping NetworkRouterComplition)
    func cancel()
}
