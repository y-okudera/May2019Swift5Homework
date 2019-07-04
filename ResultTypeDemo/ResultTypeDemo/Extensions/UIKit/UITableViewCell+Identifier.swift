//
//  UITableViewCell+Identifier.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import UIKit

extension UITableViewCell {

    static var identifier: String {
        return String(describing: self)
    }
}
