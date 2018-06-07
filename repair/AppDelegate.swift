//
//  AppDelegate.swift
//  repair
//
//  Created by Ahmad Karkouty on 5/31/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import UIKit
import FoldingTabBar
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupYALTabBarController()
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error == nil {
                print("Successful Authorization ")
            }
        }
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        
        
        
        return true
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBHandler()
    }
    
    @objc func refreshToken(notification: NSNotification) {
        let refreshToken = InstanceID.instanceID().token()!
        print("*** \(refreshToken) ***")
        
        FBHandler()
    }
    
    
    func FBHandler() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }



}

private extension AppDelegate {
    
    func setupYALTabBarController() {
        guard let tabBarController = window?.rootViewController as? YALFoldingTabBarController else { return }
        
        
        
        let item1 = YALTabBarItem(itemImage: UIImage(named: "nearby_icon"), leftItemImage: nil, rightItemImage: nil)
        let item2 = YALTabBarItem(itemImage: UIImage(named: "profile_icon"), leftItemImage: UIImage(named: "edit_icon"), rightItemImage: nil)
        tabBarController.leftBarItems = [item1, item2]
        
        
        let item3 = YALTabBarItem(itemImage: UIImage(named: "chats_icon"), leftItemImage: UIImage(named: "chats_icon"), rightItemImage: UIImage(named: "edit_icon"))
        let item4 = YALTabBarItem(itemImage: UIImage(named: "settings_icon"), leftItemImage: nil, rightItemImage: nil)
        tabBarController.rightBarItems = [item3, item4]
        
        tabBarController.centerButtonImage = UIImage(named:"plus_icon")!
        tabBarController.selectedIndex = 2
        
        //customize tabBarView
        tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
        tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
        tabBarController.tabBarView.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0, blue: 149.0/255.0, alpha: 1)
        
        tabBarController.tabBarView.tabBarColor = UIColor(red: 72.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1)
        tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight;
        tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets;
        tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;
    }
}

