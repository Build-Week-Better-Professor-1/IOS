//
//  LoginViewController.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/27/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

enum LoginType: String {
    case signIn = "Sign In"
    case signUp = "Sign Up"
}

class LoginViewController: UIViewController {
    
    var betterProfessorController: BetterProfessorController?
    
    // MARK: - Outlets
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    var apiController: APIController?
    
    var loginType : LoginType?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        loginType = .signIn
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 8.0
        submitButton.setTitle("Sign In", for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            loginType = .signUp
            submitButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            submitButton.setTitle("Sign In", for: .normal)
        }
    }
    

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let apiController = apiController else {return}
        if let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty {
            let professor = Professor(username: username, password: password)
            if loginType == .signUp {
                apiController.signUp(with: professor) {error in
                    if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Done", message: "Please Login", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController,animated: true) {
                                self.loginType = .signIn
                                self.loginTypeSegmentedControl.selectedSegmentIndex = 0
                                self.submitButton.setTitle("Sign In", for: .normal)
                            }

                        }
                    }
                }

            } else {
                apiController.signIn(with: professor) {error in
                    if let error = error {
                        NSLog("Error occured during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

}
