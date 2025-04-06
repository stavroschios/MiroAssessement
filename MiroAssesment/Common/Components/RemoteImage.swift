import SwiftUI
import UIKit

enum ImageHelper {
    static func createImage(from data: Data) -> UIImage? {
        UIImage(data: data)
    }
}

struct RemoteImage: View {
    private let url: URL?
    private let placeholder: Image
    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(
        url: URL?,
        placeholder: Image = Image(
            systemName: "person.circle.fill"
        )
    ) {
        self.url = url
        self.placeholder = placeholder
    }
    
    init(
        githubUsername: String,
        size: Int = 400,
        placeholder: Image = Image(
            systemName: "person.circle.fill"
        )
    ) {
        self.url = Constants.GitHub
            .avatarURL(
                username: githubUsername,
                size: size
            )
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ZStack {
                    Circle()
                        .fill(Constants.Colors.secondaryBackground)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Constants.Colors.accent))
                }
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Constants.Colors.secondaryText)
                    .background(Constants.Colors.secondaryBackground)
                    .clipShape(Circle())
            }
        }
        .onAppear {
            if let url = url, let cachedImage = ImageCache.shared.getImage(
                for: url
            ) {
                self.image = cachedImage
            } else {
                loadImage()
            }
        }
    }
    
    private func loadImage() {
        guard !isLoading, image == nil, let url = url else { return }
        
        // Prevent double loading
        isLoading = true
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let downloadedImage = UIImage(data: data) else {
                    await MainActor.run {
                        self.isLoading = false
                    }
                    return
                }
                
                ImageCache.shared.setImage(downloadedImage, for: url)
                
                await MainActor.run {
                    self.image = downloadedImage
                    self.isLoading = false
                }
            } catch {
                print("Failed to load image: \(error.localizedDescription)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}
