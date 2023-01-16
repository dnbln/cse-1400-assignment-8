.macro glCall f
movq glad_\f, %rax
callq *%rax
.endm

.macro invertSignBit xmm
movd    %\xmm, %eax
xorl    $0x80000000, %eax # swap sign bit
movd    %eax, %\xmm
.endm
