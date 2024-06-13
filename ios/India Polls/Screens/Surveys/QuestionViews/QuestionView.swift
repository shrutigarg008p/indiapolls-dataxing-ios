import UIKit
import Core

class QuestionView: UIView {
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionsContainer: UIStackView!
    
    private var question: SurveyQuestionItemView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        rootView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as! UIView
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(rootView)
        
        questionLabel.setPrimaryMedium18LabelStyle()
    }
    
    func set(question: SurveyQuestionItemView) {
        self.question = question
        questionLabel.text = question.text
        
        if let type = QuestionDisplayType(rawValue: question.displayType) {
            switch type {
            case .dropDown:
                optionsContainer.addArrangedSubview(getDropDownView(options: question.options))
            case .radioButtons:
                question.options.enumerated().forEach {
                    optionsContainer.addArrangedSubview(getRadioButton(option: $0.element, index: $0.offset))
                }
            case .checkBoxes:
                question.options.enumerated().forEach {
                    optionsContainer.addArrangedSubview(getCheckBoxView(option: $0.element, index: $0.offset))
                }
            }
        }
    }
    
    private func getRadioButton(option: OptionItemView, index: Int) -> UIView {
        let view = RadioButtonView(frame: .zero)
        view.onClick = { [weak self] in
            guard let self = self else { return }
            self.removeAllSelections()
            
            let previousView = optionsContainer.arrangedSubviews.first(where: { ($0 as? RadioButtonView)?.checked ?? false }) as? RadioButtonView
            previousView?.updateCheckedStateManually(checked: false)
            
            question.options[index].isSelected = true
        }
        view.set(title: option.value, checked: option.isSelected)

        return view
    }
    
    private func getCheckBoxView(option: OptionItemView, index: Int) -> UIView {
        let view = CheckBoxView(frame: .zero)
        view.onClick = { [weak self] in
            guard let self = self else { return }

            question.options[index].isSelected = view.checked
        }
        view.set(title: option.value, checked: option.isSelected)

        return view
    }
    
    private func getDropDownView(options: [OptionItemView]) -> UIView {
        let view = DropDownView(frame: .zero)
        view.onClick = { [weak self] index in
            guard let self = self else { return }
            self.removeAllSelections()
            
            question.options[index].isSelected = true
        }
        view.set(options: options)

        return view
    }
    
    private func removeAllSelections() {
        for index in question.options.indices {
            question.options[index].isSelected = false
        }
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}
