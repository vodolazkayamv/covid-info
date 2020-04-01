//
//  Logger.swift
//  covidInfo
//
//  Created by Masha Vodolazkaya on 30/03/2020.
//  Copyright © 2020 Мария Водолазкая. All rights reserved.
//

import Foundation

class Logger {
    class func error(_ message: String,
                   function: String = #function,
                   file: String = #file,
                   line: Int = #line) {
        
        let url = NSURL(fileURLWithPath: file)
        
        print("!!! Error \"\(message)\" \n ↳ (File: \(url.lastPathComponent ?? "?"), Function: \(function), Line: \(line)) \n")
    }
    class func warning(_ message: String,
                   function: String = #function,
                   file: String = #file,
                   line: Int = #line) {
        
        let url = NSURL(fileURLWithPath: file)
        
        print("WARNING: \"\(message)\" \n ↳(File: \(url.lastPathComponent ?? "?"), Function: \(function), Line: \(line)) \n")
    }
    class func log(_ message: String,
                   function: String = #function,
                   file: String = #file,
                   line: Int = #line) {
        
        let url = NSURL(fileURLWithPath: file)
        
        print("\"\(message)\" \n ↳(File: \(url.lastPathComponent ?? "?"), Function: \(function), Line: \(line)) \n")
    }
}
