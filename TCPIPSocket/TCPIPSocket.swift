//
//  TCPIPSocket.swift
//  TCPIPSocket
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation










///	Regular type for IPv4 address.
struct TCPIPSocketAddress {
	//	Compiler doesn't like this code. 
//	init(_ bytes: (UInt8, UInt8, UInt8, UInt8)) {
//		let	a1	=	UInt32(bytes.0) << 24
//		let	b1	=	UInt32(bytes.1) << 16
//		let	c1	=	UInt32(bytes.2) << 8
//		let	d1	=	UInt32(bytes.3) << 0
//		_number	=	a1 + b1 + c1 + d1
//	}
	///	Creates an address with 4 separated numbers.
	///	The numbers must be ordered in network-endian. (MSB left)
	init(_ a:UInt8, _ b:UInt8, _ c:UInt8, _ d:UInt8) {
		let	a1	=	UInt32(a) << 24
		let	b1	=	UInt32(b) << 16
		let	c1	=	UInt32(c) << 8
		let	d1	=	UInt32(d) << 0
		
		_number	=	a1 + b1 + c1 + d1
	}
	private let	_number:UInt32		///	Uses host-endian.
}










///	Make a `NSFileHandle` to perform I/O to this socket.
///	See `socketDescriptor` for details.
final class TCPIPSocket {
	
	///	You can treat this as a file-descriptor and this value can be used
	///	to create a `NSFileHandle` object.
	let	socketDescriptor:Int32
	
	init() {
		let	r	=	socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)
		postconditionDarwinAPICallResultCodeState(r != -1)

		socketDescriptor	=	r
	}
	deinit {
		let	r	=	close(socketDescriptor)
		postconditionDarwinAPICallResultCodeState(r == 0)
	}

	///	Connect to specified address and port.
	///	You need to resolve domain name into integer address before passing it into here.
	func connect(address: UInt32, _ port: UInt16) {
		func cast(p:UnsafePointer<sockaddr_in>) -> UnsafePointer<sockaddr> {
			return	UnsafePointer<sockaddr>(p)
		}
		
		let	f		=	sa_family_t(AF_INET)
		let	p		=	in_port_t(port.networkEndian)
		let	a		=	in_addr(s_addr: address.networkEndian)
		var	addr	=	sockaddr_in(sin_len: 0, sin_family: f, sin_port: p, sin_addr: a, sin_zero: (0,0,0,0,0,0,0,0))
		let	sz		=	socklen_t(sizeofValue(addr))
		let	r		=	Darwin.connect(socketDescriptor, unsafePointerCast(&addr), sz)
		postconditionDarwinAPICallResultCodeState(r == 0)
	}
}

//protocol SocketType {
////	func send()
////	func receive()
//}
//protocol ServerSocketType {
////	func bind()
////	func listen()
////	func accept()
//}
//protocol ClientSocketType {
//	///	Do not swap endianness of passing-in parameters.
//	///	Just use host byte-endian. This function will handle the endianness.
//	func connect(address: UInt32, port: UInt16)
//}
//
//
//
//
//extension TCPIPSocket: SocketType {
//	
//}
//extension TCPIPSocket: ServerSocketType {
//	
//}
//extension TCPIPSocket: ClientSocketType {
//	
//}


































///	MARK:
///	MARK:	Extensions

extension TCPIPSocketAddress {
	static let	localhost	=	TCPIPSocketAddress(127,0,0,1)
	
	//	///	Resolves a hostname to an address synchronously.
	//	///	BEWARE! This resolution may take very long if the name is not yet cached in local machine,
	//	///	and caller will be blocked until resolution finishes.
	//	static func resolve(hostname:String) -> TCPIPSocketAddress {
	//
	//	}
}

extension TCPIPSocket {
	///	http://en.wikipedia.org/wiki/Nagle%27s_algorithm
	///	http://stackoverflow.com/questions/7286592/set-tcp-quickack-and-tcp-nodelay
	var noDelay:Bool {
		get {
			var	v	=	UInt32(0)
			var	sz	=	socklen_t(sizeof(UInt32))
			var	r	=	getsockopt(self.socketDescriptor, IPPROTO_TCP, TCP_NODELAY, &v, &sz)
			postconditionDarwinAPICallResultCodeState(r == 0)
			return	v != 0
		}
		set(v) {
			var	v1	=	UInt32(v ? 1 : 0)
			let	sz	=	socklen_t(sizeof(Int32))
			let	r	=	setsockopt(self.socketDescriptor, IPPROTO_TCP, TCP_NODELAY, &v1, sz)
			postconditionDarwinAPICallResultCodeState(r == 0)
		}
	}
}

extension TCPIPSocket {
	///	Connect using regular address object.
	func connect(address:TCPIPSocketAddress, _ port:UInt16) {
		self.connect(address._number, port)
	}
}


extension TCPIPSocket {
	///	Creates a file handle using socket descriptor.
	///	So you can perform socket I/O using the file I/O interface.
	///	The file handle does not own the socket. The socket will be closed
	///	when the socket object dies, so you're responsible to keep the socket
	///	alive while the file handle object alive.
	func instantiateFileHandle() -> NSFileHandle {
		return	NSFileHandle(fileDescriptor: socketDescriptor, closeOnDealloc: false)
	}
}









































///	MARK:
///	MARK:	Darwin Utility

private func postconditionDarwinAPICallResultCodeState(ok:Bool) {
	if !ok {
		let	n	=	Darwin.errno
		let	p	=	strerror(n)
		let	s	=	String(UTF8String: p)
		fatalError("Darwin API call error: (\(n)) \(s)")
	}
}








































///	MARK:
///	MARK:	Swift+TCPIPSocket

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



private func unsafePointerCast<T,U>(p:UnsafePointer<T>) -> UnsafePointer<U> {
	return	UnsafePointer<U>(p)
}














