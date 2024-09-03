//
//  AddEditTaskVIewController.swift
//  ToDoList
//
//  Created by Mac  on 03.09.2024.
//

import Foundation
import UIKit

protocol AddEditTaskDelegate: AnyObject{
    func didSaveTask()
}

class AddEditTaskVIewController: UIViewController{
    weak var delegate: AddEditTaskDelegate?
    
    var task: Task?
    
    let titleTextField = UITextField()
    let descriptionTextField = UITextField()
    let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        if let task = task{
            titleTextField.text = task.title
            descriptionTextField.text = task.taskDescription
            saveButton.setTitle("Update Task", for: .normal)
        }else{
            saveButton.setTitle("Add Task", for: .normal)
        }
    }
    
    private func setupUI(){
        titleTextField.placeholder = "TaskTitle"
        descriptionTextField.placeholder = "Task Description"
        
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(saveButton)
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 20)
        ])
        
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
    }
    
    @objc private func saveTask() {
            guard let title = titleTextField.text, !title.isEmpty,
                  let description = descriptionTextField.text, !description.isEmpty else {
                // Show an alert or message to user about the error
                return
            }
            
            if let task = task {
                task.title = title
                task.taskDescription = description
                task.isCompleted = task.isCompleted
            } else {
                CoreDataManager.shared.createTask(title: title, taskDescription: description)
            }
            
            CoreDataManager.shared.saveContext()
            
            delegate?.didSaveTask()
            navigationController?.popViewController(animated: true)
        }
}
