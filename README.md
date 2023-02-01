# Mockingbird

Mock your network requests by defining responses.

## Getting Started
1. Create your fixtures. Either as a file, encodable types or just a plain string and add them to your app target
2. Define your custom router the way it is described in [Routing](#routing)
3. Configure the `MockingbirdURLProtocol`to use your custom router
3. Configure your `URLSession` to use the `MockingbirdURLProtocol`

```swift
#if DEBUG
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingbirdURLProtocol.self]
        MockingbirdURLProtocol.router = router
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        urlSession = session
#endif
``` 


A good way to integrate `Mockingbird` into your testing routine is by switching it on and off by using commandline arguments.

```swift
        if CommandLine.arguments.contains("-mock_backend") {
            configureMock()
        }
```

It is strongly recommended to remove all mocked related code before shipping the application. Therefore you can use the exclude rules within the build settings.

## Routing 

A  router with `Mockingbird` looks like this:
```swift
let router = Router {
    get("/api/account") { _ in
        Content(fileName:  "account.json", statusCode: .accepted)
    }
    post("/api/account") { _ in
        Content("Hallo you did a post")
    }
    get("/api/hallo/{{name}}") { request in
        Content("Hallo \(request.pathParams["name"]!)", delay: 5)
    }
}
```

You can define path params by using a `{{placeholder}}` which will be handed into the content closure as a part of the `RequestMetadata`.
Use the `Content` type also to specify the status code and response headers. You can also create a content response with all encodable types as they will automatically be encoded to json. 


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

```
    pod 'Mockingbird', :configurations => ['Debug']
```
