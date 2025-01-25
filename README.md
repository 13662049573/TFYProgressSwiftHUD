# TFYProgressSwiftHUD

[![Version](https://img.shields.io/cocoapods/v/TFYProgressSwiftHUD.svg?style=flat)](https://cocoapods.org/pods/TFYProgressSwiftHUD)
[![License](https://img.shields.io/cocoapods/l/TFYProgressSwiftHUD.svg?style=flat)](https://cocoapods.org/pods/TFYProgressSwiftHUD)
[![Platform](https://img.shields.io/cocoapods/p/TFYProgressSwiftHUD.svg?style=flat)](https://cocoapods.org/pods/TFYProgressSwiftHUD)

TFYProgressSwiftHUD 是一个优雅的 Swift HUD 库，提供丰富的加载动画和提示效果。适用于 iOS 15.0+ 的项目，完全用 Swift 5.0 编写。

## 特性

- [x] 11种精美的加载动画效果
- [x] 3种状态动画图标（成功、失败、添加）
- [x] 19种系统图标集成
- [x] 支持进度条显示
- [x] 自定义颜色和样式
- [x] 简单易用的 API
- [x] 优雅的动画过渡效果
- [x] 支持键盘自适应

## 预览

[这里可以放一些动画效果的截图或 GIF]

## 要求

- iOS 15.0+
- Swift 5.0+
- Xcode 14.0+

## 安装

### CocoaPods

```ruby
pod 'TFYProgressSwiftHUD'
```

## 使用方法

### 基本使用

```swift
// 显示加载动画
TFYProgressSwiftHUD.show("Loading...")

// 显示成功提示
TFYProgressSwiftHUD.showSuccess("Success!")

// 显示错误提示
TFYProgressSwiftHUD.showError("Error occurred!")

// 显示进度
TFYProgressSwiftHUD.showProgress(0.75)

// 隐藏
TFYProgressSwiftHUD.dismiss()
```

### 自定义动画类型

```swift
// 设置动画类型
TFYProgressSwiftHUD.animationType = .circleRotateChase

// 可用的动画类型
public enum AnimationType {
    case systemActivityIndicator
    case horizontalCirclesPulse
    case lineScaling
    case singleCirclePulse
    case multipleCirclePulse
    case singleCircleScaleRipple
    case multipleCircleScaleRipple
    case circleSpinFade
    case lineSpinFade
    case circleRotateChase
    case circleStrokeSpin
}
```

### 使用系统图标

```swift
// 显示系统图标
TFYProgressSwiftHUD.show("Bookmarked!", icon: .bookmark)

// 可用的系统图标
public enum AlertIcon {
    case heart
    case doc
    case bookmark
    case moon
    case star
    // ... 更多图标
}
```

### 自定义样式

```swift
// 自定义颜色
TFYProgressSwiftHUD.colorBackground = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
TFYProgressSwiftHUD.colorHUD = .black
TFYProgressSwiftHUD.colorStatus = .white
TFYProgressSwiftHUD.colorAnimation = .white
TFYProgressSwiftHUD.colorProgress = .white

// 自定义字体
TFYProgressSwiftHUD.fontStatus = .boldSystemFont(ofSize: 24)
```

## 作者

田风有, 420144542@qq.com

## 许可证

TFYProgressSwiftHUD 基于 MIT 许可证开源。详见 LICENSE 文件。
