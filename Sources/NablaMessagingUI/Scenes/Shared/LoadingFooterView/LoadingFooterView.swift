import Foundation
import NablaCoreFork
import UIKit

class LoadingFooterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(
            width: size.width,
            height: 50.0
        )
    }
    
    // MARK: - Private
    
    private func setup() {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = NablaTheme.Shared.loadingViewIndicatorTintColor
        activityIndicatorView.startAnimating()
        addSubview(activityIndicatorView)
        activityIndicatorView.nabla.constraintToCenterInSuperView()
    }
}
