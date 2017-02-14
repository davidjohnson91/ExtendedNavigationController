import UIKit


protocol ExtendedNavigationControllerProvider {
  var extendedView: UIView? { get }
}

public final class ExtendedNavigationController: UINavigationController {
  fileprivate weak var fakeBackgroundView: UIVisualEffectView!
  fileprivate weak var extendingContainer: UIView!
  fileprivate var extendingViews = [UIView]()
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    delegate = self
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    fakeBackgroundView = makeFakeBackground()
    extendingContainer = makeExtendingContainer()
    fakeBackgroundView.bottomAnchor.constraint(equalTo: extendingContainer.bottomAnchor).isActive = true
    
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

extension ExtendedNavigationController: UINavigationControllerDelegate {
  public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    
    let layoutBlock = {
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
    }
    
    insertExtendingView(from: viewController)
    
    navigationController.transitionCoordinator?.animate(alongsideTransition: { _ in
      layoutBlock()
    }, completion: { context in
      guard context.isCancelled,
        let fromController = context.viewController(forKey: .from) else {
        return
      }
      
      self.insertExtendingView(from: fromController)
      layoutBlock()
    })
  }
  
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
  }
}

private extension ExtendedNavigationController {
  func makeFakeBackground() -> UIVisualEffectView {
    let blurEffect = UIBlurEffect(style: .dark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    view.insertSubview(blurView, belowSubview: navigationBar)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    
    let defaultBottomConstraint = blurView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
    defaultBottomConstraint.priority = 999
    defaultBottomConstraint.isActive = true
    
    return blurView
  }
  
  func makeExtendingContainer() -> UIView {
    let containerView = UIView()
    fakeBackgroundView.contentView.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor).isActive = true
    containerView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
    
    return containerView
  }
  
  func insertExtendingView(from viewController: UIViewController) {
    guard let extendingView = (viewController as? ExtendedNavigationControllerProvider)?.extendedView else {
      return
    }
    
    extendingView.removeFromSuperview()
    extendingContainer.subviews.forEach { $0.removeFromSuperview() }
    
    extendingContainer.addSubview(extendingView)
    
    extendingView.translatesAutoresizingMaskIntoConstraints = false
    extendingView.leadingAnchor.constraint(equalTo: extendingContainer.leadingAnchor).isActive = true
    extendingView.trailingAnchor.constraint(equalTo: extendingContainer.trailingAnchor).isActive = true
    extendingView.topAnchor.constraint(equalTo: extendingContainer.topAnchor).isActive = true
    extendingView.bottomAnchor.constraint(equalTo: extendingContainer.bottomAnchor).isActive = true
  }
}
