import UIKit
import Core

class QuestionViewController: BaseViewController<BaseViewModel> {
    @IBOutlet weak var questionContainer: QuestionView!

    var question: SurveyQuestionItemView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUi()
    }
    
    private func setUi() {
        if let question {
            questionContainer.set(question: question)
        }
    }
}
