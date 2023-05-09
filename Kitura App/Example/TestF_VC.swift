//
//  TestF_VC.swift
//  Example
//
//  Created by Alex PEI 裴晓磊 on 2023/4/28.
//

import Foundation
import UIKit
import Socket

class TestF_VC: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow

        let server = Server(port: 8081)

        server.delegate = self

        DispatchQueue.global(qos: .background).async {

            server.start()
        }

        server.checkDocumentD(true)

    }

}

fileprivate class Server {

    let port: Int
    var listenSocket: Socket?

    var delegate:  TestF_VC?

    init(port: Int) {
        self.port = port
    }

    func start() {
        do {
            // Create the listen socket
            listenSocket = try Socket.create()
            try listenSocket?.listen(on: port)

            // Accept incoming connections
            while true {
                let clientSocket = try listenSocket?.acceptClientConnection()
                // Handle the client connection
                handleClient(clientSocket)
            }

        } catch {
            print("Error: \(error)")
        }
    }

    func handleClient(_ clientSocket: Socket?) {
        guard let clientSocket = clientSocket else { return }

        print("New client connected from: \(clientSocket.remoteHostname)")

        do {

            let fileManager = FileManager.default
            let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let tfileURL = documentsDirectory.appendingPathComponent("received_file")
            //fileURL.appendingPathExtension(<#T##pathExtension: String##String#>)


            let fileURL = documentsDirectory
                .appendingPathComponent(tfileURL.deletingPathExtension().lastPathComponent + ".mp4")
            debugPrint("@@_ add file tp: \(fileURL) ")

            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
            fileManager.createFile(atPath: fileURL.path, contents: nil)
            
            var buffer = Data()
            // Receive data from client
            while true {
                let bytesRead = try clientSocket.read(into: &buffer)

//                for x in buffer {
//                    let c = Character.init(.init(x))
//                    print("@@_buffer data \(c)")
//                }

                debugPrint("@@_?? \(bytesRead)")

                if bytesRead == 0 {
                    print("Client disconnected")
                    return
                }

                // Process received data here
                //debugPrint("@@_ \(bytesRead)")

                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(buffer)

                buffer.removeAll()

                self.checkDocumentD()
            }
        } catch {
            print("Error: \(error)")
        }
    }

    func save() {
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentsDirectory.appendingPathComponent("received_file.mp4")

        debugPrint("@@_ share url: \(fileURL)")

        // 创建分享控制器
        let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

        // 指定可选项
        activityController.excludedActivityTypes = [
            .addToReadingList,
            .airDrop,
            .assignToContact,
            .copyToPasteboard,
            .mail,
            .markupAsPDF,
            .message,
            .openInIBooks,
            .postToFacebook,
            .postToFlickr,
            .postToTencentWeibo,
            .postToTwitter,
            .postToVimeo,
            .postToWeibo,
            .print,
            .saveToCameraRoll,
            .copyToPasteboard
        ]

        DispatchQueue.main.async {
            // 显示分享控制器
            self.delegate?.present(activityController, animated: true, completion: nil)
        }

    }

    func checkDocumentD(_ needClearAll: Bool = false) {
        // print
        let fileManager = FileManager.default
        let documentsDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let aFileURLs = try! fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])

        debugPrint("@@_ 文件夹： \(documentsDirectory)")

        for url in aFileURLs {

            let size = try! fileManager.attributesOfItem(atPath: url.path)[.size] as! Int64
            let fileSizeString = ByteCountFormatter.string(fromByteCount: size, countStyle: .file)

            print("file: \(url.lastPathComponent) size: \(fileSizeString) realsize:\(size)")
            needClearAll ? try? fileManager.removeItem(at: url) : ()


            if size >= 7654044 {
                self.save()
            }
        }

        guard needClearAll else { return }

        let bFileURLs = try! fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
        if bFileURLs.isEmpty {
            debugPrint("@@_ 清空")
        }
    }
}
