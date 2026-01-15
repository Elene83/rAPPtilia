import SwiftUI

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel
    
    var body: some View {
        VStack {
            if vm.isLoggedIn {
                VStack(alignment: .leading, spacing: 0) {
                    Text(vm.profile?.fullName ?? "Profile Name")
                        .font(.custom("Firago-Medium", size: 16))
                        .foregroundStyle(Color("AppDarkGreen"))
                        .padding(.top, 20)

                    Text(vm.profile?.username ?? "Username")
                        .font(.custom("Firago-Regular", size: 14))
                        .foregroundStyle(Color("AppDarkGreen"))
                        .padding(.top, 10)
                    
                    Text("Your Reptiles")
                        .font(.custom("Firago-Medium", size: 16))
                        .foregroundStyle(Color("AppDarkGreen"))
                        .padding(.top, 20)

                    if vm.isLoadingReptiles {
                        ProgressView()
                            .padding(.top)
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("AppDarkRed")))
                    } else if !vm.userReptiles.isEmpty {
                        ProfileReptiles(reptiles: vm.userReptiles, onRemove: vm.removeFavorite)
                            .padding(.top, 15)
                    } else {
                        Text("No reptiles yet 🦎")
                            .font(.custom("Firago-Regular", size: 14))
                            .foregroundStyle(Color("AppDarkGreen"))
                            .padding(.top, 15)
                    }
                    
                    Text("Your Locations")
                        .font(.custom("Firago-Medium", size: 16))
                        .foregroundStyle(Color("AppDarkGreen"))
                        .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Log Out") {
                    vm.logOut()
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(Color("AppOrange"))
                .foregroundStyle(Color("AppBG"))
                .font(.custom("Firago-Regular", size: 18))
                .cornerRadius(4)
                .padding(.bottom, 30)
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
