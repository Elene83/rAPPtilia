import SwiftUI

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel
    
    @State private var isEditingFullName = false
    @State private var isEditingUsername = false
    @State private var editedFullName = ""
    @State private var editedUsername = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case fullName, username
    }
    
    var body: some View {
        VStack {
            if vm.isLoggedIn {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            if isEditingFullName {
                                TextField("Full Name", text: $editedFullName)
                                    .font(.custom("Firago-Medium", size: 16))
                                    .foregroundStyle(Color("AppDarkGreen"))
                                    .textFieldStyle(.plain)
                                    .focused($focusedField, equals: .fullName)
                                    .onAppear {
                                        editedFullName = vm.profile?.fullName ?? ""
                                    }
                            } else {
                                HStack {
                                    Text(vm.profile?.fullName ?? "Profile Name")
                                        .font(.custom("Firago-Medium", size: 16))
                                        .foregroundStyle(Color("AppDarkGreen"))
                                    
                                    Image(systemName: "pencil")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color("AppDarkGreen").opacity(0.5))
                                }
                                .onTapGesture {
                                    isEditingFullName = true
                                    editedFullName = vm.profile?.fullName ?? ""
                                    focusedField = .fullName
                                }
                            }
                            
                            Spacer()
                            
                            if isEditingFullName {
                                Button("Save") {
                                    vm.updateFullName(editedFullName)
                                    isEditingFullName = false
                                    focusedField = nil
                                }
                                .font(.custom("Firago-Medium", size: 14))
                                .foregroundStyle(Color("AppOrange"))
                                .disabled(editedFullName.isEmpty || editedFullName == vm.profile?.fullName)
                            }
                        }
                        .padding(.top, 30)

                        HStack {
                            if isEditingUsername {
                                TextField("Username", text: $editedUsername)
                                    .font(.custom("Firago-Regular", size: 14))
                                    .foregroundStyle(Color("AppDarkGreen"))
                                    .textFieldStyle(.plain)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($focusedField, equals: .username)
                                    .onAppear {
                                        editedUsername = vm.profile?.username ?? ""
                                    }
                            } else {
                                HStack {
                                    Text(vm.profile?.username ?? "Username")
                                        .font(.custom("Firago-Regular", size: 14))
                                        .foregroundStyle(Color("AppDarkGreen"))
                                    
                                    Image(systemName: "pencil")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Color("AppDarkGreen").opacity(0.5))
                                }
                                .onTapGesture {
                                    isEditingUsername = true
                                    editedUsername = vm.profile?.username ?? ""
                                    focusedField = .username
                                }
                            }
                            
                            Spacer()
                            
                            if isEditingUsername {
                                Button("Save") {
                                    vm.updateUsername(editedUsername)
                                    isEditingUsername = false
                                    focusedField = nil
                                }
                                .font(.custom("Firago-Medium", size: 14))
                                .foregroundStyle(Color("AppOrange"))
                                .disabled(editedUsername.isEmpty || editedUsername == vm.profile?.username)
                            }
                        }
                        .padding(.top, 10)
                        
                        if vm.isUpdatingProfile {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("AppOrange")))
                                    .scaleEffect(0.8)
                                Text("Updating...")
                                    .font(.custom("Firago-Regular", size: 12))
                                    .foregroundStyle(Color("AppDarkGreen").opacity(0.6))
                            }
                            .padding(.top, 8)
                        }
                        
                        if let errorMessage = vm.errorMessage {
                            Text(errorMessage)
                                .font(.custom("Firago-Regular", size: 12))
                                .foregroundStyle(Color("AppRed"))
                                .padding(.top, 8)
                        }
                        
                        Text("Your Reptiles")
                            .font(.custom("Firago-Medium", size: 16))
                            .foregroundStyle(Color("AppDarkGreen"))
                            .padding(.top, 30)

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
                            .padding(.top, 30)
                        
                        if vm.isLoadingLocations {
                            ProgressView()
                                .padding(.top)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("AppDarkRed")))
                        } else if !vm.userLocations.isEmpty {
                            ProfileLocations(
                                locations: vm.userLocations,
                                getLocationAddress: vm.getLocationAddress,
                                onRemove: vm.removeLocation
                            )
                            .padding(.top, 15)
                        } else {
                            Text("No locations yet 📍")
                                .font(.custom("Firago-Regular", size: 14))
                                .foregroundStyle(Color("AppDarkGreen"))
                                .padding(.top, 15)
                        }
                    }
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .onTapGesture {
                    if isEditingFullName || isEditingUsername {
                        isEditingFullName = false
                        isEditingUsername = false
                        focusedField = nil
                    }
                }
                
                Button("Log Out") {
                    vm.logOut()
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(Color("AppOrange"))
                .foregroundStyle(Color("AppStaticBG"))
                .font(.custom("Firago-Regular", size: 18))
                .cornerRadius(4)
                .padding(.bottom, 30)
            } else {
                ScrollView {
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
                    .padding(.top, 70)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBG"))
    }
}
