import UIKit

/// Built-in loading animations.
public enum AnimationType: CaseIterable, Equatable {
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

/// Animated result icons.
public enum AnimatedIcon: CaseIterable, Equatable {
    case succeed
    case failed
    case added
}

/// SF Symbols that can be presented directly by the HUD.
public enum AlertIcon: CaseIterable, Equatable {
    case heart, doc, bookmark, moon, star, exclamation, flag, message, question
    case bolt, shuffle, eject, card, rotate, like, dislike, privacy, cart, search

    public var image: UIImage? { UIImage(systemName: systemName) }

    private var systemName: String {
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

/// Scene-aware HUD for loading, progress, result and custom content.
///
/// The legacy `interaction` argument is retained for source compatibility. `true`
/// lets touches pass through the overlay; `false` blocks touches behind the HUD.
public final class TFYProgressSwiftHUD: UIView {
    private enum Layout {
        static let minimumPanelSize = CGSize(width: 120, height: 120)
        static let maximumPanelWidth: CGFloat = 320
        static let screenMargin: CGFloat = 24
        static let contentInset: CGFloat = 20
        static let itemSpacing: CGFloat = 14
        static let cornerRadius: CGFloat = 14
        static let iconSize = CGSize(width: 64, height: 64)
        static let progressSize = CGSize(width: 70, height: 70)
        static let animationDuration: TimeInterval = 0.2
    }

    private enum ContentKind {
        case loading, progress, animatedIcon, image, custom, fullScreen
    }

    private enum Content {
        case loading
        case progress(CGFloat)
        case animatedIcon(AnimatedIcon)
        case image(UIImage?)
        case custom(UIView)
        case fullScreen(UIView)

        var kind: ContentKind {
            switch self {
            case .loading: return .loading
            case .progress: return .progress
            case .animatedIcon: return .animatedIcon
            case .image: return .image
            case .custom: return .custom
            case .fullScreen: return .fullScreen
            }
        }
    }

    private static let shared = TFYProgressSwiftHUD(frame: .zero)

    private var overlayView: HUDOverlayView?
    private var panelView: UIView?
    private var statusLabel: UILabel?
    private var contentView: UIView?
    private var progressView: HUDProgressView?
    private var activeKind: ContentKind?
    private var activeAnimatedIcon: AnimatedIcon?
    private var observerTokens: [NSObjectProtocol] = []
    private var dismissWorkItem: DispatchWorkItem?
    private var keyboardOverlap: CGFloat = 0
    private var presentationID = 0

    private var selectedAnimationType: AnimationType = .systemActivityIndicator
    private var selectedBackgroundColor = TFYProgressSwiftHUD.defaultBackgroundColor
    private var selectedHUDColor = TFYProgressSwiftHUD.defaultHUDColor
    private var selectedStatusColor = TFYProgressSwiftHUD.defaultStatusColor
    private var selectedAnimationColor = TFYProgressSwiftHUD.defaultStatusColor
    private var selectedProgressColor = TFYProgressSwiftHUD.defaultStatusColor
    private var selectedStatusFont = UIFont.preferredFont(forTextStyle: .headline)
    private var selectedSuccessImage = TFYProgressSwiftHUD.defaultSuccessImage
    private var selectedErrorImage = TFYProgressSwiftHUD.defaultErrorImage
    private var minimumDismissDelay: TimeInterval = 1.25
    private var maximumDismissDelay: TimeInterval = 5

    private static var defaultBackgroundColor: UIColor { UIColor.black.withAlphaComponent(0.22) }
    private static var defaultHUDColor: UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.secondarySystemBackground
                : UIColor.label.withAlphaComponent(0.88)
        }
    }
    private static var defaultStatusColor: UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? .label : .systemBackground }
    }
    private static var defaultSuccessImage: UIImage {
        UIImage(systemName: "checkmark.circle.fill")?
            .withTintColor(.systemGreen, renderingMode: .alwaysOriginal) ?? UIImage()
    }
    private static var defaultErrorImage: UIImage {
        UIImage(systemName: "xmark.octagon.fill")?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal) ?? UIImage()
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
    }

    @available(*, unavailable, message: "Use the TFYProgressSwiftHUD class API.")
    required init?(coder: NSCoder) { fatalError("init(coder:) is unavailable") }

    deinit { removeObservers() }

    private static func onMain(_ work: @escaping () -> Void) {
        Thread.isMainThread ? work() : DispatchQueue.main.async(execute: work)
    }

    private static func valueOnMain<Value>(_ work: () -> Value) -> Value {
        Thread.isMainThread ? work() : DispatchQueue.main.sync(execute: work)
    }

    private func present(
        status: String?,
        content: Content,
        automaticallyDismiss: Bool,
        interaction: Bool,
        in hostView: UIView? = nil
    ) {
        dispatchPrecondition(condition: .onQueue(.main))
        let trimmed = status?.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayedStatus = trimmed?.isEmpty == false ? trimmed : nil

        if content.kind == .progress,
           activeKind == .progress,
           let overlayView,
           hostView == nil || overlayView.superview === hostView,
           case let .progress(value) = content {
            overlayView.isUserInteractionEnabled = !interaction
            overlayView.accessibilityViewIsModal = !interaction
            updateProgress(value, status: displayedStatus)
            scheduleDismiss(ifNeeded: automaticallyDismiss, status: displayedStatus)
            return
        }

        guard let host = hostView ?? Self.activeWindow() else { return }
        dismissWorkItem?.cancel()
        presentationID += 1
        let wasVisible = overlayView?.superview != nil

        prepareOverlay(in: host, allowsInteraction: interaction)
        clearContent()
        activeKind = content.kind

        switch content {
        case .fullScreen(let customView): configureFullScreen(customView)
        default: configurePanel(status: displayedStatus, content: content)
        }

        updateAppearance()
        updatePosition(animated: false)
        animateIn(ifNeeded: !wasVisible)
        scheduleDismiss(ifNeeded: automaticallyDismiss, status: displayedStatus)
        announce(status: displayedStatus, kind: content.kind)
    }

    private func prepareOverlay(in host: UIView, allowsInteraction: Bool) {
        if overlayView?.superview !== host {
            destroyPresentation()
            let overlay = HUDOverlayView(frame: host.bounds)
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.accessibilityIdentifier = "tfy.hud.overlay"
            overlay.onLayout = { [weak self] in self?.updatePosition(animated: false) }
            overlay.onTraitChange = { [weak self] in self?.updateAppearance() }
            host.addSubview(overlay)
            overlayView = overlay
            installObservers()
        }
        overlayView?.backgroundColor = allowsInteraction ? .clear : selectedBackgroundColor
        overlayView?.isUserInteractionEnabled = !allowsInteraction
        overlayView?.accessibilityViewIsModal = !allowsInteraction
    }

    private func configurePanel(status: String?, content: Content) {
        guard let overlayView else { return }
        let panel = UIView()
        panel.layer.cornerCurve = .continuous
        panel.layer.cornerRadius = Layout.cornerRadius
        panel.layer.shadowColor = UIColor.black.cgColor
        panel.layer.shadowOpacity = 0.16
        panel.layer.shadowRadius = 16
        panel.layer.shadowOffset = CGSize(width: 0, height: 8)
        panel.accessibilityIdentifier = "tfy.hud.panel"
        overlayView.addSubview(panel)
        panelView = panel

        let visualContent = makeContentView(for: content)
        panel.addSubview(visualContent)
        contentView = visualContent

        if let status {
            let label = makeStatusLabel()
            label.text = status
            label.accessibilityLabel = status
            panel.addSubview(label)
            statusLabel = label
        }
        layoutPanel()
    }

    private func makeStatusLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        label.accessibilityIdentifier = "tfy.hud.status"
        return label
    }

    private func makeContentView(for content: Content) -> UIView {
        switch content {
        case .loading:
            let container = UIView(frame: CGRect(origin: .zero, size: Layout.iconSize))
            addLoadingAnimation(to: container)
            container.isAccessibilityElement = true
            container.accessibilityLabel = NSLocalizedString("Loading", comment: "HUD accessibility label")
            container.accessibilityTraits = .updatesFrequently
            return container
        case .progress(let value):
            let progress = HUDProgressView(color: selectedProgressColor)
            progress.frame = CGRect(origin: .zero, size: Layout.progressSize)
            progress.setProgress(value, animated: false)
            progressView = progress
            return progress
        case .animatedIcon(let icon):
            if UIAccessibility.isReduceMotionEnabled { return makeReducedMotionIcon(icon) }
            let container = UIView(frame: CGRect(origin: .zero, size: Layout.progressSize))
            addAnimatedIcon(icon, to: container)
            activeAnimatedIcon = icon
            container.isAccessibilityElement = true
            container.accessibilityLabel = accessibilityLabel(for: icon)
            return container
        case .image(let image):
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: Layout.iconSize))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = selectedAnimationColor
            imageView.isAccessibilityElement = true
            imageView.accessibilityLabel = NSLocalizedString("Status", comment: "HUD accessibility label")
            return imageView
        case .custom(let customView):
            normalizeCustomViewSize(customView)
            return customView
        case .fullScreen:
            return UIView()
        }
    }

    private func configureFullScreen(_ customView: UIView) {
        guard let overlayView else { return }
        customView.removeFromSuperview()
        customView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: overlayView.topAnchor),
            customView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor)
        ])
        contentView = customView
        customView.accessibilityViewIsModal = true
    }

    private func normalizeCustomViewSize(_ customView: UIView) {
        var size = customView.bounds.size
        if size.width <= 0 || size.height <= 0 {
            size = customView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
        if size.width <= 0 || size.height <= 0 { size = Layout.iconSize }
        size.width = min(max(size.width, 1), 220)
        size.height = min(max(size.height, 1), 220)
        customView.frame = CGRect(origin: .zero, size: size)
    }

    private func layoutPanel() {
        guard let overlayView, let panelView, let contentView else { return }
        let maximumWidth = max(
            Layout.minimumPanelSize.width,
            min(Layout.maximumPanelWidth, overlayView.bounds.width - Layout.screenMargin * 2)
        )
        let labelMaximumWidth = maximumWidth - Layout.contentInset * 2
        let labelSize = statusLabel?.sizeThatFits(
            CGSize(width: labelMaximumWidth, height: .greatestFiniteMagnitude)
        ) ?? .zero
        let contentSize = contentView.bounds.size
        let bodyHeight = contentSize.height + (statusLabel == nil ? 0 : Layout.itemSpacing + labelSize.height)
        let width = min(
            maximumWidth,
            max(Layout.minimumPanelSize.width, max(contentSize.width, labelSize.width) + Layout.contentInset * 2)
        )
        let height = max(Layout.minimumPanelSize.height, bodyHeight + Layout.contentInset * 2)
        panelView.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        let startY = (height - bodyHeight) / 2
        contentView.center = CGPoint(x: width / 2, y: startY + contentSize.height / 2)
        statusLabel?.frame = CGRect(
            x: Layout.contentInset,
            y: startY + contentSize.height + Layout.itemSpacing,
            width: width - Layout.contentInset * 2,
            height: labelSize.height
        )
    }

    private func addLoadingAnimation(to view: UIView) {
        if UIAccessibility.isReduceMotionEnabled {
            animationSystemActivityIndicator(view, color: selectedAnimationColor)
            return
        }
        switch selectedAnimationType {
        case .systemActivityIndicator: animationSystemActivityIndicator(view, color: selectedAnimationColor)
        case .horizontalCirclesPulse: animationHorizontalCirclesPulse(view, color: selectedAnimationColor)
        case .lineScaling: animationLineScaling(view, color: selectedAnimationColor)
        case .singleCirclePulse: animationSingleCirclePulse(view, color: selectedAnimationColor)
        case .multipleCirclePulse: animationMultipleCirclePulse(view, color: selectedAnimationColor)
        case .singleCircleScaleRipple: animationSingleCircleScaleRipple(view, color: selectedAnimationColor)
        case .multipleCircleScaleRipple: animationMultipleCircleScaleRipple(view, color: selectedAnimationColor)
        case .circleSpinFade: animationCircleSpinFade(view, color: selectedAnimationColor)
        case .lineSpinFade: animationLineSpinFade(view, color: selectedAnimationColor)
        case .circleRotateChase: animationCircleRotateChase(view, color: selectedAnimationColor)
        case .circleStrokeSpin: animationCircleStrokeSpin(view, color: selectedAnimationColor)
        }
    }

    private func addAnimatedIcon(_ icon: AnimatedIcon, to view: UIView) {
        switch icon {
        case .succeed: animatedIconSucceed(view, color: selectedAnimationColor, alpha: 0)
        case .failed: animatedIconFailed(view, color: selectedAnimationColor, alpha: 0)
        case .added: animatedIconAdded(view, color: selectedAnimationColor, alpha: 0)
        }
    }

    private func makeReducedMotionIcon(_ icon: AnimatedIcon) -> UIView {
        let imageName: String
        let color: UIColor
        switch icon {
        case .succeed: (imageName, color) = ("checkmark.circle.fill", .systemGreen)
        case .failed: (imageName, color) = ("xmark.octagon.fill", .systemRed)
        case .added: (imageName, color) = ("plus.circle.fill", .systemBlue)
        }
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: Layout.progressSize))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = color
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = accessibilityLabel(for: icon)
        return imageView
    }

    private func accessibilityLabel(for icon: AnimatedIcon) -> String {
        switch icon {
        case .succeed: return NSLocalizedString("Success", comment: "HUD accessibility label")
        case .failed: return NSLocalizedString("Failed", comment: "HUD accessibility label")
        case .added: return NSLocalizedString("Added", comment: "HUD accessibility label")
        }
    }

    private func updateProgress(_ value: CGFloat, status: String?) {
        if statusLabel?.text != status {
            if let status {
                if statusLabel == nil, let panelView {
                    let label = makeStatusLabel()
                    panelView.addSubview(label)
                    statusLabel = label
                }
                statusLabel?.text = status
                statusLabel?.accessibilityLabel = status
            } else {
                statusLabel?.removeFromSuperview()
                statusLabel = nil
            }
        }
        progressView?.setProgress(value, animated: true)
        updateAppearance()
        updatePosition(animated: true)
    }

    private func updateAppearance() {
        overlayView?.backgroundColor = overlayView?.isUserInteractionEnabled == true
            ? selectedBackgroundColor : .clear
        panelView?.backgroundColor = selectedHUDColor
        statusLabel?.font = selectedStatusFont
        statusLabel?.textColor = selectedStatusColor
        progressView?.color = selectedProgressColor

        guard let contentView else { return }
        if activeKind == .loading {
            contentView.subviews.forEach { $0.removeFromSuperview() }
            contentView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            addLoadingAnimation(to: contentView)
        } else if activeKind == .animatedIcon, let activeAnimatedIcon {
            recolorShapeLayers(in: contentView.layer, color: selectedAnimationColor)
            contentView.accessibilityLabel = accessibilityLabel(for: activeAnimatedIcon)
        } else if activeKind == .image {
            (contentView as? UIImageView)?.tintColor = selectedAnimationColor
        }
        layoutPanel()
    }

    private func recolorShapeLayers(in layer: CALayer, color: UIColor) {
        layer.sublayers?.forEach { sublayer in
            if let shape = sublayer as? CAShapeLayer {
                if shape.strokeColor != nil { shape.strokeColor = color.cgColor }
                if let fill = shape.fillColor, UIColor(cgColor: fill).cgColor.alpha > 0 {
                    shape.fillColor = color.cgColor
                }
            }
            recolorShapeLayers(in: sublayer, color: color)
        }
    }

    private func updatePosition(animated: Bool) {
        guard let overlayView, let panelView, activeKind != .fullScreen else { return }
        layoutPanel()
        let availableHeight = max(0, overlayView.bounds.height - keyboardOverlap)
        let safeTop = overlayView.safeAreaInsets.top
        let safeBottom = max(safeTop, availableHeight - overlayView.safeAreaInsets.bottom)
        let halfHeight = panelView.bounds.height / 2
        let centerY = min(max(availableHeight / 2, safeTop + halfHeight), safeBottom - halfHeight)
        let changes = { panelView.center = CGPoint(x: overlayView.bounds.midX, y: centerY) }
        if animated && !UIAccessibility.isReduceMotionEnabled {
            UIView.animate(
                withDuration: Layout.animationDuration,
                delay: 0,
                options: [.allowUserInteraction, .beginFromCurrentState],
                animations: changes
            )
        } else { changes() }
    }

    private func animateIn(ifNeeded: Bool) {
        guard ifNeeded, let panelView, activeKind != .fullScreen else { return }
        panelView.layer.removeAllAnimations()
        panelView.alpha = 0
        panelView.transform = UIAccessibility.isReduceMotionEnabled
            ? .identity : CGAffineTransform(scaleX: 1.12, y: 1.12)
        UIView.animate(
            withDuration: Layout.animationDuration,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut],
            animations: { panelView.alpha = 1; panelView.transform = .identity }
        )
    }

    private func scheduleDismiss(ifNeeded: Bool, status: String?) {
        dismissWorkItem?.cancel()
        guard ifNeeded else { return }
        let readingTime = TimeInterval(status?.count ?? 0) * 0.04
        let delay = min(max(minimumDismissDelay + readingTime, minimumDismissDelay), maximumDismissDelay)
        let item = DispatchWorkItem { [weak self] in self?.hide(completion: nil) }
        dismissWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
    }

    private func hide(completion: (() -> Void)?) {
        dispatchPrecondition(condition: .onQueue(.main))
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
        guard let overlayView else { completion?(); return }

        presentationID += 1
        let hidingID = presentationID
        let target = panelView ?? contentView ?? overlayView
        UIView.animate(
            withDuration: Layout.animationDuration,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseIn],
            animations: {
                target.alpha = 0
                if !UIAccessibility.isReduceMotionEnabled, self.activeKind != .fullScreen {
                    target.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                }
            },
            completion: { [weak self] _ in
                guard let self, self.presentationID == hidingID else { return }
                self.destroyPresentation()
                completion?()
            }
        )
    }

    private func clearContent() {
        panelView?.layer.removeAllAnimations()
        contentView?.layer.removeAllAnimations()
        contentView?.layer.sublayers?.forEach { $0.removeAllAnimations() }
        panelView?.removeFromSuperview()
        contentView?.removeFromSuperview()
        panelView = nil
        statusLabel = nil
        contentView = nil
        progressView = nil
        activeAnimatedIcon = nil
    }

    private func destroyPresentation() {
        dismissWorkItem?.cancel()
        dismissWorkItem = nil
        clearContent()
        overlayView?.removeFromSuperview()
        overlayView = nil
        activeKind = nil
        keyboardOverlap = 0
        removeObservers()
    }

    private func installObservers() {
        guard observerTokens.isEmpty else { return }
        let center = NotificationCenter.default
        observerTokens = [
            center.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) {
                [weak self] in self?.handleKeyboard($0)
            },
            center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {
                [weak self] in self?.handleKeyboard($0)
            },
            center.addObserver(forName: UIContentSizeCategory.didChangeNotification, object: nil, queue: .main) {
                [weak self] _ in self?.updateAppearance(); self?.updatePosition(animated: false)
            },
            center.addObserver(forName: UIAccessibility.reduceMotionStatusDidChangeNotification, object: nil, queue: .main) {
                [weak self] _ in self?.updateAppearance()
            }
        ]
    }

    private func removeObservers() {
        observerTokens.forEach(NotificationCenter.default.removeObserver)
        observerTokens.removeAll()
    }

    private func handleKeyboard(_ notification: Notification) {
        guard let overlayView else { return }
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            as? TimeInterval ?? Layout.animationDuration
        if notification.name == UIResponder.keyboardWillHideNotification {
            keyboardOverlap = 0
        } else if let screenFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let localFrame = overlayView.convert(screenFrame, from: nil)
            keyboardOverlap = max(0, overlayView.bounds.maxY - localFrame.minY)
        }
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: { self.updatePosition(animated: false) }
        )
    }

    private func announce(status: String?, kind: ContentKind) {
        guard UIAccessibility.isVoiceOverRunning else { return }
        let fallback: String
        switch kind {
        case .loading: fallback = "Loading"
        case .progress: fallback = "Progress"
        case .animatedIcon, .image: fallback = "Status"
        case .custom, .fullScreen: fallback = "Notification"
        }
        UIAccessibility.post(notification: .announcement, argument: status ?? fallback)
    }

    private func resetToDefaults() {
        selectedAnimationType = .systemActivityIndicator
        selectedBackgroundColor = Self.defaultBackgroundColor
        selectedHUDColor = Self.defaultHUDColor
        selectedStatusColor = Self.defaultStatusColor
        selectedAnimationColor = Self.defaultStatusColor
        selectedProgressColor = Self.defaultStatusColor
        selectedStatusFont = UIFont.preferredFont(forTextStyle: .headline)
        selectedSuccessImage = Self.defaultSuccessImage
        selectedErrorImage = Self.defaultErrorImage
        minimumDismissDelay = 1.25
        maximumDismissDelay = 5
        updateAppearance()
    }

    private static func activeWindow() -> UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
            .sorted { $0.activationState == .foregroundActive && $1.activationState != .foregroundActive }
        for scene in scenes {
            if let key = scene.windows.first(where: { $0.isKeyWindow && !$0.isHidden }) { return key }
            if let normal = scene.windows.first(where: {
                !$0.isHidden && $0.alpha > 0 && $0.windowLevel == .normal
            }) { return normal }
        }
        return nil
    }
}

// MARK: - Appearance

public extension TFYProgressSwiftHUD {
    class var animationType: AnimationType {
        get { valueOnMain { shared.selectedAnimationType } }
        set { onMain { shared.selectedAnimationType = newValue; shared.updateAppearance() } }
    }
    class var colorBackground: UIColor {
        get { valueOnMain { shared.selectedBackgroundColor } }
        set { onMain { shared.selectedBackgroundColor = newValue; shared.updateAppearance() } }
    }
    class var colorHUD: UIColor {
        get { valueOnMain { shared.selectedHUDColor } }
        set { onMain { shared.selectedHUDColor = newValue; shared.updateAppearance() } }
    }
    class var colorStatus: UIColor {
        get { valueOnMain { shared.selectedStatusColor } }
        set { onMain { shared.selectedStatusColor = newValue; shared.updateAppearance() } }
    }
    class var colorAnimation: UIColor {
        get { valueOnMain { shared.selectedAnimationColor } }
        set { onMain { shared.selectedAnimationColor = newValue; shared.updateAppearance() } }
    }
    class var colorProgress: UIColor {
        get { valueOnMain { shared.selectedProgressColor } }
        set { onMain { shared.selectedProgressColor = newValue; shared.updateAppearance() } }
    }
    class var fontStatus: UIFont {
        get { valueOnMain { shared.selectedStatusFont } }
        set { onMain { shared.selectedStatusFont = newValue; shared.updateAppearance() } }
    }
    class var imageSuccess: UIImage {
        get { valueOnMain { shared.selectedSuccessImage } }
        set { onMain { shared.selectedSuccessImage = newValue } }
    }
    class var imageError: UIImage {
        get { valueOnMain { shared.selectedErrorImage } }
        set { onMain { shared.selectedErrorImage = newValue } }
    }
    class var minimumDismissTimeInterval: TimeInterval {
        get { valueOnMain { shared.minimumDismissDelay } }
        set {
            onMain {
                shared.minimumDismissDelay = max(0, newValue)
                shared.maximumDismissDelay = max(shared.maximumDismissDelay, shared.minimumDismissDelay)
            }
        }
    }
    class var maximumDismissTimeInterval: TimeInterval {
        get { valueOnMain { shared.maximumDismissDelay } }
        set { onMain { shared.maximumDismissDelay = max(shared.minimumDismissDelay, newValue) } }
    }
    class var isVisible: Bool { valueOnMain { shared.overlayView?.superview != nil } }
    class func resetAppearance() { onMain { shared.resetToDefaults() } }
}

// MARK: - Presentation API

public extension TFYProgressSwiftHUD {
    class func dismiss(completion: (() -> Void)? = nil) {
        onMain { shared.hide(completion: completion) }
    }

    class func dismiss(after delay: TimeInterval) {
        onMain {
            shared.dismissWorkItem?.cancel()
            let item = DispatchWorkItem { [weak hud = shared] in hud?.hide(completion: nil) }
            shared.dismissWorkItem = item
            DispatchQueue.main.asyncAfter(deadline: .now() + max(0, delay), execute: item)
        }
    }

    class func show(_ status: String? = nil, interaction: Bool = true) {
        onMain { shared.present(status: status, content: .loading, automaticallyDismiss: false, interaction: interaction) }
    }

    class func show(_ status: String? = nil, in view: UIView, interaction: Bool = true) {
        onMain {
            shared.present(
                status: status, content: .loading, automaticallyDismiss: false,
                interaction: interaction, in: view
            )
        }
    }

    class func show(_ status: String? = nil, icon: AlertIcon, interaction: Bool = true) {
        onMain {
            shared.present(
                status: status, content: .image(icon.image?.withRenderingMode(.alwaysTemplate)),
                automaticallyDismiss: true, interaction: interaction
            )
        }
    }

    class func show(_ status: String? = nil, icon: AnimatedIcon, interaction: Bool = true) {
        onMain {
            shared.present(status: status, content: .animatedIcon(icon), automaticallyDismiss: true, interaction: interaction)
        }
    }

    class func showSuccess(_ status: String? = nil, image: UIImage? = nil, interaction: Bool = true) {
        onMain {
            shared.present(
                status: status, content: .image(image ?? shared.selectedSuccessImage),
                automaticallyDismiss: true, interaction: interaction
            )
        }
    }

    class func showError(_ status: String? = nil, image: UIImage? = nil, interaction: Bool = true) {
        onMain {
            shared.present(
                status: status, content: .image(image ?? shared.selectedErrorImage),
                automaticallyDismiss: true, interaction: interaction
            )
        }
    }

    class func showSucceed(_ status: String? = nil, interaction: Bool = true) {
        show(status, icon: AnimatedIcon.succeed, interaction: interaction)
    }
    class func showFailed(_ status: String? = nil, interaction: Bool = true) {
        show(status, icon: AnimatedIcon.failed, interaction: interaction)
    }
    class func showAdded(_ status: String? = nil, interaction: Bool = true) {
        show(status, icon: AnimatedIcon.added, interaction: interaction)
    }

    class func showProgress(_ progress: CGFloat, interaction: Bool = false) {
        showProgress(nil, progress, interaction: interaction)
    }
    class func showProgress(_ status: String?, _ progress: CGFloat, interaction: Bool = false) {
        onMain {
            shared.present(status: status, content: .progress(progress), automaticallyDismiss: false, interaction: interaction)
        }
    }
    class func showProgress(_ progress: CGFloat, status: String?, interaction: Bool = false) {
        showProgress(status, progress, interaction: interaction)
    }

    /// Presents progress inside a specific view instead of the active window.
    class func showProgress(
        _ progress: CGFloat,
        status: String? = nil,
        in view: UIView,
        interaction: Bool = false
    ) {
        onMain {
            shared.present(
                status: status,
                content: .progress(progress),
                automaticallyDismiss: false,
                interaction: interaction,
                in: view
            )
        }
    }

    class func show(_ status: String? = nil, customView: UIView, interaction: Bool = true) {
        show(status, customView: customView, hide: false, interaction: interaction)
    }
    class func show(_ status: String? = nil, customView: UIView, hide: Bool = true, interaction: Bool = true) {
        onMain {
            shared.present(status: status, content: .custom(customView), automaticallyDismiss: hide, interaction: interaction)
        }
    }

    class func showFullScreen(_ customView: UIView, interaction: Bool = false) {
        showFullScreen(customView, hide: false, interaction: interaction)
    }
    class func showFullScreen(_ customView: UIView, hide: Bool = true, interaction: Bool = false) {
        onMain {
            shared.present(status: nil, content: .fullScreen(customView), automaticallyDismiss: hide, interaction: interaction)
        }
    }
}

/// Returns the key window for the foreground scene. Kept for source compatibility.
@available(*, deprecated, message: "Use scene-aware presentation or show(_:in:interaction:).")
public func KeyWindows() -> UIWindow? {
    let resolve = {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
            .flatMap(\.windows)
            .first(where: { $0.isKeyWindow && !$0.isHidden })
    }
    return Thread.isMainThread ? resolve() : DispatchQueue.main.sync(execute: resolve)
}

private final class HUDOverlayView: UIView {
    var onLayout: (() -> Void)?
    var onTraitChange: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        onLayout?()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) == true else { return }
        onTraitChange?()
    }
}

private final class HUDProgressView: UIView {
    var color: UIColor { didSet { updateColors() } }
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let percentageLabel = UILabel()
    private var progress: CGFloat = 0

    init(color: UIColor) {
        self.color = color
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is unavailable") }

    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let trackRadius = max(0, min(bounds.width, bounds.height) / 2 - 2)
        trackLayer.path = circlePath(center: center, radius: trackRadius)
        progressLayer.path = circlePath(center: center, radius: max(0, trackRadius - 5))
        percentageLabel.frame = bounds
    }

    func setProgress(_ value: CGFloat, animated: Bool) {
        let clamped = min(max(value.isFinite ? value : 0, 0), 1)
        progressLayer.removeAnimation(forKey: "progress")
        if animated && !UIAccessibility.isReduceMotionEnabled {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.presentation()?.strokeEnd ?? progress
            animation.toValue = clamped
            animation.duration = 0.18
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            progressLayer.add(animation, forKey: "progress")
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = clamped
        CATransaction.commit()
        progress = clamped
        let percentage = Int((clamped * 100).rounded())
        percentageLabel.text = "\(percentage)%"
        accessibilityValue = "\(percentage)%"
    }

    private func setup() {
        isAccessibilityElement = true
        accessibilityIdentifier = "tfy.hud.progress"
        accessibilityLabel = NSLocalizedString("Progress", comment: "HUD accessibility label")
        accessibilityTraits = .updatesFrequently
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 3
        trackLayer.opacity = 0.35
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 7
        progressLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
        percentageLabel.adjustsFontForContentSizeCategory = true
        addSubview(percentageLabel)
        updateColors()
    }

    private func circlePath(center: CGPoint, radius: CGFloat) -> CGPath {
        UIBezierPath(
            arcCenter: center, radius: radius, startAngle: -.pi / 2,
            endAngle: .pi * 1.5, clockwise: true
        ).cgPath
    }

    private func updateColors() {
        trackLayer.strokeColor = color.cgColor
        progressLayer.strokeColor = color.cgColor
        percentageLabel.textColor = color
    }
}
