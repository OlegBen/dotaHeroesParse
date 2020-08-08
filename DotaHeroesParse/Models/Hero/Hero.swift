//
//  Hero.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation

struct Hero {
    var id: Int?
    var name: String?
    var localized_name: String?
    var roles: [String]?
    var img: String?
    var icon: String?
    var base_health: Int?
    var base_attack_min: Int?
}

extension Hero: Decodable {
    private enum HeroCodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case localized_name = "localized_name"
        case roles = "roles"
        case img = "img"
        case icon = "icon"
        case base_health = "base_health"
        case base_attack_min = "base_attack_min"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HeroCodingKeys.self)
        
        self.id = try? container.decode(Int.self, forKey: .id)
        self.name = try? container.decode(String.self, forKey: .name)
        self.localized_name = try? container.decode(String.self, forKey: .localized_name)
        self.roles = try? container.decode([String].self, forKey: .roles)
        self.img = try? container.decode(String.self, forKey: .img)
        self.icon = try? container.decode(String.self, forKey: .icon)
        self.base_health = try? container.decode(Int.self, forKey: .base_health)
        self.base_attack_min = try? container.decode(Int.self, forKey: .base_attack_min)
    }
}
