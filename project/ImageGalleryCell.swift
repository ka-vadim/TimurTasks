import UIKit
import SnapKit

private let coolColors: [UIColor] = [.red, .magenta, .blue, .black, .orange, .purple, .brown, .link] // random colors

class ImageGalleryCell: UICollectionViewCell {
    static let reuseID = "ImageGalleryCell"
    static let standartBackroundColor = UIColor.secondarySystemFill
    static let choosedBackgroundColor = UIColor.gray
    
    let cellImageView = UIImageView()
    
    func setImage(_ cellImage: UIImage) {
        self.cellImageView.image = cellImage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(cellImageView)
        self.backgroundColor = ImageGalleryCell.standartBackroundColor
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
