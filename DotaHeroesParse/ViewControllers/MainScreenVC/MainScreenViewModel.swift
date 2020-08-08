//
//  MainScreenViewModel.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation
import UIKit
import Bond
import ReactiveKit

class MainScreenViewModel: BaseViewModel {
    //Dispatch group
    var dispatchGroup = DispatchGroup()
    
    //Heroes info
    var heroes: [Hero]?
    var heroesIcons: [Int: UIImage?] = [:]
    
    //Observable variables
    var needToReloadTable = Observable<Bool>(false)
    
    func getHeroes() {
        self.showHUD.send(true)
        
        NetworkManager.shared.getHeroes { (heroes, errorMessage) in
            if let heroes = heroes {
                self.heroes = heroes

                heroes.forEach { (hero) in
                    self.getIconFor(hero: hero)
                }

                self.dispatchGroup.notify(queue: .main) {
                    self.showHUD.send(false)
                    self.needToReloadTable.send(true)
                }
            }
            
            if let errorMessage = errorMessage {
                self.errorMessage.send(errorMessage)
            }
        }
    }
    
    func getIconFor(hero: Hero?) {
        guard let hero = hero, let heroIconURL = hero.icon else { return }
        self.dispatchGroup.enter()
        
        NetworkManager.shared.getHeroIcon(url: heroIconURL) { (data, error) in
            self.dispatchGroup.leave()
            
            if let data = data {
                let image = UIImage(data: data)
                self.heroesIcons[hero.id ?? 0] = image
            }
        }
    }
}
