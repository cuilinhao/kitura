//
//  TestBViewController.swift
//  Example
//
//  Created by Linhao CUI 崔林豪 on 2023/4/26.
//

import UIKit
import GCDWebServer

class TestBViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //http://10.171.228.171:8081/
        view.backgroundColor = .systemGray
        let webServer = GCDWebServer()
        //http://10.171.228.171:8080/hello
//         webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: { (request) -> GCDWebServerResponse? in
//
//            let html = "<html><body>欢迎访问 <b>hangge.com</b></body></html>"
//            return GCDWebServerDataResponse(html: html)
//        })
        webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: { (request) -> GCDWebServerResponse? in
           
           let html = "<html><body>欢迎访问 <b>hangge.com</b></body></html>"
           return GCDWebServerDataResponse(html: html)
       })
        
        webServer.start(withPort: 8081, bonjourName: "GCD Web Server")
        print("服务启动成功，使用你的浏览器访问：\(webServer.serverURL!)")
    }
}
