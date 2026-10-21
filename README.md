# TFYProgressSwiftHUD

[![Version](https://img.shields.io/cocoapods/v/TFYProgressSwiftHUD.svg?style=flat)](https://cocoapods.org/pods/TFYProgressSwiftHUD)
[![Platform](https://img.shields.io/badge/iOS-16.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.7%2B-orange.svg)](https://swift.org)
[![License](https://img.shields.io/cocoapods/l/TFYProgressSwiftHUD.svg?style=flat)](LICENSE)

一个轻量、可定制、场景感知的 UIKit HUD。内置 11 种加载动画、确定进度、结果状态、SF Symbols、自定义视图和全屏内容。

当前版本：`2.3.0`。完整版本记录请查看 [CHANGELOG.md](CHANGELOG.md)。

## 特性

- 11 种 Core Animation 加载效果和 3 种结果动画
- 确定进度，自动把异常值限制在 `0...1`
- 正确选择当前前台 Scene 的 key window，也可指定宿主 View
- 支持深色模式、Dynamic Type、VoiceOver 和“减弱动态效果”
- 自动避让键盘，旋转和分屏尺寸变化时自动重排
- 高频进度更新复用视图，快速替换与重复关闭安全
- CocoaPods 与 Swift Package Manager 双支持
- Demo 覆盖全部公开能力和稳定性场景

## 系统要求

- iOS 16.0+
- Swift 5.7+
- Xcode 14+

## 安装

### Swift Package Manager

在 Xcode 的 **File → Add Package Dependencies** 中添加：

```text
https://github.com/13662049573/TFYProgressSwiftHUD.git
```

或在 `Package.swift` 中声明：

```swift
dependencies: [
    .package(
        url: "https://github.com/13662049573/TFYProgressSwiftHUD.git",
        from: "2.3.0"
    )
]
```

### CocoaPods

```ruby
platform :ios, '16.0'
pod 'TFYProgressSwiftHUD', '~> 2.3'
```

## 快速开始

```swift
import TFYProgressSwiftHUD

TFYProgressSwiftHUD.show("正在加载…")
TFYProgressSwiftHUD.showSucceed("保存成功")
TFYProgressSwiftHUD.showError("网络连接失败")
TFYProgressSwiftHUD.showProgress(0.45, status: "正在上传")
TFYProgressSwiftHUD.dismiss()
```

状态和图标提示会自动隐藏；加载和进度默认持续显示，需在任务完成时调用 `dismiss()`。

## 加载动画

```swift
TFYProgressSwiftHUD.animationType = .circleRotateChase
TFYProgressSwiftHUD.show("正在同步")

// 也可遍历全部动画，用于设置页或 Demo
for type in AnimationType.allCases {
    print(type)
}
```

内置类型包括：

```swift
.systemActivityIndicator
.horizontalCirclesPulse
.lineScaling
.singleCirclePulse
.multipleCirclePulse
.singleCircleScaleRipple
.multipleCircleScaleRipple
.circleSpinFade
.lineSpinFade
.circleRotateChase
.circleStrokeSpin
```

## 进度与结果

```swift
TFYProgressSwiftHUD.showProgress(0.25, status: "准备资源")
TFYProgressSwiftHUD.showProgress(0.80, status: "即将完成")

TFYProgressSwiftHUD.showSucceed("上传完成")
TFYProgressSwiftHUD.showFailed("上传失败")
TFYProgressSwiftHUD.showAdded("已添加")

TFYProgressSwiftHUD.showSuccess("完成")
TFYProgressSwiftHUD.showError("出错了")
TFYProgressSwiftHUD.show("已收藏", icon: .bookmark)
```

自动隐藏时长会根据文本长度计算，也可调整边界：

```swift
TFYProgressSwiftHUD.minimumDismissTimeInterval = 1.5
TFYProgressSwiftHUD.maximumDismissTimeInterval = 6
TFYProgressSwiftHUD.dismiss(after: 2)
```

## 交互与宿主视图

为兼容旧版本，`interaction` 的语义保持不变：

- `true`：触摸穿透 HUD，用户仍可操作背后的页面。
- `false`：显示遮罩并阻止重复操作。

```swift
TFYProgressSwiftHUD.show("后台刷新中", interaction: true)
TFYProgressSwiftHUD.show("正在提交", interaction: false)

// 仅覆盖某个容器，适合卡片、子页面或多窗口场景
TFYProgressSwiftHUD.show("刷新列表", in: collectionView, interaction: false)
```

## 外观定制

```swift
TFYProgressSwiftHUD.colorBackground = UIColor.systemBlue.withAlphaComponent(0.18)
TFYProgressSwiftHUD.colorHUD = .systemBlue
TFYProgressSwiftHUD.colorStatus = .white
TFYProgressSwiftHUD.colorAnimation = .white
TFYProgressSwiftHUD.colorProgress = .white

let baseFont = UIFont.systemFont(ofSize: 22, weight: .bold)
TFYProgressSwiftHUD.fontStatus = UIFontMetrics(forTextStyle: .title2)
    .scaledFont(for: baseFont)

TFYProgressSwiftHUD.resetAppearance()
```

默认颜色均为语义色，会自动适配深色模式。使用自定义字体时建议通过 `UIFontMetrics` 支持 Dynamic Type。

## 自定义与全屏内容

```swift
let customView = UIActivityIndicatorView(style: .large)
customView.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
customView.startAnimating()

TFYProgressSwiftHUD.show("自定义加载", customView: customView)
TFYProgressSwiftHUD.show("操作完成", customView: customView, hide: true)

let fullScreenView = MyFullScreenLoadingView()
TFYProgressSwiftHUD.showFullScreen(fullScreenView)
TFYProgressSwiftHUD.dismiss(after: 3)
```

## 可访问性与稳定性

- HUD 状态、加载和进度提供 VoiceOver 标签与进度值。
- 开启“减弱动态效果”时，自定义循环加载动画自动替换为系统指示器。
- 文本使用 Dynamic Type，并支持多行与紧凑宽度。
- 键盘位置通过公开通知计算，不依赖 UIKit 私有类。
- 所有公开显示 API 都可以从后台线程安全调用。

## Demo 与测试

打开 `TFYProgressSwiftHUD.xcworkspace`，运行 `TFYProgressSwiftHUD` Scheme。Demo 包含快速开始、全部动画、进度、结果图标、主题、Lottie、自定义/全屏内容，以及后台调用、快速替换、键盘避让等场景。

```bash
xcodebuild \
  -workspace TFYProgressSwiftHUD.xcworkspace \
  -scheme TFYProgressSwiftHUD \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro' \
  test
```

## 2.3.0 更新摘要

- 最低系统版本提升至 iOS 16.0。
- HUD 窗口查找采用 Scene `keyWindow` API；深色模式切换在 iOS 17+ 使用 `registerForTraitChanges`。
- 公开 API 与集成方式不变；升级前请将工程的 Deployment Target 设为 iOS 16 及以上。

## 2.2.0 更新摘要

- 新增 Swift Package Manager 支持和指定宿主 View 的展示 API。
- 重构窗口选择、键盘避让、进度更新及显示/关闭生命周期。
- 新增深色模式、Dynamic Type、VoiceOver 与“减弱动态效果”适配。
- 全面重制 Demo，并补充单元测试和 UI 自动化测试。
- 保持现有 CocoaPods 集成方式及旧版公开 API 兼容。

详细变更及升级说明请参阅 [CHANGELOG.md](CHANGELOG.md)。

## License

TFYProgressSwiftHUD 基于 [MIT License](LICENSE) 发布。
