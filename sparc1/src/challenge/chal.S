.globl getCmdLen
getCmdLen:
  retl
  ldub   [%o0+%g0], %o0

.globl getCmdType
getCmdType:
  retl
  ldub   [%o0+1], %o0

.globl getMsgId
getMsgId:
  retl
  lduh  [%i0+8], %o0

.globl getStrIdx
getStrIdx:
  retl
  ldub   [%o0+2], %o0

.globl check_checksum
check_checksum:
  save  %sp,-0x60,%sp
  mov   %i0, %g1
  add   %g1, 2, %o0
  ldub  [ %i0 + 1 ], %l6
  call  crc8
  ldub  [ %g1 ], %o1
  sll   %o0, 0x18, %l7
  srl   %l7, 0x18, %l7
  sub   %l6, %l7, %i0
  ret 
  restore 

.globl clipStrIdx
clipStrIdx:
  save  %sp,-0x60,%sp
  set   0x3, %l6
  cmp   %i0, %l6
  bl    L1
  cmp   %i0, %g0
  ret
  restore %g0, %g0, %o0
L1:
  bg,a  L2
  mov   %i0, %l7
L2:
  ret
  restore %l7, %g0, %o0
