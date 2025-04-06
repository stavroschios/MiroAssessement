import SwiftUI

struct GitHubAvatarView: View {

    let username: String
    let size: CGFloat
    
    init(username: String, size: CGFloat = Constants.ImageSize.smallAvatar) {
        self.username = username
        self.size = size
    }
    
    var body: some View {
        RemoteImage(githubUsername: username, size: Int(size))
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

#Preview {
    GitHubAvatarViewPreview()
}

private struct GitHubAvatarViewPreview: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                GitHubAvatarView(username: "octocat", size: 100)
                GitHubAvatarView(username: "apple", size: 60)
                GitHubAvatarView(username: "nonexistent", size: 40)
            }
        }
    }
}
