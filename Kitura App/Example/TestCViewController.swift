//
//  TestCViewController.swift
//  Example
//
//  Created by Linhao CUI 崔林豪 on 2023/4/27.
//

import UIKit
import Kitura
import KituraContracts
import NIOHTTP1
import NIO
import KituraNet

class ServerTest: ServerDelegate {
    func handle(request: KituraNet.ServerRequest, response: KituraNet.ServerResponse) {
        print(request.headers)
    }
}

class TestMiddle: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        print("___>>>2222")
        var data: Data = .init()
        let length = try? request.read(into: &data)
        response.status(.created)
        next()
    }
    
    
}

class TestCViewController: UIViewController {

    var serverDelegate: ServerTest = ServerTest()
    var middle = TestMiddle()
    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        self.test_put()
    }
    
    private func test_put() {
        DispatchQueue.global(qos: .background).async {
            let router = Router()
            //router.all(middleware: MyMiddleware())
            router.get("/hello/vapor", allowPartialMatch: true, middleware: self.middle)
            
            //接收到代码
//            router.put("/api/test") { _, _, next in
//                next()
//            }
            
//            router.put("/api/test") { request, response, next in
//                //RouterResponse
//                response.send(data:
//                                """
//                              {
//                               "result_code": "success",
//                                "data": "abcde",
//                                "request_id": "11"
//                              }
//                              """.data(using: .utf8)!)
//
//                //---
//                ///request对象的read方法可以读取请求体，并返回一个Data对象，其中包含了客户端上传的数据。
//                //request.read(as: T##Decodable.Protocol)
//                next()
//            }
            
            let ssl = SSLConfig(withChainFilePath: Bundle.main.path(forResource: "Certificates", ofType: "p12"), withPassword: "123456789")
             
            let options = ServerOptions(requestSizeLimit: Int.max)
            let server = Kitura.addHTTPServer(onPort: 8080, with: router, withSSL: nil, allowPortReuse: true,options: options)
            //let server = Kitura.addHTTPServer(onPort: 8081, with: self.serverDelegate, withSSL: nil, allowPortReuse: true, options: options)
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
    /*
     我们使用HTTPUpload类来处理上传文件。在处理程序中，我们创建了一个HTTPUpload对象并将其关联到要保存的文件上。随后，我们使用decodeData方法从请求中读取数据并将其传递给HTTPUpload对象。这里我们设置了一个最大的数据长度为1MB。同时，我们使用always方法来标记上传完成，以便HTTPUpload对象知道何时上传结束。在上传完成时，我们使用whenComplete方法来检查上传结果并发送回应。

     我们还使用了upload.progressHandler来监控上传进度。这个方法会在上传过程中被多次调用，并提供上传进度的比例。我们将进度作为响应发送回客户端。值得注意的是，upload.progressHandler是在上传过程中被多次调用的，因此这里可以频繁地发送响应
     */
//    private func test_put_file_02() {
//
//        let router = Router()
//
//        router.put("/upload") { request, response, next in
//            guard let filename = request.headers["filename"].first else {
//                response.status(.badRequest)
//                return next()
//            }
//
//            let fileURL = URL(fileURLWithPath: "/path/to/local/file/\(filename)")
//            guard FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil) else {
//                response.status(.internalServerError)
//                return next()
//            }
//
//            let upload = HTTPUpload(fileURL: fileURL, fileSize: nil)
//
//            let _ = request.decodeData(maxLength: 1024 * 1024, on: eventLoopGroup.next()).flatMap { (data) -> EventLoopFuture<Void> in
//                upload.receive(data: data)
//            }.always {
//                upload.finish()
//            }.whenComplete { (result) in
//                switch result {
//                case .success:
//                    response.status(.OK)
//                case .failure(let error):
//                    response.status(.internalServerError)
//                    response.send(error.localizedDescription)
//                }
//                next()
//            }
//
//            // 监控上传进度
//            upload.progressHandler = { progress in
//                response.send("\(progress)")
//            }
//        }
//
//        Kitura.addHTTPServer(onPort: 8081, with: router)
//        Kitura.run()
//    }
    
    /*
     //我们使用put方法将一个路由注册为PUT请求的处理程序。当客户端发起PUT请求时，我们将会收到一个request对象，我们可以从中读取客户端上传的文件名，并创建本地文件以保存上传的内容。同时，我们使用request.on(.data)方法来监控上传进度，计算上传进度并将其发送回客户端。最后，在上传完成时，我们会发送一个OK状态码来告知客户端上传已经完成。
    private func test_put_file() {
    let router = Router()

    router.put("/upload") { request, response, next in
        // 获取上传文件名
        guard let filename = request.headers["filename"]?.first else {
            response.status(.badRequest)
            return next()
        }
        
        // 创建本地文件
        let fileURL = URL(fileURLWithPath: "/path/to/local/file/\(filename)")
        guard FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil) else {
            response.status(.internalServerError)
            return next()
        }
        
        // 监控上传进度
        var bytesReceived = 0
        
        request.on(.data) { data in
            // 将数据写入本地文件
            guard let fileHandle = try? FileHandle(forWritingTo: fileURL) else {
                response.status(.internalServerError)
                return next()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            bytesReceived += data.count
            
            // 计算上传进度并发送回客户端
            let totalBytes = request.headers["Content-Length"].first.flatMap { Int($0) } ?? 0
            let progress = Double(bytesReceived) / Double(totalBytes)
            response.send("\(progress)")
        }
        
        // 完成上传
        request.on(.end) {
            response.status(.OK)
            next()
        }
    }

    //Kitura.addHTTPServer(onPort: 8080, with: router)
    //Kitura.run()
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
    */
    

    
    ///swift Kitura 实现put请求，并将接收到数据存到本地路径
    private func test_put_01() {
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
    
    ///Swift Kitura框架实现PUT请求并将接收到的数据存储到本地路径，并读取文件上传进度条
    ///首先定义了一个结构体MyData，并创建了一个Kitura路由对象。我们使用put方法将一个路由注册为PUT请求的处理程序，并使用get方法注册一个路由来返回上传进度。
    private func test_put_02() {
        let router = Router()

        router.put("/data") { request, response, next in
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
                
                let outputStream = OutputStream(url: fileURL, append: false)!
                outputStream.open()
                
                let bytesWritten = jsonData.withUnsafeBytes { outputStream.write($0, maxLength: jsonData.count) }
                
                outputStream.close()
                
                response.status(.OK)
                next()
            } catch {
                response.status(.internalServerError)
                next()
            }
        }

        router.get("/progress") { request, response, next in
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("myData.json")
            
            if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path) {
                if let fileSize = fileAttributes[FileAttributeKey.size] as? Double {
                    response.send("\(fileSize)")
                    next()
                }
            }
            
            response.send("0")
            next()
        }

        //Kitura.addHTTPServer(onPort: 8080, with: router)
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


}

extension TestViewController {
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
}
