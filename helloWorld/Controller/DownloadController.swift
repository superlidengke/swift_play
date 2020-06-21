//
//  DownloadController.swift
//  helloWorld
//
//  Created by lidengke on 2020/06/21.
//  Copyright © 2020 lidengke. All rights reserved.
//

import UIKit

class DownloadController: UIViewController,UITextFieldDelegate{
    
      
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var urlField: UITextField!
    
    @IBAction func download(_ sender: Any) {
        tipLabel.text = "Download begins"
        let url = URL(string: urlField.text!)!
        
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
                self.tipLabel.text = "Download completed!"
            }
        }
        
        
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Download File"
        
        urlField.delegate = self
        urlField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
