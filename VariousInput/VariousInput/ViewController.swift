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
    
    //segmentedControlに対応する値の定義
    enum State: Int {
        case useButtons   //あいさつの始まり選択
        case useTextField //自由入力にする
    }
    
    let disposeBag = DisposeBag()
    //初期値の設定
    var lastSelectedGreeting: Variable<String> = Variable("こんにちは")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservable()
    }
    
    func addObservable() {
        //nameTextFieldを観測対象に
        let nameObservable: Observable<String?> = nameTextField.rx.text.asObservable()
        //freeTextFieldを観測対象に
        let freeObservable: Observable<String?> = freeTextField.rx.text.asObservable()
        //combineLatest: nameTextFieldとfreeTextFieldの直近の最新値同士を結合する
        let freewordWidtNameObservable: Observable<String?> = Observable.combineLatest(nameObservable, freeObservable) { (string1: String?, string2: String?) in
            return string1! + string2!
        }
        
        //イベントのプロパティ接続をする
        freeObservable
            .bind(to: greetingLabel.rx.text)
            .disposed(by: disposeBag)
        
        //SegmentedControlに値変化の値変化を観測対象に
        let segmentedControlObservable: Observable<Int> = stateSegmentedControl.rx.value.asObservable()
        
        //SegmentedControlの値の変化を検知したらその状態に対応するenumの値を返す
        //map 別の要素に変換する *IntからStateへ変換
        let stateObservable: Observable<State> = segmentedControlObservable.map {
            (selectedIndex: Int) -> State in
            return State(rawValue: selectedIndex)!
        }
        
        //enumの値の変化を検知して、テキストフィールドが編集を受け付けるかを返す
        //mapはStateからBoolへ変換している
        let greetingTextFieldEnabledObservable: Observable<Bool> = stateObservable.map {
            (state: State) -> Bool in
            return state == .useTextField
        }
        
        //イベントのプロパティを接続
        greetingTextFieldEnabledObservable
            .bind(to: freeTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //テキストフィールドが編集を受け付ける状態かを検知して、ボタン部分が選択可能かを返す
        //map BoolからBoolへ変換
        let buttonsEnabledObservable: Observable<Bool> = greetingTextFieldEnabledObservable.map {
            (greetingEnabled: Bool) -> Bool in
            return !greetingEnabled
        }
        
        //greetingButtonに関する処理
        greetingButtons.forEach { button in
            buttonsEnabledObservable
                .bind(to: button.rx.isEnabled)
                .disposed(by: disposeBag)
            
        //lastSelectedGreetingにボタンのタイトル名を返す
            button.rx.tap.subscribe(onNext: { (nothing: Void) in
                self.lastSelectedGreeting.value = button.currentTitle!
            }).disposed(by: disposeBag)
            
            
        }
        
        
    }
}

