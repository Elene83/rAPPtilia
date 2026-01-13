import SwiftUI

struct HomeFilterBoolCell: View {
    var title: String
    var selectedValue: Bool?
    var onSelect: (Bool?) -> Void
    
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
            
            Button(action: {
                onSelect(true)
            }) {
                HStack {
                    Text("Yes")
                    if selectedValue == true {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button(action: {
                onSelect(false)
            }) {
                HStack {
                    Text("No")
                    if selectedValue == false {
                        Image(systemName: "checkmark")
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

//TODO: stylize
