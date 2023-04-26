Pod::Spec.new do |s|
  s.name = "KituraNIO"
  s.version = "3.1.0"
  s.summary = "A networking library for Kitura, based on SwiftNIO."
  s.homepage = "https://www.kitura.dev"
  s.license = { :type => "Apache License, Version 2.0" }
  s.author = "IBM"

  s.module_name = "KituraNet"

  s.osx.deployment_target = "10.11"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"

  s.source = { :git => "https://github.com/Kitura/Kitura-NIO.git", :tag => s.version }
  s.source_files = "Sources/#{s.module_name}/**/*.swift"

  s.swift_version = "5.2"

  s.dependency "KituraNIOLinuxHelpers", "#{s.version}"

  s.dependency "SwiftNIO", "~> 2.33"
  s.dependency "SwiftNIOFoundationCompat", "~> 2.33"
  s.dependency "SwiftNIOHTTP1", "~> 2.33"
  s.dependency "SwiftNIOWebSocket", "~> 2.33"
  s.dependency "SwiftNIOConcurrencyHelpers", "~> 2.33"
  s.dependency "SwiftNIOSSL", "~> 2.0"
  s.dependency "SwiftNIOExtras", "~> 1.0"

  s.dependency "BlueSSLService", "~> 2.0"

  s.dependency "KituraLoggerAPI", "~> 2.0"
end
