Pod::Spec.new do |s|
  s.name = "BlueSocket"
  s.version = "2.0.4"
  s.summary = "Socket framework for Swift."
  s.homepage = "https://www.kitura.dev"
  s.license = { :type => "Apache License, Version 2.0" }
  s.author = "IBM"

  s.module_name = "Socket"

  s.osx.deployment_target = "10.12"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"

  s.source = { :git => "https://github.com/Kitura/BlueSocket.git", :tag => s.version }
  s.source_files = "Sources/#{s.module_name}/*.swift"

  s.swift_version = "5.1"
end
