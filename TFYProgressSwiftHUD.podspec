
Pod::Spec.new do |spec|
  spec.name         = "TFYProgressSwiftHUD"

  spec.version      = "2.1.3"

  spec.summary      = "Swift版的多动画提示框，最低支持iOS 15 系统以上。SWIFT 5.0 以上"

  spec.description  = <<-DESC
TFYProgressSwiftHUD 是一款基于 Swift 5.0 开发的多动画提示框组件，专为 iOS 15 及以上系统设计。支持多种动画样式，界面简洁美观，易于集成和自定义。适用于加载、进度、提示等多种场景，提升用户体验。代码结构清晰，维护方便，适合个人和企业项目使用。
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
