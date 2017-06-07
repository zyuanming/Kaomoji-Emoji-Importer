//
//  NSData+EnumerateComponents.swift
//  Importer
//
//  Created by Zhang Yuanming on 7/25/16.
//  Copyright © 2016 ZhangYuanming. All rights reserved.
//

import Foundation

extension Data {
    func enumerateComponents(separateBy delimiter: Data, usingBlock block: ((_ data: Data, _ finalBlock: Bool) -> Void)) {
        var loc: Int = 0
        while true {
            if let rangeOfNewLine: Range = self.range(of: delimiter, options: [], in: Range(loc..<self.count)) {
                let rangeWithDelimiter: Range = Range(loc..<rangeOfNewLine.lowerBound + delimiter.count)
                let chunkWithDelimiter: Data = self.subdata(in: rangeWithDelimiter)
                block(chunkWithDelimiter, false)
                loc = rangeWithDelimiter.upperBound
            } else {
                break
            }
        }
        let remainder = self.subdata(in: Range(loc..<self.count))
        block(remainder, true)
    }
    
    init(uints:[UInt8]) {
        self.init(bytes:uints, count:uints.count)
    }
}
