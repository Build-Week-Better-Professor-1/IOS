//
//  EditTaskViewController.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/30/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {

     var task: Task?
     var taskController: TaskController?
     var wasEdited = false
     @IBOutlet weak var taskTitleTextField: UITextField!
     @IBOutlet weak var taskDueDate: UITextField!
     @IBOutlet weak var taskNoteTextView: UITextView!
    
    @IBAction func saveChange(_ sender: Any) {
        
        guard let taskTitle = taskTitleTextField.text, !taskTitle.isEmpty, let taskDate = taskDueDate.text, !taskDate.isEmpty, let note = taskNoteTextView.text, !note.isEmpty else {return}
        if let taskController = taskController {
            taskController.updateTask(task: task!, title: taskTitle, note: note, taskDueDate: taskDate)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
       
       updateViews()
     }
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited{
            guard let title = taskTitleTextField.text,
              !title.isEmpty,
              let note = taskNoteTextView.text,
              !note.isEmpty,
              let date = taskDueDate.text,
              !date.isEmpty,
              let task = task else {
                return
            }
            task.title = title
            task.note = note
            task.dueDate = date
              do {
                try CoreDataStack.shared.mainContext.save()
              } catch {
                NSLog("Error saving managed object context: \(error)")
              }
        }
       }
     // MARK: - Editing
     override func setEditing(_ editing: Bool, animated: Bool) {
       super.setEditing(editing, animated: animated)
        
       if editing { wasEdited = true }
        
       taskTitleTextField.isUserInteractionEnabled = editing
       taskNoteTextView.isUserInteractionEnabled = editing
       taskDueDate.isUserInteractionEnabled = editing
        
       navigationItem.hidesBackButton = editing
     }
      
     // MARK: - Actions
     private func updateViews() {
        if isViewLoaded{
            taskTitleTextField.text = task?.title
            taskTitleTextField.isUserInteractionEnabled = isEditing
             
            taskNoteTextView.text = task?.note
            taskNoteTextView.isUserInteractionEnabled = isEditing
             
            taskDueDate.text = task?.dueDate
            taskDueDate.isUserInteractionEnabled = isEditing
            navigationItem.rightBarButtonItem = editButtonItem
        }
     }
}
