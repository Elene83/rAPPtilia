import SwiftUI

struct ChatView: View {
    let coordinator: MainCoordinator
    @StateObject private var viewModel: ChatViewModel
    @Namespace private var animation
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeChatViewModel())
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                if viewModel.messages.isEmpty {
                    TopSide()
                        .padding(.top, -60)
                        .transition(.scale)
                    
                    Prompts(onPromptSelected: { selectedPrompt in
                        Task {
                            await viewModel.startConvo(with: selectedPrompt)
                        }
                    })
                    .transition(.opacity.combined(with: .scale))
                    
                    Spacer()
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                Color.clear.frame(height: 90)
                                
                                ForEach(viewModel.messages) { message in
                                    MessageBubble(message: message)
                                        .id(message.id)
                                        .transition(.opacity.combined(with: .move(edge: .leading)))
                                }
                                           
                                if viewModel.isLoading {
                                    HStack {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("AppDarkRed")))
                                            .scaleEffect(0.8)
                                            .padding(.leading, 16)
                                        Spacer()
                                    }
                                }
                                
                                Color.clear.frame(height: 20)
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(maxHeight: .infinity)
                        .transition(.opacity)
                        .onChange(of: viewModel.messages.count) { oldValue, newValue in
                            if let lastMessage = viewModel.messages.last {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                TextInput(
                    text: $viewModel.currentInput,
                    onSend: {
                        Task {
                            await viewModel.sendMessage(viewModel.currentInput)
                        }
                    }
                )
                .frame(height: 60)
                .padding(.horizontal, 20)
                .padding(.bottom, 25)
                .padding(.top, 10)
            }
            
            if !viewModel.messages.isEmpty {
                TopSideOpened()
                    .padding(.top, -110)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.messages.isEmpty)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("AppBG"))
        .hideKeyboardOnTap()
        .toolbar {
            if !viewModel.messages.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            viewModel.resetChat()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Color("AppDarkRed"))
                    }
                }
            }
        }
    }
}
