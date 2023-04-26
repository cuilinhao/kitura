Pod::Spec.new do |s|
  s.name = "KituraTemplateEngine"
  s.version = "3.0.0"
  s.summary = " Kitura Template Engine protocol."
  s.homepage = "https://www.kitura.dev"
  s.license = { :type => "Apache License, Version 2.0" }
  s.author = "IBM"

  s.osx.deployment_target = "10.11"
  s.ios.deployment_target = "10.0"
  s.tvos.deployment_target = "10.0"

  s.source = { :git => "https://github.com/Kitura/Kitura-TemplateEngine.git", :tag => s.version }
  s.source_files = "Sources/#{s.name}/**/*.swift"

  s.swift_version = "5.1"
end
