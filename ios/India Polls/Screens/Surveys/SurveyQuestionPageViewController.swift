import UIKit
import Core

class SurveyQuestionPageViewController: BaseViewController<SurveyQuestionsViewModel>, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    private var nextIndex = 0
    @IBOutlet weak var navigationBarView: NavigationBarView!
    
    private lazy var pageController: UIPageViewController = {
        let pc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pc.view.setDefaultBackgroundColor()
        pc.delegate = self
        pc.dataSource = self
        pc.view.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    var viewControllers: [UIViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLoader()
        setUi()
        setEventHandlers()
        setBindings()
        
        viewModel.execute()
    }
    
    private func setUi() {
        view.setDefaultBackgroundColor()
        setupPageController(leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, topAnchor: navigationBarView.bottomAnchor, bottomAnchor: view.bottomAnchor)
        view.bringSubviewToFront(self.loader!)
    }
    
    private func setupPageController(leadingAnchor: NSLayoutXAxisAnchor, trailingAnchor: NSLayoutXAxisAnchor, topAnchor: NSLayoutYAxisAnchor, bottomAnchor: NSLayoutYAxisAnchor) {
        addChild(pageController)
        view.addSubview(pageController.view)
        NSLayoutConstraint.activate([
            pageController.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            pageController.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            pageController.view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            pageController.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    private func setEventHandlers() {
        navigationBarView.onLeftButtonClick = { [weak self] in
            guard let self else {
                return
            }
            
            self.navigateBack()
        }
    }
    
    private func setBindings() {
        viewModel.questions
            .sink { [weak self] questions in
               self?.setupQuestions(questions)
            }
            .store(in: &cancellables)
    }
    
    private func setupQuestions(_ questions: [SurveyQuestionItemView]) {
        if questions.isEmpty {
            return
        }
        
        var vcs = [UIViewController]()
        questions.forEach { question in
            let questionVC: QuestionViewController = ViewControllerFactory.create(from: .question)
            questionVC.question = question
            vcs.append(questionVC)
        }
        
        let completionViewController: CompletionViewController = ViewControllerFactory.create(from: .completion)
        completionViewController.onCompletion = { [weak self] in
            self?.viewModel.completeButtonWasTapped()
        }
        vcs.append(completionViewController)
        viewControllers = vcs
        pageController.setViewControllers([viewControllers[0]], direction: .forward, animated: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController) {
            if index > 0 {
                return viewControllers[index - 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController) {
            if index < viewControllers.count - 1 {
                return viewControllers[index + 1]
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let vc = pendingViewControllers.first,
              let index = viewControllers.firstIndex(of: vc) else {
            return
        }
        
        slideToPage(to: index, from: nextIndex)
        nextIndex = index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            set(selectedIndex: nextIndex)
        }
    }
    
    func set(selectedIndex: Int) {
        print(selectedIndex)
    }
    
    private func slideToPage(to pageIndex: Int, from currentPageIndex: Int) {
        if pageIndex < viewControllers.count {
            if pageIndex > currentPageIndex {
                setCurrentPage(to: pageIndex, in: .forward, animated: true)
            } else if pageIndex < currentPageIndex {
                setCurrentPage(to: pageIndex, in: .reverse, animated: true)
            }
        }
    }
    
    private func setCurrentPage(to pageIndex: Int, in direction: UIPageViewController.NavigationDirection, animated: Bool) {
        let vc = viewControllers[pageIndex]
        pageController.setViewControllers([vc], direction: direction, animated: animated, completion: { [weak self] _ in
            self?.set(selectedIndex: pageIndex)
        })
    }
}
