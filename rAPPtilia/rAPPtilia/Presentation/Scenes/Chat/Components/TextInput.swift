import SwiftUI

struct TextInput: View {
    @State private var text: String = ""
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Type your question...")
                        .foregroundColor(Color("AppLightRed"))
                        .font(.custom("Firago-Regular", size: 14))
                }
                TextField("", text: $text)
                    .foregroundColor(Color("AppDarkRed"))
                    .font(.custom("Firago-Regular", size: 14))
            }
            
            Button(action: {
                print("send tapped: \(text)")
            }) {
                Image("sendIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 11)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("AppDarkRed"), lineWidth: 1)
        )
    }

}
