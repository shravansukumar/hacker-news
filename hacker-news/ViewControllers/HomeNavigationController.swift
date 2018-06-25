//
//  HomeNavigationController.swift
//  hacker-news
//
//  Created by Shravan Sukumar on 24/06/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import Firebase

class HomeNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSetup()
    }
    
    private func performSetup() {
        self.navigationBar.barTintColor = .white
        if Preferences.userId != nil {
            let hackerNewsLandingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hackerNewsLandingViewController") as! HackerNewsLandingViewController
            navigationBar.isHidden = false
            self.viewControllers = [hackerNewsLandingViewController]
        } else {
            navigationBar.isHidden = true
        }
    }
}
