//
//  Log.swift
//  Log
//
//  Created by Roland Tolnay on 17/05/2018.
//

import Foundation
import SwiftyBeaver

public var log = { () -> SwiftyBeaver.Type in
  
  let beaverLog = SwiftyBeaver.self
  
  let console = ConsoleDestination()
  console.levelColor.error = "❌ "
  console.levelColor.warning = "⚠️ "
  console.levelColor.info = "ℹ️ "
  console.levelColor.debug = "🔸 "
  console.levelColor.verbose = " "
  console.minLevel = .verbose
  
  #if !DEBUG
    
    if let documentsPath = try? FileManager.default.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: true),
      let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
      let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
      
      let fileName = "Cooker-\(appVersion)(\(buildVersion)).log"
      let fileUrl = documentsPath.appendingPathComponent(fileName)
      let file = FileDestination()
      file.logFileURL = fileUrl
      file.format = "$Ddd.MM.yyyy HH:mm:ss$d $L $N.$F:$l - $M"
      beaverLog.addDestination(file)
    }
  #endif
  
  beaverLog.addDestination(console)
  
  return beaverLog
}()

public class Log: NSObject {

  @objc open class func debug(_ message: String, filePath: String, function: String, line: Int) {

    log.debug(message, filePath, convertFunction(function), line: line, context: nil)
  }

  // CREDIT: https://github.com/SwiftyBeaver/SBObjectiveCWrapper/blob/master/Sources/SBObjectiveCWrapper.swift
  private class func convertFunction(_ function: String) -> String {
    var strippedFunction = function

    if let match = function.range(of: "\\w+:*[\\w*:*]*]", options: .regularExpression) {
      let endIndex = function.index(before: match.upperBound)
      let functionParts = function[match.lowerBound..<endIndex].components(separatedBy: ":")

      guard !functionParts.isEmpty else { return function }

      for (index, part) in functionParts.enumerated() {
        switch index {
        case 0:
          strippedFunction = part
          if functionParts.count > 1 { strippedFunction += "(_:" }
        default:
          if !part.isEmpty {
            strippedFunction += "\(part):"
          }
        }
      }
      if functionParts.count > 1 {
        strippedFunction += ")"
      } else if functionParts.count == 1 {
        strippedFunction += "()"
      }

    }
    return strippedFunction
  }
}

public func assertError(_ error: Error,
                        message: String? = nil,
                        _ file: String = #file,
                        _ function: String = #function,
                        _ line: Int = #line) {

  let logMessage = message.map { "\($0): \(error.localizedDescription)" } ?? error.localizedDescription
  log.error(logMessage, file, function, line: line)
  assertionFailure(logMessage)
}
