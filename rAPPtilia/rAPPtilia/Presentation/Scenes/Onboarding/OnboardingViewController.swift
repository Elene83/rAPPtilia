import UIKit

class OnboardingViewController: UIViewController {
    //MARK: Properties
    private var scrollView = UIScrollView()
    private var pageControl = UIPageControl()
    private let skipButton = UIButton(type: .system)

    private let viewModel: OnboardingViewModel
    weak var coordinator: AppCoordinator?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
        setupUI()
    }
    
    //MARK: Inits
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: Methods
    private func setupUI() {
        setupScrollView()
        setupPageControl()
        setupSkipButton()
        setupPages()
    }
    
    private func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
             
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.numberOfPages
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
               
        let firstPage = viewModel.getPage(at: 0)
        if let dotColor = UIColor(named: firstPage.dotColorName) {
            pageControl.pageIndicatorTintColor = dotColor.withAlphaComponent(0.3)
            pageControl.currentPageIndicatorTintColor = dotColor
        }
               
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupSkipButton() {
        skipButton.setTitle(viewModel.getButtonLabel(), for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "FiraGO-Medium", size: 18) ?? .systemFont(ofSize: 16, weight: .medium)
              
        let firstPage = viewModel.getPage(at: 0)
        if let fontColor = UIColor(named: firstPage.fontColorName) {
            skipButton.setTitleColor(fontColor, for: .normal)
            }
              
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skipButton)
              
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupPages() {
        let pageWidth = view.bounds.width
        let pageHeight = view.bounds.height
                
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(viewModel.numberOfPages), height: pageHeight)
        
        for index in 0..<viewModel.numberOfPages { //TODO: perhaps viewmodelshi es
            let page = viewModel.getPage(at: index)
            let pageView = OnboardingPageView(frame: CGRect(
                x: CGFloat(index) * pageWidth,
                y: 0,
                width: pageWidth,
                height: pageHeight
            ))
            pageView.configure(with: page)
            scrollView.addSubview(pageView)
        }
    }
    
    private func completeOnboarding() {
          coordinator?.onboardingDidFinish()
      }
    
    @objc private func skipTapped() {
         completeOnboarding()
     }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        viewModel.updateCurrentPage(pageIndex)
        pageControl.currentPage = pageIndex
        
        skipButton.setTitle(viewModel.getButtonLabel(), for: .normal)
        
        let currentPageData = viewModel.getPage(at: pageIndex)
        
        UIView.animate(withDuration: 0.3) {
            if let fontColor = UIColor(named: currentPageData.fontColorName) {
                self.skipButton.setTitleColor(fontColor, for: .normal)
            }
            
            if let dotColor = UIColor(named: currentPageData.dotColorName) {
                self.pageControl.pageIndicatorTintColor = dotColor.withAlphaComponent(0.3)
                self.pageControl.currentPageIndicatorTintColor = dotColor
            }
        }
    }
}
