//
//  APIService.swift
//  ToDoList
//
//  Created by Mac  on 03.09.2024.
//

import Foundation

class APIService{
    static let shared = APIService()
    
    private init(){}
    
    func fetchTodos(completition: @escaping ([Task]?) -> Void){
        guard let url = URL(string: "https://dummyjson.com/todos") else{
            print("Invalid URL")
            completition(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error{
                print("Error fetching todos: \(error)")
                completition(nil)
                return
            }
            
            guard let data = data else{
                print("No data returned")
                completition(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let todoResponse = try decoder.decode(TodoResponse.self, from: data)
                
                let tasks = todoResponse.todos.compactMap{todo in
                    CoreDataManager.shared.createTask(title: todo.title, taskDescription: todo.taskDescription, isCompleted: todo.isCompleted)
                }
                
                completition(tasks)
            }catch{
                print("Error decoding todos: \(error)")
                completition(nil)
            }
        }.resume()
    }
}


//Models
struct TodoResponse: Codable{
    let todos: [Todo]
}

struct Todo: Codable{
    let id: Int
    let title: String
    let taskDescription: String
    let isCompleted: Bool
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case taskDescription = "description"
        case isCompleted = "completed"
    }
}
