import SwiftUI

struct RecentUsersHorizontalList: View {
    let searchHistory: [String]
    let onNavigateToUser: (String) -> Void
    let onClearHistory: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            HStack {
                Text("Recently Searched")
                    .font(.system(size: Constants.FontSize.medium, weight: .semibold))
                    .foregroundColor(Constants.Colors.primaryText)
                
                Spacer()
                
                Button(action: onClearHistory) {
                    Text("Clear")
                        .font(.system(size: Constants.FontSize.small))
                        .foregroundColor(Constants.Colors.accent)
                }
            }
            .padding(.horizontal, Constants.Spacing.small)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.Spacing.medium) {
                    ForEach(searchHistory.prefix(5), id: \.self) { username in
                        Button {
                            onNavigateToUser(username)
                        } label: {
                            VStack(spacing: Constants.Spacing.small) {
                                GitHubAvatarView(username: username, size: 60)
                                
                                Text(username)
                                    .foregroundColor(Constants.Colors.primaryText)
                                    .font(.system(size: Constants.FontSize.small))
                                    .lineLimit(1)
                                    .frame(width: 80)
                            }
                            .padding(.vertical, Constants.Spacing.small)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
