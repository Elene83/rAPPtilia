import SwiftUI

struct StatusView: View {
    //MARK: Properties
    let isUpdating: Bool
    let errorMessage: String?
    let successMessage: String?
    
    var body: some View {
        VStack(spacing: 10) {
            if isUpdating {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("AppOrange")))
                        .scaleEffect(0.8)
                    Text("Processing...")
                        .font(.custom("Firago-Regular", size: 12))
                        .foregroundStyle(Color("AppDarkGreen").opacity(0.6))
                }
                .frame(maxWidth: .infinity)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.custom("Firago-Regular", size: 12))
                    .foregroundStyle(Color("AppRed"))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            if let successMessage = successMessage {
                Text(successMessage)
                    .font(.custom("Firago-Regular", size: 12))
                    .foregroundStyle(Color("AppDarkGreen"))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
