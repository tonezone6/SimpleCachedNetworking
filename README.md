# SimpleCachedNetworking

In addition to SimpleNetworking, SimpleCachedNetworking helps you to save requested resources.  

## Usage
Just load your resource using URLSession  `cached` instance:

```swift
var request: URLRequest {
    let endpoint = URLSession.Endpoint(path: "/api/endpoint")
    return URLRequest(url: endpoint.url!)
}

URLSession.cached.load(FooBar.self, with: request) { result in
    switch result {
    case .failure(let error):
        // handle error...
    case .success(let fooBar):
        // do something... 
    }
}
```

To clean-up cache just call

```swift
try URLSession.cached.cleanup()
```

or you can use a cleanup policy:

```swift
let size = 50 * 1024 * 1024 // 50 MB
let policy = MaxSizeCleanupPolicy(size: size)
URLSession.cached.cleanup(using: policy)
```



