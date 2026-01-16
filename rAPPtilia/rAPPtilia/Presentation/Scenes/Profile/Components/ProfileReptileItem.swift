import SwiftUI

struct ProfileReptileItem: View {
    var name: String
    var scientificName: String
    var onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            ScrollView() {
                Rectangle()
                    .fill(Color("AppListsGreen"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                    .overlay {
                        HStack {
                            Text("\(name) - \(scientificName)")
                                .font(.custom("FiraGO-Medium", size: 14))
                                .foregroundColor(Color("AppDarkGreen"))
                                .padding(.vertical, 9)
                                .padding(.horizontal, 11)
                            
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
}
