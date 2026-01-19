import SwiftUI

struct MapFilterCell: View, Equatable {
    var title: String
    var selectedValue: String?
    var options: [String]
    var onSelect: (String?) -> Void
    
    static func == (lhs: MapFilterCell, rhs: MapFilterCell) -> Bool {
        lhs.title == rhs.title &&
        lhs.selectedValue == rhs.selectedValue &&
        lhs.options == rhs.options
    }
    
    var body: some View {
        Menu {
            Button(action: {
                onSelect(nil)
            }) {
                HStack {
                    Text("All")
                    if selectedValue == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            ForEach(options, id: \.self) { option in
                Button(action: {
                    onSelect(option)
                }) {
                    HStack {
                        Text(option)
                        if selectedValue == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(title)
                    .font(.custom("Firago-Regular", size: 14))

                Image(systemName: "chevron.down")
                    .font(.system(size: 12))
            }
            .padding(11)
            .background(selectedValue != nil ? Color("AppDarkGreen") : Color("AppBG"))
            .foregroundColor(selectedValue != nil ? Color("AppBG") : Color("AppDarkGreen"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("AppDarkGreen"), lineWidth: 1)
            )
        }
    }
}
