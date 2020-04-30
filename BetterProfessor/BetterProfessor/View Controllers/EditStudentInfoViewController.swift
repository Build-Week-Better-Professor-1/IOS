//
//  EditStudentInfoViewController.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/27/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import CoreData

class EditStudentInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var wasEdited = false
    var betterProfessorController: BetterProfessorController?
    var student: Student? {
        didSet {
            updateViews()
        }
    }
    func updateViews() {
        if let student = student, isViewLoaded {
            studentName.text = student.name
            studentEmail.isUserInteractionEnabled = isEditing
            studentEmail.text = student.email
            studentName.isUserInteractionEnabled = isEditing
        }
    }
    
    @IBOutlet weak var studentName: UITextField!
    @IBOutlet weak var studentEmail: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        return UITableViewCell()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        updateViews()
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }
        
        studentName.isUserInteractionEnabled = true
        studentEmail.isUserInteractionEnabled = true
        navigationItem.setHidesBackButton(editing, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let name = studentName.text,
                !name.isEmpty,
                let email = studentEmail.text,
                !email.isEmpty,
                let student = student else {return}
            student.name = name
            student.email = email
            do {
                try CoreDataStack.shared.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    @IBAction func editStudentInfo(_ sender: Any) {
        isEditing = true
    
    }
    @IBAction func saveStudentInfo(_ sender: Any) {
        guard isEditing == true else {return}
        guard let name = studentName.text, !name.isEmpty,
            let email = studentEmail.text, !email.isEmpty else {return}
        if let student = student, let betterProfessorController = betterProfessorController {
            student.name = name
            student.email = email
            betterProfessorController.updateStudent(student: student, name: name, email: email)
        }
        isEditing = false
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
//        case "AddTaskSegue":
//            guard let addTaskVC = segue.destination as? AddTaskViewController else {return}
//            print(addTaskVC)
        case "ShowTaskSegue":
            guard let showTaskVC = segue.destination as? EditTaskViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            print(showTaskVC)
            print(indexPath)
        default:
            break
        }
    }
    

}
