primitives
primitiveAccept
	"Primitive. Starts or continues a server handshake using the current session.
	Will eventually produce output to be sent to the client. Requires the host
	and cert name to be set for the session. Returns a code indicating the sate
	of the connection:
		> 0	 - Number of bytes to be sent to the client.
		0	 - Success. The connection is established.
		-1 	 - More input is required.
		< -1 - Other errors.
	"
	| start srcLen dstLen srcOop dstOop handle srcPtr dstPtr result |
	<var: #srcPtr type: #'char *'>
	<var: #dstPtr type: #'char *'>
	<export: true>
	interpreterProxy methodArgumentCount = 5
		ifFalse:[^interpreterProxy primitiveFail].
	dstOop := interpreterProxy stackValue: 0.
	srcLen := interpreterProxy stackIntegerValue: 1.
	start := interpreterProxy stackIntegerValue: 2.
	srcOop := interpreterProxy stackValue: 3.
	handle := interpreterProxy stackIntegerValue: 4.
	interpreterProxy failed ifTrue:[^nil].
	((start > 0 and:[srcLen >= 0])
		and:[(interpreterProxy isBytes: srcOop) 
		and:[(interpreterProxy isBytes: dstOop) 
		and:[(interpreterProxy byteSizeOf: srcOop) >= (start + srcLen - 1)]]])
			ifFalse:[^interpreterProxy primitiveFail].
	srcPtr := interpreterProxy firstIndexableField: srcOop.
	dstPtr := interpreterProxy firstIndexableField: dstOop.
	srcPtr := srcPtr + start - 1.
	dstLen := interpreterProxy byteSizeOf: dstOop.
	result := self cCode: 'sqAcceptSSL(handle, srcPtr, srcLen, dstPtr, dstLen)' 
					inSmalltalk:[handle. srcPtr. srcLen. dstPtr. dstLen. -2].
	interpreterProxy failed ifTrue:[^nil].
	interpreterProxy pop: interpreterProxy methodArgumentCount+1.
	interpreterProxy pushInteger: result.