import SwiftUI

struct LocationAnnotationView: View {
    let reptile: Reptile
    let isUserLocation: Bool
    
    var body: some View {
        Image(reptile.markerIcon)
            .resizable()
            .scaledToFit()
            .frame(width: reptile.markerSize, height: reptile.markerSize)
    }
}
