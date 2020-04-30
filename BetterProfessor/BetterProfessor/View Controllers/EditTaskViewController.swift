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
     var wasEdited = false
     @IBOutlet weak var taskTitleTextField: UITextField!
     @IBOutlet weak var taskDueDate: UITextField!
     @IBOutlet weak var taskNoteTextView: UITextView!
    
     override func viewDidLoad() {
       super.viewDidLoad()
       navigationItem.rightBarButtonItem = editButtonItem
       updateViews()
     }
     override func viewWillDisappear(_ animated: Bool) {
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
       taskTitleTextField.text = task?.title
       taskTitleTextField.isUserInteractionEnabled = isEditing
        
       taskNoteTextView.text = task?.note
       taskNoteTextView.isUserInteractionEnabled = isEditing
        
       taskDueDate.text = task?.dueDate
       taskDueDate.isUserInteractionEnabled = isEditing
     }
}
