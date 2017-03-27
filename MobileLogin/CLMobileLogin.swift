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
	public var coverImage: UIImage?
	public var mobilePlaceholder: String = "手机号"
	public var tintColor: UIColor = UIColor.darkGray
	public var codePlaceholder: String = "验证码"
	public var sendSmsText: String = "发送验证码"
	public var remainSmsText: String = "剩余"
	public var loginText: String = "登录/注册"
	
	//MARK: param
	public var mobileText: String?
	
	//MARK: output
	public var onSmsAction:(_ mobile:String, _ resp:(Bool)->())->() = { _ in }
	public var onLoginAction:(_ mobile:String, _ code:String, _ resp:(Bool)->())->() = { _ in }
	public var didLogin:()->() = { _ in }
	
	public init(smsAction:@escaping (String, (Bool)->())->(), loginAction:@escaping (String, String, (Bool)->())->(), afterLogin:@escaping ()->()) {
		onSmsAction = smsAction
		onLoginAction = loginAction
		didLogin = afterLogin
	}
}

public extension UIViewController {
	public func doLogin(login:CLMobileLogin) -> UIViewController {
		let sb = Bundle(for: CLMobileLoginVC.self)
		let burl = sb.url(forResource: "MyFramework", withExtension: "bundle")!
		let bundle = Bundle(url: burl)
		let vc = CLMobileLoginVC(nibName: "CLMobileLoginVC", bundle: bundle)
		vc.loginValue = login
		self.present(vc, animated: false, completion: nil)
		return vc
	}
}
