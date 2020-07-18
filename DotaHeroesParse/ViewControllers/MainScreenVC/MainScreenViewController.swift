//
//  ViewController.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    //TableView
    @IBOutlet weak var tableView: UITableView!
    //Views
    @IBOutlet weak var loadHUDView: UIView!
    //ActivityIndicator
    @IBOutlet weak var loadHUDIndicator: UIActivityIndicatorView!
    
    var viewModel = MainScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Герои"
        self.setupTableView()
        self.getHeroes()
    }
    
    func getHeroes() {
        self.showHUD(load: true)
        self.viewModel.getHeroes { [weak self] (heroes, error) in
            self?.showHUD(load: false)
            if let error = error {
                DispatchQueue.main.async {
                    let errorAlert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Хорошо", style: .default, handler: { tap in
                        errorAlert.dismiss(animated: true, completion: nil)
                    })
                    
                    errorAlert.addAction(okAction)
                    self?.navigationController?.present(errorAlert, animated: true, completion: nil)
                }
            } else if let heroes = heroes {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
