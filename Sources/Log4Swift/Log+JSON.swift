//
//  Log+JSON.swift
//  
//
//  Created by Robert Schmid on 10/6/22.
//

import Foundation

//TODO: Convert to subclass?
extension Log
{
	@objc public func debugJSONObjc(json: Data?)
	{
		if let data = json, let raw = String(data: data, encoding: String.Encoding.utf8)
		{
			fLog(file: "", funcName: "", line: 0, level: .DEBUG, format: raw, args: [])
		}
	}
	
	public func debugJson(json: Data?, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [])
	{
		if let data = json, let raw = String(data: data, encoding: String.Encoding.utf8)
		{
			fLog(file: file, funcName: funcName, line: line, level: .DEBUG, format: raw, args: args)
		}
	}
	
	public func errorJson(json: Data?, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [])
	{
		if let data = json, let raw = String(data: data, encoding: String.Encoding.utf8)
		{
			fLog(file: file, funcName: funcName, line: line, level: .ERROR, format: raw, args: args)
		}
	}
}
