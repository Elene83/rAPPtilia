import SwiftUI

struct OrderSelectionModal: View {
    @ObservedObject var viewModel: MapViewModel
    
    let orders = ["Snake", "Lizard", "Turtle"]
    let orderMapping = [
        "Turtle": "Testudines",
        "Snake": "Serpentes",
        "Lizard": "Sauria"
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            Text("What did you find?")
                .font(.custom("Firago-SemiBold", size: 14))
                .foregroundColor(Color("AppOrangeFont"))
            
            HStack(spacing: 14) {
                ForEach(orders, id: \.self) { order in
                    Button {
                        if let actualOrder = orderMapping[order] {
                            viewModel.selectOrder(actualOrder)
                        }
                    } label: {
                        Text(order)
                            .font(.custom("Firago-Regular", size: 14))
                            .foregroundColor(Color("AppOrangeFont"))
                            .padding()
                    }
                }
            }
        }
        .padding(10)
        .padding(.top, 10)
        .background(Color("AppBG"))
        .cornerRadius(10)
        .frame(maxWidth: 300)
    }
}
