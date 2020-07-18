//
//  MainScreenViewModel.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation
import UIKit

class MainScreenViewModel {
    var dispatchGroup = DispatchGroup()
    var heroes: [Hero]?
    var heroesIcons: [Int: UIImage?] = [:]
    
    func getHeroes(completionHandler: @escaping (_ heroes: [Hero]?, _ error: Error?) -> Void) {
        let getHeroURL = APIConstants.baseAPIURL + APIConstants.getHeroesURL
        
        guard let url = URL(string: getHeroURL) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                do {
                    let heroes = try JSONDecoder().decode([Hero].self, from: data)
                    self.heroes = heroes
                    
                    heroes.forEach { (hero) in
                        self.getIconFor(hero: hero)
                    }
                    
                    self.dispatchGroup.notify(queue: .main) {
                        completionHandler(heroes, nil)
                    }
                } catch let error {
                    completionHandler(nil, error)
                }
            }
        }.resume()
        
    }
    
    func getIconFor(hero: Hero?) {
        guard let hero = hero, let heroIconURL = hero.icon, let url = URL(string: APIConstants.baseURL + heroIconURL) else { return }
        
        let session = URLSession.shared
        self.dispatchGroup.enter()
        session.dataTask(with: url) { (data, response, error) in
            self.dispatchGroup.leave()
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let image = UIImage(data: data)
                self.heroesIcons[hero.id ?? 0] = image
            }
        }.resume()
    }
}
