//
//  AcronymRequest.swift
//  iVapor
//
//  Created by larms on 8/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import Foundation

enum AcronymUserRequestResult {
    case success(User)
    case failure
}

struct AcronymRequest {
    let resource: URL
    init(acronymID: Int) {
        let resourceString = "http://localhost:8080/api/acronyms/\(acronymID)"
//        let resourceString = "https://usingvapor3.vapor.cloud/api/acronyms/\(acronymID)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resource = resourceURL
    }
    
    /// 获取Acronym对应的User
    ///
    /// - Parameter completion: completion(_:)闭包, 返回结果
    func getUser(completion: @escaping (AcronymUserRequestResult) -> Void) {
        // 获取Acronym对应的User的url, http://localhost:8080/api/acronyms/acronymID/user
        let url = resource.appendingPathComponent("user")
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            // 本地获取数据时模拟请求延迟
            Thread.sleep(forTimeInterval: 1.25)
            
            // 确保响应有数据, 否则传递 .failure
            guard let jsonData = data else {
                completion(.failure)
                return
            }
            
            do {
                // 将响应体解码为一个User对象, 并调用具有成功结果的完成处理程序。
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                // 传递 .success, 并返回 此 User
                completion(.success(user))
            } catch {
                // 捕获到任何错误则返回失败
                completion(.failure)
            }
        }
        
        dataTask.resume()
    }
    
    /// 获取Acronym对应的Category数组
    ///
    /// - Parameter completion: completion(_:)闭包, 返回结果
    func getCategories(completion: @escaping (GetResourcesRequest<Category>) -> Void) {
        // 获取Acronym对应的categories的url, http://localhost:8080/api/acronyms/acronymID/categories
        let url = resource.appendingPathComponent("categories")
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            // 本地获取数据时模拟请求延迟
            Thread.sleep(forTimeInterval: 1.25)
            
            guard let jsonData = data else {
                completion(.failure)
                return
            }
            
            do {
                // 将响应数据解码为 Category数组
                let categories = try JSONDecoder().decode([Category].self, from: jsonData)
                completion(.success(categories))
            } catch {
                completion(.failure)
            }
        }
        
        dataTask.resume()
    }
}
