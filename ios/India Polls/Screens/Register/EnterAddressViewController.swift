import UIKit
import MaterialComponents
import Core

class EnterAddressViewController: EditableViewControllerBase<EnterAddressViewModel> {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationBarView: NavigationBarView!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var addressLine1TextField: MDCOutlinedTextField!
    @IBOutlet weak var addressLine2TextField: MDCOutlinedTextField!
    @IBOutlet weak var countryTextField: MDCOutlinedTextField!
    @IBOutlet weak var stateTextField: MDCOutlinedTextField!
    @IBOutlet weak var cityTextField: MDCOutlinedTextField!
    @IBOutlet weak var pincodeTextField: MDCOutlinedTextField!
    @IBOutlet weak var referralSourceTextField: MDCOutlinedTextField!
    @IBOutlet weak var nextButton: UIButton!
    
    private var countryPicker: PickerTextField!
    private var statePicker: PickerTextField!
    private var cityPicker: PickerTextField!
    private var referralSourcePicker: PickerTextField!

    override func viewDidLoad() {
        scrollable = scrollView

        super.viewDidLoad()
        
        setUi()
        addLoader()
        configurePickers()
        setEventHandlers()
        setBindings()
        
        viewModel.execute()
    }
    
    private func setUi() {
        registerLabel.setPrimaryMedium24LabelStyle(text: Strings.register)
        infoLabel.setPrimaryRegular14LabelStyle(text: Strings.pleaseProvideFollowingInformationToContinue)
        addressLine1TextField.setDefaultStyle(placeholder: Strings.addressLine1Placeholder, label: Strings.addressLine1Placeholder)
        addressLine2TextField.setDefaultStyle(placeholder: Strings.addressLine2Placeholder, label: Strings.addressLine2Placeholder)
        countryTextField.setDefaultStyle(placeholder: Strings.countryPlaceholder, label: Strings.countryPlaceholder)
        stateTextField.setDefaultStyle(placeholder: Strings.statePlaceholder, label: Strings.statePlaceholder)
        cityTextField.setDefaultStyle(placeholder: Strings.cityPlaceholder, label: Strings.cityPlaceholder)
        pincodeTextField.setDefaultStyle(placeholder: Strings.pincodePlaceholder, label: Strings.pincodePlaceholder)
        referralSourceTextField.setDefaultStyle(placeholder: Strings.selectReferral, label: Strings.selectReferral)

        nextButton.setDefaultStyle(text: Strings.submit)
    }
    
    private func configurePickers() {
        countryPicker = PickerTextField(textField: countryTextField, itemChangeHandler: { [weak self] item in
            guard let self else { return }
            self.onCountryChange(country: item)
        })
        
        statePicker = PickerTextField(textField: stateTextField, itemChangeHandler: { [weak self] item in
            guard let self else { return }
            self.onStateChange(state: item)
        })
        
        cityPicker = PickerTextField(textField: cityTextField, itemChangeHandler: { [weak self] item in
            guard let self else { return }
            self.onCityChange(city: item)
        })
        
        referralSourcePicker = PickerTextField(textField: referralSourceTextField, itemChangeHandler: { [weak self] item in
            guard let self else { return }
            self.onReferralSourceChange(item: item)
        })
        
        referralSourcePicker.update(items: viewModel.referralSources)
    }
    
    private func setEventHandlers() {
        navigationBarView.onLeftButtonClick = { [weak self] in
            guard let self else {
                return
            }
            
            self.navigateBack()
        }
        
        nextButton.addTapGesture(self, #selector(nextButtonWasTapped))
    }
    
    private func setBindings() {
        addressLine1TextField
            .textPublisher
            .subscribe(viewModel.addressLine1)
            .store(in: &cancellables)
        
        viewModel.addressError
            .sink(receiveValue: addressLine1TextField.error)
            .store(in: &cancellables)
        
        addressLine2TextField
            .textPublisher
            .subscribe(viewModel.addressLine2)
            .store(in: &cancellables)
        
        pincodeTextField
            .textPublisher
            .subscribe(viewModel.pincode)
            .store(in: &cancellables)
        
        viewModel.pincodeError
            .sink(receiveValue: pincodeTextField.error)
            .store(in: &cancellables)
        
        pincodeTextField
            .publisher(for: .editingDidEnd)
            .sink { [weak self] in
                self?.viewModel.zipCodeWasChanged()
            }.store(in: &cancellables)
        
        viewModel.selectedCountry
            .map { ($0?.name).orEmpty }
            .sink { [weak self] value in
                self?.countryTextField.text = value
            }.store(in: &cancellables)
        
        viewModel.countryError
            .sink(receiveValue: countryTextField.error)
            .store(in: &cancellables)
        
        viewModel.selectedState
            .map { ($0?.name).orEmpty }
            .sink { [weak self] value in
                self?.stateTextField.text = value
            }.store(in: &cancellables)
        
        viewModel.stateError
            .sink(receiveValue: stateTextField.error)
            .store(in: &cancellables)
        
        viewModel.selectedCity
            .map { ($0?.name).orEmpty }
            .sink { [weak self] value in
                self?.cityTextField.text = value
            }.store(in: &cancellables)
        
        viewModel.cityError
            .sink(receiveValue: cityTextField.error)
            .store(in: &cancellables)
        
        viewModel.countries
            .map { list in
                list.map { $0.name }
            }
            .sink { [weak self] values in
                self?.countryPicker.update(items: values)
            }.store(in: &cancellables)
        
        viewModel.states
            .map { list in
                list.map { $0.name }
            }
            .sink { [weak self] values in
                self?.statePicker.update(items: values)
            }.store(in: &cancellables)
        
        viewModel.cities
            .map { list in
                list.map { $0.name }
            }
            .sink { [weak self] values in
                self?.cityPicker.update(items: values)
            }.store(in: &cancellables)
        
        viewModel.referralCodeError
            .sink(receiveValue: referralSourceTextField.error)
            .store(in: &cancellables)
    }
    
    @objc private func nextButtonWasTapped() {
        viewModel.submitWasTapped()
    }
    
    private func onCountryChange(country: PickerItem) {
        viewModel.countryWasChanged(to: country.index)
    }
    
    private func onStateChange(state: PickerItem) {
        viewModel.stateWasChanged(to: state.index)
    }
    
    private func onCityChange(city: PickerItem) {
        viewModel.cityWasChanged(to: city.index)
    }
    
    private func onReferralSourceChange(item: PickerItem) {
        viewModel.referralSourceWasChanged(referralSource: item.title)
    }
}
