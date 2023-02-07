import UIKit
import TinyConstraints

class ActivityViewController: BaseViewController {
    
    var dataModel: [(UIImage, String, Date)] = [
        (UIImage.eduIDLogo, "edubadges", Date()),
        (UIImage.surfLogo, "SURF wiki", Date()),
        (UIImage.eduIDLogo, "RIO", Date()),
        (UIImage.surfLogo, "service provider X", Date())
    ]
    
    var stack: AnimatedVStackView!
    let scrollView = UIScrollView()
    weak var delegate: ActivityNavigationDelegate?

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .activityLandingScreen
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissActivityScreen))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: stack.frame.size.width, height: stack.frame.size.height + view.safeAreaInsets.top)
    }
    
    //MARK: - setup ui
    func setupUI() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Data & Activity", primary: "Data & Activity")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        let textParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: """
Each service you accessed through eduID receives certain personal data (attributes) from your eduID account. E.g. your name & email address or a pseudonym which the service can use to uniquely identify you.
""", partBold: "")
        textParent.addSubview(textLabel)
        textLabel.edges(to: textParent)
        
        stack = AnimatedVStackView(arrangedSubviews: [posterParent, textParent])
        for item in dataModel {
            let control = ActivityItemControl(image: item.0, title: item.1, date: item.2)
            stack.addArrangedSubview(control)
            control.width(to: stack)
            
        }
        stack.alignment = .center
        
        // constraints
        scrollView.addSubview(stack)
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 0, bottom: -24, right: 0))
        stack.width(to: scrollView)
        posterParent.width(to: stack, offset: -48)
        textParent.width(to: stack, offset: -48)
    }
    
    @objc
    func dismissActivityScreen() {
        delegate?.dismissActivityFlow(sender: self)
    }
    
}
