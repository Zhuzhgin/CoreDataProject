//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Artem Zhuzhgin on 25.01.2022.
//

import UIKit

class TaskListViewController: UITableViewController {

    
    private let cellID = "task"
    var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        setupNavigationBar()

        StorageManager.shared.fetchData { (taskList) in
            self.taskList = taskList
        }
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppeareance = UINavigationBarAppearance()
        navBarAppeareance.configureWithOpaqueBackground()
        navBarAppeareance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppeareance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppeareance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255)
        navigationController?.navigationBar.standardAppearance = navBarAppeareance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppeareance
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: .none)
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc private func addNewTask(){
        showAlertAdd(with: "New Task", and: "What do you want to do?")
    }
    
    private func showAlertAdd(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else {return}
            self.save(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        

    
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
            textField.placeholder = "New Task"
            
        }
        present(alert, animated: true)
    }
    
    
    
    private func showAlertEdit(with title: String, and message: String, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.taskList[indexPath.row].name
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let newTaskName = alert.textFields?.first?.text, !newTaskName.isEmpty else {return}
            self.saveEditTask(newTaskName: newTaskName, indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String){
        
        StorageManager.shared.saveTask(taskName: taskName) { (task) in
            self.taskList.append(task)
            
        }
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
    }
    
    private func saveEditTask(newTaskName: String, indexPath: IndexPath) {
      let task = taskList[indexPath.row]

        taskList[indexPath.row].name = newTaskName
        StorageManager.shared.edit(task: task, newName: newTaskName)
       
            self.tableView.reloadData()
        }
        
    }
    


extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    
   
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Edit") { (action, view, complition) in
            self.showAlertEdit(with: "Edit", and: "Please Edit Task Name", indexPath: indexPath)
            complition(true)
        }
        action.backgroundColor = .systemGreen
        return action
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(indexPath.row)
            let task = taskList[indexPath.row]
            StorageManager.shared.deleteData(task: task)

            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
 
}
