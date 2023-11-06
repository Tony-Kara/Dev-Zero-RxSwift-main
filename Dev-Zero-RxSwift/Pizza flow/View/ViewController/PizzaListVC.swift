//
//  PizzaListVC.swift
//  Dev-Zero-RxSwift
//
//  Created by Eniola Anthony on 7/18/23.
//

import Foundation
import UIKit

final class PizzaListVC: UIViewController {
    
    // MARK: - Private properties
    
    private let rootView = PizzaListHomeView()
    private lazy var pizzaViewModel = PizzaViewModel()
    
    private lazy var menuItems = [MenuItem]()  {
        didSet {
            DispatchQueue.main.async {
                self.rootView.tableView.reloadData()
            }
            pizzaViewModel.loadCategoryItems()
        }
    }
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = false
        didTapNextBtn()
        loadMenuItems()
        bindViewModel()
        rootView.delegate = self
        
        rootView.tableView.register(PizzaInfoTableViewCell.self, forCellReuseIdentifier: PizzaInfoTableViewCell.identifier)
        rootView.tableView.register(DrinksToGoTableViewCell.self, forCellReuseIdentifier: DrinksToGoTableViewCell.identifier)
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        
        rootView.bannerViewCollection.register(AdvertisementBannerCollectionCell.self, forCellWithReuseIdentifier: AdvertisementBannerCollectionCell.identifier)
        rootView.bannerViewCollection.dataSource = self
        rootView.bannerViewCollection.delegate = self
        
        rootView.menuCatergoryCollectionView.register(MenuCatergoryCell.self, forCellWithReuseIdentifier: MenuCatergoryCell.identifier)
        rootView.menuCatergoryCollectionView.dataSource = self
        rootView.menuCatergoryCollectionView.delegate = self
    }
    
    // MARK: - Private functions
    
    private func loadMenuItems() {
        pizzaViewModel.loadMenuItems { items in
            self.menuItems = items
        }
        isLoading = true
    }
    
    var isLoading: Bool = false
    {
        didSet {
            switch isLoading {
            case true:
                print("1111-2 changed  it's true")
                rootView.menuCatergoryCollectionView.isScrollEnabled = true
            case false:
                print("1111-2 changed  it's false")
                rootView.menuCatergoryCollectionView.isScrollEnabled = false
            }
        }
    }
    
    func bindViewModel() {
        pizzaViewModel.cartegoryTypesDidChange = { [weak self] in
            Task {
                self?.rootView.menuCatergoryCollectionView.reloadData()
            }
        }
    }
    
    private func didTapNextBtn() {
        rootView.onNextScreenTapped =  {
            let profileInfoListVC = ProfileInfoVC()
            self.navigationController?.pushViewController(profileInfoListVC, animated: true)
        }
    }
}

extension PizzaListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menuItems.count
        }
        else {
            return pizzaViewModel.drinks.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Menu Items"
        } else {
            return "Drinks"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PizzaInfoTableViewCell.identifier, for: indexPath) as! PizzaInfoTableViewCell
            let menuItem = self.menuItems[indexPath.row]
            guard let imageUrl = menuItem.image else { return cell }
            pizzaViewModel.getProductImage(with: imageUrl) { itemImage in
                cell.configure(model: menuItem, image: itemImage)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DrinksToGoTableViewCell.identifier, for: indexPath) as! DrinksToGoTableViewCell
            let drink = pizzaViewModel.drinks[indexPath.row]
            cell.configure(drink: drink)
            return cell
        }
    }
}

extension PizzaListVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            let menuItem = self.menuItems[indexPath.item]
            print("The current tapped pizza is \(menuItem.name)")
        }
    }
}

extension PizzaListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == rootView.bannerViewCollection {
            return pizzaViewModel.bannerImages.count
        }
        
        else {
            return pizzaViewModel.allCartegoryTypes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == rootView.bannerViewCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertisementBannerCollectionCell.identifier, for: indexPath) as! AdvertisementBannerCollectionCell
            let bannerImage = pizzaViewModel.bannerImages[indexPath.row]
            cell.set(image: bannerImage ?? UIImage())
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCatergoryCell.identifier, for: indexPath) as! MenuCatergoryCell
            let categoryItems = pizzaViewModel.allCartegoryTypes[indexPath.row]
            cell.insertData(categoryType: categoryItems)
            return cell
        }
    }
}

extension PizzaListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case rootView.menuCatergoryCollectionView:
            let selectedCategory = pizzaViewModel.allCartegoryTypes[indexPath.item]
            print("The current tapped category is \(String(describing: selectedCategory.menuType?.title))")
        default:
            break;
        }
    }
}

extension PizzaListVC: PizzaListHomeViewDelegate {
    func tapToNextScreen() {
        let profileInfoListVC = ProfileInfoVC()
        self.navigationController?.present(profileInfoListVC, animated: true)
    }
}
