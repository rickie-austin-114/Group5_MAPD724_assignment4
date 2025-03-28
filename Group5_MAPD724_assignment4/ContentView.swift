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
                    HStack {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            selectedImages[index]
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .padding(4)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
                .frame(height: UIScreen.main.bounds.height / 5)
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
