//
//  ViewController.swift
//  TFYProgressSwiftHUD
//
//  Created by 田风有 on 2021/4/10.
//

import UIKit


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
        title = "TFYProgressSwiftHUD"
        
        actions1.append("动画-没有文字")
        actions1.append("动画-短文本")
        actions1.append("动画-较长的文本")

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

        actions2.append("进度-没有文本")
        actions2.append("进度-短文本")
        actions2.append("进度-较长的文本")

        actions3.append("进度 - 10%")
        actions3.append("进度 - 40%")
        actions3.append("进度 - 60%")
        actions3.append("进度 - 90%")

        actions4.append("成功-没有文字")
        actions4.append("成功-短文本")
        actions4.append("错误-没有文本")
        actions4.append("错误-短文本")

        actions5.append("成功-没有文本")
        actions5.append("成功-短文本")
        actions5.append("失败-没有文本")
        actions5.append("失败-短文本")
        actions5.append("新增-无文字")
        actions5.append("新增-短文本")

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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.frame
    }
}

extension ViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) { return 3                }
        if (section == 1) { return actions1.count    }
        if (section == 2) { return types.count        }
        if (section == 3) { return actions2.count    }
        if (section == 4) { return actions3.count    }
        if (section == 5) { return actions4.count    }
        if (section == 6) { return actions5.count    }
        if (section == 7) { return actions6.count    }
        return 0
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

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if (section == 1) { return "动画"            }
        if (section == 2) { return "动画类型"    }
        if (section == 3) { return "进步"            }
        if (section == 4) { return "进步"            }
        if (section == 5) { return "行动——静态"    }
        if (section == 6) { return "行动——动画"    }
        if (section == 7) { return "图标-静态"        }

        return nil
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

        if (indexPath.section == 0) && (indexPath.row == 1) { view.endEditing(true)             }
        if (indexPath.section == 0) && (indexPath.row == 2) { TFYProgressSwiftHUD.dismiss()                }

        if (indexPath.section == 1) {
            if (indexPath.row == 0) { TFYProgressSwiftHUD.show();            status = nil                }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.show(textShort);    status = textShort            }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.show(textLong);    status = textLong            }
        }

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

        if (indexPath.section == 3) {
            if (indexPath.row == 0) { actionProgressStart()                                        }
            if (indexPath.row == 1) { actionProgressStart(textShort)                            }
            if (indexPath.row == 2) { actionProgressStart(textLong)                                }
        }

        if (indexPath.section == 4) {
            if (indexPath.row == 0) { TFYProgressSwiftHUD.showProgress(0.1, interaction: true)            }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.showProgress(0.4, interaction: true)            }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.showProgress(0.6, interaction: true)            }
            if (indexPath.row == 3) { TFYProgressSwiftHUD.showProgress(0.9, interaction: true)            }
        }

        if (indexPath.section == 5) {
            if (indexPath.row == 0) { TFYProgressSwiftHUD.showSuccess()                                    }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.showSuccess(textSuccess)                        }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.showError()                                    }
            if (indexPath.row == 3) { TFYProgressSwiftHUD.showError(textError)                            }
        }

        if (indexPath.section == 6) {
            if (indexPath.row == 0) { TFYProgressSwiftHUD.showSucceed()                                    }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.showSucceed(textSucceed)                        }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.showFailed()                                    }
            if (indexPath.row == 3) { TFYProgressSwiftHUD.showFailed(textFailed)                        }
            if (indexPath.row == 4) { TFYProgressSwiftHUD.showAdded()                                    }
            if (indexPath.row == 5) { TFYProgressSwiftHUD.showAdded(textAdded)                            }
        }

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
    }
}
