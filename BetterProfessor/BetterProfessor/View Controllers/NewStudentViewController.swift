//
//  NewStudentViewController.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/27/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class NewStudentViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var studentEmailTextField: UITextField!
    @IBOutlet weak var reminderTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
         navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
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
