//
//  main.swift
//  TCPIPSocket
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation








func testSynchronousIO() {
	//	Make socket.
	let	s	=	TCPIPSocket()
	
	//	Make file handle for I/O.
	let	f	=	NSFileHandle(fileDescriptor: s.socketDescriptor)
	s.connect(TCPIPSocketAddress(58, 123, 220, 24), 80)
	f.writeData(("GET / HTTP/1.0\n\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
	let	d	=	f.readDataToEndOfFile()
	print(NSString(data: d, encoding: NSUTF8StringEncoding)!)
}
testSynchronousIO()









func testAsynchronousIO() {
	//	Make socket.
	let	s	=	TCPIPSocket()
	
	//	Make file handle for I/O.
	let	f	=	NSFileHandle(fileDescriptor: s.socketDescriptor)
	s.connect(TCPIPSocketAddress(58, 123, 220, 24), 80)
	var	w	=	false
	f.writeabilityHandler	=	{ (f: NSFileHandle!) -> () in
		if w == false {
			w		=	true
			f.writeData(("GET / HTTP/1.0\n\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
		}
	}
	f.readabilityHandler	=	{ (f: NSFileHandle!) -> () in
		let	s	=	NSString(data: f.availableData, encoding: NSUTF8StringEncoding)!
		print(s)
	}
	sleep(3)
}
testAsynchronousIO()









