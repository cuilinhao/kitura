Pod::Spec.new do |s|
  s.name = "KituraContracts"
  s.version = "2.0.1"
  s.summary = "A library containing type definitions shared by client and server Kitura code. "
  s.homepage = "https://www.kitura.dev"
  s.license = { :type => "Apache License, Version 2.0" }
  s.author = "IBM"

  s.osx.deployment_target = "10.11"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "9.1"
  s.watchos.deployment_target = "2.0"

  s.source = { :git => "https://github.com/Kitura/KituraContracts.git", :tag => s.version }
  s.source_files = "Sources/#{s.name}/**/*.swift"

  s.swift_version = "5.0"

  s.dependency "LoggerAPI", "~> 2.0"
end
