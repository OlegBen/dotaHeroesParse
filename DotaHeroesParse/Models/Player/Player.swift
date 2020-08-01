//
//  Player.swift
//  DotaHeroesParse
//
//  Created by Олег on 20.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation

struct TopPlayersContainer: Decodable {
    var hero_id: Int?
    var rankings: [Player]?
}

struct Player: Decodable {
    var account_id: Int64?
    var avatar: String?
    var personaname: String?
    var profileurl: String?
}
