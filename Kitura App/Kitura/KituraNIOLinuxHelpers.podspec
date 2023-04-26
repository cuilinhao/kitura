Pod::Spec.new do |s|
  s.name = "KituraNIOLinuxHelpers"
  s.version = "3.1.0"
  s.summary = "A networking library for Kitura, based on SwiftNIO."
  s.homepage = "https://www.kitura.dev"
  s.license = { :type => "Apache License, Version 2.0" }
  s.author = "IBM"

  s.module_name = "CLinuxHelpers"

  s.osx.deployment_target = "10.11"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"

  s.source = { :git => "https://github.com/Kitura/Kitura-NIO.git", :tag => s.version }
  s.source_files = "Sources/#{s.module_name}/**/*.{h,c}"

  s.swift_version = "5.2"
end
