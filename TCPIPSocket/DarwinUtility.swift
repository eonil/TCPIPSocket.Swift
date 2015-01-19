//
//  DarwinUtility.swift
//  TCPIPSocket
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation


func postconditionDarwinAPICallResultCodeState(ok:Bool) {
	if !ok {
		let	n	=	Darwin.errno
		let	p	=	strerror(n)
		let	s	=	String(UTF8String: p)
		fatalError("Darwin API call error: (\(n)) \(s)")
	}
}







