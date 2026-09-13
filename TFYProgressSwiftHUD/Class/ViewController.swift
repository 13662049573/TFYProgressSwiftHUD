import UIKit
import Lottie

private struct DemoSection {
    let title: String
    let footer: String?
    let items: [DemoItem]
}

private struct DemoItem {
    let title: String
    let detail: String
    let symbol: String
    let action: () -> Void
}

final class ViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var progressTimer: Timer?
    private var simulatedProgress: CGFloat = 0
    private lazy var sections = makeSections()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTableView()
    }

    deinit {
        progressTimer?.invalidate()
    }

    private func configureNavigation() {
        title = "TFYProgressSwiftHUD"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "重置",
            style: .plain,
            target: self,
            action: #selector(resetDemo)
        )
        navigationItem.rightBarButtonItem?.accessibilityHint = "恢复 HUD 默认外观并停止演示"
    }

    private func configureTableView() {
        view.backgroundColor = .systemGroupedBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        tableView.keyboardDismissMode = .interactive
        tableView.accessibilityIdentifier = "hud.demo.table"
        tableView.tableHeaderView = makeHeaderView()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func makeHeaderView() -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 132))
        let icon = UIImageView(image: UIImage(systemName: "sparkles.rectangle.stack.fill"))
        icon.tintColor = .systemIndigo
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .semibold)
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.isAccessibilityElement = false

        let title = UILabel()
        title.text = "完整能力演示"
        title.font = .preferredFont(forTextStyle: .title2)
        title.adjustsFontForContentSizeCategory = true
        title.textColor = .label

        let subtitle = UILabel()
        subtitle.text = "加载、进度、状态、主题、自定义视图、全屏模式与稳定性场景。点击任意项目立即预览。"
        subtitle.font = .preferredFont(forTextStyle: .subheadline)
        subtitle.adjustsFontForContentSizeCategory = true
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 0

        let labels = UIStackView(arrangedSubviews: [title, subtitle])
        labels.axis = .vertical
        labels.spacing = 6
        let stack = UIStackView(arrangedSubviews: [icon, labels])
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -16),
            icon.widthAnchor.constraint(equalToConstant: 40),
            icon.heightAnchor.constraint(equalToConstant: 40)
        ])
        container.isAccessibilityElement = true
        container.accessibilityLabel = "TFYProgressSwiftHUD 完整能力演示"
        container.accessibilityValue = subtitle.text
        return container
    }

    private func makeSections() -> [DemoSection] {
        let loadingItems = AnimationType.allCases.map { type in
            DemoItem(
                title: type.displayName,
                detail: "切换并预览 \(type.displayName)",
                symbol: type.symbolName
            ) { [weak self] in
                self?.stopProgressDemo()
                TFYProgressSwiftHUD.animationType = type
                TFYProgressSwiftHUD.show("正在使用\(type.displayName)")
                TFYProgressSwiftHUD.dismiss(after: 2.5)
            }
        }

        let symbolItems = AlertIcon.allCases.map { icon in
            DemoItem(
                title: icon.displayName,
                detail: "SF Symbol 状态提示",
                symbol: icon.symbolName
            ) {
                TFYProgressSwiftHUD.show(icon.displayName, icon: icon)
            }
        }

        return [
            DemoSection(title: "快速开始", footer: "interaction 为 true 时允许触摸穿透；false 时阻止背后的操作。", items: [
                item("无文字加载", "显示默认加载动画", "circle.dotted") { TFYProgressSwiftHUD.show() },
                item("短文本加载", "最常见的网络等待状态", "text.bubble") { TFYProgressSwiftHUD.show("请稍候…") },
                item("长文本与自动换行", "验证自适应宽高和动态字体", "text.alignleft") {
                    TFYProgressSwiftHUD.show("正在安全地处理数据，完成前请不要关闭当前页面。")
                    TFYProgressSwiftHUD.dismiss(after: 3)
                },
                item("阻止页面交互", "显示半透明遮罩并拦截触摸", "hand.raised.fill") {
                    TFYProgressSwiftHUD.show("正在提交，请勿重复操作", interaction: false)
                    TFYProgressSwiftHUD.dismiss(after: 2.5)
                },
                item("限定在当前列表", "使用 show(_:in:) 指定宿主视图", "rectangle.inset.filled") { [weak self] in
                    guard let self else { return }
                    TFYProgressSwiftHUD.show("HUD 只覆盖当前列表", in: self.tableView, interaction: false)
                    TFYProgressSwiftHUD.dismiss(after: 2.5)
                },
                item("立即关闭", "取消定时任务并清理 HUD", "xmark.circle") { TFYProgressSwiftHUD.dismiss() }
            ]),
            DemoSection(title: "11 种加载动画", footer: "开启“减弱动态效果”后会自动降级为系统活动指示器。", items: loadingItems),
            DemoSection(title: "进度", footer: "进度会限制在 0%～100%，高频更新会复用现有视图。", items: [
                item("模拟文件上传", "连续更新到 100% 并显示成功", "arrow.up.circle.fill") { [weak self] in
                    self?.startProgressDemo()
                },
                item("25%", "带文字的确定进度", "chart.pie.fill") {
                    TFYProgressSwiftHUD.showProgress(0.25, status: "正在准备资源")
                    TFYProgressSwiftHUD.dismiss(after: 2.5)
                },
                item("75%", "无文字的确定进度", "gauge.with.dots.needle.67percent") {
                    TFYProgressSwiftHUD.showProgress(0.75)
                    TFYProgressSwiftHUD.dismiss(after: 2.5)
                },
                item("越界值保护", "传入 135%，界面安全显示为 100%", "shield.checkered") {
                    TFYProgressSwiftHUD.showProgress(1.35, status: "进度值已自动限制")
                    TFYProgressSwiftHUD.dismiss(after: 2.5)
                }
            ]),
            DemoSection(title: "结果状态", footer: "结果提示会根据文本长度自动决定展示时长。", items: [
                item("动画成功", "描边勾选动画", "checkmark.circle") { TFYProgressSwiftHUD.showSucceed("保存成功") },
                item("动画失败", "描边错误动画", "xmark.octagon") { TFYProgressSwiftHUD.showFailed("操作失败，请重试") },
                item("动画新增", "描边加号动画", "plus.circle") { TFYProgressSwiftHUD.showAdded("已添加到列表") },
                item("静态成功图标", "使用可替换的成功图片", "checkmark.circle.fill") { TFYProgressSwiftHUD.showSuccess("同步完成") },
                item("静态错误图标", "使用可替换的错误图片", "exclamationmark.octagon.fill") { TFYProgressSwiftHUD.showError("网络连接不可用") },
                item("自定义图片", "使用彩色 SF Symbol", "star.fill") {
                    let image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
                    TFYProgressSwiftHUD.showSuccess("已加入收藏", image: image)
                }
            ]),
            DemoSection(title: "19 种系统图标", footer: nil, items: symbolItems),
            DemoSection(title: "外观与字体", footer: "默认主题使用语义色，可自动适配深色模式。", items: [
                item("恢复默认主题", "语义色与 Dynamic Type", "circle.lefthalf.filled") { [weak self] in
                    self?.applyTheme(.defaultTheme)
                },
                item("海洋蓝主题", "蓝色面板与白色内容", "drop.fill") { [weak self] in self?.applyTheme(.ocean) },
                item("森林绿主题", "绿色面板与高对比内容", "leaf.fill") { [weak self] in self?.applyTheme(.forest) },
                item("暮光紫主题", "紫色面板与柔和遮罩", "moon.stars.fill") { [weak self] in self?.applyTheme(.twilight) },
                item("大号动态字体", "使用 UIFontMetrics 缩放自定义字体", "textformat.size.larger") {
                    let base = UIFont.systemFont(ofSize: 26, weight: .bold)
                    TFYProgressSwiftHUD.fontStatus = UIFontMetrics(forTextStyle: .title2).scaledFont(for: base)
                    TFYProgressSwiftHUD.show("大号字体仍能完整换行")
                    TFYProgressSwiftHUD.dismiss(after: 2.5)
                }
            ]),
            DemoSection(title: "自定义内容", footer: "自定义视图可持续显示，也可由 hide 参数自动关闭。", items: [
                item("自定义旋转视图", "嵌入 Core Animation 视图", "rotate.3d") {
                    TFYProgressSwiftHUD.show("自定义加载器", customView: Self.makeCustomSpinner())
                    TFYProgressSwiftHUD.dismiss(after: 3)
                },
                item("自定义成功徽章", "自定义大小与弹性动画", "hands.sparkles.fill") {
                    TFYProgressSwiftHUD.show("自定义视图完成", customView: Self.makeSuccessBadge(), hide: true)
                },
                item("Lottie 动画", "演示与第三方动画视图组合", "wand.and.stars") {
                    TFYProgressSwiftHUD.show("Lottie 加载动画", customView: Self.makeLottieView())
                    TFYProgressSwiftHUD.dismiss(after: 3)
                },
                item("全屏 Lottie", "自适应安全区域，3 秒后关闭", "arrow.up.left.and.arrow.down.right") {
                    TFYProgressSwiftHUD.showFullScreen(Self.makeFullScreenContent(useLottie: true))
                    TFYProgressSwiftHUD.dismiss(after: 3)
                },
                item("全屏自定义界面", "包含可访问的手动关闭按钮", "rectangle.fill.on.rectangle.fill") {
                    TFYProgressSwiftHUD.showFullScreen(Self.makeFullScreenContent(useLottie: false))
                }
            ]),
            DemoSection(title: "稳定性场景", footer: "这些示例覆盖后台线程调用、快速替换、键盘避让和重复清理。", items: [
                item("后台线程调用", "公开 API 会安全切回主线程", "cpu") {
                    DispatchQueue.global(qos: .userInitiated).async {
                        TFYProgressSwiftHUD.show("从后台任务安全显示")
                        TFYProgressSwiftHUD.dismiss(after: 2.5)
                    }
                },
                item("快速替换内容", "验证旧动画完成回调不会误删新 HUD", "arrow.triangle.2.circlepath") {
                    TFYProgressSwiftHUD.show("第一条消息")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { TFYProgressSwiftHUD.showProgress(0.55, status: "已切换为进度") }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { TFYProgressSwiftHUD.showSucceed("替换成功") }
                },
                item("键盘避让", "输入时显示 HUD，观察自动上移", "keyboard") { [weak self] in self?.showKeyboardDemo() },
                item("重复关闭", "多次 dismiss 仍保持幂等", "checkmark.shield.fill") {
                    TFYProgressSwiftHUD.show("准备执行重复关闭")
                    TFYProgressSwiftHUD.dismiss()
                    TFYProgressSwiftHUD.dismiss()
                }
            ])
        ]
    }

    private func item(_ title: String, _ detail: String, _ symbol: String, action: @escaping () -> Void) -> DemoItem {
        DemoItem(title: title, detail: detail, symbol: symbol, action: action)
    }

    private func startProgressDemo() {
        stopProgressDemo()
        simulatedProgress = 0
        TFYProgressSwiftHUD.showProgress(simulatedProgress, status: "正在上传文件", interaction: false)
        let timer = Timer(timeInterval: 0.04, repeats: true) { [weak self] timer in
            guard let self else { timer.invalidate(); return }
            self.simulatedProgress += 0.02
            TFYProgressSwiftHUD.showProgress(self.simulatedProgress, status: "正在上传文件", interaction: false)
            if self.simulatedProgress >= 1 {
                timer.invalidate()
                self.progressTimer = nil
                TFYProgressSwiftHUD.showSucceed("上传完成", interaction: false)
            }
        }
        progressTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func stopProgressDemo() {
        progressTimer?.invalidate()
        progressTimer = nil
    }

    @objc private func resetDemo() {
        stopProgressDemo()
        TFYProgressSwiftHUD.dismiss()
        TFYProgressSwiftHUD.resetAppearance()
        tableView.reloadData()
    }

    private enum DemoTheme { case defaultTheme, ocean, forest, twilight }

    private func applyTheme(_ theme: DemoTheme) {
        TFYProgressSwiftHUD.resetAppearance()
        switch theme {
        case .defaultTheme:
            TFYProgressSwiftHUD.show("默认主题 · 自动适配深浅色")
        case .ocean:
            setTheme(hud: .systemBlue, backdrop: .systemBlue, accent: .white)
            TFYProgressSwiftHUD.show("海洋蓝主题")
        case .forest:
            setTheme(hud: .systemGreen, backdrop: .systemGreen, accent: .white)
            TFYProgressSwiftHUD.show("森林绿主题")
        case .twilight:
            setTheme(hud: .systemPurple, backdrop: .systemIndigo, accent: .white)
            TFYProgressSwiftHUD.show("暮光紫主题")
        }
        TFYProgressSwiftHUD.dismiss(after: 2.5)
    }

    private func setTheme(hud: UIColor, backdrop: UIColor, accent: UIColor) {
        TFYProgressSwiftHUD.colorHUD = hud
        TFYProgressSwiftHUD.colorBackground = backdrop.withAlphaComponent(0.2)
        TFYProgressSwiftHUD.colorStatus = accent
        TFYProgressSwiftHUD.colorAnimation = accent
        TFYProgressSwiftHUD.colorProgress = accent
    }

    private func showKeyboardDemo() {
        let alert = UIAlertController(title: "键盘避让", message: "输入任意内容后点击显示", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "输入内容"
            textField.accessibilityLabel = "演示输入框"
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "显示 HUD", style: .default) { _ in
            TFYProgressSwiftHUD.show("HUD 会避开键盘", interaction: false)
            TFYProgressSwiftHUD.dismiss(after: 2.5)
        })
        present(alert, animated: true)
    }

    private static func makeLottieView(size: CGFloat = 72) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        if let animation = LottieAnimation.named("加载-中间") {
            let animationView = LottieAnimationView(animation: animation)
            animationView.frame = container.bounds
            animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            container.addSubview(animationView)
        } else {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .systemPurple
            indicator.center = CGPoint(x: size / 2, y: size / 2)
            indicator.startAnimating()
            container.addSubview(indicator)
        }
        container.isAccessibilityElement = true
        container.accessibilityLabel = "Lottie 加载动画"
        return container
    }

    private static func makeCustomSpinner() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        let ring = CAShapeLayer()
        ring.frame = view.bounds.insetBy(dx: 6, dy: 6)
        ring.path = UIBezierPath(ovalIn: ring.bounds).cgPath
        ring.fillColor = UIColor.clear.cgColor
        ring.strokeColor = UIColor.systemCyan.cgColor
        ring.lineWidth = 7
        ring.lineCap = .round
        ring.strokeStart = 0.08
        ring.strokeEnd = 0.78
        view.layer.addSublayer(ring)
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 0.8
        animation.repeatCount = .infinity
        ring.add(animation, forKey: "rotation")
        view.isAccessibilityElement = true
        view.accessibilityLabel = "自定义旋转加载器"
        return view
    }

    private static func makeSuccessBadge() -> UIView {
        let badge = UIImageView(frame: CGRect(x: 0, y: 0, width: 76, height: 76))
        badge.image = UIImage(systemName: "checkmark.seal.fill")
        badge.tintColor = .systemGreen
        badge.contentMode = .scaleAspectFit
        badge.isAccessibilityElement = true
        badge.accessibilityLabel = "成功"
        badge.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(
            withDuration: 0.45,
            delay: 0,
            usingSpringWithDamping: 0.62,
            initialSpringVelocity: 0.8,
            animations: { badge.transform = .identity }
        )
        return badge
    }

    private static func makeFullScreenContent(useLottie: Bool) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.94)
        let visual = useLottie ? makeLottieView(size: 120) : makeSuccessBadge()
        visual.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel()
        title.text = useLottie ? "正在准备精彩内容" : "全屏任务已完成"
        title.font = .preferredFont(forTextStyle: .title2)
        title.adjustsFontForContentSizeCategory = true
        title.textColor = .white
        title.textAlignment = .center
        title.numberOfLines = 0

        let close = UIButton(type: .system, primaryAction: UIAction(title: "关闭") { _ in
            TFYProgressSwiftHUD.dismiss()
        })
        close.setTitleColor(.white, for: .normal)
        close.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        close.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        close.layer.cornerRadius = 12
        close.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        close.accessibilityHint = "关闭全屏 HUD"

        let stack = UIStackView(arrangedSubviews: [visual, title, close])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            visual.widthAnchor.constraint(equalToConstant: useLottie ? 120 : 76),
            visual.heightAnchor.constraint(equalToConstant: useLottie ? 120 : 76),
            stack.centerXAnchor.constraint(equalTo: container.safeAreaLayoutGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.safeAreaLayoutGuide.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: container.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: container.safeAreaLayoutGuide.trailingAnchor, constant: -32)
        ])
        if useLottie { close.setTitle("可手动关闭 · 也会自动关闭", for: .normal) }
        return container
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].footer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "DemoCell")
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.detail
        content.image = UIImage(systemName: item.symbol)
        content.imageProperties.tintColor = .systemIndigo
        content.textProperties.font = .preferredFont(forTextStyle: .body)
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .footnote)
        content.secondaryTextProperties.color = .secondaryLabel
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4)
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.accessibilityIdentifier = "hud.demo.\(indexPath.section).\(indexPath.row)"
        cell.accessibilityLabel = item.title
        cell.accessibilityValue = item.detail
        cell.accessibilityTraits = .button
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].items[indexPath.row].action()
    }
}

private extension AnimationType {
    var displayName: String {
        switch self {
        case .systemActivityIndicator: return "系统活动指示器"
        case .horizontalCirclesPulse: return "水平圆点脉冲"
        case .lineScaling: return "线条缩放"
        case .singleCirclePulse: return "单圆脉冲"
        case .multipleCirclePulse: return "多圆脉冲"
        case .singleCircleScaleRipple: return "单圆缩放波纹"
        case .multipleCircleScaleRipple: return "多圆缩放波纹"
        case .circleSpinFade: return "圆点旋转淡出"
        case .lineSpinFade: return "线条旋转淡出"
        case .circleRotateChase: return "圆点旋转追逐"
        case .circleStrokeSpin: return "圆形描边旋转"
        }
    }

    var symbolName: String {
        switch self {
        case .systemActivityIndicator: return "circle.dotted"
        case .horizontalCirclesPulse, .multipleCirclePulse: return "ellipsis"
        case .lineScaling: return "waveform"
        case .singleCirclePulse: return "circle.fill"
        case .singleCircleScaleRipple, .multipleCircleScaleRipple: return "dot.radiowaves.left.and.right"
        case .circleSpinFade, .lineSpinFade: return "sun.max.fill"
        case .circleRotateChase: return "circle.hexagongrid.fill"
        case .circleStrokeSpin: return "circle.dashed"
        }
    }
}

private extension AlertIcon {
    var displayName: String {
        switch self {
        case .heart: return "喜欢"
        case .doc: return "文档"
        case .bookmark: return "书签"
        case .moon: return "夜间模式"
        case .star: return "收藏"
        case .exclamation: return "警告"
        case .flag: return "标记"
        case .message: return "消息"
        case .question: return "帮助"
        case .bolt: return "快速操作"
        case .shuffle: return "随机播放"
        case .eject: return "弹出"
        case .card: return "支付卡"
        case .rotate: return "旋转"
        case .like: return "赞"
        case .dislike: return "不赞"
        case .privacy: return "隐私"
        case .cart: return "购物车"
        case .search: return "搜索"
        }
    }

    var symbolName: String { fallbackSymbolName }

    private var fallbackSymbolName: String {
        switch self {
        case .heart: return "heart.fill"
        case .doc: return "doc.fill"
        case .bookmark: return "bookmark.fill"
        case .moon: return "moon.fill"
        case .star: return "star.fill"
        case .exclamation: return "exclamationmark.triangle.fill"
        case .flag: return "flag.fill"
        case .message: return "envelope.fill"
        case .question: return "questionmark.diamond.fill"
        case .bolt: return "bolt.fill"
        case .shuffle: return "shuffle"
        case .eject: return "eject.fill"
        case .card: return "creditcard.fill"
        case .rotate: return "rotate.right.fill"
        case .like: return "hand.thumbsup.fill"
        case .dislike: return "hand.thumbsdown.fill"
        case .privacy: return "hand.raised.fill"
        case .cart: return "cart.fill"
        case .search: return "magnifyingglass"
        }
    }
}
