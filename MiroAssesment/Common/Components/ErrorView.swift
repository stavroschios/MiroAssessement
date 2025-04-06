import SwiftUI

struct ErrorView: View {
    let error: NetworkError
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: Constants.Spacing.large) {
            Image(systemName: errorIcon)
                .font(.system(size: 64))
                .foregroundColor(Constants.Colors.error)
                .padding(.bottom, Constants.Spacing.small)
            
            Text(errorTitle)
                .font(.system(size: Constants.FontSize.large, weight: .bold))
                .foregroundColor(Constants.Colors.primaryText)
                .multilineTextAlignment(.center)
            
            Text(error.localizedDescription)
                .font(.system(size: Constants.FontSize.medium))
                .foregroundColor(Constants.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: retryAction) {
                Text("Try Again")
                    .primaryButtonStyle()
            }
            .padding(.top, Constants.Spacing.medium)
        }
        .padding(Constants.Spacing.extraLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.Colors.primaryBackground)
    }
    
    private var errorIcon: String {
        switch error {
        case .userNotFound:
            return "person.slash"
        case .invalidURL:
            return "link.slash"
        case .httpError:
            return "exclamationmark.triangle"
        default:
            return "xmark.octagon"
        }
    }
    
    private var errorTitle: String {
        switch error {
        case .userNotFound:
            return "User Not Found"
        case .invalidURL:
            return "Invalid URL"
        case .httpError:
            return "Server Error"
        default:
            return "Something Went Wrong"
        }
    }
} 