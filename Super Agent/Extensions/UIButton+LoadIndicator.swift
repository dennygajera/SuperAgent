//
//  UIButton+LoadIndicator.swift
//  ITMO
//
//  Created by Alexey Voronov on 12/03/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    private var states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    func loadingIndicator(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.isEnabled = false
                self.setTitleColor(.clear, for: .normal)
                let indicator = UIActivityIndicatorView()
                let buttonHeight = self.bounds.size.height
                let buttonWidth = self.bounds.size.width
                indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
                indicator.style = .whiteLarge
                indicator.alpha = 0.9
                self.addSubview(indicator)
                indicator.startAnimating()
            } else {
                self.setTitleColor(UIColor(named: "WhiteSecond"), for: .normal)
                self.isEnabled = true
                for view in self.subviews {
                    if let indicator = view as? UIActivityIndicatorView {
                        indicator.stopAnimating()
                        indicator.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    public func setTitleForAllStates(_ title: String) {
        states.forEach { setTitle(title, for: $0) }
    }
}
