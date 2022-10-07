//
//  Log.swift
//  Treadmill
//
//  Created by Robert Schmid on 12/10/18.
//  Copyright © 2018 Robert Schmid. All rights reserved.
//

import Foundation
import os
/**
* Helper methods that make logging more consistent throughout the app.  These methods also allow for indentation making
* the logs easier to read when processing a lot of data.  The log calls in ecgmagic are not really intended for external
* use.  These will simply be silent in the absence of an available logging system like CocoaLumberjack or Log4Swift
*/
public class Log
{
	public static let shared = Log()
	private var xLog = Logger(subsystem: COM_AIRSTRIP, category: "configure_this")
	//This was added after os.Logger so it stays
	let customQueue = DispatchQueue(label: "com.airstrip.Log.queue",
											qos: .default, attributes: .concurrent)
	var _timerMap: [TimerKey: Date] = [:]
	var timerMap: [TimerKey: Date]
	{
		get {
				//2. sync read
			return customQueue.sync {
				_timerMap
			}
		}
		set {
				//3. async write
			customQueue.async(flags: .barrier) {
				self._timerMap = newValue
			}
		}
	}
	
	public var useIndenting = false
	//indentation Levels not threshold levels
	private var _levels: [(String, String)] = []

	var levels: [(String, String)]
	{
		get {
				//2. sync read
			return customQueue.sync {
				_levels
			}
		}
		set {
				//3. async write
			customQueue.async(flags: .barrier) {
				self._levels = newValue
			}
		}
	}
	
	private let TAB = "\t"

	var threshold = Level.OFF
	private static let COM_AIRSTRIP = "com.airstrip"


	init()
	{
		if let configURL = Bundle.main.url(forResource: "Log4Swift", withExtension: "config")
		{
			do {
				let data = try Data(contentsOf: configURL, options: .mappedIfSafe)
				let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
				if let jsonResult = jsonResult as? Dictionary<String, AnyObject>
				{
					if let t = jsonResult["threshold"] as? Level
					{
						threshold = t
					}
					if let s = jsonResult["subsystem"] as? String,
					   let c = jsonResult["category"] as? String
					{
						xLog = Logger(subsystem: s, category: c)
					}
				}
			} catch {
			   // handle error
			}
		}
	}
	
	init(processingDir: String, name: String, level: Level)
	{
		threshold = level; //(ERROR | TIMED | PHYSIO);
		if threshold.isOn()
		{
//			file = fopen((processingDir + "/" + name + ".dat").c_str(), "w");
		}
	}
	
	init(threshold: Level)
	{
		self.threshold = threshold
	}


	/**
	logs a debug level statement
	
	-Parameters:
	- from: The object calling the logger (usually just 'self')
	- indent: whether or not to use the internal indentation level. (Useful for highlighting some debugging)
	- format: A string with formatting elements
	- args: The arguments that apply to the format String
	*/
	public func debug(_ format:String, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [])
	{
		fLog(file: file, funcName: funcName, line: line, level: .DEBUG, format: format, args: args)
	}
	
	public func info(_ format:String, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [])
	{
		fLog(file: file, funcName: funcName, line: line, level: .INFO, format: format, args: args)
	}
	
	public func warn(_ format:String, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [])
	{
		fLog(file: file, funcName: funcName, line: line, level: .WARN, format: format, args: args)
	}
	
	public func error(_ format:String, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [])
	{
		fLog(file: file, funcName: funcName, line: line, level: .ERROR, format: format, args: args)
	}
	
	func fLog(file: String, funcName: String, line: Int, level: Level, format:String, args:CVarArg)
	{
		var indentCount: Int = -1
		
		if useIndenting
		{
			if let idx = levels.firstIndex(where: {$0 == (file, funcName)})
			{
				indentCount = idx
			}
			else
			{
				levels.append((file, funcName))
				//TODO: Make this array decrease again
				indentCount = levels.count - 1
			}
		}
		else
		{
			indentCount = 0
		}

		//		if level.rawValue >= threshold.rawValue

		//TODO: The >= needs to be fixed I think
		if (level.rawValue >= threshold.rawValue || (level.rawValue & threshold.rawValue) > 1)
		{
			let fileName = file.components(separatedBy: "/").last!
			let indent = String(repeating: TAB, count: indentCount)
			switch level
			{
					//TODO: Logger levels don't seem to work as I would expect
				case .DEBUG:
					xLog.debug("\(indent)\(format) (\(fileName):\(line))")
					break
				case .INFO:
					xLog.debug("\(indent)\(format) (\(fileName):\(line))")
					break
				case .WARN:
					xLog.debug("\(indent)\(format) (\(fileName):\(line))")
					break
				case .ERROR:
					xLog.error("\(indent)\(format) (\(fileName):\(line))")
					break
				default: break
					//do nothing
			}
		}

	}
}
