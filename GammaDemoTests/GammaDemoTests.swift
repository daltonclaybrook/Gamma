@testable import GammaDemo
import Gamma
import UIKit
import XCTest
import FBSnapshotTestCase

class GammaDemoTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
//        self.recordMode = true
//        GammaSettings(forceRecord: true).makeCurrent()
    }
    
    func testTenColorsInColorViewController() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorViewController") as! ColorViewController
        let colors: [UIColor] = [
//            .green, .red, .blue, .orange, .magenta, .brown, .cyan, .purple, .gray, .yellow
            .green, .red, .blue, .orange, .magenta, .brown, .cyan, .purple, .gray
        ]
        viewController.configure(with: colors)
//        measure {
            viewController
                .takeSnapshot(identifier: "foobar")
                .assertMatch()
//        }
    }
    
    func testFacebook() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorViewController") as! ColorViewController
        let colors: [UIColor] = [
//            .green, .red, .blue, .orange, .magenta, .brown, .cyan, .purple, .gray, .yellow
            .green, .red, .blue, .orange, .magenta, .brown, .cyan, .purple, .gray
        ]
        viewController.configure(with: colors)
        
        measure {
            FBSnapshotVerifyView(viewController.view)
        }
    }
    
    // MARK: Private
    
    private func snapshotOfView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
