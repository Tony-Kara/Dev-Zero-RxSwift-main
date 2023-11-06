//
//  PizzaViewModel.swift
//  Dev-Zero-RxSwift
//
//  Created by Eniola Anthony on 7/18/23.
//

import Foundation
import UIKit

class PizzaViewModel {
    
    let apiService = ApiService()
    var menuItems: [MenuItem] = [MenuItem]()
    var bannerImages : [UIImage?] = [UIImage(named: "Banner1"), UIImage(named: "Banner2"), UIImage(named: "Banner3")]
    let drinks = [ "Pepsi", "Cola", "Sprite", "Ice Tea" ]
    var cartegoryTypesDidChange: (() -> Void)?

    
    var others: CategoryTypes?
    var pizza: CategoryTypes?
    var combo: CategoryTypes?
    var beverage: CategoryTypes?
    var dessert: CategoryTypes?
    
    func loadMenuItems(_ completion: @escaping ([MenuItem]) -> Void) {
        apiService.getMenu { items in
            self.menuItems = items
            completion(items)
        }
    }
    
    func getProductImage(with url: URL,  _ completion: @escaping (UIImage) -> Void) {
        apiService.getImage(url: url) { productImage in
            completion(productImage)
        }
    }

    lazy var allCartegoryTypes = [CategoryTypes]() {
        didSet {
            cartegoryTypesDidChange?()
        }
    }

    func loadCategoryItems() {
        if !self.menuItems.isEmpty {
            for menuItem in menuItems {
                switch menuItem.category {
                case .pizza:
                    let pizza = CategoryTypes(id: 4, menuType: .Pizza, category: menuItem.category.rawValue)
                    self.pizza = pizza
                case .combo:
                    let combo = CategoryTypes(id: 2, menuType: .Combo, category: menuItem.category.rawValue)
                    self.combo = combo
                case .beverage:
                    let beverage = CategoryTypes(id: 1, menuType: .Beverage, category: menuItem.category.rawValue)
                    self.beverage = beverage
                case .dessert:
                    let dessert = CategoryTypes(id: 3, menuType: .Dessert, category: menuItem.category.rawValue)
                    self.dessert = dessert
                case .others:
                    let others = CategoryTypes(id: 0, menuType: .Others, category: "Others")
                    self.others = others
                }
            }

            if let pizza = self.pizza {
                self.allCartegoryTypes.append(pizza)
            }

            if let combo = self.combo {
               allCartegoryTypes.append(combo)
            }

            if let beverage = self.beverage {
                allCartegoryTypes.append(beverage)
            }

            if let dessert = self.dessert {
                allCartegoryTypes.append(dessert)
            }

            if let others = self.others {
                allCartegoryTypes.append(others)
            }
        }
    }
}
