import UIKit
import Core

class ImagePickerManager: NSObject {
    override init() {
    }
    
    private var currentVC: UIViewController?
    
    var imagePicked: ((UIImage) -> Void)?
    
    func showActionSheet(vc: UIViewController,
                         _ imagePicked: ((_ image: UIImage) -> Void)?) {
        self.currentVC = vc
        self.imagePicked = imagePicked
        let actionSheet = UIAlertController(title: Strings.selectAnOption,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: Strings.openCamera, style: .default) { [weak self] action -> Void in
            self?.getImage(fromSourceType: .camera)
        }
        actionSheet.addAction(photoAction)
        
        let galleryAction = UIAlertAction(title: Strings.openGallery, style: .default) { [weak self] _ -> Void in
            self?.getImage(fromSourceType: .photoLibrary)
        }
        actionSheet.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: Strings.cancel, style: .cancel)
        actionSheet.addAction(cancelAction)
        
        if let presenter = actionSheet.popoverPresentationController {
            presenter.sourceView = vc.view
            presenter.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
            presenter.permittedArrowDirections = []
        }
        
        currentVC?.present(actionSheet, animated: true)
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            currentVC?.present(imagePickerController, animated: true)
        }
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            currentVC?.dismiss(animated: true, completion: { [weak self] in
                self?.imagePicked?(image)
            })
        } else {
            print("Something went wrong")
        }
    }
}
