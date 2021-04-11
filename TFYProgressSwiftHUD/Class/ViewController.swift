//
//  ViewController.swift
//  TFYProgressSwiftHUD
//
//  Created by 田风有 on 2021/4/10.
//

import UIKit

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

    private let textShort    = "Please wait..."
    private let textLong    = "Please wait. We need some more time to work out this situation."

    private let textSuccess    = "That was awesome!"
    private let textError    = "Something went wrong."

    private let textSucceed    = "That was awesome!"
    private let textFailed    = "Something went wrong."
    private let textAdded    = "Successfully added."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "TFYProgressSwiftHUD"
        
        actions1.append("Animation - No text")
        actions1.append("Animation - Short text")
        actions1.append("Animation - Longer text")

        types.append("System Activity Indicator")
        types.append("Horizontal Circles Pulse")
        types.append("Line Scaling")
        types.append("Single Circle Pulse")
        types.append("Multiple Circle Pulse")
        types.append("Single Circle Scale Ripple")
        types.append("Multiple Circle Scale Ripple")
        types.append("Circle Spin Fade")
        types.append("Line Spin Fade")
        types.append("Circle Rotate Chase")
        types.append("Circle Stroke Spin")

        actions2.append("Progress - No text")
        actions2.append("Progress - Short text")
        actions2.append("Progress - Longer text")

        actions3.append("Progress - 10%")
        actions3.append("Progress - 40%")
        actions3.append("Progress - 60%")
        actions3.append("Progress - 90%")

        actions4.append("Success - No text")
        actions4.append("Success - Short text")
        actions4.append("Error - No text")
        actions4.append("Error - Short text")

        actions5.append("Succeed - No text")
        actions5.append("Succeed - Short text")
        actions5.append("Failed - No text")
        actions5.append("Failed - Short text")
        actions5.append("Added - No text")
        actions5.append("Added - Short text")

        actions6.append("Heart")
        actions6.append("Doc")
        actions6.append("Bookmark")
        actions6.append("Moon")
        actions6.append("Star")
        actions6.append("Exclamation")
        actions6.append("Flag")
        actions6.append("Message")
        actions6.append("Question")
        actions6.append("Bolt")
        actions6.append("Shuffle")
        actions6.append("Eject")
        actions6.append("Card")
        actions6.append("Rotate")
        actions6.append("Like")
        actions6.append("Dislike")
        actions6.append("Privacy")
        actions6.append("Cart")
        actions6.append("Search")


        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
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

        if (indexPath.section == 0) && (indexPath.row == 0) { return self.tableView(tableView, cellWithText: "cell")     }

        if (indexPath.section == 0) && (indexPath.row == 1) { return self.tableView(tableView, cellWithText: "Dismiss Keyboard")    }
        if (indexPath.section == 0) && (indexPath.row == 2) { return self.tableView(tableView, cellWithText: "Dismiss HUD")            }

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

        if (section == 1) { return "Animation"            }
        if (section == 2) { return "Animation Types"    }
        if (section == 3) { return "Progress"            }
        if (section == 4) { return "Progress"            }
        if (section == 5) { return "Action - Static"    }
        if (section == 6) { return "Action - Animated"    }
        if (section == 7) { return "Icons - Static"        }

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
            if (indexPath.row == 0) { TFYProgressSwiftHUD.show(icon: .heart)                            }
            if (indexPath.row == 1) { TFYProgressSwiftHUD.show(icon: .doc)                                }
            if (indexPath.row == 2) { TFYProgressSwiftHUD.show(icon: .bookmark)                            }
            if (indexPath.row == 3) { TFYProgressSwiftHUD.show(icon: .moon)                                }
            if (indexPath.row == 4) { TFYProgressSwiftHUD.show(icon: .star)                                }
            if (indexPath.row == 5) { TFYProgressSwiftHUD.show(icon: .exclamation)                        }
            if (indexPath.row == 6) { TFYProgressSwiftHUD.show(icon: .flag)                                }
            if (indexPath.row == 7) { TFYProgressSwiftHUD.show(icon: .message)                            }
            if (indexPath.row == 8) { TFYProgressSwiftHUD.show(icon: .question)                            }
            if (indexPath.row == 9) { TFYProgressSwiftHUD.show(icon: .bolt)                                }
            if (indexPath.row == 10) { TFYProgressSwiftHUD.show(icon: .shuffle)                            }
            if (indexPath.row == 11) { TFYProgressSwiftHUD.show(icon: .eject)                            }
            if (indexPath.row == 12) { TFYProgressSwiftHUD.show(icon: .card)                            }
            if (indexPath.row == 13) { TFYProgressSwiftHUD.show(icon: .rotate)                            }
            if (indexPath.row == 14) { TFYProgressSwiftHUD.show(icon: .like)                            }
            if (indexPath.row == 15) { TFYProgressSwiftHUD.show(icon: .dislike)                            }
            if (indexPath.row == 16) { TFYProgressSwiftHUD.show(icon: .privacy)                            }
            if (indexPath.row == 17) { TFYProgressSwiftHUD.show(icon: .cart)                            }
            if (indexPath.row == 18) { TFYProgressSwiftHUD.show(icon: .search)                            }
        }
    }
}
