//
//  MailboxViewController.swift
//  CodePathWeek3Mailbox
//
//  Created by Justin Peng on 2/15/16.
//  Copyright © 2016 Justin Peng. All rights reserved.
//

import UIKit
import MessageUI

class MailboxViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //Center points
    var mailboxViewCenter: CGPoint!
    var mailboxFirstMessageViewCenter: CGPoint!
    var mailboxFirstMessageCenter: CGPoint!
    var mailboxLeftIconCenter: CGPoint!
    var mailboxRightIconCenter: CGPoint!
    var mailboxMessageFeedCenter: CGPoint!
    var mailboxScrollViewCenter: CGPoint!
    var archiveScrollViewCenter: CGPoint!
    var laterScrollViewCenter: CGPoint!
    
    //Refresh control
    var mailboxRefreshControl: UIRefreshControl!
    
    //Gesture recognizers
    var mailboxViewPanGesture: UIPanGestureRecognizer!
    var edgeGesture: UIScreenEdgePanGestureRecognizer!
    
    var lastAction: String!
    //append lastAction depending on last action taken - read, delete, list, or later
    
    //Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mailboxView: UIView!
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
    @IBOutlet weak var archiveScrollView: UIScrollView!
    @IBOutlet weak var laterScrollView: UIScrollView!
    @IBOutlet weak var segmentMenu: UISegmentedControl!
    @IBOutlet weak var numberOfLaters: UILabel!
    @IBOutlet weak var composeView: UIView!
    
    //Define colors
    let grayColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
    let yellowColor = UIColor(red: 0.98, green: 0.82, blue: 0.20, alpha: 1)
    let brownColor = UIColor(red: 0.85, green: 0.65, blue: 0.46, alpha: 1)
    let greenColor = UIColor(red: 0.44, green: 0.85, blue: 0.38, alpha: 1)
    let redColor = UIColor(red: 0.92, green: 0.33, blue: 0.20, alpha: 1)
    
    //NSUserDefaults
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //What to do when the user releases the swipe
    func completeAction (translation_x: CGFloat) {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            if translation_x < 0 {
                self.mailboxFirstMessage.center.x -= 320
                self.mailboxRightIcon.alpha = 0
            }
            if translation_x > 0 {
                self.mailboxFirstMessage.center.x += 320
                self.mailboxLeftIcon.alpha = 0
                
            }
        }, completion: { (Bool) -> Void in
            if translation_x > -260 && translation_x < -60 {
                self.showLaterView()
                self.emailRescheduled()
            } else if translation_x < -260 {
                self.showListView()
            } else {
            self.hideFirstMessage()
                if translation_x > 0 && translation_x < 260 {
                    self.emailArchived()
                } else {
                    self.lastAction = "delete"
                }
            }
    })
    }
    
    //When a new message is refreshed for
    func onRefresh () {
        resetFirstMessage()
        delay(0.5) { () -> () in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mailboxFirstMessageView.center = self.mailboxFirstMessageViewCenter
                self.mailboxMessageFeed.center = self.mailboxMessageFeedCenter
                self.mailboxFirstMessageView.hidden = false
                }, completion: { (Bool) -> Void in
            })
            self.mailboxRefreshControl.endRefreshing()
        }
    }
    
    func resetFirstMessage () {
        mailboxFirstMessageView.center = mailboxFirstMessageViewCenter
        mailboxFirstMessage.center = mailboxFirstMessageCenter
        mailboxRightIcon.center = mailboxRightIconCenter
        mailboxLeftIcon.center = mailboxLeftIconCenter
    }
    
    func showLaterView () {
        view.bringSubviewToFront(mailboxRescheduleView)
        UIView.animateWithDuration(0.3) { () -> Void in
            self.mailboxRescheduleView.alpha = 1
        }
    }
    
    func showListView () {
        lastAction = "list"
        view.bringSubviewToFront(mailboxListView)
        mailboxListView.alpha = 1
    }

    func hideFirstMessage () {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.mailboxFirstMessageView.center.y -= 86
            self.mailboxFirstMessageView.hidden = true
            self.mailboxMessageFeed.center.y -= 86
        }
    }
    
    func openMenu () {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.mailboxView.center.x = 450
            //self.mailboxViewTapGesture.enabled = true
            self.mailboxViewPanGesture.enabled = true
        }
    }
    
    func closeMenu () {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.mailboxView.center = self.mailboxViewCenter
            //self.mailboxViewTapGesture.enabled = false
            self.mailboxViewPanGesture.enabled = false
        }
    }
    
    func resetLastAction (lastaction: String) {
        resetFirstMessage()
        self.mailboxMessageFeed.center = self.mailboxMessageFeedCenter
        mailboxFirstMessageView.hidden = false
        if lastaction == "archive" {
            var number_archived = defaults.integerForKey("emails_archived")
            if number_archived > 0 {
                number_archived -= 1
                defaults.setInteger(number_archived, forKey: "emails_archived")
                defaults.synchronize()
                archiveScrollView.contentSize.height -= 86
                for subView in self.archiveScrollView.subviews {
                    if subView.tag == number_archived {
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            subView.removeFromSuperview()
                        })
                    }
                }
                
            }
            
        } else if lastaction == "later" {
            var number_rescheduled = defaults.integerForKey("emails_rescheduled")
            if number_rescheduled > 0 {
                number_rescheduled -= 1
                defaults.setInteger(number_rescheduled, forKey: "emails_rescheduled")
                defaults.synchronize()
                numberOfLaters.text = String(number_rescheduled)
                laterScrollView.contentSize.height -= 86
                for subView in self.laterScrollView.subviews {
                    if subView.tag == number_rescheduled {
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            subView.removeFromSuperview()
                        })
                    }
                }
                
            }
            
        } else if lastaction == "delete" || lastaction == "list" {
            
        } else {
            
        }
    }

    func onMailboxPan (sender:UIPanGestureRecognizer) {
        var translation_x = sender.translationInView(contentView).x + 290
        print(translation_x)
        if sender.state == UIGestureRecognizerState.Changed {
        mailboxView.center = CGPoint(x: mailboxViewCenter.x + translation_x, y: mailboxView.center.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            if mailboxView.center.x < 320 {
                closeMenu()
            } else {
                openMenu()
            }
        }
    }
    
    func emailArchived () {
        //increase the number of archived by 1
        lastAction = "archive"
        var number_archived = defaults.integerForKey("emails_archived")
        number_archived += 1
        defaults.setInteger(number_archived, forKey: "emails_archived")
        defaults.synchronize()
        //add it to the archive list
        archiveScrollView.contentSize.height += 86
        var frame = CGRect(x: 0, y: 0 + ((number_archived - 1) * 86), width: 320, height: 86)
        var imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "message")
        imageView.userInteractionEnabled = true
        imageView.tag = number_archived - 1
        archiveScrollView.addSubview(imageView)
        //add a new image view with the email
        //increase the content size of the archive scroll view
        
    }
    
    func emailRescheduled () {
        //increase the number rescheduled by 1
        lastAction = "later"
        var number_rescheduled = defaults.integerForKey("emails_rescheduled")
        number_rescheduled += 1
        defaults.setInteger(number_rescheduled, forKey: "emails_rescheduled")
        defaults.synchronize()
        //add it to the later list
        laterScrollView.contentSize.height += 86
        var frame = CGRect(x: 0, y: 0 + ((number_rescheduled - 1) * 86), width: 320, height: 86)
        var imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "message")
        imageView.userInteractionEnabled = true
        imageView.tag = number_rescheduled - 1
        laterScrollView.addSubview(imageView)
        numberOfLaters.text = String(number_rescheduled)
    }
    
    func showLaterScrollView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.laterScrollView.center.x = 160
            //self.laterScrollView.hidden = false
            self.laterScrollView.alpha = 1
            
            self.mailboxScrollView.center.x = 480
            //self.mailboxScrollView.hidden = true
            self.mailboxScrollView.alpha = 0
            
            self.archiveScrollView.center.x = 640
            //self.archiveScrollView.hidden = true
            self.archiveScrollView.alpha = 0
        })
    }
    
    func showMailboxScrollView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.laterScrollView.center.x = -160
            //self.laterScrollView.hidden = true
            self.laterScrollView.alpha = 0
            
            self.mailboxScrollView.center.x = 160
            //self.mailboxScrollView.hidden = false
            self.mailboxScrollView.alpha = 1
            
            self.archiveScrollView.center.x = 480
            //self.archiveScrollView.hidden = true
            self.archiveScrollView.alpha = 0
        })
    }
    
    func showArchiveScrollView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.laterScrollView.center.x = -480
            //self.laterScrollView.hidden = true
            self.laterScrollView.alpha = 0
            
            self.mailboxScrollView.center.x = -160
            //self.mailboxScrollView.hidden = true
            self.mailboxScrollView.alpha = 0
            
            self.archiveScrollView.center.x = 160
            //self.archiveScrollView.hidden = false
            self.archiveScrollView.alpha = 1
        })
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        if segmentMenu.selectedSegmentIndex == 0 {
            showLaterScrollView()
            
        } else if segmentMenu.selectedSegmentIndex == 1 {
            showMailboxScrollView()
            
        } else if segmentMenu.selectedSegmentIndex == 2 {
            showArchiveScrollView()
            
        }
    }
    
    @IBAction func didPressMenuButton(sender: UIButton) {
        if mailboxView.center.x == 450 {
            closeMenu()
        } else {
            openMenu()
        }
    }

    @IBAction func didPressLater(sender: UIButton) {
        closeMenu()
        showLaterScrollView()
        segmentMenu.selectedSegmentIndex = 0
    }
    
    @IBAction func didPressArchive(sender: UIButton) {
        closeMenu()
        showArchiveScrollView()
        segmentMenu.selectedSegmentIndex = 2
    }
    
    @IBAction func didTapAView(sender: UITapGestureRecognizer) {
        var imageView = sender.view as! UIImageView
        imageView.alpha = 0
        hideFirstMessage()
    }

    @IBAction func didPressCompose(sender: UIButton) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.composeView.center.y -= 568
        }
        /*
        // Old code from MFMailComposeViewController which is supposedly broken in Simulator
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["justin@gmail.com"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("Hello from California!", isHTML: false)
        
        // Present the view controller modally.
        self.presentViewController(composeVC, animated: true, completion: nil)
        */
    }
    
    @IBAction func didPressCancelCompose(sender: AnyObject) {
        view.endEditing(true)
        UIView.animateWithDuration(0.5) { () -> Void in
            self.composeView.center.y += 568
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
        didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            // Check the result or perform other tasks.
            
            // Dismiss the mail compose view controller.
            controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onEdgePan(sender:UIScreenEdgePanGestureRecognizer) {
        var translation_x = sender.translationInView(contentView).x
        print(translation_x)
        if sender.state == UIGestureRecognizerState.Began {
        } else if sender.state == UIGestureRecognizerState.Changed && translation_x > 0 {
        mailboxView.center = CGPoint(x: mailboxViewCenter.x + translation_x, y: mailboxView.center.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            if mailboxView.center.x < 320 {
                closeMenu()
            } else if mailboxView.center.x >= 320 {
                openMenu()
            }
        }
    }
    
    @IBAction func onMessagePan(sender: AnyObject) {
        var pan_x = sender.locationInView(mailboxFirstMessageView).x
        var translation_x = sender.translationInView(mailboxFirstMessageView).x
        var velocity = sender.velocityInView(mailboxFirstMessageView)
        
        if sender.state == UIGestureRecognizerState.Began {
        } else if sender.state == UIGestureRecognizerState.Changed {
            mailboxFirstMessage.center = CGPoint(x: mailboxFirstMessageCenter.x + translation_x, y: mailboxFirstMessage.center.y)
            if translation_x > -60 && translation_x < 0 {
                mailboxFirstMessageView.backgroundColor = grayColor
                mailboxRightIcon.image = UIImage(named: "later_icon")
                var rightIconAlpha = convertValue(translation_x, r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
                mailboxRightIcon.alpha = rightIconAlpha
            } else if translation_x > -260 && translation_x < -60 {
                mailboxRightIcon.image = UIImage(named: "later_icon")
                mailboxFirstMessageView.backgroundColor = yellowColor
                mailboxLeftIcon.alpha = 0
                mailboxRightIcon.center.x = mailboxRightIconCenter.x + (translation_x + 60)
            } else if translation_x < -260 {
                mailboxFirstMessageView.backgroundColor = brownColor
                mailboxRightIcon.image = UIImage(named: "list_icon")
                mailboxRightIcon.center.x = mailboxRightIconCenter.x + (translation_x + 60)
            } else if translation_x > 0 && translation_x < 60 {
                mailboxFirstMessageView.backgroundColor = grayColor
                mailboxLeftIcon.image = UIImage(named: "archive_icon")
                var leftIconAlpha = convertValue(translation_x, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                mailboxLeftIcon.alpha = leftIconAlpha
            } else if translation_x > 60 && translation_x < 260 {
                mailboxFirstMessageView.backgroundColor = greenColor
                mailboxLeftIcon.image = UIImage(named: "archive_icon")
                mailboxRightIcon.alpha = 0
                mailboxLeftIcon.center.x = mailboxLeftIconCenter.x + (translation_x - 60)
            } else if translation_x > 260 {
                mailboxFirstMessageView.backgroundColor = redColor
                mailboxLeftIcon.image = UIImage(named: "delete_icon")
                mailboxLeftIcon.center.x = mailboxLeftIconCenter.x + (translation_x - 60)
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            if translation_x < -60 || translation_x > 60 {
                completeAction(translation_x)
            } else {
                resetFirstMessage()
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mailboxScrollView setup
        mailboxScrollView.contentSize.height = mailboxHelpLabel.image!.size.height + mailboxSearchLabel.image!.size.height + mailboxFirstMessage.image!.size.height + mailboxMessageFeed.image!.size.height
        mailboxScrollView.contentSize.width = mailboxHelpLabel.image!.size.width
        
        //archiveScrollView setup
        archiveScrollView.contentSize.height = 0
        archiveScrollView.contentSize.width = 320
        archiveScrollView.alpha = 0
        //archiveScrollView.hidden = true
        
        //laterScrollView setup
        laterScrollView.contentSize.height = 0
        laterScrollView.contentSize.width = 320
        laterScrollView.alpha = 0
        //laterScrollView.hidden = true
        
        //Assigning centers to default views
        mailboxViewCenter = mailboxView.center
        mailboxFirstMessageViewCenter = mailboxFirstMessageView.center
        mailboxFirstMessageCenter = mailboxFirstMessage.center
        mailboxLeftIconCenter = mailboxLeftIcon.center
        mailboxRightIconCenter = mailboxRightIcon.center
        mailboxMessageFeedCenter = mailboxMessageFeed.center
        mailboxScrollViewCenter = mailboxScrollView.center
        archiveScrollViewCenter = archiveScrollView.center
        laterScrollViewCenter = laterScrollView.center
        
        //Hiding icons
        mailboxRightIcon.alpha = 0
        mailboxLeftIcon.alpha = 0
        
        //Initializing refresh control
        mailboxRefreshControl = UIRefreshControl()
        mailboxRefreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        mailboxScrollView.insertSubview(mailboxRefreshControl, atIndex: 0)
        
        //Initializing gesture recognizers
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
        
        mailboxViewPanGesture = UIPanGestureRecognizer(target: self, action: "onMailboxPan:")
        mailboxView.addGestureRecognizer(mailboxViewPanGesture)
        mailboxViewPanGesture.enabled = false
        
        //NSUserDefaults setup
        defaults.setInteger(0, forKey: "emails_archived")
        defaults.setInteger(0, forKey: "emails_rescheduled")
        defaults.synchronize()
        
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
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            print ("shaken")
            resetLastAction(lastAction)
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
