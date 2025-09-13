//
//  ViewController.swift
//  TFYProgressSwiftHUD
//
//  Created by 田风有 on 2021/4/10.
//

import UIKit
import Lottie

func log<T>(_ msg: T,file: NSString = #file, line: Int = #line, fn: String = #function) {
    #if DEBUG
    let prefix = "\(file.lastPathComponent)_\(line)_\(fn):"
    print(prefix, msg)
    #endif
}

class ViewController: UIViewController {
    
    private var types: [String] = []
    private var actions1: [String] = []
    private var actions2: [String] = []
    private var actions3: [String] = []
    private var actions4: [String] = []
    private var actions5: [String] = []
    private var actions6: [String] = []
    private var actions7: [String] = []
    private var actions8: [String] = []
    private var actions9: [String] = []
    private var actions10: [String] = []

    private var timer: Timer?
    private var status: String?

    private let textShort    = "请稍等..."
    private let textLong    = "请稍等。拉斯可能翻番了反复拿饭是免费拿，反，拿饭，按，拿饭，案犯，泛泛泛滥反腐两年拉了父类你发你发，啊你"

    private let textSuccess    = "那是太棒了!"
    private let textError    = "发生了一些错误。"

    private let textSucceed    = "那是太棒了!"
    private let textFailed    = "发生了一些错误。"
    private let textAdded    = "成功地补充道。"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "TFYProgressSwiftHUD - 功能展示"
        
        // 基础功能
        actions1.append("动画-没有文字")
        actions1.append("动画-短文本")
        actions1.append("动画-较长的文本")

        // 动画类型
        types.append("系统活动指标")
        types.append("水平圆脉冲")
        types.append("行缩放")
        types.append("单圈脉冲")
        types.append("多个圆脉冲")
        types.append("单圆尺度波痕")
        types.append("多圆尺度波痕")
        types.append("圆旋转褪色")
        types.append("行旋转褪色")
        types.append("圆旋转追逐")
        types.append("圆中风旋转")

        // 进度条功能
        actions2.append("进度-没有文本")
        actions2.append("进度-短文本")
        actions2.append("进度-较长的文本")

        actions3.append("进度 - 10%")
        actions3.append("进度 - 40%")
        actions3.append("进度 - 60%")
        actions3.append("进度 - 90%")

        // 静态图标功能
        actions4.append("成功-没有文字")
        actions4.append("成功-短文本")
        actions4.append("错误-没有文本")
        actions4.append("错误-短文本")

        // 动画图标功能
        actions5.append("成功-没有文本")
        actions5.append("成功-短文本")
        actions5.append("失败-没有文本")
        actions5.append("失败-短文本")
        actions5.append("新增-无文字")
        actions5.append("新增-短文本")

        // 系统图标功能
        actions6.append("心")
        actions6.append("医生")
        actions6.append("书签")
        actions6.append("月亮")
        actions6.append("明星")
        actions6.append("感叹")
        actions6.append("国旗")
        actions6.append("消息")
        actions6.append("问题")
        actions6.append("螺栓")
        actions6.append("洗牌")
        actions6.append("喷射")
        actions6.append("卡")
        actions6.append("旋转")
        actions6.append("就像")
        actions6.append("不喜欢")
        actions6.append("隐私")
        actions6.append("车")
        actions6.append("搜索")
        
        // 颜色自定义功能
        actions7.append("默认颜色")
        actions7.append("红色主题")
        actions7.append("蓝色主题")
        actions7.append("绿色主题")
        actions7.append("紫色主题")
        actions7.append("橙色主题")
        
        // 字体自定义功能
        actions8.append("默认字体")
        actions8.append("大字体")
        actions8.append("小字体")
        actions8.append("粗体字体")
        actions8.append("斜体字体")
        
        // 图片自定义功能
        actions9.append("默认成功图片")
        actions9.append("自定义成功图片")
        actions9.append("默认错误图片")
        actions9.append("自定义错误图片")
        
        // 自定义view功能
        actions10.append("自定义Loading View")
        actions10.append("自定义Success View")
        actions10.append("自定义Error View")
        actions10.append("自定义Progress View")
        actions10.append("Lottie动画示例")
        actions10.append("自定义动画View")
        actions10.append("全屏Lottie动画")
        actions10.append("全屏自定义动画")
        actions10.append("全屏加载动画")
        
        self.view.addSubview(tableView)
        
    }
    
    func actionProgressStart(_ status: String? = nil) {
        timer?.invalidate()
        timer = nil
        var intervalCount: CGFloat = 0.0
        TFYProgressSwiftHUD.showProgress(status, intervalCount/100)
        timer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true) { timer in
            intervalCount += 1
            TFYProgressSwiftHUD.showProgress(status, intervalCount/100)
            if (intervalCount >= 100) {
                log("打印结果=========：\(intervalCount)");
                self.actionProgressStop()
            }
        }
    }
    
    func actionProgressStop() {
        timer?.invalidate()
        timer = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            TFYProgressSwiftHUD.showSucceed(interaction: false)
        }
    }

    /// 创建自定义Loading View
    private func createCustomLoadingView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        containerView.backgroundColor = .clear
        
        // 使用Lottie动画
        if let animation = LottieAnimation.named("加载-下拉") {
            let animationView = LottieAnimationView(animation: animation)
            animationView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            containerView.addSubview(animationView)
        } else {
            // 备用方案：使用系统活动指示器
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .systemBlue
            activityIndicator.startAnimating()
            activityIndicator.center = CGPoint(x: 30, y: 30)
            containerView.addSubview(activityIndicator)
        }
        
        return containerView
    }
    
    /// 创建自定义Success View
    private func createCustomSuccessView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        containerView.backgroundColor = .clear
        
        let checkmarkView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        checkmarkView.center = CGPoint(x: 30, y: 30)
        checkmarkView.backgroundColor = .systemGreen
        checkmarkView.layer.cornerRadius = 20
        
        let checkmarkLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        checkmarkLabel.text = "✓"
        checkmarkLabel.textColor = .white
        checkmarkLabel.textAlignment = .center
        checkmarkLabel.font = UIFont.boldSystemFont(ofSize: 24)
        checkmarkView.addSubview(checkmarkLabel)
        
        containerView.addSubview(checkmarkView)
        
        // 添加动画
        checkmarkView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            checkmarkView.transform = .identity
        }, completion: nil)
        
        return containerView
    }
    
    /// 创建自定义Error View
    private func createCustomErrorView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        containerView.backgroundColor = .clear
        
        let errorView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        errorView.center = CGPoint(x: 30, y: 30)
        errorView.backgroundColor = .systemRed
        errorView.layer.cornerRadius = 20
        
        let errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        errorLabel.text = "✕"
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.boldSystemFont(ofSize: 20)
        errorView.addSubview(errorLabel)
        
        containerView.addSubview(errorView)
        
        // 添加动画
        errorView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            errorView.transform = .identity
        }, completion: nil)
        
        return containerView
    }
    
    /// 创建自定义Progress View
    private func createCustomProgressView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        containerView.backgroundColor = .clear
        
        let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        progressView.center = CGPoint(x: 30, y: 30)
        progressView.backgroundColor = .systemBlue
        progressView.layer.cornerRadius = 20
        
        let progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        progressLabel.text = "0%"
        progressLabel.textColor = .white
        progressLabel.textAlignment = .center
        progressLabel.font = UIFont.boldSystemFont(ofSize: 12)
        progressView.addSubview(progressLabel)
        
        containerView.addSubview(progressView)
        
        // 模拟进度更新
        var progress = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 5
            if progress <= 100 {
                progressLabel.text = "\(progress)%"
                progressView.transform = CGAffineTransform(rotationAngle: CGFloat(progress) * .pi / 50)
            } else {
                timer.invalidate()
            }
        }
        
        return containerView
    }
    
    /// 创建Lottie动画示例View
    private func createLottieAnimationView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        containerView.backgroundColor = .clear
        
        // 使用Lottie动画
        if let animation = LottieAnimation.named("加载-中间") {
            let animationView = LottieAnimationView(animation: animation)
            animationView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            containerView.addSubview(animationView)
        } else {
            // 备用方案：使用系统活动指示器
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .systemPurple
            activityIndicator.startAnimating()
            activityIndicator.center = CGPoint(x: 30, y: 30)
            containerView.addSubview(activityIndicator)
        }
        
        return containerView
    }
    
    /// 创建自定义动画View
    private func createCustomAnimationView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        containerView.backgroundColor = .clear
        
        let animationView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        animationView.center = CGPoint(x: 30, y: 30)
        animationView.backgroundColor = .systemOrange
        animationView.layer.cornerRadius = 20
        
        let animationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        animationLabel.text = "✨"
        animationLabel.textAlignment = .center
        animationLabel.font = UIFont.systemFont(ofSize: 20)
        animationView.addSubview(animationLabel)
        
        containerView.addSubview(animationView)
        
        // 添加弹跳动画
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.2, 0.8, 1.1, 1.0]
        bounceAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 1]
        bounceAnimation.duration = 1.0
        bounceAnimation.repeatCount = .infinity
        animationView.layer.add(bounceAnimation, forKey: "bounceAnimation")
        
        return containerView
    }
    
    /// 创建全屏Lottie动画View
    private func createFullScreenLottieView() -> UIView {
        let containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        // 使用Lottie动画
        if let animation = LottieAnimation.named("加载-中间") {
            let animationView = LottieAnimationView(animation: animation)
            animationView.frame = CGRect(x: 0, y: 0, width: 105, height: 105)
            animationView.center = containerView.center
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            containerView.addSubview(animationView)
        } else {
            // 备用方案：使用系统活动指示器
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.startAnimating()
            activityIndicator.center = containerView.center
            containerView.addSubview(activityIndicator)
        }
        
        // 添加文字说明
        let titleLabel = UILabel()
        titleLabel.text = "Lottie动画播放中..."
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 120)
        ])
        
        return containerView
    }
    
    /// 创建全屏自定义动画View
    private func createFullScreenCustomAnimationView() -> UIView {
        let containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        
        let animationView = UIView(frame: CGRect(x: 0, y: 0, width: 105, height: 105))
        animationView.center = containerView.center
        animationView.backgroundColor = .white
        animationView.layer.cornerRadius = 75
        
        let animationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 105, height: 105))
        animationLabel.text = "✨"
        animationLabel.textAlignment = .center
        animationLabel.font = UIFont.systemFont(ofSize: 60)
        animationView.addSubview(animationLabel)
        
        containerView.addSubview(animationView)
        
        // 添加弹跳动画
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.3, 0.7, 1.1, 1.0]
        bounceAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 1]
        bounceAnimation.duration = 1.5
        bounceAnimation.repeatCount = .infinity
        animationView.layer.add(bounceAnimation, forKey: "bounceAnimation")
        
        // 添加文字说明
        let titleLabel = UILabel()
        titleLabel.text = "自定义动画播放中..."
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 30)
        ])
        
        return containerView
    }
    
    /// 创建全屏加载动画View
    private func createFullScreenLoadingView() -> UIView {
        let containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.8)
        
        // 使用Lottie动画
        if let animation = LottieAnimation.named("加载-中间") {
            let animationView = LottieAnimationView(animation: animation)
            animationView.frame = CGRect(x: 0, y: 0, width: 105, height: 105)
            animationView.center = containerView.center
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            containerView.addSubview(animationView)
        } else {
            // 备用方案：使用系统活动指示器
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.startAnimating()
            activityIndicator.center = containerView.center
            containerView.addSubview(activityIndicator)
        }
        
        // 添加文字说明
        let titleLabel = UILabel()
        titleLabel.text = "正在加载中..."
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 100)
        ])
        
        return containerView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.frame
    }
}

extension ViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return actions1.count
        case 2: return types.count
        case 3: return actions2.count
        case 4: return actions3.count
        case 5: return actions4.count
        case 6: return actions5.count
        case 7: return actions6.count
        case 8: return actions7.count
        case 9: return actions8.count
        case 10: return actions9.count
        case 11: return actions10.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) && (indexPath.row == 0) { return self.tableView(tableView, cellWithText: "类型")     }
        if (indexPath.section == 0) && (indexPath.row == 1) { return self.tableView(tableView, cellWithText: "关闭 Keyboard")    }
        if (indexPath.section == 0) && (indexPath.row == 2) { return self.tableView(tableView, cellWithText: "关闭 HUD")            }

        if (indexPath.section == 1) { return self.tableView(tableView, cellWithText: actions1[indexPath.row])    }
        if (indexPath.section == 2) { return self.tableView(tableView, cellWithText: types[indexPath.row])        }
        if (indexPath.section == 3) { return self.tableView(tableView, cellWithText: actions2[indexPath.row])    }
        if (indexPath.section == 4) { return self.tableView(tableView, cellWithText: actions3[indexPath.row])    }
        if (indexPath.section == 5) { return self.tableView(tableView, cellWithText: actions4[indexPath.row])    }
        if (indexPath.section == 6) { return self.tableView(tableView, cellWithText: actions5[indexPath.row])    }
        if (indexPath.section == 7) { return self.tableView(tableView, cellWithText: actions6[indexPath.row])    }
        if (indexPath.section == 8) { return self.tableView(tableView, cellWithText: actions7[indexPath.row])    }
        if (indexPath.section == 9) { return self.tableView(tableView, cellWithText: actions8[indexPath.row])    }
        if (indexPath.section == 10) { return self.tableView(tableView, cellWithText: actions9[indexPath.row])    }
        if (indexPath.section == 11) { return self.tableView(tableView, cellWithText: actions10[indexPath.row])    }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "基础动画功能"
        case 2: return "动画类型选择"
        case 3: return "进度条功能"
        case 4: return "进度条数值"
        case 5: return "静态图标功能"
        case 6: return "动画图标功能"
        case 7: return "系统图标功能"
        case 8: return "颜色自定义"
        case 9: return "字体自定义"
        case 10: return "图片自定义"
        case 11: return "自定义View功能"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellWithText text: String) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = text
        return cell
    }
}

extension ViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // 基础功能
        if (indexPath.section == 0) && (indexPath.row == 1) { view.endEditing(true)             }
        if (indexPath.section == 0) && (indexPath.row == 2) { TFYProgressSwiftHUD.dismiss()                }

        // 基础动画功能
        if (indexPath.section == 1) {
            if (indexPath.row == 0) { TFYProgressSwiftHUD.show();            status = nil                }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.show(textShort);    status = textShort            }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.show(textLong);    status = textLong            }
        }

        // 动画类型选择
        if (indexPath.section == 2)    {
            if (indexPath.row == 0)     { TFYProgressSwiftHUD.animationType = .systemActivityIndicator        }
            if (indexPath.row == 1)     { TFYProgressSwiftHUD.animationType = .horizontalCirclesPulse        }
            if (indexPath.row == 2)     { TFYProgressSwiftHUD.animationType = .lineScaling                    }
            if (indexPath.row == 3)     { TFYProgressSwiftHUD.animationType = .singleCirclePulse            }
            if (indexPath.row == 4)     { TFYProgressSwiftHUD.animationType = .multipleCirclePulse            }
            if (indexPath.row == 5)     { TFYProgressSwiftHUD.animationType = .singleCircleScaleRipple        }
            if (indexPath.row == 6)     { TFYProgressSwiftHUD.animationType = .multipleCircleScaleRipple    }
            if (indexPath.row == 7)     { TFYProgressSwiftHUD.animationType = .circleSpinFade                }
            if (indexPath.row == 8)     { TFYProgressSwiftHUD.animationType = .lineSpinFade                }
            if (indexPath.row == 9)     { TFYProgressSwiftHUD.animationType = .circleRotateChase            }
            if (indexPath.row == 10) { TFYProgressSwiftHUD.animationType = .circleStrokeSpin            }
            TFYProgressSwiftHUD.show(status)
        }

        // 进度条功能
        if (indexPath.section == 3) {
            if (indexPath.row == 0) { actionProgressStart()                                        }
            if (indexPath.row == 1) { actionProgressStart(textShort)                            }
            if (indexPath.row == 2) { actionProgressStart(textLong)                                }
        }

        // 进度条数值
        if (indexPath.section == 4) {
            if (indexPath.row == 0) { TFYProgressSwiftHUD.showProgress(0.1, interaction: true)            }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.showProgress(0.4, interaction: true)            }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.showProgress(0.6, interaction: true)            }
            if (indexPath.row == 3) { TFYProgressSwiftHUD.showProgress(0.9, interaction: true)            }
        }

        // 静态图标功能
        if (indexPath.section == 5) {
            if (indexPath.row == 0) { TFYProgressSwiftHUD.showSuccess()                                    }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.showSuccess(textSuccess)                        }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.showError()                                    }
            if (indexPath.row == 3) { TFYProgressSwiftHUD.showError(textError)                            }
        }

        // 动画图标功能
        if (indexPath.section == 6) {
            if (indexPath.row == 0) { TFYProgressSwiftHUD.showSucceed()                                    }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.showSucceed(textSucceed)                        }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.showFailed()                                    }
            if (indexPath.row == 3) { TFYProgressSwiftHUD.showFailed(textFailed)                        }
            if (indexPath.row == 4) { TFYProgressSwiftHUD.showAdded()                                    }
            if (indexPath.row == 5) { TFYProgressSwiftHUD.showAdded(textAdded)                            }
        }

        // 系统图标功能
        if (indexPath.section == 7) {
            if (indexPath.row == 0) { TFYProgressSwiftHUD.show(status,icon: .heart)                            }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.show(status,icon: .doc)                                }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.show(status,icon: .bookmark)                            }
            if (indexPath.row == 3) { TFYProgressSwiftHUD.show(status,icon: .moon)                                }
            if (indexPath.row == 4) { TFYProgressSwiftHUD.show(status,icon: .star)                                }
            if (indexPath.row == 5) { TFYProgressSwiftHUD.show(status,icon: .exclamation)                        }
            if (indexPath.row == 6) { TFYProgressSwiftHUD.show(status,icon: .flag)                                }
            if (indexPath.row == 7) { TFYProgressSwiftHUD.show(status,icon: .message)                            }
            if (indexPath.row == 8) { TFYProgressSwiftHUD.show(status,icon: .question)                            }
            if (indexPath.row == 9) { TFYProgressSwiftHUD.show(status,icon: .bolt)                                }
            if (indexPath.row == 10) { TFYProgressSwiftHUD.show(status,icon: .shuffle)                            }
            if (indexPath.row == 11) { TFYProgressSwiftHUD.show(status,icon: .eject)                            }
            if (indexPath.row == 12) { TFYProgressSwiftHUD.show(status,icon: .card)                            }
            if (indexPath.row == 13) { TFYProgressSwiftHUD.show(status,icon: .rotate)                            }
            if (indexPath.row == 14) { TFYProgressSwiftHUD.show(status,icon: .like)                            }
            if (indexPath.row == 15) { TFYProgressSwiftHUD.show(status,icon: .dislike)                            }
            if (indexPath.row == 16) { TFYProgressSwiftHUD.show(status,icon: .privacy)                            }
            if (indexPath.row == 17) { TFYProgressSwiftHUD.show(status,icon: .cart)                            }
            if (indexPath.row == 18) { TFYProgressSwiftHUD.show(status,icon: .search)                            }
        }
        
        // 颜色自定义功能
        if (indexPath.section == 8) {
            if (indexPath.row == 0) { 
                // 恢复默认颜色
                TFYProgressSwiftHUD.colorBackground = UIColor.systemBackground.withAlphaComponent(0.2)
                TFYProgressSwiftHUD.colorHUD = UIColor.systemGray6
                TFYProgressSwiftHUD.colorStatus = UIColor.label
                TFYProgressSwiftHUD.colorAnimation = UIColor.label
                TFYProgressSwiftHUD.colorProgress = UIColor.label
                TFYProgressSwiftHUD.show("默认颜色主题")
            }
            if (indexPath.row == 1) { 
                // 红色主题
                TFYProgressSwiftHUD.colorBackground = UIColor.red.withAlphaComponent(0.2)
                TFYProgressSwiftHUD.colorHUD = UIColor.systemRed
                TFYProgressSwiftHUD.colorStatus = UIColor.white
                TFYProgressSwiftHUD.colorAnimation = UIColor.white
                TFYProgressSwiftHUD.colorProgress = UIColor.white
                TFYProgressSwiftHUD.show("红色主题")
            }
            if (indexPath.row == 2) { 
                // 蓝色主题
                TFYProgressSwiftHUD.colorBackground = UIColor.blue.withAlphaComponent(0.2)
                TFYProgressSwiftHUD.colorHUD = UIColor.systemBlue
                TFYProgressSwiftHUD.colorStatus = UIColor.white
                TFYProgressSwiftHUD.colorAnimation = UIColor.white
                TFYProgressSwiftHUD.colorProgress = UIColor.white
                TFYProgressSwiftHUD.show("蓝色主题")
            }
            if (indexPath.row == 3) { 
                // 绿色主题
                TFYProgressSwiftHUD.colorBackground = UIColor.green.withAlphaComponent(0.2)
                TFYProgressSwiftHUD.colorHUD = UIColor.systemGreen
                TFYProgressSwiftHUD.colorStatus = UIColor.white
                TFYProgressSwiftHUD.colorAnimation = UIColor.white
                TFYProgressSwiftHUD.colorProgress = UIColor.white
                TFYProgressSwiftHUD.show("绿色主题")
            }
            if (indexPath.row == 4) { 
                // 紫色主题
                TFYProgressSwiftHUD.colorBackground = UIColor.purple.withAlphaComponent(0.2)
                TFYProgressSwiftHUD.colorHUD = UIColor.systemPurple
                TFYProgressSwiftHUD.colorStatus = UIColor.white
                TFYProgressSwiftHUD.colorAnimation = UIColor.white
                TFYProgressSwiftHUD.colorProgress = UIColor.white
                TFYProgressSwiftHUD.show("紫色主题")
            }
            if (indexPath.row == 5) { 
                // 橙色主题
                TFYProgressSwiftHUD.colorBackground = UIColor.orange.withAlphaComponent(0.2)
                TFYProgressSwiftHUD.colorHUD = UIColor.systemOrange
                TFYProgressSwiftHUD.colorStatus = UIColor.white
                TFYProgressSwiftHUD.colorAnimation = UIColor.white
                TFYProgressSwiftHUD.colorProgress = UIColor.white
                TFYProgressSwiftHUD.show("橙色主题")
            }
        }
        
        // 字体自定义功能
        if (indexPath.section == 9) {
            if (indexPath.row == 0) { 
                // 默认字体
                TFYProgressSwiftHUD.fontStatus = UIFont.boldSystemFont(ofSize: 24)
                TFYProgressSwiftHUD.show("默认字体")
            }
            if (indexPath.row == 1) { 
                // 大字体
                TFYProgressSwiftHUD.fontStatus = UIFont.boldSystemFont(ofSize: 32)
                TFYProgressSwiftHUD.show("大字体")
            }
            if (indexPath.row == 2) { 
                // 小字体
                TFYProgressSwiftHUD.fontStatus = UIFont.systemFont(ofSize: 16)
                TFYProgressSwiftHUD.show("小字体")
            }
            if (indexPath.row == 3) { 
                // 粗体字体
                TFYProgressSwiftHUD.fontStatus = UIFont.boldSystemFont(ofSize: 28)
                TFYProgressSwiftHUD.show("粗体字体")
            }
            if (indexPath.row == 4) { 
                // 斜体字体
                TFYProgressSwiftHUD.fontStatus = UIFont.italicSystemFont(ofSize: 24)
                TFYProgressSwiftHUD.show("斜体字体")
            }
        }
        
        // 图片自定义功能
        if (indexPath.section == 10) {
            if (indexPath.row == 0) { 
                // 默认成功图片
                TFYProgressSwiftHUD.imageSuccess = UIImage(named: "reward_alert_coins") ?? UIImage()
                TFYProgressSwiftHUD.colorHUD = UIColor.black
                TFYProgressSwiftHUD.colorStatus = UIColor.yellow
                TFYProgressSwiftHUD.colorAnimation = UIColor.yellow
                TFYProgressSwiftHUD.colorProgress = UIColor.yellow
                TFYProgressSwiftHUD.showSuccess("+5 Bonus")
            }
            if (indexPath.row == 1) { 
                // 自定义成功图片
                let customImage = UIImage(systemName: "star.fill")?.withTintColor(UIColor.systemYellow, renderingMode: .alwaysOriginal) ?? UIImage()
                TFYProgressSwiftHUD.showSuccess("自定义成功图片", image: customImage)
            }
            if (indexPath.row == 2) { 
                // 默认错误图片
                TFYProgressSwiftHUD.imageError = UIImage(systemName: "xmark")?.withTintColor(UIColor.systemRed, renderingMode: .alwaysOriginal) ?? UIImage()
                TFYProgressSwiftHUD.showError("默认错误图片")
            }
            if (indexPath.row == 3) { 
                // 自定义错误图片
                let customImage = UIImage(systemName: "exclamationmark.triangle.fill")?.withTintColor(UIColor.systemOrange, renderingMode: .alwaysOriginal) ?? UIImage()
                TFYProgressSwiftHUD.showError("自定义错误图片", image: customImage)
            }
        }
        
        // 自定义View功能
        if (indexPath.section == 11) {
            if (indexPath.row == 0) {
                // 自定义Loading View
                let customLoadingView = createCustomLoadingView()
                TFYProgressSwiftHUD.show("自定义Loading", customView: customLoadingView)
            }
            if (indexPath.row == 1) { 
                // 自定义Success View
                let customSuccessView = createCustomSuccessView()
                TFYProgressSwiftHUD.show("自定义Success", customView: customSuccessView, hide: true)
            }
            if (indexPath.row == 2) { 
                // 自定义Error View
                let customErrorView = createCustomErrorView()
                TFYProgressSwiftHUD.show("自定义Error", customView: customErrorView, hide: true)
            }
            if (indexPath.row == 3) { 
                // 自定义Progress View
                let customProgressView = createCustomProgressView()
                TFYProgressSwiftHUD.show("自定义Progress", customView: customProgressView)
            }
            if (indexPath.row == 4) { 
                // Lottie动画示例
                let lottieAnimationView = createLottieAnimationView()
                TFYProgressSwiftHUD.show("Lottie动画示例", customView: lottieAnimationView)
            }
            if (indexPath.row == 5) { 
                // 自定义动画View
                let customAnimationView = createCustomAnimationView()
                TFYProgressSwiftHUD.show("自定义动画", customView: customAnimationView)
            }
            if (indexPath.row == 6) { 
                // 全屏Lottie动画
                let fullScreenLottieView = createFullScreenLottieView()
                TFYProgressSwiftHUD.showFullScreen(fullScreenLottieView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    TFYProgressSwiftHUD.dismiss()
                }
            }
            if (indexPath.row == 7) { 
                // 全屏自定义动画
                let fullScreenCustomAnimationView = createFullScreenCustomAnimationView()
                TFYProgressSwiftHUD.showFullScreen(fullScreenCustomAnimationView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    TFYProgressSwiftHUD.dismiss()
                }
            }
            if (indexPath.row == 8) { 
                // 全屏加载动画
                let fullScreenLoadingView = createFullScreenLoadingView()
                TFYProgressSwiftHUD.showFullScreen(fullScreenLoadingView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    TFYProgressSwiftHUD.dismiss()
                }
            }
        }
    }
}
