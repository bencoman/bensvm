initialization
initialize
	"We can put all initializations that set something to 0 or to false here.
	 In C all global variables are initialized to 0, and 0 is false."
	remapBuffer := Array new: RemapBufferSize.
	remapBufferCount := extraRootCount := 0. "see below"
	freeListsMask := totalFreeOldSpace := lowSpaceThreshold := 0.
	checkForLeaks := 0.
	needGCFlag := signalLowSpace := marking := false.
	becomeEffectsFlags := gcPhaseInProgress := 0.
	statScavenges := statIncrGCs := statFullGCs := 0.
	statScavengeGCUsecs := statIncrGCUsecs := statFullGCUsecs := statCompactionUsecs := statGCEndUsecs := 0.
	statSGCDeltaUsecs := statIGCDeltaUsecs := statFGCDeltaUsecs := 0.
	statGrowMemory := statShrinkMemory := statRootTableCount := 0.
	statRootTableOverflows := statMarkCount := statCompactPassCount := statCoalesces := 0.

	"We can initialize things that are allocated but are lazily initialized."
	unscannedEphemerons := SpurContiguousObjStack new.

	"we can initialize things that are virtual in C."
	scavenger := SpurGenerationScavenger simulatorClass new manager: self; yourself.
	segmentManager := SpurSegmentManager simulatorClass new manager: self; yourself.
	compactor := self class compactorClass simulatorClass new manager: self; yourself.

	"We can also initialize here anything that is only for simulation."
	heapMap := CogCheck32BitHeapMap new.

	"N.B. We *don't* initialize extraRoots because we don't simulate it."
	maxOldSpaceSize := self class initializationOptions
							ifNotNil: [:initOpts| initOpts at: #maxOldSpaceSize ifAbsent: [0]]
							ifNil: [0]