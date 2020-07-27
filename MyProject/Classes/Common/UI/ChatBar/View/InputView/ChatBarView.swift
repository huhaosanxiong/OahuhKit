//
//  ChatBarView.swift
//  MyProject
//
//  Created by huhsx on 2020/7/21.
//  Copyright © 2020 胡浩三雄. All rights reserved.
//

import UIKit
import RxSwift

public enum ChatFunctionViewShowType: Int {
    /** 不显示functionView */
    case none                   = 1000
    /** 显示键盘 */
    case keyboard               = 1001
    /** 显示表情View */
    case emoji                  = 1002
    /** 显示更多view */
    case more                   = 1003
}

//功能键盘高度
public let FunctionViewHeight: CGFloat = 240.0
//输入框bar高度
public let ChatBarHeight: CGFloat = 54.0

protocol ChatBarViewDelegate: AnyObject {
    
    /// 发送消息
    /// - Parameter text: text
    func sendMessage(text: String)
    
    /// chatBar frame变化
    /// - Parameter frame: frame
    func chatBarFrameDidChanged(frame: CGRect)
}

class ChatBarView: UIView {

    public var textView: UITextView!
    
    private var emojiButton: UIButton!
    
    private var moreButton: UIButton!
    
    private var emojiBoardView: ChatBarFaceView!
    
    public var moreBoardView: ChatBarMoreView!
    
    private var space: CGFloat = 7.0
    
    private var keyboardFrame: CGRect = .zero
    
    private let disposeBag = DisposeBag()
    
    private let manager = ChatBarDataManager.shared
    
    public weak var delegate: ChatBarViewDelegate?
    
    // 安全区高度
    lazy var bottomInset: CGFloat = {
        
        if #available(iOS 11.0, *) {
            return CGFloat(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0)
        } else {
            // Fallback on earlier versions
            return 0.0
        }
    }()
    
    /// 输入框最小高度
    let minHeight: CGFloat = 40
    /// 输入框最大高度
    let maxHeight: CGFloat = 100
    /// textview内容高度
    var contentHeight: CGFloat = 0
    /// textview高度
    var countedHeight: CGFloat {
        min(max(minHeight, contentHeight), maxHeight)
    }
    /// bar 的高度
    var chatBarHeight: CGFloat {
        countedHeight + 2 * space
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = ColorHex("#EFF4F5")
        
        configSubviews()
        
        addNotification()
    }
    
    private func configSubviews() {
        
        // textview
        textView = UITextView()
        textView.backgroundColor = .white
        textView.tintColor = ColorHex("#00CC67")
        textView.textColor = .black
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16.0)
        textView.returnKeyType = .send
        textView.enablesReturnKeyAutomatically = true
        textView.frame = CGRect(x: space, y: space, width: bounds.width - space * 3 - 2 * 40, height: 40)
        textView.layer.cornerRadius = 3.0
        textView.layer.masksToBounds = true
        
        //emojiButton
        emojiButton = UIButton()
        emojiButton.setImage(UIImage(named: "message_expression_n"), for: .normal)
        emojiButton.setImage(UIImage(named: "message_expression_s"), for: .highlighted)
        emojiButton.setImage(UIImage(named: "message_keyboard_n"), for: .selected)
        emojiButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        emojiButton.tag = ChatFunctionViewShowType.emoji.rawValue
        
        //moreButton
        moreButton = UIButton()
        moreButton.setImage(UIImage(named: "message_add_n"), for: .normal)
        moreButton.setImage(UIImage(named: "message_add_s"), for: .highlighted)
        moreButton.setImage(UIImage(named: "message_keyboard_n"), for: .selected)
        moreButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        moreButton.tag = ChatFunctionViewShowType.more.rawValue
        
        addSubview(textView)
        addSubview(emojiButton)
        addSubview(moreButton)
        
        moreButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-space)
            make.width.height.equalTo(40)
        }

        emojiButton.snp.makeConstraints { make in
            make.right.equalTo(moreButton.snp.left)
            make.bottom.equalToSuperview().offset(-space)
            make.width.height.equalTo(40)
        }
        
        
        //表情键盘
        emojiBoardView = ChatBarFaceView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - FunctionViewHeight - bottomInset, width: SCREEN_WIDTH, height: FunctionViewHeight))
        emojiBoardView.emojiDataArray = manager.emojiDataArray
        emojiBoardView.delegate = self

        //更多view
        moreBoardView = ChatBarMoreView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - FunctionViewHeight - bottomInset, width: SCREEN_WIDTH, height: FunctionViewHeight))

    }

    
    @objc func buttonAction(sender: UIButton) {
        
        var showType: ChatFunctionViewShowType = ChatFunctionViewShowType(rawValue: sender.tag) ?? .none
        
        if sender == emojiButton {
            // 点击emoji
            moreButton.isSelected = false
            emojiButton.isSelected = !emojiButton.isSelected
            
            emojiBoardView.setSendButtonEnable(enable: textView.text.count > 0)
            
        }else if sender == moreButton {
            
            emojiButton.isSelected = false
            moreButton.isSelected = !moreButton.isSelected
        }
        
        if !sender.isSelected {
            showType = ChatFunctionViewShowType.keyboard
        }
        
        showViewWithType(showType: showType)
    }
    
    private func showViewWithType(showType: ChatFunctionViewShowType) {
        
        showFunctionView(view: emojiBoardView, show: showType == .emoji && emojiButton.isSelected)
        showFunctionView(view: moreBoardView, show: showType == .more && moreButton.isSelected)
        
        switch showType {
        case .emoji, .more:
            setViewFrame(frame: CGRect(x: 0, y: SCREEN_HEIGHT - FunctionViewHeight - bounds.height - bottomInset, width: SCREEN_WIDTH, height: bounds.height))
            textView.resignFirstResponder()
        case .keyboard:
            textView.becomeFirstResponder()
        default:
            break
        }
    }
    
    private func showFunctionView(view: UIView, show: Bool) {
        
        if show {
            superview?.addSubview(view)
            view.frame = CGRect(x: 0, y: SCREEN_HEIGHT - FunctionViewHeight - bottomInset, width: SCREEN_WIDTH, height: FunctionViewHeight)
        }else {
            view.removeFromSuperview()
        }
    }
    
    public func setViewFrame(frame: CGRect) {
        
        self.frame = frame
        
        if let delegate = delegate {
            delegate.chatBarFrameDidChanged(frame: self.frame)
        }
    }
    
    /**
    *  根据输入文字计算textView的大小 刷新textview 和 view；
    *  回调改变聊天主界面的tableView 大小。
    */
    private func refreshTextViewSize(textView: UITextView) {
        
        contentHeight = textView.contentSize.height
        
        let frame = textView.frame
        textView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: countedHeight)
        
        UIView.animate(withDuration: 0.25) {
            self.frame = CGRect(x: 0, y: SCREEN_HEIGHT - self.keyboardFrame.size.height - self.chatBarHeight, width: SCREEN_WIDTH, height: self.chatBarHeight)
            
            if let delegate = self.delegate {
                delegate.chatBarFrameDidChanged(frame: self.frame)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UITextViewDelegate
extension ChatBarView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        emojiButton.isSelected = false
        moreButton.isSelected = false
        
        showFunctionView(view: emojiBoardView, show: false)
        showFunctionView(view: moreBoardView, show: false)
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let selectedRange = textView.markedTextRange
        //获取高亮部分
        let pos = textView.position(from: selectedRange?.start ?? UITextPosition(), offset: 0)
        
        if selectedRange != nil && pos != nil {
            return
        }
        
        refreshTextViewSize(textView: textView)
        
        emojiBoardView.setSendButtonEnable(enable: textView.text.count > 0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            // 点击回车
            sendTextMessage(text: textView.text)
            
            return false
        }
        
        if text == "" {
            //删除
            let range = delRangeForEmoticon()
            if range.length == 1 {
                //删的不是表情，可能是@
                let item = false
                if item {
                    
                }else {
                    // 删除普通文字
                    return true
                }
            }
            
            //删除表情和@ ，退格删除键开放限制
            deleteTextRange(range: range)
            return false
        }
        
        
        return true
    }
}

// MARK: - Private
extension ChatBarView {
    
    /// 键盘通知
    private func addNotification() {
        
        NotificationCenter
            .default
            .rx
            .notification(UIResponder.keyboardWillShowNotification)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (notification) in
                
                guard let s = self else { return }
                
                guard let userInfo = notification.userInfo else { return }
                guard var keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                s.keyboardFrame = keyboardRect
                
                guard let superview = s.superview else { return }
                keyboardRect = superview.convert(keyboardRect, from: nil)
                
                //根据老的 frame 设定新的 frame
                var newTextViewFrame = s.frame
                newTextViewFrame.origin.y = keyboardRect.origin.y - s.frame.size.height
                
                //键盘的动画时间，设定与其完全保持一致
                let animationDurationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSValue
                var animationDuration: TimeInterval = 0
                animationDurationValue?.getValue(&animationDuration)
                
                //键盘的动画是变速的，设定与其完全保持一致
                let animationCurveObjectValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSValue
                var animationCurve: Int = 0
                animationCurveObjectValue?.getValue(&animationCurve)
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(animationDuration)
                UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: animationCurve)!)
                
                s.setViewFrame(frame: newTextViewFrame)
                
                UIView.commitAnimations()
                
            }).disposed(by: disposeBag)
        
        NotificationCenter
            .default
            .rx
            .notification(UIResponder.keyboardWillHideNotification)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] (notification) in
                
                guard let s = self else { return }
                
                guard let userInfo = notification.userInfo else { return }
                s.keyboardFrame = .zero
                
                //键盘的动画时间，设定与其完全保持一致
                let animationDurationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSValue
                var animationDuration: TimeInterval = 0
                animationDurationValue?.getValue(&animationDuration)
                
                //键盘的动画是变速的，设定与其完全保持一致
                let animationCurveObjectValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSValue
                var animationCurve: Int = 0
                animationCurveObjectValue?.getValue(&animationCurve)
                
                var newTextViewFrame = s.frame
                
                if s.emojiButton.isSelected || s.moreButton.isSelected {
                    newTextViewFrame.origin.y = SCREEN_HEIGHT - FunctionViewHeight - s.bounds.height - s.bottomInset
                }else {
                    newTextViewFrame.origin.y = SCREEN_HEIGHT - s.bounds.height - s.bottomInset
                }
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(animationDuration)
                UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: animationCurve)!)
                
                s.setViewFrame(frame: newTextViewFrame)
                
                UIView.commitAnimations()
                
            }).disposed(by: disposeBag)
        
    }
    
    /// 计算textView size
    /// - Parameters:
    ///   - string: 字符串
    ///   - textView: textView
    /// - Returns: size
    func getStringRectInTextView(string: String = "", textView: UITextView) -> CGSize {
        
        //实际textView显示时我们设定的宽
        var contentWidth = textView.frame.width
        //但事实上内容需要除去显示的边框值
        let broadWidth = (textView.contentInset.left + textView.contentInset.right
            + textView.textContainerInset.left
            + textView.textContainerInset.right
            + textView.textContainer.lineFragmentPadding/*左边距*/
            + textView.textContainer.lineFragmentPadding/*右边距*/)
        
        let broadHeight = (textView.contentInset.top
            + textView.contentInset.bottom
            + textView.textContainerInset.top
            + textView.textContainerInset.bottom)
        
        //由于求的是普通字符串产生的Rect来适应textView的宽
        contentWidth -= broadWidth
        
        let inSize = CGSize(width: contentWidth, height: CGFloat(MAXFLOAT))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode
        let dic = [NSAttributedString.Key.font: textView.font!, NSAttributedString.Key.paragraphStyle: paragraphStyle.copy()]
        
        let calculatedSize = NSString(string: string).boundingRect(with: inSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: dic, context: nil).size
        
        let adjustSize = CGSize(width: CGFloat(ceil(Double(calculatedSize.width))), height: calculatedSize.height + broadHeight)
        
        return adjustSize
    }
    
    
    /// 删除表情
    /// - Returns: 返回表情range
    func delRangeForEmoticon() -> NSRange {

        var range = rangeForPrefix(prefix: "[", suffix: "]")
        let selectedRange = textView.selectedRange
        if range.length > 1 {
            let tag = NSString(string: textView.text).substring(with: range)
            let exist = manager.checkEmojiInSystem(tag: tag)
            
            range = exist ? range : NSRange(location: selectedRange.location - 1, length: 1)
        }
        
        return range
    }
    
    func deleteTextRange(range: NSRange) {
        
        let text = textView.text ?? ""
        
        if (range.location + range.length <= text.count) &&
            (range.location != NSNotFound && range.length != 0) {
            
            let newText = NSString(string: text).replacingCharacters(in: range, with: "")
            let newSelectRange = NSRange(location: range.location, length: 0)
            
            textView.text = newText
            textView.selectedRange = newSelectRange
            textViewDidChange(textView)
        }
    }
    
    /// 匹配出字符串的range
    /// - Parameters:
    ///   - prefix: prefix 前缀
    ///   - suffix: suffix 后缀
    /// - Returns: range
    func rangeForPrefix(prefix: String, suffix: String) -> NSRange {
        
        let text = NSString(string: textView.text)
        let range = textView.selectedRange
        let selectedText = range.length > 0 ? text.substring(with: range) as NSString : text
        let endLocation = range.location
        
        if endLocation < 0 {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        var index = -1
        if selectedText.hasSuffix(suffix) {
            //往前搜最多20个字符，一般来讲是够了...
            let p = 20
            var i = endLocation
            
            while (i >= endLocation - p) && (i >= 1) {
                
                let subRange = NSRange(location: i - 1, length: 1)
                let subString = text.substring(with: subRange)
                if subString.compare(prefix) == .orderedSame {
                    index = i - 1
                    break
                }
                
                i -= 1
            }
        }
        
        return index == -1 ? NSRange(location: endLocation - 1, length: 1) : NSRange(location: index, length: endLocation - index)
    }
    
    /// 发送文本消息
    /// - Parameter text: text
    func sendTextMessage(text: String) {
        
        if text.count == 0 { return }
        
        DLog("发送message: \(text)")
        
        if let delegate = delegate {
            delegate.sendMessage(text: textView.text)
        }
        
        textView.text = ""
        
        textViewDidChange(textView)
        
        let bottomHeight = (emojiButton.isSelected || moreButton.isSelected) ? FunctionViewHeight + bottomInset : keyboardFrame.bounds.height
        
        setViewFrame(frame: CGRect(x: 0,
                                   y: SCREEN_HEIGHT - bottomHeight - ChatBarHeight,
                                   width: SCREEN_WIDTH,
                                   height: ChatBarHeight))
    }
    
}

// MARK: - ChatBarFaceViewDelegate
extension ChatBarView: ChatBarFaceViewDelegate {
    
    /// 点击表情
    /// - Parameter name: 表情tag
    func clickFace(name: String) {
        
        textView.text = textView.text + name
        
        textViewDidChange(textView)
    }
    
    /// 点击删除按钮
    func clickDeleteButton() {
        
        let _ = textView(textView, shouldChangeTextIn: NSRange(location: textView.text.count - 1, length: 1), replacementText: "")
    }
    
    /// 点击发送按钮
    func clickSendButton() {
        
        sendTextMessage(text: textView.text)
    }

}

// MARK: - Public
extension ChatBarView {
    
    public func chatBarDismiss() {
        
        if textView.isFirstResponder {
            textView.resignFirstResponder()
            
        }else if emojiButton.isSelected || moreButton.isSelected {
            
            showFunctionView(view: emojiBoardView, show: false)
            showFunctionView(view: moreBoardView, show: false)
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.setViewFrame(frame: CGRect(x: 0, y: SCREEN_HEIGHT - ChatBarHeight - self.bottomInset, width: SCREEN_WIDTH, height: ChatBarHeight))
            }) { _ in
                self.emojiButton.isSelected = false
                self.moreButton.isSelected = false
            }
        }

    }
}
