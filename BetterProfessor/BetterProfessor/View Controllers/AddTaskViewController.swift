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
            let date = taskDueDateTextField.text,
            !date.isEmpty,
            let student = student else { return }
        
        
        
        let task = Task(title: title, note: taskNoteTextField.text, dueDate: date, student: student)
            taskController?.sendTaskToServer(task: task)
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Failed to save coredata context: \(error)")
                return
            }

        navigationController?.popViewController(animated: true)
        }
    }
