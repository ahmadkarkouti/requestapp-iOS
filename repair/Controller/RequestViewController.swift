//
//  RequestViewController.swift
//  repair
//
//  Created by Ahmad Karkouty on 6/1/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import Foundation
import UIKit
import ELPickerView
import Firebase
import FirebaseDatabase
import SVProgressHUD


var collectionList = [RequestInfo]()
private let reuseIdentifier = "RequestCollectionViewCell"

class RequestViewController: UIViewController, BEMCheckBoxDelegate, UITextFieldDelegate{
    
    
    var refRequests: DatabaseReference!
    
    let now = Date()
    var date: NSNumber!
    
    let myArray = ["Mobile", "Computer", "Tablet", "Smart Watch"]
    let mobiles = ["iPhone", "Samsung", "Nokia", "Huawei"]
    let tablets = ["iPad", "Fire", "Samsung Tablet"]
    let computers = ["MacBook", "Laptop", "PC", "iMac"]
    let smartwatchs = ["Apple Watch", "Samsung Watch"]
    let others = ["adop", "bofd", "sasa", "greg", "odpkw"]
    let myColor = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewB: UICollectionView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    var deviceLabel = ""
    var typeLabel = ""
    
    @IBOutlet weak var modelTextfield: UITextField!
    @IBOutlet weak var box1: BEMCheckBox!
    @IBOutlet weak var box2: BEMCheckBox!
    @IBOutlet weak var box3: BEMCheckBox!
    @IBOutlet weak var box4: BEMCheckBox!
    @IBOutlet weak var box5: BEMCheckBox!
    @IBOutlet weak var box6: BEMCheckBox!
    @IBOutlet weak var rushSwitch: UISwitch!
    @IBOutlet weak var recSwitch: UISwitch!
    @IBOutlet weak var termsBox: BEMCheckBox!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    let uid = Auth.auth().currentUser?.uid
    //    fileprivate let cellAnumationDuration: Double = 0.25
//    fileprivate let animationDelayStep: Double = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstView.isHidden = false
        secondView.isHidden = true
        thirdView.isHidden = true
        submitBtn.isEnabled = false
        termsBox.delegate = self
        box1.delegate = self
        box2.delegate = self
        box3.delegate = self
        box4.delegate = self
        box5.delegate = self
        box6.delegate = self
        modelTextfield.delegate = self
        
        refRequests = Database.database().reference().child("request").child(uid!);
    }

    
    @IBAction func submitClick(_ sender: UIButton) {
        addArtist()
        
    }
    
    
    func textFieldShouldReturn(_ modelTextfield: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    
    
    func addArtist(){
        let key = refRequests.childByAutoId().key
        
        let request = ["id":key as String, "device": deviceLabel as String, "type": typeLabel as String, "model": modelTextfield.text!, "BrokenScreen": box1.on as Bool, "BatteryReplace": box2.on as Bool, "Other": box3.on as Bool, "VerySlow": box4.on as Bool, "Spy": box5.on as Bool, "Network": box6.on as Bool, "Rush": rushSwitch.isOn as Bool, "Record": recSwitch.isOn as Bool, "Status": "0" as String, "Date": ServerValue.timestamp()] as [String : Any]
        refRequests.child(key).setValue(request)
        SVProgressHUD.dismiss()
        SVProgressHUD.showSuccess(withStatus: "Request Sent")
        
        SVProgressHUD.dismiss(withDelay: 2)
        navigationController?.popViewController(animated: true)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        print("User tapped \(checkBox.tag): \(checkBox.on)")
        
        if termsBox.on == true && (box1.on == true || box2.on == true || box3.on == true || box4.on == true || box5.on == true || box6.on == true)  {
            submitBtn.isEnabled = true
            
        } else {
            submitBtn.isEnabled = false
        }
    }
    
    
    
    
}

extension RequestViewController: UICollectionViewDataSource {
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 4
        }
        else {
            switch deviceLabel {
            case "Mobile":
                return mobiles.count
            case "Tablet":
                return tablets.count
            case "Computer":
                return computers.count
            case "Smart Watch":
                return smartwatchs.count
            default:
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RequestCollectionViewCell
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        var trying = "Mobile"
        switch myArray[indexPath.row] {
            
        case "Mobile":
            trying = "MobileRequest"
        case "Tablet":
            trying = "TabletRequest"
        case "Computer":
            trying = "ComputerRequest"
        case "Smart Watch":
            trying = "WatchRequest"
        default:
            trying = "Mobile"
        }
        
        let image = UIImage(named:  trying)
        cell.configure(withImage: image!)
        cell.layer.cornerRadius = 20
        return cell
        }
            else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RequestCollectionViewCell
            cellB.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap2(_:))))
        var trying2 = "Mobile"
        switch deviceLabel {
        case "Mobile":
            trying2 = mobiles[indexPath.row]
        case "Tablet":
            trying2 = tablets[indexPath.row]
        case "Computer":
            trying2 = computers[indexPath.row]
        case "Smart Watch":
            trying2 = smartwatchs[indexPath.row]
        default:
            trying2 = "Mobile"
        }
        let image2 = UIImage(named:  trying2)
        cellB.configure2(withImage: image2!)
        return cellB
        }
        
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        if let index = indexPath {
            switch index {
            case [0, 0]:
                deviceLabel = "Mobile"
                self.collectionViewB!.reloadData()
                firstView.isHidden = true
                secondView.isHidden = false
            case [0, 1]:
                deviceLabel = "Computer"
                self.collectionViewB!.reloadData()
                firstView.isHidden = true
                secondView.isHidden = false
            case [0, 2]:
                deviceLabel = "Tablet"
                self.collectionViewB!.reloadData()
                firstView.isHidden = true
                secondView.isHidden = false
            case [0, 3]:
                deviceLabel = "Smart Watch"
                self.collectionViewB!.reloadData()
                firstView.isHidden = true
                secondView.isHidden = false
            default:
                print("")
            }

        }
    }
    
    
    @objc func tap2(_ sender: UITapGestureRecognizer) {
        
        let location2 = sender.location(in: self.collectionViewB)
        let indexPath2 = self.collectionViewB.indexPathForItem(at: location2)
        if let index = indexPath2 {
            switch index {
            case [0, 0]:
                if deviceLabel == "Mobile" {
                    typeLabel = "iPhone"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Tablet" {
                    typeLabel = "iPad"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Computer" {
                    typeLabel = "MacBook"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Smart Watch" {
                    typeLabel = "Apple Watch"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }

            case [0, 1]:
                if deviceLabel == "Mobile" {
                    typeLabel = "Samsung"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Tablet" {
                    typeLabel = "Fire"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Computer" {
                    typeLabel = "Laptop"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Smart Watch" {
                    typeLabel = "Samsung Watch"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
            case [0, 2]:
                if deviceLabel == "Mobile" {
                    typeLabel = "Nokia"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Tablet" {
                    typeLabel = "Samsung Tabler"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Computer" {
                    typeLabel = "PC"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Smart Watch" {
                    typeLabel = ""
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
            case [0, 3]:
                if deviceLabel == "Mobile" {
                    typeLabel = "Huawei"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Tablet" {
                    typeLabel = ""
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Computer" {
                    typeLabel = "iMac"
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
                if deviceLabel == "Smart Watch" {
                    typeLabel = ""
                    firstView.isHidden = true
                    secondView.isHidden = true
                    thirdView.isHidden = false
                }
            default:
                print("")
            }
        }
        
        
        
        
    }

    
}

extension RequestViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
        return CGSize(width: 177, height: 253
        )
        } else {
            return CGSize(width: 177, height: 177)
        }
    }
    
}


//extension RequestViewController {
//
//    func prepareVisibleCellsForAnimation() {
//        collectionView.visibleCells.forEach {
//            $0.frame = CGRect(
//                x: -$0.bounds.width,
//                y: $0.frame.origin.y,
//                width: $0.bounds.width,
//                height: $0.bounds.height
//            )
//            $0.alpha = 0
//        }
//    }
//
//    func animateVisibleCells() {
//        collectionView.visibleCells.enumerated().forEach { offset, cell in
//            cell.alpha = 1
//            UIView.animate(
//                withDuration: self.cellAnumationDuration,
//                delay: Double(offset) * self.animationDelayStep,
//                options: .curveEaseOut,
//                animations: {
//                    cell.frame = CGRect(
//                        x: 0,
//                        y: cell.frame.origin.y,
//                        width: cell.bounds.width,
//                        height: cell.bounds.height
//                    )
//            })
//        }
//    }
//}


//
//    @IBOutlet weak var nextButton: UIBarButtonItem!
//    @IBOutlet weak var progressView: GradientProgressBar!
//    @IBOutlet weak var deviceImage: UIImageView!
//    let button = FlatButton()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        customPickerView.title.text = "Device"
//        customPickerView.leftButton.isHidden = true
//        customPickerView.leftButton.setTitle("Cancel", for: .normal)
//        customPickerView.rightButton.setTitle("Done", for: .normal)
//        customPickerView.blackBackground = false
//        progressView.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
//        progressView.animationDuration = 2.0
//        progressView.setProgress(0.25, animated: true)
//        nextButton.isEnabled = false
//        
//        button.color = #colorLiteral(red: 0.3678899407, green: 0.3551638722, blue: 0.5831567645, alpha: 1)
//        button.highlightedColor = #colorLiteral(red: 0.6463815789, green: 0.7103721217, blue: 1, alpha: 1)
//        button.cornerRadius  = 5
//        view.addSubview(button)
//        button.frame = CGRect(x: 16, y: 300, width: view.frame.width - 32, height: 50)
//        button.setTitle("Choose Device:", for: .normal)
//        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
//        customPickerView.setDidScrollHandler({ [weak self] (view, chosenIndex, chosenItem) -> (shouldHide: Bool, animated: Bool) in
//            let hide = false
//            let animated = true
//            self?.button.setTitle(chosenItem, for: .normal)
//            self?.nextButton.isEnabled = true
//            var image = UIImage(named: "colour2")
//            
//            switch self?.button.currentTitle {
//                
//            case "Mobile"?:
//                image = UIImage(named: "Mobile")
//                _ = UIImageView(image: image!)
//            case "Tablet"?:
//                image = UIImage(named: "Tablet")
//                _ = UIImageView(image: image!)
//            case "Computer"?:
//                image = UIImage(named: "Computer")
//                _ = UIImageView(image: image!)
//            case "Smart Watch"?:
//                image = UIImage(named: "Smart watch")
//                _ = UIImageView(image: image!)
//            case "Other"?:
//                image = UIImage(named: "Other")
//                _ = UIImageView(image: image!)
//                
//            default:
//                ""
//            }
//            
//            self?.deviceImage.image = image
//            return (hide, animated)
//        })
//        
//    }
//    
//    @IBAction func nextButton(_ sender: Any) {
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "RequestViewControllerTwo") as! RequestViewControllerTwo
//        myVC.stringPassed = button.currentTitle!
//        navigationController?.pushViewController(myVC, animated: true)
//    }
//
//    @objc func handleButton() {
//        customPickerView.show(viewController: nil, animated: true)
//
//    }
//
//
//    
//    
//    lazy var customPickerView: ELCustomPickerView<String> = {
//        return ELCustomPickerView<String>(pickerType: .singleComponent, items: [
//            "Mobile"
//            , "Tablet"
//            , "Computer"
//            , "Smart Watch"
//            , "Other"
//            ])
//    }()
//    
//
//    
//    
//}

