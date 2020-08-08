//
//  TopPlayersViewController.swift
//  DotaHeroesParse
//
//  Created by Олег on 20.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import UIKit

class TopPlayersViewController: BaseController {
    //CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = TopPlayersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start setup
        self.setupCollectionView()
        self.setupObservers()
        
        //Get hero players
        self.viewModel.getTopPlayers()
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setupObservers() {
        //Reload collection observe
        self.viewModel.needToReloadCollection.observeNext { [weak self] (reload) in
            if reload {
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }.dispose(in: self.reactive.bag)
        
        //Error observe
        self.viewModel.errorMessage.observeNext { [weak self] (errorMessage) in
            if !errorMessage.isEmpty {
                self?.showAlert(title: "Ошибка", message: errorMessage, buttonName: "Хорошо") {
                    //Add if need action
                }
            }
        }.dispose(in: self.reactive.bag)
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
