import Foundation
import UIKit

class FeedImageCell: UITableViewCell {
    let locationContainer = UIView()
    let locationLabel = UILabel()
    let descriptionLabel = UILabel()
    let feedImageContainer = UIView()
    let feedImageView = UIImageView()
    
    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onRetry: (() -> Void)?
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
