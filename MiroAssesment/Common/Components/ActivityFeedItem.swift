import SwiftUI

struct ActivityFeedItem: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: Constants.Spacing.medium) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 20))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: Constants.Spacing.tiny) {
                Text(title)
                    .font(.system(size: Constants.FontSize.medium, weight: .medium))
                    .foregroundColor(Constants.Colors.primaryText)
                
                Text(subtitle)
                    .font(.system(size: Constants.FontSize.small))
                    .foregroundColor(Constants.Colors.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Constants.Colors.secondaryText)
                .font(.system(size: Constants.FontSize.small))
        }
        .padding()
    }
} 
