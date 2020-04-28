//
//  LoginViewController.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/27/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

enum LoginType: String {
    case login = "Login"
    case signUp = "Sign Up"
}

class LoginViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var loginType = LoginType.login
    var apiController = APIController()
    
    private var isFetching: Bool = false {
        didSet {
            if isFetching {
                activityIndicator.startAnimating()
                submitButton.isEnabled = false
            } else {
                activityIndicator.stopAnimating()
                submitButton.isEnabled = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func loginTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            loginType = .signUp
            passwordTextField.textContentType = .newPassword
        default:
            loginType = .login
            passwordTextField.textContentType = .password
        }
        submitButton.setTitle(loginType.rawValue, for: .normal)
    }
    
    @IBAction func textDidChange(_ sender: Any) {
        submitButton.isEnabled = usernameTextField.text?.isEmpty == false &&
            passwordTextField.text?.isEmpty == false
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        isFetching = true
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            username.isEmpty == false,
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            password.isEmpty == false
            else { return }
        
        
        
        
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
