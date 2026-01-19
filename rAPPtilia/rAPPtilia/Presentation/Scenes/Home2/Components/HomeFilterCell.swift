import SwiftUI

struct HomeFilterCell: View {
    var title: String
    var selectedValue: String?
    var options: [String]
    var onSelect: (String?) -> Void
    
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
                    .font(.custom("Firago-Regular", size: 10))

                Image(systemName: "chevron.down")
                    .font(.system(size: 10))
            }
            .padding(8)
            .background(selectedValue != nil ? Color("AppDarkRed") : Color("AppBG"))
            .foregroundColor(selectedValue != nil ? Color("AppBG") : Color("AppDarkRed"))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("AppDarkRed"), lineWidth: 2)
            )
            .cornerRadius(8)
        }
    }
}
