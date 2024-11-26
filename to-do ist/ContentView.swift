import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @State private var isShowingItemSheet = false
    @Query(sort: \Item.title) var items: [Item]
    @State private var expenseToEdit: Item?
    @State private var searchText = ""
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems) { item in
                    ExpenseCell(item: item)
                        .onTapGesture {
                            expenseToEdit = item
                        }
                        .listRowSeparator(.hidden)
                        
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(items[index])
                    }
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .searchable(text: $searchText, prompt: "Search to-do list...")
            .navigationTitle("to-do ist")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddToDoListSheeet() }
            .sheet(item: $expenseToEdit, content: { expense in
                UpdateToDoListSheeet(item: expense)
            })
            .toolbar {
                if !items.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait") },
                                           description: {
                        Text("Start adding expenses to see your list.")
                    }, actions: {
                        Button("Add Expense") { isShowingItemSheet = true }
                    })
                    .offset(y: -60)
                }
            }
        }
    }
}

#Preview { ContentView() }

struct ExpenseCell: View {
    let item: Item
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            Text(item.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Text(item.paragraph)
                .font(.callout)
                .foregroundColor(.black)
        }
        .padding(16)
        .background(Color.randomLight)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct AddToDoListSheeet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var paragraph: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Paragraph", text: $paragraph)
            }
            .navigationTitle("to-do ist")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let item = Item(title: title, paragraph: paragraph)
                        context.insert(item)
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UpdateToDoListSheeet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: Item
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $item.title)
                TextField("Paragraph", text: $item.paragraph)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("to-do ist")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}


extension Color {
    static var randomLight: Color {
        return Color(
            red: Double.random(in: 0.5...1.0),
            green: Double.random(in: 0.5...1.0),
            blue: Double.random(in: 0.5...1.0)
        )
    }
}
