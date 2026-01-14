import SwiftUI

struct DescriptionStack: View {
    var items: [DescriptionItem]
    
    let columns = [
        GridItem(.flexible(), spacing: 40),
        GridItem(.flexible(), spacing: 40),
        GridItem(.flexible(), spacing: 40)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(items) { item in
                DescriptionCell(descriptionLabel: item.label, descriptionString: item.value)
            }
        }
        .padding(.top, 10)
    }
}
