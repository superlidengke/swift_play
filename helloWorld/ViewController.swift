//
//  ViewController.swift
//  helloWorld
//
//  Created by lidengke on 2020/06/04.
//  Copyright © 2020 lidengke. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var playAndPause: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    
    func preparePlay(url: URL){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
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
    
    @IBAction func play(_ sender: UIButton) {
        if(audioPlayer?.isPlaying ?? false){
            audioPlayer?.pause()
            sender.setTitle("Play", for: .normal)
        }else{
            sender.setTitle("Pause", for: .normal)
            
            if(audioPlayer == nil){
                let url = self.getDocumentsDirectory().appendingPathComponent("news.mp3")
                print(url.absoluteURL)
                preparePlay(url:url)
            }
            audioPlayer?.play()
        }
    }
    
    
    
    @IBAction func button(_ sender: Any) {
        
        label.text = "Download begins"
        let url = URL(string: nameTextField.text!)!
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localURL = localURL {
                
                print(localURL)
                
                print(self.getDocumentsDirectory())
                let fileManager = FileManager.default
                
                // Copy 'hello.swift' to 'subfolder/hello.swift'
                let newsURL = self.getDocumentsDirectory().appendingPathComponent("news.mp3")
                do {
                    try? FileManager.default.removeItem(at: newsURL)
                    try _ = fileManager.copyItem(at:localURL, to: newsURL)
                    
                }
                catch let error as NSError {
                    print("Ooops! Something went wrong: \(error)")
                }
                self.label.text = "Download completed!"
            }
        }
        
        
        task.resume()
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
    }
    
}

