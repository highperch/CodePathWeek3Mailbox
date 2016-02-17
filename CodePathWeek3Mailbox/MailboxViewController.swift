//
//  MailboxViewController.swift
//  CodePathWeek3Mailbox
//
//  Created by Justin Peng on 2/15/16.
//  Copyright © 2016 Justin Peng. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    var mailboxFirstMessageCenter: CGPoint!
    var mailboxLeftIconCenter: CGPoint!
    var mailboxRightIconCenter: CGPoint!
    
    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet weak var mailboxHelpLabel: UIImageView!
    @IBOutlet weak var mailboxSearchLabel: UIImageView!
    @IBOutlet weak var mailboxFirstMessage: UIImageView!
    @IBOutlet weak var mailboxMessageFeed: UIImageView!
    @IBOutlet weak var mailboxListView: UIImageView!
    @IBOutlet weak var mailboxRescheduleView: UIImageView!
    @IBOutlet weak var mailboxFirstMessageView: UIView!
    @IBOutlet weak var mailboxLeftIcon: UIImageView!
    @IBOutlet weak var mailboxRightIcon: UIImageView!
    
    func performAction () {
        
    }
    
    @IBAction func onMessagePan(sender: AnyObject) {
        var pan_x = sender.locationInView(mailboxFirstMessageView).x
        print(pan_x)
        var translation_x = sender.translationInView(mailboxFirstMessageView).x
        print(translation_x)
        var velocity = sender.velocityInView(mailboxFirstMessageView)
        
        if sender.state == UIGestureRecognizerState.Began {
        } else if sender.state == UIGestureRecognizerState.Changed {
            mailboxFirstMessage.center = CGPoint(x: mailboxFirstMessageCenter.x + translation_x, y: mailboxFirstMessage.center.y)
            if translation_x > -60 && translation_x < 0 {
                mailboxFirstMessageView.backgroundColor = UIColor.grayColor()
                if velocity.x < 0 {
                    mailboxRightIcon.image = UIImage(named: "later_icon")
                    var rightIconAlpha = convertValue(translation_x, r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
                    mailboxRightIcon.alpha = rightIconAlpha
                } else if velocity.x > 0 {
                    mailboxRightIcon.image = UIImage(named: "later_icon")
                    var rightIconAlpha = convertValue(translation_x, r1Min: -60, r1Max: 0, r2Min: 1, r2Max: 0)
                    mailboxRightIcon.alpha = rightIconAlpha
                }
            } else if translation_x > -260 && translation_x < -60 {
                mailboxRightIcon.image = UIImage(named: "later_icon")
                mailboxFirstMessageView.backgroundColor = UIColor.yellowColor()
                mailboxLeftIcon.alpha = 0
                mailboxRightIcon.center.x = mailboxRightIconCenter.x + (translation_x + 60)
            } else if translation_x < -260 {
                mailboxFirstMessageView.backgroundColor = UIColor.brownColor()
                mailboxRightIcon.image = UIImage(named: "list_icon")
                mailboxRightIcon.center.x = mailboxRightIconCenter.x + (translation_x + 60)
            } else if translation_x > 0 && translation_x < 60 {
                mailboxFirstMessageView.backgroundColor = UIColor.grayColor()
                if velocity.x > 0 {
                    mailboxLeftIcon.image = UIImage(named: "archive_icon")
                    var leftIconAlpha = convertValue(translation_x, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                    mailboxLeftIcon.alpha = leftIconAlpha
                } else if velocity.x < 0 {
                    mailboxLeftIcon.image = UIImage(named: "archive_icon")
                    var leftIconAlpha = convertValue(translation_x, r1Min: 60, r1Max: 0, r2Min: 1, r2Max: 0)
                    mailboxLeftIcon.alpha = leftIconAlpha
                }
            } else if translation_x > 60 && translation_x < 260 {
                mailboxFirstMessageView.backgroundColor = UIColor.greenColor()
                mailboxLeftIcon.image = UIImage(named: "archive_icon")
                mailboxRightIcon.alpha = 0
                mailboxLeftIcon.center.x = mailboxLeftIconCenter.x + (translation_x - 60)
            } else if translation_x > 260 {
                mailboxFirstMessageView.backgroundColor = UIColor.redColor()
                mailboxLeftIcon.image = UIImage(named: "delete_icon")
                mailboxLeftIcon.center.x = mailboxLeftIconCenter.x + (translation_x - 60)
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            mailboxFirstMessage.center = mailboxFirstMessageCenter
            mailboxRightIcon.center = mailboxRightIconCenter
            mailboxLeftIcon.center = mailboxLeftIconCenter
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailboxScrollView.contentSize.height = mailboxHelpLabel.image!.size.height + mailboxSearchLabel.image!.size.height + mailboxFirstMessage.image!.size.height + mailboxMessageFeed.image!.size.height
        mailboxScrollView.contentSize.width = mailboxHelpLabel.image!.size.width
        mailboxFirstMessageCenter = mailboxFirstMessage.center
        print(mailboxFirstMessageCenter)
        mailboxLeftIconCenter = mailboxLeftIcon.center
        mailboxRightIconCenter = mailboxRightIcon.center
        mailboxRightIcon.alpha = 0
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        mailboxListView.alpha = 0
        mailboxRescheduleView.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
