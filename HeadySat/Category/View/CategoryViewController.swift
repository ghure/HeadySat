//
//  CategoryViewController.swift
//  HeadySat
//
//  Created by Captain on 6/28/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    private let categoryObj = CategoryViewModel()
    @IBOutlet weak var tableView: UITableView!
    private let catCell = "catCell"
    private let defaultCell = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryObj.delegate = self
        self.categoryObj.callWebApi()
        self.loadTableView()
    }
    
    func loadTableView() {
        self.tableView.register(UINib(nibName: WithLabelTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: catCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let jsonModel = self.categoryObj.jsonModel {
            return jsonModel.categories.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: WithLabelTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.catCell, for: indexPath) as? WithLabelTableViewCell{
            if let jsonModel = self.categoryObj.jsonModel {
                let obj = jsonModel.categories[indexPath.row]
                cell.titleLable.text = obj.name
                cell.visualView.backgroundColor = (indexPath.row % 2) == 0 ? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1): #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCell)
        cell?.textLabel?.text = "No cell to display"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller: SubCategoryViewController = self.storyboard?.instantiateViewController(identifier: "SubCategoryViewController") as? SubCategoryViewController {
            if let jsonModel = self.categoryObj.jsonModel {
                controller.addSubCategory(subCategory: jsonModel.categories[indexPath.row].products)
            }
            if let navigation = self.navigationController {
                navigation.pushViewController(controller, animated: true)
            } else {
                print("error log CategoryViewController:- No navigation found")
            }
        } else {
            print("error log CategoryViewController:- No SubCategoryViewController found")
        }
    }
}
// MARK:- Catagory Delegate
extension CategoryViewController: CategoryDelegate {
    func finishLoadingData(error: String?) {
        if let error = error {
            print("error log CategoryViewController:- " + error)
            return
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
