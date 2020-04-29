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
    
    var betterProfessorController: BetterProfessorController?
    var student: StudentRepresentation?

    
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
        guard isViewLoaded else {return}
        betterProfessorController?.fetchStudent()
        studentEmail.text = student?.email
        studentName.text = student?.name
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AddTaskSegue":
            guard let addTaskVC = segue.destination as? TaskDetailViewController else {return}
            print(addTaskVC)
        case "ShowTaskSegue":
            guard let showTaskVC = segue.destination as? TaskDetailViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            print(showTaskVC)
            print(indexPath)
        default:
            break
        }
    }
    

}
