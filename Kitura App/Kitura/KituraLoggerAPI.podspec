Pod::Spec.new do |s|
  s.name = "KituraLoggerAPI"
  s.version = "2.0.0"
  s.summary = "Kitura logger protocol."
  s.homepage = "https://www.kitura.dev"
  s.license = { :type => "Apache License, Version 2.0" }
  s.author = "IBM"

  s.module_name = "LoggerAPI"

  s.osx.deployment_target = "10.11"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "9.1"
  s.watchos.deployment_target = "2.0"

  s.source = { :git => "https://github.com/Kitura/LoggerAPI.git", :tag => s.version }
  s.source_files = "Sources/#{s.module_name}/**/*.swift"

  s.swift_version = "5.1"

  s.dependency "Logging", "~> 1.0"
end
