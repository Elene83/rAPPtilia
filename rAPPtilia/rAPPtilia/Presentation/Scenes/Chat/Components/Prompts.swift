import SwiftUI

struct Prompts: View {
    private let prompts = [
        "What can I do if a snake bit me?",
        "How do I relocate lizards?",
        "How do I remove snakes off my property?",
        "What time do vipers come out?",
        "How many venomous snake species are in Georgia?",
        "Do reptiles hibernate?",
        "Do all venomous snakes have slit pupils?",
        "What to do with a non-venomous snake bite?"
    ]
    var body: some View {
        ScrollView {
            VStack (spacing: 20) {
                ForEach(prompts, id: \.self) {
                    Text($0)
                        .font(.custom("Firago-Regular", size: 14))
                        .foregroundStyle(Color("AppDarkRed"))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 60)
        }
        .padding(.top, -85)
    }
}
