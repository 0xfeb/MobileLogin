//
//  CLMobileLogin.swift
//  MobileLogin
//
//  Created by 王渊鸥 on 2017/3/26.
//  Copyright © 2017年 王渊鸥. All rights reserved.
//

import UIKit

/**
登录过程分两部分, 根据DeviceID, Mobile, 从服务端获取验证结果.
如果找不到验证, 获取SMS验证码.
**/

public class CLMobileLogin {
	//MARK: env
	var coverImage: UIImage?
	var mobilePlaceholder: String = "手机号"
	var tintColor: UIColor = UIColor.darkGray
	var codePlaceholder: String = "验证码"
	var sendSmsText: String = "发送验证码"
	var remainSmsText: String = "剩余"
	var loginText: String = "登录/注册"
	
	//MARK: param
	var mobileText: String?
	
	//MARK: output
	var onSmsAction:(_ mobile:String, _ resp:(Bool)->())->() = { _ in }
	var onLoginAction:(_ mobile:String, _ code:String, _ resp:(Bool)->())->() = { _ in }
	var didLogin:()->() = { _ in }
}

public extension UIViewController {
	public func doLogin(login:CLMobileLogin) -> UIViewController {
		let bundle = Bundle(identifier: "com.mixbus.MobileLogin")
		let vc = CLMobileLoginVC(nibName: "CLMobileLoginVC", bundle: bundle)
		vc.loginValue = login
		vc.setup()
		self.present(vc, animated: false, completion: nil)
		return vc
	}
}
