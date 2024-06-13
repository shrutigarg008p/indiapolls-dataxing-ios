import Combine

public class EnterAddressViewModel: LoadableViewModelBase<ServerResponseDto<[CountryDto]>> {
    private var getRegion: LoadableViewModelBase<ServerResponseDto<RegioDto>>!
    private var updateProfile: LoadableViewModelBase<ServerResponseDto<UpdateProfileResponseDto>>!
    
    public let referralSources = Strings.referralSources
    
    public let countries = CurrentValueSubject<[CountryDto], Never>([])
    public let states = CurrentValueSubject<[StateDto], Never>([])
    public let cities = CurrentValueSubject<[CityDto], Never>([])
    public let addressLine1 = CurrentValueSubject<String, Never>(.empty)
    public let addressLine2 = CurrentValueSubject<String, Never>(.empty)
    public let pincode = CurrentValueSubject<String, Never>(.empty)
    
    public let countryError = CurrentValueSubject<String?, Never>(nil)
    public let stateError = CurrentValueSubject<String?, Never>(nil)
    public let cityError = CurrentValueSubject<String?, Never>(nil)
    public let addressError = CurrentValueSubject<String?, Never>(nil)
    public let referralCodeError = CurrentValueSubject<String?, Never>(nil)
    public let pincodeError = CurrentValueSubject<String?, Never>(nil)
    
    public let selectedCountry = CurrentValueSubject<CountryDto?, Never>(nil)
    public let selectedState = CurrentValueSubject<StateDto?, Never>(nil)
    public let selectedCity = CurrentValueSubject<CityDto?, Never>(nil)
    
    var personalDetails: PersonalDetails!
    private var selectedReferralSource: String!
    
    public override func initialize(with data: NavigationData?) {
        guard let data, let personalDetails = data[.personalDetails] as? PersonalDetails else {
            return
        }
        
        self.personalDetails = personalDetails
        let userId = (environment.appState?.auth?.id).orEmpty
        
        getRegion = LoadableViewModelBase()
        
        getRegion.initialize { [unowned self] in
            try await self.api.getAllStatesAndCitiesByZipCode(request: self.createRegionRequest())
        }
        
        getRegion.resultWasFound = { [weak self] response in
            guard let self, let data = response.data else {
                return
            }
            
            self.states.send(data.state)
            self.cities.send(data.cities)
            
            self.findStateAndCity()
        }
        
        updateProfile = LoadableViewModelBase()
        
        updateProfile.initialize { [unowned self] in
            try await self.api.updateProfile(requestId: userId, request: self.createProfileRequest())
        }
        
        updateProfile.validate = { [weak self] in
            guard let self else {
                return false
            }
            
            return self.validate()
        }
        
        updateProfile.resultWasFound = { [weak self] result in
            guard let self, let profile = result.data?.basicProfile else {
                return
            }
            
            if environment.appState.isLoggedIn {
                self.save(profile)
                self.navigate(to: .home)
            } else {
                self.navigate(to: .login)
            }
        }
        
        super.initialize { [unowned self] in
            try await self.api.getCountries()
        }
    }
    
    override func resultWasFound(result: ServerResponseDto<[CountryDto]>) {
        if let data = result.data, !data.isEmpty {
            countries.send(data)
            selectedCountry.send(data.first)
        }
    }
    
    override func setBindings() {
        super.setBindings()
        
        Publishers.CombineLatest3(getRegion.isExecuting, updateProfile.isExecuting, isExecuting)
            .map { $0 || $1 || $2 }
            .subscribe(isBusy)
            .store(in: &cancellables)
    }
    
    public func countryWasChanged(to index: Int) {
        if countries.value.indices.contains(index) {
            let country = countries.value[index]
            selectedCountry.send(country)
        }
    }
    
    public func stateWasChanged(to index: Int) {
        if states.value.indices.contains(index) {
            let state = states.value[index]
            selectedState.send(state)
        }
    }
    
    public func cityWasChanged(to index: Int) {
        if cities.value.indices.contains(index) {
            let city = cities.value[index]
            selectedCity.send(city)
        }
    }
    
    public func zipCodeWasChanged() {
        getRegion.execute()
    }
    
    public func referralSourceWasChanged(referralSource: String) {
        selectedReferralSource = referralSource
    }
    
    public func submitWasTapped() {
        updateProfile.execute()
    }
    
    private func findStateAndCity() {
        let pincode = pincode.value
        if let city = cities.value.first(where: { $0.zipCode == pincode }),
           let state = states.value.first(where: { $0.id == city.stateId }) {
            self.selectedCity.send(city)
            self.selectedState.send(state)
        }
    }
    
    private func createRegionRequest() -> AddresRequestDto {
        let request = AddresRequestDto(limit: 1000, id: pincode.value)
        return request
    }
    
    private func createProfileRequest() -> ProfileUpdateRequestDto {
        let request = ProfileUpdateRequestDto(firstName: personalDetails.firstName,
                                              lastName: personalDetails.lastName,
                                              gender: personalDetails.gender,
                                              dateOfBirth: personalDetails.dateOfBirth,
                                              referralSource: selectedReferralSource,
                                              addressLine1: addressLine1.value,
                                              addressLine2: addressLine2.value,
                                              country: (selectedCountry.value?.name).orEmpty,
                                              state: (selectedState.value?.name).orEmpty,
                                              city: (selectedCity.value?.name).orEmpty,
                                              mobile: personalDetails.mobile,
                                              pinCode: pincode.value,
                                              acceptTerms: personalDetails.acceptTerms,
                                              imagePath: personalDetails.imagePath)
        return request
    }
    
    private func validate() -> Bool {
        addressError.send(addressLine1.value.isValid ? nil : Strings.invalidAddress)
        pincodeError.send(pincode.value.isValid ? nil : Strings.invalidPincode)
        countryError.send(selectedCountry.value.hasValue ? nil : Strings.invalidCountry)
        stateError.send(selectedState.value.hasValue ? nil : Strings.invalidState)
        cityError.send(selectedCity.value.hasValue ? nil : Strings.invalidCity)
        referralCodeError.send(selectedReferralSource.hasValue ? nil : Strings.invalidReferralCode)
        
        return addressError.value.isEmpty && pincodeError.value.isEmpty && countryError.value.isEmpty && stateError.value.isEmpty && cityError.value.isEmpty && referralCodeError.value.isEmpty
    }
}
