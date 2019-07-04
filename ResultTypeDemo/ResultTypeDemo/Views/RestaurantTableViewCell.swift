//
//  RestaurantTableViewCell.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import UIKit

final class RestaurantTableViewCell: UITableViewCell {

    var restaurant: Restaurant? {
        didSet {
            self.textLabel?.text = restaurant?.name
        }
    }
}
