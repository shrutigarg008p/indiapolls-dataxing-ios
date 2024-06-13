import UIKit
import Core

class DrawerMenuViewController: BaseViewController<DrawerMenuViewModel> {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLoader()
        setUi()
        setEventHandlers()
        setBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.execute()
    }
    
    private func setUi() {
        view.backgroundColor = Colors.AccentColor
        collectionView.setVerticalWithHeaderCompositionLayout()
        collectionView.registerCell(cellIdentifier: MenuCollectionViewCell.reuseIdentifier)
        collectionView.registerSupplementaryView(cellIdentifier: DrawerHeaderCollectionReusableView.reuseIdentifier, elementKind: UICollectionView.elementKindSectionHeader)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setEventHandlers() {
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizerDown.direction = .left
        view.addGestureRecognizer(swipeGestureRecognizerDown)
    }
    
    private func setBindings() {
        viewModel.imagePath
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        closeDrawer()
    }
    
    private func closeDrawer() {
        dismiss(animated: true)
    }
    
    @objc private func didTapOnHeader() {
        closeDrawer()
        navigate(to: .profile)
    }
}

extension DrawerMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.reuseIdentifier, for: indexPath) as! MenuCollectionViewCell
        cell.set(data: viewModel.items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DrawerHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as! DrawerHeaderCollectionReusableView
            headerView.addTapGesture(self, #selector(didTapOnHeader))
            headerView.set(url: viewModel.imagePath.value, name: viewModel.name.value, email: viewModel.email.value)
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        closeDrawer()
        let page = viewModel.items[indexPath.row].page
        if page != .home {
            navigate(to: page)
        }
    }
}
