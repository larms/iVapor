//
//  ResourceRequest.swift
//  iVapor
//
//  Created by larms on 4/6/2018.
//  Copyright © 2018年 larms. All rights reserved.
//

import Foundation

/// 这个enum表示泛型的GetResourcesRequest类型, 并提供2种情况
///
/// - success: 成功, 存储ResourceType数组
/// - failure: 失败
enum GetResourcesRequest<ResourceType> {
    case success([ResourceType])
    case failure
}

/// 一个管理资源请求的泛型ResourceRequest类型, 其泛型参数必须遵循Codable,
struct ResourceRequest<ResourceType> where ResourceType: Codable {
    let baseURL = "http://localhost:8080/api/"  // 本地测试baseURL
//    let baseURL = "https://usingvapor3.vapor.cloud/api/"    // https://<vapor_cloud_url>/api/
    let resourceURL: URL
    
    // 初始化
    init(resourcePath: String) {
        guard let resourceURL = URL(string: baseURL) else {
            fatalError()
        }
        // 拼接路径
        self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
    }
    
    /// 从API获取ResourceType的所有值, 需要一个 completion(_:)闭包 作为参数传递结果
    ///
    /// - Parameter completion: completion(_:)闭包, 返回结果
    func getAll(completion: @escaping (GetResourcesRequest<ResourceType>) -> Void) {
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = 2.0
//        sessionConfig.timeoutIntervalForResource = 3.0
//        let session = URLSession(configuration: sessionConfig)
        
        // 通过 resourceURL 创建 dataTask
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            // 本地获取数据时模拟请求延迟
            Thread.sleep(forTimeInterval: 1.25)

            // 确保响应有数据, 否则调用 completion(_:)闭包 传递 .failure
            guard let jsonData = data else {
                completion(.failure)
                return
            }
            
            do {
                // 将响应数据解码为 ResourceTypes数组
                let resources = try JSONDecoder().decode([ResourceType].self, from: jsonData)
                // 调用 completion(_:)闭包 传递 .success, 并返回 ResourceTypes数组
                completion(.success(resources))
            } catch {
                // 捕获到任何错误则返回失败
                completion(.failure)
            }
        }
        
        // 任务开始
        dataTask.resume()
    }
}
