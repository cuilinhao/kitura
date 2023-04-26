Pod::Spec.new do |s|
  s.name = "BlueSSLService"
  s.version = "2.0.2"
  s.summary = "SSL/TLS Add-in for BlueSocket using Secure Transport and OpenSSL."
  s.homepage = "https://www.kitura.dev"
  s.license = { :type => "Apache License, Version 2.0" }
  s.author = "IBM"

  s.module_name = "SSLService"

  s.osx.deployment_target = "10.12"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"

  s.source = { :git => "https://github.com/Kitura/BlueSSLService.git", :tag => s.version }
  s.source_files = "Sources/#{s.module_name}/*.swift"

  s.swift_version = "5.1"

  s.dependency "BlueSocket", "~> 2.0"
end
