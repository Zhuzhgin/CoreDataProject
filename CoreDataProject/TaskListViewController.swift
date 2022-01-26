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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    //    tableView.reloadData()
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
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc private func addNewTask(){
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else {return}
            self.save(task)
        }
        let cancelAction = UIAlertAction(title: "Calcel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
            textField.placeholder = "New Task"
        }
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String){
        StorageManager.shared.saveContext(taskName: taskName) { (task) in
            self.taskList.append(task)
        }
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        dismiss(animated: true)
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
