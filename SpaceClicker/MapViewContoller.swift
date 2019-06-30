//
//  MapViewContoller.swift
//  SpaceClicker
//
//  Created by Andy Humphries on 6/14/19.
//  Copyright © 2019 iMacAndrew. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MapViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)

        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white

        view.backgroundColor = .black

        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        tabBar.tintColor = .white
    }
}
