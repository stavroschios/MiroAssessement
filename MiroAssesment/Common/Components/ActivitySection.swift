import SwiftUI

struct ActivityFeedSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            Text("Today's Activity")
                .font(.system(size: Constants.FontSize.medium, weight: .semibold))
                .foregroundColor(Constants.Colors.primaryText)
                .padding(.horizontal, Constants.Spacing.small)
            
            VStack(spacing: Constants.Spacing.small) {
                ActivityFeedItem(icon: "star.fill", color: .yellow, title: "New trending repositories", subtitle: "React, Flutter and TensorFlow are trending today")
                
                Divider()
                    .background(Constants.Colors.divider)
                    .padding(.horizontal)
                
                ActivityFeedItem(icon: "bell.fill", color: Constants.Colors.accent, title: "GitHub Universe", subtitle: "Register for the online developer event")
                
                Divider()
                    .background(Constants.Colors.divider)
                    .padding(.horizontal)
                
                ActivityFeedItem(icon: "person.2.fill", color: .blue, title: "Team collaboration", subtitle: "4 pull requests need your review")
            }
            .cardStyle()
        }
    }
}
