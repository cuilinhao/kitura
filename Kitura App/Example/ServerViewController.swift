import Foundation
import Kitura
import KituraNet
import UIKit


//Visit https://www.kitura.dev for a Getting Started guide, tutorials, and API reference documentation.

class ServerViewController: UIViewController {
    override func loadView() {
        super.loadView()
        self.title = "HTTPS Server"
        self.view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // http://www.m3u8
        
        // 网站访问： http://localhost:8080/
        DispatchQueue.global(qos: .background).async {
            let router = Router()
            router.put("/api/file") { request, response, next in
                request.body
                request.headers
                next()
            }
            router.get("/") { _, response, next in
                response.send("Hello, world!")
                next()
            }
            //--
            router.post("/api/test") { request, response, next in
                // REQUEST 对方请求
                // response 发回去
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
            //https
            //server 有车控证书
            //用证书， 创建一个SSLConfig 就ok
            //不用证书
            /*
             要写解密
             router.post("/api/test") 在这个block里面写
             先解密，再拿原文
             */
            let ssl = SSLConfig(withChainFilePath: Bundle.main.path(forResource: "Certificates", ofType: "p12"),
                                withPassword: "1234567890")
            let server = Kitura.addHTTPServer(onPort: 8080, with: router, withSSL: nil, allowPortReuse: true)
            
            
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
