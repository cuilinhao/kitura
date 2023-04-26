import CoreGraphics
import Foundation
import UIKit

class NavigationController: UINavigationController, UINavigationBarDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        self.topViewController?.preferredStatusBarStyle ?? .default
    }
}

