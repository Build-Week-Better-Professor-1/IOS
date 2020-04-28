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
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
         navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let studentName = studentNameTextField.text, !studentName.isEmpty,
            let studentEmail = studentEmailTextField.text, !studentEmail.isEmpty else {return}
        try! CoreDataStack.shared.save()
    }

}
