//
//  ViewController.swift
//  helloWorld
//
//  Created by lidengke on 2020/06/04.
//  Copyright © 2020 lidengke. All rights reserved.
//

import UIKit
import AVFoundation

class HomeController: UIViewController,AVAudioPlayerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    var menuOut = false
    
    var resourceManager : ResourcesManager = ResourcesManager()
    
    @IBAction func menuTapped(_ sender: Any) {
        if menuOut == false {
                   trailing.constant = -150
                   leading.constant = 150
                   menuOut = true
               }else{
                   trailing.constant = 0
                   leading.constant = 0
                   menuOut = false
               }
               UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                   self.view.layoutIfNeeded()
               }, completion: nil)
    }
    
    @IBOutlet weak var playAndPause: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var audioItemNum = 0
    
    func preparePlay(url: URL){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
//            audioPlayer?.numberOfLoops = -1
            let audioSession = AVAudioSession.sharedInstance();
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            }catch{
                print(error)
            }
        } catch {
            // couldn't load file :(
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioItemNum=(audioItemNum + 1) % self.resourceManager.getResources().count
        let url = self.resourceManager.getResources()[audioItemNum]
        print(url.absoluteURL)
        preparePlay(url:url)
        audioPlayer?.play()
    }
    
    func pauseAudio(){
        audioPlayer?.pause()
        playAndPause.setTitle("Play", for: .normal)
        disableSchedule()
    }
    
    func playAudio(){
        playAndPause.setTitle("Pause", for: .normal)
        audioPlayer?.play()
        enableSchedule()
    }
    
    @IBAction func play(_ sender: UIButton) {
        if(audioPlayer?.isPlaying ?? false){
            pauseAudio()
        }else{
            if(audioPlayer == nil){
                let url = self.resourceManager.getResources()[0]
                print(url.absoluteURL)
                preparePlay(url:url)
            }
            playAudio()
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stoptimeField.delegate = self
        stoptimeField.returnKeyType = .done
        stoptimeField.keyboardType = .numberPad
        stoptimeField.addDoneButtonOnKeyBoardWithControl()
        
        // listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name:UIResponder.keyboardWillShowNotification,object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name:UIResponder.keyboardWillHideNotification,object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name:UIResponder.keyboardWillChangeFrameNotification,object: nil)
    }
    
    deinit {
        // stop listening for keyboard hide/show
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillChangeFrameNotification,object: nil)
    }
    
    @objc func keyBoardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue )?.cgRectValue else{return}
        if notification.name == UIResponder.keyboardWillHideNotification {
            view.frame.origin.y = 0
        }else{
            view.frame.origin.y = -keyboardRect.height
        }
        print(notification.name)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        stoptimeField.resignFirstResponder()
    }
    
    func enableSchedule(){
        stoptimeField.isUserInteractionEnabled = true
        stoptimeField.backgroundColor = UIColor.white
        stopTimeSwitch.isEnabled = true
        stopTimeSwitch.alpha = 1.0
    }
    
    func disableSchedule(){
        stoptimeField.isUserInteractionEnabled = false
        stoptimeField.backgroundColor = UIColor.lightGray
        stopTimeSwitch.isEnabled = false
        stopTimeSwitch.alpha = 0.5
        stopTimeSwitch.isOn = false
        playStatus.text = "Schedule Inactive"
        
    }
    
    // play schedule
    
    @IBOutlet weak var playStatus: UILabel!
    
    
    @IBOutlet weak var stoptimeField: UITextField!
    
    var playTimer: Timer?
    
    @IBOutlet weak var stopTimeSwitch: UISwitch!
    @IBAction func scheduleSwitch(_ sender: UISwitch) {
        let switchOn = sender.isOn;
        if(switchOn){
            startCountDown()
        }else{
            playTimer?.invalidate()
            playStatus.text = "Schedule Inactive"
        }
    }
    
     func startCountDown() {
        let mins = Double(stoptimeField.text ?? "10") ?? 10
        self.playStatus.text = "will stop after" + (stoptimeField.text ?? "10")
        let startDate = Date()
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: Int(mins), to: startDate)!
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        
        playStatus.text = "Stop at \(hour) : \(minute): \(second)"
            
        
        playTimer = Timer.scheduledTimer(withTimeInterval: mins*60.0, repeats: false) { timer in
            print("Timer fired!")
            self.pauseAudio()
        }
    }
}

extension UITextField {
    func addDoneButtonOnKeyBoardWithControl() {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    keyboardToolbar.sizeToFit()
    keyboardToolbar.barStyle = .default
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.endEditing(_:)))
    keyboardToolbar.items = [flexBarButton, doneBarButton]
    self.inputAccessoryView = keyboardToolbar
    }
}

