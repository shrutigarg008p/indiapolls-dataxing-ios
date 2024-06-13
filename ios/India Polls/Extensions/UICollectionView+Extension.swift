import UIKit

extension UICollectionView {
    func setVerticalCompositionLayout(itemVerticalSpacing: CGFloat = 0, top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        let compositionalLayout: UICollectionViewCompositionalLayout = {
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: size)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
            section.interGroupSpacing = itemVerticalSpacing
            
            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        self.collectionViewLayout = compositionalLayout
    }
    
    func setVerticalWithHeaderCompositionLayout() {
        let compositionalLayout: UICollectionViewCompositionalLayout = {
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Dimen.dimen20, bottom: 0, trailing: Dimen.dimen20)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: Dimen.dimen10, leading: 0, bottom: Dimen.dimen10, trailing: 0)
            section.interGroupSpacing = Dimen.dimen24
            
            let headerFooterSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(Dimen.dimen160)
                    )
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                       layoutSize: headerFooterSize,
                       elementKind: UICollectionView.elementKindSectionHeader,
                       alignment: .top
                   )
            section.boundarySupplementaryItems = [sectionHeader]

            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        self.collectionViewLayout = compositionalLayout
    }
    
    func setHorizontalCompositionLayout(width: CGFloat, height: CGFloat, supplementaryItemIdentifier: String? = nil) {
        let compositionalLayout: UICollectionViewCompositionalLayout = {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), 
                                                  heightDimension: .fractionalHeight(1))
            var item = NSCollectionLayoutItem(layoutSize: itemSize)

            if let supplementaryItemIdentifier {
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Dimen.dimen30))
                let containerAnchor = NSCollectionLayoutAnchor(edges: [.top], absoluteOffset: CGPoint(x: Dimen.dimen1, y: Dimen.dimen12))
                let supplementaryItem = NSCollectionLayoutSupplementaryItem(layoutSize: layoutSize, elementKind: supplementaryItemIdentifier, containerAnchor: containerAnchor)
                item =  NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [supplementaryItem])
            }
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: Dimen.dimen24)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Dimen.dimen24, bottom: 0, trailing: Dimen.dimen12)
            section.orthogonalScrollingBehavior = .continuous
            
            return UICollectionViewCompositionalLayout(section: section)
        }()
        
        self.collectionViewLayout = compositionalLayout
    }
    
    func registerCell(cellIdentifier: String) {
        self.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func registerSupplementaryView(cellIdentifier: String, elementKind: String) {
        self.register(UINib(nibName: cellIdentifier, bundle: nil), forSupplementaryViewOfKind: elementKind, withReuseIdentifier: cellIdentifier)
    }
}
