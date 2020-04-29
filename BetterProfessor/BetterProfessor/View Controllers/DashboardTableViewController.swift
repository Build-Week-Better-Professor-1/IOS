//
//  DashboardTableViewController.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/27/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import CoreData

class DashboardTableViewController: UITableViewController {
    
    // MARK: -Properties
    lazy var fetchedResultsController: NSFetchedResultsController<Student> = {
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "StudentCell",
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var students: [Student] = []
    var apiController = APIController()
    var betterProfessorController = BetterProfessorController()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        let bearer = apiController.bearer
        if bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            betterProfessorController.fetchStudent() {result in
                let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
                let context = CoreDataStack.shared.mainContext
                
                context.perform {
                    do {
                        self.students = try context.fetch(fetchRequest)
                    } catch {
                        NSLog("Error fetching student in Dashboard VC: \(error)")
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return betterProfessorController.studentRep.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        cell.textLabel?.text = betterProfessorController.studentRep[indexPath.row].name


        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let student = fetchedResultsController.object(at: indexPath)
            CoreDataStack.shared.mainContext.delete(student)
            betterProfessorController.deleteStudentFromServer(student: student)
            DispatchQueue.main.async {
                do {
                    try CoreDataStack.shared.mainContext.save()
                } catch {
                    CoreDataStack.shared.mainContext.reset()
                    NSLog("Error saving managed object context: \(error)")
                }
            }

            betterProfessorController.delete(student: students[indexPath.row])

        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowStudentSegue":
            guard let showStudentVC = segue.destination as? EditStudentInfoViewController,
                let index = tableView.indexPathForSelectedRow else {return}
            showStudentVC.betterProfessorController = betterProfessorController
            showStudentVC.student = betterProfessorController.studentRep[index.row]
            
        case "AddStudentSegue":
            guard let addStudentVC = segue.destination as? NewStudentViewController else {return}
            addStudentVC.betterProfessorController = betterProfessorController
            addStudentVC.apiController = apiController
            
        case "LoginModalSegue":
            guard let loginVC = segue.destination as? LoginViewController else {return}
            loginVC.betterProfessorController = betterProfessorController
            loginVC.apiController = apiController
        default:
            break
        }
    }
    

}
extension DashboardTableViewController: NSFetchedResultsControllerDelegate {
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

