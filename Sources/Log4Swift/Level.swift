//
//  File.swift
//  
//
//  Created by Robert Schmid on 10/6/22.
//

import Foundation

public struct Level: OptionSet
{
	public let rawValue: UInt8
	
	public static let OFF = Level(rawValue: 1 << 7)
	public static let DATA_DUMPS = Level(rawValue: 1 << 6)
	public static let TIME = Level(rawValue: 1 << 5)
	public static let SPECIAL = Level(rawValue: 1 << 4)
	
	public static let ERROR = Level(rawValue: 1 << 3)
	public static let WARN = Level(rawValue: 1 << 2)
	public static let INFO = Level(rawValue: 1 << 1)
	public static let DEBUG = Level(rawValue: 1)


	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	public func meets(threshold: Level) -> Bool
	{
		return threshold.contains(self) || meets(degree: threshold)
	}
	
	public func isOn() -> Bool
	{
		return !self.meets(threshold: .OFF)
	}
	
	private func meets(degree: Level) -> Bool
	{
		let minLvl = degree.rawValue % Level.SPECIAL.rawValue
		let selfLvl = self.rawValue % Level.SPECIAL.rawValue
		return selfLvl >= minLvl
	}
}
