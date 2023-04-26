Pod::Spec.new do |s|
  s.name = "Kitura"
  s.version = "3.0.1"
  s.summary = "A Swift web framework and HTTP server."
  s.homepage = "https://www.kitura.dev"
  s.license = { :type => "Apache License, Version 2.0" }
  s.author = "IBM"

  s.osx.deployment_target = "10.11"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"

  s.source = { :git => "https://github.com/Kitura/Kitura.git", :tag => s.version }
  s.source_files = "Sources/#{s.name}/**/*.swift"

  s.swift_version = "5.2"

  s.dependency "KituraContracts", "~> 2.0"
  s.dependency "KituraLoggerAPI", "~> 2.0"
  s.dependency "KituraNIO", "~> 3.0"
  s.dependency "KituraTemplateEngine", "~> 3.0"
  s.dependency "KituraTypeDecoder", "~> 2.0"
end
