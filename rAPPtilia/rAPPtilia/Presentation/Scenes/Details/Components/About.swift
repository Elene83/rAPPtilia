import SwiftUI

struct About: View {
    var description: String
    var suborder: String
    var family: String
    var species: String
    
    var parts: [String] {
        description.splitText(maxSentences: 4)
    }
    
    var taxonomyLine: String {
        "Kingdom Animalia → Subphylum Vertebrates → Class Reptilia → Suborder \(suborder) → Family \(family) → Species \(species)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About")
                .font(.custom("Firago-Medium", size: 16))
                .foregroundStyle(Color("AppBrown"))
            
            ForEach(parts, id: \.self) { part in
                Text(part)
                    .font(.custom("Firago-Regular", size: 12))
                    .foregroundStyle(Color("AppBrown"))
                    .padding(.bottom, 10)
            }
            
            Text("Taxonomy")
                .font(.custom("Firago-Medium", size: 16))
                .foregroundStyle(Color("AppBrown"))
            Text(taxonomyLine)
                .font(.custom("Firago-Regular", size: 12))
                .foregroundStyle(Color("AppBrown"))
        }
        .padding(.bottom, 20)
    }
}
