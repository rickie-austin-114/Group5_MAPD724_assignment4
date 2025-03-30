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
                
                
                Button("Add Photo") {
                    showPhotoSelector = true
                }
                .padding(.top, 20) // Add some top padding, ensure the button located at the top of the screen
                .background(Color.white)
                .cornerRadius(10)

                Spacer() // use spacer to push the button to the top of the screen

                
                // Horizontal ScrollView for selected images
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            selectedImages[index]
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .padding(.horizontal)
                }
                .containerRelativeFrame(.vertical) { height, _ in
                    height * 0.20 // 20% of container height
                }
                
                Spacer()// use spacer to push the scrollview to the center of the screen

            }
            .frame(maxHeight: .infinity) // Ensures VStack takes full height of the screen
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
            // Limit to 5 photos, else print error message
            if newValue.count <= 5 {
                selectedImages.removeAll()
                for photo in newValue {
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
            } else {
                print("Error: Cannot select more than 5 images")
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem) async throws -> Image? {
        try await item.loadTransferable(type: Image.self)
    }
}
