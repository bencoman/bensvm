ARM convenience instructions
ands: destReg rn: srcReg imm: immediate ror: rot
"Remember the ROR is doubled by the cpu so use 30>>1 etc
	ANDS destReg, srcReg, #immediate ROR #rot - ARM_ARM v7 DDI10406 p. A8-34"

	^self type: 1 op: AndOpcode set: 1 rn: srcReg rd: destReg shifterOperand: ((rot>>1) <<8 bitOr: immediate)