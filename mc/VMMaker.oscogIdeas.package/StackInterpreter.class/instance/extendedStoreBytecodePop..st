stack bytecodes
extendedStoreBytecodePop: popBoolean
	| descriptor variableType variableIndex value |
	<inline: true>
	descriptor := self fetchByte.
	variableType := descriptor >> 6 bitAnd: 3.
	variableIndex := descriptor bitAnd: 63.
	value := self internalStackTop.
	popBoolean ifTrue: [ self internalPop: 1 ].
	variableType = 0 ifTrue:
		[objectMemory storePointerImmutabilityCheck: variableIndex ofObject: self receiver withValue: value.
		^ self fetchNextBytecode].
	variableType = 1 ifTrue:
		[ self fetchNextBytecode.
		^self temporary: variableIndex in: localFP put: value].
	variableType = 3 ifTrue:
		[self storeLiteralVariable: variableIndex withValue: value.
		^ self fetchNextBytecode].
	self error: 'illegal store'
