//
//  Default.swift
//  SuperGina
//
//  Created by huawenjie on 15/8/24.
//  Copyright (c) 2015年 anve. All rights reserved.
//

import Foundation

//根据不同环境变化账号和地址的数据 切换bundleid时需要修改1.CertName2.EaseMobAppKey3.个推appid等
//Product
//bug 当地址不对时，网页打不开。没有任何提示。可以用非公司网络 环境下用Development做测试看效果


var EnvironmentisDevelop = true
//Development
//0105get方法的使用
var BaseURL:String {
    get{
        return "https://app.ultimavip.cn" //"https://121.43.233.86:9911"//"https://app.ultimavip.cn" //
    }
}


let interfaceVersion = "/1.0"
let URLBasic = ""
let URLOrder = ""
let URLHowHow = ""
let URLHaiTao = ""
let URLToken = ""
let URLUC = ""
let EaseMobAppKey = "330108000146751#surftest"
var CertName = "companyPushForEaseMobDevelop"

//-------------------------------------

// app 唯一ID
let AppId = 980572392

let APP_URL = "https://itunes.apple.com/cn/app/shen-zhu-si-ren-zhu-li/id980572392?mt=8"
// 投诉电话号码
let AlertTel = "400-106-0015"

//图片文件夹名字
let FileofImage = "FileofImage"
//本地下载下来的广告页名字
let ADPageImageName = "adPageImageName"
//本地下载的加载页
let LoadingImageName = "LoadingImageName"



//通知名称
let PushADWeb = "PushADWeb"
let NotificationShowGetHongbaoView="ShowGetHongbaoView"
//播放新语音消息的时候通知其他cell不要再播放
let NotificationPlayVoice="PlayVoice"
//退出红包列表展示界面时，修改支付选择的红包
let NotificationChangeHongbaoid="ChangeHongbaoid"
//通知登陆界面消失，也就是说在非登陆状态下使用app需要登陆的功能时，弹出登陆界面。此时登陆成功需要将弹出的界面消失，就发送这个通知
let NotificationLoginViewDissmissSuccess="LoginViewDissmissSuccess"
//通知登陆界面消失，也就是说在非登陆状态下使用app需要登陆的功能时，弹出登陆界面。此时取消登陆则需要将弹出的界面取消
let NotificationLoginViewDissmissCancel="LoginViewDissmissCancel"
//在非会话界面收到消息
let NotificationGetMsgFromAssistant="GetMsgFromAssistan"

/**
* 本地存储的数据都用SG_开头
*/


//记录上一次Tel的key
let SG_LastTimeSignInPhoneNum = "SG_LastTimeSignInPhoneNum"
//记录上次登录的UserId
let UD_LastTimeLoginInUserId = "SG_LastTimeLoginInUserId"
//记录上一次登录方式 1.手机 2.微博，3.微信
let SG_LastLoginType = "SG_LastLoginType"
//记录是否已经设置过密码
let SG_LastIsHavePsw = "SG_IsHavePsw"
//记录绑定的手机
let SG_LastIsHavePhone = "SG_LastIsHavePhone"
//初始设备数据请求
let SG_FirstDeviceRequest = "SG_FirstDeviceRequest"
//configVersion
let SG_ConfigVersion = "SG_ConfigVersion"
//广告链接
let SG_ADUrl = "SG_ADUrl"
//用户声音开关
let isSilent = "isSilent"
//是否有新的发现
let SG_IsHaveNewDiscover = "SG_IsHaveNewDiscover"
//是否第一次点击crv
let SG_IsFirstTap = "SG_IsFirstTap"
/**
*  用户默认用户组,保存的群组string,使用时需要转化成model
*/
//私人助理,也就是该设备上最后一次使用用户所分配到的用户的组信息，下同
let DefaultGroupPrivate="DefaultGroupPrivate"
//海淘助理
let DefaultGroupHaiTao="DefaultGroupHaiTao"
//私人助理
let DefaultGroupHuli="DefaultGroupHuli"
//默认私人助理id,也就是该设备上最后一次使用用户所分配到的用户的私人助理id，下同
//let DefaultGroupIdPrivate="DefaultGroupIdPrivate"
////默认海淘助理id
//let DefaultGroupIdHaitao="DefaultGroupIdHaitao"
////默认护理助理id
//let DefaultGroupIdHuli="DefaultGroupIdHuli"




//是否是提交appStore版本
let SG_ISTestVersion = "SG_ISTestVersion"
/**
*  数据库
*/
//数据库命名
let SqlName = "SuperGina.sqlite"
//sourceDB 名字
let DBName = "address.db"
// 数据库保存首页icon表名
let DBTableHomePageIcon = "DBTableHomePageIcon"
//保存聊天记录的表名
let DBTableChatHistroy = "msg"
//orderId和msg uuid关系的关系表
let DBTableUuidAndOrderNo = "UuidAndOrderNo"
/**
*  upToken 七牛上传
*/
let SG_QiniuUpToken = "SG_QiniuUpToken"
let SG_QiniuUpTokenTime = "SG_QiniuUpTokenTime"
//
let UpLoadImageLimitSize: Int = 1024*1024
let UpLoadHeadImageLimitSize: Int = 1024 * 64
// 七牛的Basic网址
let QiNiuBasicURL = "http://img1.ultimavip.cn/"  //"http://img1.pig.ai/"

//确定不变的相关账号的数据
//友盟
let UmengAppkey = "5591000e67e58eea62003d6a"

//个推
//神猪测试1app配置，已经通过
let GeTuiAppId = "RiY3RR477F9HVBrc7SxSz9"
let GeTuiAppKey = "10weCpNViA64sFr2KrlfM2"
let GeTuiAppSecret = "3SAFZON6dp5Kl3BwYSkkVA"
let GeTuiMasterSecret = "0tYPTyy0Vk5aw7Ih6OyaG5"


//let GeTuiAppId = "TnHKCInEGp87oBQvqgYJD4"
//let GeTuiAppKey = "Gi1rMRpHhd6YHThzC8BCe4"
//let GeTuiAppSecret = "3dZynw4vjw8H7oAUyFINH1"
//let GeTuiMasterSecret = "c2nJX78iBj5zCrpf7fFhO5"

//微信
let WXAppId = "wx7e04d3f99ff1963c"
let WXAppSecret = "de66fb65bd6dbe1ad5e7af6c798e4036"


// bugHD Crash 统计
let BUGTagsKey = "e1e3f62ab8eff713e04d94ed78198319"
//百度地图
let BaiduAk = "7NhRZ86mMa8AHFzWWxrlPfvR" //"rlQWjIziAambHgsic7T0LQ3U" //"7NhRZ86mMa8AHFzWWxrlPfvR"

//多盟广告
let PlaceMentID = "16TLuE4oAp8_ANUv26zv_4Dk"
let PublisherID = "56OJwiAIuN7TUw0JZP"
//多盟sign_key
let SingKey = "3d201651ed2774c8ea980668e491d3d8"

// 版本号和build号
let ApplicationVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
let ApplicationBuildVersion = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String

//ios版本
// 当前系统版本是否大于 8.0
let isIOSMoreThan8 = (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0
let SystemVersion = UIDevice.currentDevice().systemVersion._bridgeToObjectiveC().doubleValue

//默认用户头像地址
var DefaultHeadImgUser =  "headUser"//NSBundle.mainBundle().pathForResource("Assets/headUser", ofType: "png")
//默认用户头像地址
var DefaultHeadImgManager = "headManager"//NSBundle.mainBundle().pathForResource("Assets/headManager", ofType: "png")

//导航栏的颜色
//let NavColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
let BackGroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
let TitleColor = UIColor(red: 48.0/255.0, green: 50.0/255.0, blue: 62.0/255.0, alpha: 1.0)
let DetailTitleColor = UIColor(red: 131.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1.0)
let LineColor = UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0)
let TabBarSelectedColor = UIColor(red: 253.0/255.0, green: 167.0/255.0, blue: 31.0/255.0, alpha: 1.0)
let TabBarUnSelectedColor = UIColor(red: 167.0/255.0, green: 167.0/255.0, blue: 170.0/255.0, alpha: 1.0)
let ColorUnSelectedBtnCodeTitle = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0 , alpha: 1.0)
let ColorUnSelected = UIColor(red: 225.0/255.0, green: 220.0/255.0, blue: 153.0/255.0 , alpha: 1.0)
let ColorSelected = UIColor(red: 255.0/255.0, green: 168.0/255.0, blue: 0/255.0 , alpha: 1.0)
let CellBackgroundColor=UIColor(red: 232.0 / 255.0, green: 232.0 / 255.0, blue: 232.0 / 255.0, alpha: 1)
//主题色
let ColorTopic = UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 81.0/255.0, alpha: 1.0)
//导航栏颜色
let ColorNav =  UIColor(red: 33.0/255.0, green: 32.0/255.0, blue: 37.0/255.0, alpha: 1.0)
//消息的字体颜色
let ColorMsgGet = UIColor(red: 48.0/255.0, green: 50.0/255.0, blue: 62.0/255.0, alpha: 1.0)
let ColorMsgSend = UIColor.whiteColor()
//消息背景色
let ColorMsgGetBg = UIColor.whiteColor()
let ColorMsgSendBg = UIColor(red: 48.0/255.0, green: 50.0/255.0, blue: 62.0/255.0, alpha: 1.0)
//UIStoryboard中界面的标识
let UIStoryboardIDChat="Chat"
//通知名  
//start加载完成，依赖start的ui页面开始渲染。
let NotificationUIUpdate="NotificationUiUpdate"
//通知会话界面拉取聊天记录
let NotificationRCIMLoginSuccess="NotificationRCIMLoginSuccess"
//收到消息
let NotificationNewMsg="NotificationNewMsg"
//收到文字，订单消息
let NotificationNewMsgTxtOrder="NSNotificationNewMsgTxt"
//收到语音消息
let NotificationNewMsgVoice="NSNotificationNewMsgVoice"
//收到图片消息
let NotificationNewMsgImg="NSNotificationNewMsgImg"
/// 切换客服
let NotificationBulter="NotificationBulter"
/// 登出
let NotificationLoginOut="NotificationBulter"
//没有时间戳
let DefaultNoTime:Double=0
//通知文本信息
let PushContentImg="您有一条图片消息"
let PushContentVoice="您有一条语音消息"
let PushContentLocation="您有一条地址消息"
//图片资源地址
let UrlImgSource="http://img2.ultimavip.cn/"

//记录Token的key
let UD_LastTimeSignToken = "UD_LastTimeSignToken"
//记录上次登录的UserId
let UD_LastTimeUserId = "SG_LastTimeLoginInUserId"
//按钮可点击颜色
let ColorBtnCanSelect = UIColor(hexString: "#C1A96B")
//按钮不可点击颜色
let ColorBtnCanUnSelect = UIColor.lightGrayColor()
//消息文本边距
let  MsgTxtUIEdgeInsetsMakeT:CGFloat=2
let  MsgTxtUIEdgeInsetsMakeL:CGFloat=10
let  MsgTxtUIEdgeInsetsMakeB:CGFloat=5
let  MsgTxtUIEdgeInsetsMakeR:CGFloat=15
//服务器消息类型
enum MsgTypeInTxtExtra:Int{
    case  BulterChange = 2
    case  OrderMsg = 50
}

/// 订单列表
let DefaultTargetList="DefaultTargetList"
/// 融云key
let RCIMAppKey="k51hidwq18o0b"
//请求网路错误
/// 该卡当前已有用户使用
let RequestErrCodeAlreadyLogin=1018
//  请登录
let RequestErrCodeLoginPlease=1002
//  登录过期，请重新登录
let RequestErrCodeLoginExpire=1013
//用户不存在
let RequestErrCodeNoUser=1014
/// 登陆需要验证码
let RequestErrNeedCode=1022
/// 请先激活卡
let RequestErrUnActive=1006