//
//  main.swift
//  Mockingbird_Example
//
//  Created by Christian Braun on 30.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Mockingbird_Networking
import Foundation

let testRouter = Router {
    get("/api/account") { _ in
        return Content(fileName:  "account.json", statusCode: .accepted)
    }
    post("/api/account") { _ in
        return Content("Hallo you did a post")
    }
    get("/api/hallo/{{name}}") { request  in
        return Content("Hallo \(request.pathParams["name"]!)")
    }
}

let configuration = URLSessionConfiguration.default
configuration.protocolClasses = [MockingbirdURLProtocol.self]
MockingbirdURLProtocol.router = testRouter
let session = URLSession(configuration: configuration)

func main() {
    session.dataTask(with: URL(string:"https://localhost/api/hallo/hendrik")!) { data, response, error in
        if let error = error {
            print(error)
            return
        }
        print(String(data: data!, encoding: .utf8) ?? "")
        print(response!)
    }.resume()
}

main()
RunLoop.main.run()


