//
//  TestDViewController.swift
//  Example
//
//  Created by Linhao CUI 崔林豪 on 2023/5/8.
//

import UIKit
import Vapor
import NIOFoundationCompat

// Mark: - Models

protocol Sticker: Codable {
}

//public struct StickerString: Sticker,  Codable, /*ResponseEncodable*/{
//    //public func encodeResponse(for request: Vapor.Request) -> NIOCore.EventLoopFuture<Vapor.Response> {
//        //print("___>>>_111")
//    //}
//    let fontName: String
//    let character: String
//}

public struct StickerBitmap: Sticker,  Codable, Equatable {
    let imageName: String
}

class TestDViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.test3()
    }
    
}

extension TestDViewController {
    
    func test22() {
        let app = try? Application(.detect())
        //let serverConfig = HTTPServerConfig.default(port: 8123)
        //services.register(serverConfig)
        //try? app?.server.start(address: .hostname("127.0.0.1", port: 8081))
        defer { app?.shutdown() }
        app?.get("hello") { req in
            return "Hello, world."
        }
        try? app?.run()
    }
    
    func test() {
        let app = Application()
        //访问：http://vapor.codes/hello/vapor
        app.get("hello", "vapor") { req in
            print("___>>>_\(req)")
            return "Hello, vapor!"
        }
        //0.0.0.0是监听ipv4 的任意端口
        try! app.server.start(address: .hostname("0.0.0.0", port: 8080))
        //run里面包含start,故不能和start一起用
        //try! app.run()
    }
    
    
    func test2() {
        let app = Application()
        app.on(.PUT, "upload", body: .stream) { req -> String in
            //req.fileio
            print("___>>>_ 上传 文件回调")
            let data = ByteBuffer(string: "ByteBuffer")
            try! req.fileio.writeFile(data, at: "/path/to/file.txt")
            
            //req.fileio.writeFile(data, at: "").foldWithEventLoop(req.eventLoop) { _, o, e in
            //  print("___>>>_\(o)___\(e)")
            //}
            return "test"
        }
        //0.0.0.0是监听ipv4 的任意端口
        try! app.server.start(address: .hostname("0.0.0.0", port: 8080))
    }
    
    func test3() {
        let app = Application(.testing)
        app.routes.defaultMaxBodySize = ByteCount(value: Int.max)
        /*
         app.on(.PUT, "upload", body: .stream) { request in
         //req.fileio
         print("___>>>_ 上传 文件回调")
         /*
          let data = ByteBuffer(string: "ByteBuffer")
          try! req.fileio.writeFile(data, at: "/path/to/file.txt")
          */
         let size = Int(request.headers["Content-Length"].first!)!
         print(size)
         
         var partial = 0
         request.body.drain {
         print("___>>>_ 上传 数据回调")
         switch $0 {
         case let .buffer(buffer):
         //---
         print(buffer.readableBytes)
         partial += Data(buffer: buffer).count
         print(partial, partial == size)
         case let .error(error):
         print(error)
         case .end:
         print(size == partial)
         
         }
         
         return request.eventLoop.makeSucceededVoidFuture()
         }
         
         print(size == partial)
         
         //req.fileio.writeFile(data, at: "").foldWithEventLoop(req.eventLoop) { _, o, e in
         //  print("___>>>_\(o)___\(e)")
         //}
         return Response(status: .created)
         }
         */
        app.on(.PUT, "upload", body: .stream) { req in
            let done = req.eventLoop.makePromise(of: Response.self)
            
            let size = Double(req.headers["Content-Length"].first!)!
            print(size)
            
            //let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(UUID().uuidString, isDirectory: false)
            let fileManager = FileManager.default
            var url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("MP4s", isDirectory: true)
            ///创建文件
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            
            ///创建文件名
            url.appendPathComponent("received_file.mp4", isDirectory: false)
            //url.appendPathComponent("received_file.ts", isDirectory: false)
            debugPrint("@@_ add file tp: \(url)")
            try? fileManager.removeItem(at: url)
            fileManager.createFile(atPath: url.path, contents: nil)
            
            let fileHandle = try FileHandle(forWritingTo: url)
                                                                                   
            print("__>>>\(url.path)")
            //let handle = OutputStream(url: url, append: false)!
            
            var total: Double = 0
            req.body.drain { result in
                let promise = req.eventLoop.makePromise(of: Void.self)
                //768163530
                switch result {
                case .buffer(let buffer):
                    total += Double(Data(buffer: buffer).count)
                    //Data(buffer: buffer)
                    let ff = Data(buffer: buffer)
                    //这个会crash
                    //func write<T>(contentsOf data: T) throws where T : DataProtocol
                    //这个api最多支持iOS13.4 故不可用
                    // fileHandle.write(ff) 这个方法会给OC抛出一个异常，swift捕获不到，就会crash
                    fileHandle.write(ff)
                    print("\(total / size * 100)")
                    promise.succeed(())
                case .error(let error):
                    done.fail(error)
                    
                case .end:
                    //handle.close()
                   try? fileHandle.close()
                    promise.succeed(())
                    done.succeed(Response(status: .created))
                }
                
                // manually return pre-completed future
                // this should balloon in memory
                // return req.eventLoop.makeSucceededFuture(())
                
                // return real future that indicates bytes were handled
                // this should use very little memory
                return promise.futureResult
            }
            return done.futureResult
        }
        
        //0.0.0.0是监听ipv4 的任意端口
        try! app.server.start(address: .hostname("0.0.0.0", port: 8080))
    }
    
    func handler_error() {
        let app = Application(.testing)
        app.routes.defaultMaxBodySize = ByteCount(value: Int.max)
        /*
         app.on(.PUT, "upload", body: .stream) { request in
         //req.fileio
         print("___>>>_ 上传 文件回调")
         /*
          let data = ByteBuffer(string: "ByteBuffer")
          try! req.fileio.writeFile(data, at: "/path/to/file.txt")
          */
         let size = Int(request.headers["Content-Length"].first!)!
         print(size)
         
         var partial = 0
         request.body.drain {
         print("___>>>_ 上传 数据回调")
         switch $0 {
         case let .buffer(buffer):
         //---
         print(buffer.readableBytes)
         partial += Data(buffer: buffer).count
         print(partial, partial == size)
         case let .error(error):
         print(error)
         case .end:
         print(size == partial)
         
         }
         
         return request.eventLoop.makeSucceededVoidFuture()
         }
         
         print(size == partial)
         
         //req.fileio.writeFile(data, at: "").foldWithEventLoop(req.eventLoop) { _, o, e in
         //  print("___>>>_\(o)___\(e)")
         //}
         return Response(status: .created)
         }
         */
        app.on(.PUT, "upload", body: .stream) { req in
            let done = req.eventLoop.makePromise(of: Response.self)
            
            let size = Double(req.headers["Content-Length"].first!)!
            print(size)
            
            //let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(UUID().uuidString, isDirectory: false)
            let fileManager = FileManager.default
            var url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("MP4s", isDirectory: true)
            ///创建文件
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            
            ///创建文件名
            url.appendPathComponent("received_file.mp4", isDirectory: false)
            //url.appendPathComponent("received_file.ts", isDirectory: false)
            debugPrint("@@_ add file tp: \(url)")
            try? fileManager.removeItem(at: url)
            fileManager.createFile(atPath: url.path, contents: nil)
            
            //let fileHandle = try FileHandle(forWritingTo: url)
                                                                                   
            print("__>>>\(url.path)")
            //let handle = OutputStream(url: url, append: false)!
            
            var total: Double = 0
            req.body.drain { result in
                let promise = req.eventLoop.makePromise(of: Void.self)
                //768163530
                switch result {
                case .buffer(let buffer):
                    total += Double(Data(buffer: buffer).count)
                    //Data(buffer: buffer)
                    let ff = Data(buffer: buffer)
                    let fileHandle: FileHandle
                    do {
                         fileHandle = try FileHandle(forWritingTo: url)
                    } catch {
                        done.fail(error)
                        break
                    }
                    //这个会crash
                    //func write<T>(contentsOf data: T) throws where T : DataProtocol
                    //这个api最多支持iOS13.4 故不可用
                    // fileHandle.write(ff) 这个方法会给OC抛出一个异常，swift捕获不到，就会crash
                    fileHandle.write(ff)
                    print("\(total / size * 100)")
                    promise.succeed(())
                case .error(let error):
                    done.fail(error)
                    
                case .end:
                    //handle.close()
                   //try? fileHandle.close()
                    promise.succeed(())
                    done.succeed(Response(status: .created))
                }
                
                // manually return pre-completed future
                // this should balloon in memory
                // return req.eventLoop.makeSucceededFuture(())
                
                // return real future that indicates bytes were handled
                // this should use very little memory
                return promise.futureResult
            }
            return done.futureResult
        }
        
        //0.0.0.0是监听ipv4 的任意端口
        try! app.server.start(address: .hostname("0.0.0.0", port: 8080))
    }
    
    func test33() {
        let app = Application(.testing)
        app.routes.defaultMaxBodySize = ByteCount(value: Int.max)
        /*
         app.on(.PUT, "upload", body: .stream) { request in
         //req.fileio
         print("___>>>_ 上传 文件回调")
         /*
          let data = ByteBuffer(string: "ByteBuffer")
          try! req.fileio.writeFile(data, at: "/path/to/file.txt")
          */
         let size = Int(request.headers["Content-Length"].first!)!
         print(size)
         
         var partial = 0
         request.body.drain {
         print("___>>>_ 上传 数据回调")
         switch $0 {
         case let .buffer(buffer):
         //---
         print(buffer.readableBytes)
         partial += Data(buffer: buffer).count
         print(partial, partial == size)
         case let .error(error):
         print(error)
         case .end:
         print(size == partial)
         
         }
         
         return request.eventLoop.makeSucceededVoidFuture()
         }
         
         print(size == partial)
         
         //req.fileio.writeFile(data, at: "").foldWithEventLoop(req.eventLoop) { _, o, e in
         //  print("___>>>_\(o)___\(e)")
         //}
         return Response(status: .created)
         }
         */
        app.on(.PUT, "upload", body: .stream) { req in
            let done = req.eventLoop.makePromise(of: Response.self)
            
            let size = Double(req.headers["Content-Length"].first!)!
            print(size)
            
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(UUID().uuidString, isDirectory: false)
            print("__>>>\(url.path)")
            let handle = OutputStream(url: url, append: false)!
            
            var total: Double = 0
            req.body.drain { result in
                let promise = req.eventLoop.makePromise(of: Void.self)
                //768163530
                switch result {
                case .buffer(let buffer):
                    total += Double(Data(buffer: buffer).count)
                    promise.succeed(())
                    //Data(buffer: buffer)
                    let ff = Data(buffer: buffer)
                    buffer.readableBytesView.withUnsafeBytes {
                        guard !$0.isEmpty else { return }
                        
                        let bytesWritten = handle.write($0.assumingMemoryBound(to: UInt8.self).baseAddress!,
                                     maxLength: $0.count)
                        guard bytesWritten == $0.count else {
                            return
                        }
                    }
                    print("\(total / size * 100)")
                case .error(let error):
                    done.fail(error)
                    
                case .end:
                    handle.close()
                    promise.succeed(())
                    done.succeed(Response(status: .created))
                }
                
                // manually return pre-completed future
                // this should balloon in memory
                // return req.eventLoop.makeSucceededFuture(())
                
                // return real future that indicates bytes were handled
                // this should use very little memory
                return promise.futureResult
            }
            return done.futureResult
        }
        
        //0.0.0.0是监听ipv4 的任意端口
        try! app.server.start(address: .hostname("0.0.0.0", port: 8080))
    }
}



extension TestDViewController {
    func put_file() {
        // Increases the streaming body collection limit to 500kb
        //app.routes.defaultMaxBodySize = "500kb"
        
        let app = Application()
        //0.0.0.0是监听ipv4 的任意端口
        try! app.server.start(address: .hostname("0.0.0.0", port: 8080))
        
        // Request body will not be collected into a buffer.
        
        //        app.on(.POST, "upload", body: .stream) { req in
        //            let recentStickers = try? JSONDecoder().decode([StickerString].self, from: req.body.data!)
        //            print("___>>>_\(req)")
        //        }
    }
    
}
