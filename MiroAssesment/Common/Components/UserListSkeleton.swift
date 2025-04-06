import SwiftUI

struct UserListSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            SkeletonView(
                width: 120,
                height: Constants.FontSize.small
            )
            .padding(.horizontal, Constants.Spacing.medium)
            
            VStack(spacing: Constants.Spacing.small) {
                ForEach(0..<5, id: \.self) { _ in
                    HStack(spacing: Constants.Spacing.medium) {
                        SkeletonView(
                            width: Constants.ImageSize.smallAvatar,
                            height: Constants.ImageSize.smallAvatar,
                            cornerRadius: Constants.ImageSize.smallAvatar / 2
                        )
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.tiny) {
                            SkeletonView(
                                width: 120,
                                height: Constants.FontSize.medium
                            )
                            
                            SkeletonView(
                                width: 80,
                                height: Constants.FontSize.tiny
                            )
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .cardStyle()
            .padding(.horizontal)
        }
        .padding(.top)
    }
} 
