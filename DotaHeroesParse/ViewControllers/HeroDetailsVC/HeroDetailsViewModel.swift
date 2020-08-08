//
//  HeroDetailsViewModel.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation
import UIKit
import Bond
import ReactiveKit

class HeroDetailsViewModel: BaseViewModel {
    var selectedHero: Hero?
    var imageData: Data?
    
    func getHeroImage(completionHandler: @escaping () -> Void) {
        guard let hero = self.selectedHero, let imageLink = hero.img?.replacingOccurrences(of: "?", with: "") else { return }
        
        self.showHUD.send(true)
        
        NetworkManager.shared.getHeroImage(url: imageLink) { (data, error) in
            if let data = data {
                self.imageData = data
                self.showHUD.send(false)
                completionHandler()
            } else if let error = error {
                self.errorMessage.send(error)
                self.showHUD.send(false)
                completionHandler()
            }
        }
    }
}
