//
//  ViewController.swift
//  VariousInput
//
//  Created by 山口賢登 on 2018/08/05.
//  Copyright © 2018 山口賢登. All rights reserved.
//

//このコードは、こちらのコードを写経しています。
//https://qiita.com/fumiyasac@github/items/90d1ebaa0cd8c4558d96

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var freeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var greetingButtons: [UIButton]!
    
    var lastSelectedGreeting: Variable<String> = Variable("こんにちは")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nameTextFieldを観測対象に
        let nameObservable: Observable<String?> = nameTextField.rx.text.asObservable()
        //freeTextFieldを観測対象に
        let freeObservable: Observable<String?> = freeTextField.rx.text.asObservable()
        //combineLatest: nameTextFieldとfreeTextFieldの直近の最新値同士を結合する
        let freewordWidtNameObservable: Observable<String?> = Observable.combineLatest(nameObservable, freeObservable) { (string1: String?, string2: String?) in
            return string1! + string2!
        }
        
    }


}

