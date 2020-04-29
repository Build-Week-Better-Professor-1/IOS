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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var students: [Student] = []
    var apiController = APIController()
    var betterProfessorController = BetterProfessorController()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        let token = apiController.token
        if token == nil {
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        cell.textLabel?.text = betterProfessorController.studentRep[indexPath.row].name

        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            betterProfessorController.delete(student: students[indexPath.row])
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowStudentSegue":
            guard let showStudentVC = segue.destination as? EditStudentInfoViewController else {return}
            print(showStudentVC)
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
