//
//  HeroDetailsViewModel.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import Foundation
import UIKit

class HeroDetailsViewModel {
    var selectedHero: Hero?
    
    func getHeroImage(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        guard let hero = self.selectedHero, let imageLink = hero.img, let url = URL(string: APIConstants.baseURL + imageLink) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                let image = UIImage(data: data)
                completionHandler(image, nil)
            }
        }.resume()
    }
}
