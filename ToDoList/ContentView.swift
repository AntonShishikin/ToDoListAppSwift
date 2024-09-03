//
//  ContentView.swift
//  ToDoList
//
//  Created by Mac  on 03.09.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
           sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: true)],
           animation: .default)
       private var tasks: FetchedResults<Task>

    var body: some View {
            NavigationView {
            List {
                ForEach(tasks) { task in
                    NavigationLink {
                        VStack(alignment: .leading) {
                            Text(task.title ?? "No Title")
                                .font(.headline)
                            Text(task.taskDescription ?? "No Description")
                                .font(.subheadline)
                            Text("Created at: \(task.createdAt!, formatter: itemFormatter)")
                                .font(.footnote)
                        }
                    } label: {
                        Text(task.title ?? "No Title")
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addTask) {
                        Label("Add Task", systemImage: "plus")
                    }
                }
            }
            Text("Select a task")
        }
    }

    private func addTask() {
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.title = "New Task"
            newTask.taskDescription = "Task description"
            newTask.createdAt = Date()
            newTask.isCompleted = false

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
