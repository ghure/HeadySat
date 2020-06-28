//
//  UrlConfig.swift
//  HeadySat
//
//  Created by Captain on 6/28/20.
//  Copyright © 2020 Captain. All rights reserved.
//

import Foundation

enum UrlConfigEnum {
    
    case json
    var baseURL: URL {
        return URL(string: "https://stark-spire-93433.herokuapp.com")!
    }
    var path: String {
        switch self {
        case .json:
            return "/json"
        }
    }

    var url: URL {
        let path = self.path
        let baseURL = self.baseURL
        let url = URL(string: path, relativeTo: baseURL)
        return url!
    }
}
