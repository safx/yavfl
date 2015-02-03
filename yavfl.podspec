Pod::Spec.new do |s|
  s.name         = "yavfl"
  s.version      = "0.1.4"
  s.summary      = "Yet Anoter Visual Format Language for Auto Layout in Swift"
  s.homepage     = "https://github.com/safx/yavfl"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "MATSUMOTO Yuji" => "safxdev@gmail.com" }
  s.source       = { :git => "https://github.com/safx/yavfl.git", :tag => s.version }
  s.source_files = "yavfl.swift"
  s.framework    = 'Foundation'
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.requires_arc = true
end
