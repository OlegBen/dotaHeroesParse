//
//  ViewController.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import UIKit

class MainScreenViewController: BaseController {
    //TableView
    @IBOutlet weak var tableView: UITableView!
    //Views
    @IBOutlet weak var loadHUDView: UIView!
    //ActivityIndicator
    @IBOutlet weak var loadHUDIndicator: UIActivityIndicatorView!
    
    var viewModel = MainScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set screen title
        self.title = "Герои"
        
        //Start setup
        self.setupTableView()
        self.setupObservers()
        
        //Get heroes list
        self.viewModel.getHeroes()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setupObservers() {
        //Send true if need reload table
        self.viewModel.needToReloadTable.observeNext { [weak self] (reload) in
            if reload {
                self?.tableView.reloadData()
            }
        }.dispose(in: self.reactive.bag)
        
        //HUD observer
        self.viewModel.showHUD.observeNext { [weak self] (show) in
            self?.showHUD(load: show)
        }.dispose(in: self.reactive.bag)
        
        //Error observer
        self.viewModel.errorMessage.observeNext { [weak self] (errorMessage) in
            if !errorMessage.isEmpty {
                self?.showAlert(title: "Ошибка", message: errorMessage, buttonName: "Хорошо") {
                    //Add if need completion
                }
            }
        }.dispose(in: self.reactive.bag)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.heroes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = self.viewModel.heroes?[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HeroTableViewCell") as! HeroTableViewCell
        cell.setupCell(with: cellData)
        
        if let icon = self.viewModel.heroesIcons[cellData?.id ?? 0] {
            cell.setHeroIcon(icon: icon)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHero = self.viewModel.heroes?[indexPath.row]
        
        let heroDetailsVC = storyboard?.instantiateViewController(withIdentifier: "HeroDetailsViewController") as! HeroDetailsViewController
        heroDetailsVC.viewModel.selectedHero = selectedHero
        self.navigationController?.pushViewController(heroDetailsVC, animated: true)
    }
}

//MARK: HUD methods

extension MainScreenViewController {
    func showHUD(load: Bool) {
        DispatchQueue.main.async {
            self.loadHUDView.isHidden = !load
            self.loadHUDIndicator.isHidden = !load
            
            if load {
                self.loadHUDIndicator.startAnimating()
            } else {
                self.loadHUDIndicator.stopAnimating()
            }
        }
    }
}
