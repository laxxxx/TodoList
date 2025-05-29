//
//  ContentView.swift
//  Grocery List
//
//  Created by Sree Lakshman on 27/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    func addEssesntialFoods() {
        modelContext.insert(Item(title: "Bread", isCompleted: true))
        modelContext.insert(Item(title: "Chicken Breasts", isCompleted: false))
        modelContext.insert(Item(title: "Bananas", isCompleted: true))
        modelContext.insert(Item(title: "Milk", isCompleted: false))
        modelContext.insert(Item(title: "Cheese", isCompleted: true))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    Text(item.title)
                        .font(.title)
                        .fontWeight(.light)
                        .padding(.vertical, 2)
                        .foregroundStyle(item.isCompleted ? Color.accentColor : Color.primary)
                        .strikethrough(item.isCompleted)
                        .italic(item.isCompleted)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    modelContext.delete(item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button("Done", systemImage: item.isCompleted ? "x.circle" : "checkmark.circle") {
                                item.isCompleted.toggle()
                            }
                            .tint(item.isCompleted ? .red : .accentColor)
                        }
                }
                
            }
            .navigationTitle("Grocery List")
            .toolbar {
                if items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            addEssesntialFoods()
                        } label: {
                            Label("Essentials", systemImage: "carrot")
                        }
                    }
                }
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("Empty Cart",systemImage: "cart.circle", description: Text("Add some items to the shopping list."))
                }
            }
        }
        
    }
}

#Preview("with sample data") {
    let sampleData: [Item] = [
        Item(title: "Bread", isCompleted: true),
        Item(title: "Chicken Breasts", isCompleted: false),
        Item(title: "Bananas", isCompleted: true),
        Item(title: "Milk", isCompleted: false),
        Item(title: "Cheese", isCompleted: true)
    ]
    
    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for item in sampleData {
        container.mainContext.insert(item)
    }
    
    return ContentView()
        .modelContainer(container)
}

#Preview("empty list") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
