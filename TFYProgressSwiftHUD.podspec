
Pod::Spec.new do |spec|
  spec.name         = "TFYProgressSwiftHUD"

  spec.version      = "2.0.2"

  spec.summary      = "Swift版的多动画提示框，最低支持iOS 13 系统以上。"

  spec.description  = <<-DESC
Swift版的多动画提示框，最低支持iOS 13 系统以上。
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFYProgressSwiftHUD"
  
  spec.license      = "MIT"
  
  spec.author       = { "田风有" => "420144542@qq.com" }
  

  spec.platform     = :ios, "13.0"

  spec.swift_version = '5.0'

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  spec.source       = { :git => "https://github.com/13662049573/TFYProgressSwiftHUD.git", :tag => spec.version }

  spec.source_files  = "TFYProgressSwiftHUD/TFYProgressSwiftHUD/**/*.{swift}"
  

  spec.requires_arc = true

  

end
