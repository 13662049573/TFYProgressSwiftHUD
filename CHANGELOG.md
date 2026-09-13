# 更新日志

本项目遵循[语义化版本](https://semver.org/lang/zh-CN/)。

## [2.2.0] - 2026-09-13

### 新增

- 新增 Swift Package Manager 支持，最低支持 iOS 15 和 Swift 5.7。
- 新增 `show(_:in:interaction:)` 与 `showProgress(_:status:in:interaction:)`，可将 HUD 限定在指定 View 内。
- 新增 `isVisible`、`dismiss(after:)`、`dismiss(completion:)` 和 `resetAppearance()`。
- `AnimationType`、`AnimatedIcon`、`AlertIcon` 支持 `CaseIterable` 与 `Equatable`。
- 新增 Dynamic Type、VoiceOver、深色模式和“减弱动态效果”支持。
- 新增可调节的自动关闭时间上下限。
- 新增完整单元测试、UI 自动化测试和 Swift Package 测试目标。

### 优化

- 使用当前前台 Scene 的 key window，改善多窗口及多 Scene 环境下的展示行为。
- 高频进度更新复用现有 HUD，减少视图重建和动画抖动。
- 进度值自动限制在 `0...1`，并安全处理非有限数值。
- 重构 HUD 布局，使其适配旋转、分屏、键盘和紧凑宽度。
- 重构显示与关闭生命周期，避免快速替换、延迟关闭和重复关闭之间相互干扰。
- Demo 改为数据驱动结构，覆盖全部加载动画、状态图标、进度、主题、自定义 View、Lottie、全屏和稳定性场景。
- README 补充完整安装、API、交互语义、无障碍和测试说明。

### 修复

- 修复通知观察者被提前移除后无法恢复的问题。
- 修复依赖首个 Window 导致 HUD 可能显示在错误场景的问题。
- 修复键盘避让依赖 UIKit 私有类的问题。
- 修复面板弹出动画结束时缩放比例不正确的问题。
- 修复后台线程调用公开 API 时潜在的 UI 线程问题。
- 修复部分强制解包可能引发的崩溃。

### 兼容性

- 保留原有公开展示、结果、进度、自定义 View 和全屏 API。
- `interaction` 参数继续保持旧版语义：`true` 允许触摸穿透，`false` 阻止背后页面交互。
- 最低系统版本为 iOS 15.0。

## [2.1.6] - 历史版本

- 上一个 CocoaPods 发布版本。

[2.2.0]: https://github.com/13662049573/TFYProgressSwiftHUD/compare/2.1.6...2.2.0
[2.1.6]: https://github.com/13662049573/TFYProgressSwiftHUD/releases/tag/2.1.6
