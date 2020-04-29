//
//  TaskDetailViewController.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDueDate: UITextField!
    @IBOutlet weak var taskNoteTextView: UITextView!
    
   // MARK: - Properties
    var taskController: TaskController?
    
    var task: Task? {
           didSet {
               
           }
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
   // MARK: - Actions
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let title = taskTitleTextField.text,
            !title.isEmpty else {return}
        guard let date = taskDueDate.text,
            !date.isEmpty else {return}
        guard let student = task?.student else { return }
        
        let task = Task(title: title, note: taskNoteTextView.text, dueDate: date, student: student)
        taskController?.sendTaskToServer(task: task)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
        NSLog("Failed to save coredate context: \(error)")
        return
    }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func setUpViews() {
        
    }
}
