//
//  TestViewController.swift
//  Example
//
//  Created by Linhao CUI 崔林豪 on 2023/4/26.
//

import UIKit
import Kitura
import KituraNet
import Foundation

struct MyData: Codable {
    let name: String
    let age: Int
}


class TestViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
//        self.test_post()
//        self.test_get()
//        self.test_put()
        self.test_put_02()
    }
    
    private func test_put_02() {
        let router = Router()
        router.put("/api/test") { request, response, next in
            guard let body = try? request.read(as: Data.self),
                  let myData = try? JSONDecoder().decode(MyData.self, from: body)
            else {
                response.status(.badRequest)
                return next()
            }
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(myData)
                
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent("myData.json")
                print("___>>>__put__\(fileURL.absoluteString)")
                try jsonData.write(to: fileURL)
                
                response.status(.OK)
                next()
            } catch {
                response.status(.internalServerError)
                next()
            }
        }
        //Kitura.addHTTPServer(onPort: 8081, with: router)
        //Kitura.run()
        
        //---
        let server = Kitura.addHTTPServer(onPort: 8081, with: router, withSSL: nil, allowPortReuse: true)
        server.started {
            print("[ServerViewController] Server started.")
        }
        server.clientConnectionFailed {
            print("[ServerViewController] Connection from \($0) failed.")
        }
        server.stopped {
            print("[ServerViewController] Server stopped.")
        }
        Kitura.start()
        
    }
    
    private func test_get() {
        DispatchQueue.global(qos: .background).async {
            let router = Router()
            router.get("/") { _, response, next in
                response.send("Hello World!")
                next()
            }
            
            let ssl = SSLConfig(withChainFilePath: Bundle.main.path(forResource: "Certificates", ofType: "p12"), withPassword: "123456789")
            let server = Kitura.addHTTPServer(onPort: 8081, with: router, withSSL: nil, allowPortReuse: true)
            server.started {
                print("[ServerViewController] Server started.")
            }
            server.clientConnectionFailed {
                print("[ServerViewController] Connection from \($0) failed.")
            }
            server.stopped {
                print("[ServerViewController] Server stopped.")
            }
            Kitura.start()
        }
    }
    
    private func test_post() {
        ///测试的时候，可以用2个模拟器进行测试
        DispatchQueue.global(qos: .background).async {
            let router = Router()
            router.post("/api/test") { request, response, next in
                response.send(data:
                                """
                              {
                               "result_code": "success",
                                "data": "abcde",
                                "request_id": "11"
                              }
                              """.data(using: .utf8)!)
                next()
            }
            
            let ssl = SSLConfig(withChainFilePath: Bundle.main.path(forResource: "Certificates", ofType: "p12"), withPassword: "123456789")
            let server = Kitura.addHTTPServer(onPort: 8081, with: router, withSSL: ssl, allowPortReuse: true)
            server.started {
                print("[ServerViewController] Server started.")
            }
            server.clientConnectionFailed {
                print("[ServerViewController] Connection from \($0) failed.")
            }
            server.stopped {
                print("[ServerViewController] Server stopped.")
            }
            Kitura.start()
        }
    }
    
    private func test_put() {
        DispatchQueue.global(qos: .background).async {
            let router = Router()
            //接收到代码
            router.put("/api/test") { request, response, next in
                request.body
                request.headers
                //RouterResponse
                response.send(data:
                                """
                              {
                               "result_code": "success",
                                "data": "abcde",
                                "request_id": "11"
                              }
                              """.data(using: .utf8)!)
                next()
            }
            
            router.put("") { Identifier, dd, next in
                
            }
            
            let ssl = SSLConfig(withChainFilePath: Bundle.main.path(forResource: "Certificates", ofType: "p12"), withPassword: "123456789")
             
            let server = Kitura.addHTTPServer(onPort: 8081, with: router, withSSL: ssl, allowPortReuse: true)
            server.started {
                print("[ServerViewController] Server started.")
            }
            server.clientConnectionFailed {
                print("[ServerViewController] Connection from \($0) failed.")
            }
            server.stopped {
                print("[ServerViewController] Server stopped.")
            }
            Kitura.start()
        }
    }
    


}
