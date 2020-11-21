//
//  SettingsVC.swift
//  ExercisesApp
//
//  Created by developer on 10/21/20.
//  Copyright © 2020 Bradin. All rights reserved.
//

import UIKit
import AYPopupPickerView
import UserNotifications
import MessageUI

class SettingsVC: UIViewController,MFMailComposeViewControllerDelegate {


    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var reminderSwitch: UISwitch!
    
    var isReminder = false{
        didSet{
            self.reminderView.isHidden = !isReminder
            self.reminderSwitch.setOn(isReminder, animated: true)
        }
    }
    
    let popupDatePickerView = AYPopupDatePickerView()
    var reminderTime: Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSettings()

    }
    
    func getSettings(){
        self.isReminder = UserInfo.shared.isReminder
        self.reminderTime = UserInfo.shared.reminderTime
        self.initView()
        
    }
    
    func initView(){
        popupDatePickerView.datePickerView.datePickerMode = .time
        popupDatePickerView.datePickerView.locale = .current
        popupDatePickerView.headerView.backgroundColor = BACKGROUND_COLOR
        popupDatePickerView.doneButton.setTitleColor(COLOR3, for: .normal)
        popupDatePickerView.cancelButton.setTitleColor(.gray, for: .normal)
        popupDatePickerView.datePickerView.setValue(MAIN_COLOR, forKeyPath: "textColor")
        
        if #available(iOS 14, *) {
            popupDatePickerView.datePickerView.preferredDatePickerStyle = .wheels
            popupDatePickerView.datePickerView.sizeToFit()
        }
        if reminderTime == nil {
            self.timeBtn.setTitle("set time", for: .normal)
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            self.timeBtn.setTitle(formatter.string(from: reminderTime!), for: .normal)
        }

    }
    
    func removeNotifications(){
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func setNotifications(){
        
        if !UserInfo.shared.isReminder {
            return
        }
        
        if UserInfo.shared.reminderTime == nil {
            return
        }
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's exercise time."
        content.categoryIdentifier = "alarm"
        
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: UserInfo.shared.reminderTime!)
        dateComponents.minute = calendar.component(.minute, from: UserInfo.shared.reminderTime!)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
        center.add(request)
        print(UserInfo.shared.reminderTime!)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["mrlafranchi@gmail.com"])
            mail.setSubject("Contact Us")
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
       
    }

    @IBAction func reminderChanged(_ sender: Any) {
        
        self.isReminder = self.reminderSwitch.isOn
        UserInfo.shared.setUserInfo(.isReminder, value: self.isReminder)
        
        if isReminder {
            removeNotifications()
            setNotifications()
        }else{
            removeNotifications()
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.back()
    }
    
    @IBAction func didTapTime(_ sender: Any) {
        

        popupDatePickerView.display(defaultDate: reminderTime, doneHandler: { [self] date in
            print(date)
            self.reminderTime = date
            UserInfo.shared.setUserInfo(.reminderTime, value: self.reminderTime! as Date)
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            self.timeBtn.setTitle(formatter.string(from: date), for: .normal)
            self.removeNotifications()
            self.setNotifications()
        })
    }
    
    @IBAction func didTapContactUs(_ sender: Any) {
        self.sendEmail()
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) in
            UserInfo.shared.setUserInfo(.token, value: "")
            DispatchQueue.main.async {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
                self.view.window?.rootViewController = vc
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true)

    }
    
}

