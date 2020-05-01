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

    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.predicate = NSPredicate(format:"student == %@", self.student!.id!)
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error doing frc fetch")
        }
        return frc
    }()
    
    @objc func alertAdd() {
        self.navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Success", message: "This task has been added to your list successfully", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    @objc func alertChange() {
        self.navigationController?.popViewController(animated: true)
        let alert = UIAlertController(title: "Success", message: "Change has been made on this task", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    var wasEdited = false
    var betterProfessorController: BetterProfessorController?
    var taskController = TaskController()
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
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = fetchedResultsController.fetchedObjects?[indexPath.row].title
        cell.detailTextLabel?.text = fetchedResultsController.fetchedObjects?[indexPath.row].dueDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let delete = fetchedResultsController.object(at: indexPath)

            taskController.delete(task: delete)

        }
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()
        updateViews()
        tableView.dataSource = self
        tableView.delegate = self
        taskController.fetchTask() {error in
            guard error == nil else {return}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(alertAdd), name: NSNotification.Name("TaskAdd"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alertChange), name: NSNotification.Name("TaskChange"), object: nil)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing { wasEdited = true }

        studentName.isUserInteractionEnabled = true
        studentEmail.isUserInteractionEnabled = true
        navigationItem.setHidesBackButton(editing, animated: true)
    }
    
    //do not reload TVdata here!
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
        case "AddTaskSegue":
            guard let addTaskVC = segue.destination as? AddTaskViewController else {return}
            addTaskVC.taskController = taskController
            addTaskVC.student = student?.id
        case "ShowTaskSegue":
            guard let showTaskVC = segue.destination as? EditTaskViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            showTaskVC.task = fetchedResultsController.object(at: indexPath)
            showTaskVC.taskController = taskController
        default:
            break
        }
    }

}
extension EditStudentInfoViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

