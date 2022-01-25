//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Artem Zhuzhgin on 25.01.2022.
//

import UIKit


class TaskListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .white
        setupNavigationBar()
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
        
    }
}

