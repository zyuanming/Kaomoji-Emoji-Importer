//
//  SMJKaomojiSearchModel.swift
//  Importer
//
//  Created by Zhang Yuanming on 6/15/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation
import CoreData

class SMJKaomojiSearchModel: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var kaomoji: String
    @NSManaged var index: Int32
    var sizeSpace: Int = 0
    
    class func entityName() -> String {
        return "SMJKaomojiSearchModel"
    }
}
