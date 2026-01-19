import SwiftUI

struct LocationDetailModal: View {
    let location: LocationModel
    let reptile: Reptile?
    let canDelete: Bool
    let onDelete: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    if let reptile = reptile {
                        HStack(alignment: .top, spacing: 20) {
                            CachedAsyncImage(url: URL(string: reptile.thumbnailUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Color("AppLightBrown")
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(reptile.commonName)
                                    .font(.custom("Firago-SemiBold", size: 16))
                                    .foregroundColor(Color("AppOrangeFont"))
                                
                                Text(reptile.name)
                                    .font(.custom("Firago-Light", size: 14))
                                    .foregroundColor(Color("AppOrangeFont"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Size Range")
                                    .font(.custom("Firago-Regular", size: 12))
                                    .foregroundColor(Color("AppLightBrown"))
                                Text(reptile.sizeRange)
                                    .font(.custom("Firago-Medium", size: 12))
                                    .foregroundColor(Color("AppBrown"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Temperament")
                                    .font(.custom("Firago-Regular", size: 12))
                                    .foregroundColor(Color("AppLightBrown"))
                                Text(reptile.temperament)
                                    .font(.custom("Firago-Medium", size: 12))
                                    .foregroundColor(Color("AppBrown"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Venom")
                                    .font(.custom("Firago-Medium", size: 12))
                                    .foregroundColor(Color("AppLightBrown"))
                                Text(reptile.venom ? "Venomous" : "Non-venomous")
                                    .font(.custom("Firago-Medium", size: 12))
                                    .foregroundColor(Color("AppBrown"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 4) {
                                if canDelete {
                                    Text("Observed by you!")
                                        .font(.custom("Firago-Regular", size: 12))
                                        .foregroundColor(Color("AppLightBrown"))
                                    
                                    Button(role: .destructive) {
                                        onDelete()
                                    } label: {
                                        Text("Delete Location")
                                            .font(.custom("Firago-Medium", size: 12))
                                            .foregroundStyle(Color("AppRed"))
                                    }
                                } else {
                                    Text("Observed by")
                                        .font(.custom("Firago-Regular", size: 12))
                                        .foregroundColor(Color("AppLightBrown"))
                                    Text(location.userId)
                                        .font(.custom("Firago-Regular", size: 12))
                                        .foregroundColor(Color("AppBrown"))
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                //detalebze gadasvla
                            } label: {
                                Text("Read More")
                                    .font(.custom("Firago-Medium", size: 14))
                                    .foregroundColor(Color("AppOrangeFont"))
                            }
                        }
                    }
                }
                .padding()
            }
            .frame(width: 360, height: 200)
            .background(Color("AppBG"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .transition(.scale.combined(with: .opacity))
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: reptile != nil)
    }
}
