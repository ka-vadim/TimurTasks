import UIKit
import SnapKit

private let coolColors: [UIColor] = [.red, .magenta, .blue, .black, .orange, .purple, .brown, .link] // random colors

class ImageGalleryCell: UICollectionViewCell {
    static let reuseID = "ImageGalleryCell"
    static let choosedBackgroundColor = UIColor.tertiarySystemBackground
    
    let cellImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(cellImageView)
        self.tintColor = coolColors[Int.random(in: 0..<coolColors.count)]
        self.selectedBackgroundView = {
            let background = UIView()
            background.backgroundColor = ImageGalleryCell.choosedBackgroundColor
            return background
        }()
        
        cellImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func animateChoose() {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

#Preview {
    {
        let cell = ImageGalleryCell()
        cell.cellImageView.image = UIImage(systemName: "square.and.arrow.up.circle.fill")
        return cell
    }()
}
