//
//  ChatViewCell.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/10/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import UIKit

protocol ChatViewCellDelegate: class {
    func handleClearSignal(sender : ChatViewCell)
    func handleUserTextChange(sender: ChatViewCell)
    func handleUserTextFocus(sender: ChatViewCell)
    func handleUserTextBlur(sender: ChatViewCell)
    func handleUserStoppedTyping(sender: ChatViewCell)
    func handleChatTextExpired(sender: ChatViewCell)
}

class ChatViewCell: UITableViewCell, UITextViewDelegate {
    var index: Int = 0
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timerIndicatorView: TimerIndicatorView!
    @IBOutlet weak var chatTextView: UITextView!
    
    weak var delegate: ChatViewCellDelegate?
    var isUser: Bool = false {
        didSet {
            chatTextView.editable = isUser
            if isUser {
                chatTextView.becomeFirstResponder()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //test
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        chatTextView.delegate = self
        chatTextView.scrollEnabled = false
        chatTextView.tintColor = UIColors.Text
        chatTextView.textContainerInset = UIEdgeInsetsZero
    }
    
    override func prepareForReuse() {
        if isUser {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                if self.isUser {
                    self.chatTextView.becomeFirstResponder()
                }
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if let touchPoint = touches.anyObject() as? UITouch {
            if CGRectContainsPoint(nameLabel.frame, touchPoint.locationInView(self)) {
                delegate?.handleClearSignal(self)
            }
        }
    }
    
    var typingTimer: NSTimer? = nil
    var lastTypingEvent: NSTimeInterval? = nil
    let stoppedTypingDelaySeconds: Double = 5
    let checkStoppedTypingIntervalSeconds: Double = 0.5
    
    private enum ChatState
    {
        case Typing
        case EnteredText
        case NoText
        case NotEditing
    }
    
    private var chatState: ChatState = ChatState.NoText {
        didSet {
            switch(chatState){
            case .Typing:
                if oldValue == .EnteredText || oldValue == .NoText {
                    timerIndicatorView.setupTimerAnimation(true)
                }
                delegate?.handleUserTextChange(self)
            case .EnteredText:
                timerIndicatorView.startTimerAnimation({ [unowned self] in
                    //if user started typing again, it's not expired anymore
                    if (self.chatState == .EnteredText){
                        self.delegate!.handleChatTextExpired(self)
                    }
                })
                self.delegate!.handleUserStoppedTyping(self)
            case .NoText:
                timerIndicatorView.setupTimerAnimation(false)
            default:
                break
            }
        }
    }
    
    private func startTypingTimer(){
        typingTimer = NSTimer.scheduledTimerWithTimeInterval(checkStoppedTypingIntervalSeconds, target: self, selector: Selector("checkStoppedTyping"), userInfo: nil, repeats: true)
        typingTimer?.tolerance = 0.2
    }
    
    private func stopTypingTimer(){
        typingTimer?.invalidate()
        typingTimer = nil
    }
    
    func checkStoppedTyping(){
        if lastTypingEvent == nil { return }
        if NSDate.timeIntervalSinceReferenceDate() - lastTypingEvent! >= stoppedTypingDelaySeconds && chatTextView.text != "" {
            chatState = chatTextView.text == "" ? .NoText : .EnteredText
            stopTypingTimer()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        lastTypingEvent = NSDate.timeIntervalSinceReferenceDate()
        chatState = .Typing
        if typingTimer == nil {
            startTypingTimer()
        }
        delegate?.handleUserTextChange(self)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        stopTypingTimer()
        chatState = .NotEditing
        delegate?.handleUserTextBlur(self)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        startTypingTimer()
        if chatTextView.text == "" {
            chatState = .NoText
        } else {
            chatState = .EnteredText
        }
        delegate?.handleUserTextFocus(self)
    }
}
