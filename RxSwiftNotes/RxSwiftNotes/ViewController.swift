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
///BehaviorSubjectと違ってonError / onCompleted を明示的に発生させることはできないため、現在値取得で例外が発生することはない。
///bindTo   メソッドの引数に指定できるというメリットもある
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


///bindToを使うとsubscribeを使うより簡単にイベントをプロパティに接続できる
let presenter2 = Presenter2()

let disposable3 = presenter2.buttonHidden.subscribe(onNext: {[button] in
    button.isHidden = $0
})

let disposable4 = presenter2.buttonHidden.bind(to: button.rx.isHidden)


///map
///画面上でターゲット名が設定されてなければ開始ボタンを押せないとする
class Action {
    var targetName: Observable<String>!
}

class Presenter4 {
    let action = Action()
    var startButtonEnabled: Observable<Bool> {
        return action.targetName.map{ !$0.isEmpty }
    }
}


///filter
///指定条件がtrueになるイベントだけ通過させる
class Engine {//動作中かどうかを示すrunnningプロパティ
    var running: Observable<Bool>!
}
//これを「動作開始したことを通知してくれるイベント」に変換する
//filterでrunningがtrueに変化した時だけを抜き出し、true/falseを伝達する必要はないのでmapでVoidに変換する
let engine = Engine()
var startEvent: Observable<Void> {
    return engine.running.filter{ $0 }.map{ _ in () }
}


///take
///イベントを最初の指定した数だけ絞る。指定数に達した時点でonCompletedになる。
///上のengine.runningで最初に起動開始した時だけ何かを実行したいとする
//filterでtrueの時に絞って、takeで最初の1つだけ監視する
var startEvent2: Observable<Void> {
    return engine.running.filter{ $0 }.take(1).subscribe(onNext: { _ in }) as! Observable<Void>
}

///skip
///イベントの最初から指定個を無視する
///BehaviorSubjectの現在地を無視してPublishSubjectのように変化だけを監視したいとする
var startEvent3: Observable<Void> {
    return engine.running.skip(1).subscribe(onNext: { running in
        //running変化時の処理
    }) as! Observable<Void>
}


///merge
///2つの同じ型のイベントストリームを1つにまとめることができる
///それぞれ別のクラスが発生するエラーイベントをまとめて1つのエラーイベントにしたいとする
class Fuga {
    var errorEvent: Error!
}
class Piyo {
    var errorEvent: Error!
}
let fuga = Fuga()
let piyo = Piyo()
var errorEvent: Observable<Error> {
    return Observable.merge(fuga.errorEvent as! Observable<Error>, piyo.errorEvent as! Observable<Error>)
}
//これ合ってるのか微妙


///combineLatest
///直近の最新地同士を組み合わせたイベントを作る
///例えば現在地を通知するLocationMonitorクラスに現在地の緯度軽度を表すlocationプロパティがあるとするLatLonは緯度経度を表すクラス
///２つの Observable を combineLatest で合成しています。どちらかの Observable に変化があると、その変化値ともう一方の直近の値がクロージャに渡され、クロージャの戻り値がイベントとして流れる
class LocationMonitor {
    var location: Observable<LatLon> {
        return locationVar.asObservable()
    }
}

class Route {
    var goal: Observable<LatLon> {
        return goal.asObservable()
    }
}

var distance: Observable<Double> {
    return Observable.combineLatest(LocationMonitor.location, Route.goal) { location, goal in
        goal.distanceFrom(location)
    }
}


///sample
///Observableの値を発行するタイミングを、もう一方のObservableをトリガーにして決める場合に使う。
///例えば画面上にある部品が、押すと移動できるようになっているとする。移動中はpositionプロパティが位置を通知してくれるけど、指を話して位置が確定した時だけ教えてくれれば良い。
///sample の引数に渡すトリガーとして、pressed が false になったとき（指を離した時）を指定
///トリガー発生時に必ず値を通知して欲しい用途では使えない
element.position
    .sample(element.pressed.filter{ !$0 })//
    .subscribe(onNext: { position in
        //指を話して位置が決定した時に行う処理
    })
    .disposed(by: disposeBag)



///withLatestFrom
///あるObservableにもう一方のObservableの最新地を合成する
///ccombineLatestと違って、イベントの発行タイミングは最初のObservableの発行タイミングと同じ。
///単にそこにもう一方の最新値を組みああせるだけ。
///トリガーになるイベントのあたいも利用できて、値に変化がなくてもトリガー発生時に値を通知してくれるsampleの拡張版とも捉えれる
///例えばエラー発生時に発生したエラーとエラー発生時の現在地の緯度経度から、新たなエラーを生成して通知するObservableを作る
class Hoge3 {
    var errorEvent: Error!
}
let hoge3 = Hoge3()
var errorEvent2: Observable<Error> {
    return hoge3.errorEvent.withLatestFrom(LocationMonitor.location) { error, ocation in
       MyError.hogeError(error, location)
    }
}

//元のObservableのイベントを利用しないなら第二引数のクロージャは省略できる
//sampleだと値変化がないと通知してくれない困る！って時はこっちを使う
element.pressed
    .filter{ !$0 }
    .withLatestFrom(element.position)
    .subscribe(onNext: { position in
        //指を話して位置が決定した時に行う処理
    })
    .disposed(by: disposeBage)









