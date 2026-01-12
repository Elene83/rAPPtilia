import SwiftUI

struct Prompts: View {
    var onPromptSelected: (String) -> Void
    
    private let prompts = [
        "What can I do if a snake bit me?",
        "How do I relocate lizards?",
        "How do I remove snakes off my property?",
        "What time do vipers come out?",
        "How many venomous snake species are in Georgia?",
        "What to do with a non-venomous snake bite?"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                ForEach(prompts, id: \.self) { prompt in
                    Button(action: {
                        onPromptSelected(prompt)
                    }) {
                        Text(prompt)
                            .font(.custom("Firago-Regular", size: 14))
                            .foregroundStyle(Color("AppDarkRed"))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                            .background(Color("AppLightPink"))
                            .cornerRadius(4)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 60)
        }
        .padding(.top, -80)
    }
}
