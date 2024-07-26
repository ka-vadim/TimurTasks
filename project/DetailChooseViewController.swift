import UIKit
import SnapKit

class DetailChooseViewController: UIViewController {
    private var detailImageView = UIImageView()
    
    func setImageDetails(_ image: UIImage, tintColor: UIColor) {
        detailImageView.image = image
        detailImageView.tintColor = tintColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedViews()
        setupAppearence()
        setupLayout()
    }
}


// MARK: - Setup appearence
private extension DetailChooseViewController {
    func setupAppearence() {
        self.navigationItem.title = "This is \(detailImageView.tintColor.accessibilityName)!"
        
        view.backgroundColor = .white
        
        detailImageView.contentMode = .scaleAspectFit
    }
}

// MARK: - Embed views
private extension DetailChooseViewController {
    func embedViews() {
        view.addSubview(detailImageView)
    }
}

// MARK: - Setup layout
private extension DetailChooseViewController {
    func setupLayout() {
        detailImageView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

#Preview {
    DetailChooseViewController()
}
