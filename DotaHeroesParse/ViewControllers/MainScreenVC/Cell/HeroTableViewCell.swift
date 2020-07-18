//
//  HeroTableViewCell.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import UIKit

class HeroTableViewCell: UITableViewCell {
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with hero: Hero?) {
        guard let hero = hero else { return }
        
        self.heroName.text = hero.localized_name ?? "Hero name"
    }

    func setHeroIcon(icon: UIImage?) {
        self.heroImage.image = icon
    }
}
