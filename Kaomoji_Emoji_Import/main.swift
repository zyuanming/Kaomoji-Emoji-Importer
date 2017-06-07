//
//  main.swift
//  Kaomoji_Emoji_Import
//
//  Created by Zhang Yuanming on 8/8/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation
import CoreData

print("Hello, World!")

func managedObjectModel() -> NSManagedObjectModel {
    let path = "SMJLocalSearch"
//    let modelURL = URL.fileURLWithPath(path, isDirectory: false).URLByAppendingPathExtension("mom")
    let modelURL = URL(fileURLWithPath: path, isDirectory: false).appendingPathExtension("mom")
    return NSManagedObjectModel(contentsOf: modelURL)!
}


do {
    let desktopURL = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//    let storeURL = desktopURL.URLByAppendingPathComponent("test.sqlite")
    let storeURL = desktopURL.appendingPathComponent("test.sqlite", isDirectory: false)
    try? FileManager.default.removeItem(at: storeURL)
    let importer = SMJImporter(persistentStoreURL: storeURL, managedObjectModel: managedObjectModel(), dataURL: desktopURL)
    importer.startImport()
} catch {
    
}
