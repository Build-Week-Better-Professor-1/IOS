//
//  AddTaskViewController.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/30/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    //MARK: - Properties
    var taskController: TaskController?
    var student: String?
    //MARK: - Outlets
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDueDateTextField: UITextField!
    @IBOutlet weak var taskNoteTextField: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = taskTitleTextField.text,
            !title.isEmpty,
            let note = taskNoteTextField.text,
            !note.isEmpty,
            let date = taskDueDateTextField.text,
            !date.isEmpty,
            let student = student else { return }
        
        
            taskController?.createTask(title: title, note: note, dueDate: date, student: student)

        navigationController?.popViewController(animated: true)
        }
    }
