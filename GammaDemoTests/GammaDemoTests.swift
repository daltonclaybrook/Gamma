//
//  GammaDemoTests.swift
//  GammaDemoTests
//
//  Created by Dalton Claybrook on 1/3/18.
//  Copyright © 2018 Dalton Claybrook. All rights reserved.
//

@testable import GammaDemo
import Gamma
import UIKit
import XCTest

class GammaDemoTests: XCTestCase {
    
    func testExample() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorViewController") as! ColorViewController
        let colors: [UIColor] = [
            .green, .red, .blue, .orange, .magenta
        ]
        viewController.configure(with: colors)
        print(String(describing: type(of: viewController)))
        
        let window = UIApplication.shared.keyWindow!
        window.rootViewController = viewController
        let image = snapshotOfView(window)
        XCTAssertNotNil(image)
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
