//
//  TimeFormats.shared.swift
//  Treadmill
//
//  Created by Robert Schmid on 8/13/18.
//  Copyright © 2018 Robert Schmid. All rights reserved.
//

import Foundation

public class TimeFormats
{
	public static let shared = TimeFormats()
	
	//NOTE: The DateFormatter has a terrible memory leak.  I need to create a more specialized, lightweight version to fit my needs.
	private let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
	var dateFormatters: [DateFormatter] = []
	private let formats = ["yyyy-MM-dd'T'HH:mm:ss.SSSSSSSX",
						   "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX",
						   "yyyy-MM-dd'T'HH:mm:ss.SSSX"]
	private let timeWithHours = DateFormatter()
	public let shortTime = DateFormatter()
	
	private init()
	{
		for format in formats
		{
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = format;
			self.dateFormatters.append(dateFormatter)
		}
		
		timeWithHours.timeZone = TimeZone(secondsFromGMT: 0)
		timeWithHours.dateFormat = "HH:mm:ss.SSS"
		shortTime.timeZone = TimeZone(secondsFromGMT: 0)
		shortTime.dateFormat = "mm:ss.SSS"

	}

	public func dateFrom(_ hhmmss: String) -> Date
	{
		let minSec = hhmmss.trimmingCharacters(in: .punctuationCharacters).components(separatedBy: ":")
		var hh = 0.0
		var mm = 0.0
		var ss = 0.0
		
		switch minSec.count
		{
			case 3:
				hh = Double(minSec[0])! * 3600
				mm = Double(minSec[1])! * 60
				ss = Double(minSec[2])!
				break
			case 2:
				mm = Double(minSec[0])! * 60
				ss = Double(minSec[1])!
				break
			case 1:
				ss = Double(minSec[0])!
				break
			default:
				break
		}
		return referenceDate.addingTimeInterval(TimeInterval(hh + mm + ss))
	}
	
	public func from(date: Date) -> String
	{
		if date.timeIntervalSinceReferenceDate < 3600
		{
			return shortTime.string(from: date)
		}
		return timeWithHours.string(from: date)
	}
	
	func atr(at: Double, before: Double) -> String
	{
		let df = before > 3600 ? timeWithHours : shortTime
		let date = Date(timeIntervalSince1970: at)
		return df.string(from: date)
	}
}
