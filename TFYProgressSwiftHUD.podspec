
Pod::Spec.new do |spec|
  spec.name         = "TFYProgressSwiftHUD"

  spec.version      = "2.3.0"

  spec.summary      = "支持动画、进度、自定义视图与无障碍功能的 Swift HUD。"

  spec.description  = <<-DESC
TFYProgressSwiftHUD 是一款基于 Swift 5.7 开发的多动画提示框组件，专为 iOS 16 及以上系统设计。支持多种动画样式、确定进度、自定义视图、深色模式和辅助功能，易于集成和定制。
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFYProgressSwiftHUD"
  
  spec.license      = "MIT"
  
  spec.author       = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "16.0"

  spec.swift_version = '5.7'

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.7' }

  spec.source       = { :git => "https://github.com/13662049573/TFYProgressSwiftHUD.git", :tag => spec.version }

  spec.source_files  = "TFYProgressSwiftHUD/TFYProgressSwiftHUD/**/*.{swift}"
  
  spec.requires_arc = true

end
