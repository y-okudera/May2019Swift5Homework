//
//  RestaurantsViewController.swift
//  ResultTypeDemo
//
//  Created by YukiOkudera on 2019/07/07.
//  Copyright © 2019 YukiOkudera. All rights reserved.
//

import UIKit

final class RestaurantsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    #warning("テストデータ使用")
    private var restSearchDataStore = RestSearchDataStore(areaCode: "AREAL2115")
    private var restaurantsDataSource = RestaurantsDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = restaurantsDataSource
        restSearchDataStore.delegate = self
        requestRestSearch()
    }

    private func requestRestSearch() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        restSearchDataStore.requestAPI()
    }
}

extension RestaurantsViewController: RestSearchResult {

    func fetchSucceeded(restaurants: [Restaurant]) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        if restaurantsDataSource.restaurants.isEmpty {
            restaurantsDataSource.setRestaurants(restaurants: restaurants)
        } else {
            restaurantsDataSource.appendRestaurants(restaurants: restaurants)
        }

        tableView.reloadData()
        navigationItem.title = "レストラン一覧(\(restSearchDataStore.total())件)"
    }

    func fetchFailed(errorMessage: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let alert = UIAlertController(title: "エラー", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension RestaurantsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height
            && scrollView.isDragging else {
                return
        }

        if restSearchDataStore.hasMoreRequest() {
            requestRestSearch()
        }
    }
}
