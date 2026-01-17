import SwiftUI

struct HomeCards: View {
    @ObservedObject var vm: HomeViewModel
    weak var coordinator: MainCoordinator?
    let navigationController: UINavigationController?
    
    @State private var currentPage: Int = 0
    @State private var selectedOrder: String? = nil
    @State private var dragOffset: CGFloat = 0
    @State private var hasUserSwiped: Bool = false
    
    private let pageCount = 2
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(uiColor: UIColor(named: "AppBG") ?? .systemBackground)
                    .ignoresSafeArea()
                
                if let order = selectedOrder {
                    ReptileGridView(
                        reptiles: vm.reptiles.filter {
                            $0.order.uppercased() == order.uppercased()
                        },
                        order: order,
                        coordinator: coordinator,
                        navigationController: navigationController,
                        onBack: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedOrder = nil
                            }
                        }
                    )
                    .transition(.move(edge: .trailing))
                } else {
                    HStack(spacing: 0) {
                        ReptiliaCardView(hasUserSwiped: $hasUserSwiped)
                            .frame(width: geometry.size.width)
                        
                        OrderCardsView(onOrderTapped: { order in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedOrder = order
                            }
                        })
                        .frame(width: geometry.size.width)
                    }
                    .offset(x: -CGFloat(currentPage) * geometry.size.width + dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let threshold: CGFloat = 50
                                
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    if value.translation.width < -threshold && currentPage < pageCount - 1 {
                                        currentPage += 1
                                        hasUserSwiped = true
                                    } else if value.translation.width > threshold && currentPage > 0 {
                                        currentPage -= 1
                                    }
                                    dragOffset = 0
                                }
                            }
                    )
                }
            }
        }
    }
}
