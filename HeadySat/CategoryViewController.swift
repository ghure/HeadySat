//
//  CategoryViewController.swift
//  HeadySat
//
//  Created by Captain on 6/28/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    let categoryObj = CategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryObj.delegate = self
        self.categoryObj.callWebApi()
        
    }
}

extension CategoryViewController: CategoryDelegate {
    func finishLoadingData(error: String?) {
        if let error = error {
            print("error log CategoryViewController:- " + error)
            return
        }
        print(self.categoryObj.jsonModel?.rankings[0].ranking)
    }
}
