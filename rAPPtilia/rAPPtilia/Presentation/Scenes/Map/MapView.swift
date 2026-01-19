import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel: MapViewModel
    @State private var selectedLocation: LocationModel?
    
    var body: some View {
        ZStack {
            mapLayer
            filterBar
            addLocationOverlay
            locationControls
            addButton
            imagePreviewOverlay
            locationDetailOverlay
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
        .onAppear {
            viewModel.loadData()
        }
        .animation(.easeInOut, value: viewModel.isAddingLocation)
        .animation(.easeInOut, value: viewModel.currentStep)
        .animation(.easeInOut, value: selectedLocation != nil)
    }
    
    private var mapLayer: some View {
        MapReader { proxy in
            Map(position: $viewModel.cameraPosition, selection: $selectedLocation) {
                ForEach(viewModel.filteredLocations) { location in
                    if let reptile = viewModel.getReptile(for: location) {
                        Annotation("", coordinate: location.coordinate) {
                            LocationAnnotationView(
                                reptile: reptile,
                                isUserLocation: location.userId == viewModel.profile?.id
                            )
                        }
                        .tag(location)
                    }
                }
                UserAnnotation()
            }
            .mapStyle(.standard)
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .onTapGesture { screenCoordinate in
                if viewModel.currentStep == .markLocation {
                    if let coordinate = proxy.convert(screenCoordinate, from: .local) {
                        viewModel.handleMapTap(at: coordinate)
                    }
                }
            }
        }
    }
    
    private var filterBar: some View {
        VStack {
            HStack(spacing: 12) {
                MapFilterCell(
                    title: "All reptiles",
                    selectedValue: viewModel.selectedSpeciesFilter,
                    options: viewModel.availableSpecies,
                    onSelect: { species in
                        viewModel.setSpeciesFilter(species)
                    }
                )
                
                Spacer()
               
                MapFilterCell(
                    title: "Type",
                    selectedValue: viewModel.selectedOrderFilter,
                    options: viewModel.availableOrders,
                    onSelect: { order in
                        viewModel.setOrderFilter(order)
                    }
                )
            }
            .padding()
            .padding(.top, 20)
            
            Spacer()
        }
    }
    
    private var addLocationOverlay: some View {
        Group {
            if viewModel.isAddingLocation {
                ZStack {
                    if viewModel.currentStep != .markLocation {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                if viewModel.currentStep == .selectSpecies {
                                    viewModel.goBackToSpeciesSelection()
                                }
                            }
                    }
                    
                    modalContent
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private var modalContent: some View {
        VStack {
            Spacer()
            switch viewModel.currentStep {
            case .selectOrder:
                OrderSelectionModal(viewModel: viewModel)
            case .markLocation:
                MarkLocationInstructionView()
                    .allowsHitTesting(false)
            case .selectSpecies:
                SpeciesSelectionModal(viewModel: viewModel)
            }
            Spacer()
        }
        .allowsHitTesting(viewModel.currentStep != .markLocation)
    }
    
    private var locationControls: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    if let userLocation = viewModel.userLocation {
                        viewModel.cameraPosition = .region(MKCoordinateRegion(
                            center: userLocation,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))
                    }
                } label: {
                    Image(systemName: "location.fill")
                        .foregroundColor(Color("AppDarkGreen"))
                        .font(.system(size: 20))
                        .frame(width: 21, height: 21)
                        .padding(16)
                        .background(Color("AppBG"))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.leading, 20)
                .padding(.bottom, 20)
                
                Spacer()
            }
        }
    }
    
    private var addButton: some View {
        Group {
            if viewModel.isLoggedIn {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddLocationButton(viewModel: viewModel)
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
        .zIndex(999)
    }
    
    private var imagePreviewOverlay: some View {
        Group {
            if viewModel.showingImagePreview {
                ImageOverlay(
                    isPresented: $viewModel.showingImagePreview,
                    imageUrl: viewModel.previewImageUrl ?? ""
                )
                .zIndex(1000)
            }
        }
    }
    
    private var locationDetailOverlay: some View {
        Group {
            if let location = selectedLocation {
                LocationDetailModal(
                    location: location,
                    reptile: viewModel.getReptile(for: location),
                    canDelete: location.userId == viewModel.profile?.id,
                    onDelete: {
                        viewModel.removeLocation(location)
                        selectedLocation = nil
                    },
                    onDismiss: {
                        selectedLocation = nil
                    }
                )
                .zIndex(1001)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
}
