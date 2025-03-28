import SwiftUI
import Photos
import PhotosUI

struct ContentView: View {
    
    @State var showPhotoSelector = false
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedImage: Image?
    
    var body: some View {
        ZStack {
            // Fullscreen LinearGradient background
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue, Color.red]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all) // Make the gradient fullscreen
            
            VStack {
                Button("Select Photo") {
                    showPhotoSelector = true
                }
                .padding()
                .background(Color.white.opacity(0.8)) // Slightly transparent background for the button
                .cornerRadius(10)
                .shadow(radius: 10) // Add shadow for better visibility
                
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
            }
        }
        .photosPicker(isPresented: $showPhotoSelector, selection: $selectedPhoto, matching: .images, preferredItemEncoding: .compatible)
        .onChange(of: selectedPhoto) { _, newValue in
            Task {
                if let newValue {
                    do {
                        self.selectedImage = try await loadImage(from: newValue)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem) async throws -> Image {
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
