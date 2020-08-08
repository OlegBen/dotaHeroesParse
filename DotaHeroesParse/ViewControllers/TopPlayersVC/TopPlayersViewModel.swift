//
//  TopPlayersViewModel.swift
//  DotaHeroesParse
//
//  Created by Олег on 20.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation
import UIKit
import Bond
import ReactiveKit

class TopPlayersViewModel: BaseViewModel {
    var selectedHeroId: Int?
    var players: [Player] = []
    var playersImage: [Int64: UIImage?] = [:]
    var needToReloadCollection = Observable<Bool>(false)
    
    func getTopPlayers() {
        guard let heroId = self.selectedHeroId else { return }
        
        self.showHUD.send(true)
        self.players.removeAll()
        
        NetworkManager.shared.getHeroPlayers(id: String(heroId)) { (topPlayers, errorMessage) in
            if let error = errorMessage {
                self.showHUD.send(false)
                self.errorMessage.send(error)
            }
            
            if let playersContainer = topPlayers, let players = playersContainer.rankings {
                self.showHUD.send(false)
                self.players.insert(contentsOf: players, at: 0)
            }
            
            self.needToReloadCollection.send(true)
        }
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
