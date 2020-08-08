//
//  BaseController.swift
//  DotaHeroesParse
//
//  Created by Олег on 07.08.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import UIKit

//It's a base controller, you can add function for use on all screens
class BaseController: UIViewController {

}

//MARK: Alert
extension BaseController {
    func showAlert(title: String?, message: String?, buttonName: String?, action: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: buttonName ?? "Хорошо", style: .default, handler: { tap in
                action()
                alert.dismiss(animated: true) {
                    //Add if need completion
                }
            })
            
            alert.addAction(okAction)
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
}
