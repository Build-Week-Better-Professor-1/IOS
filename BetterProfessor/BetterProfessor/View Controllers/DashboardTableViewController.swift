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

    lazy var fetchedResultsController: NSFetchedResultsController<Student> = {
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //fetchRequest.predicate = NSPredicate(format: "professor IN %@", "\(APIController().bearer!)")
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
    // MARK: - Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        betterProfessorController.fetchStudent()
        self.tableView.reloadData()
    }
    var token: String?
    var apiController = APIController()
    var betterProfessorController = BetterProfessorController()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // transition to login view if conditions require
        let bearer = apiController.bearer
        if bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            betterProfessorController.token = apiController.bearer
            betterProfessorController.fetchStudent { error in
                guard error == nil else {return}
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
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        cell.textLabel?.text = fetchedResultsController.fetchedObjects?[indexPath.row].name

        //cell.textLabel?.text = betterProfessorController.studentRep[indexPath.row].name

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let studentFR = fetchedResultsController.object(at: indexPath)

            betterProfessorController.delete(student: studentFR)

        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowStudentSegue":
            guard let showStudentVC = segue.destination as? EditStudentInfoViewController,
                let index = tableView.indexPathForSelectedRow else {return}
            showStudentVC.betterProfessorController = betterProfessorController
            showStudentVC.student = fetchedResultsController.fetchedObjects?[index.row]

        case "AddStudentSegue":
            guard let addStudentVC = segue.destination as? NewStudentViewController else {return}
            addStudentVC.betterProfessorController = betterProfessorController

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
