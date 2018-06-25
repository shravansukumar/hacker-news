//
//  SignInViewController.swift
//  hacker-news
//
//  Created by Shravan Sukumar on 24/06/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var signInButton: GIDSignInButton!
    @IBOutlet var welcomeLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGoogleSignInButton()
    }
    
    // MARK: - Private Methods
    private func setupGoogleSignInButton() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    private func pushToNewsViewController() {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hackerNewsLandingViewController") as! HackerNewsLandingViewController
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}

// MARK: - GIDSignInUIDelegate, GIDSignInDelegate
extension SignInViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            welcomeLabel.text = "There seems to be a problem. Please try again!"
            return
        }
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.welcomeLabel.text = "There seems to be a problem. Please try again!"
                return
            }
            if let userId = user?.user.uid {
                print("fb success login for user: \(userId)")
                self.welcomeLabel.text = "Yaay! Successfully registered with us!"
                Preferences.userId = userId
                
                self.pushToNewsViewController()
            }
        }
    }
}
