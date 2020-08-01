//
//  TopPlayerCollectionViewCell.swift
//  DotaHeroesParse
//
//  Created by Олег on 20.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import UIKit

protocol TopPlayerCellDelegate {
    func getPlayerImage(by id: Int64?, completionHandler: @escaping (_ image: UIImage?) -> Void)
}

class TopPlayerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var playerAvatarImage: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    
    var delegate: TopPlayerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func setupCell(with player: Player?) {
        guard let player = player else { return }
        
        self.playerNameLabel.text = player.personaname ?? "Ник игрока"
        
        self.showLoadHUD(show: true)
        self.playerAvatarImage.isHidden = true
        self.delegate?.getPlayerImage(by: player.account_id ?? 0, completionHandler: { (image) in
            DispatchQueue.main.async {
                self.playerAvatarImage.image = image
                self.playerAvatarImage.isHidden = false
                self.showLoadHUD(show: false)
            }
        })
    }
    
    func showLoadHUD(show: Bool) {
        self.loaderIndicator.isHidden = !show
        if show {
            self.loaderIndicator.startAnimating()
        } else {
            self.loaderIndicator.stopAnimating()
        }
        
    }
}
