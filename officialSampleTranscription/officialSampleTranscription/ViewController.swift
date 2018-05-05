//
//  ViewController.swift
//  officialSampleTranscription
//
//  Created by 山口賢登 on 2018/05/04.
//  Copyright © 2018年 山口賢登. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let projectName = ["AddingNumbers", "SimpleValidation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = projectName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc = UIViewController()
        switch indexPath.row + 1 {
        case 1:
            vc = UIStoryboard(name: "AddingNumbers", bundle: nil).instantiateInitialViewController()!
        case 2:
            vc = UIStoryboard(name: "SimpleValidation", bundle: nil).instantiateInitialViewController()!
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
