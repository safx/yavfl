Pod::Spec.new do |s|
  s.name         = "yavfl"
  s.version      = "0.1.1"
  s.summary      = "yavfl is a Yet Anoter Visual Format Language for Auto Layout, written in Swift"
  s.homepage     = "https://github.com/safx/yavfl"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "MATSUMOTO Yuji" => "safxdev@gmail.com" }
  s.source       = { :git => "https://github.com/safx/yavfl.git", :tag => s.version }
  s.source_files = "yavfl.swift"
  s.framework    = 'Foundation'
  s.framework    = 'UIKit'
  s.ios.deployment_target = "8.0"
  s.requires_arc = true
end
