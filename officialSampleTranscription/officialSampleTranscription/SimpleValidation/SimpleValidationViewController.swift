//
//  SimpleValidationViewController.swift
//  officialSampleTranscription
//
//  Created by 山口賢登 on 2018/05/04.
//  Copyright © 2018年 山口賢登. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleValidationViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    let disposeBag = DisposeBag()
    
    var minimalUsernameLength = 5
    var minimalPasswordLength = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameValidOutlet.text = "ユーザーネームは最低 \(minimalUsernameLength) 文字必要です"
        passwordValidOutlet.text = "パスワードば最低 \(minimalPasswordLength) 文字必要です"
        
        let usernameValid = usernameTextField.rx.text.orEmpty
            .map{ $0.count >= self.minimalUsernameLength }
            .share(replay: 1)//処理を1回にする(多重処理を防ぐ)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map{ $0.count >= self.minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        usernameValid// パスワードフィールドの検証が真の時に, 有効になる
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doSomethingOutlet.rx.tap
            .subscribe(onNext:{ [weak self] _ in
                self?.showAlert()
                
            })
            .disposed(by: disposeBag)
        
        
        
    }

    func showAlert() {
        let alertView = UIAlertView(
        title: "RxSample",
        message: "good",
        delegate: nil,
        cancelButtonTitle: "OK")
        alertView.show()
    }
}
