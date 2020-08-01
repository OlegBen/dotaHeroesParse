//
//  TopPlayersViewModel.swift
//  DotaHeroesParse
//
//  Created by Олег on 20.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation
import UIKit

class TopPlayersViewModel {
    var selectedHeroId: Int?
    var players: [Player] = []
    var playersImage: [Int64: UIImage?] = [:]
    
    func getTopPlayers(completionHandler: @escaping (_ players: [Player]?, _ error: Error?) -> Void) {
        guard let heroId = self.selectedHeroId else { return }
        let linkWithHeroId = APIConstants.getHeroTopPlayers + String(heroId)
        let fullLink = APIConstants.baseAPIURL + linkWithHeroId
        
        guard let url = URL(string: fullLink) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                do {
                    let playersContainer = try JSONDecoder().decode(TopPlayersContainer.self, from: data)
                    if let players = playersContainer.rankings {
                        self.players = players
                        completionHandler(players, nil)
                    } else {
                        return
                    }
                } catch let error {
                    completionHandler(nil, error)
                }
            }
        }.resume()
    }
    
    func getPlayerImage(playerId: Int64?, completionHandler: @escaping (_ avatar: UIImage?) -> Void) {
        guard let id = playerId, let player = self.players.filter({ $0.account_id == id }).first, let avatarLink = player.avatar, let url = URL(string: avatarLink) else { return }
        
        if let image = self.playersImage[id] {
            completionHandler(image)
        } else {
            let session = URLSession.shared
            
            session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    self.playersImage[id] = image
                    completionHandler(image)
                }
            }.resume()
        }
    }
}
