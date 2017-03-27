//
//  CLMobileLoginVC.swift
//  MobileLogin
//
//  Created by 王渊鸥 on 2017/3/26.
//  Copyright © 2017年 王渊鸥. All rights reserved.
//

import UIKit
import Coastline

class CLMobileLoginVC: UIViewController {
	var loginValue:CLMobileLogin?

	@IBOutlet weak var keyboardHeight: NSLayoutConstraint!
	
	@IBOutlet weak var mobileText: UITextField!
	@IBOutlet weak var codeText: UITextField!
	@IBOutlet weak var sendSmsButton: UIButton!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var signImage: UIImageView!
	
	var showHandle:NSObject?
	var hideHandle:NSObject?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		showHandle = NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardDidShow, object: self, queue: OperationQueue.main) { [weak self] (noti) in
			if let value = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
				let rect = value.cgRectValue
				UIView.animate(withDuration: 0.2, animations: {
					self?.keyboardHeight.constant =  rect.size.height
					self?.view.setNeedsLayout()
				})
			}
		} as? NSObject
		
		hideHandle = NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardDidShow, object: self, queue: OperationQueue.main) { [weak self] (noti) in
			UIView.animate(withDuration: 0.2, animations: {
				self?.keyboardHeight.constant =  0
				self?.view.setNeedsLayout()
			})
		} as? NSObject
		
		setup()
    }
	
	deinit {
		if let showHandle = showHandle {
			NotificationCenter.default.removeObserver(showHandle)
		}
		
		if let hideHandle = hideHandle {
			NotificationCenter.default.removeObserver(hideHandle)
		}
	}
	
	func setup() {
		guard let lv = loginValue else { return }
		mobileText.placeholder = lv.mobilePlaceholder
		mobileText.text = lv.mobileText
		codeText.placeholder = lv.codePlaceholder
		mobileText.rightView = sendSmsButton
		sendSmsButton.setTitle(lv.sendSmsText, for: .normal)
		loginButton.setTitle(lv.loginText, for: .normal)
		loginButton.backgroundColor = lv.tintColor
		signImage.image = lv.coverImage
	}
	
	@IBAction func onClickSendSms(_ sender: UIButton) {
		guard let vc = loginValue else { return }
		guard let mobile = mobileText.text else {
			mobileText.becomeFirstResponder()
			return
		}
		vc.onSmsAction(mobile) { [weak self] (result) in
			if result {
				self?.view.startHud(title: "短信已经发送", timeout: 3.0)
			} else {
				self?.view.startHud(title: "无法发送, 请稍候", timeout: 3.0)
				self?.mobileText.becomeFirstResponder()
			}
		}
	}
	
	@IBAction func onClickLogin(_ sender: UIButton) {
		guard let vc = loginValue else { return }
		guard let mobile = mobileText.text, mobile.characters.count == 11 else {
			self.view.startHud(title: "请输入正确手机号", timeout: 2.0)
			mobileText.becomeFirstResponder()
			return
		}
		
		guard let code = codeText.text, code.characters.count >= 4 else {
			self.view.startHud(title: "请输入验证码", timeout: 2.0)
			codeText.becomeFirstResponder()
			return
		}
		
		vc.onLoginAction(mobile, code) { [weak self, weak vc] (result) in
			if result {
				self?.dismiss(animated: false, completion: nil)
				vc?.didLogin()
			} else {
				self?.view.startHud(title: "登录错误, 请稍候再试", timeout: 3.0)
			}
		}
	}
	
}
