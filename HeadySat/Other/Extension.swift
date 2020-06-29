//
//  Extension.swift
//  HeadySat
//
//  Created by Captain on 6/29/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
