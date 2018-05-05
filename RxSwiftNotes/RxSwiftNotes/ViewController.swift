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
    
}

let hoge = Hoge()
let disposable = hoge.event?.subscribe(
    onNext: {value in
        print("hiya")
},
    onError: {error in
        print("error")
}, onCompleted: {
    
})
