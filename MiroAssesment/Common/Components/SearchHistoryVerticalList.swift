import SwiftUI

struct SearchHistoryVerticalList: View {
    let searchHistory: [String]
    let onNavigateToUser: (String) -> Void
    let onClearHistory: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            HStack {
                Text("Recent Searches")
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
            
            VStack(spacing: 1) {
                ForEach(searchHistory, id: \.self) { username in
                    Button {
                        onNavigateToUser(username)
                    } label: {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(Constants.Colors.secondaryText)
                                .font(.system(size: Constants.FontSize.small))
                            
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
                    
                    if username != searchHistory.last {
                        Divider()
                            .background(Constants.Colors.divider)
                            .padding(.horizontal)
                    }
                }
            }
            .cardStyle()
        }
    }
} 
