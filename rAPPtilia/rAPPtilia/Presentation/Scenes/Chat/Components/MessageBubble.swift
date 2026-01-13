import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .font(.custom("Firago-Regular", size: 13))
                .foregroundColor(Color("AppWhite"))
                .padding(.horizontal, 13)
                .padding(.vertical, 10)
                .background(message.isUser ? Color("AppMyBubble") : Color("AppTheirBubble"))
                .cornerRadius(8)
                .frame(maxWidth: .infinity * 0.75, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser { Spacer() }
        }
    }
}
