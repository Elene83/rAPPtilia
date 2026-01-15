import SwiftUI

struct ProfileReptiles: View {
    var name: String
    var scientificName: String
    
    var body: some View {
        VStack(spacing: 10) {
            ScrollView() {
                Rectangle()
                    .fill(Color("AppLightGreen"))
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
                            
                            Image("binIcon")
                                .foregroundColor(Color("AppDarkGreen"))
                                .padding(.trailing, 11)
                        }
                    }
            }
        }
    }
}
