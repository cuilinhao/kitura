<p align="center">
<a href="http://kitura.io/">
<img src="https://raw.githubusercontent.com/Kitura/Kitura/master/Sources/Kitura/resources/kitura-bird.svg?sanitize=true" height="100" alt="Kitura">
</a>
</p>


<p align="center">
<img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift 5.0">
<a href="https://ibm-swift.github.io/Kitura-NIO/index.html">
<img src="https://img.shields.io/badge/apidoc-KituraNIO-1FBCE4.svg?style=flat" alt="APIDoc">
</a>
<a href="https://travis-ci.org/Kitura/Kitura-NIO">
<img src="https://travis-ci.org/Kitura/Kitura-NIO.svg?branch=master" alt="Build Status - Master">
</a>
<img src="https://img.shields.io/badge/os-macOS-green.svg?style=flat" alt="macOS">
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux">
<img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2">
<a href="http://swift-at-ibm-slack.mybluemix.net/">
<img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg" alt="Slack Status">
</a>
</p>

# Kitura-NIO

Kitura-NIO is a [SwiftNIO](https://github.com/apple/swift-nio) based networking library for Kitura. Kitura-NIO adopts the same API as [KituraNet](https://github.com/Kitura/Kitura-net), making the transition from KituraNet to Kitura-NIO seamless. While Kitura-NIO shares some code with Kitura-Net, the core comprising of HTTPServer, ClientRequest/ClientResponse and TLS support have been implemented using SwiftNIO. Kitura-NIO uses [NIOSSL](https://github.com/apple/swift-nio-ssl) for TLS support.

We expect most of our users to require higher level concepts such as routing, templates and middleware. These are not provided in Kitura-NIO. If you want to use those facilities you should be coding at the Kitura level, for this please see the [Kitura](https://github.com/Kitura/Kitura) project. Kitura-NIO, like  [Kitura-net](https://github.com/Kitura/Kitura-net), underpins Kitura which offers a higher abstraction level to users.

Kitura-NIO 2 has been tested with Swift 5. If you are using Swift 4, please use Kitura-NIO 1. See the [release history](https://github.com/Kitura/Kitura-NIO/releases) for details.

## Features

- Port Listening
- HTTP Server support (request and response)
- Basic HTTP client support

## Using Kitura-NIO

With Kitura 2.5 and future releases, to run on top of Kitura-NIO (instead of Kitura-Net) all you need to do is set an environment variable called `KITURA_NIO` before building your Kitura application:

```shell
    export KITURA_NIO=1 && swift build
```

If you have already built your Kitura application using Kitura-Net and want to switch to using `KITURA_NIO`, you need to update the package before building:

```shell
    export KITURA_NIO=1 && swift package update && swift build
```

Using the environment variable we make sure that only one out of Kitura-NIO and Kitura-Net is linked into the final binary.

Please note that though Kitura-NIO has its own GitHub repository, the package name is `KituraNet`. This is because the Kitura-NIO and Kitura-Net are expected to provide identical APIs, and it makes sense if they share the package name too.


## Getting Started

Visit [www.kitura.io](http://www.kitura.io/) for reference documentation.

## Contributing to Kitura-NIO

We'd be more than happy to receive bug reports, enhancement requests and pull requests!

1. Clone this repository.

`$ git clone https://github.com/Kitura/Kitura-NIO && cd Kitura-NIO`

2. Build and run tests.

`$ swift test`

You may also want to run the tests in parallel:
`$ swift test --parallel`

In some Linux environments, a low open file limit could cause test failures. See [this](https://github.com/Kitura/Kitura-NIO/issues/1).

## Community

We'd really love to hear feedback from you.

Join the [Kitura on Swift Forums](https://forums.swift.org/c/related-projects/kitura) or our [Slack](http://swift-at-ibm-slack.mybluemix.net/) to meet the team!

## License

This library is licensed under Apache 2.0. The full license text is available in [LICENSE](https://github.com/Kitura/Kitura-NIO/blob/master/LICENSE.txt).
