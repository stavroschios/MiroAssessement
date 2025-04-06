import SwiftUI

struct SkeletonView: View {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    @State private var isAnimating = false
    
    init(width: CGFloat, height: CGFloat, cornerRadius: CGFloat = Constants.CornerRadius.small) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Constants.Colors.skeletonDark,
                            Constants.Colors.skeletonLight,
                            Constants.Colors.skeletonDark
                        ]
                    ),
                    startPoint: .leading,
                    endPoint: UnitPoint(x: isAnimating ? 2 : 0, y: 0)
                )
            )
            .frame(width: width, height: height)
            .onAppear {
                withAnimation(Animation.linear(duration: Constants.Animations.skeletonDuration).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}
