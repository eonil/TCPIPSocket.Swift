//
//  main.swift
//  TCPIPSocket
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation


//	Make socket.
let	s	=	TCPIPSocket()

//	Make file handler for I/O.
let	f	=	NSFileHandle(fileDescriptor: s.socketDescriptor)

s.connect(TCPIPSocketAddress(173, 194, 127, 231), 80)

f.writeData(("GET / HTTP/1.0\n\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)

let	d	=	f.readDataToEndOfFile()

println(NSString(data: d, encoding: NSUTF8StringEncoding)!)
