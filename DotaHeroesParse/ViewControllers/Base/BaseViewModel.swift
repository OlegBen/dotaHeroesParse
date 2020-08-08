//
//  BaseViewModel.swift
//  DotaHeroesParse
//
//  Created by Олег on 07.08.2020.
//  Copyright © 2020 Oleg Ben. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

//It's a base viewModel
class BaseViewModel: NSObject {
    var showHUD = Observable<Bool>(false)
    var errorMessage = Observable<String>("")
}
