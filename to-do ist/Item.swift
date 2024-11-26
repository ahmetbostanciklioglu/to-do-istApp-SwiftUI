import Foundation
import SwiftData

@Model
class Item {
    var title: String
    var paragraph: String
    
    init(title: String, paragraph: String) {
        self.title = title
        self.paragraph = paragraph
    }
}
