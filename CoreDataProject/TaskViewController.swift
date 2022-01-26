//
//  TaskViewController.swift
//  CoreDataProject
//
//  Created by Artem Zhuzhgin on 25.01.2022.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var taskTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 0/255, alpha: 194/255)
        button.setTitle("Save Task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
//        self.save()
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        self.dismiss(animated: true)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup(subviews: taskTextField, saveButton, cancelButton)
        setConstrains()
        
    }
    

    private func setup(subviews: UIView...){
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }

    private func setConstrains() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
             
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 100),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 40),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            
        ])
        
    }
    
    @objc private func save() {
        
        
        // Для сложных взаимосвязей и моделей
//        guard let enttityDeescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return}
//        guard let task = NSManagedObject(entity: enttityDeescription, insertInto: context) as? Task else {return}
        
        // ДЛя простой модели
        let task = Task(context: context)
        task.name = taskTextField.text
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
             
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        dismiss(animated: true)
        
    }
}
