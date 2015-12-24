//
//  inputVc.swift
//
//
//  Created by ai966669 on 15/9/1.
//
//

import UIKit
protocol InputVcDelegate:NSObjectProtocol{
    func sendMsg(msg:String)
    func heightOfInputNeedToChange(heightNew:CGFloat)
    func finishImagesPick(images:NSArray)
    func finishVoice(infosVoice:NSArray)
    func presentMapVC()
    func showUseIntroduce()
    func goLastMsg()
}
enum  StatusOfKeyboard {
    case Emoji
    case Recent
    case Text
    case None
    case Voice
    case MoreAction
    case MsgWant
    case TypeOrder
}
class InputV: UIView {
    var firstIsStatusOfKeyboard = false
    private let emojiArray = [
        [
            "😀","😁","😂","😃","😄","😅","😆","😇",
            "😈","👿","😉","😊","☺️","😋","😌","😍",
            "😎","😏","😐","😑","😒","😓","😔","@"
        ],
        [
            "😕","😖","😗","😘","😙",
            "😚","😛","😜","😝","😞",
            "😟","😠","😡","😢","😣",
            "😤","😥","😦","😧","😨",
            "😩","😪","😫","@"]
        ,
        [
            "😬","😭","😮","😯","😰",
            "😱","😲","😳","😴","😵",
            "😶","😷","👦","👧","👨",
            "👩","👮","👼","🎅","👻",
            "💩","👽","💏","@"],
        [
            "👏","👍","👎","👌","✌️",
            "👊","✊","💪","👐","🙏",
            "🌷","🌹","🌻","🐭","🐯",
            "🐰","🐘","🐱","🐴","🐑",
            "🐓","🐫","🐷","@"],
        [
            "🐶","🐼","🐵","🐲","🐠",
            "🐄","🐝","🐞","⚡","🌙",
            "☀️","💦","☔","🌚","🌝",
            "🍎","🍉","🍌","🍇","🍗",
            "🍚","🍵","🍻","@"],
        [
            "🎂","🎁","🎉","❤️","💔",
            "💘","🚦","🚕","🚊","✈️",
            "💰","💊","💣","🔫","㊗️",
            "🚫","🔞","📢","🚅","🚧",
            "🚲","🏥","🏢","@"],
        
        ["🏡","📬","⚽","🏀","✅","❌","⚠️","▶️",
            "🔵","❔","❕","","","","","",
            "","","","","","","","@"],
    ]
    
    @IBOutlet var txtViewOfMsg: UITextView!
    @IBOutlet var btnOfChangingMsgStyle: UIButton!
    @IBOutlet var btnOfShowEmoji: UIButton!
    @IBOutlet var btnOfMoreAction: UIButton!
    @IBOutlet var btnOfVoice: UIButton!
    @IBOutlet var btnOfSend: UIButton!
    @IBOutlet var viewUnderNSLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var viewUnder: UIView!
    var aVolView:VolView!
    var mySelf = self
    var oneRecordAndPlay:RecordAndPlay!
    var voiceMsgAvailable: Bool = true
    var voiceStart=false
    var heightOfUnderView: CGFloat = 0
//    该view的高度
    var heightOfView:CGFloat!
    var heightOfKeyBoard:CGFloat!
    var clvOfMenu: UICollectionView!
    var clvOfKeyBoard : UICollectionView!
    var clvOfRecent : UICollectionView!
    var clvOfMoreAction : UICollectionView!
    var clvMsgWantSend : UICollectionView!
    var pageControl : UIPageControl!
    weak var oneInputVcDelegate:InputVcDelegate?
    var imagenameCellInClvOfMoreAction:[String]=[]
    var titleCellInClvOfMoreAction:[String]=[]
    var emojiRecent :[ String ] = []
    var assetPicker : AssetPicker!
    var titleCellInClvOfMenu:[String]=[]
    private let heightOfEmoji:CGFloat	= 40
    private let sendButtonWidth:CGFloat		= 75
    private let recentButtonWidth:CGFloat	= 55
    private let widthOfEmoji:CGFloat   = 55
    private let nbOfSecationEmoji:Int = 3
    private let nbOfIndexOfEveryPageEmoji:Int = 8
    private let nbOfPageEmoji:Int = 7
    //    关于emoji表情的约束参数
    private let clvOfKeyBoardNSLayoutConstraintToL:CGFloat = 0
    private let clvOfKeyBoardNSLayoutConstraintToB:CGFloat = 25
    private let clvOfKeyBoardNSLayoutConstraintToR:CGFloat = 0
    private let clvOfKeyBoardNSLayoutConstraintToT:CGFloat = 15
    //   关于pageControl表情的约束参数
    private let pageControlNSLayoutConstraintHeight:CGFloat = 10
    private let pageControlNSLayoutConstraintToT:CGFloat = 20
    //    clvOfKeyBoard的高度，为了和之前的heightOfKeyBoard区别所以取名这个，后期取名需要重新设置
    private let heightOfKeyBoardReal:CGFloat=150
    //    clvOfMoreAction的高度，为了和之前的heightOfKeyBoard区别所以取名这个，后期取名需要重新设置
    private let heightOfClvOfMoreAction:CGFloat=200
    //  输入框的宽度 114其他控件以及间隙占去的空间
    private var widthOfTxtViewOfMsg:CGFloat = UIScreen.mainScreen().applicationFrame.width - 120
    var isText:Bool=true
    var effectView: UIView?
    //ViewUnder比消息输入框高出的高度
    var heightThanViewUnder:CGFloat=15
    // 录音图标显示类型  true 是音量图标 false 想取消图标
    var isVolImg=true
    var statusOfKeyboard = StatusOfKeyboard.None{
        didSet {
//            点击时除了none状态，其他都让 txtViewOfMsg成为第一响应者
//            if statusOfKeyboard != StatusOfKeyboard.None{        //不知道键盘响应者的情况下让键盘消失的方法
////                UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
//                txtViewOfMsg.becomeFirstResponder()
//            }

            switch statusOfKeyboard{
            case .Text:
                btnOfVoice.hidden=true
                btnOfChangingMsgStyle.setImage(UIImage(named: "record"), forState: UIControlState.Normal)
                btnOfShowEmoji.setImage(UIImage(named: "emoji"), forState: UIControlState.Normal)
                if (oneInputVcDelegate != nil){
                    oneInputVcDelegate!.goLastMsg()
                }
                //因为要获得键盘高度，暂时还是用keyboardMsgWillShow函数处理
            case .Voice:
                btnOfChangingMsgStyle.setImage(UIImage(named: "keyboard"), forState: UIControlState.Normal)
                btnOfShowEmoji.setImage(UIImage(named: "emoji"), forState: UIControlState.Normal)
                btnOfVoice.hidden=false
                txtViewOfMsg.resignFirstResponder()
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    var boundOfView = self.superview!.bounds
                    boundOfView.origin.y = 0
                    self.superview!.bounds = boundOfView
                })

            case .None:
                btnOfChangingMsgStyle.setImage(UIImage(named: "record"), forState: UIControlState.Normal)
                btnOfShowEmoji.setImage(UIImage(named: "emoji"), forState: UIControlState.Normal)
                btnOfVoice.hidden=true
                txtViewOfMsg.resignFirstResponder()
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    guard var boundOfView = self.superview?.bounds else{
                        return
                    }
                    boundOfView.origin.y = 0
                    self.superview!.bounds = boundOfView
                })
            case .Recent:
                btnOfChangingMsgStyle.setImage(UIImage(named: "record"), forState: UIControlState.Normal)
                btnOfShowEmoji.setImage(UIImage(named: "keyboard"), forState: UIControlState.Normal)
                clvOfRecent.hidden=false
                //                viewBot.hidden=false
                clvOfKeyBoard.hidden=true
                pageControl.hidden=true
                clvOfMoreAction.hidden = true
                btnOfSend.hidden=false
                clvOfMenu.hidden=false
                btnOfVoice.hidden=true
                clvMsgWantSend.hidden=true
                emojiRecent[23]="@"
                clvOfRecent.reloadData()
            case .Emoji:
                NSLayoutConstraintPageControlToTop.constant=20
                pageControl.numberOfPages=nbOfPageEmoji
                btnOfChangingMsgStyle.setImage(UIImage(named: "record"), forState: UIControlState.Normal)
                btnOfShowEmoji.setImage(UIImage(named: "keyboard"), forState: UIControlState.Normal)
                clvOfRecent.hidden=true
                //                viewBot.hidden=true
                clvOfMoreAction.hidden = true
                clvOfKeyBoard.hidden=false
                pageControl.hidden=false
                btnOfSend.hidden=false
                clvOfMenu.hidden=false
                btnOfVoice.hidden=true
                clvMsgWantSend.hidden=true
                txtViewOfMsg.resignFirstResponder()
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    var boundOfView = self.superview!.bounds
                    let offsetY:CGFloat = self.heightOfView - self.heightOfUnderView
                    boundOfView.origin.y = offsetY
                    self.superview!.bounds = boundOfView
                })
                oneInputVcDelegate!.goLastMsg()
            case .MoreAction:
                btnOfChangingMsgStyle.setImage(UIImage(named: "record"), forState: UIControlState.Normal)
                btnOfShowEmoji.setImage(UIImage(named: "emoji"), forState: UIControlState.Normal)
                clvOfRecent.hidden=true
                //                viewBot.hidden=true
                clvOfMoreAction.hidden = false
                clvOfKeyBoard.hidden=true
                pageControl.hidden=true
                btnOfSend.hidden=true
                clvOfMenu.hidden=true
                clvMsgWantSend.hidden=true
                txtViewOfMsg.resignFirstResponder()
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    var boundOfView = self.superview!.bounds
                    let offsetY:CGFloat = self.heightOfView-self.heightOfUnderView
                    boundOfView.origin.y = offsetY
                    self.superview!.bounds = boundOfView
                })
                oneInputVcDelegate!.goLastMsg()
            case .MsgWant:
                NSLayoutConstraintPageControlToTop.constant=40
                pageControl.numberOfPages=3
                btnOfChangingMsgStyle.setImage(UIImage(named: "record"), forState: UIControlState.Normal)
                btnOfShowEmoji.setImage(UIImage(named: "emoji"), forState: UIControlState.Normal)
                clvOfRecent.hidden=true
                clvOfMoreAction.hidden = true
                clvOfKeyBoard.hidden=true
                pageControl.hidden=false
                btnOfSend.hidden=true
                clvOfMenu.hidden=true
                clvMsgWantSend.hidden=false
                txtViewOfMsg.resignFirstResponder()
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    var boundOfView = self.superview!.bounds
                    let offsetY:CGFloat = self.heightOfView-self.heightOfUnderView
                    boundOfView.origin.y = offsetY
                    self.superview!.bounds = boundOfView
                })
                oneInputVcDelegate!.goLastMsg()
            default:
                break
                //                println()
            }
            
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.btnOfVoice.hidden = isText
        
        backgroundColor = UIColor.clearColor()
        if #available(iOS 8.0, *) {
            viewUnder.backgroundColor = UIColor.clearColor()
            let viewStyle = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            effectView = UIVisualEffectView(effect: viewStyle)
            effectView!.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, viewUnder.bounds.size.height)
            viewUnder.addSubview(effectView!)
            
            
        }else {
            viewUnder.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6)
        }
        initNotification()
        
        initData()
        
        initClv()

        initVolView()
        
        initLayout()
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "setStatusOfKeyboard", userInfo: nil, repeats: false)
    }
   

    func setStatusOfKeyboard(){
        if firstIsStatusOfKeyboard{
            txtViewOfMsg.becomeFirstResponder()
//            firstIsStatusOfKeyboard = nil
        }
    }
    func initLayout(){
        self.viewUnder.layer.borderWidth=0.5
        self.viewUnder.layer.borderColor=UIColor.lightGrayColor().CGColor
        self.txtViewOfMsg.layer.masksToBounds=true
        self.btnOfChangingMsgStyle.layer.masksToBounds=true
        self.txtViewOfMsg.layer.cornerRadius=4.0
        self.txtViewOfMsg.layer.borderWidth=0.5
        self.txtViewOfMsg.layer.borderColor=UIColor.lightGrayColor().CGColor
        self.btnOfVoice.layer.masksToBounds=true
        self.btnOfVoice.layer.cornerRadius=4.0
        self.btnOfVoice.layer.borderWidth=0.5
        self.btnOfVoice.layer.borderColor=UIColor.lightGrayColor().CGColor
    }
    func initData(){
        //初始化emojiRecent,使clvOfRecent有数据
        for _ in 0 ... nbOfIndexOfEveryPageEmoji*nbOfSecationEmoji-2
        {
            emojiRecent.append("")
        }
        emojiRecent.append("❌")
        assetPicker=AssetPicker()
        assetPicker.oneAssetPickerDelegate=self
        imagenameCellInClvOfMoreAction=["photo","","camera","","icon地址","","icon如何使用",""]
        titleCellInClvOfMoreAction=["相册","","拍照","","发送地址","","使用说明",""]
        titleCellInClvOfMenu=["最近","表情"]
        txtViewOfMsg.delegate=self
        //        txtViewOfMsg.showsHorizontalScrollIndicator=false
        //        txtViewOfMsg.showsHorizontalScrollIndicator=false
        //记录txtViewOfMsg的初始高度，之后所有高度变化（输入文字）都需要更新这个值
        heightOfUnderView=self.viewUnder.frame.height
        heightOfView = self.frame.height
    }
    
    func initClv(){
        initClvOfKeyBoard()
        initClvOfMenu()
        initClvOfRecent()
        initClvOfMoreAction()
        initClvMsgWantSend()
        initCell()
        initPageControl()
        initBtnOfVoice()

    }
    var aMMsgWantSendCollectionViewDelegateNzz=MMsgWantSendCollectionViewDelegateNzz()
    var msgs=["asdf","asdf","fffffasdffffffasdffffffasdffffffasdf","asdf","fffffasdf","asfffffasdffffffasdffffffasdfdf","asdf","asasdfjkjklkjlkljasdfdf","asdf","asdf","asasdfjkjklkjlkljasdfdf","asdf","asdf","asasdfjkjklkjlkljasdfdf","asdf","asdf","asasdfjkjklkjlkljasdfdf","asdf","asdf"]
    
    func initClvMsgWantSend(){
        
        let  aCustomLayoutNzz=CustomLayoutNzz()
        
        aMMsgWantSendCollectionViewDelegateNzz.calculate(CGSizeMake(UIScreen.mainScreen().bounds.size.width, 162), msgs:msgs)
        
        aCustomLayoutNzz.msgSizes=aMMsgWantSendCollectionViewDelegateNzz.msgSizes
        aCustomLayoutNzz.contentView=aMMsgWantSendCollectionViewDelegateNzz.contentView

        clvMsgWantSend = UICollectionView(frame: CGRectMake(0,0,0,0), collectionViewLayout: aCustomLayoutNzz)

        clvMsgWantSend.dataSource=self
        clvMsgWantSend.delegate=self
        clvMsgWantSend.bounces=false
        let flowLayoutClvOfKeyBoard = UICollectionViewFlowLayout()
        
        flowLayoutClvOfKeyBoard.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        clvMsgWantSend.collectionViewLayout=flowLayoutClvOfKeyBoard

        
        
        addSubview(clvMsgWantSend)
        clvMsgWantSend.translatesAutoresizingMaskIntoConstraints=false
        clvMsgWantSend.collectionViewLayout=aCustomLayoutNzz
        //增加下方emoji表情列表的autolayout约束
        addConstraint(NSLayoutConstraint(item: clvMsgWantSend, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: clvOfKeyBoardNSLayoutConstraintToL))
        
        addConstraint(NSLayoutConstraint(item: clvMsgWantSend, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: clvMsgWantSend, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant:-clvOfKeyBoardNSLayoutConstraintToR))
        
        addConstraint(NSLayoutConstraint(item: clvMsgWantSend, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: viewUnder, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: clvOfKeyBoardNSLayoutConstraintToT))
        
        clvMsgWantSend.showsHorizontalScrollIndicator = false
        
        clvMsgWantSend.pagingEnabled=true
        
        clvMsgWantSend.backgroundColor=UIColor.whiteColor()


    }
    func initBtnOfVoice(){
        if oneRecordAndPlay == nil{
            oneRecordAndPlay=RecordAndPlay()
            oneRecordAndPlay.initAudio()
        }
        btnOfVoice.addTarget(self, action: "startRecord", forControlEvents: UIControlEvents.TouchDown)
        btnOfVoice.addTarget(self, action: "stopRecord", forControlEvents: UIControlEvents.TouchUpInside)
        btnOfVoice.addTarget(self, action: "wantCancel", forControlEvents: UIControlEvents.TouchDragExit)
        btnOfVoice.addTarget(self, action: "finishCancel", forControlEvents: UIControlEvents.TouchDragEnter)
        btnOfVoice.addTarget(self, action: "cancelRecord", forControlEvents: UIControlEvents.TouchUpOutside)
    }
    var nstimerOfVolRecord:NSTimer?
    func initClvOfMoreAction(){
        
        let flowLayoutClvOfKeyBoard = UICollectionViewFlowLayout()
        
        flowLayoutClvOfKeyBoard.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        clvOfMoreAction = UICollectionView(frame: CGRectMake(0, 0, 100, 100), collectionViewLayout:
            flowLayoutClvOfKeyBoard)
        
        //约束添加需要在页面已经被对象化
        addSubview(clvOfMoreAction)
        
        clvOfMoreAction.translatesAutoresizingMaskIntoConstraints=false
        
        addConstraint(NSLayoutConstraint(item: clvOfMoreAction, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: clvOfKeyBoardNSLayoutConstraintToL))
        
        addConstraint(NSLayoutConstraint(item: clvOfMoreAction, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: clvOfMoreAction, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant:-clvOfKeyBoardNSLayoutConstraintToR))
        
        addConstraint(NSLayoutConstraint(item: clvOfMoreAction, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: viewUnder, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: clvOfKeyBoardNSLayoutConstraintToT))
        
        
        clvOfMoreAction.showsHorizontalScrollIndicator = false
        
        clvOfMoreAction.backgroundColor=UIColor.whiteColor()
        
        clvOfMoreAction.pagingEnabled=true
        
        clvOfMoreAction.delegate=self
        
        clvOfMoreAction.dataSource=self
        
        addSubview(clvOfMoreAction)
        
    }
    func initClvOfRecent(){
        
        let flowLayoutClvOfKeyBoard=UICollectionViewFlowLayout()
        
        flowLayoutClvOfKeyBoard.scrollDirection=UICollectionViewScrollDirection.Horizontal
        
        clvOfRecent = UICollectionView(frame: CGRectMake(0, 0, 100, 100), collectionViewLayout:
            flowLayoutClvOfKeyBoard)
        
        self.addSubview(clvOfRecent)
        
        clvOfRecent.translatesAutoresizingMaskIntoConstraints=false
        
        self.addConstraint(NSLayoutConstraint(item: clvOfRecent, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: clvOfRecent, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.btnOfVoice, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8))
        
        self.addConstraint(NSLayoutConstraint(item: clvOfRecent, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant:0))
        
        self.addConstraint(NSLayoutConstraint(item: clvOfRecent, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: btnOfSend, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -8))
        
        clvOfRecent.backgroundColor = UIColor.whiteColor()
        
        clvOfRecent.showsHorizontalScrollIndicator = false
        
        clvOfRecent.pagingEnabled=true
        
        clvOfRecent.delegate=self
        
        clvOfRecent.dataSource=self
        
    }
    
    private let MsgWantSendCollectionViewCellIdentifier="MsgWantSendCollectionViewCell"
    
    func initCell(){
        
        let uiNibColCell1InputVc=UINib(nibName: "ColCell1InputVc", bundle: NSBundle.mainBundle())
        
        clvOfKeyBoard.registerNib(uiNibColCell1InputVc, forCellWithReuseIdentifier: "ColCell1InputVc")
        
        clvOfRecent.registerNib(uiNibColCell1InputVc, forCellWithReuseIdentifier: "ColCell1InputVc")
        
        clvOfMenu.registerNib(uiNibColCell1InputVc, forCellWithReuseIdentifier: "ColCell1InputVc")
        
        let uiNibColCell2InputVc=UINib(nibName: "ColCell2InputVc", bundle: NSBundle.mainBundle())
        
        clvOfMoreAction.registerNib(uiNibColCell2InputVc, forCellWithReuseIdentifier: "ColCell2InputVc")
        
        clvMsgWantSend.registerNib(UINib(nibName: "MsgWantSendCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: MsgWantSendCollectionViewCellIdentifier)
        
    }
    
    func initClvOfKeyBoard(){
        
        let flowLayoutClvOfKeyBoard = UICollectionViewFlowLayout()
        
        flowLayoutClvOfKeyBoard.scrollDirection=UICollectionViewScrollDirection.Horizontal
        
        clvOfKeyBoard = UICollectionView(frame: CGRectMake(0, 0, 100, 100), collectionViewLayout:
            flowLayoutClvOfKeyBoard)
        
        clvOfKeyBoard.translatesAutoresizingMaskIntoConstraints=false
        
        self.addSubview(clvOfKeyBoard)
        //增加下方emoji表情列表的autolayout约束
        self.addConstraint(NSLayoutConstraint(item: clvOfKeyBoard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: clvOfKeyBoardNSLayoutConstraintToL))
        
        self.addConstraint(NSLayoutConstraint(item: clvOfKeyBoard, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: btnOfSend, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -clvOfKeyBoardNSLayoutConstraintToB))
        
        
        self.addConstraint(NSLayoutConstraint(item: clvOfKeyBoard, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant:-clvOfKeyBoardNSLayoutConstraintToR))
        
        self.addConstraint(NSLayoutConstraint(item: clvOfKeyBoard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.viewUnder, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: clvOfKeyBoardNSLayoutConstraintToT))
        
        clvOfKeyBoard.showsHorizontalScrollIndicator = false
        
        clvOfKeyBoard.pagingEnabled=true
        
        clvOfKeyBoard.backgroundColor=UIColor.whiteColor()
        
        clvOfKeyBoard.delegate=self
        
        clvOfKeyBoard.dataSource=self
        
    }
    func initClvOfMenu(){
        
        let flowLayoutClvOfKeyBoard=UICollectionViewFlowLayout()
        
        flowLayoutClvOfKeyBoard.scrollDirection=UICollectionViewScrollDirection.Horizontal
        
        clvOfMenu = UICollectionView(frame: CGRectMake(0, 0, 100, 100), collectionViewLayout:
            flowLayoutClvOfKeyBoard)
        
        self.addSubview(clvOfMenu)
        
        clvOfMenu.translatesAutoresizingMaskIntoConstraints=false
        
        clvOfMenu.showsHorizontalScrollIndicator = false
        
        self.addConstraint(NSLayoutConstraint(item: clvOfMenu, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: clvOfMenu, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: clvOfMenu, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: btnOfSend, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: clvOfMenu, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: btnOfSend, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 2))
        
        clvOfMenu.delegate=self
        
        clvOfMenu.dataSource=self
        
        clvOfMenu.backgroundColor=UIColor.whiteColor()
        
        clvOfMenu.layer.masksToBounds=true
        
        clvOfMenu.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        clvOfMenu.layer.borderWidth=0.5
        
        btnOfSend.layer.masksToBounds=true
        
        btnOfSend.layer.borderWidth=0.5
        
        btnOfSend.layer.borderColor=UIColor.lightGrayColor().CGColor
        
    }
    var NSLayoutConstraintPageControlToTop:NSLayoutConstraint!
    func initPageControl(){
        
        pageControl = UIPageControl(frame: CGRectMake(0, 0, 100, 100))
        
        pageControl.translatesAutoresizingMaskIntoConstraints=false
        
//        pageControl.backgroundColor=UIColor.yellowColor()
        
        self.addSubview(pageControl)
        
        NSLayoutConstraintPageControlToTop=NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: clvOfKeyBoard, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: pageControlNSLayoutConstraintToT)
        
        self.addConstraint(NSLayoutConstraintPageControlToTop)
        
        self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: clvOfKeyBoard, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: clvOfKeyBoard, attribute: NSLayoutAttribute.Width, multiplier: 0.2, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: clvOfKeyBoard, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: pageControlNSLayoutConstraintHeight))
        
        pageControl.numberOfPages=nbOfPageEmoji
        
        pageControl.pageIndicatorTintColor=UIColor.lightGrayColor()
        
        pageControl.currentPageIndicatorTintColor=UIColor.grayColor()
        
        pageControl.addTarget(self, action: "pageChange", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    func initNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardTextWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChangeToSmall", name: UIKeyboardWillHideNotification, object: nil)
    }
    deinit {
        nstimerOfVolRecord?.invalidate()
        nstimerOfVolRecord = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    @IBAction func changingMsgStyle(){
        isText = !isText
        if isText{
            statusOfKeyboard = StatusOfKeyboard.Text
        }else{
            statusOfKeyboard = StatusOfKeyboard.Voice
        }
    }
    
    @IBAction func showEmoji(){
        if  statusOfKeyboard == StatusOfKeyboard.Emoji{
            txtViewOfMsg.becomeFirstResponder()
        }else{
            
            statusOfKeyboard = StatusOfKeyboard.Emoji
        }
    }
    
    @IBAction func showMoreAction(){
        if  statusOfKeyboard == StatusOfKeyboard.MoreAction{
            txtViewOfMsg.becomeFirstResponder()
        }else{
            statusOfKeyboard = StatusOfKeyboard.MoreAction
        }
    }
    @IBAction func sendInMenu(){
        self.sendMsg()
    }
    func sendMsg(){
        if txtViewOfMsg.text != ""{
            oneInputVcDelegate?.sendMsg(txtViewOfMsg.text)
            txtViewOfMsg.text = ""
            calumateAndUpdateUITxtViewOfMsg()
            //            heightOfUnderView = self.txtViewOfMsg.frame.height + heightThanViewUnder
            //            if effectView != nil {
            //                effectView!.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, heightOfUnderView)
            //
            //            }
            //            heightOfView = heightOfView + heightOfUnderView - self.viewUnder.frame.height
            //            Log("\(heightOfView)")
            //            viewUnderNSLayoutConstraint.constant = heightOfUnderView
            //            oneInputVcDelegate?.heightOfInputNeedToChange(heightOfUnderView)
        }else{
            SVProgressHUD.showInfoWithStatus("发送内容不能为空")
        }
    }
    func keyboardTextWillShow(aNSNotification:NSNotification){
//        if statusOfKeyboard == StatusOfKeyboard.Text{
        statusOfKeyboard = StatusOfKeyboard.Text
        if let userInfo = aNSNotification.userInfo {
            if let height = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.origin.y{
                //nzz此处高度第一次进入chatview时会,键盘出现4415高度！
                if height<1000{
                    //倪壮壮需要做 ios7.0手机查看是否有上弹效果
                    //UIView.animateWithDuration(2.5, animations: { () -> Void in
                    guard (self.superview != nil) else {
                        return
                    }
                    var boundOfView = self.superview!.bounds
                    let offsetY:CGFloat = boundOfView.size.height-height
                    heightOfKeyBoard=height
                    boundOfView.origin.y = offsetY
                    self.superview!.bounds = boundOfView
                    
                    //                })
                }
            }
        }
//        }
    }
    func keyboardChangeToSmall(){
        if statusOfKeyboard != StatusOfKeyboard.None && statusOfKeyboard != StatusOfKeyboard.Voice  && statusOfKeyboard != StatusOfKeyboard.MoreAction&&statusOfKeyboard != StatusOfKeyboard.Emoji {
            statusOfKeyboard = StatusOfKeyboard.None
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
let ColCell1InputVcIdentifier="ColCell1InputVc"
let ColCell2InputVcIdentifier="ColCell2InputVc"

extension InputV:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        if collectionView == clvOfKeyBoard{
            return nbOfPageEmoji * nbOfIndexOfEveryPageEmoji
        }else if collectionView == clvOfMenu {
            return 2
        }else if collectionView == clvOfRecent{
            return 8
        }else if collectionView == clvOfMoreAction{
            return 4
        }else if collectionView == clvMsgWantSend{
            return 1
        }
        else{
            return 0
        }
    }
  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clvOfKeyBoard{
            return 3
        }else if collectionView == clvOfMenu {
            return 1
        }else if collectionView == clvOfRecent{
            return 3
        }else if collectionView == clvOfMoreAction{
            return 2
        }else if collectionView == clvMsgWantSend{
            return msgs.count
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == clvOfKeyBoard{
            //NZZ tom：多屏适配估计会有问题
            return  CGSizeMake((frame.width-clvOfKeyBoardNSLayoutConstraintToL-clvOfKeyBoardNSLayoutConstraintToR)/8, heightOfKeyBoardReal/4)
        }else if collectionView == clvOfMenu {
            return CGSizeMake(60, clvOfMenu.frame.height)
        }else if collectionView == clvOfRecent{
            return CGSizeMake((frame.width-clvOfKeyBoardNSLayoutConstraintToL-clvOfKeyBoardNSLayoutConstraintToR)/8, (heightOfKeyBoardReal+pageControlNSLayoutConstraintHeight+pageControlNSLayoutConstraintToT)/4)
        }else if collectionView == clvOfMoreAction{
            return CGSizeMake((frame.width-clvOfKeyBoardNSLayoutConstraintToL-clvOfKeyBoardNSLayoutConstraintToR)/4, heightOfClvOfMoreAction/2.2)
        }else{
            return CGSizeMake(0,0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        
        return 0
    }
    
    func  collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        if (section + 1)%8 == 0 {
            return 16
        }
        return  0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == clvOfKeyBoard{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ColCell1InputVcIdentifier, forIndexPath: indexPath) as! ColCell1InputVc
            if getEmojiInAll(indexPath.section, row: indexPath.row) != "@" {
                cell.lbOfEmoji.text =  getEmojiInAll(indexPath.section,row: indexPath.row)
                cell.imgv.hidden = true
            }else {
                //nzzTom
                cell.lbOfEmoji.text =  ""
                cell.imgv.hidden = false
                cell.imgv.image=UIImage(named: "emojiDelete")
            }
            return cell
        }else if collectionView == clvOfMenu {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ColCell1InputVcIdentifier, forIndexPath: indexPath) as! ColCell1InputVc
            cell.lbOfEmoji.text =  titleCellInClvOfMenu[indexPath.section]
            cell.lbOfEmoji.layer.masksToBounds=true
            cell.lbOfEmoji.layer.borderWidth=1
            if indexPath.section == 0{
                cell.lbOfEmoji.font=UIFont.systemFontOfSize(12.0)
                cell.lbOfEmoji.backgroundColor=UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
                cell.lbOfEmoji.layer.borderColor=UIColor(red: 208/255.0, green: 208/255.0, blue: 208/255.0, alpha: 1).CGColor
                cell.lbOfEmoji.textColor = UIColor.lightGrayColor()
            }else{
                cell.lbOfEmoji.font=UIFont.systemFontOfSize(17.0)
                cell.lbOfEmoji.backgroundColor=UIColor(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1)
                cell.lbOfEmoji.layer.borderColor=UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1).CGColor
                cell.lbOfEmoji.textColor = ColorSelected
            }
            cell.backgroundColor=UIColor.yellowColor()
            return cell
        }else if collectionView == clvOfRecent{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ColCell1InputVcIdentifier, forIndexPath: indexPath) as! ColCell1InputVc
            cell.lbOfEmoji.text =  emojiRecent[ indexPath.section + indexPath.row * 8]
            if cell.lbOfEmoji.text != "@" {
                cell.imgv.hidden = true
            }else {
                //nzzTom
                cell.lbOfEmoji.text =  ""
                cell.imgv.hidden = false
            }
            return cell
        }else if collectionView == clvOfMoreAction{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ColCell2InputVcIdentifier, forIndexPath: indexPath) as! ColCell2InputVc
            cell.lblOfMoreAction.text = titleCellInClvOfMoreAction[indexPath.row + indexPath.section*2]
            cell.imgOfMoreAction.image = UIImage(named: imagenameCellInClvOfMoreAction[indexPath.row + indexPath.section*2])
            return cell
        }else if collectionView == clvMsgWantSend{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MsgWantSendCollectionViewCellIdentifier, forIndexPath: indexPath) as! MsgWantSendCollectionViewCell
            cell.lblTxt.text = msgs[indexPath.row]
            cell.layer.borderColor=UIColor.redColor().CGColor
            cell.layer.borderWidth=1
            return cell
        }else{
            return ColCell1InputVc()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        if collectionView == clvOfKeyBoard{
            let emojiChosing = getEmojiInAll(indexPath.section, row: indexPath.row)
            if emojiChosing != "@"{
                for i in 0 ... emojiRecent.count-1{
                    if emojiChosing == emojiRecent[i] {
                        emojiRecent.removeAtIndex(i)
                        emojiRecent.insert(emojiChosing, atIndex: 0)
                        break
                    }else if i == emojiRecent.count-1 {
                        emojiRecent.insert(emojiChosing, atIndex: 0)
                    }
                }
            }
            //判断点击了键盘上的什么内容
            if (indexPath.section+1)%8 == 0 && indexPath.row == 2 {
                txtViewOfMsg.text =  self.reduceOne(txtViewOfMsg.text)
            }else{
                txtViewOfMsg.text = txtViewOfMsg.text + emojiChosing
            }
            calumateAndUpdateUITxtViewOfMsg()
        }else if collectionView == clvOfMenu {
            let cell =  collectionView.cellForItemAtIndexPath(indexPath) as! ColCell1InputVc
            cell.lbOfEmoji.font=UIFont.systemFontOfSize(17.0)
            cell.lbOfEmoji.textColor = ColorSelected
            cell.lbOfEmoji.backgroundColor=UIColor(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1)
            cell.lbOfEmoji.layer.borderColor=UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1).CGColor
            if indexPath.section == 0{
                let cell1 =  collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! ColCell1InputVc
                cell1.lbOfEmoji.font=UIFont.systemFontOfSize(12.0)
                cell1.lbOfEmoji.backgroundColor=UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
                cell1.lbOfEmoji.layer.borderColor=UIColor(red: 208/255.0, green: 208/255.0, blue: 208/255.0, alpha: 1).CGColor
                cell1.lbOfEmoji.textColor = UIColor.lightGrayColor()
                statusOfKeyboard = StatusOfKeyboard.Recent
            }else if indexPath.section == 1{
                let cell2 =  collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ColCell1InputVc
                cell2.lbOfEmoji.font=UIFont.systemFontOfSize(12.0)
                cell2.lbOfEmoji.backgroundColor=UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
                cell2.lbOfEmoji.layer.borderColor=UIColor(red: 208/255.0, green: 208/255.0, blue: 208/255.0, alpha: 1).CGColor
                cell2.lbOfEmoji.textColor = UIColor.lightGrayColor()
                statusOfKeyboard = StatusOfKeyboard.Emoji
            }
        }else if collectionView == clvOfRecent{
            if (indexPath.row == 2) && ((indexPath.section+1)%8 == 0) {
                txtViewOfMsg.text =  self.reduceOne(txtViewOfMsg.text)
                calumateAndUpdateUITxtViewOfMsg()
            }else {
                txtViewOfMsg.text = txtViewOfMsg.text + emojiRecent[ indexPath.section + indexPath.row * 8]
                calumateAndUpdateUITxtViewOfMsg()
            }
        }else if collectionView == clvOfMoreAction{
            if indexPath.row == 0{
                switch (indexPath.section) {
                case 0:
                    if (assetPicker != nil) {
                        assetPicker.getPictureFromAlbum()
                    }
                    break;
                case 1:
                    if (assetPicker != nil) {
                        assetPicker.getPictureFromCamera()
                    }
                case 2:
                    //调用地图
                    
                    oneInputVcDelegate!.presentMapVC()
                    
                    break;
                case 3:
                    //                    使用说明
                    oneInputVcDelegate?.showUseIntroduce()
                default:
                    break;
                }
            }
            else{
            }
        }else{
            
        }
    }
    
    func getEmojiInAll(section:Int,row:Int)->String{
        let page = section / 8
        let nb = section % 8 + row * 8
        return emojiArray[page][nb]
    }
    func reduceOne(str:NSString)->String{
        if str.length > 0{
            var lastCharacterLength = 1
            //nzz此处需要优化，找一个更好的知道最后一个字符是多少字节的方法
            (str as NSString).enumerateSubstringsInRange(NSRange(location: 0,length: str.length), options: NSStringEnumerationOptions.ByComposedCharacterSequences, usingBlock: { (substring, substringRange, enclosingRange, _) -> () in
                lastCharacterLength =  (substring! as NSString).length
            })
            return str.substringWithRange(NSMakeRange(0,str.length-lastCharacterLength))
        }
        else{
            return str as String
        }
    }
    func calumateAndUpdateUITxtViewOfMsg(){
        if #available(iOS 8.0, *) {
            let newsize = txtViewOfMsg.sizeThatFits(CGSizeMake(widthOfTxtViewOfMsg, CGFloat.max))
            if newsize.height<200{
                //8.0开始可以设置开关
                //oldNSLayoutConstraint.active=false
                //var constrains = self.view.constraints
                //self.removeConstraint(txtViewOfMsgNSLayoutConstraint)
                //heightOfUnderView比txtViewOfMsg高15
                print("\(newsize.height)")
//                let heightOfUnderViewBefore = heightOfUnderView
                heightOfUnderView = newsize.height + heightThanViewUnder
                if effectView != nil {
                    effectView!.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, heightOfUnderView)
                }
                heightOfView = heightOfView +  heightOfUnderView - self.viewUnder.frame.height
                print("\(heightOfView)")
                viewUnderNSLayoutConstraint.constant = heightOfUnderView
                oneInputVcDelegate?.heightOfInputNeedToChange(heightOfUnderView)
            }
        }
    }
}
extension InputV:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == clvMsgWantSend{
        pageControl.currentPage = Int(clvMsgWantSend.contentOffset.x / clvMsgWantSend.frame.size.width)
        }
        else{
        pageControl.currentPage = Int(clvOfKeyBoard.contentOffset.x / clvOfKeyBoard.frame.size.width)
        }
    }
}
extension InputV:UITextViewDelegate{
    func textViewDidEndEditing(textView: UITextView) {
        txtViewOfMsg.text = textView.text
    }
    func textViewDidChange(textView: UITextView) {
        calumateAndUpdateUITxtViewOfMsg()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            self.sendMsg()
            return false
        }
        return true
    }
}
extension InputV:AssetPickerDelegate{
    func finishPick(images: [AnyObject]!) {
        oneInputVcDelegate!.finishImagesPick(images)
    }
}
//关于语音录制的操作
extension InputV{
    func initVolView(){
        
        aVolView = VolView(frame:CGRectMake((UIScreen.mainScreen().bounds.size.width - 150)/2, (UIScreen.mainScreen().bounds.size.height - 150)/2 - 30, 150, 150))
        
        aVolView.hidden = false
        

    }
    
    func showImgVol(nameOfImage:String,isVolImg:Bool,isHide:Bool){
        aVolView.hidden = isHide
        if !isHide {
            aVolView.imgv.image = UIImage(named: nameOfImage)
            if isVolImg{
                aVolView.lbl.text="上划取消发送"
                aVolView.lbl.backgroundColor=UIColor.clearColor()
            }else{
                aVolView.lbl.backgroundColor=UIColor(red: 136.0 / 255.0, green: 48.0 / 255.0, blue: 33.0 / 255.0, alpha: 1)
                aVolView.lbl.text="松开取消发送"
            }
            aVolView.updateLbl()
        }
    }
    func startRecord(){
        if voiceMsgAvailable{
            self.btnOfVoice.backgroundColor=UIColor.lightGrayColor()
            oneRecordAndPlay.recordAudio()
            voiceStart=true
            if nstimerOfVolRecord == nil {
                nstimerOfVolRecord = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "changeViewOfVol", userInfo: nil, repeats: true)
            }else {
                if nstimerOfVolRecord!.valid {
                    nstimerOfVolRecord!.fireDate = NSDate.distantPast()
                }
                
            }
        }
    }
    func changeViewOfVol(){
//        oneInputVcDelegate?.recording(getImageNameByVol(),isVolImg: isVolImg, isHide: false)
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
//            在最上层弹出提示框
//            1.方法1
            UIApplication.sharedApplication().windows.last?.insertSubview(self.aVolView, atIndex: 20)
//            2.方法2
//            UIApplication.sharedApplication().windows.last?.addSubview(self.aVolView)
//            3.方法3不行
//            UIApplication.sharedApplication().windows.last?.bringSubviewToFront(self.aVolView)
//            4.方法4
            //            let aUIViewController:UIViewController = HelpFromOc.getCurrentVC()
            //            aUIViewController.view.addSubview(self.aVolView)
        }
        showImgVol(getImageNameByVol(),isVolImg: isVolImg, isHide: false)
    }
    func wantCancel(){
        isVolImg=false
    }
    func finishCancel(){
        isVolImg=true
    }
    func cancelRecord(){
        if voiceStart{
            SVProgressHUD.showInfoWithStatus("会话已经取消")
            self.btnOfVoice.backgroundColor=UIColor.whiteColor()
            oneRecordAndPlay.stopAudio()
            voiceStart=false
            if (nstimerOfVolRecord != nil){
                if nstimerOfVolRecord!.valid {
                    nstimerOfVolRecord!.fireDate = NSDate.distantFuture()
                }
            }
            showImgVol(getImageNameByVol(),isVolImg: isVolImg, isHide: true)
//            oneInputVcDelegate?.recording(getImageNameByVol(),isVolImg: isVolImg, isHide: true)
            isVolImg=true
            //将录音取消的提示提示去掉
//            NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "HideViewOfVol", userInfo: nil, repeats: false)
        }
    }
//    func HideViewOfVol(){
//        oneInputVcDelegate?.recording("", txt: "", isHide: true)
//        showImgVol("", txt: "", isHide: true)
//    }
    func stopRecord(){
        if voiceStart{
            self.btnOfVoice.backgroundColor=UIColor.whiteColor()
            let timeVoice = oneRecordAndPlay.stopAudio()[1] as! NSNumber
            if timeVoice.doubleValue > 0.5{
                oneInputVcDelegate?.finishVoice(oneRecordAndPlay.stopAudio())
                voiceMsgAvailable=true
            }else{
                SVProgressHUD.showInfoWithStatus("语音时间太短")
                if voiceMsgAvailable{
                    voiceMsgAvailable=false
                    //时间太短，再次打开录音需要隔一段时间，设计1s
                    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "openVoiceMsg", userInfo: nil, repeats: false)
                }
            }
            voiceStart=false
            if nstimerOfVolRecord!.valid {
                nstimerOfVolRecord!.fireDate = NSDate.distantFuture()
                nstimerOfVolRecord=nil
            }
            showImgVol(getImageNameByVol(), isVolImg: isVolImg, isHide: true)
//            oneInputVcDelegate?.recording(getImageNameByVol(), isVolImg: isVolImg, isHide: true)
        }
    }
    func openVoiceMsg(){
        voiceMsgAvailable = true
    }
    //发送updateMeters消息来刷新平均和峰值功率。此计数是以对数刻度计量的，-160表示完全安静，0表示最大输入值
    func getImageNameByVol()->String{
        
        if isVolImg{
            oneRecordAndPlay.recorder.updateMeters()
            let vol=oneRecordAndPlay.recorder.averagePowerForChannel(0)
            if vol < -50{
                return "vol1"
            }else if vol < -40{
                return "vol2"
            }else if vol < -35{
                return "vol3"
            }else if vol < -30{
                return "vol4"
            }else if vol < -28{
                return "vol5"
            }else if vol < -25{
                return "vol6"
            }else if vol < -15{
                return "vol7"
            }else{
                return "vol8"
            }
        }else{
            return "recordcancel"
        }
    }
}