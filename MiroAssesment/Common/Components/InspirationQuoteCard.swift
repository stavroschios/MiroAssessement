import SwiftUI

struct InspirationQuoteCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            Text("Inspiration")
                .font(.system(size: Constants.FontSize.medium, weight: .semibold))
                .foregroundColor(Constants.Colors.primaryText)
                .padding(.horizontal, Constants.Spacing.small)
            
            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                Text("\"The only way to do great work is to love what you do. If you haven't found it yet, keep looking. Don't settle.\"")
                    .foregroundColor(Constants.Colors.primaryText)
                    .font(.system(size: Constants.FontSize.medium, weight: .medium))
                    .italic()
                    .padding()
                
                Text("– Steve Jobs")
                    .foregroundColor(Constants.Colors.secondaryText)
                    .font(.system(size: Constants.FontSize.small))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                    .padding(.bottom, Constants.Spacing.small)
            }
            .cardStyle()
        }
    }
} 