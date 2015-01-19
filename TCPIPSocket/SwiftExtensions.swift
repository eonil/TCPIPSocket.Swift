//
//  SwiftExtensions.swift
//  TCPIPSocket
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//



extension UInt16 {
	var networkEndian:UInt16 {
		get {
			return	bigEndian
		}
	}
}

extension UInt32 {
	var networkEndian:UInt32 {
		get {
			return	bigEndian
		}
	}
}

extension UInt64 {
	var networkEndian:UInt64 {
		get {
			return	bigEndian
		}
	}
}






func unsafePointerCast<T,U>(p:UnsafePointer<T>) -> UnsafePointer<U> {
	return	UnsafePointer<U>(p)
}




















