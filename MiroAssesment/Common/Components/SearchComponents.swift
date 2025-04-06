import SwiftUI

struct GitHubSearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    var onSubmit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? 
                    Constants.Colors.secondaryText : Constants.Colors.accent
                )
            
            TextField("Search GitHub users", text: $searchText)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit(onSubmit)
                .foregroundColor(Constants.Colors.primaryText)
                .font(.system(size: Constants.FontSize.medium))
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    isSearching = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Constants.Colors.secondaryText)
                }
            }
        }
        .searchBarStyle()
    }
}
