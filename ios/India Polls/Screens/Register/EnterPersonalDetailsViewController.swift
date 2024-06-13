import UIKit
import MaterialComponents
import Core

class EnterPersonalDetailsViewController: EditableViewControllerBase<EnterPersonalDetailsViewModel> {
    @IBOutlet weak var navigationBarView: NavigationBarView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var firstNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var lastNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var mobileTextField: MDCOutlinedTextField!
    @IBOutlet weak var dobTextField: MDCOutlinedTextField!
    @IBOutlet weak var genderTextField: MDCOutlinedTextField!
    @IBOutlet weak var nextButton: UIButton!
    
    private var genderPicker: PickerTextField!

    override func viewDidLoad() {
        scrollable = scrollView
        
        super.viewDidLoad()
        
        addLoader()
        
        setUi()
        setEventHandlers()
        setBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUi() {
        navigationBarView.leftButton.isHidden = true

        registerLabel.setPrimaryMedium24LabelStyle(text: Strings.register)
        infoLabel.setPrimaryRegular14LabelStyle(text: Strings.pleaseProvideFollowingInformationToContinue)
        
        firstNameTextField.setDefaultStyle(placeholder: Strings.firstNamePlaceholder, label: Strings.firstNamePlaceholder)
        lastNameTextField.setDefaultStyle(placeholder: Strings.lastNamePlaceholder, label: Strings.lastNamePlaceholder)
        mobileTextField.setDefaultStyle(placeholder: Strings.mobilePlaceholder, label: Strings.mobilePlaceholder, keyboardType: .phonePad)
        dobTextField.setDefaultStyle(placeholder: Strings.dobPlaceholder, label: Strings.dobPlaceholder)
        genderTextField.setDefaultStyle(placeholder: Strings.selectGender, label: Strings.selectGender)
        nextButton.setDefaultStyle(text: Strings.next)
        dobTextField.setTrailingView(image: "ic_calendar")
    }
    
    private func setEventHandlers() {
        navigationBarView.onLeftButtonClick = { [weak self] in
            guard let self else {
                return
            }
            
            self.navigateBack()
        }
        
        nextButton.addTapGesture(self, #selector(nextButtonWasTapped))
        dobTextField.datePicker(target: self,
                                doneAction: #selector(doneAction),
                                cancelAction: #selector(cancelAction),
                                datePickerMode: .date)
        
        genderPicker = PickerTextField(textField: genderTextField, itemChangeHandler: { [weak self] item in
            guard let self else { return }
            self.onGenderChange(item: item)
        })
        genderPicker.update(items: viewModel.genders)
    }
    
    private func setBindings() {
        firstNameTextField
            .textPublisher
            .subscribe(viewModel.firstName)
            .store(in: &cancellables)
        
        viewModel.firstNameError
            .sink(receiveValue: firstNameTextField.error)
            .store(in: &cancellables)
        
        lastNameTextField
            .textPublisher
            .subscribe(viewModel.lastName)
            .store(in: &cancellables)
        
        viewModel.lastNameError
            .sink(receiveValue: lastNameTextField.error)
            .store(in: &cancellables)
        
        viewModel.mobile
            .sink { [weak self] value in
                self?.mobileTextField.text = value
            }
            .store(in: &cancellables)
        
        viewModel.mobileError
            .sink(receiveValue: mobileTextField.error)
            .store(in: &cancellables)
        
        mobileTextField
            .textPublisher
            .subscribe(viewModel.mobile)
            .store(in: &cancellables)
        
        viewModel.dobError
            .sink(receiveValue: dobTextField.error)
            .store(in: &cancellables)
        
        viewModel.genderError
            .sink(receiveValue: genderTextField.error)
            .store(in: &cancellables)
    }
    
    private func onGenderChange(item: PickerItem) {
        viewModel.genderWasChanged(gender: item.title)
    }
    
    @objc private func nextButtonWasTapped() {
        viewModel.nextWasTapped()
    }
    
    @objc private func cancelAction() {
        self.dobTextField.resignFirstResponder()
    }
    
    @objc private func doneAction() {
        if let datePickerView = self.dobTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.dobTextField.text = dateString
            self.viewModel.dob.send(dateString)
            self.dobTextField.resignFirstResponder()
        }
    }
}
