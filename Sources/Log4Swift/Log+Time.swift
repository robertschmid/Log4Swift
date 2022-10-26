//
//  File.swift
//  
//
//  Created by Robert Schmid on 10/6/22.
//

import Foundation

//TODO: Convert to subclass?
extension Log
{
	private func addTimerMark(key: TimerKey)
	{
		customQueue.async(flags: .barrier) {
			self._timerMap[key] = Date()
		}
	}
	
	private func removeTimerMark(forKey: TimerKey) -> Date?
	{
		return customQueue.sync(flags: .barrier) {
			return self._timerMap.removeValue(forKey: forKey)
		}
	}
	
	public func markTimerStart(file: String = #file, funcName: String = #function, line: Int = #line, blockId: String = "", msg: String = "")
	{
		addTimerMark(key: TimerKey(file: file, funcName: funcName, line: line, blockId: blockId))
		fLog(file: file, funcName: funcName, line: line, level: .TIME, format: "\(msg)", args: [])
	}
	
	public func markTime(file: String = #file, funcName: String = #function, line: Int = #line, blockId: String = "", msg: String)
	{
		let end = Date()
		if let newKey = startKey(file: file, funcName: funcName, line: line, blockId: blockId),
		   let start = self._timerMap[newKey]
		{
			let duration = end.timeIntervalSince(start)
			let durStr = TimeString.shared.duration(from: duration)
			let dateStr:String = TimeFormats.shared.from(date: end)
			
			fLog(file: file, funcName: funcName, line: line, level: .TIME, format: "\(msg) at \(dateStr) (\(durStr))", args: [])
		}
	}
	
	public func markTimerEnd(file: String = #file, funcName: String = #function, line: Int = #line, blockId: String = "", msg: String)
	{
		let end = Date()
		if let newKey = startKey(file: file, funcName: funcName, line: line, blockId: blockId),
		   let start = removeTimerMark(forKey: newKey)
		{
			let duration = end.timeIntervalSince(start)
			let durStr = TimeString.shared.duration(from: duration)
			let dateStr:String = TimeFormats.shared.from(date: end)
			
			fLog(file: file, funcName: funcName, line: line, level: .TIME, format: "\(msg) at \(dateStr) (\(durStr))", args: [])
		}
	}
	
	private func startKey(file: String, funcName: String, line: Int, blockId: String) -> TimerKey?
	{
		let newKey = TimerKey(file: file, funcName: funcName, line: line, blockId: blockId)
		let possibleKeys = timerMap.keys.filter { $0.candidateMatch(newKey: newKey) }

		if var closestKey = possibleKeys.first
		{
			if possibleKeys.count > 1
			{
				possibleKeys.forEach { key in
					if key != closestKey && key.line > closestKey.line
					{
						closestKey = key
					}
				}
			}
			return closestKey
		}
		return nil
	}
}
