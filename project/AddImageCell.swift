import UIKit
import SnapKit

class AddImageCell: UICollectionViewCell {
    static let reuseID = "AddImageCell"
    private let standartColor = UIColor.lightGray
    private let plusImage = "plus.circle.fill"
    
    let addImageButton = UIButton()
    private let plusImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addImageButton.addSubview(plusImageView)
        self.addSubview(addImageButton)
        
        plusImageView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
        plusImageView.image = UIImage(systemName: plusImage)
        plusImageView.tintColor = standartColor
        
        addImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    AddImageCell()
}
