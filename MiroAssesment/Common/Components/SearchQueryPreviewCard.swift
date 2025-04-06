import SwiftUI

struct SearchQueryPreviewCard: View {
    var searchText: String
    var onSubmit: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Search for: ")
                    .foregroundColor(Constants.Colors.secondaryText)
                
                Text(searchText)
                    .foregroundColor(Constants.Colors.primaryText)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: onSubmit) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Constants.Colors.accent)
                }
            }
            .padding()
            .cardStyle()
            
            Spacer()
        }
    }
}
