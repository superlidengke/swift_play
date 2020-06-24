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
    
    @IBOutlet weak var downloadProgressBar: UIProgressView!
    
    
    @IBAction func download(_ sender: Any) {
        tipLabel.text = "Download begins"
        let url = URL(string: urlField.text!)!
        let mURLSession = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
        mURLSession.downloadTask(with: URL.init(string: url.absoluteString)!).resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Download File"
        
        urlField.delegate = self
        urlField.returnKeyType = .done
        
        downloadProgressBar.setProgress(0, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


extension DownloadController:URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileManager = FileManager.default
        let newsURL = self.getDocumentsDirectory().appendingPathComponent("news.mp3")
        do {
            try? FileManager.default.removeItem(at: newsURL)
            try _ = fileManager.copyItem(at:location, to: newsURL)

        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        self.tipLabel.text = "Download completed!"

    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        DispatchQueue.main.async {
            let currentProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            self.downloadProgressBar.setProgress( currentProgress,animated: false)
        }
        
    }
    
}

