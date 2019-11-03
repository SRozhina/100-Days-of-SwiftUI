import Foundation

struct ExpenseItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items: [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        let decoder = JSONDecoder()
        if let items = UserDefaults.standard.data(forKey: "Items"),
            let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
            self.items = decoded
            return
        }
        self.items = []
    }
}
