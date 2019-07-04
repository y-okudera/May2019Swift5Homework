//
//  RestaurantsDataSource.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import UIKit

final class RestaurantsDataSource: NSObject {
    private(set) var restaurants = [Restaurant]()

    func setRestaurants(restaurants: [Restaurant]) {
        self.restaurants = restaurants
    }

    func appendRestaurants(restaurants: [Restaurant]) {
        self.restaurants.append(contentsOf: restaurants)
    }
}

extension RestaurantsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RestaurantTableViewCell.identifier, for: indexPath) as! RestaurantTableViewCell
        cell.restaurant = restaurants[indexPath.row]
        return cell
    }
}
