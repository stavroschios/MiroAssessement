import SwiftUI

struct UserProfileSkeleton: View {
    var body: some View {
        VStack(spacing: Constants.Spacing.medium) {
            SkeletonView(
                width: Constants.ImageSize.avatar,
                height: Constants.ImageSize.avatar,
                cornerRadius: Constants.ImageSize.avatar / 2
            )
            
            SkeletonView(
                width: 150,
                height: Constants.FontSize.extraLarge
            )
            
            SkeletonView(
                width: 200,
                height: Constants.FontSize.medium
            )
            
            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                SkeletonView(
                    width: 60,
                    height: Constants.FontSize.small
                )
                
                SkeletonView(
                    width: 300,
                    height: Constants.FontSize.medium * 3
                )
                .cardStyle()
            }
            
            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                SkeletonView(
                    width: 60,
                    height: Constants.FontSize.small
                )
                
                HStack {
                    VStack {
                        SkeletonView(
                            width: 80,
                            height: Constants.FontSize.medium
                        )
                        
                        SkeletonView(
                            width: 60,
                            height: Constants.FontSize.small
                        )
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        SkeletonView(
                            width: 80,
                            height: Constants.FontSize.medium
                        )
                        
                        SkeletonView(
                            width: 60,
                            height: Constants.FontSize.small
                        )
                    }
                    .frame(maxWidth: .infinity)
                }
                .cardStyle()
            }
        }
        .padding()
    }
}

