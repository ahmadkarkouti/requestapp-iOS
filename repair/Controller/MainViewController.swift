//
//  MainViewController.swift
//  repair
//
//  Created by Ahmad Karkouty on 6/1/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FoldingTabBar
import SVProgressHUD
import UserNotifications

var ref: DatabaseReference!
private let DemoUserName = "userName"
private let ChatDemoMessageText = "messageText"
private let ChatDemeDateText = "dateText"
private let reuseIdentifier = "MainCollectionViewCell"
var requestList = [RequestInfo]()
var userList = [User]()
var myIndex = 0

class MainViewController: UIViewController, YALTabBarDelegate{
    

    
    var refHandle: UInt!
    typealias Message = [String: String]
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let cellAnumationDuration: Double = 0.25
    fileprivate let animationDelayStep: Double = 0.1
    
    
    override func viewDidLoad() {
    if Auth.auth().currentUser == nil {
        let MainNavigationController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(MainNavigationController, animated: true, completion: nil)
    }
    ref = Database.database().reference()
    requestList.removeAll()
    fetchUsers()
    self.collectionView.reloadData()
    super.viewDidLoad()
  }
    
    func addRefreshHeader() {
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.startAnimating()
        let barButtonItem = UIBarButtonItem(customView: myActivityIndicator)
        self.navigationItem.rightBarButtonItem = barButtonItem
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                        myActivityIndicator.stopAnimating()
                    })
    }

    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.collectionView.reloadData()
    prepareVisibleCellsForAnimation()
  }
  
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateVisibleCells()
  }
  
    var requestDictionary = [String: RequestInfo]()
    func tabBarDidSelectExtraRightItem(_ tabBar: YALFoldingTabBar){
        self.performSegue(withIdentifier: "goToRequest", sender: Any?.self)
    }

    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func tabBarDidSelectExtraLeftItem(_ tabBar: YALFoldingTabBar){
        let chatPartnerId = "1evli5UvfuRaWmhEWMlGgx9c8EL2"
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject]
                else { return }
            let usered = User()
            usered.id = chatPartnerId
            print(dictionary)
            usered.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user: usered)
        }
    }
    
    func showChatControllerForUser(user: User) {
        let chatViewController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatViewController.user = user
        chatViewController.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requestList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myIndex = indexPath.row
    }

  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        
        let myDevice = requestList[indexPath.row].device!
        var image = UIImage(named: "Mobile")
        switch myDevice {
            
        case "Mobile":
            image = UIImage(named: "Mobile")
            _ = UIImageView(image: image!)
        case "Tablet":
            image = UIImage(named: "Tablet")
            _ = UIImageView(image: image!)
        case "Computer":
            image = UIImage(named: "Computer")
            _ = UIImageView(image: image!)
        case "Smart Watch":
            image = UIImage(named: "Smart watch")
            _ = UIImageView(image: image!)
        case "Other":
            image = UIImage(named: "colour")
            _ = UIImageView(image: image!)
            
        default:
            image = UIImage(named: "colour")
            _ = UIImageView(image: image!)
        }
        
        
        
        var Status = ""
        var mystatusColor: UIColor?
        let myStatus = requestList[indexPath.row].Status!
        switch myStatus {
        case "0":
            Status = "Status: Pending"
            mystatusColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case "1":
            Status = "Status: Approved"
            mystatusColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case "2":
            Status = "Status: In Progress"
            mystatusColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case "3":
            Status = "Status: Completed"
            mystatusColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        case "4":
            Status = "Status: Refused"
            mystatusColor = #colorLiteral(red: 0.8874454128, green: 0, blue: 0.04979250122, alpha: 1)
        case "5":
            Status = "Status: Refund"
            mystatusColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        default:
            mystatusColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        }
    
        let yawza = convertTimestamp(serverTimestamp: Double(truncating: requestList[indexPath.row].Date!))
        let dateFormatter = DateFormatter()
        let dateFormat = "M/d/yy, h:mm:ss a"
        dateFormatter.dateFormat = dateFormat
        let startDate = dateFormatter.date(from: yawza)

        let hello = timeAgoSinceDate(date: startDate! as NSDate, numericDates: false)

        cell.configure(
          withImage: image!,
          userName: requestList[indexPath.row].device!,
          messageText: Status,
          dateText: hello,
          statusColor: mystatusColor!
        )
        
        return cell
  }
    
    func registerBackgroundTask() {
        let backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        var backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: date as Date)
    }
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    func fetchUsers(){
        let uid = Auth.auth().currentUser?.uid
        refHandle = ref?.child("request").child(uid ?? "uid not found").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = RequestInfo()
                user.setValuesForKeys(dictionary)
                requestList.append(user)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
        
        refHandle = ref?.child("request").child(uid ?? "uid not found").observe(.childChanged, with: { (snapshot) in
            let content = UNMutableNotificationContent()
            content.title = "Repair Forget"
            content.subtitle = ""
            content.body = "The Status of your order has been updated!"
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.5, repeats: false)
            
            let ID = snapshot.key
            if let index = requestList.index(where: {$0.id == ID}) {
                let value = snapshot.value as? NSDictionary
                
                
                requestList[index].Status = value?["Status"] as! String
                requestList[index].device = value?["device"] as! String
                requestList[index].type = value?["type"] as! String
                requestList[index].model = value?["model"] as! NSString
                let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

                print(requestList[index].Status)
                let indexPath = IndexPath(item: index, section: 0)
                self.collectionView.reloadItems(at: [indexPath])
                self.registerBackgroundTask()
            }
            
        })
        
        ref?.observe(.childRemoved, with: { (snapshot) in
            print("snapshot::::: \(snapshot.key)")
            print(self.requestDictionary)

            self.requestDictionary.removeValue(forKey: snapshot.key)
            self.collectionView.reloadData()
        }, withCancel: nil)
        
        
        
        
        
        SVProgressHUD.dismiss()
        SVProgressHUD.showSuccess(withStatus: "Fetched")
        
        SVProgressHUD.dismiss(withDelay: 2)
    }
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    return CGSize(width: view.bounds.width, height: layout.itemSize.height)
  }
}

extension MainViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segue.destination.hidesBottomBarWhenPushed = true
  }
}

//MARK: - Cell's animation
private extension MainViewController {
  
  func prepareVisibleCellsForAnimation() {
    collectionView.visibleCells.forEach {
      $0.frame = CGRect(
        x: -$0.bounds.width,
        y: $0.frame.origin.y,
        width: $0.bounds.width,
        height: $0.bounds.height
      )
      $0.alpha = 0
    }
  }
  
  func animateVisibleCells() {
    collectionView.visibleCells.enumerated().forEach { offset, cell in
      cell.alpha = 1
      UIView.animate(
        withDuration: self.cellAnumationDuration,
        delay: Double(offset) * self.animationDelayStep,
        options: .curveEaseOut,
        animations: {
          cell.frame = CGRect(
            x: 0,
            y: cell.frame.origin.y,
            width: cell.bounds.width,
            height: cell.bounds.height
          )
      })
    }
  }
  
}

