//
//  Player.swift
//  DotaHeroesParse
//
//  Created by Олег on 20.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation

struct TopPlayersContainer {
    var hero_id: Int?
    var rankings: [Player]?
}

extension TopPlayersContainer: Decodable {
    private enum ContainerCodingKeys: String, CodingKey {
        case hero_id = "hero_id"
        case rankings = "rankings"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContainerCodingKeys.self)
        
        self.hero_id = try? container.decode(Int.self, forKey: .hero_id)
        self.rankings = try? container.decode([Player].self, forKey: .rankings)
    }
}


struct Player {
    var account_id: Int64?
    var avatar: String?
    var personaname: String?
    var profileurl: String?
}

extension Player: Decodable {
    private enum PlayerCodingKeys: String, CodingKey {
        case account_id = "account_id"
        case avatar = "avatar"
        case personaname = "personaname"
        case profileurl = "profileurl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PlayerCodingKeys.self)
        
        self.account_id = try? container.decode(Int64.self, forKey: .account_id)
        self.avatar = try? container.decode(String.self, forKey: .avatar)
        self.personaname = try? container.decode(String.self, forKey: .personaname)
        self.profileurl = try? container.decode(String.self, forKey: .profileurl)
    }
}

