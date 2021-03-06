//
//  ViewController.swift
//  MyRx
//
//  Created by Maple on 2017/8/29.
//  Copyright © 2017年 Maple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
        }
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "简单的加法"
            cell?.detailTextLabel?.text = "Bindings的使用"
        case 1:
            cell?.textLabel?.text = "表单校验"
            cell?.detailTextLabel?.text = "Bindings的使用"
        case 2:
            cell?.textLabel?.text = "地理位置监听"
            cell?.detailTextLabel?.text = "Observer，service和Driver的使用"
        case 3:
            cell?.textLabel?.text = "Github注册-使用Observerable"
            cell?.detailTextLabel?.text = "简单的MVVM例子"
        case 4:
            cell?.textLabel?.text = "Github注册-使用Driver"
            cell?.detailTextLabel?.text = "简单的MVVM例子"
        case 5:
            cell?.textLabel?.text = "APIWrapper"
            cell?.detailTextLabel?.text = "APIWrapper"
        case 6:
            cell?.textLabel?.text = "计算器"
        case 7:
            cell?.textLabel?.text = "UIImagePicker"
        case 8:
            cell?.textLabel?.text = "PickerView"
        case 9:
            cell?.textLabel?.text = "UITableView的简单使用"
        case 10:
            cell?.textLabel?.text = "UITableView带SectionHeader的简单使用"
        case 11:
            cell?.textLabel?.text = "UITableView的命令使用"
        default:
            break
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = PlusViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = ValidationViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = LocationViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = GithubBindingViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = GitHubSignUpViewController2()
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = APIWrappersViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = CalCulatorViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = ImagePickerController()
            navigationController?.pushViewController(vc, animated: true)
        case 8:
            let vc = MyTabBarViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 9:
            let vc = SimpleTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 10:
            let vc = SimpleSectionViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 11:
            let vc = TableViewWithEditingCommandViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

