//
//  TopPlayersViewController.swift
//  DotaHeroesParse
//
//  Created by Олег on 20.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import UIKit

class TopPlayersViewController: UIViewController {
    //CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = TopPlayersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        
        self.viewModel.getTopPlayers { (players, error) in
            if let error = error {
                DispatchQueue.main.async {
                    let errorAlert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Хорошо", style: .default) { (action) in
                        errorAlert.dismiss(animated: true, completion: nil)
                    }
                    
                    errorAlert.addAction(okAction)
                    self.navigationController?.present(errorAlert, animated: true, completion: nil)
                }
            } else if let players = players {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewFlowLayout

extension TopPlayersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.view.frame.size.width / 2) - 4
        let cellHeight = cellWidth
        let size = CGSize(width: cellWidth, height: cellHeight)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = self.viewModel.players[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopPlayerCollectionViewCell", for: indexPath) as! TopPlayerCollectionViewCell
        cell.delegate = self
        cell.setupCell(with: cellData)
        return cell
    }
}

//MARK: TopPlayerCellDelegate

extension TopPlayersViewController: TopPlayerCellDelegate {
    func getPlayerImage(by id: Int64?, completionHandler: @escaping (_ image: UIImage?) -> Void) {
        self.viewModel.getPlayerImage(playerId: id) { (image) in
            completionHandler(image)
        }
    }
}
