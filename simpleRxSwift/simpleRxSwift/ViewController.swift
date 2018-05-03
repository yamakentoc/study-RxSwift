//
//  ViewController.swift
//  simpleRxSwift
//
//  Created by 山口賢登 on 2018/05/03.
//  Copyright © 2018年 山口賢登. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTextField.rx.text.orEmpty
            .distinctUntilChanged()//重複を避ける
            .subscribe(onNext: {[unowned self] text in//inputTextFieldが変更されると呼ばれる
                self.outputLabel.text = text
            })
            .disposed(by: self.disposeBag)//講読を解除
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
