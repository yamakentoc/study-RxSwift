//
//  ViewController.swift
//  RxSwiftNotes
//
//  Created by 山口賢登 on 2018/05/05.
//  Copyright © 2018年 山口賢登. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


class Hoge {
    var event: Observable<Int>?
    ///Subjectでイベントを発生させる。
    ///1番基本的なSubjectがPublishSubject
    private let eventSubject = PublishSubject<Int>()
    var event2: Observable<Int> { return eventSubject }
    
    func doSomething() {
        eventSubject.onNext(1)
    }
    
}


let hoge = Hoge()
let disposeBag = DisposeBag()
///Observableでイベントを受け取る
let disposable = hoge.event?.subscribe(//購読開始
    onNext: {value in
    //通常イベント発生時の処理
    },onError: {error in
    print("error")//エラー発生時の処理
    }, onCompleted: {
    //完了時の処理
    })
    .disposed(by: disposeBag)//購読完了



///BehaviorSubject  現在地を取得できる。 ただしVariableの方が有能。
///今の状態を反映した上で変化があったらそれを反映するという動作が実現できる
class Presenter {
    private let buttonHiddenSubject = BehaviorSubject(value: false)
    var buttonHidden: Observable<Bool> { return buttonHiddenSubject }
 
    func start() {
        buttonHiddenSubject.onNext(true)
    }
    
    func stop() {
        buttonHiddenSubject.onNext(false)
    }
}

let button = UIButton()
let presenter = Presenter()
let disposable2 = presenter.buttonHidden.subscribe(onNext: {[button] in
    button.isHidden = $0
})
.disposed(by: disposeBag)


/// Variable  BehaviorSubjectからObservableを取り除いたもの
///BehaviorSubject と違ってonError / onCompleted を明示的に発生させることはできないため、現在値取得で例外が発生することはない。
///bindTo メソッドの引数に指定できるというメリットもある
class Presenter2 {
    private let buttonHiddenVar = Variable(false)
    var buttonHidden: Observable<Bool> { return buttonHiddenVar.asObservable() }
    
    func start() {
        buttonHiddenVar.value = true
    }
    
    func stop() {
        buttonHiddenVar.value = false
    }
}

class Config {
    private let disposable: Disposable
    let optionButtonEnabled = Variable(false)

    init() {
        disposable = optionButtonEnabled.asObservable()
            .subscribe(onNext: { newValue in
                // 値が設定されたときの処理
        })
    }
    deinit {
        disposable.dispose()
    }
}
