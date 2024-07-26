import UIKit
import SnapKit

private struct imageGallerySectionData {
    let sectionIdentifier: String
    let sectionItems: [imageGalleryItemData]
}

private struct imageGalleryItemData {
    let itemIdentifier: String
    let itemImage: UIImage
}

// MARK: - ViewController
class ViewController: UIViewController {
    // MARK: !!!Test data!!!
    private let imageGalleryData = [
        imageGallerySectionData(
            sectionIdentifier: "Section-1",
            sectionItems: {
                var itemsIdentifiers = [imageGalleryItemData]()
                for i in 0...5 {
                    itemsIdentifiers.append(imageGalleryItemData(
                        itemIdentifier: "Image-1-\(i)",
                        itemImage: UIImage(systemName: "person.circle.fill")!)
                    )
                }
                return itemsIdentifiers
            }()
        ),
        imageGallerySectionData(
            sectionIdentifier: "Section-2",
            sectionItems: [
                imageGalleryItemData(itemIdentifier: "Item-2-1", itemImage: UIImage(systemName: "character.book.closed.fill")!),
                imageGalleryItemData(itemIdentifier: "Item-2-2", itemImage: UIImage(systemName: "rectangle.fill")!),
                imageGalleryItemData(itemIdentifier: "Item-2-3", itemImage: UIImage(systemName: "rectangle.fill")!),
            ]
        ),
    ]
    
    private var imageGalleryCollection: UICollectionView!
    private var imageDataSource: UICollectionViewDiffableDataSource<String, String>!
    private let selectedImageView = UIImageView()
    
    private let modeSwitchView = UIView()
    private let modeSwitch = UISwitch()
    private let modeLabel = UILabel()
    
    
    var galleryConstraintToImage: Constraint?
    var galleryConstraintToSwitch: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageGalleryCollection()
        setupImageGalleryCollectionDataSource()
        setupAppearence()
        setupBehavior()
        embedViews()
        setupLayout()
    }
}

// MARK: - Setup appearence
private extension ViewController {
    func setupAppearence() {
        view.backgroundColor = .white
        
        imageGalleryCollection.backgroundColor = .quaternarySystemFill
        
        selectedImageView.backgroundColor = .quaternarySystemFill
        selectedImageView.layer.cornerRadius = 20
        
        modeSwitch.onTintColor = .link
        
        modeLabel.text = "Switch to navigation mode"
        modeLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
}

// MARK: - Setup behavior
private extension ViewController {
    func setupBehavior() {
        imageGalleryCollection.delegate = self
        imageGalleryCollection.dataSource = imageDataSource
        imageGalleryCollection.register(ImageGalleryCell.self, forCellWithReuseIdentifier: ImageGalleryCell.reuseID)
        imageGalleryCollection.allowsMultipleSelection = false
        
        modeSwitch.addTarget(self, action: #selector(switchNavigationMode), for: .valueChanged)
    }
    
    @objc func switchNavigationMode() {
        if modeSwitch.isOn {
            modeLabel.text = "Switch to view mode"
            
            selectedImageView.isHidden = true
            selectedImageView.image = nil
        } else {
            modeLabel.text = "Switch to navigation mode"
            selectedImageView.isHidden = false
        }
        
        galleryConstraintToImage?.isActive.toggle()
        galleryConstraintToSwitch?.isActive.toggle()
        
        if let selectedItem = imageGalleryCollection.indexPathsForSelectedItems?.first {
            imageGalleryCollection.deselectItem(at: selectedItem, animated: false)
        }
    }
}

// MARK: - Embed views
private extension ViewController {
    func embedViews() {
        view.addSubview(imageGalleryCollection)
        view.addSubview(selectedImageView)
        modeSwitchView.addSubview(modeSwitch)
        modeSwitchView.addSubview(modeLabel)
        view.addSubview(modeSwitchView)
    }
}

// MARK: - Setup layout
private extension ViewController {
    func setupLayout() {
        imageGalleryCollection.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            galleryConstraintToImage = $0.top.equalTo(selectedImageView.snp.bottom).offset(40).constraint
        }
        
        imageGalleryCollection.snp.prepareConstraints {
            galleryConstraintToSwitch = $0.top.equalTo(modeSwitchView.snp.bottom).offset(40).constraint
        }
        
        selectedImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            $0.size.equalTo(150)
        }
        
        modeSwitchView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        modeSwitch.snp.makeConstraints {
            $0.bottom.centerX.equalToSuperview()
            $0.top.equalTo(modeLabel.snp.bottom).offset(15)
        }
        
        modeLabel.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
        }
        
        galleryConstraintToImage?.activate()
    }
}

// MARK: - Setup gallery collection
private extension ViewController {
    func setupImageGalleryCollection() {
        let sqareItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0/4.0),
            heightDimension: .fractionalHeight(1)
        )
        let sqareItem = NSCollectionLayoutItem(layoutSize: sqareItemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0/4.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [sqareItem]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        imageGalleryCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
}

// MARK: - Setup gallery datasource
extension ViewController {
    func setupImageGalleryCollectionDataSource() {
        imageDataSource = UICollectionViewDiffableDataSource<String, String>(
            collectionView: imageGalleryCollection) { collectionView, indexPath, itemIdentifier in
                guard let imageCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ImageGalleryCell.reuseID,
                    for: indexPath
                ) as? ImageGalleryCell else {
                    fatalError("Failed to initialize image gallery cell!")
                }
                
                imageCell.setImage(self.imageGalleryData[indexPath.section].sectionItems[indexPath.item].itemImage)
                
                return imageCell
            }
        
        var initializeSnapshot = NSDiffableDataSourceSnapshot<String, String>()
        
        imageGalleryData.forEach { sectionData in
            initializeSnapshot.appendSections([sectionData.sectionIdentifier])
            initializeSnapshot.appendItems({
                var itemsIdentifiers = [String]()
                
                sectionData.sectionItems.forEach { itemData in
                    itemsIdentifiers.append(itemData.itemIdentifier)
                }
                
                return itemsIdentifiers
            }(), toSection: sectionData.sectionIdentifier)
        }
    
        imageDataSource.apply(initializeSnapshot, animatingDifferences: true)
    }
}

// MARK: - Delegate protocol subscription
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cellImageView = (collectionView.cellForItem(at: indexPath) as? ImageGalleryCell)?.cellImageView,
            let cellImage = cellImageView.image,
            let cellColor = cellImageView.tintColor else {
                fatalError("Failed to get cell content!")
        }
        
        if modeSwitch.isOn {
            let detailViewController = DetailChooseViewController()
            detailViewController.setImageDetails(cellImage, tintColor: cellColor)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            selectedImageView.image = cellImage
            selectedImageView.tintColor = cellImageView.tintColor
        }
    }
}

#Preview {
    ViewController()
}
