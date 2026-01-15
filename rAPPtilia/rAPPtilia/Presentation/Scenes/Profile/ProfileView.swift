import SwiftUI

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel
    
    var body: some View {
        VStack {
            if vm.isLoggedIn {
                VStack {
                    //danarcheni ragacebi
                    Button("Log Out") {
                        vm.logOut()
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(Color("AppOrange"))
                    .foregroundStyle(Color("AppBG"))
                    .font(.custom("Firago-Regular", size: 18))
                    .cornerRadius(4)
                }
            } else {
                VStack {
                    Image("darkgreenliz")
                        .padding(.bottom, 80)
                    Text("You are not logged in")
                        .font(.custom("Firago-Regular", size: 18))
                        .foregroundStyle(Color("AppRed"))
                        .padding(.bottom, 34)
                    Button("Log In") {
                        vm.showAuth()
                    }
                    .font(.custom("Firago-Medium", size: 20))
                    .foregroundStyle(Color("AppDarkGreen"))
                    
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBG"))
    }
}
