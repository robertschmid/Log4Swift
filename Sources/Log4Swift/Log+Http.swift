//
//  File.swift
//  
//
//  Created by Robert Schmid on 10/25/22.
//

import Foundation

//TODO: Convert to subclass?
extension Log
{
	public func session(request: URLRequest, file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [])
	{
		if Level.SESSION.meets(threshold: threshold)
		{
			var reqLog = "\n\n    BEGIN HTTP REQUEST >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
			reqLog.append("        \(request.httpMethod!): \(request.url!)\n")
			for header in request.allHTTPHeaderFields!
			{
				reqLog.append("            \(header.key): \(header.value)\n")
			}
			if let body = request.httpBody, let raw = String(data: body, encoding: String.Encoding.utf8)
			{
				reqLog.append("            \(raw)\n")
			}
			reqLog.append("    END HTTP REQUEST >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n")
			fLog(file: file, funcName: funcName, line: line, level: .DEBUG, format: reqLog, args: args)
		}
	}
	
	public func session(response: URLResponse?, data: Data?, error: Error? = nil,
					  file: String = #file, funcName: String = #function, line: Int = #line, args:CVarArg = [])
	{
		if Level.SESSION.meets(threshold: threshold), let resp = response as? HTTPURLResponse
		{
			var respLog = "\n\n    BEGIN HTTP RESPONSE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
			for header in resp.allHeaderFields
			{
				respLog.append("            \(header.key): \(header.value)\n")
			}
			if let d = data, let raw = String(data: d, encoding: String.Encoding.utf8)
			{
				respLog.append("            \(raw)\n")
			}
			respLog.append("    END HTTP RESPONSE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n")
			fLog(file: file, funcName: funcName, line: line, level: .DEBUG, format: respLog, args: args)
		}
	}


}
