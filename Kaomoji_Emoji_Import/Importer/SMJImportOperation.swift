//
//  SMJImportOperation.swift
//  Importer
//
//  Created by Zhang Yuanming on 7/25/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation
import CoreData

class SMJImportOperation: Operation {
    
    var managedObjectModel: NSManagedObjectModel
    var storeURL: URL
    var dataURL: URL
    
    init(objectModel: NSManagedObjectModel, storeURL: URL, dataURL: URL) {
        managedObjectModel = objectModel
        self.storeURL = storeURL
        self.dataURL = dataURL
        super.init()
    }
    
    override func main() {
        let importer = SMJImporter(persistentStoreURL: storeURL, managedObjectModel: managedObjectModel, dataURL: dataURL)
        importer.startImport()
    }
}
