import SwiftUI
import Photos
import PhotosUI

struct ContentView: View {
    
    @State private var showPhotoSelector = false
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []
    
    var body: some View {
        ZStack {
            // Fullscreen LinearGradient background
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue, Color.red]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all) // Make the gradient fullscreen
            
            VStack {
                Button("Select Photos") {
                    showPhotoSelector = true
                }
                .padding()
                .background(Color.white.opacity(0.8)) // Slightly transparent background for the button
                .cornerRadius(10)
                .shadow(radius: 10) // Add shadow for better visibility
                
                Spacer()
                
                // Horizontal ScrollView for selected images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100) // Fixed size for images
                                .padding(4)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
                .frame(height: UIScreen.main.bounds.height / 5) // Height of 1/5 of the screen
            }
        }
        .photosPicker(isPresented: $showPhotoSelector, selection: $selectedPhotos, matching: .images, preferredItemEncoding: .compatible)
        .onChange(of: selectedPhotos) { _, newValue in
            Task {
                selectedImages.removeAll() // Clear previous images
                for photo in newValue.prefix(5) { // Limit to 5 photos
                    do {
                        if let image = try await loadImage(from: photo) {
                            selectedImages.append(image)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem) async throws -> Image? {
        guard let image = try await item.loadTransferable(type: Image.self) else {
            throw PHPhotosError(.invalidResource)
        }
        return image
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
