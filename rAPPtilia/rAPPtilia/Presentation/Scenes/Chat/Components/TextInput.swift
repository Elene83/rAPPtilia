import SwiftUI

struct TextInput: View {
    @Binding var text: String
    var onSend: () -> Void
    
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
                guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                onSend()
            }) {
                Image("sendIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .opacity(text.isEmpty ? 0.5 : 1.0)
            }
            .disabled(text.isEmpty)
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 11)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("AppDarkRed"), lineWidth: 1)
        )
    }
}
