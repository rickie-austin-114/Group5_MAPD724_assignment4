import SwiftUI
import Photos
import PhotosUI

struct ContentView: View {
    @State var showPhotoSelector = false
    @State var selectedPhoto: [PhotosPickerItem] = []
    @State var selectedImages: [Image] = []
    
    var body: some View {
        ZStack {
            // Fullscreen LinearGradient background
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue, Color.red]),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Button("Select Photo") {
                    showPhotoSelector = true
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                
                // Horizontal ScrollView for selected images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            selectedImages[index]
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal)
                }
                // Use containerRelativeFrame instead of GeometryReader
                .containerRelativeFrame(.vertical) { height, _ in
                    height * 0.20 // 20% of container height
                }
            }
        }
        .photosPicker(isPresented: $showPhotoSelector,
                     selection: $selectedPhoto,
                     matching: .images,
                     preferredItemEncoding: .compatible)
        .onChange(of: selectedPhoto) { oldValue, newValue in
            handlePhotoSelection(newValue)
        }
    }
    
    private func handlePhotoSelection(_ newValue: [PhotosPickerItem]) {
        Task {
            selectedImages.removeAll()
            
            // Limit to 5 photos
            let photosToProcess = Array(newValue.prefix(5))
            
            for photo in photosToProcess {
                do {
                    if let image = try await loadImage(from: photo) {
                        await MainActor.run {
                            selectedImages.append(image)
                        }
                    }
                } catch {
                    print("Error loading image: \(error)")
                }
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem) async throws -> Image? {
        try await item.loadTransferable(type: Image.self)
    }
}
