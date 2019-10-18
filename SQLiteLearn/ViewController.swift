//
//  ViewController.swift
//  SQLiteLearn
//
//  Created by Raju Dhumne on 15/09/19.
//  Copyright © 2019 Raju Dhumne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableViewUser: UITableView!
    var userModel = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reminders"
        self.tableViewUser.tableFooterView = UIView()
        self.tableViewUser.delegate = self
        self.tableViewUser.dataSource = self
        
        DataManager.shared.fetchAllUser { [weak self](model, error) in
            self?.userModel = model
            self?.tableViewUser.reloadData()
        }
        
    }

    @IBAction func addUserButton(_ sender: Any) {
        print("Add Button Clicked")
        let alert = UIAlertController(title: "Add User", message: "Please provide email id and name.", preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Email"}
        alert.addTextField { (tf) in tf.placeholder = "Name"}
        
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let email = alert.textFields?.first?.text, let name = alert.textFields?.last?.text
                else { return }
            DataManager.shared.inserUser(email: email, name: name)
            DataManager.shared.fetchAllUser { [weak self](model, error) in
                self?.userModel.removeAll()
                self?.userModel = model
                self?.tableViewUser.reloadData()
            }
        }
        let cancel =  UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewUser.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as! UserViewCell
        let user = userModel[indexPath.row]
        cell.config(email: user.email, name: user.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let TrashAction = UIContextualAction(style: .normal, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let user = self.userModel[indexPath.row]
            DataManager.shared.deleteUser(email: user.email)
            DataManager.shared.fetchAllUser { [weak self](model, error) in
                self?.userModel.removeAll()
                self?.userModel = model
                self?.tableViewUser.reloadData()
            }
            success(true)
        })
        TrashAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            
            success(true)
        }
        editAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [TrashAction,editAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(userModel[indexPath.row])
    }
}

