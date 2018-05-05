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


