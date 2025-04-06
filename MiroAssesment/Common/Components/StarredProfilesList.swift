import SwiftUI

struct StarredProfilesList: View {
    var starredProfiles: [String]
    var onNavigateToUser: (String) -> Void
    
    @State private var showingAllStarred = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            Text("Starred Profiles")
                .font(.system(size: Constants.FontSize.medium, weight: .semibold))
                .foregroundColor(Constants.Colors.primaryText)
                .padding(.horizontal, Constants.Spacing.small)
            
            VStack(spacing: 1) {
                let displayProfiles = showingAllStarred ? starredProfiles : Array(starredProfiles.prefix(3))
                
                ForEach(displayProfiles, id: \.self) { username in
                    Button {
                        onNavigateToUser(username)
                    } label: {
                        HStack {
                            ZStack {
                                GitHubAvatarView(username: username, size: 32)
                                    .overlay(
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: Constants.FontSize.small))
                                            .offset(x: 12, y: -10)
                                    )
                            }
                            .padding(.trailing, 4)
                            
                            Text(username)
                                .foregroundColor(Constants.Colors.primaryText)
                                .font(.system(size: Constants.FontSize.medium))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Constants.Colors.secondaryText)
                                .font(.system(size: Constants.FontSize.small))
                        }
                        .padding()
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if username != displayProfiles.last {
                        Divider()
                            .background(Constants.Colors.divider)
                            .padding(.horizontal)
                    }
                }
                
                if starredProfiles.count > 3 && !showingAllStarred {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingAllStarred = true
                        }
                    } label: {
                        Text("See all \(starredProfiles.count) starred profiles")
                            .font(.system(size: Constants.FontSize.small))
                            .foregroundColor(Constants.Colors.accent)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                } else if showingAllStarred {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingAllStarred = false
                        }
                    } label: {
                        Text("Show less")
                            .font(.system(size: Constants.FontSize.small))
                            .foregroundColor(Constants.Colors.accent)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .cardStyle()
        }
    }
}
