
Pod::Spec.new do |spec|
  spec.name         = "TFYProgressSwiftHUD"

  spec.version      = "2.0.0"

  spec.summary      = "Swift版的多动画提示框，最低支持iOS 13 系统以上。"

  spec.description  = <<-DESC
Swift版的多动画提示框，最低支持iOS 13 系统以上。
                   DESC

  spec.homepage     = "http://EXAMPLE/TFYProgressSwiftHUD"
  
  spec.license      = "MIT"
  
  spec.author             = { "田风有" => "420144542@qq.com" }
  

  spec.platform     = :ios, "13.0"

 
  spec.source       = { :git => "http://EXAMPLE/TFYProgressSwiftHUD.git", :tag => spec.version }


  spec.source_files  = "Classes/**/*.{h,m}"
  

  spec.requires_arc = true

end
