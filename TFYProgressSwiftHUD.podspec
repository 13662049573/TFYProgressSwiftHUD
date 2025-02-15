
Pod::Spec.new do |spec|
  spec.name         = "TFYProgressSwiftHUD"

  spec.version      = "2.1.3"

  spec.summary      = "Swift版的多动画提示框，最低支持iOS 15 系统以上。SWIFT 5.0 以上"

  spec.description  = <<-DESC
Swift版的多动画提示框，最低支持iOS 15 系统以上 5.0 以上。
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFYProgressSwiftHUD"
  
  spec.license      = "MIT"
  
  spec.author       = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "15.0"

  spec.swift_version = '5.0'

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  spec.source       = { :git => "https://github.com/13662049573/TFYProgressSwiftHUD.git", :tag => spec.version }

  spec.source_files  = "TFYProgressSwiftHUD/TFYProgressSwiftHUD/**/*.{swift}"
  
  spec.requires_arc = true

end
