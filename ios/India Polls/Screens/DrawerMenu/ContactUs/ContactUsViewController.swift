import UIKit
import MaterialComponents
import Core

class ContactUsViewController: EditableViewControllerBase<ContactUsViewModel> {
    @IBOutlet weak var navigationBarView: NavigationBarView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subjectTextField: MDCOutlinedTextField!
    @IBOutlet weak var queryTypeTextField: MDCOutlinedTextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var textFieldContainerView: UIStackView!
    
    private var pickerTextField: PickerTextField!
    private var bodyTextField: MDCOutlinedTextArea!
    
    override func viewDidLoad() {
        scrollable = scrollView

        super.viewDidLoad()

        setUi()
        setEventHandlers()
        setBindings()
        
        addLoader()
    }
    
    private func setUi() {
        subjectTextField.setDefaultStyle(placeholder: Strings.subjectPlaceholder, label: Strings.subjectPlaceholder)
        submitButton.setDefaultStyle(text: Strings.submit)
        queryTypeTextField.setDefaultStyle(placeholder: Strings.queryTypePlaceholder, label: Strings.queryTypePlaceholder)
        bodyTextField = MDCOutlinedTextArea()
        bodyTextField.setDefaultStyle(placeholder: Strings.body, label: Strings.body)
        textFieldContainerView.addArrangedSubview(bodyTextField)
    }
    
    private func setEventHandlers() {
        navigationBarView.onLeftButtonClick = { [weak self] in
            guard let self else {
                return
            }
            
            self.navigateBack()
        }
        
        submitButton.addTapGesture(self, #selector(submitButtonWasTapped))

        pickerTextField = PickerTextField(textField: queryTypeTextField, itemChangeHandler: { [weak self] item in
            guard let self else { return }
            self.onQueryChange(query: item)
        })
        
        pickerTextField.update(items: viewModel.queryTypes)
    }
    
    private func setBindings() {
        subjectTextField
            .textPublisher
            .sink { [weak self] value in
                self?.viewModel.subject.send(value)
            }.store(in: &cancellables)
        
        viewModel.subjectError
            .sink(receiveValue: subjectTextField.error)
            .store(in: &cancellables)
        
        bodyTextField
            .textPublisher
            .sink { [weak self] value in
                self?.viewModel.body.send(value)
            }.store(in: &cancellables)
        
        viewModel.queryTypeError
            .sink(receiveValue: queryTypeTextField.error)
            .store(in: &cancellables)
    }
    
    private func onQueryChange(query: PickerItem) {
        viewModel.queryType.send(query.title)
    }
    
    @objc private func submitButtonWasTapped() {
        viewModel.submitWasTapped()
    }
}
