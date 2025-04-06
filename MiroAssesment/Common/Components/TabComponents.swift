import SwiftUI

struct TabNavigationBar: View {
    let tabs: [String]
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation {
                        selectedTab = index
                    }
                }) {
                    Text(tabs[index])
                        .font(.system(size: Constants.FontSize.medium, weight: selectedTab == index ? .semibold : .regular))
                        .foregroundColor(selectedTab == index ? Constants.Colors.accent : Constants.Colors.secondaryText)
                        .padding(.vertical, Constants.Spacing.small)
                        .padding(.horizontal, Constants.Spacing.medium)
                        .background(
                            selectedTab == index ? 
                                Constants.Colors.secondaryBackground :
                                Constants.Colors.primaryBackground
                        )
                        .cornerRadius(Constants.CornerRadius.medium)
                }
            }
            
            Spacer()
        }
        .padding(.bottom, Constants.Spacing.small)
    }
}
