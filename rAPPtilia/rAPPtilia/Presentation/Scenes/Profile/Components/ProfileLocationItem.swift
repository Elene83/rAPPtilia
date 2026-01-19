import SwiftUI

struct ProfileLocationItem: View {
    var address: String
    var date: String
    var onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Rectangle()
                .fill(Color("AppListsGreen"))
                .frame(maxWidth: .infinity)
                .frame(height: 35)
                .overlay {
                    HStack {
                        Text("\(address) - \(date)")
                            .font(.custom("FiraGO-Medium", size: 14))
                            .foregroundColor(Color("AppDarkGreen"))
                            .padding(.vertical, 9)
                            .padding(.horizontal, 11)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button(action: onRemove) {
                            Image("binIcon")
                                .frame(height: 14)
                        }
                        .padding(.trailing, 17)
                    }
                }
        }
    }
}
