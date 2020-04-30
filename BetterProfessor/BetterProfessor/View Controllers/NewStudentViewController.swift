//
//  NewStudentViewController.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/27/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class NewStudentViewController: UIViewController {

    var betterProfessorController: BetterProfessorController?

    // MARK: - Outlets
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var studentEmailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Actions

    @IBAction func saveTapped(_ sender: Any) {

        guard let studentName = studentNameTextField.text, !studentName.isEmpty,
            let studentEmail = studentEmailTextField.text, !studentEmail.isEmpty else {return}
        betterProfessorController?.createStudent(name: studentName, email: studentEmail,professor: "\(betterProfessorController!.token!)")
        Alert.showBasic(title: "Student Added", message: "Please add task!", vc: self)
        navigationController?.popViewController(animated: true)
    }

}
