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
                for i in 0...20 {
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
        imageGalleryCollection.backgroundColor = .quaternarySystemFill
    }
}

// MARK: - Setup behavior
private extension ViewController {
    func setupBehavior() {
        imageGalleryCollection.delegate = self
        imageGalleryCollection.dataSource = imageDataSource
        imageGalleryCollection.register(ImageGalleryCell.self, forCellWithReuseIdentifier: ImageGalleryCell.reuseID)
    }
}

// MARK: - Embed views
private extension ViewController {
    func embedViews() {
        view.addSubview(imageGalleryCollection)
    }
}

// MARK: - Setup layout
private extension ViewController {
    func setupLayout() {
        imageGalleryCollection.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide.snp.verticalEdges).inset(100)
        }
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
extension ViewController: UICollectionViewDelegate {}

#Preview {
    ViewController()
}
