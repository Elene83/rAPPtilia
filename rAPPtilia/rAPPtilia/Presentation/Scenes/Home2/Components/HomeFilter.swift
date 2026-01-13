import SwiftUI

struct HomeFilter: View {
    @Binding var filters: ReptileFilters
    var allReptiles: [Reptile]
    var onFilterChanged: () -> Void
    
    private var availableTypes: [String] {
        Array(Set(allReptiles.map { $0.order })).sorted()
    }
    
    private var availableColors: [String] {
        var seen = Set<String>()
        var result: [String] = []
        
        for reptile in allReptiles {
            if let firstColor = reptile.color.first {
                let lowercased = firstColor.lowercased()
                if !seen.contains(lowercased) {
                    seen.insert(lowercased)
                    result.append(firstColor)
                }
            }
        }
        
        return result.sorted()
    }
    
    private var availableHeadShapes: [String] {
        Array(Set(allReptiles.map { $0.headShape })).sorted()
    }
    
    private var availableActivityPeriods: [String] {
        var seen = Set<String>()
        var result: [String] = []
        
        for reptile in allReptiles {
            let trimmed = reptile.activityPeriod.trimmingCharacters(in: .whitespacesAndNewlines)
            let lowercased = trimmed.lowercased()
            if !seen.contains(lowercased) {
                seen.insert(lowercased)
                result.append(trimmed)
                }
            }
            return result.sorted()
        }
    
    private var availableTemperaments: [String] {
        Array(Set(allReptiles.map { $0.temperament })).sorted()
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Filter by")
                    .foregroundStyle(Color("AppDarkRed"))
                    .font(.custom("Firago-Regular", size: 14))
                    .padding(.horizontal, 15)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        HomeFilterCell(
                            title: "Type",
                            selectedValue: filters.order,
                            options: availableTypes,
                            onSelect: { value in
                                filters.order = value
                                onFilterChanged()
                            }
                        )
                        
                        HomeFilterBoolCell(
                            title: "Venomous",
                            selectedValue: filters.venomous,
                            onSelect: { value in
                                filters.venomous = value
                                onFilterChanged()
                            }
                        )
                        
                        HomeFilterCell(
                            title: "Color",
                            selectedValue: filters.color,
                            options: availableColors,
                            onSelect: { value in
                                filters.color = value
                                onFilterChanged()
                            }
                        )
                        
                        HomeFilterCell(
                            title: "Head Shape",
                            selectedValue: filters.headshape,
                            options: availableHeadShapes,
                            onSelect: { value in
                                filters.headshape = value
                                onFilterChanged()
                            }
                        )
                        
                        HomeFilterCell(
                            title: "Activity",
                            selectedValue: filters.activityPeriod,
                            options: availableActivityPeriods,
                            onSelect: { value in
                                filters.activityPeriod = value
                                onFilterChanged()
                            }
                        )
                        
                        HomeFilterCell(
                            title: "Temperament",
                            selectedValue: filters.temperament,
                            options: availableTemperaments,
                            onSelect: { value in
                                filters.temperament = value
                                onFilterChanged()
                            }
                        )
                        
                        if hasActiveFilters {
                            Button(action: clearFilters) {
                                HStack(spacing: 6) {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("Clear")
                                }
                                .font(.custom("Firago-Regular", size: 10))
                                .foregroundColor(Color("AppDarkRed"))
                                .padding(8)
                                .background(Color("AppDarkRed").opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    var hasActiveFilters: Bool {
        filters.order != nil || filters.venomous != nil ||
        filters.color != nil || filters.headshape != nil || filters.activityPeriod != nil ||
        filters.temperament != nil
    }
    
    func clearFilters() {
        filters = ReptileFilters()
        onFilterChanged()
    }
}

