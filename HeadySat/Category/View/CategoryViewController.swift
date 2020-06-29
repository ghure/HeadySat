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
    private var filteBtn: UIButton?
    private var variantVC: VariantViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryObj.delegate = self
        self.categoryObj.callWebApi()
        self.loadTableView()
        self.addFilterButton()
    }
    
    func loadTableView() {
        self.tableView.register(UINib(nibName: WithLabelTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: catCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func addFilterButton() {
        self.filteBtn = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 80, width: 60, height: 60))
        self.filteBtn?.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.filteBtn?.setTitle("🔍", for: .normal)
        self.filteBtn?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.filteBtn?.layer.cornerRadius = (self.filteBtn?.frame.height)!/2
        self.filteBtn?.addTarget(self, action: #selector(self.didFilterBtnPressed(_:)), for: .touchUpInside)
        self.view.addSubview(self.filteBtn!)
    }
    
    @objc func didFilterBtnPressed(_ sender: UIButton) {
        if let variantVC = self.variantVC {
            variantVC.view.removeFromSuperview()
        }
        self.variantVC = self.storyboard?.instantiateViewController(identifier: "VariantViewController") as? VariantViewController
        
        if let variantVC = self.variantVC {
        variantVC.addIndex( tableViewSelection: true)
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
                if (jsonModel.categories[indexPath.row].products.count == 0) {
                    print("No products")
                    return
                }
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

extension CategoryViewController: PopOverViewDelegate {
    func getSelectedIndex(mainIndexPath index: IndexPath?, currentIndexPath currentIndex: IndexPath) {
        self.variantVC?.view.removeFromSuperview()
        if let json = self.categoryObj.jsonModel {
            let obj = json.rankings[currentIndex.row]
            self.categoryObj.sortDataAsPerFilter(Ranking: obj)
        }
    }
    
    func getTableViewCount(IndexPath index: IndexPath?) -> Int {
        if let json = self.categoryObj.jsonModel {
        return json.rankings.count
        }
        return 0
    }
    
    func getCellConfigration(cell: WithLabelTableViewCell, mainIndexPath index: IndexPath?, currentIndexPath currentIndex: IndexPath) -> WithLabelTableViewCell {
        if let json = self.categoryObj.jsonModel {
            let obj = json.rankings[currentIndex.row]
            cell.titleLable.text = obj.ranking
        }
        return cell
    }
}
