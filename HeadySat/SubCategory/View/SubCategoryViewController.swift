//
//  SubCategoryViewController.swift
//  HeadySat
//
//  Created by Captain on 6/29/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import UIKit

class SubCategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var products: [ProductModel] = []
    private let catCell = "subCatCell"
    private let defaultCell = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTableView()
    }
    
    func loadTableView() {
        self.tableView.register(UINib(nibName: WithLabelTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: self.catCell)
           self.tableView.delegate = self
           self.tableView.dataSource = self
       }
    
    func addSubCategory(subCategory products: [ProductModel]) {
        self.products = products
    }
}

extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: WithLabelTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.catCell, for: indexPath) as? WithLabelTableViewCell{
            
            let obj = self.products[indexPath.row]
                cell.titleLable.text = obj.name
                cell.visualView.backgroundColor = (indexPath.row % 2) == 0 ? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1): #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCell)
        cell?.textLabel?.text = "No cell to display"
        return cell!
    }
}
