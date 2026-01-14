import SwiftUI

struct ImageOverlay: View {
    @Binding var isPresented: Bool
    var imageUrl: String
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .ignoresSafeArea()
                .opacity(showContent ? 1 : 0)
            
            Color("AppBG")
                .opacity(showContent ? 0.2 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showContent = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPresented = false
                    }
                }
            
            CachedAsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(20)
            .scaleEffect(showContent ? 1.0 : 0.9)
            .opacity(showContent ? 1 : 0)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    showContent = true
                }
            }
        }
    }
}
