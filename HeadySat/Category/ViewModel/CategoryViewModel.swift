//
//  CategoryViewModel.swift
//  HeadySat
//
//  Created by Captain on 6/28/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import Foundation

import Foundation

protocol CategoryDelegate {
    func finishLoadingData(error: String?)
}

class CategoryViewModel {
    var rawJson: JsonModel?
    var jsonModel: JsonModel?
    var delegate: CategoryDelegate?
    
    func callWebApi() {
        var api = NetworkHelper()
        api.delegate = self
        api.callApi(configrationUrl: .json)
    }
}

extension CategoryViewModel: NeworkLoadingDelegate {
    func didApiFinishedLoadingWithError(error: Error?, message: String?, httpResponse: HTTPURLResponse?) {
        var messageStr: String? = nil
        if let error = error {
            messageStr = error.localizedDescription
        } else if let message = message {
            messageStr = message
        } else if let _ = httpResponse {
            messageStr = "Internal server error!!"
        }
        
        if let delegate = self.delegate {
            delegate.finishLoadingData(error: messageStr)
        }
    }
    
    func didApiFinishedLoadingWithSuccess(data: Any?) {
        if let data = data as? Data {
            do {
                let decoder = JSONDecoder()
                self.jsonModel = try decoder.decode(JsonModel.self, from: data)
                self.rawJson = self.jsonModel
                if let delegate = self.delegate {
                    delegate.finishLoadingData(error: nil)
                }
            } catch let error {
                self.didApiFinishedLoadingWithError(error: error, message: nil, httpResponse: nil)
            }
        }
    }
    
    func sortDataAsPerFilter(Ranking obj: RankingModel) {
        
        let ranking = obj.products.sorted { (obj1, obj2) -> Bool in
            if let orderCount = obj1.order_count {
                return orderCount > obj2.order_count!
            }
            if let viewCount = obj1.view_count {
                return viewCount > obj2.view_count!
            }
            
            return obj1.shares! > obj2.shares!
        }
        
        var categories:[CategoryModel] = []
        for item in ranking {
            if let obj = self.rawJson?.categories.first(where: { (value) -> Bool in
                return value.id == item.id
            }) {
            categories.append(obj)
            }
        }
        self.jsonModel?.categories = categories
        if let delegate = self.delegate {
            delegate.finishLoadingData(error: nil)
        }
    }
}
