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
    private var variantVC: VariantViewController?
    
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
                cell.visualView.backgroundColor = (indexPath.row % 2) == 0 ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1): #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.defaultCell)
        cell?.textLabel?.text = "No cell to display"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let variantVC = self.variantVC {
            variantVC.view.removeFromSuperview()
        }
        self.variantVC = self.storyboard?.instantiateViewController(identifier: "VariantViewController") as? VariantViewController
        
        if self.products[indexPath.row].variants.count == 0 {
            print("No variants founds")
            return
        }
        
        if let variantVC = self.variantVC {
        variantVC.addIndex(indexPath: indexPath)
            variantVC.delegate = self
        self.addChild(variantVC)
        self.view.addSubview(variantVC.view)
        variantVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        variantVC.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7146511884)
        variantVC.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
        }
    }
}

extension SubCategoryViewController: PopOverViewDelegate {
    func getSelectedIndex(mainIndexPath index: IndexPath?, currentIndexPath currentIndex: IndexPath) {
        
    }
    
    func getTableViewCount(IndexPath index: IndexPath?) -> Int {
        if let index = index {
            return self.products[index.row].variants.count
        }
        return 0
    }
    
    func getCellConfigration(cell: WithLabelTableViewCell, mainIndexPath index: IndexPath?, currentIndexPath currentIndex: IndexPath) -> WithLabelTableViewCell {
        if let index = index {
         
                        let obj = self.products[index.row].variants[currentIndex.row]
            
                            var title = "Color: " + obj.color
                        if let size = obj.size {
                            title = "\n" + title + " Size:" + String(size)
                        }
                        if let price = obj.price {
                            title = "\n" + title + " Price: ₹" + String(price)
                        }
            cell.titleLable.text = title
        }
        
        return cell
    }
}
