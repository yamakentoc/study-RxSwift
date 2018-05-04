//
//  AddingNumbersViewController.swift
//  officialSampleTranscription
//
//  Created by 山口賢登 on 2018/05/04.
//  Copyright © 2018年 山口賢登. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AddingNumbersViewController: UIViewController {
    
    @IBOutlet weak var number1TextField: UITextField!
    @IBOutlet weak var number2TextField: UITextField!
    @IBOutlet weak var number3TextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
     let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //combineLatest 複数の値の変更をまとめて監視して同じ処理をする
        Observable.combineLatest(number1TextField.rx.text.orEmpty, number2TextField.rx.text.orEmpty, number3TextField.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }//それぞれを文字型に変換
            .bind(to: resultLabel.rx.text)//ObservableとUI部品のプロパティをバインド(結ぶ)
            .disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
