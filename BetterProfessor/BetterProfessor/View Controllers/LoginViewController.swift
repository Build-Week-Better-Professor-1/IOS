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
    
    
    // MARK: - Outlets
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    var apiController: APIController?
    
    var loginType: LoginType = .signUp {
        didSet {
            switch loginType {
            case .signIn:
                submitButton.setTitle("Sign In", for: .normal)
            default:
                submitButton.setTitle("Sign Up", for: .normal)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            loginType = .signUp
            passwordTextField.textContentType = .newPassword
        default:
            loginType = .signIn
            passwordTextField.textContentType = .password
        }
        submitButton.setTitle(loginType.rawValue, for: .normal)
    }
    
    @IBAction func textDidChange(_ sender: Any) {
        submitButton.isEnabled = usernameTextField.text?.isEmpty == false &&
            passwordTextField.text?.isEmpty == false
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            username.isEmpty == false,
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            password.isEmpty == false
            else { return }
        
        switch loginType {
        case .signIn:
            apiController?.signIn(with: username, password: password) { error in
                DispatchQueue.main.async {
                    let alert: UIAlertController
                    let action: () -> Void
                    
                    if error != nil {
                        action = {
                            self.dismiss(animated: true)
                        }
                    } else {
                        alert = self.alert(title: "Error", message: "Error during signing in")
                        action = {
                            self.present(alert, animated: true)
                        }
                    }
                    action()
                }
            }
        case .signUp:
            
        }
    }
    
    private func alert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
