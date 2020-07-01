//
//  ResourcesManager.swift
//  helloWorld
//
//  Created by lidengke on 2020/07/01.
//  Copyright © 2020 lidengke. All rights reserved.
//

import Foundation

public class ResourcesManager {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getResources() -> [URL] {
        var fileURLs = [URL]()
        do {
            fileURLs = try FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil)
        }catch{
            NSLog("Error while enumerating files at getDocumentsDirectory")
        }
        return fileURLs
    }   
}
