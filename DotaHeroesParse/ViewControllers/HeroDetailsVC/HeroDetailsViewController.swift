//
//  HeroDetailsViewController.swift
//  DotaHeroesParse
//
//  Created by Олег on 18.07.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import UIKit
import UserNotifications

class HeroDetailsViewController: UIViewController {
    //ImageView
    @IBOutlet weak var heroImage: UIImageView!
    //Label
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroHealthLabel: UILabel!
    //ActivityIndicator
    @IBOutlet weak var loadHUDIndicator: UIActivityIndicatorView!
    //ProgressView
    @IBOutlet weak var heroHealthProgress: UIProgressView!
    //TableView
    @IBOutlet weak var tableView: UITableView!
    
    let localNotification = UNUserNotificationCenter.current()
    var viewModel = HeroDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupImage()
        self.setupLabels()
        self.setupProgress()
        self.setupTable()
    }
    
    func sendNotification() {
        guard let hero = self.viewModel.selectedHero, let name = hero.localized_name else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Успешно выполнено"
        content.body = "Вы успешно получили информацию о \(name)"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "SuccessGetHeroInfo", content: content, trigger: trigger)
            
        self.localNotification.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setupImage() {
        self.showHUD(load: true)
        self.viewModel.getHeroImage { (image, error) in
            self.showHUD(load: false)
            if let error = error {
                DispatchQueue.main.async {
                    let errorAlert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Хорошо", style: .default, handler: { tap in
                        errorAlert.dismiss(animated: true, completion: nil)
                    })
                    
                    errorAlert.addAction(okAction)
                    self.navigationController?.present(errorAlert, animated: true, completion: nil)
                }
            } else if let image = image {
                DispatchQueue.main.async {
                    self.heroImage.image = image
                    
                    //Send push about success get hero info
                    self.sendNotification()
                }
            }
        }
    }
    
    func setupLabels() {
        self.heroName.text = self.viewModel.selectedHero?.localized_name
        
        if let hero = self.viewModel.selectedHero, let health = hero.base_health, let attack = hero.base_attack_min {
            //Formula for get hero health
            let heroHealth = health + (attack * 18)
            self.heroHealthLabel.text = "Здоровье: \(heroHealth)"
        }
    }
    
    func setupProgress() {
        guard let hero = self.viewModel.selectedHero, let health = hero.base_health else { return }
        let maxHealth = 2000
        let heroHealth = health + ((hero.base_attack_min ?? 0) * 18)
        self.heroHealthProgress.progress = Float(heroHealth) / Float(maxHealth)
    }
    
    func setupTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
}

//MARK: HUD methods

extension HeroDetailsViewController {
    func showHUD(load: Bool) {
        DispatchQueue.main.async {
            self.loadHUDIndicator.isHidden = !load
            
            if load {
                self.loadHUDIndicator.startAnimating()
            } else {
                self.loadHUDIndicator.stopAnimating()
            }
        }
    }
}

//MARK:

extension HeroDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.selectedHero?.roles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = self.viewModel.selectedHero?.roles?[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "HeroRole")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "HeroRole")
        }
        cell?.selectionStyle = .none
        cell?.textLabel?.text = cellData
        return cell ?? UITableViewCell()
    }
}
