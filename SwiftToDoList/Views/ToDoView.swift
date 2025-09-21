//
//  ToDoList.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/08.
//

import SwiftUI

struct ToDoView: View {
    
    @StateObject private var viewModel:TaskViewModel
    @State private var selectedCard: CardType? = .tasks
    @State private var selectedSegment: String = "Incompleted"
    @State private var isTaskChecked = false
    @State private var showAddTaskSheet = false
    @State var selectedTask: Tasks?
    
    init() {
           _viewModel = StateObject(wrappedValue: DIContainer.shared.resolveTaskViewModel())
       }
            
    var body: some View {
        ZStack(alignment: .top) {
            // Sky blue gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.53, green: 0.61, blue: 0.98), // Light sky blue
                    Color(red: 0.15, green: 0.1, blue: 0.5)  // Deeper sky blue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Text("Segments")
                        .font(.custom("TrebuchetMS", size: 35))
                        .bold()
                    Spacer()
                    Button {
                        showAddTaskSheet = true
                        selectedTask = nil
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size:30))
                            .foregroundColor(.white)
                    }
                }
                
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        SegmentsCard(icon: "house.fill", title: "All Task", count: viewModel.taskCount(cardCount: .tasks))
                            .onTapGesture { selectedCard = .tasks; selectedSegment = "Incompleted" }
                        
                        SegmentsCard(icon: "exclamationmark.triangle.fill", title: "Priority", count: viewModel.taskCount(cardCount: .priority))
                            .onTapGesture { selectedCard = .priority; selectedSegment = "Low" }
                        
                        
                    }
                    HStack(spacing: 15) {
                        SegmentsCard(icon: "hourglass.bottomhalf.fill", title: "Today", count: viewModel.taskCount(cardCount: .today))
                            .onTapGesture { selectedCard = .today; selectedSegment = "Today's Tasks" }
                        
                        SegmentsCard(icon: "flag.fill", title: "Over Due", count: viewModel.taskCount(cardCount: .overdue))
                            .onTapGesture { selectedCard = .overdue; selectedSegment = "Over Due" }
                    }
                }
                .navigationTitle("Segments")
                
                Text("Tasks")
                    .font(.custom("TrebuchetMS", size: 35))
                    .bold()
                    .frame(alignment: .leading)
                
                if let selectedCard, !selectedCard.options.isEmpty{
                    Picker("Select", selection: $selectedSegment){
                        ForEach(selectedCard.options, id: \.self){ option in // id: \.self provides key path since cardType doesn't conform to Identifialble
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                VStack {
                    ScrollView {
                        LazyVStack(spacing: 13) {
                            ForEach(viewModel.filteredTasks(selectedCard: selectedCard, selectedSegment: selectedSegment)) { task in
                                TaskCardView(task: task, viewModel: viewModel)
                                    .onTapGesture{
                                        selectedTask = task
                                    }
                            }
                        }
                        .padding(.vertical)
                    }
                    .frame(maxHeight: 500)
                    
                }
                //Spacer()
            }
            .padding()
            .sheet(isPresented: $showAddTaskSheet) {
                AddTaskSheetView(viewModel: viewModel)
            }
            .sheet(item: $selectedTask) { task in // now selectedTask is a trigger
                AddTaskSheetView(viewModel: viewModel, taskToEdit: task)
            }
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
