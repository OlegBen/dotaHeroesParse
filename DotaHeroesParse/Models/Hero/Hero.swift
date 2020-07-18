//
//  Hero.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation

struct Hero: Decodable {
    var id: Int?
    var name: String?
    var localized_name: String?
    var roles: [String]?
    var img: String?
    var icon: String?
    var base_health: Int?
    var base_attack_min: Int?
}
