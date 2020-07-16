
client:     file format elf32-vax

Disassembly of section .note.openbsd.ident:

00010154 <.note.openbsd.ident>:
   10154:	08 00 00 00 	cvtps $0x0,$0x0,$0x0,$0x4
   10158:	04 
   10159:	00          	halt
   1015a:	00          	halt
   1015b:	00          	halt
   1015c:	01          	nop
   1015d:	00          	halt
   1015e:	00          	halt
   1015f:	00          	halt
   10160:	4f 70 65 6e 	acbf -(r0),(r5),(sp),154a8 <fflush+0x20>
   10164:	42 53 
   10166:	44 00 00    	mulf2 $0x0 [f-float],$0x0 [f-float]
   10169:	00          	halt
	...
Disassembly of section .init:

0001016c <__init>:
   1016c:	00 00       	.word 0x0000 # Entry mask: < >
   1016e:	fb 00 ef 79 	calls $0x0,102ee <pthread_atfork+0x78>
   10172:	01 00 00 
   10175:	04          	ret
Disassembly of section .text:

00010178 <_start>:
   10178:	01 01       	.word 0x0101 # Entry mask: < r8 ~r0~ >
   1017a:	dd 5e       	pushl sp
   1017c:	fb 01 af 02 	calls $0x1,10182 <_start+0xa>
   10180:	00          	halt
   10181:	01          	nop
   10182:	c0 03 c2 04 	addl2 $0x3,0x5e04(r2)
   10186:	5e 
   10187:	d0 ac 04 50 	movl 0x4(ap),r0
   1018b:	d0 80 59    	movl (r0)+,r9
   1018e:	d0 50 57    	movl r0,r7
   10191:	de 49 a0 04 	moval 0x4(r0)[r9],r8
   10195:	58 
   10196:	d0 58 ef 73 	movl r8,62010 <environ>
   1019a:	1e 05 00 
   1019d:	d0 60 56    	movl (r0),r6
   101a0:	13 5e       	beql 10200 <_start+0x88>
   101a2:	dd 2f       	pushl $0x2f
   101a4:	dd 56       	pushl r6
   101a6:	fb 02 cf 8b 	calls $0x2,10236 <_start+0xbe>
   101aa:	00 
   101ab:	d0 50 ef fe 	movl r0,5bfb0 <__data_start>
   101af:	bd 04 00 
   101b2:	12 77       	bneq 1022b <_start+0xb3>
   101b4:	d0 56 ef f5 	movl r6,5bfb0 <__data_start>
   101b8:	bd 04 00 
   101bb:	9e ef 53 1e 	movab 62014 <__progname_storage>,r1
   101bf:	05 00 51 
   101c2:	d0 ef e8 bd 	movl 5bfb0 <__data_start>,r0
   101c6:	04 00 50 
   101c9:	95 60       	tstb (r0)
   101cb:	13 26       	beql 101f3 <_start+0x7b>
   101cd:	d1 51 8f 13 	cmpl r1,$0x00062113
   101d1:	21 06 00 
   101d4:	1e 1d       	bcc 101f3 <_start+0x7b>
   101d6:	d6 ef d4 bd 	incl 5bfb0 <__data_start>
   101da:	04 00 
   101dc:	90 60 81    	movb (r0),(r1)+
   101df:	d0 ef cb bd 	movl 5bfb0 <__data_start>,r0
   101e3:	04 00 50 
   101e6:	95 60       	tstb (r0)
   101e8:	13 09       	beql 101f3 <_start+0x7b>
   101ea:	d1 51 8f 13 	cmpl r1,$0x00062113
   101ee:	21 06 00 
   101f1:	1f e3       	blssu 101d6 <_start+0x5e>
   101f3:	94 61       	clrb (r1)
   101f5:	9e ef 19 1e 	movab 62014 <__progname_storage>,5bfb0 <__data_start>
   101f9:	05 00 ef b0 
   101fd:	bd 04 00 
   10200:	9e ef fa fd 	movab 0 <__init-0x1016c>,r0
   10204:	fe ff 50 
   10207:	13 05       	beql 1020e <_start+0x96>
   10209:	dd 58       	pushl r8
   1020b:	fb 01 60    	calls $0x1,(r0)
   1020e:	fb 00 ef 57 	calls $0x0,1016c <__init>
   10212:	ff ff ff 
   10215:	dd 58       	pushl r8
   10217:	dd 57       	pushl r7
   10219:	dd 59       	pushl r9
   1021b:	fb 03 ef 1a 	calls $0x3,1053c <main>
   1021f:	03 00 00 
   10222:	dd 50       	pushl r0
   10224:	fb 01 ef 9d 	calls $0x1,10bc8 <exit>
   10228:	09 00 00 
   1022b:	c1 50 01 ef 	addl3 r0,$0x1,5bfb0 <__data_start>
   1022f:	7d bd 04 00 
   10233:	11 86       	brb 101bb <_start+0x43>
   10235:	01          	nop
   10236:	00          	halt
   10237:	00          	halt
   10238:	c2 04 5e    	subl2 $0x4,sp
   1023b:	d0 ac 04 52 	movl 0x4(ap),r2
   1023f:	90 ac 08 53 	movb 0x8(ap),r3
   10243:	d4 50       	clrf r0
   10245:	90 62 51    	movb (r2),r1
   10248:	91 51 53    	cmpb r1,r3
   1024b:	13 09       	beql 10256 <_start+0xde>
   1024d:	95 51       	tstb r1
   1024f:	13 04       	beql 10255 <_start+0xdd>
   10251:	d6 52       	incl r2
   10253:	11 f0       	brb 10245 <_start+0xcd>
   10255:	04          	ret
   10256:	d0 52 50    	movl r2,r0
   10259:	11 f2       	brb 1024d <_start+0xd5>
   1025b:	01          	nop

0001025c <__register_frame_info>:
   1025c:	00 00       	.word 0x0000 # Entry mask: < >
   1025e:	c2 04 5e    	subl2 $0x4,sp
   10261:	04          	ret

00010262 <atexit>:
   10262:	00 00       	.word 0x0000 # Entry mask: < >
   10264:	c2 04 5e    	subl2 $0x4,sp
   10267:	d4 7e       	clrf -(sp)
   10269:	d4 7e       	clrf -(sp)
   1026b:	dd ac 04    	pushl 0x4(ap)
   1026e:	fb 03 ef 6b 	calls $0x3,10be0 <__cxa_atexit>
   10272:	09 00 00 
   10275:	04          	ret

00010276 <pthread_atfork>:
   10276:	00 00       	.word 0x0000 # Entry mask: < >
   10278:	c2 04 5e    	subl2 $0x4,sp
   1027b:	d4 7e       	clrf -(sp)
   1027d:	dd ac 0c    	pushl 0xc(ap)
   10280:	dd ac 08    	pushl 0x8(ap)
   10283:	dd ac 04    	pushl 0x4(ap)
   10286:	fb 04 ef 73 	calls $0x4,0 <__init-0x1016c>
   1028a:	fd fe ff 
   1028d:	04          	ret
   1028e:	c0 00 c2 04 	addl2 $0x0,0x5e04(r2)
   10292:	5e 
   10293:	d0 01 57    	movl $0x1,r7
   10296:	9e ef 04 bd 	movab 4bfa0 <__got_start>,r0
   1029a:	03 00 50 
   1029d:	d5 ef 01 bd 	tstl 4bfa4 <__got_start+0x4>
   102a1:	03 00 
   102a3:	13 07       	beql 102ac <pthread_atfork+0x36>
   102a5:	d6 57       	incl r7
   102a7:	d5 47 60    	tstl (r0)[r7]
   102aa:	12 f9       	bneq 102a5 <pthread_atfork+0x2f>
   102ac:	d7 57       	decl r7
   102ae:	de 47 ef eb 	moval 4bfa0 <__got_start>[r7],r6
   102b2:	bc 03 00 56 
   102b6:	d7 57       	decl r7
   102b8:	d1 57 8f ff 	cmpl r7,$0xffffffff
   102bc:	ff ff ff 
   102bf:	13 0d       	beql 102ce <pthread_atfork+0x58>
   102c1:	d0 66 50    	movl (r6),r0
   102c4:	c2 04 56    	subl2 $0x4,r6
   102c7:	fb 00 60    	calls $0x0,(r0)
   102ca:	d7 57       	decl r7
   102cc:	1e f3       	bcc 102c1 <pthread_atfork+0x4b>
   102ce:	04          	ret
   102cf:	01          	nop
   102d0:	40 00 c2 04 	addf2 $0x0 [f-float],0x5e04(r2)
   102d4:	5e 
   102d5:	9e ef d1 bc 	movab 4bfac <__got_start+0xc>,r6
   102d9:	03 00 56 
   102dc:	d5 66       	tstl (r6)
   102de:	12 01       	bneq 102e1 <pthread_atfork+0x6b>
   102e0:	04          	ret
   102e1:	d0 86 50    	movl (r6)+,r0
   102e4:	fb 00 60    	calls $0x0,(r0)
   102e7:	d5 66       	tstl (r6)
   102e9:	12 f6       	bneq 102e1 <pthread_atfork+0x6b>
   102eb:	11 f3       	brb 102e0 <pthread_atfork+0x6a>
   102ed:	01          	nop
   102ee:	00          	halt
   102ef:	00          	halt
   102f0:	c2 04 5e    	subl2 $0x4,sp
   102f3:	d5 ef bf bc 	tstl 5bfb8 <__dso_handle+0x4>
   102f7:	04 00 
   102f9:	13 01       	beql 102fc <pthread_atfork+0x86>
   102fb:	04          	ret
   102fc:	d0 01 ef b5 	movl $0x1,5bfb8 <__dso_handle+0x4>
   10300:	bc 04 00 
   10303:	9f ef f7 cc 	pushab 5d000 <__bss_start+0x1ac>
   10307:	04 00 
   10309:	9f ef 85 bc 	pushab 2bf94 <_sys_siglist+0x27c>
   1030d:	01 00 
   1030f:	fb 02 ef 46 	calls $0x2,1025c <__register_frame_info>
   10313:	ff ff ff 
   10316:	9e ef 80 bc 	movab 3bf9c <__guard_local+0x4>,r0
   1031a:	02 00 50 
   1031d:	d5 60       	tstl (r0)
   1031f:	13 0e       	beql 1032f <pthread_atfork+0xb9>
   10321:	9e ef d9 fc 	movab 0 <__init-0x1016c>,r1
   10325:	fe ff 51 
   10328:	13 05       	beql 1032f <pthread_atfork+0xb9>
   1032a:	dd 50       	pushl r0
   1032c:	fb 01 61    	calls $0x1,(r1)
   1032f:	fb 00 cf 5a 	calls $0x0,1028e <pthread_atfork+0x18>
   10333:	ff 
   10334:	9f ef 10 a6 	pushab 1a94a <__fini>
   10338:	00 00 
   1033a:	fb 01 ef 21 	calls $0x1,10262 <atexit>
   1033e:	ff ff ff 
   10341:	11 b8       	brb 102fb <pthread_atfork+0x85>
   10343:	01          	nop
   10344:	00          	halt
   10345:	00          	halt
   10346:	c2 04 5e    	subl2 $0x4,sp
   10349:	d5 ef 6d bc 	tstl 5bfbc <__dso_handle+0x8>
   1034d:	04 00 
   1034f:	13 01       	beql 10352 <pthread_atfork+0xdc>
   10351:	04          	ret
   10352:	d0 01 ef 63 	movl $0x1,5bfbc <__dso_handle+0x8>
   10356:	bc 04 00 
   10359:	fb 00 cf 72 	calls $0x0,102d0 <pthread_atfork+0x5a>
   1035d:	ff 
   1035e:	11 f1       	brb 10351 <pthread_atfork+0xdb>

00010360 <func>:
   10360:	00 00       	.word 0x0000 # Entry mask: < >
   10362:	9e ce ec f7 	movab 0xfffff7ec(sp),sp
   10366:	5e 
   10367:	d0 ef 2b bc 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   1036b:	02 00 ad f8 
   1036f:	01          	nop
   10370:	3c 8f 00 08 	movzwl $0x0800,-(sp)
   10374:	7e 
   10375:	9e cd f8 f7 	movab 0xfffff7f8(fp),r0
   10379:	50 
   1037a:	dd 50       	pushl r0
   1037c:	fb 02 ef fd 	calls $0x2,10980 <bzero>
   10380:	05 00 00 
   10383:	d4 7e       	clrf -(sp)
   10385:	3c 8f 00 08 	movzwl $0x0800,-(sp)
   10389:	7e 
   1038a:	9e cd f8 f7 	movab 0xfffff7f8(fp),r0
   1038e:	50 
   1038f:	dd 50       	pushl r0
   10391:	dd ac 04    	pushl 0x4(ap)
   10394:	fb 04 ef 35 	calls $0x4,10fd0 <recv>
   10398:	0c 00 00 
   1039b:	d1 50 8f ff 	cmpl r0,$0xffffffff
   1039f:	ff ff ff 
   103a2:	12 26       	bneq 103ca <func+0x6a>
   103a4:	fb 00 ef 1d 	calls $0x0,109c8 <___errno>
   103a8:	06 00 00 
   103ab:	dd 60       	pushl (r0)
   103ad:	9f ef a1 a5 	pushab 2a954 <__fini+0x1000a>
   103b1:	01 00 
   103b3:	fb 02 ef 1c 	calls $0x2,109d6 <printf>
   103b7:	06 00 00 
   103ba:	9f ef b0 a5 	pushab 2a970 <__fini+0x10026>
   103be:	01 00 
   103c0:	fb 01 ef 0f 	calls $0x1,109d6 <printf>
   103c4:	06 00 00 
   103c7:	31 56 01    	brw 10520 <func+0x1c0>
   103ca:	9e cd f8 f7 	movab 0xfffff7f8(fp),r0
   103ce:	50 
   103cf:	dd 50       	pushl r0
   103d1:	9f ef a9 a5 	pushab 2a980 <__fini+0x10036>
   103d5:	01 00 
   103d7:	fb 02 ef f8 	calls $0x2,109d6 <printf>
   103db:	05 00 00 
   103de:	dd 04       	pushl $0x4
   103e0:	9f ef 9d a5 	pushab 2a983 <__fini+0x10039>
   103e4:	01 00 
   103e6:	9e cd f8 f7 	movab 0xfffff7f8(fp),r0
   103ea:	50 
   103eb:	dd 50       	pushl r0
   103ed:	fb 03 ef 18 	calls $0x3,1120c <strncmp>
   103f1:	0e 00 00 
   103f4:	d5 50       	tstl r0
   103f6:	12 10       	bneq 10408 <func+0xa8>
   103f8:	9f ef 72 a5 	pushab 2a970 <__fini+0x10026>
   103fc:	01 00 
   103fe:	fb 01 ef d1 	calls $0x1,109d6 <printf>
   10402:	05 00 00 
   10405:	31 18 01    	brw 10520 <func+0x1c0>
   10408:	3c 8f 00 08 	movzwl $0x0800,-(sp)
   1040c:	7e 
   1040d:	9e cd f8 f7 	movab 0xfffff7f8(fp),r0
   10411:	50 
   10412:	dd 50       	pushl r0
   10414:	fb 02 ef 65 	calls $0x2,10980 <bzero>
   10418:	05 00 00 
   1041b:	9f ef 67 a5 	pushab 2a988 <__fini+0x1003e>
   1041f:	01 00 
   10421:	fb 01 ef ae 	calls $0x1,109d6 <printf>
   10425:	05 00 00 
   10428:	d4 cd f4 f7 	clrf 0xfffff7f4(fp)
   1042c:	d1 cd f4 f7 	cmpl 0xfffff7f4(fp),$0x000007fe
   10430:	8f fe 07 00 
   10434:	00 
   10435:	14 79       	bgtr 104b0 <func+0x150>
   10437:	9e cd f8 f7 	movab 0xfffff7f8(fp),r1
   1043b:	51 
   1043c:	d0 cd f4 f7 	movl 0xfffff7f4(fp),r0
   10440:	50 
   10441:	c1 50 51 cd 	addl3 r0,r1,0xfffff7f0(fp)
   10445:	f0 f7 
   10447:	d6 cd f4 f7 	incl 0xfffff7f4(fp)
   1044b:	d5 ef 93 bc 	tstl 5c0e4 <__isthreaded>
   1044f:	04 00 
   10451:	12 36       	bneq 10489 <func+0x129>
   10453:	d7 ef 7b bb 	decl 5bfd4 <__sF+0x4>
   10457:	04 00 
   10459:	d5 ef 75 bb 	tstl 5bfd4 <__sF+0x4>
   1045d:	04 00 
   1045f:	18 14       	bgeq 10475 <func+0x115>
   10461:	9f ef 69 bb 	pushab 5bfd0 <__sF>
   10465:	04 00 
   10467:	fb 01 ef 0a 	calls $0x1,11078 <__srget>
   1046b:	0c 00 00 
   1046e:	90 50 cd ef 	movb r0,0xfffff7ef(fp)
   10472:	f7 
   10473:	11 26       	brb 1049b <func+0x13b>
   10475:	d0 ef 55 bb 	movl 5bfd0 <__sF>,r0
   10479:	04 00 50 
   1047c:	d6 ef 4e bb 	incl 5bfd0 <__sF>
   10480:	04 00 
   10482:	90 60 cd ef 	movb (r0),0xfffff7ef(fp)
   10486:	f7 
   10487:	11 12       	brb 1049b <func+0x13b>
   10489:	9f ef 41 bb 	pushab 5bfd0 <__sF>
   1048d:	04 00 
   1048f:	fb 01 ef 96 	calls $0x1,1102c <getc>
   10493:	0b 00 00 
   10496:	90 50 cd ef 	movb r0,0xfffff7ef(fp)
   1049a:	f7 
   1049b:	90 cd ef f7 	movb 0xfffff7ef(fp),r0
   1049f:	50 
   104a0:	d0 cd f0 f7 	movl 0xfffff7f0(fp),r1
   104a4:	51 
   104a5:	90 50 61    	movb r0,(r1)
   104a8:	91 50 0a    	cmpb r0,$0xa
   104ab:	13 03       	beql 104b0 <func+0x150>
   104ad:	31 7c ff    	brw 1042c <func+0xcc>
   104b0:	d4 7e       	clrf -(sp)
   104b2:	3c 8f 00 08 	movzwl $0x0800,-(sp)
   104b6:	7e 
   104b7:	9e cd f8 f7 	movab 0xfffff7f8(fp),r0
   104bb:	50 
   104bc:	dd 50       	pushl r0
   104be:	dd ac 04    	pushl 0x4(ap)
   104c1:	fb 04 ef 26 	calls $0x4,10fee <send>
   104c5:	0b 00 00 
   104c8:	d1 50 8f ff 	cmpl r0,$0xffffffff
   104cc:	ff ff ff 
   104cf:	12 25       	bneq 104f6 <func+0x196>
   104d1:	fb 00 ef f0 	calls $0x0,109c8 <___errno>
   104d5:	04 00 00 
   104d8:	dd 60       	pushl (r0)
   104da:	9f ef b3 a4 	pushab 2a993 <__fini+0x10049>
   104de:	01 00 
   104e0:	fb 02 ef ef 	calls $0x2,109d6 <printf>
   104e4:	04 00 00 
   104e7:	9f ef 83 a4 	pushab 2a970 <__fini+0x10026>
   104eb:	01 00 
   104ed:	fb 01 ef e2 	calls $0x1,109d6 <printf>
   104f1:	04 00 00 
   104f4:	11 2a       	brb 10520 <func+0x1c0>
   104f6:	dd 04       	pushl $0x4
   104f8:	9f ef 85 a4 	pushab 2a983 <__fini+0x10039>
   104fc:	01 00 
   104fe:	9e cd f8 f7 	movab 0xfffff7f8(fp),r0
   10502:	50 
   10503:	dd 50       	pushl r0
   10505:	fb 03 ef 00 	calls $0x3,1120c <strncmp>
   10509:	0d 00 00 
   1050c:	d5 50       	tstl r0
   1050e:	13 03       	beql 10513 <func+0x1b3>
   10510:	31 5d fe    	brw 10370 <func+0x10>
   10513:	9f ef 57 a4 	pushab 2a970 <__fini+0x10026>
   10517:	01 00 
   10519:	fb 01 ef b6 	calls $0x1,109d6 <printf>
   1051d:	04 00 00 
   10520:	d1 ad f8 ef 	cmpl 0xfffffff8(fp),3bf98 <__guard_local>
   10524:	70 ba 02 00 
   10528:	13 10       	beql 1053a <func+0x1da>
   1052a:	dd ad f8    	pushl 0xfffffff8(fp)
   1052d:	9f ef 7c a4 	pushab 2a9af <__fini+0x10065>
   10531:	01 00 
   10533:	fb 02 ef 32 	calls $0x2,1666c <__stack_smash_handler>
   10537:	61 00 00 
   1053a:	04          	ret
   1053b:	01          	nop

0001053c <main>:
   1053c:	00 00       	.word 0x0000 # Entry mask: < >
   1053e:	9e ae b8 5e 	movab 0xffffffb8(sp),sp
   10542:	d0 ef 50 ba 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   10546:	02 00 ad f8 
   1054a:	d0 ac 08 ad 	movl 0x8(ap),0xffffffbc(fp)
   1054e:	bc 
   1054f:	d1 ac 04 02 	cmpl 0x4(ap),$0x2
   10553:	13 14       	beql 10569 <main+0x2d>
   10555:	9f ef 59 a4 	pushab 2a9b4 <__fini+0x1006a>
   10559:	01 00 
   1055b:	fb 01 ef 74 	calls $0x1,109d6 <printf>
   1055f:	04 00 00 
   10562:	d2 00 ad b8 	mcoml $0x0,0xffffffb8(fp)
   10566:	31 f2 00    	brw 1065b <main+0x11f>
   10569:	d4 7e       	clrf -(sp)
   1056b:	dd 01       	pushl $0x1
   1056d:	dd 02       	pushl $0x2
   1056f:	fb 03 ef 3a 	calls $0x3,109b0 <_thread_sys_socket>
   10573:	04 00 00 
   10576:	d0 50 ad d4 	movl r0,0xffffffd4(fp)
   1057a:	d1 ad d4 8f 	cmpl 0xffffffd4(fp),$0xffffffff
   1057e:	ff ff ff ff 
   10582:	12 20       	bneq 105a4 <main+0x68>
   10584:	dd ad d4    	pushl 0xffffffd4(fp)
   10587:	fb 01 ef 0a 	calls $0x1,10698 <_thread_sys_close>
   1058b:	01 00 00 
   1058e:	9f ef 4f a4 	pushab 2a9e3 <__fini+0x10099>
   10592:	01 00 
   10594:	fb 01 ef 3b 	calls $0x1,109d6 <printf>
   10598:	04 00 00 
   1059b:	d4 7e       	clrf -(sp)
   1059d:	fb 01 ef 24 	calls $0x1,10bc8 <exit>
   105a1:	06 00 00 
   105a4:	9f ef 54 a4 	pushab 2a9fe <__fini+0x100b4>
   105a8:	01 00 
   105aa:	fb 01 ef 25 	calls $0x1,109d6 <printf>
   105ae:	04 00 00 
   105b1:	dd 10       	pushl $0x10
   105b3:	d4 7e       	clrf -(sp)
   105b5:	c3 18 5d 50 	subl3 $0x18,fp,r0
   105b9:	dd 50       	pushl r0
   105bb:	fb 03 ef 36 	calls $0x3,168f8 <memset>
   105bf:	63 00 00 
   105c2:	90 02 ad e9 	movb $0x2,0xffffffe9(fp)
   105c6:	d0 ad bc 50 	movl 0xffffffbc(fp),r0
   105ca:	dd a0 04    	pushl 0x4(r0)
   105cd:	fb 01 ef cc 	calls $0x1,106a0 <inet_addr>
   105d1:	00 00 00 
   105d4:	d0 50 ad ec 	movl r0,0xffffffec(fp)
   105d8:	b0 8f 90 1f 	movw $0x1f90,0xffffffc2(fp)
   105dc:	ad c2 
   105de:	3c ad c2 50 	movzwl 0xffffffc2(fp),r0
   105e2:	ca 8f 00 ff 	bicl2 $0xffffff00,r0
   105e6:	ff ff 50 
   105e9:	78 08 50 51 	ashl $0x8,r0,r1
   105ed:	3c ad c2 50 	movzwl 0xffffffc2(fp),r0
   105f1:	ca 8f ff 00 	bicl2 $0xffff00ff,r0
   105f5:	ff ff 50 
   105f8:	78 8f f8 50 	ashl $0xf8,r0,r0
   105fc:	50 
   105fd:	a8 51 50    	bisw2 r1,r0
   10600:	b0 50 ad ea 	movw r0,0xffffffea(fp)
   10604:	dd 10       	pushl $0x10
   10606:	c3 18 5d 50 	subl3 $0x18,fp,r0
   1060a:	dd 50       	pushl r0
   1060c:	dd ad d4    	pushl 0xffffffd4(fp)
   1060f:	fb 03 ef 6e 	calls $0x3,10684 <_thread_sys_connect>
   10613:	00 00 00 
   10616:	d5 50       	tstl r0
   10618:	13 20       	beql 1063a <main+0xfe>
   1061a:	dd ad d4    	pushl 0xffffffd4(fp)
   1061d:	fb 01 ef 74 	calls $0x1,10698 <_thread_sys_close>
   10621:	00 00 00 
   10624:	9f ef f2 a3 	pushab 2aa1c <__fini+0x100d2>
   10628:	01 00 
   1062a:	fb 01 ef a5 	calls $0x1,109d6 <printf>
   1062e:	03 00 00 
   10631:	d4 7e       	clrf -(sp)
   10633:	fb 01 ef 8e 	calls $0x1,10bc8 <exit>
   10637:	05 00 00 
   1063a:	9f ef 02 a4 	pushab 2aa42 <__fini+0x100f8>
   1063e:	01 00 
   10640:	fb 01 ef 8f 	calls $0x1,109d6 <printf>
   10644:	03 00 00 
   10647:	dd ad d4    	pushl 0xffffffd4(fp)
   1064a:	fb 01 ef 0f 	calls $0x1,10360 <func>
   1064e:	fd ff ff 
   10651:	dd ad d4    	pushl 0xffffffd4(fp)
   10654:	fb 01 ef 3d 	calls $0x1,10698 <_thread_sys_close>
   10658:	00 00 00 
   1065b:	d0 ad b8 50 	movl 0xffffffb8(fp),r0
   1065f:	d1 ad f8 ef 	cmpl 0xfffffff8(fp),3bf98 <__guard_local>
   10663:	31 b9 02 00 
   10667:	13 10       	beql 10679 <main+0x13d>
   10669:	dd ad f8    	pushl 0xfffffff8(fp)
   1066c:	9f ef eb a3 	pushab 2aa5d <__fini+0x10113>
   10670:	01 00 
   10672:	fb 02 ef f3 	calls $0x2,1666c <__stack_smash_handler>
   10676:	5f 00 00 
   10679:	04          	ret
   1067a:	01          	nop
   1067b:	01          	nop
   1067c:	17 ef 37 03 	jmp 109b9 <___cerror>
   10680:	00 00 
   10682:	01          	nop
   10683:	01          	nop

00010684 <_thread_sys_connect>:
   10684:	00 00       	.word 0x0000 # Entry mask: < >
   10686:	bc 8f 62 00 	chmk $0x0062
   1068a:	1f f0       	blssu 1067c <main+0x140>
   1068c:	04          	ret
   1068d:	01          	nop
   1068e:	01          	nop
   1068f:	01          	nop
   10690:	17 ef 23 03 	jmp 109b9 <___cerror>
   10694:	00 00 
   10696:	01          	nop
   10697:	01          	nop

00010698 <_thread_sys_close>:
   10698:	00 00       	.word 0x0000 # Entry mask: < >
   1069a:	bc 06       	chmk $0x6
   1069c:	1f f2       	blssu 10690 <_thread_sys_connect+0xc>
   1069e:	04          	ret
   1069f:	01          	nop

000106a0 <inet_addr>:
   106a0:	00 00       	.word 0x0000 # Entry mask: < >
   106a2:	c2 08 5e    	subl2 $0x8,sp
   106a5:	9f ad f8    	pushab 0xfffffff8(fp)
   106a8:	dd ac 04    	pushl 0x4(ap)
   106ab:	fb 02 ef 0e 	calls $0x2,106c0 <inet_aton>
   106af:	00 00 00 
   106b2:	d5 50       	tstl r0
   106b4:	13 05       	beql 106bb <inet_addr+0x1b>
   106b6:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   106ba:	04          	ret
   106bb:	d2 00 50    	mcoml $0x0,r0
   106be:	04          	ret
   106bf:	01          	nop

000106c0 <inet_aton>:
   106c0:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   106c2:	c2 18 5e    	subl2 $0x18,sp
   106c5:	d0 ac 04 53 	movl 0x4(ap),r3
   106c9:	d0 ef c9 b8 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   106cd:	02 00 ad f8 
   106d1:	d0 ac 08 58 	movl 0x8(ap),r8
   106d5:	c3 18 5d 57 	subl3 $0x18,fp,r7
   106d9:	90 63 52    	movb (r3),r2
   106dc:	9a 52 51    	movzbl r2,r1
   106df:	d1 51 8f ff 	cmpl r1,$0xffffffff
   106e3:	ff ff ff 
   106e6:	12 03       	bneq 106eb <inet_aton+0x2b>
   106e8:	31 8e 02    	brw 10979 <inet_aton+0x2b9>
   106eb:	d0 ef ff b9 	movl 5c0f0 <_ctype_>,r0
   106ef:	04 00 50 
   106f2:	98 40 a1 01 	cvtbl 0x1(r1)[r0],r0
   106f6:	50 
   106f7:	ca 8f fb ff 	bicl2 $0xfffffffb,r0
   106fb:	ff ff 50 
   106fe:	d5 50       	tstl r0
   10700:	12 03       	bneq 10705 <inet_aton+0x45>
   10702:	31 dd 00    	brw 107e2 <inet_aton+0x122>
   10705:	d4 54       	clrf r4
   10707:	d0 0a 56    	movl $0xa,r6
   1070a:	91 52 30    	cmpb r2,$0x30
   1070d:	12 03       	bneq 10712 <inet_aton+0x52>
   1070f:	31 45 02    	brw 10957 <inet_aton+0x297>
   10712:	d0 ef d8 b9 	movl 5c0f0 <_ctype_>,r5
   10716:	04 00 55 
   10719:	9a 52 50    	movzbl r2,r0
   1071c:	d4 51       	clrf r1
   1071e:	d1 50 8f 7f 	cmpl r0,$0x0000007f
   10722:	00 00 00 
   10725:	1a 02       	bgtru 10729 <inet_aton+0x69>
   10727:	d6 51       	incl r1
   10729:	d5 51       	tstl r1
   1072b:	13 2f       	beql 1075c <inet_aton+0x9c>
   1072d:	d1 50 8f ff 	cmpl r0,$0xffffffff
   10731:	ff ff ff 
   10734:	12 03       	bneq 10739 <inet_aton+0x79>
   10736:	31 19 02    	brw 10952 <inet_aton+0x292>
   10739:	98 45 a0 01 	cvtbl 0x1(r0)[r5],r0
   1073d:	50 
   1073e:	ca 8f fb ff 	bicl2 $0xfffffffb,r0
   10742:	ff ff 50 
   10745:	d5 50       	tstl r0
   10747:	13 13       	beql 1075c <inet_aton+0x9c>
   10749:	c5 54 56 51 	mull3 r4,r6,r1
   1074d:	98 52 50    	cvtbl r2,r0
   10750:	9e 41 a0 d0 	movab 0xffffffd0(r0)[r1],r4
   10754:	54 
   10755:	d6 53       	incl r3
   10757:	90 63 52    	movb (r3),r2
   1075a:	11 bd       	brb 10719 <inet_aton+0x59>
   1075c:	d1 56 10    	cmpl r6,$0x10
   1075f:	12 6b       	bneq 107cc <inet_aton+0x10c>
   10761:	9a 52 50    	movzbl r2,r0
   10764:	d4 51       	clrf r1
   10766:	d1 50 8f 7f 	cmpl r0,$0x0000007f
   1076a:	00 00 00 
   1076d:	1a 02       	bgtru 10771 <inet_aton+0xb1>
   1076f:	d6 51       	incl r1
   10771:	d5 51       	tstl r1
   10773:	13 57       	beql 107cc <inet_aton+0x10c>
   10775:	d1 50 8f ff 	cmpl r0,$0xffffffff
   10779:	ff ff ff 
   1077c:	12 03       	bneq 10781 <inet_aton+0xc1>
   1077e:	31 cc 01    	brw 1094d <inet_aton+0x28d>
   10781:	98 45 a0 01 	cvtbl 0x1(r0)[r5],r0
   10785:	50 
   10786:	ca 8f bb ff 	bicl2 $0xffffffbb,r0
   1078a:	ff ff 50 
   1078d:	d5 50       	tstl r0
   1078f:	13 3b       	beql 107cc <inet_aton+0x10c>
   10791:	78 04 54 51 	ashl $0x4,r4,r1
   10795:	98 52 50    	cvtbl r2,r0
   10798:	c1 50 0a 54 	addl3 r0,$0xa,r4
   1079c:	9a 52 50    	movzbl r2,r0
   1079f:	d1 50 8f ff 	cmpl r0,$0xffffffff
   107a3:	ff ff ff 
   107a6:	13 20       	beql 107c8 <inet_aton+0x108>
   107a8:	98 45 a0 01 	cvtbl 0x1(r0)[r5],r0
   107ac:	50 
   107ad:	ca 8f fd ff 	bicl2 $0xfffffffd,r0
   107b1:	ff ff 50 
   107b4:	d5 50       	tstl r0
   107b6:	13 0a       	beql 107c2 <inet_aton+0x102>
   107b8:	9e a4 9f 50 	movab 0xffffff9f(r4),r0
   107bc:	c9 50 51 54 	bisl3 r0,r1,r4
   107c0:	11 93       	brb 10755 <inet_aton+0x95>
   107c2:	9e a4 bf 50 	movab 0xffffffbf(r4),r0
   107c6:	11 f4       	brb 107bc <inet_aton+0xfc>
   107c8:	d4 50       	clrf r0
   107ca:	11 e8       	brb 107b4 <inet_aton+0xf4>
   107cc:	91 52 2e    	cmpb r2,$0x2e
   107cf:	12 31       	bneq 10802 <inet_aton+0x142>
   107d1:	c3 0c 5d 50 	subl3 $0xc,fp,r0
   107d5:	d1 57 50    	cmpl r7,r0
   107d8:	1e 08       	bcc 107e2 <inet_aton+0x122>
   107da:	d0 54 87    	movl r4,(r7)+
   107dd:	d6 53       	incl r3
   107df:	31 f7 fe    	brw 106d9 <inet_aton+0x19>
   107e2:	d4 50       	clrf r0
   107e4:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   107e8:	d1 51 ef a9 	cmpl r1,3bf98 <__guard_local>
   107ec:	b7 02 00 
   107ef:	13 10       	beql 10801 <inet_aton+0x141>
   107f1:	dd ad f8    	pushl 0xfffffff8(fp)
   107f4:	9f ef 68 a2 	pushab 2aa62 <__fini+0x10118>
   107f8:	01 00 
   107fa:	fb 02 ef 6b 	calls $0x2,1666c <__stack_smash_handler>
   107fe:	5e 00 00 
   10801:	04          	ret
   10802:	95 52       	tstb r2
   10804:	13 37       	beql 1083d <inet_aton+0x17d>
   10806:	9a 52 51    	movzbl r2,r1
   10809:	d4 50       	clrf r0
   1080b:	d1 51 8f 7f 	cmpl r1,$0x0000007f
   1080f:	00 00 00 
   10812:	1a 02       	bgtru 10816 <inet_aton+0x156>
   10814:	d6 50       	incl r0
   10816:	d5 50       	tstl r0
   10818:	13 c8       	beql 107e2 <inet_aton+0x122>
   1081a:	d1 51 8f ff 	cmpl r1,$0xffffffff
   1081e:	ff ff ff 
   10821:	12 03       	bneq 10826 <inet_aton+0x166>
   10823:	31 22 01    	brw 10948 <inet_aton+0x288>
   10826:	d0 ef c4 b8 	movl 5c0f0 <_ctype_>,r0
   1082a:	04 00 50 
   1082d:	98 40 a1 01 	cvtbl 0x1(r1)[r0],r0
   10831:	50 
   10832:	ca 8f f7 ff 	bicl2 $0xfffffff7,r0
   10836:	ff ff 50 
   10839:	d5 50       	tstl r0
   1083b:	13 a5       	beql 107e2 <inet_aton+0x122>
   1083d:	c3 18 5d 50 	subl3 $0x18,fp,r0
   10841:	c3 50 57 50 	subl3 r0,r7,r0
   10845:	78 8f fe 50 	ashl $0xfe,r0,r0
   10849:	50 
   1084a:	d6 50       	incl r0
   1084c:	d1 50 04    	cmpl r0,$0x4
   1084f:	1a 31       	bgtru 10882 <inet_aton+0x1c2>
   10851:	cf 50 00 04 	casel r0,$0x0,$0x4
   10855:	8d ff 2d 00 	xorb3 *b0888 <_end+0x4e424>,(fp),$0x0
   10859:	0a 00 6d 00 
   1085d:	a6 00 d1 54 	divw2 $0x0,*0xffff8f54(r1)
   10861:	8f 
   10862:	ff ff       	.word 0xffff
   10864:	ff 00       	.word 0xff00
   10866:	1b 03       	blequ 1086b <inet_aton+0x1ab>
   10868:	31 77 ff    	brw 107e2 <inet_aton+0x122>
   1086b:	d0 ad e8 50 	movl 0xffffffe8(fp),r0
   1086f:	d1 50 8f ff 	cmpl r0,$0x000000ff
   10873:	00 00 00 
   10876:	1b 03       	blequ 1087b <inet_aton+0x1bb>
   10878:	31 67 ff    	brw 107e2 <inet_aton+0x122>
   1087b:	78 18 50 50 	ashl $0x18,r0,r0
   1087f:	c8 50 54    	bisl2 r0,r4
   10882:	d5 58       	tstl r8
   10884:	13 36       	beql 108bc <inet_aton+0x1fc>
   10886:	78 18 54 51 	ashl $0x18,r4,r1
   1088a:	9c 08 54 50 	rotl $0x8,r4,r0
   1088e:	ca 8f ff ff 	bicl2 $0xff00ffff,r0
   10892:	00 ff 50 
   10895:	c8 50 51    	bisl2 r0,r1
   10898:	cb 8f ff ff 	bicl3 $0xff00ffff,r4,r0
   1089c:	00 ff 54 50 
   108a0:	d0 08 52    	movl $0x8,r2
   108a3:	ef 52 18 50 	extzv r2,$0x18,r0,r0
   108a7:	50 
   108a8:	c8 50 51    	bisl2 r0,r1
   108ab:	cb 8f ff ff 	bicl3 $0x00ffffff,r4,r0
   108af:	ff 00 54 50 
   108b3:	ef 18 52 50 	extzv $0x18,r2,r0,r0
   108b7:	50 
   108b8:	c9 50 51 68 	bisl3 r0,r1,(r8)
   108bc:	d0 01 50    	movl $0x1,r0
   108bf:	31 22 ff    	brw 107e4 <inet_aton+0x124>
   108c2:	d1 54 8f ff 	cmpl r4,$0x0000ffff
   108c6:	ff 00 00 
   108c9:	1b 03       	blequ 108ce <inet_aton+0x20e>
   108cb:	31 14 ff    	brw 107e2 <inet_aton+0x122>
   108ce:	d0 ad e8 50 	movl 0xffffffe8(fp),r0
   108d2:	d1 50 8f ff 	cmpl r0,$0x000000ff
   108d6:	00 00 00 
   108d9:	1b 03       	blequ 108de <inet_aton+0x21e>
   108db:	31 04 ff    	brw 107e2 <inet_aton+0x122>
   108de:	d0 ad ec 51 	movl 0xffffffec(fp),r1
   108e2:	d1 51 8f ff 	cmpl r1,$0x000000ff
   108e6:	00 00 00 
   108e9:	1b 03       	blequ 108ee <inet_aton+0x22e>
   108eb:	31 f4 fe    	brw 107e2 <inet_aton+0x122>
   108ee:	78 18 50 50 	ashl $0x18,r0,r0
   108f2:	78 10 51 51 	ashl $0x10,r1,r1
   108f6:	c8 51 50    	bisl2 r1,r0
   108f9:	11 84       	brb 1087f <inet_aton+0x1bf>
   108fb:	d1 54 8f ff 	cmpl r4,$0x000000ff
   108ff:	00 00 00 
   10902:	1b 03       	blequ 10907 <inet_aton+0x247>
   10904:	31 db fe    	brw 107e2 <inet_aton+0x122>
   10907:	d0 ad e8 50 	movl 0xffffffe8(fp),r0
   1090b:	d1 50 8f ff 	cmpl r0,$0x000000ff
   1090f:	00 00 00 
   10912:	1b 03       	blequ 10917 <inet_aton+0x257>
   10914:	31 cb fe    	brw 107e2 <inet_aton+0x122>
   10917:	d0 ad ec 51 	movl 0xffffffec(fp),r1
   1091b:	d1 51 8f ff 	cmpl r1,$0x000000ff
   1091f:	00 00 00 
   10922:	1b 03       	blequ 10927 <inet_aton+0x267>
   10924:	31 bb fe    	brw 107e2 <inet_aton+0x122>
   10927:	d0 ad f0 52 	movl 0xfffffff0(fp),r2
   1092b:	d1 52 8f ff 	cmpl r2,$0x000000ff
   1092f:	00 00 00 
   10932:	1b 03       	blequ 10937 <inet_aton+0x277>
   10934:	31 ab fe    	brw 107e2 <inet_aton+0x122>
   10937:	78 18 50 50 	ashl $0x18,r0,r0
   1093b:	78 10 51 51 	ashl $0x10,r1,r1
   1093f:	c8 51 50    	bisl2 r1,r0
   10942:	78 08 52 51 	ashl $0x8,r2,r1
   10946:	11 ae       	brb 108f6 <inet_aton+0x236>
   10948:	d4 50       	clrf r0
   1094a:	31 ec fe    	brw 10839 <inet_aton+0x179>
   1094d:	d4 50       	clrf r0
   1094f:	31 3b fe    	brw 1078d <inet_aton+0xcd>
   10952:	d4 50       	clrf r0
   10954:	31 ee fd    	brw 10745 <inet_aton+0x85>
   10957:	d6 53       	incl r3
   10959:	90 63 52    	movb (r3),r2
   1095c:	91 52 8f 78 	cmpb r2,$0x78
   10960:	13 0c       	beql 1096e <inet_aton+0x2ae>
   10962:	91 52 8f 58 	cmpb r2,$0x58
   10966:	13 06       	beql 1096e <inet_aton+0x2ae>
   10968:	d0 08 56    	movl $0x8,r6
   1096b:	31 a4 fd    	brw 10712 <inet_aton+0x52>
   1096e:	d0 10 56    	movl $0x10,r6
   10971:	d6 53       	incl r3
   10973:	90 63 52    	movb (r3),r2
   10976:	31 99 fd    	brw 10712 <inet_aton+0x52>
   10979:	d4 50       	clrf r0
   1097b:	31 80 fd    	brw 106fe <inet_aton+0x3e>
   1097e:	01          	nop
   1097f:	01          	nop

00010980 <bzero>:
   10980:	3c 00       	.word 0x003c # Entry mask: < r5 r4 r3 r2 >
   10982:	d0 ac 04 53 	movl 0x4(ap),r3
   10986:	11 0a       	brb 10992 <bzero+0x12>
   10988:	c2 50 ac 08 	subl2 r0,0x8(ap)
   1098c:	2c 00 63 00 	movc5 $0x0,(r3),$0x0,r0,(r3)
   10990:	50 63 
   10992:	3c 8f ff ff 	movzwl $0xffff,r0
   10996:	50 
   10997:	d1 ac 08 50 	cmpl 0x8(ap),r0
   1099b:	14 eb       	bgtr 10988 <bzero+0x8>
   1099d:	2c 00 63 00 	movc5 $0x0,(r3),$0x0,0x8(ap),(r3)
   109a1:	ac 08 63 
   109a4:	04          	ret
   109a5:	01          	nop
   109a6:	01          	nop
   109a7:	01          	nop
   109a8:	17 ef 0b 00 	jmp 109b9 <___cerror>
   109ac:	00 00 
   109ae:	01          	nop
   109af:	01          	nop

000109b0 <_thread_sys_socket>:
   109b0:	00 00       	.word 0x0000 # Entry mask: < >
   109b2:	bc 8f 61 00 	chmk $0x0061
   109b6:	1f f0       	blssu 109a8 <bzero+0x28>
   109b8:	04          	ret

000109b9 <___cerror>:
   109b9:	d0 50 ef 54 	movl r0,62114 <errno>
   109bd:	17 05 00 
   109c0:	ce 01 50    	mnegl $0x1,r0
   109c3:	ce 01 51    	mnegl $0x1,r1
   109c6:	04          	ret
   109c7:	01          	nop

000109c8 <___errno>:
   109c8:	00 00       	.word 0x0000 # Entry mask: < >
   109ca:	c2 04 5e    	subl2 $0x4,sp
   109cd:	9e ef 41 17 	movab 62114 <errno>,r0
   109d1:	05 00 50 
   109d4:	04          	ret
   109d5:	01          	nop

000109d6 <printf>:
   109d6:	00 00       	.word 0x0000 # Entry mask: < >
   109d8:	c2 04 5e    	subl2 $0x4,sp
   109db:	9f ac 08    	pushab 0x8(ap)
   109de:	dd ac 04    	pushl 0x4(ap)
   109e1:	9f ef 41 b6 	pushab 5c028 <__sF+0x58>
   109e5:	04 00 
   109e7:	fb 03 ef 72 	calls $0x3,11460 <vfprintf>
   109eb:	0a 00 00 
   109ee:	04          	ret
   109ef:	01          	nop

000109f0 <moreglue>:
   109f0:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   109f2:	c2 04 5e    	subl2 $0x4,sp
   109f5:	d0 ac 04 57 	movl 0x4(ap),r7
   109f9:	c5 57 8f 6c 	mull3 r7,$0x0000016c,r0
   109fd:	01 00 00 50 
   10a01:	9f a0 0f    	pushab 0xf(r0)
   10a04:	fb 01 ef 17 	calls $0x1,18622 <malloc>
   10a08:	7c 00 00 
   10a0b:	d5 50       	tstl r0
   10a0d:	13 5e       	beql 10a6d <moreglue+0x7d>
   10a0f:	d0 50 59    	movl r0,r9
   10a12:	c0 0f 50    	addl2 $0xf,r0
   10a15:	cb 03 50 56 	bicl3 $0x3,r0,r6
   10a19:	c5 57 8f 58 	mull3 r7,$0x00000058,r0
   10a1d:	00 00 00 50 
   10a21:	c1 56 50 58 	addl3 r6,r0,r8
   10a25:	d4 69       	clrf (r9)
   10a27:	d0 57 a9 04 	movl r7,0x4(r9)
   10a2b:	d0 56 a9 08 	movl r6,0x8(r9)
   10a2f:	d7 57       	decl r7
   10a31:	18 04       	bgeq 10a37 <moreglue+0x47>
   10a33:	d0 59 50    	movl r9,r0
   10a36:	04          	ret
   10a37:	28 8f 58 00 	movc3 $0x0058,5d020 <empty.0>,(r6)
   10a3b:	ef e0 c5 04 
   10a3f:	00 66 
   10a41:	d0 58 a6 30 	movl r8,0x30(r6)
   10a45:	d4 68       	clrf (r8)
   10a47:	d0 a6 30 50 	movl 0x30(r6),r0
   10a4b:	d4 a0 04    	clrf 0x4(r0)
   10a4e:	3c 8f 0c 01 	movzwl $0x010c,-(sp)
   10a52:	7e 
   10a53:	d4 7e       	clrf -(sp)
   10a55:	9f a0 08    	pushab 0x8(r0)
   10a58:	fb 03 ef 99 	calls $0x3,168f8 <memset>
   10a5c:	5e 00 00 
   10a5f:	9e a6 58 56 	movab 0x58(r6),r6
   10a63:	9e c8 14 01 	movab 0x114(r8),r8
   10a67:	58 
   10a68:	f4 57 cc    	sobgeq r7,10a37 <moreglue+0x47>
   10a6b:	11 c6       	brb 10a33 <moreglue+0x43>
   10a6d:	d4 50       	clrf r0
   10a6f:	04          	ret

00010a70 <__sfp>:
   10a70:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   10a72:	c2 04 5e    	subl2 $0x4,sp
   10a75:	d5 ef d9 19 	tstl 62454 <__sdidinit>
   10a79:	05 00 
   10a7b:	12 03       	bneq 10a80 <__sfp+0x10>
   10a7d:	31 b8 00    	brw 10b38 <__sfp+0xc8>
   10a80:	9f ef 22 de 	pushab 5e8a8 <_thread_tagname___sfp_mutex>
   10a84:	04 00 
   10a86:	fb 01 ef 45 	calls $0x1,169d2 <_weak__thread_tag_lock>
   10a8a:	5f 00 00 
   10a8d:	9e ef 45 b6 	movab 5c0d8 <__sglue>,r7
   10a91:	04 00 57 
   10a94:	13 1c       	beql 10ab2 <__sfp+0x42>
   10a96:	d0 a7 08 56 	movl 0x8(r7),r6
   10a9a:	c3 01 a7 04 	subl3 $0x1,0x4(r7),r0
   10a9e:	50 
   10a9f:	19 0c       	blss 10aad <__sfp+0x3d>
   10aa1:	b5 a6 0c    	tstw 0xc(r6)
   10aa4:	13 44       	beql 10aea <__sfp+0x7a>
   10aa6:	9e a6 58 56 	movab 0x58(r6),r6
   10aaa:	f4 50 f4    	sobgeq r0,10aa1 <__sfp+0x31>
   10aad:	d0 67 57    	movl (r7),r7
   10ab0:	12 e4       	bneq 10a96 <__sfp+0x26>
   10ab2:	9f ef f0 dd 	pushab 5e8a8 <_thread_tagname___sfp_mutex>
   10ab6:	04 00 
   10ab8:	fb 01 ef 19 	calls $0x1,169d8 <_weak__thread_tag_unlock>
   10abc:	5f 00 00 
   10abf:	dd 0a       	pushl $0xa
   10ac1:	fb 01 cf 2a 	calls $0x1,109f0 <moreglue>
   10ac5:	ff 
   10ac6:	d0 50 57    	movl r0,r7
   10ac9:	13 6a       	beql 10b35 <__sfp+0xc5>
   10acb:	9f ef d7 dd 	pushab 5e8a8 <_thread_tagname___sfp_mutex>
   10acf:	04 00 
   10ad1:	fb 01 ef fa 	calls $0x1,169d2 <_weak__thread_tag_lock>
   10ad5:	5e 00 00 
   10ad8:	d0 57 ff ed 	movl r7,*5bfcc <lastglue>
   10adc:	b4 04 00 
   10adf:	d0 57 ef e6 	movl r7,5bfcc <lastglue>
   10ae3:	b4 04 00 
   10ae6:	d0 a7 08 56 	movl 0x8(r7),r6
   10aea:	b0 01 a6 0c 	movw $0x1,0xc(r6)
   10aee:	9f ef b4 dd 	pushab 5e8a8 <_thread_tagname___sfp_mutex>
   10af2:	04 00 
   10af4:	fb 01 ef dd 	calls $0x1,169d8 <_weak__thread_tag_unlock>
   10af8:	5e 00 00 
   10afb:	d4 66       	clrf (r6)
   10afd:	d4 a6 08    	clrf 0x8(r6)
   10b00:	d4 a6 04    	clrf 0x4(r6)
   10b03:	d4 a6 10    	clrf 0x10(r6)
   10b06:	d4 a6 14    	clrf 0x14(r6)
   10b09:	d4 a6 18    	clrf 0x18(r6)
   10b0c:	b2 00 a6 0e 	mcomw $0x0,0xe(r6)
   10b10:	d4 a6 44    	clrf 0x44(r6)
   10b13:	d4 a6 48    	clrf 0x48(r6)
   10b16:	d4 b6 30    	clrf *0x30(r6)
   10b19:	d0 a6 30 50 	movl 0x30(r6),r0
   10b1d:	d4 a0 04    	clrf 0x4(r0)
   10b20:	3c 8f 0c 01 	movzwl $0x010c,-(sp)
   10b24:	7e 
   10b25:	d4 7e       	clrf -(sp)
   10b27:	9f a0 08    	pushab 0x8(r0)
   10b2a:	fb 03 ef c7 	calls $0x3,168f8 <memset>
   10b2e:	5d 00 00 
   10b31:	d0 56 50    	movl r6,r0
   10b34:	04          	ret
   10b35:	d4 50       	clrf r0
   10b37:	04          	ret
   10b38:	fb 00 ef 17 	calls $0x0,10b56 <__sinit>
   10b3c:	00 00 00 
   10b3f:	31 3e ff    	brw 10a80 <__sfp+0x10>

00010b42 <_cleanup>:
   10b42:	00 00       	.word 0x0000 # Entry mask: < >
   10b44:	c2 04 5e    	subl2 $0x4,sp
   10b47:	9f ef a3 49 	pushab 154f0 <__sflush>
   10b4b:	00 00 
   10b4d:	fb 01 ef 38 	calls $0x1,1558c <_fwalk>
   10b51:	4a 00 00 
   10b54:	04          	ret
   10b55:	01          	nop

00010b56 <__sinit>:
   10b56:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   10b58:	c2 04 5e    	subl2 $0x4,sp
   10b5b:	9f ef 17 c5 	pushab 5d078 <_thread_tagname___sinit_mutex.1>
   10b5f:	04 00 
   10b61:	fb 01 ef 6a 	calls $0x1,169d2 <_weak__thread_tag_lock>
   10b65:	5e 00 00 
   10b68:	d5 ef e6 18 	tstl 62454 <__sdidinit>
   10b6c:	05 00 
   10b6e:	12 4a       	bneq 10bba <__sinit+0x64>
   10b70:	9e ef 36 c5 	movab 5d0ac <usual+0x30>,r8
   10b74:	04 00 58 
   10b77:	9e ef d7 ca 	movab 5d654 <usualext>,r6
   10b7b:	04 00 56 
   10b7e:	d0 10 57    	movl $0x10,r7
   10b81:	d0 56 68    	movl r6,(r8)
   10b84:	9e a8 58 58 	movab 0x58(r8),r8
   10b88:	d4 66       	clrf (r6)
   10b8a:	d4 a6 04    	clrf 0x4(r6)
   10b8d:	3c 8f 0c 01 	movzwl $0x010c,-(sp)
   10b91:	7e 
   10b92:	d4 7e       	clrf -(sp)
   10b94:	9f a6 08    	pushab 0x8(r6)
   10b97:	fb 03 ef 5a 	calls $0x3,168f8 <memset>
   10b9b:	5d 00 00 
   10b9e:	9e c6 14 01 	movab 0x114(r6),r6
   10ba2:	56 
   10ba3:	f4 57 db    	sobgeq r7,10b81 <__sinit+0x2b>
   10ba6:	9f ef 96 ff 	pushab 10b42 <_cleanup>
   10baa:	ff ff 
   10bac:	fb 01 ef b5 	calls $0x1,10e68 <__atexit_register_cleanup>
   10bb0:	02 00 00 
   10bb3:	d0 01 ef 9a 	movl $0x1,62454 <__sdidinit>
   10bb7:	18 05 00 
   10bba:	9f ef b8 c4 	pushab 5d078 <_thread_tagname___sinit_mutex.1>
   10bbe:	04 00 
   10bc0:	fb 01 ef 11 	calls $0x1,169d8 <_weak__thread_tag_unlock>
   10bc4:	5e 00 00 
   10bc7:	04          	ret

00010bc8 <exit>:
   10bc8:	00 00       	.word 0x0000 # Entry mask: < >
   10bca:	c2 04 5e    	subl2 $0x4,sp
   10bcd:	d4 7e       	clrf -(sp)
   10bcf:	fb 01 ef 16 	calls $0x1,10cec <__cxa_finalize>
   10bd3:	01 00 00 
   10bd6:	dd ac 04    	pushl 0x4(ap)
   10bd9:	fb 01 ef d8 	calls $0x1,169b8 <_thread_sys__exit>
   10bdd:	5d 00 00 

00010be0 <__cxa_atexit>:
   10be0:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   10be2:	c2 04 5e    	subl2 $0x4,sp
   10be5:	fb 00 ef 1e 	calls $0x0,15e0a <getpagesize>
   10be9:	52 00 00 
   10bec:	d0 50 57    	movl r0,r7
   10bef:	d2 00 58    	mcoml $0x0,r8
   10bf2:	d1 50 17    	cmpl r0,$0x17
   10bf5:	1a 03       	bgtru 10bfa <__cxa_atexit+0x1a>
   10bf7:	31 ee 00    	brw 10ce8 <__cxa_atexit+0x108>
   10bfa:	d5 ef e4 b4 	tstl 5c0e4 <__isthreaded>
   10bfe:	04 00 
   10c00:	13 03       	beql 10c05 <__cxa_atexit+0x25>
   10c02:	31 d9 00    	brw 10cde <__cxa_atexit+0xfe>
   10c05:	d0 ef 4d 18 	movl 62458 <__atexit>,r6
   10c09:	05 00 56 
   10c0c:	13 10       	beql 10c1e <__cxa_atexit+0x3e>
   10c0e:	c1 a6 04 01 	addl3 0x4(r6),$0x1,r0
   10c12:	50 
   10c13:	d1 50 a6 08 	cmpl r0,0x8(r6)
   10c17:	18 03       	bgeq 10c1c <__cxa_atexit+0x3c>
   10c19:	31 ab 00    	brw 10cc7 <__cxa_atexit+0xe7>
   10c1c:	d4 56       	clrf r6
   10c1e:	d5 56       	tstl r6
   10c20:	13 4a       	beql 10c6c <__cxa_atexit+0x8c>
   10c22:	c5 a6 04 0c 	mull3 0x4(r6),$0xc,r0
   10c26:	50 
   10c27:	9e 46 a0 0c 	movab 0xc(r0)[r6],r0
   10c2b:	50 
   10c2c:	d6 a6 04    	incl 0x4(r6)
   10c2f:	d0 ac 04 60 	movl 0x4(ap),(r0)
   10c33:	d0 ac 08 a0 	movl 0x8(ap),0x4(r0)
   10c37:	04 
   10c38:	d0 ac 0c a0 	movl 0xc(ap),0x8(r0)
   10c3c:	08 
   10c3d:	dd 01       	pushl $0x1
   10c3f:	dd 57       	pushl r7
   10c41:	dd 56       	pushl r6
   10c43:	fb 03 ef 0e 	calls $0x3,16a58 <_thread_sys_mprotect>
   10c47:	5e 00 00 
   10c4a:	d5 50       	tstl r0
   10c4c:	12 09       	bneq 10c57 <__cxa_atexit+0x77>
   10c4e:	d0 01 ef 5b 	movl $0x1,5e8b0 <restartloop>
   10c52:	dc 04 00 
   10c55:	d4 58       	clrf r8
   10c57:	d5 ef 87 b4 	tstl 5c0e4 <__isthreaded>
   10c5b:	04 00 
   10c5d:	12 04       	bneq 10c63 <__cxa_atexit+0x83>
   10c5f:	d0 58 50    	movl r8,r0
   10c62:	04          	ret
   10c63:	fb 00 ef 7e 	calls $0x0,16ae8 <_weak__thread_atexit_unlock>
   10c67:	5e 00 00 
   10c6a:	11 f3       	brb 10c5f <__cxa_atexit+0x7f>
   10c6c:	7c 7e       	clrd -(sp)
   10c6e:	d2 00 7e    	mcoml $0x0,-(sp)
   10c71:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   10c75:	7e 
   10c76:	dd 03       	pushl $0x3
   10c78:	dd 57       	pushl r7
   10c7a:	d4 7e       	clrf -(sp)
   10c7c:	fb 07 ef df 	calls $0x7,16a62 <_thread_sys_mmap>
   10c80:	5d 00 00 
   10c83:	d0 50 56    	movl r0,r6
   10c86:	d1 50 8f ff 	cmpl r0,$0xffffffff
   10c8a:	ff ff ff 
   10c8d:	13 c8       	beql 10c57 <__cxa_atexit+0x77>
   10c8f:	d5 ef c3 17 	tstl 62458 <__atexit>
   10c93:	05 00 
   10c95:	12 2b       	bneq 10cc2 <__cxa_atexit+0xe2>
   10c97:	7c a0 0c    	clrd 0xc(r0)
   10c9a:	d4 a0 14    	clrf 0x14(r0)
   10c9d:	d0 01 a0 04 	movl $0x1,0x4(r0)
   10ca1:	dd 0c       	pushl $0xc
   10ca3:	9f a7 f4    	pushab 0xfffffff4(r7)
   10ca6:	fb 02 ef 37 	calls $0x2,15ce4 <__udiv>
   10caa:	50 00 00 
   10cad:	d0 50 a6 08 	movl r0,0x8(r6)
   10cb1:	d0 ef a1 17 	movl 62458 <__atexit>,(r6)
   10cb5:	05 00 66 
   10cb8:	d0 56 ef 99 	movl r6,62458 <__atexit>
   10cbc:	17 05 00 
   10cbf:	31 60 ff    	brw 10c22 <__cxa_atexit+0x42>
   10cc2:	d4 a0 04    	clrf 0x4(r0)
   10cc5:	11 da       	brb 10ca1 <__cxa_atexit+0xc1>
   10cc7:	dd 03       	pushl $0x3
   10cc9:	dd 57       	pushl r7
   10ccb:	dd 56       	pushl r6
   10ccd:	fb 03 ef 84 	calls $0x3,16a58 <_thread_sys_mprotect>
   10cd1:	5d 00 00 
   10cd4:	d5 50       	tstl r0
   10cd6:	12 03       	bneq 10cdb <__cxa_atexit+0xfb>
   10cd8:	31 43 ff    	brw 10c1e <__cxa_atexit+0x3e>
   10cdb:	31 79 ff    	brw 10c57 <__cxa_atexit+0x77>
   10cde:	fb 00 ef fd 	calls $0x0,16ae2 <_weak__thread_atexit_lock>
   10ce2:	5d 00 00 
   10ce5:	31 1d ff    	brw 10c05 <__cxa_atexit+0x25>
   10ce8:	d0 58 50    	movl r8,r0
   10ceb:	04          	ret

00010cec <__cxa_finalize>:
   10cec:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   10cee:	c2 10 5e    	subl2 $0x10,sp
   10cf1:	d0 ac 04 5a 	movl 0x4(ap),r10
   10cf5:	fb 00 ef 0e 	calls $0x0,15e0a <getpagesize>
   10cf9:	51 00 00 
   10cfc:	d0 50 5b    	movl r0,r11
   10cff:	d5 ef df b3 	tstl 5c0e4 <__isthreaded>
   10d03:	04 00 
   10d05:	13 03       	beql 10d0a <__cxa_finalize+0x1e>
   10d07:	31 54 01    	brw 10e5e <__cxa_finalize+0x172>
   10d0a:	d6 ef 9c db 	incl 5e8ac <call_depth.0>
   10d0e:	04 00 
   10d10:	d4 ef 9a db 	clrf 5e8b0 <restartloop>
   10d14:	04 00 
   10d16:	d0 ef 3c 17 	movl 62458 <__atexit>,r8
   10d1a:	05 00 58 
   10d1d:	13 22       	beql 10d41 <__cxa_finalize+0x55>
   10d1f:	c3 01 a8 04 	subl3 $0x1,0x4(r8),r7
   10d23:	57 
   10d24:	19 16       	blss 10d3c <__cxa_finalize+0x50>
   10d26:	c5 57 0c 50 	mull3 r7,$0xc,r0
   10d2a:	c1 50 58 56 	addl3 r0,r8,r6
   10d2e:	d5 a6 0c    	tstl 0xc(r6)
   10d31:	13 03       	beql 10d36 <__cxa_finalize+0x4a>
   10d33:	31 bc 00    	brw 10df2 <__cxa_finalize+0x106>
   10d36:	c2 0c 56    	subl2 $0xc,r6
   10d39:	f4 57 f2    	sobgeq r7,10d2e <__cxa_finalize+0x42>
   10d3c:	d0 68 58    	movl (r8),r8
   10d3f:	12 de       	bneq 10d1f <__cxa_finalize+0x33>
   10d41:	d7 ef 65 db 	decl 5e8ac <call_depth.0>
   10d45:	04 00 
   10d47:	d5 5a       	tstl r10
   10d49:	13 78       	beql 10dc3 <__cxa_finalize+0xd7>
   10d4b:	d5 ef 93 b3 	tstl 5c0e4 <__isthreaded>
   10d4f:	04 00 
   10d51:	12 67       	bneq 10dba <__cxa_finalize+0xce>
   10d53:	d5 5a       	tstl r10
   10d55:	13 2e       	beql 10d85 <__cxa_finalize+0x99>
   10d57:	9e ef 8b b3 	movab 5c0e8 <_atfork_list>,r6
   10d5b:	04 00 56 
   10d5e:	d5 66       	tstl (r6)
   10d60:	13 23       	beql 10d85 <__cxa_finalize+0x99>
   10d62:	d5 ef 7c b3 	tstl 5c0e4 <__isthreaded>
   10d66:	04 00 
   10d68:	12 47       	bneq 10db1 <__cxa_finalize+0xc5>
   10d6a:	d0 66 50    	movl (r6),r0
   10d6d:	13 0e       	beql 10d7d <__cxa_finalize+0x91>
   10d6f:	d0 60 56    	movl (r0),r6
   10d72:	d1 a0 14 5a 	cmpl 0x14(r0),r10
   10d76:	13 17       	beql 10d8f <__cxa_finalize+0xa3>
   10d78:	d0 56 50    	movl r6,r0
   10d7b:	12 f2       	bneq 10d6f <__cxa_finalize+0x83>
   10d7d:	d5 ef 61 b3 	tstl 5c0e4 <__isthreaded>
   10d81:	04 00 
   10d83:	12 01       	bneq 10d86 <__cxa_finalize+0x9a>
   10d85:	04          	ret
   10d86:	fb 00 ef 67 	calls $0x0,16af4 <_weak__thread_atfork_unlock>
   10d8a:	5d 00 00 
   10d8d:	11 f6       	brb 10d85 <__cxa_finalize+0x99>
   10d8f:	d5 56       	tstl r6
   10d91:	13 14       	beql 10da7 <__cxa_finalize+0xbb>
   10d93:	d0 a0 04 a6 	movl 0x4(r0),0x4(r6)
   10d97:	04 
   10d98:	d0 60 b0 04 	movl (r0),*0x4(r0)
   10d9c:	dd 50       	pushl r0
   10d9e:	fb 01 ef 23 	calls $0x1,188c8 <free>
   10da2:	7b 00 00 
   10da5:	11 d1       	brb 10d78 <__cxa_finalize+0x8c>
   10da7:	d0 a0 04 ef 	movl 0x4(r0),5c0ec <_atfork_list+0x4>
   10dab:	3d b3 04 00 
   10daf:	11 e7       	brb 10d98 <__cxa_finalize+0xac>
   10db1:	fb 00 ef 36 	calls $0x0,16aee <_weak__thread_atfork_lock>
   10db5:	5d 00 00 
   10db8:	11 b0       	brb 10d6a <__cxa_finalize+0x7e>
   10dba:	fb 00 ef 27 	calls $0x0,16ae8 <_weak__thread_atexit_unlock>
   10dbe:	5d 00 00 
   10dc1:	11 90       	brb 10d53 <__cxa_finalize+0x67>
   10dc3:	d5 ef e3 da 	tstl 5e8ac <call_depth.0>
   10dc7:	04 00 
   10dc9:	12 80       	bneq 10d4b <__cxa_finalize+0x5f>
   10dcb:	d0 ef 87 16 	movl 62458 <__atexit>,r8
   10dcf:	05 00 58 
   10dd2:	13 15       	beql 10de9 <__cxa_finalize+0xfd>
   10dd4:	d0 58 50    	movl r8,r0
   10dd7:	d0 68 58    	movl (r8),r8
   10dda:	dd 5b       	pushl r11
   10ddc:	dd 50       	pushl r0
   10dde:	fb 02 ef e7 	calls $0x2,16acc <_thread_sys_munmap>
   10de2:	5c 00 00 
   10de5:	d5 58       	tstl r8
   10de7:	12 eb       	bneq 10dd4 <__cxa_finalize+0xe8>
   10de9:	d4 ef 69 16 	clrf 62458 <__atexit>
   10ded:	05 00 
   10def:	31 59 ff    	brw 10d4b <__cxa_finalize+0x5f>
   10df2:	d5 5a       	tstl r10
   10df4:	13 09       	beql 10dff <__cxa_finalize+0x113>
   10df6:	d1 5a a6 14 	cmpl r10,0x14(r6)
   10dfa:	13 03       	beql 10dff <__cxa_finalize+0x113>
   10dfc:	31 37 ff    	brw 10d36 <__cxa_finalize+0x4a>
   10dff:	28 0c a6 0c 	movc3 $0xc,0xc(r6),0xfffffff0(fp)
   10e03:	ad f0 
   10e05:	dd 03       	pushl $0x3
   10e07:	dd 5b       	pushl r11
   10e09:	dd 58       	pushl r8
   10e0b:	9e ef 47 5c 	movab 16a58 <_thread_sys_mprotect>,r9
   10e0f:	00 00 59 
   10e12:	fb 03 69    	calls $0x3,(r9)
   10e15:	d5 50       	tstl r0
   10e17:	13 37       	beql 10e50 <__cxa_finalize+0x164>
   10e19:	d5 ef c5 b2 	tstl 5c0e4 <__isthreaded>
   10e1d:	04 00 
   10e1f:	12 26       	bneq 10e47 <__cxa_finalize+0x15b>
   10e21:	dd ad f4    	pushl 0xfffffff4(fp)
   10e24:	fb 01 bd f0 	calls $0x1,*0xfffffff0(fp)
   10e28:	d5 ef b6 b2 	tstl 5c0e4 <__isthreaded>
   10e2c:	04 00 
   10e2e:	12 0e       	bneq 10e3e <__cxa_finalize+0x152>
   10e30:	d5 ef 7a da 	tstl 5e8b0 <restartloop>
   10e34:	04 00 
   10e36:	13 03       	beql 10e3b <__cxa_finalize+0x14f>
   10e38:	31 d5 fe    	brw 10d10 <__cxa_finalize+0x24>
   10e3b:	31 f8 fe    	brw 10d36 <__cxa_finalize+0x4a>
   10e3e:	fb 00 ef 9d 	calls $0x0,16ae2 <_weak__thread_atexit_lock>
   10e42:	5c 00 00 
   10e45:	11 e9       	brb 10e30 <__cxa_finalize+0x144>
   10e47:	fb 00 ef 9a 	calls $0x0,16ae8 <_weak__thread_atexit_unlock>
   10e4b:	5c 00 00 
   10e4e:	11 d1       	brb 10e21 <__cxa_finalize+0x135>
   10e50:	d4 a6 0c    	clrf 0xc(r6)
   10e53:	dd 01       	pushl $0x1
   10e55:	dd 5b       	pushl r11
   10e57:	dd 58       	pushl r8
   10e59:	fb 03 69    	calls $0x3,(r9)
   10e5c:	11 bb       	brb 10e19 <__cxa_finalize+0x12d>
   10e5e:	fb 00 ef 7d 	calls $0x0,16ae2 <_weak__thread_atexit_lock>
   10e62:	5c 00 00 
   10e65:	31 a2 fe    	brw 10d0a <__cxa_finalize+0x1e>

00010e68 <__atexit_register_cleanup>:
   10e68:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   10e6a:	c2 04 5e    	subl2 $0x4,sp
   10e6d:	fb 00 ef 96 	calls $0x0,15e0a <getpagesize>
   10e71:	4f 00 00 
   10e74:	d0 50 57    	movl r0,r7
   10e77:	d1 50 17    	cmpl r0,$0x17
   10e7a:	1b 5d       	blequ 10ed9 <__atexit_register_cleanup+0x71>
   10e7c:	d5 ef 62 b2 	tstl 5c0e4 <__isthreaded>
   10e80:	04 00 
   10e82:	13 03       	beql 10e87 <__atexit_register_cleanup+0x1f>
   10e84:	31 9e 00    	brw 10f25 <__atexit_register_cleanup+0xbd>
   10e87:	d0 ef cb 15 	movl 62458 <__atexit>,r6
   10e8b:	05 00 56 
   10e8e:	13 0d       	beql 10e9d <__atexit_register_cleanup+0x35>
   10e90:	d5 66       	tstl (r6)
   10e92:	13 09       	beql 10e9d <__atexit_register_cleanup+0x35>
   10e94:	d0 66 56    	movl (r6),r6
   10e97:	13 04       	beql 10e9d <__atexit_register_cleanup+0x35>
   10e99:	d5 66       	tstl (r6)
   10e9b:	12 f7       	bneq 10e94 <__atexit_register_cleanup+0x2c>
   10e9d:	d5 56       	tstl r6
   10e9f:	13 42       	beql 10ee3 <__atexit_register_cleanup+0x7b>
   10ea1:	dd 03       	pushl $0x3
   10ea3:	dd 57       	pushl r7
   10ea5:	dd 56       	pushl r6
   10ea7:	fb 03 ef aa 	calls $0x3,16a58 <_thread_sys_mprotect>
   10eab:	5b 00 00 
   10eae:	d5 50       	tstl r0
   10eb0:	12 1f       	bneq 10ed1 <__atexit_register_cleanup+0x69>
   10eb2:	d0 ac 04 a6 	movl 0x4(ap),0xc(r6)
   10eb6:	0c 
   10eb7:	d4 a6 10    	clrf 0x10(r6)
   10eba:	d4 a6 14    	clrf 0x14(r6)
   10ebd:	dd 01       	pushl $0x1
   10ebf:	dd 57       	pushl r7
   10ec1:	dd 56       	pushl r6
   10ec3:	fb 03 ef 8e 	calls $0x3,16a58 <_thread_sys_mprotect>
   10ec7:	5b 00 00 
   10eca:	d0 01 ef df 	movl $0x1,5e8b0 <restartloop>
   10ece:	d9 04 00 
   10ed1:	d5 ef 0d b2 	tstl 5c0e4 <__isthreaded>
   10ed5:	04 00 
   10ed7:	12 01       	bneq 10eda <__atexit_register_cleanup+0x72>
   10ed9:	04          	ret
   10eda:	fb 00 ef 07 	calls $0x0,16ae8 <_weak__thread_atexit_unlock>
   10ede:	5c 00 00 
   10ee1:	11 f6       	brb 10ed9 <__atexit_register_cleanup+0x71>
   10ee3:	7c 7e       	clrd -(sp)
   10ee5:	d2 00 7e    	mcoml $0x0,-(sp)
   10ee8:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   10eec:	7e 
   10eed:	dd 03       	pushl $0x3
   10eef:	dd 57       	pushl r7
   10ef1:	d4 7e       	clrf -(sp)
   10ef3:	fb 07 ef 68 	calls $0x7,16a62 <_thread_sys_mmap>
   10ef7:	5b 00 00 
   10efa:	d0 50 56    	movl r0,r6
   10efd:	d1 50 8f ff 	cmpl r0,$0xffffffff
   10f01:	ff ff ff 
   10f04:	13 cb       	beql 10ed1 <__atexit_register_cleanup+0x69>
   10f06:	d0 01 a0 04 	movl $0x1,0x4(r0)
   10f0a:	dd 0c       	pushl $0xc
   10f0c:	9f a7 f4    	pushab 0xfffffff4(r7)
   10f0f:	fb 02 ef ce 	calls $0x2,15ce4 <__udiv>
   10f13:	4d 00 00 
   10f16:	d0 50 a6 08 	movl r0,0x8(r6)
   10f1a:	d4 66       	clrf (r6)
   10f1c:	d0 56 ef 35 	movl r6,62458 <__atexit>
   10f20:	15 05 00 
   10f23:	11 8d       	brb 10eb2 <__atexit_register_cleanup+0x4a>
   10f25:	fb 00 ef b6 	calls $0x0,16ae2 <_weak__thread_atexit_lock>
   10f29:	5b 00 00 
   10f2c:	31 58 ff    	brw 10e87 <__atexit_register_cleanup+0x1f>
   10f2f:	01          	nop

00010f30 <fork>:
   10f30:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   10f32:	c2 04 5e    	subl2 $0x4,sp
   10f35:	d5 ef ad b1 	tstl 5c0e8 <_atfork_list>
   10f39:	04 00 
   10f3b:	12 03       	bneq 10f40 <fork+0x10>
   10f3d:	31 88 00    	brw 10fc8 <fork+0x98>
   10f40:	d5 ef 9e b1 	tstl 5c0e4 <__isthreaded>
   10f44:	04 00 
   10f46:	12 77       	bneq 10fbf <fork+0x8f>
   10f48:	d0 ef 9e b1 	movl 5c0ec <_atfork_list+0x4>,r0
   10f4c:	04 00 50 
   10f4f:	d0 b0 04 56 	movl *0x4(r0),r6
   10f53:	13 10       	beql 10f65 <fork+0x35>
   10f55:	d0 a6 08 50 	movl 0x8(r6),r0
   10f59:	12 5f       	bneq 10fba <fork+0x8a>
   10f5b:	d0 a6 04 50 	movl 0x4(r6),r0
   10f5f:	d0 b0 04 56 	movl *0x4(r0),r6
   10f63:	12 f0       	bneq 10f55 <fork+0x25>
   10f65:	fb 00 ef 50 	calls $0x0,16abc <_thread_sys_fork>
   10f69:	5b 00 00 
   10f6c:	d0 50 57    	movl r0,r7
   10f6f:	12 2e       	bneq 10f9f <fork+0x6f>
   10f71:	d0 ef 71 b1 	movl 5c0e8 <_atfork_list>,r6
   10f75:	04 00 56 
   10f78:	13 0b       	beql 10f85 <fork+0x55>
   10f7a:	d0 a6 10 50 	movl 0x10(r6),r0
   10f7e:	12 1a       	bneq 10f9a <fork+0x6a>
   10f80:	d0 66 56    	movl (r6),r6
   10f83:	12 f5       	bneq 10f7a <fork+0x4a>
   10f85:	d5 ef 59 b1 	tstl 5c0e4 <__isthreaded>
   10f89:	04 00 
   10f8b:	12 04       	bneq 10f91 <fork+0x61>
   10f8d:	d0 57 50    	movl r7,r0
   10f90:	04          	ret
   10f91:	fb 00 ef 5c 	calls $0x0,16af4 <_weak__thread_atfork_unlock>
   10f95:	5b 00 00 
   10f98:	11 f3       	brb 10f8d <fork+0x5d>
   10f9a:	fb 00 60    	calls $0x0,(r0)
   10f9d:	11 e1       	brb 10f80 <fork+0x50>
   10f9f:	d0 ef 43 b1 	movl 5c0e8 <_atfork_list>,r6
   10fa3:	04 00 56 
   10fa6:	13 dd       	beql 10f85 <fork+0x55>
   10fa8:	d0 a6 0c 50 	movl 0xc(r6),r0
   10fac:	12 07       	bneq 10fb5 <fork+0x85>
   10fae:	d0 66 56    	movl (r6),r6
   10fb1:	12 f5       	bneq 10fa8 <fork+0x78>
   10fb3:	11 d0       	brb 10f85 <fork+0x55>
   10fb5:	fb 00 60    	calls $0x0,(r0)
   10fb8:	11 f4       	brb 10fae <fork+0x7e>
   10fba:	fb 00 60    	calls $0x0,(r0)
   10fbd:	11 9c       	brb 10f5b <fork+0x2b>
   10fbf:	fb 00 ef 28 	calls $0x0,16aee <_weak__thread_atfork_lock>
   10fc3:	5b 00 00 
   10fc6:	11 80       	brb 10f48 <fork+0x18>
   10fc8:	fb 00 ef ed 	calls $0x0,16abc <_thread_sys_fork>
   10fcc:	5a 00 00 
   10fcf:	04          	ret

00010fd0 <recv>:
   10fd0:	00 00       	.word 0x0000 # Entry mask: < >
   10fd2:	c2 04 5e    	subl2 $0x4,sp
   10fd5:	d4 7e       	clrf -(sp)
   10fd7:	d4 7e       	clrf -(sp)
   10fd9:	dd ac 10    	pushl 0x10(ap)
   10fdc:	dd ac 0c    	pushl 0xc(ap)
   10fdf:	dd ac 08    	pushl 0x8(ap)
   10fe2:	dd ac 04    	pushl 0x4(ap)
   10fe5:	fb 06 ef 58 	calls $0x6,16944 <_thread_sys_recvfrom>
   10fe9:	59 00 00 
   10fec:	04          	ret
   10fed:	01          	nop

00010fee <send>:
   10fee:	00 00       	.word 0x0000 # Entry mask: < >
   10ff0:	c2 04 5e    	subl2 $0x4,sp
   10ff3:	d4 7e       	clrf -(sp)
   10ff5:	d4 7e       	clrf -(sp)
   10ff7:	dd ac 10    	pushl 0x10(ap)
   10ffa:	dd ac 0c    	pushl 0xc(ap)
   10ffd:	dd ac 08    	pushl 0x8(ap)
   11000:	dd ac 04    	pushl 0x4(ap)
   11003:	fb 06 ef be 	calls $0x6,169c8 <_thread_sys_sendto>
   11007:	59 00 00 
   1100a:	04          	ret
   1100b:	01          	nop

0001100c <getc_unlocked>:
   1100c:	00 00       	.word 0x0000 # Entry mask: < >
   1100e:	c2 04 5e    	subl2 $0x4,sp
   11011:	d0 ac 04 51 	movl 0x4(ap),r1
   11015:	d7 a1 04    	decl 0x4(r1)
   11018:	19 07       	blss 11021 <getc_unlocked+0x15>
   1101a:	9a b1 00 50 	movzbl *0x0(r1),r0
   1101e:	d6 61       	incl (r1)
   11020:	04          	ret
   11021:	dd 51       	pushl r1
   11023:	fb 01 ef 4e 	calls $0x1,11078 <__srget>
   11027:	00 00 00 
   1102a:	04          	ret
   1102b:	01          	nop

0001102c <getc>:
   1102c:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   1102e:	c2 04 5e    	subl2 $0x4,sp
   11031:	d0 ac 04 56 	movl 0x4(ap),r6
   11035:	d5 ef a9 b0 	tstl 5c0e4 <__isthreaded>
   11039:	04 00 
   1103b:	12 30       	bneq 1106d <getc+0x41>
   1103d:	d7 a6 04    	decl 0x4(r6)
   11040:	19 1d       	blss 1105f <getc+0x33>
   11042:	9a b6 00 57 	movzbl *0x0(r6),r7
   11046:	d6 66       	incl (r6)
   11048:	d5 ef 96 b0 	tstl 5c0e4 <__isthreaded>
   1104c:	04 00 
   1104e:	12 04       	bneq 11054 <getc+0x28>
   11050:	d0 57 50    	movl r7,r0
   11053:	04          	ret
   11054:	dd 56       	pushl r6
   11056:	fb 01 ef cb 	calls $0x1,16b28 <_weak_funlockfile>
   1105a:	5a 00 00 
   1105d:	11 f1       	brb 11050 <getc+0x24>
   1105f:	dd 56       	pushl r6
   11061:	fb 01 ef 10 	calls $0x1,11078 <__srget>
   11065:	00 00 00 
   11068:	d0 50 57    	movl r0,r7
   1106b:	11 db       	brb 11048 <getc+0x1c>
   1106d:	dd 56       	pushl r6
   1106f:	fb 01 ef a4 	calls $0x1,16b1a <_weak_flockfile>
   11073:	5a 00 00 
   11076:	11 c5       	brb 1103d <getc+0x11>

00011078 <__srget>:
   11078:	40 00       	.word 0x0040 # Entry mask: < r6 >
   1107a:	c2 04 5e    	subl2 $0x4,sp
   1107d:	d0 ac 04 56 	movl 0x4(ap),r6
   11081:	d0 a6 30 50 	movl 0x30(r6),r0
   11085:	13 2d       	beql 110b4 <__srget+0x3c>
   11087:	c0 08 50    	addl2 $0x8,r0
   1108a:	d5 50       	tstl r0
   1108c:	13 0b       	beql 11099 <__srget+0x21>
   1108e:	d5 c0 08 01 	tstl 0x108(r0)
   11092:	12 05       	bneq 11099 <__srget+0x21>
   11094:	d2 00 c0 08 	mcoml $0x0,0x108(r0)
   11098:	01 
   11099:	dd 56       	pushl r6
   1109b:	fb 01 ef 3c 	calls $0x1,110de <__srefill>
   1109f:	00 00 00 
   110a2:	d5 50       	tstl r0
   110a4:	12 0a       	bneq 110b0 <__srget+0x38>
   110a6:	d7 a6 04    	decl 0x4(r6)
   110a9:	9a b6 00 50 	movzbl *0x0(r6),r0
   110ad:	d6 66       	incl (r6)
   110af:	04          	ret
   110b0:	d2 00 50    	mcoml $0x0,r0
   110b3:	04          	ret
   110b4:	d4 50       	clrf r0
   110b6:	11 d2       	brb 1108a <__srget+0x12>

000110b8 <lflush>:
   110b8:	00 00       	.word 0x0000 # Entry mask: < >
   110ba:	c2 04 5e    	subl2 $0x4,sp
   110bd:	d0 ac 04 51 	movl 0x4(ap),r1
   110c1:	b0 a1 0c 50 	movw 0xc(r1),r0
   110c5:	ca 8f f6 ff 	bicl2 $0xfffffff6,r0
   110c9:	ff ff 50 
   110cc:	d1 50 09    	cmpl r0,$0x9
   110cf:	13 03       	beql 110d4 <lflush+0x1c>
   110d1:	d4 50       	clrf r0
   110d3:	04          	ret
   110d4:	dd 51       	pushl r1
   110d6:	fb 01 ef 6f 	calls $0x1,1554c <__sflush_locked>
   110da:	44 00 00 
   110dd:	04          	ret

000110de <__srefill>:
   110de:	40 00       	.word 0x0040 # Entry mask: < r6 >
   110e0:	c2 04 5e    	subl2 $0x4,sp
   110e3:	d0 ac 04 56 	movl 0x4(ap),r6
   110e7:	d5 ef 67 13 	tstl 62454 <__sdidinit>
   110eb:	05 00 
   110ed:	12 03       	bneq 110f2 <__srefill+0x14>
   110ef:	31 0f 01    	brw 11201 <__srefill+0x123>
   110f2:	d4 a6 04    	clrf 0x4(r6)
   110f5:	32 a6 0c 50 	cvtwl 0xc(r6),r0
   110f9:	e0 05 50 56 	bbs $0x5,r0,11153 <__srefill+0x75>
   110fd:	e1 02 50 03 	bbc $0x2,r0,11104 <__srefill+0x26>
   11101:	31 cb 00    	brw 111cf <__srefill+0xf1>
   11104:	e0 04 50 03 	bbs $0x4,r0,1110b <__srefill+0x2d>
   11108:	31 b2 00    	brw 111bd <__srefill+0xdf>
   1110b:	e1 03 50 03 	bbc $0x3,r0,11112 <__srefill+0x34>
   1110f:	31 91 00    	brw 111a3 <__srefill+0xc5>
   11112:	a8 04 a6 0c 	bisw2 $0x4,0xc(r6)
   11116:	d5 a6 10    	tstl 0x10(r6)
   11119:	13 7c       	beql 11197 <__srefill+0xb9>
   1111b:	b0 a6 0c 50 	movw 0xc(r6),r0
   1111f:	d3 50 03    	bitl r0,$0x3
   11122:	12 3f       	bneq 11163 <__srefill+0x85>
   11124:	d0 a6 10 66 	movl 0x10(r6),(r6)
   11128:	dd a6 14    	pushl 0x14(r6)
   1112b:	dd 66       	pushl (r6)
   1112d:	dd a6 1c    	pushl 0x1c(r6)
   11130:	fb 03 b6 24 	calls $0x3,*0x24(r6)
   11134:	d0 50 a6 04 	movl r0,0x4(r6)
   11138:	ab 8f 00 20 	bicw3 $0x2000,0xc(r6),r1
   1113c:	a6 0c 51 
   1113f:	b0 51 a6 0c 	movw r1,0xc(r6)
   11143:	d5 50       	tstl r0
   11145:	15 03       	bleq 1114a <__srefill+0x6c>
   11147:	d4 50       	clrf r0
   11149:	04          	ret
   1114a:	d5 50       	tstl r0
   1114c:	12 09       	bneq 11157 <__srefill+0x79>
   1114e:	a9 20 51 a6 	bisw3 $0x20,r1,0xc(r6)
   11152:	0c 
   11153:	d2 00 50    	mcoml $0x0,r0
   11156:	04          	ret
   11157:	d4 a6 04    	clrf 0x4(r6)
   1115a:	a9 8f 40 00 	bisw3 $0x0040,r1,0xc(r6)
   1115e:	51 a6 0c 
   11161:	11 f0       	brb 11153 <__srefill+0x75>
   11163:	a9 8f 00 80 	bisw3 $0x8000,r0,0xc(r6)
   11167:	50 a6 0c 
   1116a:	9f cf 4a ff 	pushab 110b8 <lflush>
   1116e:	fb 01 ef 17 	calls $0x1,1558c <_fwalk>
   11172:	44 00 00 
   11175:	ab 8f 00 80 	bicw3 $0x8000,0xc(r6),r0
   11179:	a6 0c 50 
   1117c:	b0 50 a6 0c 	movw r0,0xc(r6)
   11180:	ca 8f f6 ff 	bicl2 $0xfffffff6,r0
   11184:	ff ff 50 
   11187:	d1 50 09    	cmpl r0,$0x9
   1118a:	12 98       	bneq 11124 <__srefill+0x46>
   1118c:	dd 56       	pushl r6
   1118e:	fb 01 ef 5b 	calls $0x1,154f0 <__sflush>
   11192:	43 00 00 
   11195:	11 8d       	brb 11124 <__srefill+0x46>
   11197:	dd 56       	pushl r6
   11199:	fb 01 ef ca 	calls $0x1,1566a <__smakebuf>
   1119d:	44 00 00 
   111a0:	31 78 ff    	brw 1111b <__srefill+0x3d>
   111a3:	dd 56       	pushl r6
   111a5:	fb 01 ef 44 	calls $0x1,154f0 <__sflush>
   111a9:	43 00 00 
   111ac:	d5 50       	tstl r0
   111ae:	12 a3       	bneq 11153 <__srefill+0x75>
   111b0:	aa 08 a6 0c 	bicw2 $0x8,0xc(r6)
   111b4:	d4 a6 08    	clrf 0x8(r6)
   111b7:	d4 a6 18    	clrf 0x18(r6)
   111ba:	31 55 ff    	brw 11112 <__srefill+0x34>
   111bd:	fb 00 ef 04 	calls $0x0,109c8 <___errno>
   111c1:	f8 ff ff 
   111c4:	d0 09 60    	movl $0x9,(r0)
   111c7:	a8 8f 40 00 	bisw2 $0x0040,0xc(r6)
   111cb:	a6 0c 
   111cd:	11 84       	brb 11153 <__srefill+0x75>
   111cf:	d0 b6 30 51 	movl *0x30(r6),r1
   111d3:	12 03       	bneq 111d8 <__srefill+0xfa>
   111d5:	31 3e ff    	brw 11116 <__srefill+0x38>
   111d8:	9e a6 40 50 	movab 0x40(r6),r0
   111dc:	d1 51 50    	cmpl r1,r0
   111df:	13 09       	beql 111ea <__srefill+0x10c>
   111e1:	dd 51       	pushl r1
   111e3:	fb 01 ef de 	calls $0x1,188c8 <free>
   111e7:	76 00 00 
   111ea:	d4 b6 30    	clrf *0x30(r6)
   111ed:	d0 a6 3c 50 	movl 0x3c(r6),r0
   111f1:	d0 50 a6 04 	movl r0,0x4(r6)
   111f5:	12 03       	bneq 111fa <__srefill+0x11c>
   111f7:	31 1c ff    	brw 11116 <__srefill+0x38>
   111fa:	d0 a6 38 66 	movl 0x38(r6),(r6)
   111fe:	d4 50       	clrf r0
   11200:	04          	ret
   11201:	fb 00 ef 4e 	calls $0x0,10b56 <__sinit>
   11205:	f9 ff ff 
   11208:	31 e7 fe    	brw 110f2 <__srefill+0x14>
   1120b:	01          	nop

0001120c <strncmp>:
   1120c:	00 00       	.word 0x0000 # Entry mask: < >
   1120e:	c2 04 5e    	subl2 $0x4,sp
   11211:	d0 ac 04 52 	movl 0x4(ap),r2
   11215:	d0 ac 08 53 	movl 0x8(ap),r3
   11219:	d0 ac 0c 50 	movl 0xc(ap),r0
   1121d:	12 03       	bneq 11222 <strncmp+0x16>
   1121f:	d4 50       	clrf r0
   11221:	04          	ret
   11222:	90 62 51    	movb (r2),r1
   11225:	91 51 83    	cmpb r1,(r3)+
   11228:	12 0d       	bneq 11237 <strncmp+0x2b>
   1122a:	d6 52       	incl r2
   1122c:	95 51       	tstb r1
   1122e:	13 04       	beql 11234 <strncmp+0x28>
   11230:	d7 50       	decl r0
   11232:	12 ee       	bneq 11222 <strncmp+0x16>
   11234:	d4 50       	clrf r0
   11236:	04          	ret
   11237:	9a 51 51    	movzbl r1,r1
   1123a:	9a a3 ff 50 	movzbl 0xffffffff(r3),r0
   1123e:	c3 50 51 50 	subl3 r0,r1,r0
   11242:	04          	ret
   11243:	01          	nop

00011244 <__sprint>:
   11244:	40 00       	.word 0x0040 # Entry mask: < r6 >
   11246:	c2 04 5e    	subl2 $0x4,sp
   11249:	d0 ac 08 56 	movl 0x8(ap),r6
   1124d:	d5 a6 08    	tstl 0x8(r6)
   11250:	12 06       	bneq 11258 <__sprint+0x14>
   11252:	d4 a6 04    	clrf 0x4(r6)
   11255:	d4 50       	clrf r0
   11257:	04          	ret
   11258:	dd 56       	pushl r6
   1125a:	dd ac 04    	pushl 0x4(ap)
   1125d:	fb 02 ef 6e 	calls $0x2,151d2 <__sfvwrite>
   11261:	3f 00 00 
   11264:	d4 a6 08    	clrf 0x8(r6)
   11267:	d4 a6 04    	clrf 0x4(r6)
   1126a:	04          	ret
   1126b:	01          	nop

0001126c <__sbprintf>:
   1126c:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   1126e:	9e ce 8c fa 	movab 0xfffffa8c(sp),sp
   11272:	5e 
   11273:	d0 ef 1f ad 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   11277:	02 00 ad f8 
   1127b:	d0 ac 04 57 	movl 0x4(ap),r7
   1127f:	d0 ac 0c 56 	movl 0xc(ap),r6
   11283:	9e cd 8c fe 	movab 0xfffffe8c(fp),r0
   11287:	50 
   11288:	d0 50 ad d0 	movl r0,0xffffffd0(fp)
   1128c:	d4 60       	clrf (r0)
   1128e:	d4 a0 04    	clrf 0x4(r0)
   11291:	3c 8f 0c 01 	movzwl $0x010c,-(sp)
   11295:	7e 
   11296:	d4 7e       	clrf -(sp)
   11298:	9f a0 08    	pushab 0x8(r0)
   1129b:	fb 03 ef 56 	calls $0x3,168f8 <memset>
   1129f:	56 00 00 
   112a2:	ab 02 a7 0c 	bicw3 $0x2,0xc(r7),0xffffffac(fp)
   112a6:	ad ac 
   112a8:	b0 a7 0e ad 	movw 0xe(r7),0xffffffae(fp)
   112ac:	ae 
   112ad:	d0 a7 1c ad 	movl 0x1c(r7),0xffffffbc(fp)
   112b1:	bc 
   112b2:	d0 a7 2c ad 	movl 0x2c(r7),0xffffffcc(fp)
   112b6:	cc 
   112b7:	9e cd 8c fa 	movab 0xfffffa8c(fp),r0
   112bb:	50 
   112bc:	d0 50 ad a0 	movl r0,0xffffffa0(fp)
   112c0:	d0 50 ad b0 	movl r0,0xffffffb0(fp)
   112c4:	3c 8f 00 04 	movzwl $0x0400,0xffffffa8(fp)
   112c8:	ad a8 
   112ca:	3c 8f 00 04 	movzwl $0x0400,0xffffffb4(fp)
   112ce:	ad b4 
   112d0:	d4 ad b8    	clrf 0xffffffb8(fp)
   112d3:	dd 56       	pushl r6
   112d5:	dd ac 08    	pushl 0x8(ap)
   112d8:	9e ad a0 58 	movab 0xffffffa0(fp),r8
   112dc:	dd 58       	pushl r8
   112de:	fb 03 ef c1 	calls $0x3,114a6 <__vfprintf>
   112e2:	01 00 00 
   112e5:	d0 50 56    	movl r0,r6
   112e8:	19 10       	blss 112fa <__sbprintf+0x8e>
   112ea:	dd 58       	pushl r8
   112ec:	fb 01 ef fd 	calls $0x1,154f0 <__sflush>
   112f0:	41 00 00 
   112f3:	d5 50       	tstl r0
   112f5:	13 03       	beql 112fa <__sbprintf+0x8e>
   112f7:	d2 00 56    	mcoml $0x0,r6
   112fa:	e1 06 ad ac 	bbc $0x6,0xffffffac(fp),11305 <__sbprintf+0x99>
   112fe:	06 
   112ff:	a8 8f 40 00 	bisw2 $0x0040,0xc(r7)
   11303:	a7 0c 
   11305:	d0 56 50    	movl r6,r0
   11308:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   1130c:	d1 51 ef 85 	cmpl r1,3bf98 <__guard_local>
   11310:	ac 02 00 
   11313:	13 10       	beql 11325 <__sbprintf+0xb9>
   11315:	dd ad f8    	pushl 0xfffffff8(fp)
   11318:	9f ef 6f 98 	pushab 2ab8d <xdigs_upper.3+0x10>
   1131c:	01 00 
   1131e:	fb 02 ef 47 	calls $0x2,1666c <__stack_smash_handler>
   11322:	53 00 00 
   11325:	04          	ret

00011326 <__wcsconv>:
   11326:	c0 07       	.word 0x07c0 # Entry mask: < r10 r9 r8 r7 r6 >
   11328:	9e ce 70 ff 	movab 0xffffff70(sp),sp
   1132c:	5e 
   1132d:	d0 ac 08 56 	movl 0x8(ap),r6
   11331:	d0 ef 61 ac 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   11335:	02 00 ad f8 
   11339:	d0 ac 04 5a 	movl 0x4(ap),r10
   1133d:	d5 56       	tstl r6
   1133f:	18 03       	bgeq 11344 <__wcsconv+0x1e>
   11341:	31 ec 00    	brw 11430 <__wcsconv+0x10a>
   11344:	d1 56 8f 7f 	cmpl r6,$0x0000007f
   11348:	00 00 00 
   1134b:	15 03       	bleq 11350 <__wcsconv+0x2a>
   1134d:	31 87 00    	brw 113d7 <__wcsconv+0xb1>
   11350:	d0 56 57    	movl r6,r7
   11353:	9f a7 01    	pushab 0x1(r7)
   11356:	fb 01 ef c5 	calls $0x1,18622 <malloc>
   1135a:	72 00 00 
   1135d:	d0 50 58    	movl r0,r8
   11360:	d0 50 59    	movl r0,r9
   11363:	13 6e       	beql 113d3 <__wcsconv+0xad>
   11365:	d0 5a cd 74 	movl r10,0xffffff74(fp)
   11369:	ff 
   1136a:	9e cd 78 ff 	movab 0xffffff78(fp),r6
   1136e:	56 
   1136f:	9a 8f 80 7e 	movzbl $0x80,-(sp)
   11373:	d4 7e       	clrf -(sp)
   11375:	dd 56       	pushl r6
   11377:	fb 03 ef 7a 	calls $0x3,168f8 <memset>
   1137b:	55 00 00 
   1137e:	dd 56       	pushl r6
   11380:	dd 57       	pushl r7
   11382:	9f cd 74 ff 	pushab 0xffffff74(fp)
   11386:	dd 58       	pushl r8
   11388:	fb 04 ef ed 	calls $0x4,15f7c <wcsrtombs>
   1138c:	4b 00 00 
   1138f:	d0 50 57    	movl r0,r7
   11392:	d1 50 8f ff 	cmpl r0,$0xffffffff
   11396:	ff ff ff 
   11399:	13 24       	beql 113bf <__wcsconv+0x99>
   1139b:	94 48 60    	clrb (r0)[r8]
   1139e:	d0 58 50    	movl r8,r0
   113a1:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   113a5:	d1 51 ef ec 	cmpl r1,3bf98 <__guard_local>
   113a9:	ab 02 00 
   113ac:	13 10       	beql 113be <__wcsconv+0x98>
   113ae:	dd ad f8    	pushl 0xfffffff8(fp)
   113b1:	9f ef e1 97 	pushab 2ab98 <xdigs_upper.3+0x1b>
   113b5:	01 00 
   113b7:	fb 02 ef ae 	calls $0x2,1666c <__stack_smash_handler>
   113bb:	52 00 00 
   113be:	04          	ret
   113bf:	dd 58       	pushl r8
   113c1:	fb 01 ef 00 	calls $0x1,188c8 <free>
   113c5:	75 00 00 
   113c8:	fb 00 ef f9 	calls $0x0,109c8 <___errno>
   113cc:	f5 ff ff 
   113cf:	9a 8f 54 60 	movzbl $0x54,(r0)
   113d3:	d4 50       	clrf r0
   113d5:	11 ca       	brb 113a1 <__wcsconv+0x7b>
   113d7:	d4 57       	clrf r7
   113d9:	d0 5a cd 74 	movl r10,0xffffff74(fp)
   113dd:	ff 
   113de:	9a 8f 80 7e 	movzbl $0x80,-(sp)
   113e2:	d4 7e       	clrf -(sp)
   113e4:	9f cd 78 ff 	pushab 0xffffff78(fp)
   113e8:	fb 03 ef 09 	calls $0x3,168f8 <memset>
   113ec:	55 00 00 
   113ef:	9f cd 78 ff 	pushab 0xffffff78(fp)
   113f3:	dd dd 74 ff 	pushl *0xffffff74(fp)
   113f7:	c0 04 cd 74 	addl2 $0x4,0xffffff74(fp)
   113fb:	ff 
   113fc:	9f cd 70 ff 	pushab 0xffffff70(fp)
   11400:	fb 03 ef 47 	calls $0x3,15f4e <wcrtomb>
   11404:	4b 00 00 
   11407:	d5 50       	tstl r0
   11409:	13 17       	beql 11422 <__wcsconv+0xfc>
   1140b:	d1 50 8f ff 	cmpl r0,$0xffffffff
   1140f:	ff ff ff 
   11412:	13 0e       	beql 11422 <__wcsconv+0xfc>
   11414:	c1 57 50 51 	addl3 r7,r0,r1
   11418:	d1 51 56    	cmpl r1,r6
   1141b:	1a 05       	bgtru 11422 <__wcsconv+0xfc>
   1141d:	d0 51 57    	movl r1,r7
   11420:	11 cd       	brb 113ef <__wcsconv+0xc9>
   11422:	d1 50 8f ff 	cmpl r0,$0xffffffff
   11426:	ff ff ff 
   11429:	13 03       	beql 1142e <__wcsconv+0x108>
   1142b:	31 25 ff    	brw 11353 <__wcsconv+0x2d>
   1142e:	11 98       	brb 113c8 <__wcsconv+0xa2>
   11430:	9e cd 78 ff 	movab 0xffffff78(fp),r6
   11434:	56 
   11435:	9a 8f 80 7e 	movzbl $0x80,-(sp)
   11439:	d4 7e       	clrf -(sp)
   1143b:	dd 56       	pushl r6
   1143d:	fb 03 ef b4 	calls $0x3,168f8 <memset>
   11441:	54 00 00 
   11444:	d0 5a cd 74 	movl r10,0xffffff74(fp)
   11448:	ff 
   11449:	dd 56       	pushl r6
   1144b:	d4 7e       	clrf -(sp)
   1144d:	9f cd 74 ff 	pushab 0xffffff74(fp)
   11451:	d4 7e       	clrf -(sp)
   11453:	fb 04 ef 22 	calls $0x4,15f7c <wcsrtombs>
   11457:	4b 00 00 
   1145a:	d0 50 57    	movl r0,r7
   1145d:	11 c3       	brb 11422 <__wcsconv+0xfc>
   1145f:	01          	nop

00011460 <vfprintf>:
   11460:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   11462:	c2 04 5e    	subl2 $0x4,sp
   11465:	d0 ac 04 57 	movl 0x4(ap),r7
   11469:	d5 ef 75 ac 	tstl 5c0e4 <__isthreaded>
   1146d:	04 00 
   1146f:	12 29       	bneq 1149a <vfprintf+0x3a>
   11471:	dd ac 0c    	pushl 0xc(ap)
   11474:	dd ac 08    	pushl 0x8(ap)
   11477:	dd 57       	pushl r7
   11479:	fb 03 ef 26 	calls $0x3,114a6 <__vfprintf>
   1147d:	00 00 00 
   11480:	d0 50 56    	movl r0,r6
   11483:	d5 ef 5b ac 	tstl 5c0e4 <__isthreaded>
   11487:	04 00 
   11489:	12 04       	bneq 1148f <vfprintf+0x2f>
   1148b:	d0 56 50    	movl r6,r0
   1148e:	04          	ret
   1148f:	dd 57       	pushl r7
   11491:	fb 01 ef 90 	calls $0x1,16b28 <_weak_funlockfile>
   11495:	56 00 00 
   11498:	11 f1       	brb 1148b <vfprintf+0x2b>
   1149a:	dd 57       	pushl r7
   1149c:	fb 01 ef 77 	calls $0x1,16b1a <_weak_flockfile>
   114a0:	56 00 00 
   114a3:	11 cc       	brb 11471 <vfprintf+0x11>
   114a5:	01          	nop

000114a6 <__vfprintf>:
   114a6:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   114a8:	9e ce 94 fd 	movab 0xfffffd94(sp),sp
   114ac:	5e 
   114ad:	d0 ef e5 aa 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   114b1:	02 00 ad f8 
   114b5:	d0 ac 04 cd 	movl 0x4(ap),0xfffffd98(fp)
   114b9:	98 fd 
   114bb:	d0 ac 0c cd 	movl 0xc(ap),0xfffffd94(fp)
   114bf:	94 fd 
   114c1:	d4 cd c4 fd 	clrf 0xfffffdc4(fp)
   114c5:	d4 cd b0 fd 	clrf 0xfffffdb0(fp)
   114c9:	d0 cd 98 fd 	movl 0xfffffd98(fp),r1
   114cd:	51 
   114ce:	d0 a1 30 50 	movl 0x30(r1),r0
   114d2:	12 03       	bneq 114d7 <__vfprintf+0x31>
   114d4:	31 f5 1a    	brw 12fcc <__vfprintf+0x1b26>
   114d7:	c0 08 50    	addl2 $0x8,r0
   114da:	d5 50       	tstl r0
   114dc:	13 0b       	beql 114e9 <__vfprintf+0x43>
   114de:	d5 c0 08 01 	tstl 0x108(r0)
   114e2:	12 05       	bneq 114e9 <__vfprintf+0x43>
   114e4:	d2 00 c0 08 	mcoml $0x0,0x108(r0)
   114e8:	01 
   114e9:	d0 cd 98 fd 	movl 0xfffffd98(fp),r2
   114ed:	52 
   114ee:	e1 03 a2 0c 	bbc $0x3,0xc(r2),114f8 <__vfprintf+0x52>
   114f2:	05 
   114f3:	d5 a2 10    	tstl 0x10(r2)
   114f6:	12 12       	bneq 1150a <__vfprintf+0x64>
   114f8:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   114fc:	fb 01 ef c5 	calls $0x1,155c8 <__swsetup>
   11500:	40 00 00 
   11503:	d5 50       	tstl r0
   11505:	13 03       	beql 1150a <__vfprintf+0x64>
   11507:	31 b2 1a    	brw 12fbc <__vfprintf+0x1b16>
   1150a:	d0 cd 98 fd 	movl 0xfffffd98(fp),r1
   1150e:	51 
   1150f:	b0 a1 0c 50 	movw 0xc(r1),r0
   11513:	ca 8f e5 ff 	bicl2 $0xffffffe5,r0
   11517:	ff ff 50 
   1151a:	d1 50 0a    	cmpl r0,$0xa
   1151d:	12 03       	bneq 11522 <__vfprintf+0x7c>
   1151f:	31 81 1a    	brw 12fa3 <__vfprintf+0x1afd>
   11522:	d0 ac 08 5b 	movl 0x8(ap),r11
   11526:	d4 cd f8 fd 	clrf 0xfffffdf8(fp)
   1152a:	d0 01 cd a4 	movl $0x1,0xfffffda4(fp)
   1152e:	fd 
   1152f:	d0 cd 94 fd 	movl 0xfffffd94(fp),0xfffffda0(fp)
   11533:	cd a0 fd 
   11536:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   1153a:	5a 
   1153b:	d0 5a cd 08 	movl r10,0xfffffe08(fp)
   1153f:	fe 
   11540:	d4 cd 10 fe 	clrf 0xfffffe10(fp)
   11544:	d4 cd 0c fe 	clrf 0xfffffe0c(fp)
   11548:	d4 cd d0 fd 	clrf 0xfffffdd0(fp)
   1154c:	d4 cd 9c fd 	clrf 0xfffffd9c(fp)
   11550:	9a 8f 80 7e 	movzbl $0x80,-(sp)
   11554:	d4 7e       	clrf -(sp)
   11556:	9f cd f8 fe 	pushab 0xfffffef8(fp)
   1155a:	fb 03 ef 97 	calls $0x3,168f8 <memset>
   1155e:	53 00 00 
   11561:	d0 5b 59    	movl r11,r9
   11564:	9f cd f8 fe 	pushab 0xfffffef8(fp)
   11568:	dd ef be ab 	pushl 5c12c <__mb_cur_max>
   1156c:	04 00 
   1156e:	dd 5b       	pushl r11
   11570:	9f cd 04 fe 	pushab 0xfffffe04(fp)
   11574:	fb 04 ef 43 	calls $0x4,15ebe <mbrtowc>
   11578:	49 00 00 
   1157b:	d0 50 56    	movl r0,r6
   1157e:	15 0c       	bleq 1158c <__vfprintf+0xe6>
   11580:	c0 56 5b    	addl2 r6,r11
   11583:	d1 cd 04 fe 	cmpl 0xfffffe04(fp),$0x25
   11587:	25 
   11588:	12 da       	bneq 11564 <__vfprintf+0xbe>
   1158a:	d7 5b       	decl r11
   1158c:	d1 5b 59    	cmpl r11,r9
   1158f:	13 3d       	beql 115ce <__vfprintf+0x128>
   11591:	c3 59 5b 57 	subl3 r9,r11,r7
   11595:	18 03       	bgeq 1159a <__vfprintf+0xf4>
   11597:	31 cd 01    	brw 11767 <__vfprintf+0x2c1>
   1159a:	c3 cd d0 fd 	subl3 0xfffffdd0(fp),$0x7fffffff,r0
   1159e:	8f ff ff ff 
   115a2:	7f 50 
   115a4:	d1 57 50    	cmpl r7,r0
   115a7:	15 03       	bleq 115ac <__vfprintf+0x106>
   115a9:	31 bb 01    	brw 11767 <__vfprintf+0x2c1>
   115ac:	d0 59 6a    	movl r9,(r10)
   115af:	d0 57 aa 04 	movl r7,0x4(r10)
   115b3:	c0 57 cd 10 	addl2 r7,0xfffffe10(fp)
   115b7:	fe 
   115b8:	c0 08 5a    	addl2 $0x8,r10
   115bb:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   115bf:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   115c3:	07 
   115c4:	15 03       	bleq 115c9 <__vfprintf+0x123>
   115c6:	31 be 19    	brw 12f87 <__vfprintf+0x1ae1>
   115c9:	c0 57 cd d0 	addl2 r7,0xfffffdd0(fp)
   115cd:	fd 
   115ce:	d5 56       	tstl r6
   115d0:	14 03       	bgtr 115d5 <__vfprintf+0x12f>
   115d2:	31 85 19    	brw 12f5a <__vfprintf+0x1ab4>
   115d5:	d6 5b       	incl r11
   115d7:	d4 cd d4 fd 	clrf 0xfffffdd4(fp)
   115db:	d4 cd ac fd 	clrf 0xfffffdac(fp)
   115df:	d4 cd cc fd 	clrf 0xfffffdcc(fp)
   115e3:	d2 00 cd c8 	mcoml $0x0,0xfffffdc8(fp)
   115e7:	fd 
   115e8:	94 cd db fd 	clrb 0xfffffddb(fp)
   115ec:	94 cd 03 fe 	clrb 0xfffffe03(fp)
   115f0:	98 8b 58    	cvtbl (r11)+,r8
   115f3:	c3 20 58 50 	subl3 $0x20,r8,r0
   115f7:	d1 50 8f 5a 	cmpl r0,$0x0000005a
   115fb:	00 00 00 
   115fe:	1b 03       	blequ 11603 <__vfprintf+0x15d>
   11600:	31 48 19    	brw 12f4b <__vfprintf+0x1aa5>
   11603:	cf 50 00 8f 	casel r0,$0x0,$0x0000005a
   11607:	5a 00 00 00 
   1160b:	b6 00       	incw $0x0
   1160d:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   11611:	c7 00 40 19 	divl3 $0x0,$0x19[r0],$0x19[r0]
   11615:	40 19 
   11617:	40 19 e5 ff 	addf2 $0x19 [f-float],0x401940ff(r5)
   1161b:	40 19 40 
   1161e:	19 cf       	blss 115ef <__vfprintf+0x149>
   11620:	00          	halt
   11621:	35 02 40 19 	cmpp3 $0x2,$0x19[r0],r4
   11625:	54 
   11626:	01          	nop
   11627:	3d 02 40 19 	acbw $0x2,$0x19[r0],@(r9)+,bb31 <__init-0x463b>
   1162b:	99 03 a5 
   1162e:	03          	bpt
   1162f:	a5 03 a5 03 	mulw3 $0x3,0x3(r5),0x3(r5)
   11633:	a5 03 
   11635:	a5 03 a5 03 	mulw3 $0x3,0x3(r5),0x3(r5)
   11639:	a5 03 
   1163b:	a5 03 a5 03 	mulw3 $0x3,0x3(r5),$0x19[r0]
   1163f:	40 19 
   11641:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   11645:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   11649:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   1164d:	d8 11 40 19 	adwc $0x11,$0x19[r0]
   11651:	40 19 e7 03 	addf2 $0x19 [f-float],0x59152803(r7)
   11655:	28 15 59 
   11658:	16 60       	jsb (r0)
   1165a:	16 40 19    	jsb $0x19[r0]
   1165d:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   11661:	40 19 61    	addf2 $0x19 [f-float],(r1)
   11664:	0e 40 19 40 	insque $0x19[r0],$0x19[r0]
   11668:	19 
   11669:	69 0e 40 19 	cvtdw $0xe [d-float],$0x19[r0]
   1166d:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   11671:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   11675:	86 0f 40 19 	divb2 $0xf,$0x19[r0]
   11679:	40 19 a0 10 	addf2 $0x19 [f-float],0x10(r0)
   1167d:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   11681:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   11685:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   11689:	40 19 40 19 	addf2 $0x19 [f-float],$0x19 [f-float][r0]
   1168d:	d8 11 40 19 	adwc $0x11,$0x19[r0]
   11691:	63 14 ec 03 	subd3 $0x14 [d-float],0x59152803(ap),$0x16 [d-float]
   11695:	28 15 59 16 
   11699:	60 16 77    	addd2 $0x16 [d-float],-(r7)
   1169c:	16 ec 03 97 	jsb 0x40169703(ap)
   116a0:	16 40 
   116a2:	19 a3       	blss 11647 <__vfprintf+0x1a1>
   116a4:	16 40 19    	jsb $0x19[r0]
   116a7:	bb 16       	pushr $0x16
   116a9:	6e 0e 01    	cvtld $0xe,$0x1 [d-float]
   116ac:	18 b3       	bgeq 11661 <__vfprintf+0x1bb>
   116ae:	16 40 19    	jsb $0x19[r0]
   116b1:	47 18 28 19 	divf3 $0x18 [f-float],$0x28 [f-float],$0x19 [f-float]
   116b5:	8b 0f 40 19 	bicb3 $0xf,$0x19[r0],$0x19[r0]
   116b9:	40 19 
   116bb:	34 19 40 19 	movp $0x19,$0x19[r0],-(r0)
   116bf:	70 
   116c0:	19 95       	blss 11657 <__vfprintf+0x1b1>
   116c2:	cd db fd 13 	xorl3 *0x13fd(r11),$0x3,$0x31
   116c6:	03 31 
   116c8:	26 ff 90 20 	cvttp *dbce375e <_end+0xdbc812fa>,*0xc8ff1e31(fp),$0x1,0xfffffdd4(fp),$0x31
   116cc:	cd db fd 31 
   116d0:	1e ff c8 01 
   116d4:	cd d4 fd 31 
   116d8:	16 ff d4 56 	jsb *5bd16db2 <_end+0x5bcb494e>
   116dc:	d0 5b 
   116de:	59 90       	.word 0x5990
   116e0:	6b 51 98    	cvtrdl r1,@(r8)+
   116e3:	51 50 c2 30 	cmpf r0,0x5030(r2)
   116e7:	50 
   116e8:	d1 50 09    	cmpl r0,$0x9
   116eb:	1a 31       	bgtru 1171e <__vfprintf+0x278>
   116ed:	d1 56 8f cc 	cmpl r6,$0x0ccccccc
   116f1:	cc cc 0c 
   116f4:	14 71       	bgtr 11767 <__vfprintf+0x2c1>
   116f6:	c4 0a 56    	mull2 $0xa,r6
   116f9:	98 51 51    	cvtbl r1,r1
   116fc:	c3 51 8f 2f 	subl3 r1,$0x8000002f,r0
   11700:	00 00 80 50 
   11704:	d1 56 50    	cmpl r6,r0
   11707:	14 5e       	bgtr 11767 <__vfprintf+0x2c1>
   11709:	9e 46 a1 d0 	movab 0xffffffd0(r1)[r6],r6
   1170d:	56 
   1170e:	d6 59       	incl r9
   11710:	90 69 51    	movb (r9),r1
   11713:	98 51 50    	cvtbl r1,r0
   11716:	c2 30 50    	subl2 $0x30,r0
   11719:	d1 50 09    	cmpl r0,$0x9
   1171c:	1b cf       	blequ 116ed <__vfprintf+0x247>
   1171e:	91 69 24    	cmpb (r9),$0x24
   11721:	12 03       	bneq 11726 <__vfprintf+0x280>
   11723:	31 c9 00    	brw 117ef <__vfprintf+0x349>
   11726:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   1172a:	50 
   1172b:	12 03       	bneq 11730 <__vfprintf+0x28a>
   1172d:	31 ad 00    	brw 117dd <__vfprintf+0x337>
   11730:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   11734:	51 
   11735:	7e 41 60 50 	movaq (r0)[r1],r0
   11739:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   1173d:	a4 fd 
   1173f:	d0 60 cd cc 	movl (r0),0xfffffdcc(fp)
   11743:	fd 
   11744:	d5 cd cc fd 	tstl 0xfffffdcc(fp)
   11748:	19 03       	blss 1174d <__vfprintf+0x2a7>
   1174a:	31 a3 fe    	brw 115f0 <__vfprintf+0x14a>
   1174d:	d1 cd cc fd 	cmpl 0xfffffdcc(fp),$0x80000000
   11751:	8f 00 00 00 
   11755:	80 
   11756:	13 0f       	beql 11767 <__vfprintf+0x2c1>
   11758:	ce cd cc fd 	mnegl 0xfffffdcc(fp),0xfffffdcc(fp)
   1175c:	cd cc fd 
   1175f:	c8 04 cd d4 	bisl2 $0x4,0xfffffdd4(fp)
   11763:	fd 
   11764:	31 89 fe    	brw 115f0 <__vfprintf+0x14a>
   11767:	fb 00 ef 5a 	calls $0x0,109c8 <___errno>
   1176b:	f2 ff ff 
   1176e:	d0 0c 60    	movl $0xc,(r0)
   11771:	d2 00 cd d0 	mcoml $0x0,0xfffffdd0(fp)
   11775:	fd 
   11776:	d5 cd 9c fd 	tstl 0xfffffd9c(fp)
   1177a:	13 0b       	beql 11787 <__vfprintf+0x2e1>
   1177c:	dd cd 9c fd 	pushl 0xfffffd9c(fp)
   11780:	fb 01 ef 41 	calls $0x1,188c8 <free>
   11784:	71 00 00 
   11787:	d5 cd b0 fd 	tstl 0xfffffdb0(fp)
   1178b:	13 0b       	beql 11798 <__vfprintf+0x2f2>
   1178d:	dd cd b0 fd 	pushl 0xfffffdb0(fp)
   11791:	fb 01 ef 30 	calls $0x1,146c8 <__freedtoa>
   11795:	2f 00 00 
   11798:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r1
   1179c:	51 
   1179d:	13 1b       	beql 117ba <__vfprintf+0x314>
   1179f:	9e cd 14 fe 	movab 0xfffffe14(fp),r0
   117a3:	50 
   117a4:	d1 51 50    	cmpl r1,r0
   117a7:	13 11       	beql 117ba <__vfprintf+0x314>
   117a9:	dd cd fc fd 	pushl 0xfffffdfc(fp)
   117ad:	dd 51       	pushl r1
   117af:	fb 02 ef 16 	calls $0x2,16acc <_thread_sys_munmap>
   117b3:	53 00 00 
   117b6:	d4 cd f8 fd 	clrf 0xfffffdf8(fp)
   117ba:	d0 cd d0 fd 	movl 0xfffffdd0(fp),r0
   117be:	50 
   117bf:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   117c3:	d1 51 ef ce 	cmpl r1,3bf98 <__guard_local>
   117c7:	a7 02 00 
   117ca:	13 10       	beql 117dc <__vfprintf+0x336>
   117cc:	dd ad f8    	pushl 0xfffffff8(fp)
   117cf:	9f ef cd 93 	pushab 2aba2 <xdigs_upper.3+0x25>
   117d3:	01 00 
   117d5:	fb 02 ef 90 	calls $0x2,1666c <__stack_smash_handler>
   117d9:	4e 00 00 
   117dc:	04          	ret
   117dd:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   117e1:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   117e5:	50 
   117e6:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   117ea:	94 fd 
   117ec:	31 50 ff    	brw 1173f <__vfprintf+0x299>
   117ef:	d0 cd a4 fd 	movl 0xfffffda4(fp),r7
   117f3:	57 
   117f4:	d5 cd f8 fd 	tstl 0xfffffdf8(fp)
   117f8:	13 29       	beql 11823 <__vfprintf+0x37d>
   117fa:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   117fe:	50 
   117ff:	13 15       	beql 11816 <__vfprintf+0x370>
   11801:	7e 46 60 50 	movaq (r0)[r6],r0
   11805:	d0 60 cd cc 	movl (r0),0xfffffdcc(fp)
   11809:	fd 
   1180a:	d0 57 cd a4 	movl r7,0xfffffda4(fp)
   1180e:	fd 
   1180f:	c1 59 01 5b 	addl3 r9,$0x1,r11
   11813:	31 2e ff    	brw 11744 <__vfprintf+0x29e>
   11816:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   1181a:	50 
   1181b:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   1181f:	94 fd 
   11821:	11 e2       	brb 11805 <__vfprintf+0x35f>
   11823:	9e cd 14 fe 	movab 0xfffffe14(fp),0xfffffdf8(fp)
   11827:	cd f8 fd 
   1182a:	9f cd fc fd 	pushab 0xfffffdfc(fp)
   1182e:	9f cd f8 fd 	pushab 0xfffffdf8(fp)
   11832:	dd cd a0 fd 	pushl 0xfffffda0(fp)
   11836:	dd ac 08    	pushl 0x8(ap)
   11839:	fb 04 cf 9a 	calls $0x4,12fd8 <__find_arguments>
   1183d:	17 
   1183e:	11 ba       	brb 117fa <__vfprintf+0x354>
   11840:	90 2b cd db 	movb $0x2b,0xfffffddb(fp)
   11844:	fd 
   11845:	31 a8 fd    	brw 115f0 <__vfprintf+0x14a>
   11848:	98 8b 58    	cvtbl (r11)+,r8
   1184b:	d1 58 2a    	cmpl r8,$0x2a
   1184e:	13 74       	beql 118c4 <__vfprintf+0x41e>
   11850:	d4 56       	clrf r6
   11852:	c3 30 58 50 	subl3 $0x30,r8,r0
   11856:	d1 50 09    	cmpl r0,$0x9
   11859:	1a 30       	bgtru 1188b <__vfprintf+0x3e5>
   1185b:	d1 56 8f cc 	cmpl r6,$0x0ccccccc
   1185f:	cc cc 0c 
   11862:	15 03       	bleq 11867 <__vfprintf+0x3c1>
   11864:	31 00 ff    	brw 11767 <__vfprintf+0x2c1>
   11867:	c4 0a 56    	mull2 $0xa,r6
   1186a:	c3 58 8f 2f 	subl3 r8,$0x8000002f,r0
   1186e:	00 00 80 50 
   11872:	d1 56 50    	cmpl r6,r0
   11875:	15 03       	bleq 1187a <__vfprintf+0x3d4>
   11877:	31 ed fe    	brw 11767 <__vfprintf+0x2c1>
   1187a:	9e 46 a8 d0 	movab 0xffffffd0(r8)[r6],r6
   1187e:	56 
   1187f:	98 8b 58    	cvtbl (r11)+,r8
   11882:	c3 30 58 50 	subl3 $0x30,r8,r0
   11886:	d1 50 09    	cmpl r0,$0x9
   11889:	1b d0       	blequ 1185b <__vfprintf+0x3b5>
   1188b:	d1 58 24    	cmpl r8,$0x24
   1188e:	13 08       	beql 11898 <__vfprintf+0x3f2>
   11890:	d0 56 cd c8 	movl r6,0xfffffdc8(fp)
   11894:	fd 
   11895:	31 5b fd    	brw 115f3 <__vfprintf+0x14d>
   11898:	d0 56 cd a4 	movl r6,0xfffffda4(fp)
   1189c:	fd 
   1189d:	d5 cd f8 fd 	tstl 0xfffffdf8(fp)
   118a1:	13 03       	beql 118a6 <__vfprintf+0x400>
   118a3:	31 4a fd    	brw 115f0 <__vfprintf+0x14a>
   118a6:	9e cd 14 fe 	movab 0xfffffe14(fp),0xfffffdf8(fp)
   118aa:	cd f8 fd 
   118ad:	9f cd fc fd 	pushab 0xfffffdfc(fp)
   118b1:	9f cd f8 fd 	pushab 0xfffffdf8(fp)
   118b5:	dd cd a0 fd 	pushl 0xfffffda0(fp)
   118b9:	dd ac 08    	pushl 0x8(ap)
   118bc:	fb 04 cf 17 	calls $0x4,12fd8 <__find_arguments>
   118c0:	17 
   118c1:	31 2c fd    	brw 115f0 <__vfprintf+0x14a>
   118c4:	d4 56       	clrf r6
   118c6:	d0 5b 59    	movl r11,r9
   118c9:	90 6b 51    	movb (r11),r1
   118cc:	98 51 50    	cvtbl r1,r0
   118cf:	c2 30 50    	subl2 $0x30,r0
   118d2:	d1 50 09    	cmpl r0,$0x9
   118d5:	1a 37       	bgtru 1190e <__vfprintf+0x468>
   118d7:	d1 56 8f cc 	cmpl r6,$0x0ccccccc
   118db:	cc cc 0c 
   118de:	15 03       	bleq 118e3 <__vfprintf+0x43d>
   118e0:	31 84 fe    	brw 11767 <__vfprintf+0x2c1>
   118e3:	c4 0a 56    	mull2 $0xa,r6
   118e6:	98 51 51    	cvtbl r1,r1
   118e9:	c3 51 8f 2f 	subl3 r1,$0x8000002f,r0
   118ed:	00 00 80 50 
   118f1:	d1 56 50    	cmpl r6,r0
   118f4:	15 03       	bleq 118f9 <__vfprintf+0x453>
   118f6:	31 6e fe    	brw 11767 <__vfprintf+0x2c1>
   118f9:	9e 46 a1 d0 	movab 0xffffffd0(r1)[r6],r6
   118fd:	56 
   118fe:	d6 59       	incl r9
   11900:	90 69 51    	movb (r9),r1
   11903:	98 51 50    	cvtbl r1,r0
   11906:	c2 30 50    	subl2 $0x30,r0
   11909:	d1 50 09    	cmpl r0,$0x9
   1190c:	1b c9       	blequ 118d7 <__vfprintf+0x431>
   1190e:	91 69 24    	cmpb (r9),$0x24
   11911:	13 43       	beql 11956 <__vfprintf+0x4b0>
   11913:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   11917:	50 
   11918:	13 2b       	beql 11945 <__vfprintf+0x49f>
   1191a:	d0 cd a4 fd 	movl 0xfffffda4(fp),r2
   1191e:	52 
   1191f:	7e 42 60 50 	movaq (r0)[r2],r0
   11923:	c1 52 01 cd 	addl3 r2,$0x1,0xfffffda4(fp)
   11927:	a4 fd 
   11929:	d0 60 56    	movl (r0),r6
   1192c:	d0 56 cd c8 	movl r6,0xfffffdc8(fp)
   11930:	fd 
   11931:	d1 56 8f ff 	cmpl r6,$0xffffffff
   11935:	ff ff ff 
   11938:	19 03       	blss 1193d <__vfprintf+0x497>
   1193a:	31 b3 fc    	brw 115f0 <__vfprintf+0x14a>
   1193d:	d2 00 cd c8 	mcoml $0x0,0xfffffdc8(fp)
   11941:	fd 
   11942:	31 ab fc    	brw 115f0 <__vfprintf+0x14a>
   11945:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   11949:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   1194d:	50 
   1194e:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   11952:	94 fd 
   11954:	11 d3       	brb 11929 <__vfprintf+0x483>
   11956:	d0 cd a4 fd 	movl 0xfffffda4(fp),r7
   1195a:	57 
   1195b:	d5 cd f8 fd 	tstl 0xfffffdf8(fp)
   1195f:	13 26       	beql 11987 <__vfprintf+0x4e1>
   11961:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   11965:	50 
   11966:	13 12       	beql 1197a <__vfprintf+0x4d4>
   11968:	7e 46 60 50 	movaq (r0)[r6],r0
   1196c:	d0 60 56    	movl (r0),r6
   1196f:	d0 57 cd a4 	movl r7,0xfffffda4(fp)
   11973:	fd 
   11974:	c1 59 01 5b 	addl3 r9,$0x1,r11
   11978:	11 b2       	brb 1192c <__vfprintf+0x486>
   1197a:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   1197e:	50 
   1197f:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   11983:	94 fd 
   11985:	11 e5       	brb 1196c <__vfprintf+0x4c6>
   11987:	9e cd 14 fe 	movab 0xfffffe14(fp),0xfffffdf8(fp)
   1198b:	cd f8 fd 
   1198e:	9f cd fc fd 	pushab 0xfffffdfc(fp)
   11992:	9f cd f8 fd 	pushab 0xfffffdf8(fp)
   11996:	dd cd a0 fd 	pushl 0xfffffda0(fp)
   1199a:	dd ac 08    	pushl 0x8(ap)
   1199d:	fb 04 cf 36 	calls $0x4,12fd8 <__find_arguments>
   119a1:	16 
   119a2:	11 bd       	brb 11961 <__vfprintf+0x4bb>
   119a4:	c8 8f 80 00 	bisl2 $0x00000080,0xfffffdd4(fp)
   119a8:	00 00 cd d4 
   119ac:	fd 
   119ad:	31 40 fc    	brw 115f0 <__vfprintf+0x14a>
   119b0:	d4 56       	clrf r6
   119b2:	d1 56 8f cc 	cmpl r6,$0x0ccccccc
   119b6:	cc cc 0c 
   119b9:	15 03       	bleq 119be <__vfprintf+0x518>
   119bb:	31 a9 fd    	brw 11767 <__vfprintf+0x2c1>
   119be:	c4 0a 56    	mull2 $0xa,r6
   119c1:	c3 58 8f 2f 	subl3 r8,$0x8000002f,r0
   119c5:	00 00 80 50 
   119c9:	d1 56 50    	cmpl r6,r0
   119cc:	15 03       	bleq 119d1 <__vfprintf+0x52b>
   119ce:	31 96 fd    	brw 11767 <__vfprintf+0x2c1>
   119d1:	9e 46 a8 d0 	movab 0xffffffd0(r8)[r6],r6
   119d5:	56 
   119d6:	98 8b 58    	cvtbl (r11)+,r8
   119d9:	c3 30 58 50 	subl3 $0x30,r8,r0
   119dd:	d1 50 09    	cmpl r0,$0x9
   119e0:	1b d0       	blequ 119b2 <__vfprintf+0x50c>
   119e2:	d1 58 24    	cmpl r8,$0x24
   119e5:	12 03       	bneq 119ea <__vfprintf+0x544>
   119e7:	31 ae fe    	brw 11898 <__vfprintf+0x3f2>
   119ea:	d0 56 cd cc 	movl r6,0xfffffdcc(fp)
   119ee:	fd 
   119ef:	31 01 fc    	brw 115f3 <__vfprintf+0x14d>
   119f2:	c8 10 cd d4 	bisl2 $0x10,0xfffffdd4(fp)
   119f6:	fd 
   119f7:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   119fb:	50 
   119fc:	e0 0c 50 0c 	bbs $0xc,r0,11a0c <__vfprintf+0x566>
   11a00:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r1
   11a04:	51 
   11a05:	e0 05 51 03 	bbs $0x5,r1,11a0c <__vfprintf+0x566>
   11a09:	31 79 09    	brw 12385 <__vfprintf+0xedf>
   11a0c:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r2
   11a10:	52 
   11a11:	12 03       	bneq 11a16 <__vfprintf+0x570>
   11a13:	31 5a 09    	brw 12370 <__vfprintf+0xeca>
   11a16:	d0 cd a4 fd 	movl 0xfffffda4(fp),r0
   11a1a:	50 
   11a1b:	c1 50 01 cd 	addl3 r0,$0x1,0xfffffda4(fp)
   11a1f:	a4 fd 
   11a21:	7d 40 62 56 	movq (r2)[r0],r6
   11a25:	d5 57       	tstl r7
   11a27:	18 12       	bgeq 11a3b <__vfprintf+0x595>
   11a29:	7d 56 7e    	movq r6,-(sp)
   11a2c:	fb 02 ef 7f 	calls $0x2,151b2 <__negdi2>
   11a30:	37 00 00 
   11a33:	7d 50 56    	movq r0,r6
   11a36:	90 2d cd db 	movb $0x2d,0xfffffddb(fp)
   11a3a:	fd 
   11a3b:	d0 01 51    	movl $0x1,r1
   11a3e:	d0 cd c8 fd 	movl 0xfffffdc8(fp),0xfffffdac(fp)
   11a42:	cd ac fd 
   11a45:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   11a49:	19 09       	blss 11a54 <__vfprintf+0x5ae>
   11a4b:	ca 8f 80 00 	bicl2 $0x00000080,0xfffffdd4(fp)
   11a4f:	00 00 cd d4 
   11a53:	fd 
   11a54:	9e cd b8 fe 	movab 0xfffffeb8(fp),r9
   11a58:	59 
   11a59:	c9 57 56 50 	bisl3 r7,r6,r0
   11a5d:	12 09       	bneq 11a68 <__vfprintf+0x5c2>
   11a5f:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   11a63:	12 03       	bneq 11a68 <__vfprintf+0x5c2>
   11a65:	31 6f 08    	brw 122d7 <__vfprintf+0xe31>
   11a68:	d1 51 01    	cmpl r1,$0x1
   11a6b:	12 03       	bneq 11a70 <__vfprintf+0x5ca>
   11a6d:	31 be 08    	brw 1232e <__vfprintf+0xe88>
   11a70:	1e 03       	bcc 11a75 <__vfprintf+0x5cf>
   11a72:	31 7a 08    	brw 122ef <__vfprintf+0xe49>
   11a75:	d1 51 02    	cmpl r1,$0x2
   11a78:	12 03       	bneq 11a7d <__vfprintf+0x5d7>
   11a7a:	31 28 08    	brw 122a5 <__vfprintf+0xdff>
   11a7d:	9e ef 2a 91 	movab 2abad <xdigs_upper.3+0x30>,r9
   11a81:	01 00 59 
   11a84:	dd 59       	pushl r9
   11a86:	fb 01 ef 95 	calls $0x1,16922 <strlen>
   11a8a:	4e 00 00 
   11a8d:	d0 50 57    	movl r0,r7
   11a90:	d0 57 58    	movl r7,r8
   11a93:	d1 57 cd ac 	cmpl r7,0xfffffdac(fp)
   11a97:	fd 
   11a98:	18 05       	bgeq 11a9f <__vfprintf+0x5f9>
   11a9a:	d0 cd ac fd 	movl 0xfffffdac(fp),r8
   11a9e:	58 
   11a9f:	95 cd db fd 	tstb 0xfffffddb(fp)
   11aa3:	13 02       	beql 11aa7 <__vfprintf+0x601>
   11aa5:	d6 58       	incl r8
   11aa7:	95 cd 03 fe 	tstb 0xfffffe03(fp)
   11aab:	13 03       	beql 11ab0 <__vfprintf+0x60a>
   11aad:	c0 02 58    	addl2 $0x2,r8
   11ab0:	93 cd d4 fd 	bitb 0xfffffdd4(fp),$0x84
   11ab4:	8f 84 
   11ab6:	12 57       	bneq 11b0f <__vfprintf+0x669>
   11ab8:	c3 58 cd cc 	subl3 r8,0xfffffdcc(fp),r6
   11abc:	fd 56 
   11abe:	15 4f       	bleq 11b0f <__vfprintf+0x669>
   11ac0:	d1 56 10    	cmpl r6,$0x10
   11ac3:	15 29       	bleq 11aee <__vfprintf+0x648>
   11ac5:	9e ef 29 a6 	movab 5c0f4 <blanks.0>,(r10)
   11ac9:	04 00 6a 
   11acc:	d0 10 aa 04 	movl $0x10,0x4(r10)
   11ad0:	c0 10 cd 10 	addl2 $0x10,0xfffffe10(fp)
   11ad4:	fe 
   11ad5:	c0 08 5a    	addl2 $0x8,r10
   11ad8:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11adc:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11ae0:	07 
   11ae1:	15 03       	bleq 11ae6 <__vfprintf+0x640>
   11ae3:	31 a3 07    	brw 12289 <__vfprintf+0xde3>
   11ae6:	c2 10 56    	subl2 $0x10,r6
   11ae9:	d1 56 10    	cmpl r6,$0x10
   11aec:	14 d7       	bgtr 11ac5 <__vfprintf+0x61f>
   11aee:	9e ef 00 a6 	movab 5c0f4 <blanks.0>,(r10)
   11af2:	04 00 6a 
   11af5:	d0 56 aa 04 	movl r6,0x4(r10)
   11af9:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   11afd:	fe 
   11afe:	c0 08 5a    	addl2 $0x8,r10
   11b01:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11b05:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11b09:	07 
   11b0a:	15 03       	bleq 11b0f <__vfprintf+0x669>
   11b0c:	31 5e 07    	brw 1226d <__vfprintf+0xdc7>
   11b0f:	95 cd db fd 	tstb 0xfffffddb(fp)
   11b13:	13 1e       	beql 11b33 <__vfprintf+0x68d>
   11b15:	9e cd db fd 	movab 0xfffffddb(fp),(r10)
   11b19:	6a 
   11b1a:	d0 01 aa 04 	movl $0x1,0x4(r10)
   11b1e:	d6 cd 10 fe 	incl 0xfffffe10(fp)
   11b22:	c0 08 5a    	addl2 $0x8,r10
   11b25:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11b29:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11b2d:	07 
   11b2e:	15 03       	bleq 11b33 <__vfprintf+0x68d>
   11b30:	31 1e 07    	brw 12251 <__vfprintf+0xdab>
   11b33:	9e cd 02 fe 	movab 0xfffffe02(fp),r0
   11b37:	50 
   11b38:	95 a0 01    	tstb 0x1(r0)
   11b3b:	13 22       	beql 11b5f <__vfprintf+0x6b9>
   11b3d:	90 30 cd 02 	movb $0x30,0xfffffe02(fp)
   11b41:	fe 
   11b42:	d0 50 6a    	movl r0,(r10)
   11b45:	d0 02 aa 04 	movl $0x2,0x4(r10)
   11b49:	c0 02 cd 10 	addl2 $0x2,0xfffffe10(fp)
   11b4d:	fe 
   11b4e:	c0 08 5a    	addl2 $0x8,r10
   11b51:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11b55:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11b59:	07 
   11b5a:	15 03       	bleq 11b5f <__vfprintf+0x6b9>
   11b5c:	31 d6 06    	brw 12235 <__vfprintf+0xd8f>
   11b5f:	cb 8f 7b ff 	bicl3 $0xffffff7b,0xfffffdd4(fp),r0
   11b63:	ff ff cd d4 
   11b67:	fd 50 
   11b69:	d1 50 8f 80 	cmpl r0,$0x00000080
   11b6d:	00 00 00 
   11b70:	12 03       	bneq 11b75 <__vfprintf+0x6cf>
   11b72:	31 32 06    	brw 121a7 <__vfprintf+0xd01>
   11b75:	c3 57 cd ac 	subl3 r7,0xfffffdac(fp),r6
   11b79:	fd 56 
   11b7b:	15 4f       	bleq 11bcc <__vfprintf+0x726>
   11b7d:	d1 56 10    	cmpl r6,$0x10
   11b80:	15 29       	bleq 11bab <__vfprintf+0x705>
   11b82:	9e ef 7c a5 	movab 5c104 <zeroes.1>,(r10)
   11b86:	04 00 6a 
   11b89:	d0 10 aa 04 	movl $0x10,0x4(r10)
   11b8d:	c0 10 cd 10 	addl2 $0x10,0xfffffe10(fp)
   11b91:	fe 
   11b92:	c0 08 5a    	addl2 $0x8,r10
   11b95:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11b99:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11b9d:	07 
   11b9e:	15 03       	bleq 11ba3 <__vfprintf+0x6fd>
   11ba0:	31 e8 05    	brw 1218b <__vfprintf+0xce5>
   11ba3:	c2 10 56    	subl2 $0x10,r6
   11ba6:	d1 56 10    	cmpl r6,$0x10
   11ba9:	14 d7       	bgtr 11b82 <__vfprintf+0x6dc>
   11bab:	9e ef 53 a5 	movab 5c104 <zeroes.1>,(r10)
   11baf:	04 00 6a 
   11bb2:	d0 56 aa 04 	movl r6,0x4(r10)
   11bb6:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   11bba:	fe 
   11bbb:	c0 08 5a    	addl2 $0x8,r10
   11bbe:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11bc2:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11bc6:	07 
   11bc7:	15 03       	bleq 11bcc <__vfprintf+0x726>
   11bc9:	31 a3 05    	brw 1216f <__vfprintf+0xcc9>
   11bcc:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   11bd0:	50 
   11bd1:	e1 08 50 03 	bbc $0x8,r0,11bd8 <__vfprintf+0x732>
   11bd5:	31 16 01    	brw 11cee <__vfprintf+0x848>
   11bd8:	d0 59 6a    	movl r9,(r10)
   11bdb:	d0 57 aa 04 	movl r7,0x4(r10)
   11bdf:	c0 57 cd 10 	addl2 r7,0xfffffe10(fp)
   11be3:	fe 
   11be4:	c0 08 5a    	addl2 $0x8,r10
   11be7:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11beb:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11bef:	07 
   11bf0:	15 03       	bleq 11bf5 <__vfprintf+0x74f>
   11bf2:	31 e0 00    	brw 11cd5 <__vfprintf+0x82f>
   11bf5:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   11bf9:	52 
   11bfa:	e1 02 52 51 	bbc $0x2,r2,11c4f <__vfprintf+0x7a9>
   11bfe:	c3 58 cd cc 	subl3 r8,0xfffffdcc(fp),r6
   11c02:	fd 56 
   11c04:	15 49       	bleq 11c4f <__vfprintf+0x7a9>
   11c06:	d1 56 10    	cmpl r6,$0x10
   11c09:	15 29       	bleq 11c34 <__vfprintf+0x78e>
   11c0b:	9e ef e3 a4 	movab 5c0f4 <blanks.0>,(r10)
   11c0f:	04 00 6a 
   11c12:	d0 10 aa 04 	movl $0x10,0x4(r10)
   11c16:	c0 10 cd 10 	addl2 $0x10,0xfffffe10(fp)
   11c1a:	fe 
   11c1b:	c0 08 5a    	addl2 $0x8,r10
   11c1e:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11c22:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11c26:	07 
   11c27:	15 03       	bleq 11c2c <__vfprintf+0x786>
   11c29:	31 90 00    	brw 11cbc <__vfprintf+0x816>
   11c2c:	c2 10 56    	subl2 $0x10,r6
   11c2f:	d1 56 10    	cmpl r6,$0x10
   11c32:	14 d7       	bgtr 11c0b <__vfprintf+0x765>
   11c34:	9e ef ba a4 	movab 5c0f4 <blanks.0>,(r10)
   11c38:	04 00 6a 
   11c3b:	d0 56 aa 04 	movl r6,0x4(r10)
   11c3f:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   11c43:	fe 
   11c44:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11c48:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11c4c:	07 
   11c4d:	14 5a       	bgtr 11ca9 <__vfprintf+0x803>
   11c4f:	d1 cd cc fd 	cmpl 0xfffffdcc(fp),r8
   11c53:	58 
   11c54:	18 05       	bgeq 11c5b <__vfprintf+0x7b5>
   11c56:	d0 58 cd cc 	movl r8,0xfffffdcc(fp)
   11c5a:	fd 
   11c5b:	c3 cd d0 fd 	subl3 0xfffffdd0(fp),$0x7fffffff,r0
   11c5f:	8f ff ff ff 
   11c63:	7f 50 
   11c65:	d1 cd cc fd 	cmpl 0xfffffdcc(fp),r0
   11c69:	50 
   11c6a:	15 03       	bleq 11c6f <__vfprintf+0x7c9>
   11c6c:	31 f8 fa    	brw 11767 <__vfprintf+0x2c1>
   11c6f:	c0 cd cc fd 	addl2 0xfffffdcc(fp),0xfffffdd0(fp)
   11c73:	cd d0 fd 
   11c76:	d5 cd 10 fe 	tstl 0xfffffe10(fp)
   11c7a:	12 0c       	bneq 11c88 <__vfprintf+0x7e2>
   11c7c:	d4 cd 0c fe 	clrf 0xfffffe0c(fp)
   11c80:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11c84:	5a 
   11c85:	31 d9 f8    	brw 11561 <__vfprintf+0xbb>
   11c88:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11c8c:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11c90:	fb 02 cf af 	calls $0x2,11244 <__sprint>
   11c94:	f5 
   11c95:	d5 50       	tstl r0
   11c97:	13 e3       	beql 11c7c <__vfprintf+0x7d6>
   11c99:	d0 cd 98 fd 	movl 0xfffffd98(fp),r0
   11c9d:	50 
   11c9e:	e0 06 a0 0c 	bbs $0x6,0xc(r0),11ca6 <__vfprintf+0x800>
   11ca2:	03 
   11ca3:	31 d0 fa    	brw 11776 <__vfprintf+0x2d0>
   11ca6:	31 c8 fa    	brw 11771 <__vfprintf+0x2cb>
   11ca9:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11cad:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11cb1:	fb 02 cf 8e 	calls $0x2,11244 <__sprint>
   11cb5:	f5 
   11cb6:	d5 50       	tstl r0
   11cb8:	13 95       	beql 11c4f <__vfprintf+0x7a9>
   11cba:	11 dd       	brb 11c99 <__vfprintf+0x7f3>
   11cbc:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11cc0:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11cc4:	fb 02 cf 7b 	calls $0x2,11244 <__sprint>
   11cc8:	f5 
   11cc9:	d5 50       	tstl r0
   11ccb:	12 cc       	bneq 11c99 <__vfprintf+0x7f3>
   11ccd:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11cd1:	5a 
   11cd2:	31 57 ff    	brw 11c2c <__vfprintf+0x786>
   11cd5:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11cd9:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11cdd:	fb 02 cf 62 	calls $0x2,11244 <__sprint>
   11ce1:	f5 
   11ce2:	d5 50       	tstl r0
   11ce4:	12 b3       	bneq 11c99 <__vfprintf+0x7f3>
   11ce6:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11cea:	5a 
   11ceb:	31 07 ff    	brw 11bf5 <__vfprintf+0x74f>
   11cee:	d5 cd c4 fd 	tstl 0xfffffdc4(fp)
   11cf2:	12 03       	bneq 11cf7 <__vfprintf+0x851>
   11cf4:	31 67 04    	brw 1215e <__vfprintf+0xcb8>
   11cf7:	95 cd c3 fd 	tstb 0xfffffdc3(fp)
   11cfb:	13 03       	beql 11d00 <__vfprintf+0x85a>
   11cfd:	31 0e 03    	brw 1200e <__vfprintf+0xb68>
   11d00:	d5 cd ec fd 	tstl 0xfffffdec(fp)
   11d04:	14 03       	bgtr 11d09 <__vfprintf+0x863>
   11d06:	31 f1 01    	brw 11efa <__vfprintf+0xa54>
   11d09:	c3 59 cd f4 	subl3 r9,0xfffffdf4(fp),r6
   11d0d:	fd 56 
   11d0f:	d1 56 cd b8 	cmpl r6,0xfffffdb8(fp)
   11d13:	fd 
   11d14:	15 05       	bleq 11d1b <__vfprintf+0x875>
   11d16:	d0 cd b8 fd 	movl 0xfffffdb8(fp),r6
   11d1a:	56 
   11d1b:	d5 56       	tstl r6
   11d1d:	15 1d       	bleq 11d3c <__vfprintf+0x896>
   11d1f:	d0 59 6a    	movl r9,(r10)
   11d22:	d0 56 aa 04 	movl r6,0x4(r10)
   11d26:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   11d2a:	fe 
   11d2b:	c0 08 5a    	addl2 $0x8,r10
   11d2e:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11d32:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11d36:	07 
   11d37:	15 03       	bleq 11d3c <__vfprintf+0x896>
   11d39:	31 a2 01    	brw 11ede <__vfprintf+0xa38>
   11d3c:	d0 56 50    	movl r6,r0
   11d3f:	18 03       	bgeq 11d44 <__vfprintf+0x89e>
   11d41:	31 95 01    	brw 11ed9 <__vfprintf+0xa33>
   11d44:	c3 50 cd b8 	subl3 r0,0xfffffdb8(fp),r6
   11d48:	fd 56 
   11d4a:	15 4f       	bleq 11d9b <__vfprintf+0x8f5>
   11d4c:	d1 56 10    	cmpl r6,$0x10
   11d4f:	15 29       	bleq 11d7a <__vfprintf+0x8d4>
   11d51:	9e ef ad a3 	movab 5c104 <zeroes.1>,(r10)
   11d55:	04 00 6a 
   11d58:	d0 10 aa 04 	movl $0x10,0x4(r10)
   11d5c:	c0 10 cd 10 	addl2 $0x10,0xfffffe10(fp)
   11d60:	fe 
   11d61:	c0 08 5a    	addl2 $0x8,r10
   11d64:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11d68:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11d6c:	07 
   11d6d:	15 03       	bleq 11d72 <__vfprintf+0x8cc>
   11d6f:	31 4b 01    	brw 11ebd <__vfprintf+0xa17>
   11d72:	c2 10 56    	subl2 $0x10,r6
   11d75:	d1 56 10    	cmpl r6,$0x10
   11d78:	14 d7       	bgtr 11d51 <__vfprintf+0x8ab>
   11d7a:	9e ef 84 a3 	movab 5c104 <zeroes.1>,(r10)
   11d7e:	04 00 6a 
   11d81:	d0 56 aa 04 	movl r6,0x4(r10)
   11d85:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   11d89:	fe 
   11d8a:	c0 08 5a    	addl2 $0x8,r10
   11d8d:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11d91:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11d95:	07 
   11d96:	15 03       	bleq 11d9b <__vfprintf+0x8f5>
   11d98:	31 06 01    	brw 11ea1 <__vfprintf+0x9fb>
   11d9b:	c0 cd b8 fd 	addl2 0xfffffdb8(fp),r9
   11d9f:	59 
   11da0:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   11da4:	12 08       	bneq 11dae <__vfprintf+0x908>
   11da6:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   11daa:	52 
   11dab:	e9 52 1e    	blbc r2,11dcc <__vfprintf+0x926>
   11dae:	d0 cd c4 fd 	movl 0xfffffdc4(fp),(r10)
   11db2:	6a 
   11db3:	d0 01 aa 04 	movl $0x1,0x4(r10)
   11db7:	d6 cd 10 fe 	incl 0xfffffe10(fp)
   11dbb:	c0 08 5a    	addl2 $0x8,r10
   11dbe:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11dc2:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11dc6:	07 
   11dc7:	15 03       	bleq 11dcc <__vfprintf+0x926>
   11dc9:	31 b9 00    	brw 11e85 <__vfprintf+0x9df>
   11dcc:	c3 59 cd f4 	subl3 r9,0xfffffdf4(fp),r6
   11dd0:	fd 56 
   11dd2:	d1 56 cd c8 	cmpl r6,0xfffffdc8(fp)
   11dd6:	fd 
   11dd7:	15 05       	bleq 11dde <__vfprintf+0x938>
   11dd9:	d0 cd c8 fd 	movl 0xfffffdc8(fp),r6
   11ddd:	56 
   11dde:	d5 56       	tstl r6
   11de0:	15 1a       	bleq 11dfc <__vfprintf+0x956>
   11de2:	d0 59 6a    	movl r9,(r10)
   11de5:	d0 56 aa 04 	movl r6,0x4(r10)
   11de9:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   11ded:	fe 
   11dee:	c0 08 5a    	addl2 $0x8,r10
   11df1:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11df5:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11df9:	07 
   11dfa:	14 6d       	bgtr 11e69 <__vfprintf+0x9c3>
   11dfc:	d0 56 50    	movl r6,r0
   11dff:	19 64       	blss 11e65 <__vfprintf+0x9bf>
   11e01:	c3 50 cd c8 	subl3 r0,0xfffffdc8(fp),r6
   11e05:	fd 56 
   11e07:	14 03       	bgtr 11e0c <__vfprintf+0x966>
   11e09:	31 e9 fd    	brw 11bf5 <__vfprintf+0x74f>
   11e0c:	d1 56 10    	cmpl r6,$0x10
   11e0f:	15 26       	bleq 11e37 <__vfprintf+0x991>
   11e11:	9e ef ed a2 	movab 5c104 <zeroes.1>,(r10)
   11e15:	04 00 6a 
   11e18:	d0 10 aa 04 	movl $0x10,0x4(r10)
   11e1c:	c0 10 cd 10 	addl2 $0x10,0xfffffe10(fp)
   11e20:	fe 
   11e21:	c0 08 5a    	addl2 $0x8,r10
   11e24:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11e28:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11e2c:	07 
   11e2d:	14 1b       	bgtr 11e4a <__vfprintf+0x9a4>
   11e2f:	c2 10 56    	subl2 $0x10,r6
   11e32:	d1 56 10    	cmpl r6,$0x10
   11e35:	14 da       	bgtr 11e11 <__vfprintf+0x96b>
   11e37:	9e ef c7 a2 	movab 5c104 <zeroes.1>,(r10)
   11e3b:	04 00 6a 
   11e3e:	d0 56 aa 04 	movl r6,0x4(r10)
   11e42:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   11e46:	fe 
   11e47:	31 9a fd    	brw 11be4 <__vfprintf+0x73e>
   11e4a:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11e4e:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11e52:	fb 02 cf ed 	calls $0x2,11244 <__sprint>
   11e56:	f3 
   11e57:	d5 50       	tstl r0
   11e59:	13 03       	beql 11e5e <__vfprintf+0x9b8>
   11e5b:	31 3b fe    	brw 11c99 <__vfprintf+0x7f3>
   11e5e:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11e62:	5a 
   11e63:	11 ca       	brb 11e2f <__vfprintf+0x989>
   11e65:	d4 50       	clrf r0
   11e67:	11 98       	brb 11e01 <__vfprintf+0x95b>
   11e69:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11e6d:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11e71:	fb 02 cf ce 	calls $0x2,11244 <__sprint>
   11e75:	f3 
   11e76:	d5 50       	tstl r0
   11e78:	13 03       	beql 11e7d <__vfprintf+0x9d7>
   11e7a:	31 1c fe    	brw 11c99 <__vfprintf+0x7f3>
   11e7d:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11e81:	5a 
   11e82:	31 77 ff    	brw 11dfc <__vfprintf+0x956>
   11e85:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11e89:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11e8d:	fb 02 cf b2 	calls $0x2,11244 <__sprint>
   11e91:	f3 
   11e92:	d5 50       	tstl r0
   11e94:	13 03       	beql 11e99 <__vfprintf+0x9f3>
   11e96:	31 00 fe    	brw 11c99 <__vfprintf+0x7f3>
   11e99:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11e9d:	5a 
   11e9e:	31 2b ff    	brw 11dcc <__vfprintf+0x926>
   11ea1:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11ea5:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11ea9:	fb 02 cf 96 	calls $0x2,11244 <__sprint>
   11ead:	f3 
   11eae:	d5 50       	tstl r0
   11eb0:	13 03       	beql 11eb5 <__vfprintf+0xa0f>
   11eb2:	31 e4 fd    	brw 11c99 <__vfprintf+0x7f3>
   11eb5:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11eb9:	5a 
   11eba:	31 de fe    	brw 11d9b <__vfprintf+0x8f5>
   11ebd:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11ec1:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11ec5:	fb 02 cf 7a 	calls $0x2,11244 <__sprint>
   11ec9:	f3 
   11eca:	d5 50       	tstl r0
   11ecc:	13 03       	beql 11ed1 <__vfprintf+0xa2b>
   11ece:	31 c8 fd    	brw 11c99 <__vfprintf+0x7f3>
   11ed1:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11ed5:	5a 
   11ed6:	31 99 fe    	brw 11d72 <__vfprintf+0x8cc>
   11ed9:	d4 50       	clrf r0
   11edb:	31 66 fe    	brw 11d44 <__vfprintf+0x89e>
   11ede:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11ee2:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11ee6:	fb 02 cf 59 	calls $0x2,11244 <__sprint>
   11eea:	f3 
   11eeb:	d5 50       	tstl r0
   11eed:	13 03       	beql 11ef2 <__vfprintf+0xa4c>
   11eef:	31 a7 fd    	brw 11c99 <__vfprintf+0x7f3>
   11ef2:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11ef6:	5a 
   11ef7:	31 42 fe    	brw 11d3c <__vfprintf+0x896>
   11efa:	9e ef 04 a2 	movab 5c104 <zeroes.1>,(r10)
   11efe:	04 00 6a 
   11f01:	d0 01 aa 04 	movl $0x1,0x4(r10)
   11f05:	d6 cd 10 fe 	incl 0xfffffe10(fp)
   11f09:	c0 08 5a    	addl2 $0x8,r10
   11f0c:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11f10:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11f14:	07 
   11f15:	15 03       	bleq 11f1a <__vfprintf+0xa74>
   11f17:	31 d8 00    	brw 11ff2 <__vfprintf+0xb4c>
   11f1a:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   11f1e:	12 08       	bneq 11f28 <__vfprintf+0xa82>
   11f20:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r1
   11f24:	51 
   11f25:	e9 51 1e    	blbc r1,11f46 <__vfprintf+0xaa0>
   11f28:	d0 cd c4 fd 	movl 0xfffffdc4(fp),(r10)
   11f2c:	6a 
   11f2d:	d0 01 aa 04 	movl $0x1,0x4(r10)
   11f31:	d6 cd 10 fe 	incl 0xfffffe10(fp)
   11f35:	c0 08 5a    	addl2 $0x8,r10
   11f38:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11f3c:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11f40:	07 
   11f41:	15 03       	bleq 11f46 <__vfprintf+0xaa0>
   11f43:	31 90 00    	brw 11fd6 <__vfprintf+0xb30>
   11f46:	ce cd ec fd 	mnegl 0xfffffdec(fp),r6
   11f4a:	56 
   11f4b:	15 49       	bleq 11f96 <__vfprintf+0xaf0>
   11f4d:	d1 56 10    	cmpl r6,$0x10
   11f50:	15 26       	bleq 11f78 <__vfprintf+0xad2>
   11f52:	9e ef ac a1 	movab 5c104 <zeroes.1>,(r10)
   11f56:	04 00 6a 
   11f59:	d0 10 aa 04 	movl $0x10,0x4(r10)
   11f5d:	c0 10 cd 10 	addl2 $0x10,0xfffffe10(fp)
   11f61:	fe 
   11f62:	c0 08 5a    	addl2 $0x8,r10
   11f65:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11f69:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11f6d:	07 
   11f6e:	14 4b       	bgtr 11fbb <__vfprintf+0xb15>
   11f70:	c2 10 56    	subl2 $0x10,r6
   11f73:	d1 56 10    	cmpl r6,$0x10
   11f76:	14 da       	bgtr 11f52 <__vfprintf+0xaac>
   11f78:	9e ef 86 a1 	movab 5c104 <zeroes.1>,(r10)
   11f7c:	04 00 6a 
   11f7f:	d0 56 aa 04 	movl r6,0x4(r10)
   11f83:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   11f87:	fe 
   11f88:	c0 08 5a    	addl2 $0x8,r10
   11f8b:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   11f8f:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   11f93:	07 
   11f94:	14 0a       	bgtr 11fa0 <__vfprintf+0xafa>
   11f96:	c0 cd ec fd 	addl2 0xfffffdec(fp),0xfffffdc8(fp)
   11f9a:	cd c8 fd 
   11f9d:	31 2c fe    	brw 11dcc <__vfprintf+0x926>
   11fa0:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11fa4:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11fa8:	fb 02 cf 97 	calls $0x2,11244 <__sprint>
   11fac:	f2 
   11fad:	d5 50       	tstl r0
   11faf:	13 03       	beql 11fb4 <__vfprintf+0xb0e>
   11fb1:	31 e5 fc    	brw 11c99 <__vfprintf+0x7f3>
   11fb4:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11fb8:	5a 
   11fb9:	11 db       	brb 11f96 <__vfprintf+0xaf0>
   11fbb:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11fbf:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11fc3:	fb 02 cf 7c 	calls $0x2,11244 <__sprint>
   11fc7:	f2 
   11fc8:	d5 50       	tstl r0
   11fca:	13 03       	beql 11fcf <__vfprintf+0xb29>
   11fcc:	31 ca fc    	brw 11c99 <__vfprintf+0x7f3>
   11fcf:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11fd3:	5a 
   11fd4:	11 9a       	brb 11f70 <__vfprintf+0xaca>
   11fd6:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11fda:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11fde:	fb 02 cf 61 	calls $0x2,11244 <__sprint>
   11fe2:	f2 
   11fe3:	d5 50       	tstl r0
   11fe5:	13 03       	beql 11fea <__vfprintf+0xb44>
   11fe7:	31 af fc    	brw 11c99 <__vfprintf+0x7f3>
   11fea:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   11fee:	5a 
   11fef:	31 54 ff    	brw 11f46 <__vfprintf+0xaa0>
   11ff2:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   11ff6:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   11ffa:	fb 02 cf 45 	calls $0x2,11244 <__sprint>
   11ffe:	f2 
   11fff:	d5 50       	tstl r0
   12001:	13 03       	beql 12006 <__vfprintf+0xb60>
   12003:	31 93 fc    	brw 11c99 <__vfprintf+0x7f3>
   12006:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   1200a:	5a 
   1200b:	31 0c ff    	brw 11f1a <__vfprintf+0xa74>
   1200e:	d1 cd c8 fd 	cmpl 0xfffffdc8(fp),$0x1
   12012:	01 
   12013:	14 03       	bgtr 12018 <__vfprintf+0xb72>
   12015:	31 2d 01    	brw 12145 <__vfprintf+0xc9f>
   12018:	90 89 cd 54 	movb (r9)+,0xfffffe54(fp)
   1201c:	fe 
   1201d:	d0 cd c4 fd 	movl 0xfffffdc4(fp),r1
   12021:	51 
   12022:	90 61 cd 55 	movb (r1),0xfffffe55(fp)
   12026:	fe 
   12027:	9e cd 54 fe 	movab 0xfffffe54(fp),(r10)
   1202b:	6a 
   1202c:	d0 02 aa 04 	movl $0x2,0x4(r10)
   12030:	c0 02 cd 10 	addl2 $0x2,0xfffffe10(fp)
   12034:	fe 
   12035:	c0 08 5a    	addl2 $0x8,r10
   12038:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   1203c:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   12040:	07 
   12041:	15 03       	bleq 12046 <__vfprintf+0xba0>
   12043:	31 e3 00    	brw 12129 <__vfprintf+0xc83>
   12046:	d0 59 6a    	movl r9,(r10)
   12049:	c3 01 cd b4 	subl3 $0x1,0xfffffdb4(fp),0x4(r10)
   1204d:	fd aa 04 
   12050:	c1 cd 10 fe 	addl3 0xfffffe10(fp),0xfffffdb4(fp),r0
   12054:	cd b4 fd 50 
   12058:	c3 01 50 cd 	subl3 $0x1,r0,0xfffffe10(fp)
   1205c:	10 fe 
   1205e:	c0 08 5a    	addl2 $0x8,r10
   12061:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   12065:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   12069:	07 
   1206a:	15 03       	bleq 1206f <__vfprintf+0xbc9>
   1206c:	31 9e 00    	brw 1210d <__vfprintf+0xc67>
   1206f:	c3 cd b4 fd 	subl3 0xfffffdb4(fp),0xfffffdc8(fp),r6
   12073:	cd c8 fd 56 
   12077:	15 49       	bleq 120c2 <__vfprintf+0xc1c>
   12079:	d1 56 10    	cmpl r6,$0x10
   1207c:	15 26       	bleq 120a4 <__vfprintf+0xbfe>
   1207e:	9e ef 80 a0 	movab 5c104 <zeroes.1>,(r10)
   12082:	04 00 6a 
   12085:	d0 10 aa 04 	movl $0x10,0x4(r10)
   12089:	c0 10 cd 10 	addl2 $0x10,0xfffffe10(fp)
   1208d:	fe 
   1208e:	c0 08 5a    	addl2 $0x8,r10
   12091:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   12095:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   12099:	07 
   1209a:	14 56       	bgtr 120f2 <__vfprintf+0xc4c>
   1209c:	c2 10 56    	subl2 $0x10,r6
   1209f:	d1 56 10    	cmpl r6,$0x10
   120a2:	14 da       	bgtr 1207e <__vfprintf+0xbd8>
   120a4:	9e ef 5a a0 	movab 5c104 <zeroes.1>,(r10)
   120a8:	04 00 6a 
   120ab:	d0 56 aa 04 	movl r6,0x4(r10)
   120af:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   120b3:	fe 
   120b4:	c0 08 5a    	addl2 $0x8,r10
   120b7:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   120bb:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   120bf:	07 
   120c0:	14 15       	bgtr 120d7 <__vfprintf+0xc31>
   120c2:	9e cd dc fd 	movab 0xfffffddc(fp),(r10)
   120c6:	6a 
   120c7:	d0 cd bc fd 	movl 0xfffffdbc(fp),0x4(r10)
   120cb:	aa 04 
   120cd:	c0 cd bc fd 	addl2 0xfffffdbc(fp),0xfffffe10(fp)
   120d1:	cd 10 fe 
   120d4:	31 0d fb    	brw 11be4 <__vfprintf+0x73e>
   120d7:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   120db:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   120df:	fb 02 cf 60 	calls $0x2,11244 <__sprint>
   120e3:	f1 
   120e4:	d5 50       	tstl r0
   120e6:	13 03       	beql 120eb <__vfprintf+0xc45>
   120e8:	31 ae fb    	brw 11c99 <__vfprintf+0x7f3>
   120eb:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   120ef:	5a 
   120f0:	11 d0       	brb 120c2 <__vfprintf+0xc1c>
   120f2:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   120f6:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   120fa:	fb 02 cf 45 	calls $0x2,11244 <__sprint>
   120fe:	f1 
   120ff:	d5 50       	tstl r0
   12101:	13 03       	beql 12106 <__vfprintf+0xc60>
   12103:	31 93 fb    	brw 11c99 <__vfprintf+0x7f3>
   12106:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   1210a:	5a 
   1210b:	11 8f       	brb 1209c <__vfprintf+0xbf6>
   1210d:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   12111:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12115:	fb 02 cf 2a 	calls $0x2,11244 <__sprint>
   12119:	f1 
   1211a:	d5 50       	tstl r0
   1211c:	13 03       	beql 12121 <__vfprintf+0xc7b>
   1211e:	31 78 fb    	brw 11c99 <__vfprintf+0x7f3>
   12121:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   12125:	5a 
   12126:	31 46 ff    	brw 1206f <__vfprintf+0xbc9>
   12129:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   1212d:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12131:	fb 02 cf 0e 	calls $0x2,11244 <__sprint>
   12135:	f1 
   12136:	d5 50       	tstl r0
   12138:	13 03       	beql 1213d <__vfprintf+0xc97>
   1213a:	31 5c fb    	brw 11c99 <__vfprintf+0x7f3>
   1213d:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   12141:	5a 
   12142:	31 01 ff    	brw 12046 <__vfprintf+0xba0>
   12145:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   12149:	50 
   1214a:	e9 50 03    	blbc r0,12150 <__vfprintf+0xcaa>
   1214d:	31 c8 fe    	brw 12018 <__vfprintf+0xb72>
   12150:	d0 59 6a    	movl r9,(r10)
   12153:	d0 01 aa 04 	movl $0x1,0x4(r10)
   12157:	d6 cd 10 fe 	incl 0xfffffe10(fp)
   1215b:	31 56 ff    	brw 120b4 <__vfprintf+0xc0e>
   1215e:	dd 2c       	pushl $0x2c
   12160:	fb 01 ef fd 	calls $0x1,16b64 <nl_langinfo>
   12164:	49 00 00 
   12167:	d0 50 cd c4 	movl r0,0xfffffdc4(fp)
   1216b:	fd 
   1216c:	31 88 fb    	brw 11cf7 <__vfprintf+0x851>
   1216f:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   12173:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12177:	fb 02 cf c8 	calls $0x2,11244 <__sprint>
   1217b:	f0 
   1217c:	d5 50       	tstl r0
   1217e:	13 03       	beql 12183 <__vfprintf+0xcdd>
   12180:	31 16 fb    	brw 11c99 <__vfprintf+0x7f3>
   12183:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   12187:	5a 
   12188:	31 41 fa    	brw 11bcc <__vfprintf+0x726>
   1218b:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   1218f:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12193:	fb 02 cf ac 	calls $0x2,11244 <__sprint>
   12197:	f0 
   12198:	d5 50       	tstl r0
   1219a:	13 03       	beql 1219f <__vfprintf+0xcf9>
   1219c:	31 fa fa    	brw 11c99 <__vfprintf+0x7f3>
   1219f:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   121a3:	5a 
   121a4:	31 fc f9    	brw 11ba3 <__vfprintf+0x6fd>
   121a7:	c3 58 cd cc 	subl3 r8,0xfffffdcc(fp),r6
   121ab:	fd 56 
   121ad:	14 03       	bgtr 121b2 <__vfprintf+0xd0c>
   121af:	31 c3 f9    	brw 11b75 <__vfprintf+0x6cf>
   121b2:	d1 56 10    	cmpl r6,$0x10
   121b5:	15 26       	bleq 121dd <__vfprintf+0xd37>
   121b7:	9e ef 47 9f 	movab 5c104 <zeroes.1>,(r10)
   121bb:	04 00 6a 
   121be:	d0 10 aa 04 	movl $0x10,0x4(r10)
   121c2:	c0 10 cd 10 	addl2 $0x10,0xfffffe10(fp)
   121c6:	fe 
   121c7:	c0 08 5a    	addl2 $0x8,r10
   121ca:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   121ce:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   121d2:	07 
   121d3:	14 45       	bgtr 1221a <__vfprintf+0xd74>
   121d5:	c2 10 56    	subl2 $0x10,r6
   121d8:	d1 56 10    	cmpl r6,$0x10
   121db:	14 da       	bgtr 121b7 <__vfprintf+0xd11>
   121dd:	9e ef 21 9f 	movab 5c104 <zeroes.1>,(r10)
   121e1:	04 00 6a 
   121e4:	d0 56 aa 04 	movl r6,0x4(r10)
   121e8:	c0 56 cd 10 	addl2 r6,0xfffffe10(fp)
   121ec:	fe 
   121ed:	c0 08 5a    	addl2 $0x8,r10
   121f0:	d6 cd 0c fe 	incl 0xfffffe0c(fp)
   121f4:	d1 cd 0c fe 	cmpl 0xfffffe0c(fp),$0x7
   121f8:	07 
   121f9:	14 03       	bgtr 121fe <__vfprintf+0xd58>
   121fb:	31 77 f9    	brw 11b75 <__vfprintf+0x6cf>
   121fe:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   12202:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12206:	fb 02 cf 39 	calls $0x2,11244 <__sprint>
   1220a:	f0 
   1220b:	d5 50       	tstl r0
   1220d:	13 03       	beql 12212 <__vfprintf+0xd6c>
   1220f:	31 87 fa    	brw 11c99 <__vfprintf+0x7f3>
   12212:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   12216:	5a 
   12217:	31 5b f9    	brw 11b75 <__vfprintf+0x6cf>
   1221a:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   1221e:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12222:	fb 02 cf 1d 	calls $0x2,11244 <__sprint>
   12226:	f0 
   12227:	d5 50       	tstl r0
   12229:	13 03       	beql 1222e <__vfprintf+0xd88>
   1222b:	31 6b fa    	brw 11c99 <__vfprintf+0x7f3>
   1222e:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   12232:	5a 
   12233:	11 a0       	brb 121d5 <__vfprintf+0xd2f>
   12235:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   12239:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   1223d:	fb 02 cf 02 	calls $0x2,11244 <__sprint>
   12241:	f0 
   12242:	d5 50       	tstl r0
   12244:	13 03       	beql 12249 <__vfprintf+0xda3>
   12246:	31 50 fa    	brw 11c99 <__vfprintf+0x7f3>
   12249:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   1224d:	5a 
   1224e:	31 0e f9    	brw 11b5f <__vfprintf+0x6b9>
   12251:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   12255:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12259:	fb 02 cf e6 	calls $0x2,11244 <__sprint>
   1225d:	ef 
   1225e:	d5 50       	tstl r0
   12260:	13 03       	beql 12265 <__vfprintf+0xdbf>
   12262:	31 34 fa    	brw 11c99 <__vfprintf+0x7f3>
   12265:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   12269:	5a 
   1226a:	31 c6 f8    	brw 11b33 <__vfprintf+0x68d>
   1226d:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   12271:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12275:	fb 02 cf ca 	calls $0x2,11244 <__sprint>
   12279:	ef 
   1227a:	d5 50       	tstl r0
   1227c:	13 03       	beql 12281 <__vfprintf+0xddb>
   1227e:	31 18 fa    	brw 11c99 <__vfprintf+0x7f3>
   12281:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   12285:	5a 
   12286:	31 86 f8    	brw 11b0f <__vfprintf+0x669>
   12289:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   1228d:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12291:	fb 02 cf ae 	calls $0x2,11244 <__sprint>
   12295:	ef 
   12296:	d5 50       	tstl r0
   12298:	13 03       	beql 1229d <__vfprintf+0xdf7>
   1229a:	31 fc f9    	brw 11c99 <__vfprintf+0x7f3>
   1229d:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   122a1:	5a 
   122a2:	31 41 f8    	brw 11ae6 <__vfprintf+0x640>
   122a5:	cb 8f f0 ff 	bicl3 $0xfffffff0,r6,r0
   122a9:	ff ff 56 50 
   122ad:	d0 cd a8 fd 	movl 0xfffffda8(fp),r2
   122b1:	52 
   122b2:	90 42 60 79 	movb (r0)[r2],-(r9)
   122b6:	78 1c 57 55 	ashl $0x1c,r7,r5
   122ba:	d0 04 54    	movl $0x4,r4
   122bd:	90 1c 53    	movb $0x1c,r3
   122c0:	ef 54 53 56 	extzv r4,r3,r6,r2
   122c4:	52 
   122c5:	c9 52 55 50 	bisl3 r2,r5,r0
   122c9:	ef 54 53 57 	extzv r4,r3,r7,r1
   122cd:	51 
   122ce:	7d 50 56    	movq r0,r6
   122d1:	c9 57 56 50 	bisl3 r7,r6,r0
   122d5:	12 ce       	bneq 122a5 <__vfprintf+0xdff>
   122d7:	c3 59 5d 50 	subl3 r9,fp,r0
   122db:	9e c0 b8 fe 	movab 0xfffffeb8(r0),r7
   122df:	57 
   122e0:	d1 57 8f 64 	cmpl r7,$0x00000064
   122e4:	00 00 00 
   122e7:	14 03       	bgtr 122ec <__vfprintf+0xe46>
   122e9:	31 a4 f7    	brw 11a90 <__vfprintf+0x5ea>
   122ec:	31 e2 0c    	brw 12fd1 <__vfprintf+0x1b2b>
   122ef:	8b 8f f8 56 	bicb3 $0xf8,r6,r0
   122f3:	50 
   122f4:	81 50 30 58 	addb3 r0,$0x30,r8
   122f8:	90 58 79    	movb r8,-(r9)
   122fb:	78 1d 57 55 	ashl $0x1d,r7,r5
   122ff:	d0 03 54    	movl $0x3,r4
   12302:	90 1d 53    	movb $0x1d,r3
   12305:	ef 54 53 56 	extzv r4,r3,r6,r2
   12309:	52 
   1230a:	c9 52 55 50 	bisl3 r2,r5,r0
   1230e:	ef 54 53 57 	extzv r4,r3,r7,r1
   12312:	51 
   12313:	7d 50 56    	movq r0,r6
   12316:	c9 57 56 50 	bisl3 r7,r6,r0
   1231a:	12 d3       	bneq 122ef <__vfprintf+0xe49>
   1231c:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r1
   12320:	51 
   12321:	e9 51 b3    	blbc r1,122d7 <__vfprintf+0xe31>
   12324:	91 58 30    	cmpb r8,$0x30
   12327:	13 ae       	beql 122d7 <__vfprintf+0xe31>
   12329:	90 30 79    	movb $0x30,-(r9)
   1232c:	11 a9       	brb 122d7 <__vfprintf+0xe31>
   1232e:	d5 57       	tstl r7
   12330:	13 33       	beql 12365 <__vfprintf+0xebf>
   12332:	7d 0a 7e    	movq $0xa,-(sp)
   12335:	7d 56 7e    	movq r6,-(sp)
   12338:	fb 04 ef 41 	calls $0x4,15880 <__umoddi3>
   1233c:	35 00 00 
   1233f:	81 50 30 79 	addb3 r0,$0x30,-(r9)
   12343:	7d 0a 7e    	movq $0xa,-(sp)
   12346:	7d 56 7e    	movq r6,-(sp)
   12349:	fb 04 ef 18 	calls $0x4,15868 <__udivdi3>
   1234d:	35 00 00 
   12350:	7d 50 56    	movq r0,r6
   12353:	d5 57       	tstl r7
   12355:	12 db       	bneq 12332 <__vfprintf+0xe8c>
   12357:	12 05       	bneq 1235e <__vfprintf+0xeb8>
   12359:	d1 50 09    	cmpl r0,$0x9
   1235c:	1a d4       	bgtru 12332 <__vfprintf+0xe8c>
   1235e:	81 56 30 79 	addb3 r6,$0x30,-(r9)
   12362:	31 72 ff    	brw 122d7 <__vfprintf+0xe31>
   12365:	d5 57       	tstl r7
   12367:	12 f5       	bneq 1235e <__vfprintf+0xeb8>
   12369:	d1 56 09    	cmpl r6,$0x9
   1236c:	1a c4       	bgtru 12332 <__vfprintf+0xe8c>
   1236e:	11 ee       	brb 1235e <__vfprintf+0xeb8>
   12370:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12374:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12378:	50 
   12379:	c1 50 08 cd 	addl3 r0,$0x8,0xfffffd94(fp)
   1237d:	94 fd 
   1237f:	7d 60 56    	movq (r0),r6
   12382:	31 a0 f6    	brw 11a25 <__vfprintf+0x57f>
   12385:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12389:	52 
   1238a:	e0 04 52 12 	bbs $0x4,r2,123a0 <__vfprintf+0xefa>
   1238e:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12392:	52 
   12393:	e0 09 52 09 	bbs $0x9,r2,123a0 <__vfprintf+0xefa>
   12397:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   1239b:	52 
   1239c:	e1 0a 52 41 	bbc $0xa,r2,123e1 <__vfprintf+0xf3b>
   123a0:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   123a4:	50 
   123a5:	13 1d       	beql 123c4 <__vfprintf+0xf1e>
   123a7:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   123ab:	51 
   123ac:	7e 41 60 50 	movaq (r0)[r1],r0
   123b0:	d0 60 50    	movl (r0),r0
   123b3:	d0 50 56    	movl r0,r6
   123b6:	78 8f e1 50 	ashl $0xe1,r0,r7
   123ba:	57 
   123bb:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   123bf:	a4 fd 
   123c1:	31 61 f6    	brw 11a25 <__vfprintf+0x57f>
   123c4:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   123c8:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   123cc:	50 
   123cd:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   123d1:	94 fd 
   123d3:	d0 60 50    	movl (r0),r0
   123d6:	d0 50 56    	movl r0,r6
   123d9:	78 8f e1 50 	ashl $0xe1,r0,r7
   123dd:	57 
   123de:	31 44 f6    	brw 11a25 <__vfprintf+0x57f>
   123e1:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   123e5:	52 
   123e6:	e1 06 52 29 	bbc $0x6,r2,12413 <__vfprintf+0xf6d>
   123ea:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   123ee:	50 
   123ef:	13 0e       	beql 123ff <__vfprintf+0xf59>
   123f1:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   123f5:	51 
   123f6:	7e 41 60 50 	movaq (r0)[r1],r0
   123fa:	32 60 50    	cvtwl (r0),r0
   123fd:	11 b4       	brb 123b3 <__vfprintf+0xf0d>
   123ff:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12403:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12407:	50 
   12408:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   1240c:	94 fd 
   1240e:	32 60 50    	cvtwl (r0),r0
   12411:	11 c3       	brb 123d6 <__vfprintf+0xf30>
   12413:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12417:	52 
   12418:	e1 0b 52 29 	bbc $0xb,r2,12445 <__vfprintf+0xf9f>
   1241c:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12420:	50 
   12421:	13 0e       	beql 12431 <__vfprintf+0xf8b>
   12423:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12427:	51 
   12428:	7e 41 60 50 	movaq (r0)[r1],r0
   1242c:	98 60 50    	cvtbl (r0),r0
   1242f:	11 82       	brb 123b3 <__vfprintf+0xf0d>
   12431:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12435:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12439:	50 
   1243a:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   1243e:	94 fd 
   12440:	98 60 50    	cvtbl (r0),r0
   12443:	11 91       	brb 123d6 <__vfprintf+0xf30>
   12445:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12449:	50 
   1244a:	12 03       	bneq 1244f <__vfprintf+0xfa9>
   1244c:	31 75 ff    	brw 123c4 <__vfprintf+0xf1e>
   1244f:	d0 cd a4 fd 	movl 0xfffffda4(fp),r2
   12453:	52 
   12454:	7e 42 60 50 	movaq (r0)[r2],r0
   12458:	d0 60 50    	movl (r0),r0
   1245b:	d0 50 56    	movl r0,r6
   1245e:	78 8f e1 50 	ashl $0xe1,r0,r7
   12462:	57 
   12463:	c1 52 01 cd 	addl3 r2,$0x1,0xfffffda4(fp)
   12467:	a4 fd 
   12469:	31 b9 f5    	brw 11a25 <__vfprintf+0x57f>
   1246c:	c8 08 cd d4 	bisl2 $0x8,0xfffffdd4(fp)
   12470:	fd 
   12471:	31 7c f1    	brw 115f0 <__vfprintf+0x14a>
   12474:	c8 10 cd d4 	bisl2 $0x10,0xfffffdd4(fp)
   12478:	fd 
   12479:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   1247d:	50 
   1247e:	e0 0c 50 09 	bbs $0xc,r0,1248b <__vfprintf+0xfe5>
   12482:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r1
   12486:	51 
   12487:	e1 05 51 33 	bbc $0x5,r1,124be <__vfprintf+0x1018>
   1248b:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r2
   1248f:	52 
   12490:	13 18       	beql 124aa <__vfprintf+0x1004>
   12492:	d0 cd a4 fd 	movl 0xfffffda4(fp),r0
   12496:	50 
   12497:	c1 50 01 cd 	addl3 r0,$0x1,0xfffffda4(fp)
   1249b:	a4 fd 
   1249d:	7d 40 62 56 	movq (r2)[r0],r6
   124a1:	d4 51       	clrf r1
   124a3:	94 cd db fd 	clrb 0xfffffddb(fp)
   124a7:	31 94 f5    	brw 11a3e <__vfprintf+0x598>
   124aa:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   124ae:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   124b2:	50 
   124b3:	c1 50 08 cd 	addl3 r0,$0x8,0xfffffd94(fp)
   124b7:	94 fd 
   124b9:	7d 60 56    	movq (r0),r6
   124bc:	11 e3       	brb 124a1 <__vfprintf+0xffb>
   124be:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   124c2:	52 
   124c3:	e0 04 52 12 	bbs $0x4,r2,124d9 <__vfprintf+0x1033>
   124c7:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   124cb:	52 
   124cc:	e0 09 52 09 	bbs $0x9,r2,124d9 <__vfprintf+0x1033>
   124d0:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   124d4:	52 
   124d5:	e1 0a 52 33 	bbc $0xa,r2,1250c <__vfprintf+0x1066>
   124d9:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   124dd:	50 
   124de:	13 16       	beql 124f6 <__vfprintf+0x1050>
   124e0:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   124e4:	51 
   124e5:	7e 41 60 50 	movaq (r0)[r1],r0
   124e9:	d0 60 56    	movl (r0),r6
   124ec:	d4 57       	clrf r7
   124ee:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   124f2:	a4 fd 
   124f4:	11 ab       	brb 124a1 <__vfprintf+0xffb>
   124f6:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   124fa:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   124fe:	50 
   124ff:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12503:	94 fd 
   12505:	d0 60 56    	movl (r0),r6
   12508:	d4 57       	clrf r7
   1250a:	11 95       	brb 124a1 <__vfprintf+0xffb>
   1250c:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12510:	52 
   12511:	e1 06 52 29 	bbc $0x6,r2,1253e <__vfprintf+0x1098>
   12515:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12519:	50 
   1251a:	13 0e       	beql 1252a <__vfprintf+0x1084>
   1251c:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12520:	51 
   12521:	7e 41 60 50 	movaq (r0)[r1],r0
   12525:	3c 60 56    	movzwl (r0),r6
   12528:	11 c2       	brb 124ec <__vfprintf+0x1046>
   1252a:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   1252e:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12532:	50 
   12533:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12537:	94 fd 
   12539:	3c 60 56    	movzwl (r0),r6
   1253c:	11 ca       	brb 12508 <__vfprintf+0x1062>
   1253e:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12542:	52 
   12543:	e1 0b 52 29 	bbc $0xb,r2,12570 <__vfprintf+0x10ca>
   12547:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   1254b:	50 
   1254c:	13 0e       	beql 1255c <__vfprintf+0x10b6>
   1254e:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12552:	51 
   12553:	7e 41 60 50 	movaq (r0)[r1],r0
   12557:	9a 60 56    	movzbl (r0),r6
   1255a:	11 90       	brb 124ec <__vfprintf+0x1046>
   1255c:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12560:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12564:	50 
   12565:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12569:	94 fd 
   1256b:	9a 60 56    	movzbl (r0),r6
   1256e:	11 98       	brb 12508 <__vfprintf+0x1062>
   12570:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12574:	50 
   12575:	12 03       	bneq 1257a <__vfprintf+0x10d4>
   12577:	31 7c ff    	brw 124f6 <__vfprintf+0x1050>
   1257a:	d0 cd a4 fd 	movl 0xfffffda4(fp),r2
   1257e:	52 
   1257f:	7e 42 60 50 	movaq (r0)[r2],r0
   12583:	d0 60 56    	movl (r0),r6
   12586:	d4 57       	clrf r7
   12588:	c1 52 01 cd 	addl3 r2,$0x1,0xfffffda4(fp)
   1258c:	a4 fd 
   1258e:	31 10 ff    	brw 124a1 <__vfprintf+0xffb>
   12591:	c8 10 cd d4 	bisl2 $0x10,0xfffffdd4(fp)
   12595:	fd 
   12596:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   1259a:	50 
   1259b:	e0 0c 50 09 	bbs $0xc,r0,125a8 <__vfprintf+0x1102>
   1259f:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r1
   125a3:	51 
   125a4:	e1 05 51 30 	bbc $0x5,r1,125d8 <__vfprintf+0x1132>
   125a8:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r2
   125ac:	52 
   125ad:	13 15       	beql 125c4 <__vfprintf+0x111e>
   125af:	d0 cd a4 fd 	movl 0xfffffda4(fp),r0
   125b3:	50 
   125b4:	c1 50 01 cd 	addl3 r0,$0x1,0xfffffda4(fp)
   125b8:	a4 fd 
   125ba:	7d 40 62 56 	movq (r2)[r0],r6
   125be:	d0 01 51    	movl $0x1,r1
   125c1:	31 df fe    	brw 124a3 <__vfprintf+0xffd>
   125c4:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   125c8:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   125cc:	50 
   125cd:	c1 50 08 cd 	addl3 r0,$0x8,0xfffffd94(fp)
   125d1:	94 fd 
   125d3:	7d 60 56    	movq (r0),r6
   125d6:	11 e6       	brb 125be <__vfprintf+0x1118>
   125d8:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   125dc:	52 
   125dd:	e0 04 52 12 	bbs $0x4,r2,125f3 <__vfprintf+0x114d>
   125e1:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   125e5:	52 
   125e6:	e0 09 52 09 	bbs $0x9,r2,125f3 <__vfprintf+0x114d>
   125ea:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   125ee:	52 
   125ef:	e1 0a 52 33 	bbc $0xa,r2,12626 <__vfprintf+0x1180>
   125f3:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   125f7:	50 
   125f8:	13 16       	beql 12610 <__vfprintf+0x116a>
   125fa:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   125fe:	51 
   125ff:	7e 41 60 50 	movaq (r0)[r1],r0
   12603:	d0 60 56    	movl (r0),r6
   12606:	d4 57       	clrf r7
   12608:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   1260c:	a4 fd 
   1260e:	11 ae       	brb 125be <__vfprintf+0x1118>
   12610:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12614:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12618:	50 
   12619:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   1261d:	94 fd 
   1261f:	d0 60 56    	movl (r0),r6
   12622:	d4 57       	clrf r7
   12624:	11 98       	brb 125be <__vfprintf+0x1118>
   12626:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   1262a:	52 
   1262b:	e1 06 52 29 	bbc $0x6,r2,12658 <__vfprintf+0x11b2>
   1262f:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12633:	50 
   12634:	13 0e       	beql 12644 <__vfprintf+0x119e>
   12636:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   1263a:	51 
   1263b:	7e 41 60 50 	movaq (r0)[r1],r0
   1263f:	3c 60 56    	movzwl (r0),r6
   12642:	11 c2       	brb 12606 <__vfprintf+0x1160>
   12644:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12648:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   1264c:	50 
   1264d:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12651:	94 fd 
   12653:	3c 60 56    	movzwl (r0),r6
   12656:	11 ca       	brb 12622 <__vfprintf+0x117c>
   12658:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   1265c:	52 
   1265d:	e1 0b 52 29 	bbc $0xb,r2,1268a <__vfprintf+0x11e4>
   12661:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12665:	50 
   12666:	13 0e       	beql 12676 <__vfprintf+0x11d0>
   12668:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   1266c:	51 
   1266d:	7e 41 60 50 	movaq (r0)[r1],r0
   12671:	9a 60 56    	movzbl (r0),r6
   12674:	11 90       	brb 12606 <__vfprintf+0x1160>
   12676:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   1267a:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   1267e:	50 
   1267f:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12683:	94 fd 
   12685:	9a 60 56    	movzbl (r0),r6
   12688:	11 98       	brb 12622 <__vfprintf+0x117c>
   1268a:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   1268e:	50 
   1268f:	12 03       	bneq 12694 <__vfprintf+0x11ee>
   12691:	31 7c ff    	brw 12610 <__vfprintf+0x116a>
   12694:	d0 cd a4 fd 	movl 0xfffffda4(fp),r2
   12698:	52 
   12699:	7e 42 60 50 	movaq (r0)[r2],r0
   1269d:	d0 60 56    	movl (r0),r6
   126a0:	d4 57       	clrf r7
   126a2:	c1 52 01 cd 	addl3 r2,$0x1,0xfffffda4(fp)
   126a6:	a4 fd 
   126a8:	31 13 ff    	brw 125be <__vfprintf+0x1118>
   126ab:	9e ef cc 84 	movab 2ab7d <xdigs_upper.3>,0xfffffda8(fp)
   126af:	01 00 cd a8 
   126b3:	fd 
   126b4:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   126b8:	50 
   126b9:	e0 0c 50 09 	bbs $0xc,r0,126c6 <__vfprintf+0x1220>
   126bd:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r1
   126c1:	51 
   126c2:	e1 05 51 49 	bbc $0x5,r1,1270f <__vfprintf+0x1269>
   126c6:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r2
   126ca:	52 
   126cb:	13 2e       	beql 126fb <__vfprintf+0x1255>
   126cd:	d0 cd a4 fd 	movl 0xfffffda4(fp),r0
   126d1:	50 
   126d2:	c1 50 01 cd 	addl3 r0,$0x1,0xfffffda4(fp)
   126d6:	a4 fd 
   126d8:	7d 40 62 56 	movq (r2)[r0],r6
   126dc:	d0 02 51    	movl $0x2,r1
   126df:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   126e3:	50 
   126e4:	e8 50 03    	blbs r0,126ea <__vfprintf+0x1244>
   126e7:	31 b9 fd    	brw 124a3 <__vfprintf+0xffd>
   126ea:	c9 57 56 50 	bisl3 r7,r6,r0
   126ee:	12 03       	bneq 126f3 <__vfprintf+0x124d>
   126f0:	31 b0 fd    	brw 124a3 <__vfprintf+0xffd>
   126f3:	90 58 cd 03 	movb r8,0xfffffe03(fp)
   126f7:	fe 
   126f8:	31 a8 fd    	brw 124a3 <__vfprintf+0xffd>
   126fb:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   126ff:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12703:	50 
   12704:	c1 50 08 cd 	addl3 r0,$0x8,0xfffffd94(fp)
   12708:	94 fd 
   1270a:	7d 60 56    	movq (r0),r6
   1270d:	11 cd       	brb 126dc <__vfprintf+0x1236>
   1270f:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12713:	52 
   12714:	e0 04 52 12 	bbs $0x4,r2,1272a <__vfprintf+0x1284>
   12718:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   1271c:	52 
   1271d:	e0 09 52 09 	bbs $0x9,r2,1272a <__vfprintf+0x1284>
   12721:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12725:	52 
   12726:	e1 0a 52 34 	bbc $0xa,r2,1275e <__vfprintf+0x12b8>
   1272a:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   1272e:	50 
   1272f:	13 16       	beql 12747 <__vfprintf+0x12a1>
   12731:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12735:	51 
   12736:	7e 41 60 50 	movaq (r0)[r1],r0
   1273a:	d0 60 56    	movl (r0),r6
   1273d:	d4 57       	clrf r7
   1273f:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   12743:	a4 fd 
   12745:	11 95       	brb 126dc <__vfprintf+0x1236>
   12747:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   1274b:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   1274f:	50 
   12750:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12754:	94 fd 
   12756:	d0 60 56    	movl (r0),r6
   12759:	d4 57       	clrf r7
   1275b:	31 7e ff    	brw 126dc <__vfprintf+0x1236>
   1275e:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12762:	52 
   12763:	e1 06 52 29 	bbc $0x6,r2,12790 <__vfprintf+0x12ea>
   12767:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   1276b:	50 
   1276c:	13 0e       	beql 1277c <__vfprintf+0x12d6>
   1276e:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12772:	51 
   12773:	7e 41 60 50 	movaq (r0)[r1],r0
   12777:	3c 60 56    	movzwl (r0),r6
   1277a:	11 c1       	brb 1273d <__vfprintf+0x1297>
   1277c:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12780:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12784:	50 
   12785:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12789:	94 fd 
   1278b:	3c 60 56    	movzwl (r0),r6
   1278e:	11 c9       	brb 12759 <__vfprintf+0x12b3>
   12790:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12794:	52 
   12795:	e1 0b 52 29 	bbc $0xb,r2,127c2 <__vfprintf+0x131c>
   12799:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   1279d:	50 
   1279e:	13 0e       	beql 127ae <__vfprintf+0x1308>
   127a0:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   127a4:	51 
   127a5:	7e 41 60 50 	movaq (r0)[r1],r0
   127a9:	9a 60 56    	movzbl (r0),r6
   127ac:	11 8f       	brb 1273d <__vfprintf+0x1297>
   127ae:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   127b2:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   127b6:	50 
   127b7:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   127bb:	94 fd 
   127bd:	9a 60 56    	movzbl (r0),r6
   127c0:	11 97       	brb 12759 <__vfprintf+0x12b3>
   127c2:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   127c6:	50 
   127c7:	12 03       	bneq 127cc <__vfprintf+0x1326>
   127c9:	31 7b ff    	brw 12747 <__vfprintf+0x12a1>
   127cc:	d0 cd a4 fd 	movl 0xfffffda4(fp),r2
   127d0:	52 
   127d1:	7e 42 60 50 	movaq (r0)[r2],r0
   127d5:	d0 60 56    	movl (r0),r6
   127d8:	d4 57       	clrf r7
   127da:	c1 52 01 cd 	addl3 r2,$0x1,0xfffffda4(fp)
   127de:	a4 fd 
   127e0:	31 f9 fe    	brw 126dc <__vfprintf+0x1236>
   127e3:	d1 58 8f 61 	cmpl r8,$0x00000061
   127e7:	00 00 00 
   127ea:	12 03       	bneq 127ef <__vfprintf+0x1349>
   127ec:	31 67 02    	brw 12a56 <__vfprintf+0x15b0>
   127ef:	90 8f 58 cd 	movb $0x58,0xfffffe03(fp)
   127f3:	03 fe 
   127f5:	9e ef 82 83 	movab 2ab7d <xdigs_upper.3>,0xfffffda8(fp)
   127f9:	01 00 cd a8 
   127fd:	fd 
   127fe:	90 8f 50 cd 	movb $0x50,0xfffffdc3(fp)
   12802:	c3 fd 
   12804:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   12808:	19 04       	blss 1280e <__vfprintf+0x1368>
   1280a:	d6 cd c8 fd 	incl 0xfffffdc8(fp)
   1280e:	d5 cd b0 fd 	tstl 0xfffffdb0(fp)
   12812:	13 0b       	beql 1281f <__vfprintf+0x1379>
   12814:	dd cd b0 fd 	pushl 0xfffffdb0(fp)
   12818:	fb 01 ef a9 	calls $0x1,146c8 <__freedtoa>
   1281c:	1e 00 00 
   1281f:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   12823:	50 
   12824:	e0 03 50 03 	bbs $0x3,r0,1282b <__vfprintf+0x1385>
   12828:	31 db 01    	brw 12a06 <__vfprintf+0x1560>
   1282b:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r1
   1282f:	51 
   12830:	12 03       	bneq 12835 <__vfprintf+0x138f>
   12832:	31 bc 01    	brw 129f1 <__vfprintf+0x154b>
   12835:	d0 cd a4 fd 	movl 0xfffffda4(fp),r0
   12839:	50 
   1283a:	c1 50 01 cd 	addl3 r0,$0x1,0xfffffda4(fp)
   1283e:	a4 fd 
   12840:	70 40 61 50 	movd (r1)[r0],r0
   12844:	70 50 cd e4 	movd r0,0xfffffde4(fp)
   12848:	fd 
   12849:	9f cd f4 fd 	pushab 0xfffffdf4(fp)
   1284d:	9f cd f0 fd 	pushab 0xfffffdf0(fp)
   12851:	9f cd ec fd 	pushab 0xfffffdec(fp)
   12855:	dd cd c8 fd 	pushl 0xfffffdc8(fp)
   12859:	dd cd a8 fd 	pushl 0xfffffda8(fp)
   1285d:	70 50 7e    	movd r0,-(sp)
   12860:	fb 07 ef 9d 	calls $0x7,13c04 <__hldtoa>
   12864:	13 00 00 
   12867:	d0 50 cd b0 	movl r0,0xfffffdb0(fp)
   1286b:	fd 
   1286c:	d0 50 59    	movl r0,r9
   1286f:	12 03       	bneq 12874 <__vfprintf+0x13ce>
   12871:	31 70 01    	brw 129e4 <__vfprintf+0x153e>
   12874:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   12878:	18 03       	bgeq 1287d <__vfprintf+0x13d7>
   1287a:	31 5c 01    	brw 129d9 <__vfprintf+0x1533>
   1287d:	d1 cd ec fd 	cmpl 0xfffffdec(fp),$0x7fffffff
   12881:	8f ff ff ff 
   12885:	7f 
   12886:	12 03       	bneq 1288b <__vfprintf+0x13e5>
   12888:	31 47 01    	brw 129d2 <__vfprintf+0x152c>
   1288b:	d5 cd f0 fd 	tstl 0xfffffdf0(fp)
   1288f:	13 05       	beql 12896 <__vfprintf+0x13f0>
   12891:	90 2d cd db 	movb $0x2d,0xfffffddb(fp)
   12895:	fd 
   12896:	d0 cd ec fd 	movl 0xfffffdec(fp),r0
   1289a:	50 
   1289b:	d1 50 8f ff 	cmpl r0,$0x7fffffff
   1289f:	ff ff 7f 
   128a2:	12 03       	bneq 128a7 <__vfprintf+0x1401>
   128a4:	31 e2 00    	brw 12989 <__vfprintf+0x14e3>
   128a7:	c8 8f 00 01 	bisl2 $0x00000100,0xfffffdd4(fp)
   128ab:	00 00 cd d4 
   128af:	fd 
   128b0:	c3 59 cd f4 	subl3 r9,0xfffffdf4(fp),0xfffffdb4(fp)
   128b4:	fd cd b4 fd 
   128b8:	d1 58 8f 67 	cmpl r8,$0x00000067
   128bc:	00 00 00 
   128bf:	13 78       	beql 12939 <__vfprintf+0x1493>
   128c1:	d1 58 8f 47 	cmpl r8,$0x00000047
   128c5:	00 00 00 
   128c8:	13 6f       	beql 12939 <__vfprintf+0x1493>
   128ca:	95 cd c3 fd 	tstb 0xfffffdc3(fp)
   128ce:	12 31       	bneq 12901 <__vfprintf+0x145b>
   128d0:	d0 cd ec fd 	movl 0xfffffdec(fp),r0
   128d4:	50 
   128d5:	15 25       	bleq 128fc <__vfprintf+0x1456>
   128d7:	d0 50 57    	movl r0,r7
   128da:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   128de:	12 08       	bneq 128e8 <__vfprintf+0x1442>
   128e0:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   128e4:	52 
   128e5:	e9 52 0a    	blbc r2,128f2 <__vfprintf+0x144c>
   128e8:	d0 cd c8 fd 	movl 0xfffffdc8(fp),r0
   128ec:	50 
   128ed:	9e 47 a0 01 	movab 0x1(r0)[r7],r7
   128f1:	57 
   128f2:	d0 cd ec fd 	movl 0xfffffdec(fp),0xfffffdb8(fp)
   128f6:	cd b8 fd 
   128f9:	31 94 f1    	brw 11a90 <__vfprintf+0x5ea>
   128fc:	d0 01 57    	movl $0x1,r7
   128ff:	11 d9       	brb 128da <__vfprintf+0x1434>
   12901:	98 cd c3 fd 	cvtbl 0xfffffdc3(fp),-(sp)
   12905:	7e 
   12906:	c3 01 cd ec 	subl3 $0x1,0xfffffdec(fp),-(sp)
   1290a:	fd 7e 
   1290c:	9f cd dc fd 	pushab 0xfffffddc(fp)
   12910:	fb 03 cf 81 	calls $0x3,13996 <exponent>
   12914:	10 
   12915:	d0 50 cd bc 	movl r0,0xfffffdbc(fp)
   12919:	fd 
   1291a:	c1 50 cd c8 	addl3 r0,0xfffffdc8(fp),r7
   1291e:	fd 57 
   12920:	d1 cd c8 fd 	cmpl 0xfffffdc8(fp),$0x1
   12924:	01 
   12925:	15 05       	bleq 1292c <__vfprintf+0x1486>
   12927:	d6 57       	incl r7
   12929:	31 64 f1    	brw 11a90 <__vfprintf+0x5ea>
   1292c:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r1
   12930:	51 
   12931:	e8 51 03    	blbs r1,12937 <__vfprintf+0x1491>
   12934:	31 59 f1    	brw 11a90 <__vfprintf+0x5ea>
   12937:	11 ee       	brb 12927 <__vfprintf+0x1481>
   12939:	d1 50 8f fc 	cmpl r0,$0xfffffffc
   1293d:	ff ff ff 
   12940:	15 32       	bleq 12974 <__vfprintf+0x14ce>
   12942:	d1 50 cd c8 	cmpl r0,0xfffffdc8(fp)
   12946:	fd 
   12947:	14 2b       	bgtr 12974 <__vfprintf+0x14ce>
   12949:	94 cd c3 fd 	clrb 0xfffffdc3(fp)
   1294d:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12951:	52 
   12952:	e9 52 15    	blbc r2,1296a <__vfprintf+0x14c4>
   12955:	c2 50 cd c8 	subl2 r0,0xfffffdc8(fp)
   12959:	fd 
   1295a:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   1295e:	19 03       	blss 12963 <__vfprintf+0x14bd>
   12960:	31 67 ff    	brw 128ca <__vfprintf+0x1424>
   12963:	d4 cd c8 fd 	clrf 0xfffffdc8(fp)
   12967:	31 60 ff    	brw 128ca <__vfprintf+0x1424>
   1296a:	c3 50 cd b4 	subl3 r0,0xfffffdb4(fp),0xfffffdc8(fp)
   1296e:	fd cd c8 fd 
   12972:	11 e6       	brb 1295a <__vfprintf+0x14b4>
   12974:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   12978:	50 
   12979:	e9 50 03    	blbc r0,1297f <__vfprintf+0x14d9>
   1297c:	31 4b ff    	brw 128ca <__vfprintf+0x1424>
   1297f:	d0 cd b4 fd 	movl 0xfffffdb4(fp),0xfffffdc8(fp)
   12983:	cd c8 fd 
   12986:	31 41 ff    	brw 128ca <__vfprintf+0x1424>
   12989:	91 69 8f 4e 	cmpb (r9),$0x4e
   1298d:	13 28       	beql 129b7 <__vfprintf+0x1511>
   1298f:	d1 58 8f 60 	cmpl r8,$0x00000060
   12993:	00 00 00 
   12996:	15 16       	bleq 129ae <__vfprintf+0x1508>
   12998:	9e ef 29 82 	movab 2abc7 <xdigs_upper.3+0x4a>,r9
   1299c:	01 00 59 
   1299f:	d0 03 57    	movl $0x3,r7
   129a2:	ca 8f 80 00 	bicl2 $0x00000080,0xfffffdd4(fp)
   129a6:	00 00 cd d4 
   129aa:	fd 
   129ab:	31 e2 f0    	brw 11a90 <__vfprintf+0x5ea>
   129ae:	9e ef 17 82 	movab 2abcb <xdigs_upper.3+0x4e>,r9
   129b2:	01 00 59 
   129b5:	11 e8       	brb 1299f <__vfprintf+0x14f9>
   129b7:	d1 58 8f 60 	cmpl r8,$0x00000060
   129bb:	00 00 00 
   129be:	15 09       	bleq 129c9 <__vfprintf+0x1523>
   129c0:	9e ef 09 82 	movab 2abcf <xdigs_upper.3+0x52>,r9
   129c4:	01 00 59 
   129c7:	11 d6       	brb 1299f <__vfprintf+0x14f9>
   129c9:	9e ef 04 82 	movab 2abd3 <xdigs_upper.3+0x56>,r9
   129cd:	01 00 59 
   129d0:	11 cd       	brb 1299f <__vfprintf+0x14f9>
   129d2:	94 cd 03 fe 	clrb 0xfffffe03(fp)
   129d6:	31 b2 fe    	brw 1288b <__vfprintf+0x13e5>
   129d9:	c3 50 cd f4 	subl3 r0,0xfffffdf4(fp),0xfffffdc8(fp)
   129dd:	fd cd c8 fd 
   129e1:	31 99 fe    	brw 1287d <__vfprintf+0x13d7>
   129e4:	fb 00 ef dd 	calls $0x0,109c8 <___errno>
   129e8:	df ff ff 
   129eb:	d0 0c 60    	movl $0xc,(r0)
   129ee:	31 a8 f2    	brw 11c99 <__vfprintf+0x7f3>
   129f1:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   129f5:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   129f9:	50 
   129fa:	c1 50 08 cd 	addl3 r0,$0x8,0xfffffd94(fp)
   129fe:	94 fd 
   12a00:	70 60 50    	movd (r0),r0
   12a03:	31 3e fe    	brw 12844 <__vfprintf+0x139e>
   12a06:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r1
   12a0a:	51 
   12a0b:	13 35       	beql 12a42 <__vfprintf+0x159c>
   12a0d:	d0 cd a4 fd 	movl 0xfffffda4(fp),r0
   12a11:	50 
   12a12:	c1 50 01 cd 	addl3 r0,$0x1,0xfffffda4(fp)
   12a16:	a4 fd 
   12a18:	70 40 61 50 	movd (r1)[r0],r0
   12a1c:	70 50 cd e4 	movd r0,0xfffffde4(fp)
   12a20:	fd 
   12a21:	9f cd f4 fd 	pushab 0xfffffdf4(fp)
   12a25:	9f cd f0 fd 	pushab 0xfffffdf0(fp)
   12a29:	9f cd ec fd 	pushab 0xfffffdec(fp)
   12a2d:	dd cd c8 fd 	pushl 0xfffffdc8(fp)
   12a31:	dd cd a8 fd 	pushl 0xfffffda8(fp)
   12a35:	70 50 7e    	movd r0,-(sp)
   12a38:	fb 07 ef 67 	calls $0x7,13aa6 <__hdtoa>
   12a3c:	10 00 00 
   12a3f:	31 25 fe    	brw 12867 <__vfprintf+0x13c1>
   12a42:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12a46:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12a4a:	50 
   12a4b:	c1 50 08 cd 	addl3 r0,$0x8,0xfffffd94(fp)
   12a4f:	94 fd 
   12a51:	70 60 50    	movd (r0),r0
   12a54:	11 c6       	brb 12a1c <__vfprintf+0x1576>
   12a56:	90 8f 78 cd 	movb $0x78,0xfffffe03(fp)
   12a5a:	03 fe 
   12a5c:	9e ef 0b 81 	movab 2ab6d <xdigs_lower.2>,0xfffffda8(fp)
   12a60:	01 00 cd a8 
   12a64:	fd 
   12a65:	90 8f 70 cd 	movb $0x70,0xfffffdc3(fp)
   12a69:	c3 fd 
   12a6b:	31 96 fd    	brw 12804 <__vfprintf+0x135e>
   12a6e:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   12a72:	50 
   12a73:	e0 04 50 42 	bbs $0x4,r0,12ab9 <__vfprintf+0x1613>
   12a77:	9e cd 54 fe 	movab 0xfffffe54(fp),r9
   12a7b:	59 
   12a7c:	d0 59 51    	movl r9,r1
   12a7f:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12a83:	50 
   12a84:	13 1f       	beql 12aa5 <__vfprintf+0x15ff>
   12a86:	d0 cd a4 fd 	movl 0xfffffda4(fp),r2
   12a8a:	52 
   12a8b:	7e 42 60 50 	movaq (r0)[r2],r0
   12a8f:	90 60 50    	movb (r0),r0
   12a92:	c1 52 01 cd 	addl3 r2,$0x1,0xfffffda4(fp)
   12a96:	a4 fd 
   12a98:	90 50 61    	movb r0,(r1)
   12a9b:	d0 01 57    	movl $0x1,r7
   12a9e:	94 cd db fd 	clrb 0xfffffddb(fp)
   12aa2:	31 eb ef    	brw 11a90 <__vfprintf+0x5ea>
   12aa5:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12aa9:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12aad:	50 
   12aae:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12ab2:	94 fd 
   12ab4:	90 60 50    	movb (r0),r0
   12ab7:	11 df       	brb 12a98 <__vfprintf+0x15f2>
   12ab9:	9e cd 78 ff 	movab 0xffffff78(fp),r6
   12abd:	56 
   12abe:	9a 8f 80 7e 	movzbl $0x80,-(sp)
   12ac2:	d4 7e       	clrf -(sp)
   12ac4:	dd 56       	pushl r6
   12ac6:	fb 03 ef 2b 	calls $0x3,168f8 <memset>
   12aca:	3e 00 00 
   12acd:	dd 56       	pushl r6
   12acf:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12ad3:	50 
   12ad4:	13 4c       	beql 12b22 <__vfprintf+0x167c>
   12ad6:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12ada:	51 
   12adb:	7e 41 60 50 	movaq (r0)[r1],r0
   12adf:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   12ae3:	a4 fd 
   12ae5:	d0 60 50    	movl (r0),r0
   12ae8:	dd 50       	pushl r0
   12aea:	9e cd 54 fe 	movab 0xfffffe54(fp),r6
   12aee:	56 
   12aef:	dd 56       	pushl r6
   12af1:	fb 03 ef 56 	calls $0x3,15f4e <wcrtomb>
   12af5:	34 00 00 
   12af8:	d1 50 8f ff 	cmpl r0,$0xffffffff
   12afc:	ff ff ff 
   12aff:	13 08       	beql 12b09 <__vfprintf+0x1663>
   12b01:	d0 56 59    	movl r6,r9
   12b04:	d0 50 57    	movl r0,r7
   12b07:	11 95       	brb 12a9e <__vfprintf+0x15f8>
   12b09:	d0 cd 98 fd 	movl 0xfffffd98(fp),r2
   12b0d:	52 
   12b0e:	a8 8f 40 00 	bisw2 $0x0040,0xc(r2)
   12b12:	a2 0c 
   12b14:	fb 00 ef ad 	calls $0x0,109c8 <___errno>
   12b18:	de ff ff 
   12b1b:	9a 8f 54 60 	movzbl $0x54,(r0)
   12b1f:	31 77 f1    	brw 11c99 <__vfprintf+0x7f3>
   12b22:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12b26:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12b2a:	50 
   12b2b:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12b2f:	94 fd 
   12b31:	11 b2       	brb 12ae5 <__vfprintf+0x163f>
   12b33:	90 58 cd c3 	movb r8,0xfffffdc3(fp)
   12b37:	fd 
   12b38:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   12b3c:	18 03       	bgeq 12b41 <__vfprintf+0x169b>
   12b3e:	31 1b 01    	brw 12c5c <__vfprintf+0x17b6>
   12b41:	d6 cd c8 fd 	incl 0xfffffdc8(fp)
   12b45:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   12b49:	18 03       	bgeq 12b4e <__vfprintf+0x16a8>
   12b4b:	31 06 01    	brw 12c54 <__vfprintf+0x17ae>
   12b4e:	d5 cd b0 fd 	tstl 0xfffffdb0(fp)
   12b52:	13 0b       	beql 12b5f <__vfprintf+0x16b9>
   12b54:	dd cd b0 fd 	pushl 0xfffffdb0(fp)
   12b58:	fb 01 ef 69 	calls $0x1,146c8 <__freedtoa>
   12b5c:	1b 00 00 
   12b5f:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r1
   12b63:	51 
   12b64:	e1 03 51 6a 	bbc $0x3,r1,12bd2 <__vfprintf+0x172c>
   12b68:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r1
   12b6c:	51 
   12b6d:	13 4f       	beql 12bbe <__vfprintf+0x1718>
   12b6f:	d0 cd a4 fd 	movl 0xfffffda4(fp),r0
   12b73:	50 
   12b74:	c1 50 01 cd 	addl3 r0,$0x1,0xfffffda4(fp)
   12b78:	a4 fd 
   12b7a:	70 40 61 50 	movd (r1)[r0],r0
   12b7e:	70 50 cd e4 	movd r0,0xfffffde4(fp)
   12b82:	fd 
   12b83:	9f cd f4 fd 	pushab 0xfffffdf4(fp)
   12b87:	9f cd f0 fd 	pushab 0xfffffdf0(fp)
   12b8b:	9f cd ec fd 	pushab 0xfffffdec(fp)
   12b8f:	dd cd c8 fd 	pushl 0xfffffdc8(fp)
   12b93:	95 cd c3 fd 	tstb 0xfffffdc3(fp)
   12b97:	13 20       	beql 12bb9 <__vfprintf+0x1713>
   12b99:	d0 02 50    	movl $0x2,r0
   12b9c:	dd 50       	pushl r0
   12b9e:	9f cd e4 fd 	pushab 0xfffffde4(fp)
   12ba2:	fb 06 ef a7 	calls $0x6,13c50 <__ldtoa>
   12ba6:	10 00 00 
   12ba9:	d0 50 cd b0 	movl r0,0xfffffdb0(fp)
   12bad:	fd 
   12bae:	d0 50 59    	movl r0,r9
   12bb1:	13 03       	beql 12bb6 <__vfprintf+0x1710>
   12bb3:	31 d5 fc    	brw 1288b <__vfprintf+0x13e5>
   12bb6:	31 2b fe    	brw 129e4 <__vfprintf+0x153e>
   12bb9:	d0 03 50    	movl $0x3,r0
   12bbc:	11 de       	brb 12b9c <__vfprintf+0x16f6>
   12bbe:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12bc2:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12bc6:	50 
   12bc7:	c1 50 08 cd 	addl3 r0,$0x8,0xfffffd94(fp)
   12bcb:	94 fd 
   12bcd:	70 60 50    	movd (r0),r0
   12bd0:	11 ac       	brb 12b7e <__vfprintf+0x16d8>
   12bd2:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r1
   12bd6:	51 
   12bd7:	13 67       	beql 12c40 <__vfprintf+0x179a>
   12bd9:	d0 cd a4 fd 	movl 0xfffffda4(fp),r0
   12bdd:	50 
   12bde:	c1 50 01 cd 	addl3 r0,$0x1,0xfffffda4(fp)
   12be2:	a4 fd 
   12be4:	70 40 61 50 	movd (r1)[r0],r0
   12be8:	70 50 cd e4 	movd r0,0xfffffde4(fp)
   12bec:	fd 
   12bed:	9f cd f4 fd 	pushab 0xfffffdf4(fp)
   12bf1:	9f cd f0 fd 	pushab 0xfffffdf0(fp)
   12bf5:	9f cd ec fd 	pushab 0xfffffdec(fp)
   12bf9:	dd cd c8 fd 	pushl 0xfffffdc8(fp)
   12bfd:	95 cd c3 fd 	tstb 0xfffffdc3(fp)
   12c01:	13 38       	beql 12c3b <__vfprintf+0x1795>
   12c03:	d0 02 50    	movl $0x2,r0
   12c06:	dd 50       	pushl r0
   12c08:	70 cd e4 fd 	movd 0xfffffde4(fp),-(sp)
   12c0c:	7e 
   12c0d:	fb 07 ef 72 	calls $0x7,13c86 <__dtoa>
   12c11:	10 00 00 
   12c14:	d0 50 cd b0 	movl r0,0xfffffdb0(fp)
   12c18:	fd 
   12c19:	d0 50 59    	movl r0,r9
   12c1c:	12 03       	bneq 12c21 <__vfprintf+0x177b>
   12c1e:	31 c3 fd    	brw 129e4 <__vfprintf+0x153e>
   12c21:	d1 cd ec fd 	cmpl 0xfffffdec(fp),$0x0000270f
   12c25:	8f 0f 27 00 
   12c29:	00 
   12c2a:	13 03       	beql 12c2f <__vfprintf+0x1789>
   12c2c:	31 5c fc    	brw 1288b <__vfprintf+0x13e5>
   12c2f:	d0 8f ff ff 	movl $0x7fffffff,0xfffffdec(fp)
   12c33:	ff 7f cd ec 
   12c37:	fd 
   12c38:	31 50 fc    	brw 1288b <__vfprintf+0x13e5>
   12c3b:	d0 03 50    	movl $0x3,r0
   12c3e:	11 c6       	brb 12c06 <__vfprintf+0x1760>
   12c40:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12c44:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12c48:	50 
   12c49:	c1 50 08 cd 	addl3 r0,$0x8,0xfffffd94(fp)
   12c4d:	94 fd 
   12c4f:	70 60 50    	movd (r0),r0
   12c52:	11 94       	brb 12be8 <__vfprintf+0x1742>
   12c54:	d0 06 cd c8 	movl $0x6,0xfffffdc8(fp)
   12c58:	fd 
   12c59:	31 f2 fe    	brw 12b4e <__vfprintf+0x16a8>
   12c5c:	d0 07 cd c8 	movl $0x7,0xfffffdc8(fp)
   12c60:	fd 
   12c61:	31 e1 fe    	brw 12b45 <__vfprintf+0x169f>
   12c64:	94 cd c3 fd 	clrb 0xfffffdc3(fp)
   12c68:	31 da fe    	brw 12b45 <__vfprintf+0x169f>
   12c6b:	83 02 58 cd 	subb3 $0x2,r8,0xfffffdc3(fp)
   12c6f:	c3 fd 
   12c71:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   12c75:	13 03       	beql 12c7a <__vfprintf+0x17d4>
   12c77:	31 cb fe    	brw 12b45 <__vfprintf+0x169f>
   12c7a:	d0 01 cd c8 	movl $0x1,0xfffffdc8(fp)
   12c7e:	fd 
   12c7f:	31 c3 fe    	brw 12b45 <__vfprintf+0x169f>
   12c82:	91 6b 8f 68 	cmpb (r11),$0x68
   12c86:	13 0c       	beql 12c94 <__vfprintf+0x17ee>
   12c88:	c8 8f 40 00 	bisl2 $0x00000040,0xfffffdd4(fp)
   12c8c:	00 00 cd d4 
   12c90:	fd 
   12c91:	31 5c e9    	brw 115f0 <__vfprintf+0x14a>
   12c94:	d6 5b       	incl r11
   12c96:	c8 8f 00 08 	bisl2 $0x00000800,0xfffffdd4(fp)
   12c9a:	00 00 cd d4 
   12c9e:	fd 
   12c9f:	31 4e e9    	brw 115f0 <__vfprintf+0x14a>
   12ca2:	c8 8f 00 10 	bisl2 $0x00001000,0xfffffdd4(fp)
   12ca6:	00 00 cd d4 
   12caa:	fd 
   12cab:	31 42 e9    	brw 115f0 <__vfprintf+0x14a>
   12cae:	91 6b 8f 6c 	cmpb (r11),$0x6c
   12cb2:	13 08       	beql 12cbc <__vfprintf+0x1816>
   12cb4:	c8 10 cd d4 	bisl2 $0x10,0xfffffdd4(fp)
   12cb8:	fd 
   12cb9:	31 34 e9    	brw 115f0 <__vfprintf+0x14a>
   12cbc:	d6 5b       	incl r11
   12cbe:	c8 20 cd d4 	bisl2 $0x20,0xfffffdd4(fp)
   12cc2:	fd 
   12cc3:	31 2a e9    	brw 115f0 <__vfprintf+0x14a>
   12cc6:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r1
   12cca:	51 
   12ccb:	e1 05 51 3a 	bbc $0x5,r1,12d09 <__vfprintf+0x1863>
   12ccf:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12cd3:	50 
   12cd4:	13 22       	beql 12cf8 <__vfprintf+0x1852>
   12cd6:	d0 cd a4 fd 	movl 0xfffffda4(fp),r2
   12cda:	52 
   12cdb:	7e 42 60 50 	movaq (r0)[r2],r0
   12cdf:	c1 52 01 cd 	addl3 r2,$0x1,0xfffffda4(fp)
   12ce3:	a4 fd 
   12ce5:	d0 60 52    	movl (r0),r2
   12ce8:	d0 cd d0 fd 	movl 0xfffffdd0(fp),r0
   12cec:	50 
   12ced:	78 8f e1 50 	ashl $0xe1,r0,r1
   12cf1:	51 
   12cf2:	7d 50 62    	movq r0,(r2)
   12cf5:	31 69 e8    	brw 11561 <__vfprintf+0xbb>
   12cf8:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12cfc:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12d00:	50 
   12d01:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12d05:	94 fd 
   12d07:	11 dc       	brb 12ce5 <__vfprintf+0x183f>
   12d09:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r0
   12d0d:	50 
   12d0e:	e1 04 50 03 	bbc $0x4,r0,12d15 <__vfprintf+0x186f>
   12d12:	31 88 00    	brw 12d9d <__vfprintf+0x18f7>
   12d15:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12d19:	52 
   12d1a:	e1 06 52 32 	bbc $0x6,r2,12d50 <__vfprintf+0x18aa>
   12d1e:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12d22:	50 
   12d23:	13 1a       	beql 12d3f <__vfprintf+0x1899>
   12d25:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12d29:	51 
   12d2a:	7e 41 60 50 	movaq (r0)[r1],r0
   12d2e:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   12d32:	a4 fd 
   12d34:	d0 60 50    	movl (r0),r0
   12d37:	b0 cd d0 fd 	movw 0xfffffdd0(fp),(r0)
   12d3b:	60 
   12d3c:	31 22 e8    	brw 11561 <__vfprintf+0xbb>
   12d3f:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12d43:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12d47:	50 
   12d48:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12d4c:	94 fd 
   12d4e:	11 e4       	brb 12d34 <__vfprintf+0x188e>
   12d50:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12d54:	52 
   12d55:	e1 0b 52 32 	bbc $0xb,r2,12d8b <__vfprintf+0x18e5>
   12d59:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12d5d:	50 
   12d5e:	13 1a       	beql 12d7a <__vfprintf+0x18d4>
   12d60:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12d64:	51 
   12d65:	7e 41 60 50 	movaq (r0)[r1],r0
   12d69:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   12d6d:	a4 fd 
   12d6f:	d0 60 50    	movl (r0),r0
   12d72:	90 cd d0 fd 	movb 0xfffffdd0(fp),(r0)
   12d76:	60 
   12d77:	31 e7 e7    	brw 11561 <__vfprintf+0xbb>
   12d7a:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12d7e:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12d82:	50 
   12d83:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12d87:	94 fd 
   12d89:	11 e4       	brb 12d6f <__vfprintf+0x18c9>
   12d8b:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12d8f:	52 
   12d90:	e0 09 52 09 	bbs $0x9,r2,12d9d <__vfprintf+0x18f7>
   12d94:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12d98:	52 
   12d99:	e1 0a 52 32 	bbc $0xa,r2,12dcf <__vfprintf+0x1929>
   12d9d:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12da1:	50 
   12da2:	13 1a       	beql 12dbe <__vfprintf+0x1918>
   12da4:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12da8:	51 
   12da9:	7e 41 60 50 	movaq (r0)[r1],r0
   12dad:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   12db1:	a4 fd 
   12db3:	d0 60 50    	movl (r0),r0
   12db6:	d0 cd d0 fd 	movl 0xfffffdd0(fp),(r0)
   12dba:	60 
   12dbb:	31 a3 e7    	brw 11561 <__vfprintf+0xbb>
   12dbe:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12dc2:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12dc6:	50 
   12dc7:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12dcb:	94 fd 
   12dcd:	11 e4       	brb 12db3 <__vfprintf+0x190d>
   12dcf:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12dd3:	52 
   12dd4:	e1 0c 52 1c 	bbc $0xc,r2,12df4 <__vfprintf+0x194e>
   12dd8:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12ddc:	50 
   12ddd:	12 03       	bneq 12de2 <__vfprintf+0x193c>
   12ddf:	31 16 ff    	brw 12cf8 <__vfprintf+0x1852>
   12de2:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12de6:	51 
   12de7:	7e 41 60 50 	movaq (r0)[r1],r0
   12deb:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   12def:	a4 fd 
   12df1:	31 f1 fe    	brw 12ce5 <__vfprintf+0x183f>
   12df4:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12df8:	50 
   12df9:	13 c3       	beql 12dbe <__vfprintf+0x1918>
   12dfb:	d0 cd a4 fd 	movl 0xfffffda4(fp),r2
   12dff:	52 
   12e00:	7e 42 60 50 	movaq (r0)[r2],r0
   12e04:	c1 52 01 cd 	addl3 r2,$0x1,0xfffffda4(fp)
   12e08:	a4 fd 
   12e0a:	11 a7       	brb 12db3 <__vfprintf+0x190d>
   12e0c:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12e10:	50 
   12e11:	13 29       	beql 12e3c <__vfprintf+0x1996>
   12e13:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12e17:	51 
   12e18:	7e 41 60 50 	movaq (r0)[r1],r0
   12e1c:	d0 60 56    	movl (r0),r6
   12e1f:	d4 57       	clrf r7
   12e21:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   12e25:	a4 fd 
   12e27:	d0 02 51    	movl $0x2,r1
   12e2a:	9e ef 3d 7d 	movab 2ab6d <xdigs_lower.2>,0xfffffda8(fp)
   12e2e:	01 00 cd a8 
   12e32:	fd 
   12e33:	90 8f 78 cd 	movb $0x78,0xfffffe03(fp)
   12e37:	03 fe 
   12e39:	31 67 f6    	brw 124a3 <__vfprintf+0xffd>
   12e3c:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12e40:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12e44:	50 
   12e45:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12e49:	94 fd 
   12e4b:	d0 60 56    	movl (r0),r6
   12e4e:	d4 57       	clrf r7
   12e50:	11 d5       	brb 12e27 <__vfprintf+0x1981>
   12e52:	d0 cd d4 fd 	movl 0xfffffdd4(fp),r2
   12e56:	52 
   12e57:	e0 04 52 03 	bbs $0x4,r2,12e5e <__vfprintf+0x19b8>
   12e5b:	31 a7 00    	brw 12f05 <__vfprintf+0x1a5f>
   12e5e:	d5 cd 9c fd 	tstl 0xfffffd9c(fp)
   12e62:	13 0f       	beql 12e73 <__vfprintf+0x19cd>
   12e64:	dd cd 9c fd 	pushl 0xfffffd9c(fp)
   12e68:	fb 01 ef 59 	calls $0x1,188c8 <free>
   12e6c:	5a 00 00 
   12e6f:	d4 cd 9c fd 	clrf 0xfffffd9c(fp)
   12e73:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12e77:	50 
   12e78:	13 7a       	beql 12ef4 <__vfprintf+0x1a4e>
   12e7a:	d0 cd a4 fd 	movl 0xfffffda4(fp),r1
   12e7e:	51 
   12e7f:	7e 41 60 50 	movaq (r0)[r1],r0
   12e83:	c1 51 01 cd 	addl3 r1,$0x1,0xfffffda4(fp)
   12e87:	a4 fd 
   12e89:	d0 60 50    	movl (r0),r0
   12e8c:	13 5d       	beql 12eeb <__vfprintf+0x1a45>
   12e8e:	dd cd c8 fd 	pushl 0xfffffdc8(fp)
   12e92:	dd 50       	pushl r0
   12e94:	fb 02 cf 8d 	calls $0x2,11326 <__wcsconv>
   12e98:	e4 
   12e99:	d0 50 cd 9c 	movl r0,0xfffffd9c(fp)
   12e9d:	fd 
   12e9e:	13 3e       	beql 12ede <__vfprintf+0x1a38>
   12ea0:	d0 50 59    	movl r0,r9
   12ea3:	d5 cd c8 fd 	tstl 0xfffffdc8(fp)
   12ea7:	19 22       	blss 12ecb <__vfprintf+0x1a25>
   12ea9:	dd cd c8 fd 	pushl 0xfffffdc8(fp)
   12ead:	d4 7e       	clrf -(sp)
   12eaf:	dd 59       	pushl r9
   12eb1:	fb 03 ef 8e 	calls $0x3,15846 <memchr>
   12eb5:	29 00 00 
   12eb8:	d5 50       	tstl r0
   12eba:	13 07       	beql 12ec3 <__vfprintf+0x1a1d>
   12ebc:	c3 59 50 57 	subl3 r9,r0,r7
   12ec0:	31 db fb    	brw 12a9e <__vfprintf+0x15f8>
   12ec3:	d0 cd c8 fd 	movl 0xfffffdc8(fp),r7
   12ec7:	57 
   12ec8:	31 d3 fb    	brw 12a9e <__vfprintf+0x15f8>
   12ecb:	dd 59       	pushl r9
   12ecd:	fb 01 ef 4e 	calls $0x1,16922 <strlen>
   12ed1:	3a 00 00 
   12ed4:	d5 50       	tstl r0
   12ed6:	19 03       	blss 12edb <__vfprintf+0x1a35>
   12ed8:	31 29 fc    	brw 12b04 <__vfprintf+0x165e>
   12edb:	31 89 e8    	brw 11767 <__vfprintf+0x2c1>
   12ede:	d0 cd 98 fd 	movl 0xfffffd98(fp),r0
   12ee2:	50 
   12ee3:	9b 8f 40 a0 	movzbw $0x40,0xc(r0)
   12ee7:	0c 
   12ee8:	31 ae ed    	brw 11c99 <__vfprintf+0x7f3>
   12eeb:	9e ef e6 7c 	movab 2abd7 <xdigs_upper.3+0x5a>,r9
   12eef:	01 00 59 
   12ef2:	11 af       	brb 12ea3 <__vfprintf+0x19fd>
   12ef4:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12ef8:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12efc:	50 
   12efd:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12f01:	94 fd 
   12f03:	11 84       	brb 12e89 <__vfprintf+0x19e3>
   12f05:	d0 cd f8 fd 	movl 0xfffffdf8(fp),r0
   12f09:	50 
   12f0a:	13 16       	beql 12f22 <__vfprintf+0x1a7c>
   12f0c:	d0 cd a4 fd 	movl 0xfffffda4(fp),r2
   12f10:	52 
   12f11:	7e 42 60 50 	movaq (r0)[r2],r0
   12f15:	c1 52 01 cd 	addl3 r2,$0x1,0xfffffda4(fp)
   12f19:	a4 fd 
   12f1b:	d0 60 59    	movl (r0),r9
   12f1e:	12 83       	bneq 12ea3 <__vfprintf+0x19fd>
   12f20:	11 c9       	brb 12eeb <__vfprintf+0x1a45>
   12f22:	d6 cd a4 fd 	incl 0xfffffda4(fp)
   12f26:	d0 cd 94 fd 	movl 0xfffffd94(fp),r0
   12f2a:	50 
   12f2b:	c1 50 04 cd 	addl3 r0,$0x4,0xfffffd94(fp)
   12f2f:	94 fd 
   12f31:	11 e8       	brb 12f1b <__vfprintf+0x1a75>
   12f33:	c8 8f 00 02 	bisl2 $0x00000200,0xfffffdd4(fp)
   12f37:	00 00 cd d4 
   12f3b:	fd 
   12f3c:	31 b1 e6    	brw 115f0 <__vfprintf+0x14a>
   12f3f:	9e ef 28 7c 	movab 2ab6d <xdigs_lower.2>,0xfffffda8(fp)
   12f43:	01 00 cd a8 
   12f47:	fd 
   12f48:	31 69 f7    	brw 126b4 <__vfprintf+0x120e>
   12f4b:	d5 58       	tstl r8
   12f4d:	13 0b       	beql 12f5a <__vfprintf+0x1ab4>
   12f4f:	9e cd 54 fe 	movab 0xfffffe54(fp),r9
   12f53:	59 
   12f54:	90 58 69    	movb r8,(r9)
   12f57:	31 41 fb    	brw 12a9b <__vfprintf+0x15f5>
   12f5a:	d5 cd 10 fe 	tstl 0xfffffe10(fp)
   12f5e:	12 07       	bneq 12f67 <__vfprintf+0x1ac1>
   12f60:	d4 cd 0c fe 	clrf 0xfffffe0c(fp)
   12f64:	31 32 ed    	brw 11c99 <__vfprintf+0x7f3>
   12f67:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   12f6b:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12f6f:	fb 02 cf d0 	calls $0x2,11244 <__sprint>
   12f73:	e2 
   12f74:	d5 50       	tstl r0
   12f76:	13 e8       	beql 12f60 <__vfprintf+0x1aba>
   12f78:	31 1e ed    	brw 11c99 <__vfprintf+0x7f3>
   12f7b:	c8 8f 00 04 	bisl2 $0x00000400,0xfffffdd4(fp)
   12f7f:	00 00 cd d4 
   12f83:	fd 
   12f84:	31 69 e6    	brw 115f0 <__vfprintf+0x14a>
   12f87:	9f cd 08 fe 	pushab 0xfffffe08(fp)
   12f8b:	dd cd 98 fd 	pushl 0xfffffd98(fp)
   12f8f:	fb 02 cf b0 	calls $0x2,11244 <__sprint>
   12f93:	e2 
   12f94:	d5 50       	tstl r0
   12f96:	13 03       	beql 12f9b <__vfprintf+0x1af5>
   12f98:	31 fe ec    	brw 11c99 <__vfprintf+0x7f3>
   12f9b:	9e cd b8 fe 	movab 0xfffffeb8(fp),r10
   12f9f:	5a 
   12fa0:	31 26 e6    	brw 115c9 <__vfprintf+0x123>
   12fa3:	b5 a1 0e    	tstw 0xe(r1)
   12fa6:	18 03       	bgeq 12fab <__vfprintf+0x1b05>
   12fa8:	31 77 e5    	brw 11522 <__vfprintf+0x7c>
   12fab:	dd cd 94 fd 	pushl 0xfffffd94(fp)
   12faf:	dd ac 08    	pushl 0x8(ap)
   12fb2:	dd 51       	pushl r1
   12fb4:	fb 03 cf b3 	calls $0x3,1126c <__sbprintf>
   12fb8:	e2 
   12fb9:	31 03 e8    	brw 117bf <__vfprintf+0x319>
   12fbc:	fb 00 ef 05 	calls $0x0,109c8 <___errno>
   12fc0:	da ff ff 
   12fc3:	d0 09 60    	movl $0x9,(r0)
   12fc6:	d2 00 50    	mcoml $0x0,r0
   12fc9:	31 f3 e7    	brw 117bf <__vfprintf+0x319>
   12fcc:	d4 50       	clrf r0
   12fce:	31 09 e5    	brw 114da <__vfprintf+0x34>
   12fd1:	fb 00 ef d0 	calls $0x0,167a8 <abort>
   12fd5:	37 00 00 

00012fd8 <__find_arguments>:
   12fd8:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   12fda:	9e ce 58 ff 	movab 0xffffff58(sp),sp
   12fde:	5e 
   12fdf:	d0 ef b3 8f 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   12fe3:	02 00 ad f8 
   12fe7:	d0 ac 08 5b 	movl 0x8(ap),r11
   12feb:	d0 ac 0c cd 	movl 0xc(ap),0xffffff5c(fp)
   12fef:	5c ff 
   12ff1:	d0 ac 10 cd 	movl 0x10(ap),0xffffff58(fp)
   12ff5:	58 ff 
   12ff7:	d4 cd 60 ff 	clrf 0xffffff60(fp)
   12ffb:	d0 ac 04 56 	movl 0x4(ap),r6
   12fff:	9e cd 70 ff 	movab 0xffffff70(fp),r0
   13003:	50 
   13004:	d0 50 cd 64 	movl r0,0xffffff64(fp)
   13008:	ff 
   13009:	d0 08 cd 68 	movl $0x8,0xffffff68(fp)
   1300d:	ff 
   1300e:	d4 5a       	clrf r10
   13010:	d0 01 59    	movl $0x1,r9
   13013:	7c 60       	clrd (r0)
   13015:	9a 8f 80 7e 	movzbl $0x80,-(sp)
   13019:	d4 7e       	clrf -(sp)
   1301b:	9f cd 78 ff 	pushab 0xffffff78(fp)
   1301f:	fb 03 ef d2 	calls $0x3,168f8 <memset>
   13023:	38 00 00 
   13026:	9f cd 78 ff 	pushab 0xffffff78(fp)
   1302a:	dd ef fc 90 	pushl 5c12c <__mb_cur_max>
   1302e:	04 00 
   13030:	dd 56       	pushl r6
   13032:	9f cd 6c ff 	pushab 0xffffff6c(fp)
   13036:	fb 04 ef 81 	calls $0x4,15ebe <mbrtowc>
   1303a:	2e 00 00 
   1303d:	d0 50 52    	movl r0,r2
   13040:	15 0c       	bleq 1304e <__find_arguments+0x76>
   13042:	c0 52 56    	addl2 r2,r6
   13045:	d1 cd 6c ff 	cmpl 0xffffff6c(fp),$0x25
   13049:	25 
   1304a:	12 da       	bneq 13026 <__find_arguments+0x4e>
   1304c:	d7 56       	decl r6
   1304e:	d5 52       	tstl r2
   13050:	14 03       	bgtr 13055 <__find_arguments+0x7d>
   13052:	31 79 07    	brw 137ce <__find_arguments+0x7f6>
   13055:	d6 56       	incl r6
   13057:	d4 58       	clrf r8
   13059:	98 86 51    	cvtbl (r6)+,r1
   1305c:	c3 20 51 50 	subl3 $0x20,r1,r0
   13060:	d1 50 8f 5a 	cmpl r0,$0x0000005a
   13064:	00 00 00 
   13067:	1b 03       	blequ 1306c <__find_arguments+0x94>
   13069:	31 5b 07    	brw 137c7 <__find_arguments+0x7ef>
   1306c:	cf 50 00 8f 	casel r0,$0x0,$0x0000005a
   13070:	5a 00 00 00 
   13074:	e5 ff 53 07 	bbcc *75437cd <_end+0x74e1369>,0x530753ff(r5),13087 <__find_arguments+0xaf>
   13078:	53 07 e5 ff 
   1307c:	53 07 53 07 
   13080:	53 07       	tstf $0x7 [f-float]
   13082:	e5 ff 53 07 	bbcc *75437db <_end+0x74e1377>,*0x0(r6),13070 <__find_arguments+0x98>
   13086:	53 07 b6 00 
   1308a:	e5 
   1308b:	ff 53       	.word 0xff53
   1308d:	07          	svpctx
   1308e:	e5 ff b0 01 	bbcc *7543244 <_end+0x74e0de0>,0x1d021dff(r5),1309c <__find_arguments+0xc4>
   13092:	53 07 e5 ff 
   13096:	1d 02 1d 02 
   1309a:	1d 02       	bvs 1309e <__find_arguments+0xc6>
   1309c:	1d 02       	bvs 130a0 <__find_arguments+0xc8>
   1309e:	1d 02       	bvs 130a2 <__find_arguments+0xca>
   130a0:	1d 02       	bvs 130a4 <__find_arguments+0xcc>
   130a2:	1d 02       	bvs 130a6 <__find_arguments+0xce>
   130a4:	1d 02       	bvs 130a8 <__find_arguments+0xd0>
   130a6:	1d 02       	bvs 130aa <__find_arguments+0xd2>
   130a8:	53 07       	tstf $0x7 [f-float]
   130aa:	53 07       	tstf $0x7 [f-float]
   130ac:	53 07       	tstf $0x7 [f-float]
   130ae:	53 07       	tstf $0x7 [f-float]
   130b0:	53 07       	tstf $0x7 [f-float]
   130b2:	53 07       	tstf $0x7 [f-float]
   130b4:	53 07       	tstf $0x7 [f-float]
   130b6:	1b 05       	blequ 130bd <__find_arguments+0xe5>
   130b8:	53 07       	tstf $0x7 [f-float]
   130ba:	53 07       	tstf $0x7 [f-float]
   130bc:	5d 02 1b    	insqti $0x2,$0x1b
   130bf:	05          	rsb
   130c0:	1b 05       	blequ 130c7 <__find_arguments+0xef>
   130c2:	1b 05       	blequ 130c9 <__find_arguments+0xf1>
   130c4:	53 07       	tstf $0x7 [f-float]
   130c6:	53 07       	tstf $0x7 [f-float]
   130c8:	53 07       	tstf $0x7 [f-float]
   130ca:	53 07       	tstf $0x7 [f-float]
   130cc:	b7 03       	decw $0x3
   130ce:	53 07       	tstf $0x7 [f-float]
   130d0:	53 07       	tstf $0x7 [f-float]
   130d2:	bd 03       	chme $0x3
   130d4:	53 07       	tstf $0x7 [f-float]
   130d6:	53 07       	tstf $0x7 [f-float]
   130d8:	53 07       	tstf $0x7 [f-float]
   130da:	53 07       	tstf $0x7 [f-float]
   130dc:	53 07       	tstf $0x7 [f-float]
   130de:	bd 03       	chme $0x3
   130e0:	53 07       	tstf $0x7 [f-float]
   130e2:	53 07       	tstf $0x7 [f-float]
   130e4:	c0 03 53    	addl2 $0x3,r3
   130e7:	07          	svpctx
   130e8:	53 07       	tstf $0x7 [f-float]
   130ea:	53 07       	tstf $0x7 [f-float]
   130ec:	53 07       	tstf $0x7 [f-float]
   130ee:	53 07       	tstf $0x7 [f-float]
   130f0:	53 07       	tstf $0x7 [f-float]
   130f2:	53 07       	tstf $0x7 [f-float]
   130f4:	53 07       	tstf $0x7 [f-float]
   130f6:	1b 05       	blequ 130fd <__find_arguments+0x125>
   130f8:	53 07       	tstf $0x7 [f-float]
   130fa:	ed 04 60 02 	cmpzv $0x4,(r0),$0x2,$0x1b
   130fe:	1b 
   130ff:	05          	rsb
   13100:	1b 05       	blequ 13107 <__find_arguments+0x12f>
   13102:	1b 05       	blequ 13109 <__find_arguments+0x131>
   13104:	6d 05 60    	cvtwd $0x5,(r0)
   13107:	02          	rei
   13108:	89 05 53 07 	bisb3 $0x5,r3,$0x7
   1310c:	93 05 53    	bitb $0x5,r3
   1310f:	07          	svpctx
   13110:	a7 05 c0 03 	divw3 $0x5,0xffffd003(r0),$0x6
   13114:	d0 06 
   13116:	a1 05 53 07 	addw3 $0x5,r3,$0x7
   1311a:	f7 06 49 07 	cvtlw $0x6,$0x7[r9]
   1311e:	c0 03 53    	addl2 $0x3,r3
   13121:	07          	svpctx
   13122:	53 07       	tstf $0x7 [f-float]
   13124:	c0 03 53    	addl2 $0x3,r3
   13127:	07          	svpctx
   13128:	5a 08       	.word 0x5a08
   1312a:	d4 52       	clrf r2
   1312c:	d0 56 57    	movl r6,r7
   1312f:	98 66 50    	cvtbl (r6),r0
   13132:	c2 30 50    	subl2 $0x30,r0
   13135:	d1 50 09    	cmpl r0,$0x9
   13138:	1a 31       	bgtru 1316b <__find_arguments+0x193>
   1313a:	d1 52 8f cc 	cmpl r2,$0x0ccccccc
   1313e:	cc cc 0c 
   13141:	15 03       	bleq 13146 <__find_arguments+0x16e>
   13143:	31 87 00    	brw 131cd <__find_arguments+0x1f5>
   13146:	c4 0a 52    	mull2 $0xa,r2
   13149:	98 67 51    	cvtbl (r7),r1
   1314c:	c3 51 8f 2f 	subl3 r1,$0x8000002f,r0
   13150:	00 00 80 50 
   13154:	d1 52 50    	cmpl r2,r0
   13157:	14 74       	bgtr 131cd <__find_arguments+0x1f5>
   13159:	9e 42 a1 d0 	movab 0xffffffd0(r1)[r2],r2
   1315d:	52 
   1315e:	d6 57       	incl r7
   13160:	98 67 50    	cvtbl (r7),r0
   13163:	c2 30 50    	subl2 $0x30,r0
   13166:	d1 50 09    	cmpl r0,$0x9
   13169:	1b cf       	blequ 1313a <__find_arguments+0x162>
   1316b:	91 67 24    	cmpb (r7),$0x24
   1316e:	13 29       	beql 13199 <__find_arguments+0x1c1>
   13170:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13174:	ff 
   13175:	18 13       	bgeq 1318a <__find_arguments+0x1b2>
   13177:	d1 59 5a    	cmpl r9,r10
   1317a:	15 03       	bleq 1317f <__find_arguments+0x1a7>
   1317c:	d0 59 5a    	movl r9,r10
   1317f:	90 04 49 dd 	movb $0x4,*0xffffff64(fp)[r9]
   13183:	64 ff 
   13185:	d6 59       	incl r9
   13187:	31 cf fe    	brw 13059 <__find_arguments+0x81>
   1318a:	9f cd 68 ff 	pushab 0xffffff68(fp)
   1318e:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13192:	fb 02 cf 41 	calls $0x2,138d8 <__grow_type_table>
   13196:	07 
   13197:	11 de       	brb 13177 <__find_arguments+0x19f>
   13199:	d0 59 56    	movl r9,r6
   1319c:	d0 52 59    	movl r2,r9
   1319f:	d1 52 cd 68 	cmpl r2,0xffffff68(fp)
   131a3:	ff 
   131a4:	18 18       	bgeq 131be <__find_arguments+0x1e6>
   131a6:	d1 59 5a    	cmpl r9,r10
   131a9:	15 03       	bleq 131ae <__find_arguments+0x1d6>
   131ab:	d0 59 5a    	movl r9,r10
   131ae:	90 04 49 dd 	movb $0x4,*0xffffff64(fp)[r9]
   131b2:	64 ff 
   131b4:	d0 56 59    	movl r6,r9
   131b7:	c1 57 01 56 	addl3 r7,$0x1,r6
   131bb:	31 9b fe    	brw 13059 <__find_arguments+0x81>
   131be:	9f cd 68 ff 	pushab 0xffffff68(fp)
   131c2:	9f cd 64 ff 	pushab 0xffffff64(fp)
   131c6:	fb 02 cf 0d 	calls $0x2,138d8 <__grow_type_table>
   131ca:	07 
   131cb:	11 d9       	brb 131a6 <__find_arguments+0x1ce>
   131cd:	fb 00 ef f4 	calls $0x0,109c8 <___errno>
   131d1:	d7 ff ff 
   131d4:	d0 0c 60    	movl $0xc,(r0)
   131d7:	d2 00 cd 60 	mcoml $0x0,0xffffff60(fp)
   131db:	ff 
   131dc:	d0 cd 64 ff 	movl 0xffffff64(fp),r1
   131e0:	51 
   131e1:	13 1e       	beql 13201 <__find_arguments+0x229>
   131e3:	9e cd 70 ff 	movab 0xffffff70(fp),r0
   131e7:	50 
   131e8:	d1 51 50    	cmpl r1,r0
   131eb:	13 14       	beql 13201 <__find_arguments+0x229>
   131ed:	d0 cd 58 ff 	movl 0xffffff58(fp),r0
   131f1:	50 
   131f2:	dd 60       	pushl (r0)
   131f4:	dd 51       	pushl r1
   131f6:	fb 02 ef cf 	calls $0x2,16acc <_thread_sys_munmap>
   131fa:	38 00 00 
   131fd:	d4 cd 64 ff 	clrf 0xffffff64(fp)
   13201:	d0 cd 60 ff 	movl 0xffffff60(fp),r0
   13205:	50 
   13206:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   1320a:	d1 51 ef 87 	cmpl r1,3bf98 <__guard_local>
   1320e:	8d 02 00 
   13211:	13 10       	beql 13223 <__find_arguments+0x24b>
   13213:	dd ad f8    	pushl 0xfffffff8(fp)
   13216:	9f ef c2 79 	pushab 2abde <xdigs_upper.3+0x61>
   1321a:	01 00 
   1321c:	fb 02 ef 49 	calls $0x2,1666c <__stack_smash_handler>
   13220:	34 00 00 
   13223:	04          	ret
   13224:	98 86 51    	cvtbl (r6)+,r1
   13227:	d1 51 2a    	cmpl r1,$0x2a
   1322a:	13 1b       	beql 13247 <__find_arguments+0x26f>
   1322c:	c3 30 51 50 	subl3 $0x30,r1,r0
   13230:	d1 50 09    	cmpl r0,$0x9
   13233:	1b 03       	blequ 13238 <__find_arguments+0x260>
   13235:	31 24 fe    	brw 1305c <__find_arguments+0x84>
   13238:	98 86 51    	cvtbl (r6)+,r1
   1323b:	c3 30 51 50 	subl3 $0x30,r1,r0
   1323f:	d1 50 09    	cmpl r0,$0x9
   13242:	1b f4       	blequ 13238 <__find_arguments+0x260>
   13244:	31 15 fe    	brw 1305c <__find_arguments+0x84>
   13247:	d4 52       	clrf r2
   13249:	d0 56 57    	movl r6,r7
   1324c:	98 66 50    	cvtbl (r6),r0
   1324f:	c2 30 50    	subl2 $0x30,r0
   13252:	d1 50 09    	cmpl r0,$0x9
   13255:	1b 03       	blequ 1325a <__find_arguments+0x282>
   13257:	31 11 ff    	brw 1316b <__find_arguments+0x193>
   1325a:	d1 52 8f cc 	cmpl r2,$0x0ccccccc
   1325e:	cc cc 0c 
   13261:	15 03       	bleq 13266 <__find_arguments+0x28e>
   13263:	31 67 ff    	brw 131cd <__find_arguments+0x1f5>
   13266:	c4 0a 52    	mull2 $0xa,r2
   13269:	98 67 51    	cvtbl (r7),r1
   1326c:	c3 51 8f 2f 	subl3 r1,$0x8000002f,r0
   13270:	00 00 80 50 
   13274:	d1 52 50    	cmpl r2,r0
   13277:	15 03       	bleq 1327c <__find_arguments+0x2a4>
   13279:	31 51 ff    	brw 131cd <__find_arguments+0x1f5>
   1327c:	9e 42 a1 d0 	movab 0xffffffd0(r1)[r2],r2
   13280:	52 
   13281:	d6 57       	incl r7
   13283:	98 67 50    	cvtbl (r7),r0
   13286:	c2 30 50    	subl2 $0x30,r0
   13289:	d1 50 09    	cmpl r0,$0x9
   1328c:	1b cc       	blequ 1325a <__find_arguments+0x282>
   1328e:	31 da fe    	brw 1316b <__find_arguments+0x193>
   13291:	d4 52       	clrf r2
   13293:	d1 52 8f cc 	cmpl r2,$0x0ccccccc
   13297:	cc cc 0c 
   1329a:	15 03       	bleq 1329f <__find_arguments+0x2c7>
   1329c:	31 2e ff    	brw 131cd <__find_arguments+0x1f5>
   1329f:	c4 0a 52    	mull2 $0xa,r2
   132a2:	c3 51 8f 2f 	subl3 r1,$0x8000002f,r0
   132a6:	00 00 80 50 
   132aa:	d1 52 50    	cmpl r2,r0
   132ad:	15 03       	bleq 132b2 <__find_arguments+0x2da>
   132af:	31 1b ff    	brw 131cd <__find_arguments+0x1f5>
   132b2:	9e 42 a1 d0 	movab 0xffffffd0(r1)[r2],r2
   132b6:	52 
   132b7:	98 86 51    	cvtbl (r6)+,r1
   132ba:	c3 30 51 50 	subl3 $0x30,r1,r0
   132be:	d1 50 09    	cmpl r0,$0x9
   132c1:	1b d0       	blequ 13293 <__find_arguments+0x2bb>
   132c3:	d1 51 24    	cmpl r1,$0x24
   132c6:	13 03       	beql 132cb <__find_arguments+0x2f3>
   132c8:	31 91 fd    	brw 1305c <__find_arguments+0x84>
   132cb:	d0 52 59    	movl r2,r9
   132ce:	31 88 fd    	brw 13059 <__find_arguments+0x81>
   132d1:	c8 10 58    	bisl2 $0x10,r8
   132d4:	e1 0c 58 29 	bbc $0xc,r8,13301 <__find_arguments+0x329>
   132d8:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   132dc:	ff 
   132dd:	18 13       	bgeq 132f2 <__find_arguments+0x31a>
   132df:	d1 59 5a    	cmpl r9,r10
   132e2:	15 03       	bleq 132e7 <__find_arguments+0x30f>
   132e4:	d0 59 5a    	movl r9,r10
   132e7:	90 16 49 dd 	movb $0x16,*0xffffff64(fp)[r9]
   132eb:	64 ff 
   132ed:	d6 59       	incl r9
   132ef:	31 34 fd    	brw 13026 <__find_arguments+0x4e>
   132f2:	9f cd 68 ff 	pushab 0xffffff68(fp)
   132f6:	9f cd 64 ff 	pushab 0xffffff64(fp)
   132fa:	fb 02 cf d9 	calls $0x2,138d8 <__grow_type_table>
   132fe:	05 
   132ff:	11 de       	brb 132df <__find_arguments+0x307>
   13301:	e1 09 58 03 	bbc $0x9,r8,13308 <__find_arguments+0x330>
   13305:	31 fc 00    	brw 13404 <__find_arguments+0x42c>
   13308:	e1 0a 58 26 	bbc $0xa,r8,13332 <__find_arguments+0x35a>
   1330c:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13310:	ff 
   13311:	18 10       	bgeq 13323 <__find_arguments+0x34b>
   13313:	d1 59 5a    	cmpl r9,r10
   13316:	15 03       	bleq 1331b <__find_arguments+0x343>
   13318:	d0 59 5a    	movl r9,r10
   1331b:	90 14 49 dd 	movb $0x14,*0xffffff64(fp)[r9]
   1331f:	64 ff 
   13321:	11 ca       	brb 132ed <__find_arguments+0x315>
   13323:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13327:	9f cd 64 ff 	pushab 0xffffff64(fp)
   1332b:	fb 02 cf a8 	calls $0x2,138d8 <__grow_type_table>
   1332f:	05 
   13330:	11 e1       	brb 13313 <__find_arguments+0x33b>
   13332:	e1 05 58 26 	bbc $0x5,r8,1335c <__find_arguments+0x384>
   13336:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   1333a:	ff 
   1333b:	18 10       	bgeq 1334d <__find_arguments+0x375>
   1333d:	d1 59 5a    	cmpl r9,r10
   13340:	15 03       	bleq 13345 <__find_arguments+0x36d>
   13342:	d0 59 5a    	movl r9,r10
   13345:	90 0a 49 dd 	movb $0xa,*0xffffff64(fp)[r9]
   13349:	64 ff 
   1334b:	11 a0       	brb 132ed <__find_arguments+0x315>
   1334d:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13351:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13355:	fb 02 cf 7e 	calls $0x2,138d8 <__grow_type_table>
   13359:	05 
   1335a:	11 e1       	brb 1333d <__find_arguments+0x365>
   1335c:	e1 04 58 27 	bbc $0x4,r8,13387 <__find_arguments+0x3af>
   13360:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13364:	ff 
   13365:	18 11       	bgeq 13378 <__find_arguments+0x3a0>
   13367:	d1 59 5a    	cmpl r9,r10
   1336a:	15 03       	bleq 1336f <__find_arguments+0x397>
   1336c:	d0 59 5a    	movl r9,r10
   1336f:	90 07 49 dd 	movb $0x7,*0xffffff64(fp)[r9]
   13373:	64 ff 
   13375:	31 75 ff    	brw 132ed <__find_arguments+0x315>
   13378:	9f cd 68 ff 	pushab 0xffffff68(fp)
   1337c:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13380:	fb 02 cf 53 	calls $0x2,138d8 <__grow_type_table>
   13384:	05 
   13385:	11 e0       	brb 13367 <__find_arguments+0x38f>
   13387:	e1 06 58 27 	bbc $0x6,r8,133b2 <__find_arguments+0x3da>
   1338b:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   1338f:	ff 
   13390:	18 11       	bgeq 133a3 <__find_arguments+0x3cb>
   13392:	d1 59 5a    	cmpl r9,r10
   13395:	15 03       	bleq 1339a <__find_arguments+0x3c2>
   13397:	d0 59 5a    	movl r9,r10
   1339a:	90 01 49 dd 	movb $0x1,*0xffffff64(fp)[r9]
   1339e:	64 ff 
   133a0:	31 4a ff    	brw 132ed <__find_arguments+0x315>
   133a3:	9f cd 68 ff 	pushab 0xffffff68(fp)
   133a7:	9f cd 64 ff 	pushab 0xffffff64(fp)
   133ab:	fb 02 cf 28 	calls $0x2,138d8 <__grow_type_table>
   133af:	05 
   133b0:	11 e0       	brb 13392 <__find_arguments+0x3ba>
   133b2:	e1 0b 58 27 	bbc $0xb,r8,133dd <__find_arguments+0x405>
   133b6:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   133ba:	ff 
   133bb:	18 11       	bgeq 133ce <__find_arguments+0x3f6>
   133bd:	d1 59 5a    	cmpl r9,r10
   133c0:	15 03       	bleq 133c5 <__find_arguments+0x3ed>
   133c2:	d0 59 5a    	movl r9,r10
   133c5:	90 19 49 dd 	movb $0x19,*0xffffff64(fp)[r9]
   133c9:	64 ff 
   133cb:	31 1f ff    	brw 132ed <__find_arguments+0x315>
   133ce:	9f cd 68 ff 	pushab 0xffffff68(fp)
   133d2:	9f cd 64 ff 	pushab 0xffffff64(fp)
   133d6:	fb 02 cf fd 	calls $0x2,138d8 <__grow_type_table>
   133da:	04 
   133db:	11 e0       	brb 133bd <__find_arguments+0x3e5>
   133dd:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   133e1:	ff 
   133e2:	18 11       	bgeq 133f5 <__find_arguments+0x41d>
   133e4:	d1 59 5a    	cmpl r9,r10
   133e7:	15 03       	bleq 133ec <__find_arguments+0x414>
   133e9:	d0 59 5a    	movl r9,r10
   133ec:	90 04 49 dd 	movb $0x4,*0xffffff64(fp)[r9]
   133f0:	64 ff 
   133f2:	31 f8 fe    	brw 132ed <__find_arguments+0x315>
   133f5:	9f cd 68 ff 	pushab 0xffffff68(fp)
   133f9:	9f cd 64 ff 	pushab 0xffffff64(fp)
   133fd:	fb 02 cf d6 	calls $0x2,138d8 <__grow_type_table>
   13401:	04 
   13402:	11 e0       	brb 133e4 <__find_arguments+0x40c>
   13404:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13408:	ff 
   13409:	18 11       	bgeq 1341c <__find_arguments+0x444>
   1340b:	d1 59 5a    	cmpl r9,r10
   1340e:	15 03       	bleq 13413 <__find_arguments+0x43b>
   13410:	d0 59 5a    	movl r9,r10
   13413:	90 11 49 dd 	movb $0x11,*0xffffff64(fp)[r9]
   13417:	64 ff 
   13419:	31 d1 fe    	brw 132ed <__find_arguments+0x315>
   1341c:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13420:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13424:	fb 02 cf af 	calls $0x2,138d8 <__grow_type_table>
   13428:	04 
   13429:	11 e0       	brb 1340b <__find_arguments+0x433>
   1342b:	c8 08 58    	bisl2 $0x8,r8
   1342e:	31 28 fc    	brw 13059 <__find_arguments+0x81>
   13431:	c8 10 58    	bisl2 $0x10,r8
   13434:	e1 0c 58 27 	bbc $0xc,r8,1345f <__find_arguments+0x487>
   13438:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   1343c:	ff 
   1343d:	18 11       	bgeq 13450 <__find_arguments+0x478>
   1343f:	d1 59 5a    	cmpl r9,r10
   13442:	15 03       	bleq 13447 <__find_arguments+0x46f>
   13444:	d0 59 5a    	movl r9,r10
   13447:	90 17 49 dd 	movb $0x17,*0xffffff64(fp)[r9]
   1344b:	64 ff 
   1344d:	31 9d fe    	brw 132ed <__find_arguments+0x315>
   13450:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13454:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13458:	fb 02 cf 7b 	calls $0x2,138d8 <__grow_type_table>
   1345c:	04 
   1345d:	11 e0       	brb 1343f <__find_arguments+0x467>
   1345f:	e0 09 58 a1 	bbs $0x9,r8,13404 <__find_arguments+0x42c>
   13463:	e1 0a 58 27 	bbc $0xa,r8,1348e <__find_arguments+0x4b6>
   13467:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   1346b:	ff 
   1346c:	18 11       	bgeq 1347f <__find_arguments+0x4a7>
   1346e:	d1 59 5a    	cmpl r9,r10
   13471:	15 03       	bleq 13476 <__find_arguments+0x49e>
   13473:	d0 59 5a    	movl r9,r10
   13476:	90 13 49 dd 	movb $0x13,*0xffffff64(fp)[r9]
   1347a:	64 ff 
   1347c:	31 6e fe    	brw 132ed <__find_arguments+0x315>
   1347f:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13483:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13487:	fb 02 cf 4c 	calls $0x2,138d8 <__grow_type_table>
   1348b:	04 
   1348c:	11 e0       	brb 1346e <__find_arguments+0x496>
   1348e:	e1 05 58 27 	bbc $0x5,r8,134b9 <__find_arguments+0x4e1>
   13492:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13496:	ff 
   13497:	18 11       	bgeq 134aa <__find_arguments+0x4d2>
   13499:	d1 59 5a    	cmpl r9,r10
   1349c:	15 03       	bleq 134a1 <__find_arguments+0x4c9>
   1349e:	d0 59 5a    	movl r9,r10
   134a1:	90 0b 49 dd 	movb $0xb,*0xffffff64(fp)[r9]
   134a5:	64 ff 
   134a7:	31 43 fe    	brw 132ed <__find_arguments+0x315>
   134aa:	9f cd 68 ff 	pushab 0xffffff68(fp)
   134ae:	9f cd 64 ff 	pushab 0xffffff64(fp)
   134b2:	fb 02 cf 21 	calls $0x2,138d8 <__grow_type_table>
   134b6:	04 
   134b7:	11 e0       	brb 13499 <__find_arguments+0x4c1>
   134b9:	e1 04 58 27 	bbc $0x4,r8,134e4 <__find_arguments+0x50c>
   134bd:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   134c1:	ff 
   134c2:	18 11       	bgeq 134d5 <__find_arguments+0x4fd>
   134c4:	d1 59 5a    	cmpl r9,r10
   134c7:	15 03       	bleq 134cc <__find_arguments+0x4f4>
   134c9:	d0 59 5a    	movl r9,r10
   134cc:	90 08 49 dd 	movb $0x8,*0xffffff64(fp)[r9]
   134d0:	64 ff 
   134d2:	31 18 fe    	brw 132ed <__find_arguments+0x315>
   134d5:	9f cd 68 ff 	pushab 0xffffff68(fp)
   134d9:	9f cd 64 ff 	pushab 0xffffff64(fp)
   134dd:	fb 02 cf f6 	calls $0x2,138d8 <__grow_type_table>
   134e1:	03 
   134e2:	11 e0       	brb 134c4 <__find_arguments+0x4ec>
   134e4:	e1 06 58 27 	bbc $0x6,r8,1350f <__find_arguments+0x537>
   134e8:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   134ec:	ff 
   134ed:	18 11       	bgeq 13500 <__find_arguments+0x528>
   134ef:	d1 59 5a    	cmpl r9,r10
   134f2:	15 03       	bleq 134f7 <__find_arguments+0x51f>
   134f4:	d0 59 5a    	movl r9,r10
   134f7:	90 02 49 dd 	movb $0x2,*0xffffff64(fp)[r9]
   134fb:	64 ff 
   134fd:	31 ed fd    	brw 132ed <__find_arguments+0x315>
   13500:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13504:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13508:	fb 02 cf cb 	calls $0x2,138d8 <__grow_type_table>
   1350c:	03 
   1350d:	11 e0       	brb 134ef <__find_arguments+0x517>
   1350f:	e1 0b 58 27 	bbc $0xb,r8,1353a <__find_arguments+0x562>
   13513:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13517:	ff 
   13518:	18 11       	bgeq 1352b <__find_arguments+0x553>
   1351a:	d1 59 5a    	cmpl r9,r10
   1351d:	15 03       	bleq 13522 <__find_arguments+0x54a>
   1351f:	d0 59 5a    	movl r9,r10
   13522:	90 1a 49 dd 	movb $0x1a,*0xffffff64(fp)[r9]
   13526:	64 ff 
   13528:	31 c2 fd    	brw 132ed <__find_arguments+0x315>
   1352b:	9f cd 68 ff 	pushab 0xffffff68(fp)
   1352f:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13533:	fb 02 cf a0 	calls $0x2,138d8 <__grow_type_table>
   13537:	03 
   13538:	11 e0       	brb 1351a <__find_arguments+0x542>
   1353a:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   1353e:	ff 
   1353f:	18 11       	bgeq 13552 <__find_arguments+0x57a>
   13541:	d1 59 5a    	cmpl r9,r10
   13544:	15 03       	bleq 13549 <__find_arguments+0x571>
   13546:	d0 59 5a    	movl r9,r10
   13549:	90 05 49 dd 	movb $0x5,*0xffffff64(fp)[r9]
   1354d:	64 ff 
   1354f:	31 9b fd    	brw 132ed <__find_arguments+0x315>
   13552:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13556:	9f cd 64 ff 	pushab 0xffffff64(fp)
   1355a:	fb 02 cf 79 	calls $0x2,138d8 <__grow_type_table>
   1355e:	03 
   1355f:	11 e0       	brb 13541 <__find_arguments+0x569>
   13561:	e0 04 58 03 	bbs $0x4,r8,13568 <__find_arguments+0x590>
   13565:	31 75 fe    	brw 133dd <__find_arguments+0x405>
   13568:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   1356c:	ff 
   1356d:	18 11       	bgeq 13580 <__find_arguments+0x5a8>
   1356f:	d1 59 5a    	cmpl r9,r10
   13572:	15 03       	bleq 13577 <__find_arguments+0x59f>
   13574:	d0 59 5a    	movl r9,r10
   13577:	90 1b 49 dd 	movb $0x1b,*0xffffff64(fp)[r9]
   1357b:	64 ff 
   1357d:	31 6d fd    	brw 132ed <__find_arguments+0x315>
   13580:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13584:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13588:	fb 02 cf 4b 	calls $0x2,138d8 <__grow_type_table>
   1358c:	03 
   1358d:	11 e0       	brb 1356f <__find_arguments+0x597>
   1358f:	e1 03 58 27 	bbc $0x3,r8,135ba <__find_arguments+0x5e2>
   13593:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13597:	ff 
   13598:	18 11       	bgeq 135ab <__find_arguments+0x5d3>
   1359a:	d1 59 5a    	cmpl r9,r10
   1359d:	15 03       	bleq 135a2 <__find_arguments+0x5ca>
   1359f:	d0 59 5a    	movl r9,r10
   135a2:	90 0e 49 dd 	movb $0xe,*0xffffff64(fp)[r9]
   135a6:	64 ff 
   135a8:	31 42 fd    	brw 132ed <__find_arguments+0x315>
   135ab:	9f cd 68 ff 	pushab 0xffffff68(fp)
   135af:	9f cd 64 ff 	pushab 0xffffff64(fp)
   135b3:	fb 02 cf 20 	calls $0x2,138d8 <__grow_type_table>
   135b7:	03 
   135b8:	11 e0       	brb 1359a <__find_arguments+0x5c2>
   135ba:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   135be:	ff 
   135bf:	18 11       	bgeq 135d2 <__find_arguments+0x5fa>
   135c1:	d1 59 5a    	cmpl r9,r10
   135c4:	15 03       	bleq 135c9 <__find_arguments+0x5f1>
   135c6:	d0 59 5a    	movl r9,r10
   135c9:	90 0d 49 dd 	movb $0xd,*0xffffff64(fp)[r9]
   135cd:	64 ff 
   135cf:	31 1b fd    	brw 132ed <__find_arguments+0x315>
   135d2:	9f cd 68 ff 	pushab 0xffffff68(fp)
   135d6:	9f cd 64 ff 	pushab 0xffffff64(fp)
   135da:	fb 02 cf f9 	calls $0x2,138d8 <__grow_type_table>
   135de:	02 
   135df:	11 e0       	brb 135c1 <__find_arguments+0x5e9>
   135e1:	91 66 8f 68 	cmpb (r6),$0x68
   135e5:	13 0a       	beql 135f1 <__find_arguments+0x619>
   135e7:	c8 8f 40 00 	bisl2 $0x00000040,r8
   135eb:	00 00 58 
   135ee:	31 68 fa    	brw 13059 <__find_arguments+0x81>
   135f1:	d6 56       	incl r6
   135f3:	c8 8f 00 08 	bisl2 $0x00000800,r8
   135f7:	00 00 58 
   135fa:	31 5c fa    	brw 13059 <__find_arguments+0x81>
   135fd:	c8 8f 00 10 	bisl2 $0x00001000,r8
   13601:	00 00 58 
   13604:	31 52 fa    	brw 13059 <__find_arguments+0x81>
   13607:	91 66 8f 6c 	cmpb (r6),$0x6c
   1360b:	13 06       	beql 13613 <__find_arguments+0x63b>
   1360d:	c8 10 58    	bisl2 $0x10,r8
   13610:	31 46 fa    	brw 13059 <__find_arguments+0x81>
   13613:	d6 56       	incl r6
   13615:	c8 20 58    	bisl2 $0x20,r8
   13618:	31 3e fa    	brw 13059 <__find_arguments+0x81>
   1361b:	e1 05 58 27 	bbc $0x5,r8,13646 <__find_arguments+0x66e>
   1361f:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13623:	ff 
   13624:	18 11       	bgeq 13637 <__find_arguments+0x65f>
   13626:	d1 59 5a    	cmpl r9,r10
   13629:	15 03       	bleq 1362e <__find_arguments+0x656>
   1362b:	d0 59 5a    	movl r9,r10
   1362e:	90 0c 49 dd 	movb $0xc,*0xffffff64(fp)[r9]
   13632:	64 ff 
   13634:	31 b6 fc    	brw 132ed <__find_arguments+0x315>
   13637:	9f cd 68 ff 	pushab 0xffffff68(fp)
   1363b:	9f cd 64 ff 	pushab 0xffffff64(fp)
   1363f:	fb 02 cf 94 	calls $0x2,138d8 <__grow_type_table>
   13643:	02 
   13644:	11 e0       	brb 13626 <__find_arguments+0x64e>
   13646:	e1 04 58 27 	bbc $0x4,r8,13671 <__find_arguments+0x699>
   1364a:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   1364e:	ff 
   1364f:	18 11       	bgeq 13662 <__find_arguments+0x68a>
   13651:	d1 59 5a    	cmpl r9,r10
   13654:	15 03       	bleq 13659 <__find_arguments+0x681>
   13656:	d0 59 5a    	movl r9,r10
   13659:	90 09 49 dd 	movb $0x9,*0xffffff64(fp)[r9]
   1365d:	64 ff 
   1365f:	31 8b fc    	brw 132ed <__find_arguments+0x315>
   13662:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13666:	9f cd 64 ff 	pushab 0xffffff64(fp)
   1366a:	fb 02 cf 69 	calls $0x2,138d8 <__grow_type_table>
   1366e:	02 
   1366f:	11 e0       	brb 13651 <__find_arguments+0x679>
   13671:	e1 06 58 27 	bbc $0x6,r8,1369c <__find_arguments+0x6c4>
   13675:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13679:	ff 
   1367a:	18 11       	bgeq 1368d <__find_arguments+0x6b5>
   1367c:	d1 59 5a    	cmpl r9,r10
   1367f:	15 03       	bleq 13684 <__find_arguments+0x6ac>
   13681:	d0 59 5a    	movl r9,r10
   13684:	90 03 49 dd 	movb $0x3,*0xffffff64(fp)[r9]
   13688:	64 ff 
   1368a:	31 60 fc    	brw 132ed <__find_arguments+0x315>
   1368d:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13691:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13695:	fb 02 cf 3e 	calls $0x2,138d8 <__grow_type_table>
   13699:	02 
   1369a:	11 e0       	brb 1367c <__find_arguments+0x6a4>
   1369c:	e1 09 58 27 	bbc $0x9,r8,136c7 <__find_arguments+0x6ef>
   136a0:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   136a4:	ff 
   136a5:	18 11       	bgeq 136b8 <__find_arguments+0x6e0>
   136a7:	d1 59 5a    	cmpl r9,r10
   136aa:	15 03       	bleq 136af <__find_arguments+0x6d7>
   136ac:	d0 59 5a    	movl r9,r10
   136af:	90 12 49 dd 	movb $0x12,*0xffffff64(fp)[r9]
   136b3:	64 ff 
   136b5:	31 35 fc    	brw 132ed <__find_arguments+0x315>
   136b8:	9f cd 68 ff 	pushab 0xffffff68(fp)
   136bc:	9f cd 64 ff 	pushab 0xffffff64(fp)
   136c0:	fb 02 cf 13 	calls $0x2,138d8 <__grow_type_table>
   136c4:	02 
   136c5:	11 e0       	brb 136a7 <__find_arguments+0x6cf>
   136c7:	e1 0a 58 27 	bbc $0xa,r8,136f2 <__find_arguments+0x71a>
   136cb:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   136cf:	ff 
   136d0:	18 11       	bgeq 136e3 <__find_arguments+0x70b>
   136d2:	d1 59 5a    	cmpl r9,r10
   136d5:	15 03       	bleq 136da <__find_arguments+0x702>
   136d7:	d0 59 5a    	movl r9,r10
   136da:	90 15 49 dd 	movb $0x15,*0xffffff64(fp)[r9]
   136de:	64 ff 
   136e0:	31 0a fc    	brw 132ed <__find_arguments+0x315>
   136e3:	9f cd 68 ff 	pushab 0xffffff68(fp)
   136e7:	9f cd 64 ff 	pushab 0xffffff64(fp)
   136eb:	fb 02 cf e8 	calls $0x2,138d8 <__grow_type_table>
   136ef:	01 
   136f0:	11 e0       	brb 136d2 <__find_arguments+0x6fa>
   136f2:	e1 0c 58 27 	bbc $0xc,r8,1371d <__find_arguments+0x745>
   136f6:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   136fa:	ff 
   136fb:	18 11       	bgeq 1370e <__find_arguments+0x736>
   136fd:	d1 59 5a    	cmpl r9,r10
   13700:	15 03       	bleq 13705 <__find_arguments+0x72d>
   13702:	d0 59 5a    	movl r9,r10
   13705:	90 18 49 dd 	movb $0x18,*0xffffff64(fp)[r9]
   13709:	64 ff 
   1370b:	31 df fb    	brw 132ed <__find_arguments+0x315>
   1370e:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13712:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13716:	fb 02 cf bd 	calls $0x2,138d8 <__grow_type_table>
   1371a:	01 
   1371b:	11 e0       	brb 136fd <__find_arguments+0x725>
   1371d:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13721:	ff 
   13722:	18 11       	bgeq 13735 <__find_arguments+0x75d>
   13724:	d1 59 5a    	cmpl r9,r10
   13727:	15 03       	bleq 1372c <__find_arguments+0x754>
   13729:	d0 59 5a    	movl r9,r10
   1372c:	90 06 49 dd 	movb $0x6,*0xffffff64(fp)[r9]
   13730:	64 ff 
   13732:	31 b8 fb    	brw 132ed <__find_arguments+0x315>
   13735:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13739:	9f cd 64 ff 	pushab 0xffffff64(fp)
   1373d:	fb 02 cf 96 	calls $0x2,138d8 <__grow_type_table>
   13741:	01 
   13742:	11 e0       	brb 13724 <__find_arguments+0x74c>
   13744:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13748:	ff 
   13749:	18 11       	bgeq 1375c <__find_arguments+0x784>
   1374b:	d1 59 5a    	cmpl r9,r10
   1374e:	15 03       	bleq 13753 <__find_arguments+0x77b>
   13750:	d0 59 5a    	movl r9,r10
   13753:	90 10 49 dd 	movb $0x10,*0xffffff64(fp)[r9]
   13757:	64 ff 
   13759:	31 91 fb    	brw 132ed <__find_arguments+0x315>
   1375c:	9f cd 68 ff 	pushab 0xffffff68(fp)
   13760:	9f cd 64 ff 	pushab 0xffffff64(fp)
   13764:	fb 02 cf 6f 	calls $0x2,138d8 <__grow_type_table>
   13768:	01 
   13769:	11 e0       	brb 1374b <__find_arguments+0x773>
   1376b:	e1 04 58 27 	bbc $0x4,r8,13796 <__find_arguments+0x7be>
   1376f:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   13773:	ff 
   13774:	18 11       	bgeq 13787 <__find_arguments+0x7af>
   13776:	d1 59 5a    	cmpl r9,r10
   13779:	15 03       	bleq 1377e <__find_arguments+0x7a6>
   1377b:	d0 59 5a    	movl r9,r10
   1377e:	90 1c 49 dd 	movb $0x1c,*0xffffff64(fp)[r9]
   13782:	64 ff 
   13784:	31 66 fb    	brw 132ed <__find_arguments+0x315>
   13787:	9f cd 68 ff 	pushab 0xffffff68(fp)
   1378b:	9f cd 64 ff 	pushab 0xffffff64(fp)
   1378f:	fb 02 cf 44 	calls $0x2,138d8 <__grow_type_table>
   13793:	01 
   13794:	11 e0       	brb 13776 <__find_arguments+0x79e>
   13796:	d1 59 cd 68 	cmpl r9,0xffffff68(fp)
   1379a:	ff 
   1379b:	18 11       	bgeq 137ae <__find_arguments+0x7d6>
   1379d:	d1 59 5a    	cmpl r9,r10
   137a0:	15 03       	bleq 137a5 <__find_arguments+0x7cd>
   137a2:	d0 59 5a    	movl r9,r10
   137a5:	90 0f 49 dd 	movb $0xf,*0xffffff64(fp)[r9]
   137a9:	64 ff 
   137ab:	31 3f fb    	brw 132ed <__find_arguments+0x315>
   137ae:	9f cd 68 ff 	pushab 0xffffff68(fp)
   137b2:	9f cd 64 ff 	pushab 0xffffff64(fp)
   137b6:	fb 02 cf 1d 	calls $0x2,138d8 <__grow_type_table>
   137ba:	01 
   137bb:	11 e0       	brb 1379d <__find_arguments+0x7c5>
   137bd:	c8 8f 00 02 	bisl2 $0x00000200,r8
   137c1:	00 00 58 
   137c4:	31 92 f8    	brw 13059 <__find_arguments+0x81>
   137c7:	d5 51       	tstl r1
   137c9:	13 03       	beql 137ce <__find_arguments+0x7f6>
   137cb:	31 58 f8    	brw 13026 <__find_arguments+0x4e>
   137ce:	d1 5a 07    	cmpl r10,$0x7
   137d1:	15 3b       	bleq 1380e <__find_arguments+0x836>
   137d3:	7e 4a 9f 08 	movaq *0x8[r10],r0
   137d7:	00 00 00 50 
   137db:	d0 cd 58 ff 	movl 0xffffff58(fp),r1
   137df:	51 
   137e0:	d0 50 61    	movl r0,(r1)
   137e3:	7c 7e       	clrd -(sp)
   137e5:	d2 00 7e    	mcoml $0x0,-(sp)
   137e8:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   137ec:	7e 
   137ed:	dd 03       	pushl $0x3
   137ef:	dd 50       	pushl r0
   137f1:	d4 7e       	clrf -(sp)
   137f3:	fb 07 ef 68 	calls $0x7,16a62 <_thread_sys_mmap>
   137f7:	32 00 00 
   137fa:	d0 cd 5c ff 	movl 0xffffff5c(fp),r3
   137fe:	53 
   137ff:	d0 50 63    	movl r0,(r3)
   13802:	d1 50 8f ff 	cmpl r0,$0xffffffff
   13806:	ff ff ff 
   13809:	12 03       	bneq 1380e <__find_arguments+0x836>
   1380b:	31 f8 f9    	brw 13206 <__find_arguments+0x22e>
   1380e:	d0 01 52    	movl $0x1,r2
   13811:	d1 52 5a    	cmpl r2,r10
   13814:	15 03       	bleq 13819 <__find_arguments+0x841>
   13816:	31 c3 f9    	brw 131dc <__find_arguments+0x204>
   13819:	9a 42 dd 64 	movzbl *0xffffff64(fp)[r2],r0
   1381d:	ff 50 
   1381f:	d1 50 1c    	cmpl r0,$0x1c
   13822:	1a 50       	bgtru 13874 <__find_arguments+0x89c>
   13824:	cf 50 00 1c 	casel r0,$0x0,$0x1c
   13828:	8f 00 8f 00 	caseb $0x0,$0x00,$0x00
   1382c:	8f 00 
   1382e:	8f 00 8f 00 	caseb $0x0,$0x00,$0x00
   13832:	8f 00 
   13834:	8f 00 8f 00 	caseb $0x0,$0x00,$0x00
   13838:	8f 00 
   1383a:	8f 00 67 00 	caseb $0x0,(r7),$0x0
   1383e:	7b 00 8f 00 	ediv $0x0,$0x8f008f0053003a00,$0x0,$0x8f008f00
   13842:	3a 00 53 00 
   13846:	8f 00 8f 00 
   1384a:	8f 00 8f 00 
   1384e:	8f 
   1384f:	00          	halt
   13850:	8f 00 8f 00 	caseb $0x0,$0x00,(r7)
   13854:	67 
   13855:	00          	halt
   13856:	7b 00 8f 00 	ediv $0x0,$0x8f008f008f008f00,$0x0,*0x505b(r0)
   1385a:	8f 00 8f 00 
   1385e:	8f 00 8f 00 
   13862:	d0 5b 50 
   13865:	c0 08 5b    	addl2 $0x8,r11
   13868:	d0 cd 5c ff 	movl 0xffffff5c(fp),r1
   1386c:	51 
   1386d:	d0 61 51    	movl (r1),r1
   13870:	70 60 42 61 	movd (r0),(r1)[r2]
   13874:	f3 5a 52 a1 	aobleq r10,r2,13819 <__find_arguments+0x841>
   13878:	31 61 f9    	brw 131dc <__find_arguments+0x204>
   1387b:	d0 5b 50    	movl r11,r0
   1387e:	c0 08 5b    	addl2 $0x8,r11
   13881:	d0 cd 5c ff 	movl 0xffffff5c(fp),r3
   13885:	53 
   13886:	d0 63 53    	movl (r3),r3
   13889:	70 60 42 63 	movd (r0),(r3)[r2]
   1388d:	11 e5       	brb 13874 <__find_arguments+0x89c>
   1388f:	d0 5b 50    	movl r11,r0
   13892:	c0 08 5b    	addl2 $0x8,r11
   13895:	d0 cd 5c ff 	movl 0xffffff5c(fp),r1
   13899:	51 
   1389a:	d0 61 51    	movl (r1),r1
   1389d:	7d 60 42 61 	movq (r0),(r1)[r2]
   138a1:	11 d1       	brb 13874 <__find_arguments+0x89c>
   138a3:	d0 5b 50    	movl r11,r0
   138a6:	c0 08 5b    	addl2 $0x8,r11
   138a9:	d0 cd 5c ff 	movl 0xffffff5c(fp),r3
   138ad:	53 
   138ae:	d0 63 53    	movl (r3),r3
   138b1:	7d 60 42 63 	movq (r0),(r3)[r2]
   138b5:	11 bd       	brb 13874 <__find_arguments+0x89c>
   138b7:	d0 cd 5c ff 	movl 0xffffff5c(fp),r0
   138bb:	50 
   138bc:	d0 60 53    	movl (r0),r3
   138bf:	7e 42 63 51 	movaq (r3)[r2],r1
   138c3:	d0 5b 50    	movl r11,r0
   138c6:	c0 04 5b    	addl2 $0x4,r11
   138c9:	d0 60 61    	movl (r0),(r1)
   138cc:	11 a6       	brb 13874 <__find_arguments+0x89c>
   138ce:	c8 8f 00 04 	bisl2 $0x00000400,r8
   138d2:	00 00 58 
   138d5:	31 81 f7    	brw 13059 <__find_arguments+0x81>

000138d8 <__grow_type_table>:
   138d8:	c0 07       	.word 0x07c0 # Entry mask: < r10 r9 r8 r7 r6 >
   138da:	c2 04 5e    	subl2 $0x4,sp
   138dd:	d0 ac 04 59 	movl 0x4(ap),r9
   138e1:	d0 ac 08 58 	movl 0x8(ap),r8
   138e5:	d0 69 5a    	movl (r9),r10
   138e8:	78 01 68 57 	ashl $0x1,(r8),r7
   138ec:	9e ef 18 25 	movab 15e0a <getpagesize>,r6
   138f0:	00 00 56 
   138f3:	fb 00 66    	calls $0x0,(r6)
   138f6:	d1 57 50    	cmpl r7,r0
   138f9:	18 03       	bgeq 138fe <__grow_type_table+0x26>
   138fb:	31 8f 00    	brw 1398d <__grow_type_table+0xb5>
   138fe:	d1 68 08    	cmpl (r8),$0x8
   13901:	13 58       	beql 1395b <__grow_type_table+0x83>
   13903:	7c 7e       	clrd -(sp)
   13905:	d2 00 7e    	mcoml $0x0,-(sp)
   13908:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   1390c:	7e 
   1390d:	dd 03       	pushl $0x3
   1390f:	dd 57       	pushl r7
   13911:	d4 7e       	clrf -(sp)
   13913:	fb 07 ef 48 	calls $0x7,16a62 <_thread_sys_mmap>
   13917:	31 00 00 
   1391a:	d0 50 56    	movl r0,r6
   1391d:	d1 50 8f ff 	cmpl r0,$0xffffffff
   13921:	ff ff ff 
   13924:	13 34       	beql 1395a <__grow_type_table+0x82>
   13926:	dd 68       	pushl (r8)
   13928:	dd 69       	pushl (r9)
   1392a:	dd 50       	pushl r0
   1392c:	fb 03 ef 51 	calls $0x3,16884 <memmove>
   13930:	2f 00 00 
   13933:	dd 68       	pushl (r8)
   13935:	dd 69       	pushl (r9)
   13937:	fb 02 ef 8e 	calls $0x2,16acc <_thread_sys_munmap>
   1393b:	31 00 00 
   1393e:	d0 56 69    	movl r6,(r9)
   13941:	d0 68 50    	movl (r8),r0
   13944:	c3 50 57 7e 	subl3 r0,r7,-(sp)
   13948:	d4 7e       	clrf -(sp)
   1394a:	c1 69 50 7e 	addl3 (r9),r0,-(sp)
   1394e:	fb 03 ef a3 	calls $0x3,168f8 <memset>
   13952:	2f 00 00 
   13955:	d0 57 68    	movl r7,(r8)
   13958:	d4 50       	clrf r0
   1395a:	04          	ret
   1395b:	7c 7e       	clrd -(sp)
   1395d:	d2 00 7e    	mcoml $0x0,-(sp)
   13960:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   13964:	7e 
   13965:	dd 03       	pushl $0x3
   13967:	dd 57       	pushl r7
   13969:	d4 7e       	clrf -(sp)
   1396b:	fb 07 ef f0 	calls $0x7,16a62 <_thread_sys_mmap>
   1396f:	30 00 00 
   13972:	d0 50 69    	movl r0,(r9)
   13975:	d1 50 8f ff 	cmpl r0,$0xffffffff
   13979:	ff ff ff 
   1397c:	13 dc       	beql 1395a <__grow_type_table+0x82>
   1397e:	dd 68       	pushl (r8)
   13980:	dd 50       	pushl r0
   13982:	dd 5a       	pushl r10
   13984:	fb 03 ef 1d 	calls $0x3,15da8 <bcopy>
   13988:	24 00 00 
   1398b:	11 b4       	brb 13941 <__grow_type_table+0x69>
   1398d:	fb 00 66    	calls $0x0,(r6)
   13990:	d0 50 57    	movl r0,r7
   13993:	31 68 ff    	brw 138fe <__grow_type_table+0x26>

00013996 <exponent>:
   13996:	00 00       	.word 0x0000 # Entry mask: < >
   13998:	c2 10 5e    	subl2 $0x10,sp
   1399b:	d0 ac 08 52 	movl 0x8(ap),r2
   1399f:	d0 ac 0c 50 	movl 0xc(ap),r0
   139a3:	d0 ef ef 85 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   139a7:	02 00 ad f8 
   139ab:	d0 ac 04 55 	movl 0x4(ap),r5
   139af:	d0 55 54    	movl r5,r4
   139b2:	90 50 84    	movb r0,(r4)+
   139b5:	d5 52       	tstl r2
   139b7:	19 78       	blss 13a31 <exponent+0x9b>
   139b9:	90 2b 84    	movb $0x2b,(r4)+
   139bc:	c3 0a 5d 53 	subl3 $0xa,fp,r3
   139c0:	d1 52 09    	cmpl r2,$0x9
   139c3:	15 4f       	bleq 13a14 <exponent+0x7e>
   139c5:	c7 0a 52 51 	divl3 $0xa,r2,r1
   139c9:	c5 51 0a 50 	mull3 r1,$0xa,r0
   139cd:	c3 50 52 50 	subl3 r0,r2,r0
   139d1:	81 50 30 73 	addb3 r0,$0x30,-(r3)
   139d5:	d0 51 52    	movl r1,r2
   139d8:	d1 51 09    	cmpl r1,$0x9
   139db:	14 e8       	bgtr 139c5 <exponent+0x2f>
   139dd:	81 51 30 73 	addb3 r1,$0x30,-(r3)
   139e1:	c3 0a 5d 50 	subl3 $0xa,fp,r0
   139e5:	d1 53 50    	cmpl r3,r0
   139e8:	1e 08       	bcc 139f2 <exponent+0x5c>
   139ea:	90 83 84    	movb (r3)+,(r4)+
   139ed:	d1 53 50    	cmpl r3,r0
   139f0:	1f f8       	blssu 139ea <exponent+0x54>
   139f2:	c3 55 54 50 	subl3 r5,r4,r0
   139f6:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   139fa:	d1 51 ef 97 	cmpl r1,3bf98 <__guard_local>
   139fe:	85 02 00 
   13a01:	13 10       	beql 13a13 <exponent+0x7d>
   13a03:	dd ad f8    	pushl 0xfffffff8(fp)
   13a06:	9f ef e3 71 	pushab 2abef <xdigs_upper.3+0x72>
   13a0a:	01 00 
   13a0c:	fb 02 ef 59 	calls $0x2,1666c <__stack_smash_handler>
   13a10:	2c 00 00 
   13a13:	04          	ret
   13a14:	d1 50 8f 65 	cmpl r0,$0x00000065
   13a18:	00 00 00 
   13a1b:	13 0f       	beql 13a2c <exponent+0x96>
   13a1d:	d1 50 8f 45 	cmpl r0,$0x00000045
   13a21:	00 00 00 
   13a24:	13 06       	beql 13a2c <exponent+0x96>
   13a26:	81 52 30 84 	addb3 r2,$0x30,(r4)+
   13a2a:	11 c6       	brb 139f2 <exponent+0x5c>
   13a2c:	90 30 84    	movb $0x30,(r4)+
   13a2f:	11 f5       	brb 13a26 <exponent+0x90>
   13a31:	ce 52 52    	mnegl r2,r2
   13a34:	90 2d 84    	movb $0x2d,(r4)+
   13a37:	11 83       	brb 139bc <exponent+0x26>
   13a39:	01          	nop

00013a3a <roundup>:
   13a3a:	00 00       	.word 0x0000 # Entry mask: < >
   13a3c:	c2 04 5e    	subl2 $0x4,sp
   13a3f:	d0 ac 04 51 	movl 0x4(ap),r1
   13a43:	c1 51 ac 08 	addl3 r1,0x8(ap),r0
   13a47:	50 
   13a48:	d7 50       	decl r0
   13a4a:	91 60 0f    	cmpb (r0),$0xf
   13a4d:	13 05       	beql 13a54 <roundup+0x1a>
   13a4f:	96 60       	incb (r0)
   13a51:	d4 50       	clrf r0
   13a53:	04          	ret
   13a54:	d1 50 51    	cmpl r0,r1
   13a57:	13 09       	beql 13a62 <roundup+0x28>
   13a59:	94 60       	clrb (r0)
   13a5b:	91 70 0f    	cmpb -(r0),$0xf
   13a5e:	13 f4       	beql 13a54 <roundup+0x1a>
   13a60:	11 ed       	brb 13a4f <roundup+0x15>
   13a62:	90 01 60    	movb $0x1,(r0)
   13a65:	d0 01 50    	movl $0x1,r0
   13a68:	04          	ret
   13a69:	01          	nop

00013a6a <dorounding>:
   13a6a:	40 00       	.word 0x0040 # Entry mask: < r6 >
   13a6c:	c2 04 5e    	subl2 $0x4,sp
   13a6f:	d0 ac 04 52 	movl 0x4(ap),r2
   13a73:	d0 ac 08 51 	movl 0x8(ap),r1
   13a77:	d0 ac 10 56 	movl 0x10(ap),r6
   13a7b:	d4 53       	clrf r3
   13a7d:	90 42 61 50 	movb (r1)[r2],r0
   13a81:	91 50 08    	cmpb r0,$0x8
   13a84:	14 12       	bgtr 13a98 <dorounding+0x2e>
   13a86:	13 08       	beql 13a90 <dorounding+0x26>
   13a88:	d5 53       	tstl r3
   13a8a:	13 03       	beql 13a8f <dorounding+0x25>
   13a8c:	c0 04 66    	addl2 $0x4,(r6)
   13a8f:	04          	ret
   13a90:	98 42 a1 01 	cvtbl 0x1(r1)[r2],r0
   13a94:	50 
   13a95:	e9 50 f0    	blbc r0,13a88 <dorounding+0x1e>
   13a98:	dd 51       	pushl r1
   13a9a:	dd 52       	pushl r2
   13a9c:	fb 02 af 9a 	calls $0x2,13a3a <roundup>
   13aa0:	d0 50 53    	movl r0,r3
   13aa3:	11 e3       	brb 13a88 <dorounding+0x1e>
   13aa5:	01          	nop

00013aa6 <__hdtoa>:
   13aa6:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   13aa8:	c2 04 5e    	subl2 $0x4,sp
   13aab:	d0 ac 10 59 	movl 0x10(ap),r9
   13aaf:	d0 ac 14 5a 	movl 0x14(ap),r10
   13ab3:	d0 ac 1c 5b 	movl 0x1c(ap),r11
   13ab7:	c1 5c 04 57 	addl3 ap,$0x4,r7
   13abb:	ef 07 01 ac 	extzv $0x7,$0x1,0x5(ap),*0x18(ap)
   13abf:	05 bc 18 
   13ac2:	70 ac 04 7e 	movd 0x4(ap),-(sp)
   13ac6:	fb 02 ef 57 	calls $0x2,13c24 <__fpclassify>
   13aca:	01 00 00 
   13acd:	d1 50 04    	cmpl r0,$0x4
   13ad0:	13 1d       	beql 13aef <__hdtoa+0x49>
   13ad2:	d1 50 10    	cmpl r0,$0x10
   13ad5:	13 03       	beql 13ada <__hdtoa+0x34>
   13ad7:	31 23 01    	brw 13bfd <__hdtoa+0x157>
   13ada:	d0 01 6a    	movl $0x1,(r10)
   13add:	dd 01       	pushl $0x1
   13adf:	dd 5b       	pushl r11
   13ae1:	9f ef 0a 7a 	pushab 2b4f1 <_sys_errlist+0x181>
   13ae5:	01 00 
   13ae7:	fb 03 ef 9a 	calls $0x3,14688 <__nrv_alloc_D2A>
   13aeb:	0b 00 00 
   13aee:	04          	ret
   13aef:	ef 07 08 ac 	extzv $0x7,$0x8,0x4(ap),r0
   13af3:	04 50 
   13af5:	9e a0 80 6a 	movab 0xffffff80(r0),(r10)
   13af9:	d5 59       	tstl r9
   13afb:	12 03       	bneq 13b00 <__hdtoa+0x5a>
   13afd:	d0 01 59    	movl $0x1,r9
   13b00:	d0 59 58    	movl r9,r8
   13b03:	d1 59 0e    	cmpl r9,$0xe
   13b06:	18 03       	bgeq 13b0b <__hdtoa+0x65>
   13b08:	d0 0e 58    	movl $0xe,r8
   13b0b:	dd 58       	pushl r8
   13b0d:	fb 01 ef 3e 	calls $0x1,14652 <__rv_alloc_D2A>
   13b11:	0b 00 00 
   13b14:	d0 50 56    	movl r0,r6
   13b17:	12 03       	bneq 13b1c <__hdtoa+0x76>
   13b19:	31 de 00    	brw 13bfa <__hdtoa+0x154>
   13b1c:	9e 40 a8 ff 	movab 0xffffffff(r8)[r0],r1
   13b20:	51 
   13b21:	c0 0d 50    	addl2 $0xd,r0
   13b24:	d1 51 50    	cmpl r1,r0
   13b27:	1b 09       	blequ 13b32 <__hdtoa+0x8c>
   13b29:	94 61       	clrb (r1)
   13b2b:	d7 51       	decl r1
   13b2d:	d1 51 50    	cmpl r1,r0
   13b30:	1a f7       	bgtru 13b29 <__hdtoa+0x83>
   13b32:	c1 56 05 52 	addl3 r6,$0x5,r2
   13b36:	d1 51 52    	cmpl r1,r2
   13b39:	1b 21       	blequ 13b5c <__hdtoa+0xb6>
   13b3b:	d1 51 56    	cmpl r1,r6
   13b3e:	1b 1c       	blequ 13b5c <__hdtoa+0xb6>
   13b40:	8b 8f f0 a7 	bicb3 $0xf0,0x4(r7),(r1)
   13b44:	04 61 
   13b46:	d0 a7 04 50 	movl 0x4(r7),r0
   13b4a:	ef 04 1c 50 	extzv $0x4,$0x1c,r0,0x4(r7)
   13b4e:	a7 04 
   13b50:	d7 51       	decl r1
   13b52:	d1 51 52    	cmpl r1,r2
   13b55:	1b 05       	blequ 13b5c <__hdtoa+0xb6>
   13b57:	d1 51 56    	cmpl r1,r6
   13b5a:	1a e4       	bgtru 13b40 <__hdtoa+0x9a>
   13b5c:	d1 51 56    	cmpl r1,r6
   13b5f:	1b 17       	blequ 13b78 <__hdtoa+0xd2>
   13b61:	8b 8f f0 a7 	bicb3 $0xf0,0x2(r7),(r1)
   13b65:	02 61 
   13b67:	ef 04 0c a7 	extzv $0x4,$0xc,0x2(r7),r0
   13b6b:	02 50 
   13b6d:	b0 50 a7 02 	movw r0,0x2(r7)
   13b71:	d7 51       	decl r1
   13b73:	d1 51 56    	cmpl r1,r6
   13b76:	1a e9       	bgtru 13b61 <__hdtoa+0xbb>
   13b78:	d1 51 56    	cmpl r1,r6
   13b7b:	1b 16       	blequ 13b93 <__hdtoa+0xed>
   13b7d:	8b 8f f0 67 	bicb3 $0xf0,(r7),(r1)
   13b81:	61 
   13b82:	ef 04 03 67 	extzv $0x4,$0x3,(r7),r0
   13b86:	50 
   13b87:	f0 50 00 07 	insv r0,$0x0,$0x7,(r7)
   13b8b:	67 
   13b8c:	d7 51       	decl r1
   13b8e:	d1 51 56    	cmpl r1,r6
   13b91:	1a ea       	bgtru 13b7d <__hdtoa+0xd7>
   13b93:	ef 00 07 67 	extzv $0x0,$0x7,(r7),r0
   13b97:	50 
   13b98:	89 08 50 61 	bisb3 $0x8,r0,(r1)
   13b9c:	d5 59       	tstl r9
   13b9e:	19 47       	blss 13be7 <__hdtoa+0x141>
   13ba0:	d1 59 0d    	cmpl r9,$0xd
   13ba3:	14 05       	bgtr 13baa <__hdtoa+0x104>
   13ba5:	95 46 69    	tstb (r9)[r6]
   13ba8:	12 2a       	bneq 13bd4 <__hdtoa+0x12e>
   13baa:	c1 56 59 51 	addl3 r6,r9,r1
   13bae:	d5 5b       	tstl r11
   13bb0:	13 03       	beql 13bb5 <__hdtoa+0x10f>
   13bb2:	d0 51 6b    	movl r1,(r11)
   13bb5:	94 61       	clrb (r1)
   13bb7:	d7 51       	decl r1
   13bb9:	d1 51 56    	cmpl r1,r6
   13bbc:	1f 12       	blssu 13bd0 <__hdtoa+0x12a>
   13bbe:	98 61 50    	cvtbl (r1),r0
   13bc1:	d0 ac 0c 52 	movl 0xc(ap),r2
   13bc5:	90 42 60 61 	movb (r0)[r2],(r1)
   13bc9:	d7 51       	decl r1
   13bcb:	d1 51 56    	cmpl r1,r6
   13bce:	1e ee       	bcc 13bbe <__hdtoa+0x118>
   13bd0:	d0 56 50    	movl r6,r0
   13bd3:	04          	ret
   13bd4:	dd 5a       	pushl r10
   13bd6:	ef 07 01 a7 	extzv $0x7,$0x1,0x1(r7),-(sp)
   13bda:	01 7e 
   13bdc:	dd 59       	pushl r9
   13bde:	dd 56       	pushl r6
   13be0:	fb 04 cf 85 	calls $0x4,13a6a <dorounding>
   13be4:	fe 
   13be5:	11 c3       	brb 13baa <__hdtoa+0x104>
   13be7:	d0 0e 59    	movl $0xe,r9
   13bea:	95 46 a9 ff 	tstb 0xffffffff(r9)[r6]
   13bee:	12 b0       	bneq 13ba0 <__hdtoa+0xfa>
   13bf0:	d7 59       	decl r9
   13bf2:	95 46 a9 ff 	tstb 0xffffffff(r9)[r6]
   13bf6:	13 f8       	beql 13bf0 <__hdtoa+0x14a>
   13bf8:	11 a6       	brb 13ba0 <__hdtoa+0xfa>
   13bfa:	d4 50       	clrf r0
   13bfc:	04          	ret
   13bfd:	fb 00 ef a4 	calls $0x0,167a8 <abort>
   13c01:	2b 00 00 

00013c04 <__hldtoa>:
   13c04:	00 00       	.word 0x0000 # Entry mask: < >
   13c06:	c2 04 5e    	subl2 $0x4,sp
   13c09:	dd ac 1c    	pushl 0x1c(ap)
   13c0c:	dd ac 18    	pushl 0x18(ap)
   13c0f:	dd ac 14    	pushl 0x14(ap)
   13c12:	dd ac 10    	pushl 0x10(ap)
   13c15:	dd ac 0c    	pushl 0xc(ap)
   13c18:	70 ac 04 7e 	movd 0x4(ap),-(sp)
   13c1c:	fb 07 ef 83 	calls $0x7,13aa6 <__hdtoa>
   13c20:	fe ff ff 
   13c23:	04          	ret

00013c24 <__fpclassify>:
   13c24:	00 00       	.word 0x0000 # Entry mask: < >
   13c26:	c2 04 5e    	subl2 $0x4,sp
   13c29:	ef 07 08 ac 	extzv $0x7,$0x8,0x4(ap),r0
   13c2d:	04 50 
   13c2f:	12 04       	bneq 13c35 <__fpclassify+0x11>
   13c31:	d0 10 50    	movl $0x10,r0
   13c34:	04          	ret
   13c35:	d0 04 50    	movl $0x4,r0
   13c38:	04          	ret
   13c39:	01          	nop

00013c3a <__fpclassifyf>:
   13c3a:	00 00       	.word 0x0000 # Entry mask: < >
   13c3c:	c2 04 5e    	subl2 $0x4,sp
   13c3f:	ef 07 08 ac 	extzv $0x7,$0x8,0x4(ap),r0
   13c43:	04 50 
   13c45:	12 04       	bneq 13c4b <__fpclassifyf+0x11>
   13c47:	d0 10 50    	movl $0x10,r0
   13c4a:	04          	ret
   13c4b:	d0 04 50    	movl $0x4,r0
   13c4e:	04          	ret
   13c4f:	01          	nop

00013c50 <__ldtoa>:
   13c50:	40 00       	.word 0x0040 # Entry mask: < r6 >
   13c52:	c2 04 5e    	subl2 $0x4,sp
   13c55:	d0 ac 10 56 	movl 0x10(ap),r6
   13c59:	dd ac 18    	pushl 0x18(ap)
   13c5c:	dd ac 14    	pushl 0x14(ap)
   13c5f:	dd 56       	pushl r6
   13c61:	dd ac 0c    	pushl 0xc(ap)
   13c64:	dd ac 08    	pushl 0x8(ap)
   13c67:	70 bc 04 7e 	movd *0x4(ap),-(sp)
   13c6b:	fb 07 ef 14 	calls $0x7,13c86 <__dtoa>
   13c6f:	00 00 00 
   13c72:	d1 66 8f 0f 	cmpl (r6),$0x0000270f
   13c76:	27 00 00 
   13c79:	13 01       	beql 13c7c <__ldtoa+0x2c>
   13c7b:	04          	ret
   13c7c:	d0 8f ff ff 	movl $0x7fffffff,(r6)
   13c80:	ff 7f 66 
   13c83:	11 f6       	brb 13c7b <__ldtoa+0x2b>
   13c85:	01          	nop

00013c86 <__dtoa>:
   13c86:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   13c88:	9e ae 98 5e 	movab 0xffffff98(sp),sp
   13c8c:	d0 ef 06 83 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   13c90:	02 00 ad f8 
   13c94:	d0 ac 14 ad 	movl 0x14(ap),0xffffff9c(fp)
   13c98:	9c 
   13c99:	d0 ac 18 50 	movl 0x18(ap),r0
   13c9d:	d0 ac 1c ad 	movl 0x1c(ap),0xffffff98(fp)
   13ca1:	98 
   13ca2:	70 ac 04 ad 	movd 0x4(ap),0xffffffe8(fp)
   13ca6:	e8 
   13ca7:	b3 ad e8 8f 	bitw 0xffffffe8(fp),$0x8000
   13cab:	00 80 
   13cad:	12 03       	bneq 13cb2 <__dtoa+0x2c>
   13caf:	31 9b 09    	brw 1464d <__dtoa+0x9c7>
   13cb2:	d0 01 60    	movl $0x1,(r0)
   13cb5:	ca 8f 00 80 	bicl2 $0x00008000,0xffffffe8(fp)
   13cb9:	00 00 ad e8 
   13cbd:	d1 ad e8 8f 	cmpl 0xffffffe8(fp),$0x00008000
   13cc1:	00 80 00 00 
   13cc5:	12 03       	bneq 13cca <__dtoa+0x44>
   13cc7:	31 6c 09    	brw 14636 <__dtoa+0x9b0>
   13cca:	70 ad e8 50 	movd 0xffffffe8(fp),r0
   13cce:	7c 59       	clrd r9
   13cd0:	71 50 59    	cmpd r0,r9
   13cd3:	12 37       	bneq 13d0c <__dtoa+0x86>
   13cd5:	d0 ad 9c 51 	movl 0xffffff9c(fp),r1
   13cd9:	d0 01 61    	movl $0x1,(r1)
   13cdc:	dd 01       	pushl $0x1
   13cde:	dd ad 98    	pushl 0xffffff98(fp)
   13ce1:	9f ef 0a 78 	pushab 2b4f1 <_sys_errlist+0x181>
   13ce5:	01 00 
   13ce7:	fb 03 ef 9a 	calls $0x3,14688 <__nrv_alloc_D2A>
   13ceb:	09 00 00 
   13cee:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   13cf2:	d1 51 ef 9f 	cmpl r1,3bf98 <__guard_local>
   13cf6:	82 02 00 
   13cf9:	13 10       	beql 13d0b <__dtoa+0x85>
   13cfb:	dd ad f8    	pushl 0xfffffff8(fp)
   13cfe:	9f ef f8 6e 	pushab 2abfc <sigfigs.0+0x4>
   13d02:	01 00 
   13d04:	fb 02 ef 61 	calls $0x2,1666c <__stack_smash_handler>
   13d08:	29 00 00 
   13d0b:	04          	ret
   13d0c:	9f ad f4    	pushab 0xfffffff4(fp)
   13d0f:	9f ad f0    	pushab 0xfffffff0(fp)
   13d12:	70 50 7e    	movd r0,-(sp)
   13d15:	fb 04 ef 88 	calls $0x4,150a4 <__d2b_D2A>
   13d19:	13 00 00 
   13d1c:	d0 50 ad b8 	movl r0,0xffffffb8(fp)
   13d20:	12 03       	bneq 13d25 <__dtoa+0x9f>
   13d22:	31 3f 05    	brw 14264 <__dtoa+0x5de>
   13d25:	ef 07 08 ad 	extzv $0x7,$0x8,0xffffffe8(fp),r8
   13d29:	e8 58 
   13d2b:	7d ad e8 ad 	movq 0xffffffe8(fp),0xffffffa4(fp)
   13d2f:	a4 
   13d30:	cb 8f 80 ff 	bicl3 $0x0000ff80,0xffffffa4(fp),r0
   13d34:	00 00 ad a4 
   13d38:	50 
   13d39:	d0 50 ad a4 	movl r0,0xffffffa4(fp)
   13d3d:	c9 8f 80 40 	bisl3 $0x00004080,r0,0xffffffa4(fp)
   13d41:	00 00 50 ad 
   13d45:	a4 
   13d46:	9e c8 7f ff 	movab 0xffffff7f(r8),r8
   13d4a:	58 
   13d4b:	63 0c ad a4 	subd3 $0xc [d-float],0xffffffa4(fp),r2
   13d4f:	52 
   13d50:	64 8f 94 3f 	muld2 $0x1b071b7a3d3b3f94 [d-float],r2
   13d54:	3b 3d 7a 1b 
   13d58:	07 1b 52 
   13d5b:	60 8f 34 3f 	addd2 $0x45975b0651443f34 [d-float],r2
   13d5f:	44 51 06 5b 
   13d63:	97 45 52 
   13d66:	6e 58 50    	cvtld r8,r0
   13d69:	64 8f 9a 3f 	muld2 $0xcfdb84fb209a3f9a [d-float],r0
   13d6d:	9a 20 fb 84 
   13d71:	db cf 50 
   13d74:	61 52 50 55 	addd3 r2,r0,r5
   13d78:	6a 55 ad d0 	cvtdl r5,0xffffffd0(fp)
   13d7c:	71 55 59    	cmpd r5,r9
   13d7f:	18 0c       	bgeq 13d8d <__dtoa+0x107>
   13d81:	6e ad d0 50 	cvtld 0xffffffd0(fp),r0
   13d85:	71 55 50    	cmpd r5,r0
   13d88:	13 03       	beql 13d8d <__dtoa+0x107>
   13d8a:	d7 ad d0    	decl 0xffffffd0(fp)
   13d8d:	d0 01 ad c8 	movl $0x1,0xffffffc8(fp)
   13d91:	d1 ad d0 18 	cmpl 0xffffffd0(fp),$0x18
   13d95:	1a 17       	bgtru 13dae <__dtoa+0x128>
   13d97:	d0 ad d0 52 	movl 0xffffffd0(fp),r2
   13d9b:	71 ad e8 42 	cmpd 0xffffffe8(fp),2ac28 <__tens_D2A>[r2]
   13d9f:	ef 84 6e 01 
   13da3:	00 
   13da4:	18 05       	bgeq 13dab <__dtoa+0x125>
   13da6:	c3 01 52 ad 	subl3 $0x1,r2,0xffffffd0(fp)
   13daa:	d0 
   13dab:	d4 ad c8    	clrf 0xffffffc8(fp)
   13dae:	c3 58 ad f4 	subl3 r8,0xfffffff4(fp),r0
   13db2:	50 
   13db3:	c3 01 50 57 	subl3 $0x1,r0,r7
   13db7:	18 03       	bgeq 13dbc <__dtoa+0x136>
   13db9:	31 70 08    	brw 1462c <__dtoa+0x9a6>
   13dbc:	d4 ad e4    	clrf 0xffffffe4(fp)
   13dbf:	d0 57 ad c0 	movl r7,0xffffffc0(fp)
   13dc3:	d5 ad d0    	tstl 0xffffffd0(fp)
   13dc6:	18 03       	bgeq 13dcb <__dtoa+0x145>
   13dc8:	31 51 08    	brw 1461c <__dtoa+0x996>
   13dcb:	d4 ad e0    	clrf 0xffffffe0(fp)
   13dce:	d0 ad d0 ad 	movl 0xffffffd0(fp),0xffffffbc(fp)
   13dd2:	bc 
   13dd3:	c0 ad d0 ad 	addl2 0xffffffd0(fp),0xffffffc0(fp)
   13dd7:	c0 
   13dd8:	d1 ac 0c 09 	cmpl 0xc(ap),$0x9
   13ddc:	1b 03       	blequ 13de1 <__dtoa+0x15b>
   13dde:	d4 ac 0c    	clrf 0xc(ap)
   13de1:	d0 01 56    	movl $0x1,r6
   13de4:	d1 ac 0c 05 	cmpl 0xc(ap),$0x5
   13de8:	15 06       	bleq 13df0 <__dtoa+0x16a>
   13dea:	c2 04 ac 0c 	subl2 $0x4,0xc(ap)
   13dee:	d4 56       	clrf r6
   13df0:	d0 01 ad c4 	movl $0x1,0xffffffc4(fp)
   13df4:	d2 00 ad dc 	mcoml $0x0,0xffffffdc(fp)
   13df8:	d0 ad dc ad 	movl 0xffffffdc(fp),0xffffffd4(fp)
   13dfc:	d4 
   13dfd:	d1 ac 0c 05 	cmpl 0xc(ap),$0x5
   13e01:	1a 17       	bgtru 13e1a <__dtoa+0x194>
   13e03:	cf ac 0c 00 	casel 0xc(ap),$0x0,$0x5
   13e07:	05 
   13e08:	0c 00 0c 00 	prober $0x0,$0xc,$0x0
   13e0c:	d5 07       	tstl $0x7
   13e0e:	f2 07 d8 07 	aoblss $0x7,*0xfffff507(r8),13e1b <__dtoa+0x195>
   13e12:	f5 07 
   13e14:	d0 12 58    	movl $0x12,r8
   13e17:	d4 ac 10    	clrf 0x10(ap)
   13e1a:	dd 58       	pushl r8
   13e1c:	fb 01 ef 2f 	calls $0x1,14652 <__rv_alloc_D2A>
   13e20:	08 00 00 
   13e23:	d0 50 ad a0 	movl r0,0xffffffa0(fp)
   13e27:	d0 50 5b    	movl r0,r11
   13e2a:	12 03       	bneq 13e2f <__dtoa+0x1a9>
   13e2c:	31 35 04    	brw 14264 <__dtoa+0x5de>
   13e2f:	d1 ad dc 0f 	cmpl 0xffffffdc(fp),$0xf
   13e33:	1b 03       	blequ 13e38 <__dtoa+0x1b2>
   13e35:	31 ee 00    	brw 13f26 <__dtoa+0x2a0>
   13e38:	d5 56       	tstl r6
   13e3a:	12 03       	bneq 13e3f <__dtoa+0x1b9>
   13e3c:	31 e7 00    	brw 13f26 <__dtoa+0x2a0>
   13e3f:	d4 58       	clrf r8
   13e41:	70 ad e8 52 	movd 0xffffffe8(fp),r2
   13e45:	70 52 ad a4 	movd r2,0xffffffa4(fp)
   13e49:	d0 ad d0 ad 	movl 0xffffffd0(fp),0xffffffcc(fp)
   13e4d:	cc 
   13e4e:	d0 ad dc ad 	movl 0xffffffdc(fp),0xffffffd8(fp)
   13e52:	d8 
   13e53:	d0 02 51    	movl $0x2,r1
   13e56:	d5 ad d0    	tstl 0xffffffd0(fp)
   13e59:	14 03       	bgtr 13e5e <__dtoa+0x1d8>
   13e5b:	31 39 07    	brw 14597 <__dtoa+0x911>
   13e5e:	cb 8f f0 ff 	bicl3 $0xfffffff0,0xffffffd0(fp),r0
   13e62:	ff ff ad d0 
   13e66:	50 
   13e67:	70 40 ef ba 	movd 2ac28 <__tens_D2A>[r0],r5
   13e6b:	6d 01 00 55 
   13e6f:	78 8f fc ad 	ashl $0xfc,0xffffffd0(fp),r7
   13e73:	d0 57 
   13e75:	e1 01 57 13 	bbc $0x1,r7,13e8c <__dtoa+0x206>
   13e79:	ca 8f fe ff 	bicl2 $0xfffffffe,r7
   13e7d:	ff ff 57 
   13e80:	67 ef 8a 6d 	divd3 2ac10 <__bigtens_D2A+0x8>,r2,0xffffffe8(fp)
   13e84:	01 00 52 ad 
   13e88:	e8 
   13e89:	d0 03 51    	movl $0x3,r1
   13e8c:	d5 57       	tstl r7
   13e8e:	13 18       	beql 13ea8 <__dtoa+0x222>
   13e90:	e9 57 0a    	blbc r7,13e9d <__dtoa+0x217>
   13e93:	d6 51       	incl r1
   13e95:	64 48 ef 6c 	muld2 2ac08 <__bigtens_D2A>[r8],r5
   13e99:	6d 01 00 55 
   13e9d:	78 8f ff 57 	ashl $0xff,r7,r7
   13ea1:	57 
   13ea2:	d6 58       	incl r8
   13ea4:	d5 57       	tstl r7
   13ea6:	12 e8       	bneq 13e90 <__dtoa+0x20a>
   13ea8:	66 55 ad e8 	divd2 r5,0xffffffe8(fp)
   13eac:	d5 ad c8    	tstl 0xffffffc8(fp)
   13eaf:	13 22       	beql 13ed3 <__dtoa+0x24d>
   13eb1:	70 ad e8 52 	movd 0xffffffe8(fp),r2
   13eb5:	71 52 08    	cmpd r2,$0x8 [d-float]
   13eb8:	18 19       	bgeq 13ed3 <__dtoa+0x24d>
   13eba:	d5 ad dc    	tstl 0xffffffdc(fp)
   13ebd:	15 14       	bleq 13ed3 <__dtoa+0x24d>
   13ebf:	d5 ad d4    	tstl 0xffffffd4(fp)
   13ec2:	15 4f       	bleq 13f13 <__dtoa+0x28d>
   13ec4:	d0 ad d4 ad 	movl 0xffffffd4(fp),0xffffffdc(fp)
   13ec8:	dc 
   13ec9:	d7 ad d0    	decl 0xffffffd0(fp)
   13ecc:	65 52 22 ad 	muld3 r2,$0x22 [d-float],0xffffffe8(fp)
   13ed0:	e8 
   13ed1:	d6 51       	incl r1
   13ed3:	6e 51 50    	cvtld r1,r0
   13ed6:	70 ad e8 52 	movd 0xffffffe8(fp),r2
   13eda:	64 52 50    	muld2 r2,r0
   13edd:	60 1e 50    	addd2 $0x1e [d-float],r0
   13ee0:	70 50 59    	movd r0,r9
   13ee3:	9e c0 80 e4 	movab 0xffffe480(r0),r9
   13ee7:	59 
   13ee8:	d5 ad dc    	tstl 0xffffffdc(fp)
   13eeb:	13 03       	beql 13ef0 <__dtoa+0x26a>
   13eed:	31 e1 05    	brw 144d1 <__dtoa+0x84b>
   13ef0:	d4 ad b0    	clrf 0xffffffb0(fp)
   13ef3:	d4 ad ac    	clrf 0xffffffac(fp)
   13ef6:	62 1a 52    	subd2 $0x1a [d-float],r2
   13ef9:	70 52 ad e8 	movd r2,0xffffffe8(fp)
   13efd:	70 59 50    	movd r9,r0
   13f00:	71 52 50    	cmpd r2,r0
   13f03:	15 03       	bleq 13f08 <__dtoa+0x282>
   13f05:	31 21 01    	brw 14029 <__dtoa+0x3a3>
   13f08:	72 50 50    	mnegd r0,r0
   13f0b:	71 52 50    	cmpd r2,r0
   13f0e:	18 03       	bgeq 13f13 <__dtoa+0x28d>
   13f10:	31 e0 00    	brw 13ff3 <__dtoa+0x36d>
   13f13:	d0 ad a0 5b 	movl 0xffffffa0(fp),r11
   13f17:	70 ad a4 ad 	movd 0xffffffa4(fp),0xffffffe8(fp)
   13f1b:	e8 
   13f1c:	d0 ad cc ad 	movl 0xffffffcc(fp),0xffffffd0(fp)
   13f20:	d0 
   13f21:	d0 ad d8 ad 	movl 0xffffffd8(fp),0xffffffdc(fp)
   13f25:	dc 
   13f26:	d5 ad f0    	tstl 0xfffffff0(fp)
   13f29:	18 03       	bgeq 13f2e <__dtoa+0x2a8>
   13f2b:	31 03 01    	brw 14031 <__dtoa+0x3ab>
   13f2e:	d1 ad d0 0f 	cmpl 0xffffffd0(fp),$0xf
   13f32:	15 03       	bleq 13f37 <__dtoa+0x2b1>
   13f34:	31 fa 00    	brw 14031 <__dtoa+0x3ab>
   13f37:	d0 ad d0 50 	movl 0xffffffd0(fp),r0
   13f3b:	70 40 ef e6 	movd 2ac28 <__tens_D2A>[r0],r5
   13f3f:	6c 01 00 55 
   13f43:	d5 ac 10    	tstl 0x10(ap)
   13f46:	18 03       	bgeq 13f4b <__dtoa+0x2c5>
   13f48:	31 8b 00    	brw 13fd6 <__dtoa+0x350>
   13f4b:	d0 01 58    	movl $0x1,r8
   13f4e:	70 ad e8 52 	movd 0xffffffe8(fp),r2
   13f52:	67 55 52 50 	divd3 r5,r2,r0
   13f56:	6a 50 54    	cvtdl r0,r4
   13f59:	6e 54 50    	cvtld r4,r0
   13f5c:	64 55 50    	muld2 r5,r0
   13f5f:	63 50 52 ad 	subd3 r0,r2,0xffffffe8(fp)
   13f63:	e8 
   13f64:	81 54 30 8b 	addb3 r4,$0x30,(r11)+
   13f68:	70 ad e8 50 	movd 0xffffffe8(fp),r0
   13f6c:	13 27       	beql 13f95 <__dtoa+0x30f>
   13f6e:	d1 58 ad dc 	cmpl r8,0xffffffdc(fp)
   13f72:	13 09       	beql 13f7d <__dtoa+0x2f7>
   13f74:	d6 58       	incl r8
   13f76:	65 50 22 ad 	muld3 r0,$0x22 [d-float],0xffffffe8(fp)
   13f7a:	e8 
   13f7b:	11 d1       	brb 13f4e <__dtoa+0x2c8>
   13f7d:	60 50 50    	addd2 r0,r0
   13f80:	70 50 ad e8 	movd r0,0xffffffe8(fp)
   13f84:	71 50 55    	cmpd r0,r5
   13f87:	19 0c       	blss 13f95 <__dtoa+0x30f>
   13f89:	91 7b 39    	cmpb -(r11),$0x39
   13f8c:	13 2f       	beql 13fbd <__dtoa+0x337>
   13f8e:	d0 5b 50    	movl r11,r0
   13f91:	d6 5b       	incl r11
   13f93:	96 60       	incb (r0)
   13f95:	dd ad b8    	pushl 0xffffffb8(fp)
   13f98:	fb 01 ef b5 	calls $0x1,14954 <__Bfree_D2A>
   13f9c:	09 00 00 
   13f9f:	94 6b       	clrb (r11)
   13fa1:	d0 ad 9c 51 	movl 0xffffff9c(fp),r1
   13fa5:	c1 ad d0 01 	addl3 0xffffffd0(fp),$0x1,(r1)
   13fa9:	61 
   13faa:	d5 ad 98    	tstl 0xffffff98(fp)
   13fad:	13 07       	beql 13fb6 <__dtoa+0x330>
   13faf:	d0 ad 98 52 	movl 0xffffff98(fp),r2
   13fb3:	d0 5b 62    	movl r11,(r2)
   13fb6:	d0 ad a0 50 	movl 0xffffffa0(fp),r0
   13fba:	31 31 fd    	brw 13cee <__dtoa+0x68>
   13fbd:	d1 5b ad a0 	cmpl r11,0xffffffa0(fp)
   13fc1:	13 07       	beql 13fca <__dtoa+0x344>
   13fc3:	91 7b 39    	cmpb -(r11),$0x39
   13fc6:	13 f5       	beql 13fbd <__dtoa+0x337>
   13fc8:	11 c4       	brb 13f8e <__dtoa+0x308>
   13fca:	d6 ad d0    	incl 0xffffffd0(fp)
   13fcd:	d0 ad a0 51 	movl 0xffffffa0(fp),r1
   13fd1:	90 30 61    	movb $0x30,(r1)
   13fd4:	11 b8       	brb 13f8e <__dtoa+0x308>
   13fd6:	d5 ad dc    	tstl 0xffffffdc(fp)
   13fd9:	15 03       	bleq 13fde <__dtoa+0x358>
   13fdb:	31 6d ff    	brw 13f4b <__dtoa+0x2c5>
   13fde:	d4 ad b0    	clrf 0xffffffb0(fp)
   13fe1:	d4 ad ac    	clrf 0xffffffac(fp)
   13fe4:	d5 ad dc    	tstl 0xffffffdc(fp)
   13fe7:	19 0a       	blss 13ff3 <__dtoa+0x36d>
   13fe9:	65 55 1a 50 	muld3 r5,$0x1a [d-float],r0
   13fed:	71 ad e8 50 	cmpd 0xffffffe8(fp),r0
   13ff1:	14 36       	bgtr 14029 <__dtoa+0x3a3>
   13ff3:	d2 ac 10 ad 	mcoml 0x10(ap),0xffffffd0(fp)
   13ff7:	d0 
   13ff8:	dd ad ac    	pushl 0xffffffac(fp)
   13ffb:	9e ef 53 09 	movab 14954 <__Bfree_D2A>,r6
   13fff:	00 00 56 
   14002:	fb 01 66    	calls $0x1,(r6)
   14005:	d5 ad b0    	tstl 0xffffffb0(fp)
   14008:	13 8b       	beql 13f95 <__dtoa+0x30f>
   1400a:	d5 ad b4    	tstl 0xffffffb4(fp)
   1400d:	13 0d       	beql 1401c <__dtoa+0x396>
   1400f:	d1 ad b4 ad 	cmpl 0xffffffb4(fp),0xffffffb0(fp)
   14013:	b0 
   14014:	13 06       	beql 1401c <__dtoa+0x396>
   14016:	dd ad b4    	pushl 0xffffffb4(fp)
   14019:	fb 01 66    	calls $0x1,(r6)
   1401c:	dd ad b0    	pushl 0xffffffb0(fp)
   1401f:	fb 01 ef 2e 	calls $0x1,14954 <__Bfree_D2A>
   14023:	09 00 00 
   14026:	31 6c ff    	brw 13f95 <__dtoa+0x30f>
   14029:	90 31 8b    	movb $0x31,(r11)+
   1402c:	d6 ad d0    	incl 0xffffffd0(fp)
   1402f:	11 c7       	brb 13ff8 <__dtoa+0x372>
   14031:	d0 ad e4 59 	movl 0xffffffe4(fp),r9
   14035:	d0 ad e0 57 	movl 0xffffffe0(fp),r7
   14039:	d4 ad b4    	clrf 0xffffffb4(fp)
   1403c:	d4 ad b0    	clrf 0xffffffb0(fp)
   1403f:	d5 ad c4    	tstl 0xffffffc4(fp)
   14042:	13 03       	beql 14047 <__dtoa+0x3c1>
   14044:	31 67 04    	brw 144ae <__dtoa+0x828>
   14047:	d5 59       	tstl r9
   14049:	15 1c       	bleq 14067 <__dtoa+0x3e1>
   1404b:	d5 ad c0    	tstl 0xffffffc0(fp)
   1404e:	15 17       	bleq 14067 <__dtoa+0x3e1>
   14050:	d0 ad c0 58 	movl 0xffffffc0(fp),r8
   14054:	d1 58 59    	cmpl r8,r9
   14057:	15 03       	bleq 1405c <__dtoa+0x3d6>
   14059:	d0 59 58    	movl r9,r8
   1405c:	c2 58 ad e4 	subl2 r8,0xffffffe4(fp)
   14060:	c2 58 59    	subl2 r8,r9
   14063:	c2 58 ad c0 	subl2 r8,0xffffffc0(fp)
   14067:	d5 ad e0    	tstl 0xffffffe0(fp)
   1406a:	15 4e       	bleq 140ba <__dtoa+0x434>
   1406c:	d5 ad c4    	tstl 0xffffffc4(fp)
   1406f:	12 03       	bneq 14074 <__dtoa+0x3ee>
   14071:	31 35 04    	brw 144a9 <__dtoa+0x823>
   14074:	d5 57       	tstl r7
   14076:	15 38       	bleq 140b0 <__dtoa+0x42a>
   14078:	dd 57       	pushl r7
   1407a:	dd ad b0    	pushl 0xffffffb0(fp)
   1407d:	fb 02 ef 18 	calls $0x2,14c9c <__pow5mult_D2A>
   14081:	0c 00 00 
   14084:	d0 50 ad b0 	movl r0,0xffffffb0(fp)
   14088:	12 03       	bneq 1408d <__dtoa+0x407>
   1408a:	31 d7 01    	brw 14264 <__dtoa+0x5de>
   1408d:	dd ad b8    	pushl 0xffffffb8(fp)
   14090:	dd ad b0    	pushl 0xffffffb0(fp)
   14093:	fb 02 ef f6 	calls $0x2,14b90 <__mult_D2A>
   14097:	0a 00 00 
   1409a:	d0 50 56    	movl r0,r6
   1409d:	12 03       	bneq 140a2 <__dtoa+0x41c>
   1409f:	31 c2 01    	brw 14264 <__dtoa+0x5de>
   140a2:	dd ad b8    	pushl 0xffffffb8(fp)
   140a5:	fb 01 ef a8 	calls $0x1,14954 <__Bfree_D2A>
   140a9:	08 00 00 
   140ac:	d0 56 ad b8 	movl r6,0xffffffb8(fp)
   140b0:	c3 57 ad e0 	subl3 r7,0xffffffe0(fp),r7
   140b4:	57 
   140b5:	13 03       	beql 140ba <__dtoa+0x434>
   140b7:	31 d7 03    	brw 14491 <__dtoa+0x80b>
   140ba:	dd 01       	pushl $0x1
   140bc:	fb 01 ef ad 	calls $0x1,14b70 <__i2b_D2A>
   140c0:	0a 00 00 
   140c3:	d0 50 ad ac 	movl r0,0xffffffac(fp)
   140c7:	12 03       	bneq 140cc <__dtoa+0x446>
   140c9:	31 98 01    	brw 14264 <__dtoa+0x5de>
   140cc:	d5 ad bc    	tstl 0xffffffbc(fp)
   140cf:	15 16       	bleq 140e7 <__dtoa+0x461>
   140d1:	dd ad bc    	pushl 0xffffffbc(fp)
   140d4:	dd ad ac    	pushl 0xffffffac(fp)
   140d7:	fb 02 ef be 	calls $0x2,14c9c <__pow5mult_D2A>
   140db:	0b 00 00 
   140de:	d0 50 ad ac 	movl r0,0xffffffac(fp)
   140e2:	12 03       	bneq 140e7 <__dtoa+0x461>
   140e4:	31 7d 01    	brw 14264 <__dtoa+0x5de>
   140e7:	d4 56       	clrf r6
   140e9:	d1 ac 0c 01 	cmpl 0xc(ap),$0x1
   140ed:	15 05       	bleq 140f4 <__dtoa+0x46e>
   140ef:	d5 ad c4    	tstl 0xffffffc4(fp)
   140f2:	13 18       	beql 1410c <__dtoa+0x486>
   140f4:	d5 ad ec    	tstl 0xffffffec(fp)
   140f7:	12 13       	bneq 1410c <__dtoa+0x486>
   140f9:	d3 ad e8 8f 	bitl 0xffffffe8(fp),$0xffff007f
   140fd:	7f 00 ff ff 
   14101:	12 09       	bneq 1410c <__dtoa+0x486>
   14103:	d6 ad e4    	incl 0xffffffe4(fp)
   14106:	d6 ad c0    	incl 0xffffffc0(fp)
   14109:	d0 01 56    	movl $0x1,r6
   1410c:	d5 ad bc    	tstl 0xffffffbc(fp)
   1410f:	13 03       	beql 14114 <__dtoa+0x48e>
   14111:	31 62 03    	brw 14476 <__dtoa+0x7f0>
   14114:	c1 ad c0 01 	addl3 0xffffffc0(fp),$0x1,r0
   14118:	50 
   14119:	cb 8f e0 ff 	bicl3 $0xffffffe0,r0,r8
   1411d:	ff ff 50 58 
   14121:	13 04       	beql 14127 <__dtoa+0x4a1>
   14123:	c3 58 20 58 	subl3 r8,$0x20,r8
   14127:	d1 58 04    	cmpl r8,$0x4
   1412a:	14 03       	bgtr 1412f <__dtoa+0x4a9>
   1412c:	31 39 03    	brw 14468 <__dtoa+0x7e2>
   1412f:	c2 04 58    	subl2 $0x4,r8
   14132:	c0 58 ad e4 	addl2 r8,0xffffffe4(fp)
   14136:	c0 58 59    	addl2 r8,r9
   14139:	c0 58 ad c0 	addl2 r8,0xffffffc0(fp)
   1413d:	d5 ad e4    	tstl 0xffffffe4(fp)
   14140:	15 16       	bleq 14158 <__dtoa+0x4d2>
   14142:	dd ad e4    	pushl 0xffffffe4(fp)
   14145:	dd ad b8    	pushl 0xffffffb8(fp)
   14148:	fb 02 ef 75 	calls $0x2,14dc4 <__lshift_D2A>
   1414c:	0c 00 00 
   1414f:	d0 50 ad b8 	movl r0,0xffffffb8(fp)
   14153:	12 03       	bneq 14158 <__dtoa+0x4d2>
   14155:	31 0c 01    	brw 14264 <__dtoa+0x5de>
   14158:	d5 ad c0    	tstl 0xffffffc0(fp)
   1415b:	15 16       	bleq 14173 <__dtoa+0x4ed>
   1415d:	dd ad c0    	pushl 0xffffffc0(fp)
   14160:	dd ad ac    	pushl 0xffffffac(fp)
   14163:	fb 02 ef 5a 	calls $0x2,14dc4 <__lshift_D2A>
   14167:	0c 00 00 
   1416a:	d0 50 ad ac 	movl r0,0xffffffac(fp)
   1416e:	12 03       	bneq 14173 <__dtoa+0x4ed>
   14170:	31 f1 00    	brw 14264 <__dtoa+0x5de>
   14173:	d5 ad c8    	tstl 0xffffffc8(fp)
   14176:	13 03       	beql 1417b <__dtoa+0x4f5>
   14178:	31 9c 02    	brw 14417 <__dtoa+0x791>
   1417b:	d5 ad dc    	tstl 0xffffffdc(fp)
   1417e:	14 03       	bgtr 14183 <__dtoa+0x4fd>
   14180:	31 4f 02    	brw 143d2 <__dtoa+0x74c>
   14183:	d5 ad c4    	tstl 0xffffffc4(fp)
   14186:	12 03       	bneq 1418b <__dtoa+0x505>
   14188:	31 f8 01    	brw 14383 <__dtoa+0x6fd>
   1418b:	d5 59       	tstl r9
   1418d:	15 15       	bleq 141a4 <__dtoa+0x51e>
   1418f:	dd 59       	pushl r9
   14191:	dd ad b0    	pushl 0xffffffb0(fp)
   14194:	fb 02 ef 29 	calls $0x2,14dc4 <__lshift_D2A>
   14198:	0c 00 00 
   1419b:	d0 50 ad b0 	movl r0,0xffffffb0(fp)
   1419f:	12 03       	bneq 141a4 <__dtoa+0x51e>
   141a1:	31 c0 00    	brw 14264 <__dtoa+0x5de>
   141a4:	d0 ad b0 ad 	movl 0xffffffb0(fp),0xffffffb4(fp)
   141a8:	b4 
   141a9:	d5 56       	tstl r6
   141ab:	13 03       	beql 141b0 <__dtoa+0x52a>
   141ad:	31 89 01    	brw 14339 <__dtoa+0x6b3>
   141b0:	d0 01 58    	movl $0x1,r8
   141b3:	dd ad ac    	pushl 0xffffffac(fp)
   141b6:	dd ad b8    	pushl 0xffffffb8(fp)
   141b9:	fb 02 ef 2a 	calls $0x2,146ea <__quorem_D2A>
   141bd:	05 00 00 
   141c0:	c1 50 30 5a 	addl3 r0,$0x30,r10
   141c4:	dd ad b4    	pushl 0xffffffb4(fp)
   141c7:	dd ad b8    	pushl 0xffffffb8(fp)
   141ca:	9e ef a0 0c 	movab 14e70 <__cmp_D2A>,r9
   141ce:	00 00 59 
   141d1:	fb 02 69    	calls $0x2,(r9)
   141d4:	d0 50 57    	movl r0,r7
   141d7:	dd ad b0    	pushl 0xffffffb0(fp)
   141da:	dd ad ac    	pushl 0xffffffac(fp)
   141dd:	fb 02 ef da 	calls $0x2,14ebe <__diff_D2A>
   141e1:	0c 00 00 
   141e4:	d0 50 56    	movl r0,r6
   141e7:	13 7b       	beql 14264 <__dtoa+0x5de>
   141e9:	d5 a0 0c    	tstl 0xc(r0)
   141ec:	12 03       	bneq 141f1 <__dtoa+0x56b>
   141ee:	31 3a 01    	brw 1432b <__dtoa+0x6a5>
   141f1:	d0 01 59    	movl $0x1,r9
   141f4:	dd 56       	pushl r6
   141f6:	fb 01 ef 57 	calls $0x1,14954 <__Bfree_D2A>
   141fa:	07 00 00 
   141fd:	d5 57       	tstl r7
   141ff:	18 03       	bgeq 14204 <__dtoa+0x57e>
   14201:	31 e1 00    	brw 142e5 <__dtoa+0x65f>
   14204:	12 09       	bneq 1420f <__dtoa+0x589>
   14206:	d1 ac 0c 01 	cmpl 0xc(ap),$0x1
   1420a:	13 03       	beql 1420f <__dtoa+0x589>
   1420c:	31 d6 00    	brw 142e5 <__dtoa+0x65f>
   1420f:	d5 59       	tstl r9
   14211:	15 03       	bleq 14216 <__dtoa+0x590>
   14213:	31 be 00    	brw 142d4 <__dtoa+0x64e>
   14216:	90 5a 8b    	movb r10,(r11)+
   14219:	d1 58 ad dc 	cmpl r8,0xffffffdc(fp)
   1421d:	13 5e       	beql 1427d <__dtoa+0x5f7>
   1421f:	d4 7e       	clrf -(sp)
   14221:	dd 0a       	pushl $0xa
   14223:	dd ad b8    	pushl 0xffffffb8(fp)
   14226:	9e ef 14 08 	movab 14a40 <__multadd_D2A>,r6
   1422a:	00 00 56 
   1422d:	fb 03 66    	calls $0x3,(r6)
   14230:	d0 50 ad b8 	movl r0,0xffffffb8(fp)
   14234:	13 2e       	beql 14264 <__dtoa+0x5de>
   14236:	d1 ad b4 ad 	cmpl 0xffffffb4(fp),0xffffffb0(fp)
   1423a:	b0 
   1423b:	13 2c       	beql 14269 <__dtoa+0x5e3>
   1423d:	d4 7e       	clrf -(sp)
   1423f:	dd 0a       	pushl $0xa
   14241:	dd ad b4    	pushl 0xffffffb4(fp)
   14244:	fb 03 66    	calls $0x3,(r6)
   14247:	d0 50 ad b4 	movl r0,0xffffffb4(fp)
   1424b:	13 17       	beql 14264 <__dtoa+0x5de>
   1424d:	d4 7e       	clrf -(sp)
   1424f:	dd 0a       	pushl $0xa
   14251:	dd ad b0    	pushl 0xffffffb0(fp)
   14254:	fb 03 66    	calls $0x3,(r6)
   14257:	d0 50 ad b0 	movl r0,0xffffffb0(fp)
   1425b:	d5 50       	tstl r0
   1425d:	13 05       	beql 14264 <__dtoa+0x5de>
   1425f:	d6 58       	incl r8
   14261:	31 4f ff    	brw 141b3 <__dtoa+0x52d>
   14264:	d4 50       	clrf r0
   14266:	31 85 fa    	brw 13cee <__dtoa+0x68>
   14269:	d4 7e       	clrf -(sp)
   1426b:	dd 0a       	pushl $0xa
   1426d:	dd ad b0    	pushl 0xffffffb0(fp)
   14270:	fb 03 66    	calls $0x3,(r6)
   14273:	d0 50 ad b0 	movl r0,0xffffffb0(fp)
   14277:	d0 50 ad b4 	movl r0,0xffffffb4(fp)
   1427b:	11 de       	brb 1425b <__dtoa+0x5d5>
   1427d:	dd 01       	pushl $0x1
   1427f:	dd ad b8    	pushl 0xffffffb8(fp)
   14282:	fb 02 ef 3b 	calls $0x2,14dc4 <__lshift_D2A>
   14286:	0b 00 00 
   14289:	d0 50 ad b8 	movl r0,0xffffffb8(fp)
   1428d:	13 d5       	beql 14264 <__dtoa+0x5de>
   1428f:	dd ad ac    	pushl 0xffffffac(fp)
   14292:	dd ad b8    	pushl 0xffffffb8(fp)
   14295:	fb 02 ef d4 	calls $0x2,14e70 <__cmp_D2A>
   14299:	0b 00 00 
   1429c:	d0 50 57    	movl r0,r7
   1429f:	19 29       	blss 142ca <__dtoa+0x644>
   142a1:	91 7b 39    	cmpb -(r11),$0x39
   142a4:	13 0a       	beql 142b0 <__dtoa+0x62a>
   142a6:	d0 5b 50    	movl r11,r0
   142a9:	d6 5b       	incl r11
   142ab:	96 60       	incb (r0)
   142ad:	31 48 fd    	brw 13ff8 <__dtoa+0x372>
   142b0:	d1 5b ad a0 	cmpl r11,0xffffffa0(fp)
   142b4:	13 07       	beql 142bd <__dtoa+0x637>
   142b6:	91 7b 39    	cmpb -(r11),$0x39
   142b9:	13 f5       	beql 142b0 <__dtoa+0x62a>
   142bb:	11 e9       	brb 142a6 <__dtoa+0x620>
   142bd:	d6 ad d0    	incl 0xffffffd0(fp)
   142c0:	d0 ad a0 5b 	movl 0xffffffa0(fp),r11
   142c4:	90 31 8b    	movb $0x31,(r11)+
   142c7:	31 2e fd    	brw 13ff8 <__dtoa+0x372>
   142ca:	91 7b 30    	cmpb -(r11),$0x30
   142cd:	13 fb       	beql 142ca <__dtoa+0x644>
   142cf:	d6 5b       	incl r11
   142d1:	31 24 fd    	brw 13ff8 <__dtoa+0x372>
   142d4:	d1 5a 39    	cmpl r10,$0x39
   142d7:	13 07       	beql 142e0 <__dtoa+0x65a>
   142d9:	81 5a 01 8b 	addb3 r10,$0x1,(r11)+
   142dd:	31 18 fd    	brw 13ff8 <__dtoa+0x372>
   142e0:	90 39 8b    	movb $0x39,(r11)+
   142e3:	11 bc       	brb 142a1 <__dtoa+0x61b>
   142e5:	d0 ad b8 52 	movl 0xffffffb8(fp),r2
   142e9:	d5 a2 14    	tstl 0x14(r2)
   142ec:	12 06       	bneq 142f4 <__dtoa+0x66e>
   142ee:	d1 a2 10 01 	cmpl 0x10(r2),$0x1
   142f2:	15 31       	bleq 14325 <__dtoa+0x69f>
   142f4:	d5 59       	tstl r9
   142f6:	15 2d       	bleq 14325 <__dtoa+0x69f>
   142f8:	dd 01       	pushl $0x1
   142fa:	dd ad b8    	pushl 0xffffffb8(fp)
   142fd:	fb 02 ef c0 	calls $0x2,14dc4 <__lshift_D2A>
   14301:	0a 00 00 
   14304:	d0 50 ad b8 	movl r0,0xffffffb8(fp)
   14308:	12 03       	bneq 1430d <__dtoa+0x687>
   1430a:	31 57 ff    	brw 14264 <__dtoa+0x5de>
   1430d:	dd ad ac    	pushl 0xffffffac(fp)
   14310:	dd 50       	pushl r0
   14312:	fb 02 ef 57 	calls $0x2,14e70 <__cmp_D2A>
   14316:	0b 00 00 
   14319:	d0 50 59    	movl r0,r9
   1431c:	19 07       	blss 14325 <__dtoa+0x69f>
   1431e:	d6 5a       	incl r10
   14320:	d1 5a 3a    	cmpl r10,$0x3a
   14323:	13 bb       	beql 142e0 <__dtoa+0x65a>
   14325:	90 5a 8b    	movb r10,(r11)+
   14328:	31 cd fc    	brw 13ff8 <__dtoa+0x372>
   1432b:	dd 50       	pushl r0
   1432d:	dd ad b8    	pushl 0xffffffb8(fp)
   14330:	fb 02 69    	calls $0x2,(r9)
   14333:	d0 50 59    	movl r0,r9
   14336:	31 bb fe    	brw 141f4 <__dtoa+0x56e>
   14339:	d0 ad b0 50 	movl 0xffffffb0(fp),r0
   1433d:	dd a0 04    	pushl 0x4(r0)
   14340:	fb 01 ef 49 	calls $0x1,14890 <__Balloc_D2A>
   14344:	05 00 00 
   14347:	d0 50 ad b0 	movl r0,0xffffffb0(fp)
   1434b:	12 03       	bneq 14350 <__dtoa+0x6ca>
   1434d:	31 14 ff    	brw 14264 <__dtoa+0x5de>
   14350:	d0 ad b4 51 	movl 0xffffffb4(fp),r1
   14354:	78 02 a1 10 	ashl $0x2,0x10(r1),r0
   14358:	50 
   14359:	9f a0 08    	pushab 0x8(r0)
   1435c:	9f a1 0c    	pushab 0xc(r1)
   1435f:	c1 ad b0 0c 	addl3 0xffffffb0(fp),$0xc,-(sp)
   14363:	7e 
   14364:	fb 03 ef 83 	calls $0x3,166ee <memcpy>
   14368:	23 00 00 
   1436b:	dd 01       	pushl $0x1
   1436d:	dd ad b0    	pushl 0xffffffb0(fp)
   14370:	fb 02 ef 4d 	calls $0x2,14dc4 <__lshift_D2A>
   14374:	0a 00 00 
   14377:	d0 50 ad b0 	movl r0,0xffffffb0(fp)
   1437b:	13 03       	beql 14380 <__dtoa+0x6fa>
   1437d:	31 30 fe    	brw 141b0 <__dtoa+0x52a>
   14380:	31 e1 fe    	brw 14264 <__dtoa+0x5de>
   14383:	d0 01 58    	movl $0x1,r8
   14386:	dd ad ac    	pushl 0xffffffac(fp)
   14389:	d0 5b 56    	movl r11,r6
   1438c:	d6 5b       	incl r11
   1438e:	dd ad b8    	pushl 0xffffffb8(fp)
   14391:	fb 02 ef 52 	calls $0x2,146ea <__quorem_D2A>
   14395:	03 00 00 
   14398:	81 50 30 66 	addb3 r0,$0x30,(r6)
   1439c:	d0 ad b8 50 	movl 0xffffffb8(fp),r0
   143a0:	d5 a0 14    	tstl 0x14(r0)
   143a3:	12 09       	bneq 143ae <__dtoa+0x728>
   143a5:	d1 a0 10 01 	cmpl 0x10(r0),$0x1
   143a9:	14 03       	bgtr 143ae <__dtoa+0x728>
   143ab:	31 4a fc    	brw 13ff8 <__dtoa+0x372>
   143ae:	d1 58 ad dc 	cmpl r8,0xffffffdc(fp)
   143b2:	19 03       	blss 143b7 <__dtoa+0x731>
   143b4:	31 c6 fe    	brw 1427d <__dtoa+0x5f7>
   143b7:	d4 7e       	clrf -(sp)
   143b9:	dd 0a       	pushl $0xa
   143bb:	dd ad b8    	pushl 0xffffffb8(fp)
   143be:	fb 03 ef 7b 	calls $0x3,14a40 <__multadd_D2A>
   143c2:	06 00 00 
   143c5:	d0 50 ad b8 	movl r0,0xffffffb8(fp)
   143c9:	12 03       	bneq 143ce <__dtoa+0x748>
   143cb:	31 96 fe    	brw 14264 <__dtoa+0x5de>
   143ce:	d6 58       	incl r8
   143d0:	11 b4       	brb 14386 <__dtoa+0x700>
   143d2:	d1 ac 0c 03 	cmpl 0xc(ap),$0x3
   143d6:	13 09       	beql 143e1 <__dtoa+0x75b>
   143d8:	d1 ac 0c 05 	cmpl 0xc(ap),$0x5
   143dc:	13 03       	beql 143e1 <__dtoa+0x75b>
   143de:	31 a2 fd    	brw 14183 <__dtoa+0x4fd>
   143e1:	d4 7e       	clrf -(sp)
   143e3:	dd 05       	pushl $0x5
   143e5:	dd ad ac    	pushl 0xffffffac(fp)
   143e8:	fb 03 ef 51 	calls $0x3,14a40 <__multadd_D2A>
   143ec:	06 00 00 
   143ef:	d0 50 ad ac 	movl r0,0xffffffac(fp)
   143f3:	12 03       	bneq 143f8 <__dtoa+0x772>
   143f5:	31 6c fe    	brw 14264 <__dtoa+0x5de>
   143f8:	d5 ad dc    	tstl 0xffffffdc(fp)
   143fb:	18 03       	bgeq 14400 <__dtoa+0x77a>
   143fd:	31 f3 fb    	brw 13ff3 <__dtoa+0x36d>
   14400:	dd ad ac    	pushl 0xffffffac(fp)
   14403:	dd ad b8    	pushl 0xffffffb8(fp)
   14406:	fb 02 ef 63 	calls $0x2,14e70 <__cmp_D2A>
   1440a:	0a 00 00 
   1440d:	d5 50       	tstl r0
   1440f:	15 03       	bleq 14414 <__dtoa+0x78e>
   14411:	31 15 fc    	brw 14029 <__dtoa+0x3a3>
   14414:	31 dc fb    	brw 13ff3 <__dtoa+0x36d>
   14417:	dd ad ac    	pushl 0xffffffac(fp)
   1441a:	dd ad b8    	pushl 0xffffffb8(fp)
   1441d:	fb 02 ef 4c 	calls $0x2,14e70 <__cmp_D2A>
   14421:	0a 00 00 
   14424:	d5 50       	tstl r0
   14426:	19 03       	blss 1442b <__dtoa+0x7a5>
   14428:	31 50 fd    	brw 1417b <__dtoa+0x4f5>
   1442b:	d7 ad d0    	decl 0xffffffd0(fp)
   1442e:	d4 7e       	clrf -(sp)
   14430:	dd 0a       	pushl $0xa
   14432:	dd ad b8    	pushl 0xffffffb8(fp)
   14435:	9e ef 05 06 	movab 14a40 <__multadd_D2A>,r7
   14439:	00 00 57 
   1443c:	fb 03 67    	calls $0x3,(r7)
   1443f:	d0 50 ad b8 	movl r0,0xffffffb8(fp)
   14443:	12 03       	bneq 14448 <__dtoa+0x7c2>
   14445:	31 1c fe    	brw 14264 <__dtoa+0x5de>
   14448:	d5 ad c4    	tstl 0xffffffc4(fp)
   1444b:	12 08       	bneq 14455 <__dtoa+0x7cf>
   1444d:	d0 ad d4 ad 	movl 0xffffffd4(fp),0xffffffdc(fp)
   14451:	dc 
   14452:	31 26 fd    	brw 1417b <__dtoa+0x4f5>
   14455:	d4 7e       	clrf -(sp)
   14457:	dd 0a       	pushl $0xa
   14459:	dd ad b0    	pushl 0xffffffb0(fp)
   1445c:	fb 03 67    	calls $0x3,(r7)
   1445f:	d0 50 ad b0 	movl r0,0xffffffb0(fp)
   14463:	12 e8       	bneq 1444d <__dtoa+0x7c7>
   14465:	31 fc fd    	brw 14264 <__dtoa+0x5de>
   14468:	d1 58 03    	cmpl r8,$0x3
   1446b:	15 03       	bleq 14470 <__dtoa+0x7ea>
   1446d:	31 cd fc    	brw 1413d <__dtoa+0x4b7>
   14470:	c0 1c 58    	addl2 $0x1c,r8
   14473:	31 bc fc    	brw 14132 <__dtoa+0x4ac>
   14476:	d0 ad ac 52 	movl 0xffffffac(fp),r2
   1447a:	d0 a2 10 50 	movl 0x10(r2),r0
   1447e:	dd 40 a2 10 	pushl 0x10(r2)[r0]
   14482:	fb 01 ef 87 	calls $0x1,14b10 <__hi0bits_D2A>
   14486:	06 00 00 
   14489:	c3 50 ad c0 	subl3 r0,0xffffffc0(fp),r0
   1448d:	50 
   1448e:	31 88 fc    	brw 14119 <__dtoa+0x493>
   14491:	dd 57       	pushl r7
   14493:	dd ad b8    	pushl 0xffffffb8(fp)
   14496:	fb 02 ef ff 	calls $0x2,14c9c <__pow5mult_D2A>
   1449a:	07 00 00 
   1449d:	d0 50 ad b8 	movl r0,0xffffffb8(fp)
   144a1:	13 03       	beql 144a6 <__dtoa+0x820>
   144a3:	31 14 fc    	brw 140ba <__dtoa+0x434>
   144a6:	31 bb fd    	brw 14264 <__dtoa+0x5de>
   144a9:	dd ad e0    	pushl 0xffffffe0(fp)
   144ac:	11 e5       	brb 14493 <__dtoa+0x80d>
   144ae:	c3 ad f4 39 	subl3 0xfffffff4(fp),$0x39,r8
   144b2:	58 
   144b3:	c1 59 58 ad 	addl3 r9,r8,0xffffffe4(fp)
   144b7:	e4 
   144b8:	c0 58 ad c0 	addl2 r8,0xffffffc0(fp)
   144bc:	dd 01       	pushl $0x1
   144be:	fb 01 ef ab 	calls $0x1,14b70 <__i2b_D2A>
   144c2:	06 00 00 
   144c5:	d0 50 ad b0 	movl r0,0xffffffb0(fp)
   144c9:	13 03       	beql 144ce <__dtoa+0x848>
   144cb:	31 79 fb    	brw 14047 <__dtoa+0x3c1>
   144ce:	31 93 fd    	brw 14264 <__dtoa+0x5de>
   144d1:	d5 ad c4    	tstl 0xffffffc4(fp)
   144d4:	13 5c       	beql 14532 <__dtoa+0x8ac>
   144d6:	d0 ad dc 52 	movl 0xffffffdc(fp),r2
   144da:	67 42 ef 3f 	divd3 2ac20 <__tinytens_D2A+0x8>[r2],$0x0 [d-float],r0
   144de:	67 01 00 00 
   144e2:	50 
   144e3:	62 59 50    	subd2 r9,r0
   144e6:	70 50 59    	movd r0,r9
   144e9:	d4 58       	clrf r8
   144eb:	70 ad e8 52 	movd 0xffffffe8(fp),r2
   144ef:	6a 52 54    	cvtdl r2,r4
   144f2:	6e 54 50    	cvtld r4,r0
   144f5:	63 50 52 ad 	subd3 r0,r2,0xffffffe8(fp)
   144f9:	e8 
   144fa:	81 54 30 8b 	addb3 r4,$0x30,(r11)+
   144fe:	70 ad e8 56 	movd 0xffffffe8(fp),r6
   14502:	71 56 59    	cmpd r6,r9
   14505:	18 03       	bgeq 1450a <__dtoa+0x884>
   14507:	31 8b fa    	brw 13f95 <__dtoa+0x30f>
   1450a:	63 56 08 50 	subd3 r6,$0x8 [d-float],r0
   1450e:	71 50 59    	cmpd r0,r9
   14511:	18 03       	bgeq 14516 <__dtoa+0x890>
   14513:	31 73 fa    	brw 13f89 <__dtoa+0x303>
   14516:	d6 58       	incl r8
   14518:	d1 58 ad dc 	cmpl r8,0xffffffdc(fp)
   1451c:	19 03       	blss 14521 <__dtoa+0x89b>
   1451e:	31 f2 f9    	brw 13f13 <__dtoa+0x28d>
   14521:	70 22 52    	movd $0x22 [d-float],r2
   14524:	65 59 52 50 	muld3 r9,r2,r0
   14528:	70 50 59    	movd r0,r9
   1452b:	65 56 52 ad 	muld3 r6,r2,0xffffffe8(fp)
   1452f:	e8 
   14530:	11 b9       	brb 144eb <__dtoa+0x865>
   14532:	d0 ad dc 52 	movl 0xffffffdc(fp),r2
   14536:	65 42 ef e3 	muld3 2ac20 <__tinytens_D2A+0x8>[r2],r9,r0
   1453a:	66 01 00 59 
   1453e:	50 
   1453f:	70 50 59    	movd r0,r9
   14542:	d0 01 58    	movl $0x1,r8
   14545:	70 ad e8 50 	movd 0xffffffe8(fp),r0
   14549:	6a 50 54    	cvtdl r0,r4
   1454c:	6e 54 52    	cvtld r4,r2
   1454f:	62 52 50    	subd2 r2,r0
   14552:	70 50 ad e8 	movd r0,0xffffffe8(fp)
   14556:	12 04       	bneq 1455c <__dtoa+0x8d6>
   14558:	d0 58 ad dc 	movl r8,0xffffffdc(fp)
   1455c:	81 54 30 8b 	addb3 r4,$0x30,(r11)+
   14560:	d1 58 ad dc 	cmpl r8,0xffffffdc(fp)
   14564:	13 08       	beql 1456e <__dtoa+0x8e8>
   14566:	d6 58       	incl r8
   14568:	64 22 ad e8 	muld2 $0x22 [d-float],0xffffffe8(fp)
   1456c:	11 d7       	brb 14545 <__dtoa+0x8bf>
   1456e:	70 00 56    	movd $0x0 [d-float],r6
   14571:	61 59 56 50 	addd3 r9,r6,r0
   14575:	70 ad e8 52 	movd 0xffffffe8(fp),r2
   14579:	71 52 50    	cmpd r2,r0
   1457c:	15 03       	bleq 14581 <__dtoa+0x8fb>
   1457e:	31 08 fa    	brw 13f89 <__dtoa+0x303>
   14581:	63 59 56 50 	subd3 r9,r6,r0
   14585:	71 52 50    	cmpd r2,r0
   14588:	19 03       	blss 1458d <__dtoa+0x907>
   1458a:	31 86 f9    	brw 13f13 <__dtoa+0x28d>
   1458d:	91 7b 30    	cmpb -(r11),$0x30
   14590:	13 fb       	beql 1458d <__dtoa+0x907>
   14592:	d6 5b       	incl r11
   14594:	31 fe f9    	brw 13f95 <__dtoa+0x30f>
   14597:	ce ad d0 59 	mnegl 0xffffffd0(fp),r9
   1459b:	12 03       	bneq 145a0 <__dtoa+0x91a>
   1459d:	31 0c f9    	brw 13eac <__dtoa+0x226>
   145a0:	cb 8f f0 ff 	bicl3 $0xfffffff0,r9,r0
   145a4:	ff ff 59 50 
   145a8:	64 40 ef 79 	muld2 2ac28 <__tens_D2A>[r0],r2
   145ac:	66 01 00 52 
   145b0:	70 52 ad e8 	movd r2,0xffffffe8(fp)
   145b4:	78 8f fc 59 	ashl $0xfc,r9,r7
   145b8:	57 
   145b9:	12 03       	bneq 145be <__dtoa+0x938>
   145bb:	31 ee f8    	brw 13eac <__dtoa+0x226>
   145be:	e9 57 0a    	blbc r7,145cb <__dtoa+0x945>
   145c1:	d6 51       	incl r1
   145c3:	64 48 ef 3e 	muld2 2ac08 <__bigtens_D2A>[r8],r2
   145c7:	66 01 00 52 
   145cb:	78 8f ff 57 	ashl $0xff,r7,r7
   145cf:	57 
   145d0:	d6 58       	incl r8
   145d2:	d5 57       	tstl r7
   145d4:	12 e8       	bneq 145be <__dtoa+0x938>
   145d6:	70 52 ad e8 	movd r2,0xffffffe8(fp)
   145da:	31 cf f8    	brw 13eac <__dtoa+0x226>
   145dd:	d4 ad c4    	clrf 0xffffffc4(fp)
   145e0:	d5 ac 10    	tstl 0x10(ap)
   145e3:	15 0f       	bleq 145f4 <__dtoa+0x96e>
   145e5:	d0 ac 10 58 	movl 0x10(ap),r8
   145e9:	d0 58 ad d4 	movl r8,0xffffffd4(fp)
   145ed:	d0 58 ad dc 	movl r8,0xffffffdc(fp)
   145f1:	31 26 f8    	brw 13e1a <__dtoa+0x194>
   145f4:	d0 01 ac 10 	movl $0x1,0x10(ap)
   145f8:	11 eb       	brb 145e5 <__dtoa+0x95f>
   145fa:	d4 ad c4    	clrf 0xffffffc4(fp)
   145fd:	c1 ac 10 ad 	addl3 0x10(ap),0xffffffd0(fp),r0
   14601:	d0 50 
   14603:	c1 50 01 58 	addl3 r0,$0x1,r8
   14607:	d0 58 ad dc 	movl r8,0xffffffdc(fp)
   1460b:	d0 50 ad d4 	movl r0,0xffffffd4(fp)
   1460f:	d5 58       	tstl r8
   14611:	15 03       	bleq 14616 <__dtoa+0x990>
   14613:	31 04 f8    	brw 13e1a <__dtoa+0x194>
   14616:	d0 01 58    	movl $0x1,r8
   14619:	31 fe f7    	brw 13e1a <__dtoa+0x194>
   1461c:	c2 ad d0 ad 	subl2 0xffffffd0(fp),0xffffffe4(fp)
   14620:	e4 
   14621:	ce ad d0 ad 	mnegl 0xffffffd0(fp),0xffffffe0(fp)
   14625:	e0 
   14626:	d4 ad bc    	clrf 0xffffffbc(fp)
   14629:	31 ac f7    	brw 13dd8 <__dtoa+0x152>
   1462c:	ce 57 ad e4 	mnegl r7,0xffffffe4(fp)
   14630:	d4 ad c0    	clrf 0xffffffc0(fp)
   14633:	31 8d f7    	brw 13dc3 <__dtoa+0x13d>
   14636:	d0 ad 9c 50 	movl 0xffffff9c(fp),r0
   1463a:	3c 8f 0f 27 	movzwl $0x270f,(r0)
   1463e:	60 
   1463f:	dd 03       	pushl $0x3
   14641:	dd ad 98    	pushl 0xffffff98(fp)
   14644:	9f ef b9 65 	pushab 2ac03 <sigfigs.0+0xb>
   14648:	01 00 
   1464a:	31 9a f6    	brw 13ce7 <__dtoa+0x61>
   1464d:	d4 60       	clrf (r0)
   1464f:	31 6b f6    	brw 13cbd <__dtoa+0x37>

00014652 <__rv_alloc_D2A>:
   14652:	40 00       	.word 0x0040 # Entry mask: < r6 >
   14654:	c2 04 5e    	subl2 $0x4,sp
   14657:	d0 ac 04 52 	movl 0x4(ap),r2
   1465b:	d0 04 51    	movl $0x4,r1
   1465e:	d4 56       	clrf r6
   14660:	d1 52 13    	cmpl r2,$0x13
   14663:	1b 0e       	blequ 14673 <__rv_alloc_D2A+0x21>
   14665:	d6 56       	incl r6
   14667:	c0 51 51    	addl2 r1,r1
   1466a:	c1 51 10 50 	addl3 r1,$0x10,r0
   1466e:	d1 50 52    	cmpl r0,r2
   14671:	1b f2       	blequ 14665 <__rv_alloc_D2A+0x13>
   14673:	dd 56       	pushl r6
   14675:	fb 01 ef 14 	calls $0x1,14890 <__Balloc_D2A>
   14679:	02 00 00 
   1467c:	d5 50       	tstl r0
   1467e:	13 04       	beql 14684 <__rv_alloc_D2A+0x32>
   14680:	d0 56 80    	movl r6,(r0)+
   14683:	04          	ret
   14684:	d4 50       	clrf r0
   14686:	04          	ret
   14687:	01          	nop

00014688 <__nrv_alloc_D2A>:
   14688:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   1468a:	c2 04 5e    	subl2 $0x4,sp
   1468d:	d0 ac 04 56 	movl 0x4(ap),r6
   14691:	d0 ac 08 57 	movl 0x8(ap),r7
   14695:	dd ac 0c    	pushl 0xc(ap)
   14698:	fb 01 ef b3 	calls $0x1,14652 <__rv_alloc_D2A>
   1469c:	ff ff ff 
   1469f:	d0 50 52    	movl r0,r2
   146a2:	d0 50 51    	movl r0,r1
   146a5:	13 1d       	beql 146c4 <__nrv_alloc_D2A+0x3c>
   146a7:	90 86 50    	movb (r6)+,r0
   146aa:	90 50 62    	movb r0,(r2)
   146ad:	13 0a       	beql 146b9 <__nrv_alloc_D2A+0x31>
   146af:	d6 51       	incl r1
   146b1:	90 86 50    	movb (r6)+,r0
   146b4:	90 50 61    	movb r0,(r1)
   146b7:	12 f6       	bneq 146af <__nrv_alloc_D2A+0x27>
   146b9:	d5 57       	tstl r7
   146bb:	13 03       	beql 146c0 <__nrv_alloc_D2A+0x38>
   146bd:	d0 51 67    	movl r1,(r7)
   146c0:	d0 52 50    	movl r2,r0
   146c3:	04          	ret
   146c4:	d4 50       	clrf r0
   146c6:	04          	ret
   146c7:	01          	nop

000146c8 <__freedtoa>:
   146c8:	00 00       	.word 0x0000 # Entry mask: < >
   146ca:	c2 04 5e    	subl2 $0x4,sp
   146cd:	d0 ac 04 50 	movl 0x4(ap),r0
   146d1:	c3 04 50 51 	subl3 $0x4,r0,r1
   146d5:	d0 61 52    	movl (r1),r2
   146d8:	d0 52 60    	movl r2,(r0)
   146db:	78 52 01 a1 	ashl r2,$0x1,0x8(r1)
   146df:	08 
   146e0:	dd 51       	pushl r1
   146e2:	fb 01 ef 6b 	calls $0x1,14954 <__Bfree_D2A>
   146e6:	02 00 00 
   146e9:	04          	ret

000146ea <__quorem_D2A>:
   146ea:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   146ec:	c2 14 5e    	subl2 $0x14,sp
   146ef:	d0 ac 08 50 	movl 0x8(ap),r0
   146f3:	d0 a0 10 ad 	movl 0x10(r0),0xfffffff8(fp)
   146f7:	f8 
   146f8:	d0 ac 04 50 	movl 0x4(ap),r0
   146fc:	d1 a0 10 ad 	cmpl 0x10(r0),0xfffffff8(fp)
   14700:	f8 
   14701:	18 03       	bgeq 14706 <__quorem_D2A+0x1c>
   14703:	d4 50       	clrf r0
   14705:	04          	ret
   14706:	c1 ac 08 14 	addl3 0x8(ap),$0x14,r11
   1470a:	5b 
   1470b:	d7 ad f8    	decl 0xfffffff8(fp)
   1470e:	78 02 ad f8 	ashl $0x2,0xfffffff8(fp),r0
   14712:	50 
   14713:	c1 5b 50 ad 	addl3 r11,r0,0xffffffec(fp)
   14717:	ec 
   14718:	c1 ac 04 14 	addl3 0x4(ap),$0x14,r10
   1471c:	5a 
   1471d:	c1 5a 50 ad 	addl3 r10,r0,0xfffffff4(fp)
   14721:	f4 
   14722:	d0 ad ec 50 	movl 0xffffffec(fp),r0
   14726:	c1 60 01 7e 	addl3 (r0),$0x1,-(sp)
   1472a:	d0 ad f4 50 	movl 0xfffffff4(fp),r0
   1472e:	dd 60       	pushl (r0)
   14730:	fb 02 ef ad 	calls $0x2,15ce4 <__udiv>
   14734:	15 00 00 
   14737:	d0 50 ad f0 	movl r0,0xfffffff0(fp)
   1473b:	12 03       	bneq 14740 <__quorem_D2A+0x56>
   1473d:	31 a3 00    	brw 147e3 <__quorem_D2A+0xf9>
   14740:	7c 56       	clrd r6
   14742:	7c 58       	clrd r8
   14744:	d0 8b 53    	movl (r11)+,r3
   14747:	7a 53 ad f0 	emul r3,0xfffffff0(fp),$0x0,r0
   1474b:	00 50 
   1474d:	78 8f e1 53 	ashl $0xe1,r3,r2
   14751:	52 
   14752:	d2 52 52    	mcoml r2,r2
   14755:	cb 52 ad f0 	bicl3 r2,0xfffffff0(fp),r2
   14759:	52 
   1475a:	c0 52 51    	addl2 r2,r1
   1475d:	78 8f e1 ad 	ashl $0xe1,0xfffffff0(fp),r2
   14761:	f0 52 
   14763:	d2 52 52    	mcoml r2,r2
   14766:	cb 52 53 52 	bicl3 r2,r3,r2
   1476a:	c0 52 51    	addl2 r2,r1
   1476d:	7d 50 52    	movq r0,r2
   14770:	c0 58 52    	addl2 r8,r2
   14773:	d8 59 53    	adwc r9,r3
   14776:	d0 53 58    	movl r3,r8
   14779:	d4 59       	clrf r9
   1477b:	d0 6a 50    	movl (r10),r0
   1477e:	d4 51       	clrf r1
   14780:	7d 50 54    	movq r0,r4
   14783:	d0 52 50    	movl r2,r0
   14786:	c2 50 54    	subl2 r0,r4
   14789:	d9 51 55    	sbwc r1,r5
   1478c:	c2 56 54    	subl2 r6,r4
   1478f:	d9 57 55    	sbwc r7,r5
   14792:	cb 8f fe ff 	bicl3 $0xfffffffe,r5,r6
   14796:	ff ff 55 56 
   1479a:	d4 57       	clrf r7
   1479c:	d0 54 8a    	movl r4,(r10)+
   1479f:	d1 5b ad ec 	cmpl r11,0xffffffec(fp)
   147a3:	1b 9f       	blequ 14744 <__quorem_D2A+0x5a>
   147a5:	d0 ad f4 50 	movl 0xfffffff4(fp),r0
   147a9:	d5 60       	tstl (r0)
   147ab:	12 36       	bneq 147e3 <__quorem_D2A+0xf9>
   147ad:	c1 ac 04 14 	addl3 0x4(ap),$0x14,r10
   147b1:	5a 
   147b2:	c3 04 50 ad 	subl3 $0x4,r0,0xfffffff4(fp)
   147b6:	f4 
   147b7:	d1 ad f4 5a 	cmpl 0xfffffff4(fp),r10
   147bb:	1b 1d       	blequ 147da <__quorem_D2A+0xf0>
   147bd:	d0 ad f4 50 	movl 0xfffffff4(fp),r0
   147c1:	d5 60       	tstl (r0)
   147c3:	12 15       	bneq 147da <__quorem_D2A+0xf0>
   147c5:	d7 ad f8    	decl 0xfffffff8(fp)
   147c8:	c2 04 ad f4 	subl2 $0x4,0xfffffff4(fp)
   147cc:	d1 ad f4 5a 	cmpl 0xfffffff4(fp),r10
   147d0:	1b 08       	blequ 147da <__quorem_D2A+0xf0>
   147d2:	d0 ad f4 50 	movl 0xfffffff4(fp),r0
   147d6:	d5 60       	tstl (r0)
   147d8:	13 eb       	beql 147c5 <__quorem_D2A+0xdb>
   147da:	d0 ac 04 50 	movl 0x4(ap),r0
   147de:	d0 ad f8 a0 	movl 0xfffffff8(fp),0x10(r0)
   147e2:	10 
   147e3:	dd ac 08    	pushl 0x8(ap)
   147e6:	dd ac 04    	pushl 0x4(ap)
   147e9:	fb 02 ef 80 	calls $0x2,14e70 <__cmp_D2A>
   147ed:	06 00 00 
   147f0:	d5 50       	tstl r0
   147f2:	18 03       	bgeq 147f7 <__quorem_D2A+0x10d>
   147f4:	31 93 00    	brw 1488a <__quorem_D2A+0x1a0>
   147f7:	d6 ad f0    	incl 0xfffffff0(fp)
   147fa:	7c 56       	clrd r6
   147fc:	7c 58       	clrd r8
   147fe:	c1 ac 04 14 	addl3 0x4(ap),$0x14,r10
   14802:	5a 
   14803:	c1 ac 08 14 	addl3 0x8(ap),$0x14,r11
   14807:	5b 
   14808:	d0 8b 50    	movl (r11)+,r0
   1480b:	d4 51       	clrf r1
   1480d:	7d 50 52    	movq r0,r2
   14810:	c0 58 52    	addl2 r8,r2
   14813:	d8 59 53    	adwc r9,r3
   14816:	d0 53 58    	movl r3,r8
   14819:	d4 59       	clrf r9
   1481b:	d0 6a 50    	movl (r10),r0
   1481e:	7d 50 54    	movq r0,r4
   14821:	d0 52 50    	movl r2,r0
   14824:	c2 50 54    	subl2 r0,r4
   14827:	d9 51 55    	sbwc r1,r5
   1482a:	c2 56 54    	subl2 r6,r4
   1482d:	d9 57 55    	sbwc r7,r5
   14830:	cb 8f fe ff 	bicl3 $0xfffffffe,r5,r6
   14834:	ff ff 55 56 
   14838:	d4 57       	clrf r7
   1483a:	d0 54 8a    	movl r4,(r10)+
   1483d:	d1 5b ad ec 	cmpl r11,0xffffffec(fp)
   14841:	1b c5       	blequ 14808 <__quorem_D2A+0x11e>
   14843:	c1 ac 04 14 	addl3 0x4(ap),$0x14,r10
   14847:	5a 
   14848:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   1484c:	de 40 6a ad 	moval (r10)[r0],0xfffffff4(fp)
   14850:	f4 
   14851:	d0 ad f4 50 	movl 0xfffffff4(fp),r0
   14855:	d5 60       	tstl (r0)
   14857:	12 31       	bneq 1488a <__quorem_D2A+0x1a0>
   14859:	c3 04 50 ad 	subl3 $0x4,r0,0xfffffff4(fp)
   1485d:	f4 
   1485e:	d1 ad f4 5a 	cmpl 0xfffffff4(fp),r10
   14862:	1b 1d       	blequ 14881 <__quorem_D2A+0x197>
   14864:	d0 ad f4 50 	movl 0xfffffff4(fp),r0
   14868:	d5 60       	tstl (r0)
   1486a:	12 15       	bneq 14881 <__quorem_D2A+0x197>
   1486c:	d7 ad f8    	decl 0xfffffff8(fp)
   1486f:	c2 04 ad f4 	subl2 $0x4,0xfffffff4(fp)
   14873:	d1 ad f4 5a 	cmpl 0xfffffff4(fp),r10
   14877:	1b 08       	blequ 14881 <__quorem_D2A+0x197>
   14879:	d0 ad f4 50 	movl 0xfffffff4(fp),r0
   1487d:	d5 60       	tstl (r0)
   1487f:	13 eb       	beql 1486c <__quorem_D2A+0x182>
   14881:	d0 ac 04 50 	movl 0x4(ap),r0
   14885:	d0 ad f8 a0 	movl 0xfffffff8(fp),0x10(r0)
   14889:	10 
   1488a:	d0 ad f0 50 	movl 0xfffffff0(fp),r0
   1488e:	04          	ret
   1488f:	01          	nop

00014890 <__Balloc_D2A>:
   14890:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   14892:	c2 04 5e    	subl2 $0x4,sp
   14895:	d0 ac 04 57 	movl 0x4(ap),r7
   14899:	d5 ef 45 78 	tstl 5c0e4 <__isthreaded>
   1489d:	04 00 
   1489f:	13 03       	beql 148a4 <__Balloc_D2A+0x14>
   148a1:	31 9f 00    	brw 14943 <__Balloc_D2A+0xb3>
   148a4:	d1 57 09    	cmpl r7,$0x9
   148a7:	14 32       	bgtr 148db <__Balloc_D2A+0x4b>
   148a9:	9e ef 05 a0 	movab 5e8b4 <freelist>,r0
   148ad:	04 00 50 
   148b0:	d0 47 60 56 	movl (r0)[r7],r6
   148b4:	13 25       	beql 148db <__Balloc_D2A+0x4b>
   148b6:	d0 66 47 60 	movl (r6),(r0)[r7]
   148ba:	d5 ef 24 78 	tstl 5c0e4 <__isthreaded>
   148be:	04 00 
   148c0:	12 0a       	bneq 148cc <__Balloc_D2A+0x3c>
   148c2:	d4 a6 10    	clrf 0x10(r6)
   148c5:	d4 a6 0c    	clrf 0xc(r6)
   148c8:	d0 56 50    	movl r6,r0
   148cb:	04          	ret
   148cc:	9f ef 52 78 	pushab 5c124 <__dtoa_locks>
   148d0:	04 00 
   148d2:	fb 01 ef 6d 	calls $0x1,16b46 <_weak__thread_mutex_unlock>
   148d6:	22 00 00 
   148d9:	11 e7       	brb 148c2 <__Balloc_D2A+0x32>
   148db:	78 57 01 58 	ashl r7,$0x1,r8
   148df:	de 48 9f 1b 	moval *0x1b[r8],r0
   148e3:	00 00 00 50 
   148e7:	9c 1d 50 51 	rotl $0x1d,r0,r1
   148eb:	ca 8f 00 00 	bicl2 $0xe0000000,r1
   148ef:	00 e0 51 
   148f2:	d1 57 09    	cmpl r7,$0x9
   148f5:	14 35       	bgtr 1492c <__Balloc_D2A+0x9c>
   148f7:	d0 ef 17 78 	movl 5c114 <pmem_next>,r2
   148fb:	04 00 52 
   148fe:	c3 8f dc e8 	subl3 $0x0005e8dc,r2,r0
   14902:	05 00 52 50 
   14906:	78 8f fd 50 	ashl $0xfd,r0,r0
   1490a:	50 
   1490b:	c0 51 50    	addl2 r1,r0
   1490e:	d1 50 8f 20 	cmpl r0,$0x00000120
   14912:	01 00 00 
   14915:	1a 15       	bgtru 1492c <__Balloc_D2A+0x9c>
   14917:	d0 52 56    	movl r2,r6
   1491a:	7e 41 62 ef 	movaq (r2)[r1],5c114 <pmem_next>
   1491e:	f2 77 04 00 
   14922:	d0 57 a6 04 	movl r7,0x4(r6)
   14926:	d0 58 a6 08 	movl r8,0x8(r6)
   1492a:	11 8e       	brb 148ba <__Balloc_D2A+0x2a>
   1492c:	7e 41 9f 00 	movaq *0x0[r1],-(sp)
   14930:	00 00 00 7e 
   14934:	fb 01 ef e7 	calls $0x1,18622 <malloc>
   14938:	3c 00 00 
   1493b:	d0 50 56    	movl r0,r6
   1493e:	12 e2       	bneq 14922 <__Balloc_D2A+0x92>
   14940:	d4 50       	clrf r0
   14942:	04          	ret
   14943:	9f ef db 77 	pushab 5c124 <__dtoa_locks>
   14947:	04 00 
   14949:	fb 01 ef f0 	calls $0x1,16b40 <_weak__thread_mutex_lock>
   1494d:	21 00 00 
   14950:	31 51 ff    	brw 148a4 <__Balloc_D2A+0x14>
   14953:	01          	nop

00014954 <__Bfree_D2A>:
   14954:	40 00       	.word 0x0040 # Entry mask: < r6 >
   14956:	c2 04 5e    	subl2 $0x4,sp
   14959:	d0 ac 04 56 	movl 0x4(ap),r6
   1495d:	13 29       	beql 14988 <__Bfree_D2A+0x34>
   1495f:	d1 a6 04 09 	cmpl 0x4(r6),$0x9
   14963:	14 42       	bgtr 149a7 <__Bfree_D2A+0x53>
   14965:	d5 ef 79 77 	tstl 5c0e4 <__isthreaded>
   14969:	04 00 
   1496b:	12 2b       	bneq 14998 <__Bfree_D2A+0x44>
   1496d:	d0 a6 04 51 	movl 0x4(r6),r1
   14971:	9e ef 3d 9f 	movab 5e8b4 <freelist>,r0
   14975:	04 00 50 
   14978:	d0 41 60 66 	movl (r0)[r1],(r6)
   1497c:	d0 56 41 60 	movl r6,(r0)[r1]
   14980:	d5 ef 5e 77 	tstl 5c0e4 <__isthreaded>
   14984:	04 00 
   14986:	12 01       	bneq 14989 <__Bfree_D2A+0x35>
   14988:	04          	ret
   14989:	9f ef 95 77 	pushab 5c124 <__dtoa_locks>
   1498d:	04 00 
   1498f:	fb 01 ef b0 	calls $0x1,16b46 <_weak__thread_mutex_unlock>
   14993:	21 00 00 
   14996:	11 f0       	brb 14988 <__Bfree_D2A+0x34>
   14998:	9f ef 86 77 	pushab 5c124 <__dtoa_locks>
   1499c:	04 00 
   1499e:	fb 01 ef 9b 	calls $0x1,16b40 <_weak__thread_mutex_lock>
   149a2:	21 00 00 
   149a5:	11 c6       	brb 1496d <__Bfree_D2A+0x19>
   149a7:	dd 56       	pushl r6
   149a9:	fb 01 ef 18 	calls $0x1,188c8 <free>
   149ad:	3f 00 00 
   149b0:	04          	ret
   149b1:	01          	nop

000149b2 <__lo0bits_D2A>:
   149b2:	00 00       	.word 0x0000 # Entry mask: < >
   149b4:	c2 04 5e    	subl2 $0x4,sp
   149b7:	d0 ac 04 52 	movl 0x4(ap),r2
   149bb:	d0 62 51    	movl (r2),r1
   149be:	d3 51 07    	bitl r1,$0x7
   149c1:	13 1c       	beql 149df <__lo0bits_D2A+0x2d>
   149c3:	e9 51 03    	blbc r1,149c9 <__lo0bits_D2A+0x17>
   149c6:	d4 50       	clrf r0
   149c8:	04          	ret
   149c9:	e1 01 51 09 	bbc $0x1,r1,149d6 <__lo0bits_D2A+0x24>
   149cd:	d0 01 50    	movl $0x1,r0
   149d0:	ef 50 1f 51 	extzv r0,$0x1f,r1,(r2)
   149d4:	62 
   149d5:	04          	ret
   149d6:	d0 02 50    	movl $0x2,r0
   149d9:	ef 50 1e 51 	extzv r0,$0x1e,r1,(r2)
   149dd:	62 
   149de:	04          	ret
   149df:	d4 50       	clrf r0
   149e1:	b5 51       	tstw r1
   149e3:	12 08       	bneq 149ed <__lo0bits_D2A+0x3b>
   149e5:	d0 10 50    	movl $0x10,r0
   149e8:	ef 50 50 51 	extzv r0,r0,r1,r1
   149ec:	51 
   149ed:	95 51       	tstb r1
   149ef:	12 0e       	bneq 149ff <__lo0bits_D2A+0x4d>
   149f1:	c0 08 50    	addl2 $0x8,r0
   149f4:	9c 18 51 51 	rotl $0x18,r1,r1
   149f8:	ca 8f 00 00 	bicl2 $0xff000000,r1
   149fc:	00 ff 51 
   149ff:	d3 51 0f    	bitl r1,$0xf
   14a02:	12 0e       	bneq 14a12 <__lo0bits_D2A+0x60>
   14a04:	c0 04 50    	addl2 $0x4,r0
   14a07:	9c 1c 51 51 	rotl $0x1c,r1,r1
   14a0b:	ca 8f 00 00 	bicl2 $0xf0000000,r1
   14a0f:	00 f0 51 
   14a12:	d3 51 03    	bitl r1,$0x3
   14a15:	12 0e       	bneq 14a25 <__lo0bits_D2A+0x73>
   14a17:	c0 02 50    	addl2 $0x2,r0
   14a1a:	9c 1e 51 51 	rotl $0x1e,r1,r1
   14a1e:	ca 8f 00 00 	bicl2 $0xc0000000,r1
   14a22:	00 c0 51 
   14a25:	e8 51 0f    	blbs r1,14a37 <__lo0bits_D2A+0x85>
   14a28:	d6 50       	incl r0
   14a2a:	9c 1f 51 51 	rotl $0x1f,r1,r1
   14a2e:	ca 8f 00 00 	bicl2 $0x80000000,r1
   14a32:	00 80 51 
   14a35:	13 04       	beql 14a3b <__lo0bits_D2A+0x89>
   14a37:	d0 51 62    	movl r1,(r2)
   14a3a:	04          	ret
   14a3b:	d0 20 50    	movl $0x20,r0
   14a3e:	04          	ret
   14a3f:	01          	nop

00014a40 <__multadd_D2A>:
   14a40:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   14a42:	c2 0c 5e    	subl2 $0xc,sp
   14a45:	d0 ac 0c 50 	movl 0xc(ap),r0
   14a49:	d0 ac 04 51 	movl 0x4(ap),r1
   14a4d:	d0 a1 10 ad 	movl 0x10(r1),0xfffffff4(fp)
   14a51:	f4 
   14a52:	c1 51 14 5b 	addl3 r1,$0x14,r11
   14a56:	d4 ad f8    	clrf 0xfffffff8(fp)
   14a59:	d0 50 59    	movl r0,r9
   14a5c:	78 8f e1 50 	ashl $0xe1,r0,r10
   14a60:	5a 
   14a61:	d0 6b 53    	movl (r11),r3
   14a64:	d4 54       	clrf r4
   14a66:	d0 ac 08 50 	movl 0x8(ap),r0
   14a6a:	78 8f e1 50 	ashl $0xe1,r0,r1
   14a6e:	51 
   14a6f:	7a 53 50 00 	emul r3,r0,$0x0,r5
   14a73:	55 
   14a74:	d0 1f 58    	movl $0x1f,r8
   14a77:	90 01 52    	movb $0x1,r2
   14a7a:	ef 58 52 53 	extzv r8,r2,r3,r7
   14a7e:	57 
   14a7f:	c0 54 57    	addl2 r4,r7
   14a82:	ef 58 52 50 	extzv r8,r2,r0,r2
   14a86:	52 
   14a87:	c0 51 52    	addl2 r1,r2
   14a8a:	c4 53 52    	mull2 r3,r2
   14a8d:	c0 56 52    	addl2 r6,r2
   14a90:	c4 50 57    	mull2 r0,r7
   14a93:	c1 52 57 56 	addl3 r2,r7,r6
   14a97:	c0 59 55    	addl2 r9,r5
   14a9a:	d8 5a 56    	adwc r10,r6
   14a9d:	d0 56 59    	movl r6,r9
   14aa0:	d4 5a       	clrf r10
   14aa2:	d0 55 8b    	movl r5,(r11)+
   14aa5:	f2 ad f4 ad 	aoblss 0xfffffff4(fp),0xfffffff8(fp),14a61 <__multadd_D2A+0x21>
   14aa9:	f8 b6 
   14aab:	c9 5a 56 50 	bisl3 r10,r6,r0
   14aaf:	13 1d       	beql 14ace <__multadd_D2A+0x8e>
   14ab1:	d0 ac 04 50 	movl 0x4(ap),r0
   14ab5:	d1 ad f4 a0 	cmpl 0xfffffff4(fp),0x8(r0)
   14ab9:	08 
   14aba:	18 17       	bgeq 14ad3 <__multadd_D2A+0x93>
   14abc:	d0 ad f4 50 	movl 0xfffffff4(fp),r0
   14ac0:	d0 ac 04 51 	movl 0x4(ap),r1
   14ac4:	d0 59 40 a1 	movl r9,0x14(r1)[r0]
   14ac8:	14 
   14ac9:	c1 50 01 a1 	addl3 r0,$0x1,0x10(r1)
   14acd:	10 
   14ace:	d0 ac 04 50 	movl 0x4(ap),r0
   14ad2:	04          	ret
   14ad3:	c1 a0 04 01 	addl3 0x4(r0),$0x1,-(sp)
   14ad7:	7e 
   14ad8:	fb 01 ef b1 	calls $0x1,14890 <__Balloc_D2A>
   14adc:	fd ff ff 
   14adf:	d0 50 57    	movl r0,r7
   14ae2:	13 29       	beql 14b0d <__multadd_D2A+0xcd>
   14ae4:	d0 ac 04 51 	movl 0x4(ap),r1
   14ae8:	78 02 a1 10 	ashl $0x2,0x10(r1),r0
   14aec:	50 
   14aed:	9f a0 08    	pushab 0x8(r0)
   14af0:	9f a1 0c    	pushab 0xc(r1)
   14af3:	9f a7 0c    	pushab 0xc(r7)
   14af6:	fb 03 ef f1 	calls $0x3,166ee <memcpy>
   14afa:	1b 00 00 
   14afd:	dd ac 04    	pushl 0x4(ap)
   14b00:	fb 01 ef 4d 	calls $0x1,14954 <__Bfree_D2A>
   14b04:	fe ff ff 
   14b07:	d0 57 ac 04 	movl r7,0x4(ap)
   14b0b:	11 af       	brb 14abc <__multadd_D2A+0x7c>
   14b0d:	d4 50       	clrf r0
   14b0f:	04          	ret

00014b10 <__hi0bits_D2A>:
   14b10:	00 00       	.word 0x0000 # Entry mask: < >
   14b12:	c2 04 5e    	subl2 $0x4,sp
   14b15:	d0 ac 04 51 	movl 0x4(ap),r1
   14b19:	d4 50       	clrf r0
   14b1b:	d3 51 8f 00 	bitl r1,$0xffff0000
   14b1f:	00 ff ff 
   14b22:	12 07       	bneq 14b2b <__hi0bits_D2A+0x1b>
   14b24:	d0 10 50    	movl $0x10,r0
   14b27:	78 10 51 51 	ashl $0x10,r1,r1
   14b2b:	d3 51 8f 00 	bitl r1,$0xff000000
   14b2f:	00 00 ff 
   14b32:	12 07       	bneq 14b3b <__hi0bits_D2A+0x2b>
   14b34:	c0 08 50    	addl2 $0x8,r0
   14b37:	78 08 51 51 	ashl $0x8,r1,r1
   14b3b:	d3 51 8f 00 	bitl r1,$0xf0000000
   14b3f:	00 00 f0 
   14b42:	12 07       	bneq 14b4b <__hi0bits_D2A+0x3b>
   14b44:	c0 04 50    	addl2 $0x4,r0
   14b47:	78 04 51 51 	ashl $0x4,r1,r1
   14b4b:	d3 51 8f 00 	bitl r1,$0xc0000000
   14b4f:	00 00 c0 
   14b52:	12 0b       	bneq 14b5f <__hi0bits_D2A+0x4f>
   14b54:	c0 02 50    	addl2 $0x2,r0
   14b57:	de 41 9f 00 	moval *0x0[r1],r1
   14b5b:	00 00 00 51 
   14b5f:	d5 51       	tstl r1
   14b61:	19 06       	blss 14b69 <__hi0bits_D2A+0x59>
   14b63:	d6 50       	incl r0
   14b65:	e1 1e 51 01 	bbc $0x1e,r1,14b6a <__hi0bits_D2A+0x5a>
   14b69:	04          	ret
   14b6a:	d0 20 50    	movl $0x20,r0
   14b6d:	11 fa       	brb 14b69 <__hi0bits_D2A+0x59>
   14b6f:	01          	nop

00014b70 <__i2b_D2A>:
   14b70:	00 00       	.word 0x0000 # Entry mask: < >
   14b72:	c2 04 5e    	subl2 $0x4,sp
   14b75:	dd 01       	pushl $0x1
   14b77:	fb 01 ef 12 	calls $0x1,14890 <__Balloc_D2A>
   14b7b:	fd ff ff 
   14b7e:	d5 50       	tstl r0
   14b80:	13 0a       	beql 14b8c <__i2b_D2A+0x1c>
   14b82:	d0 ac 04 a0 	movl 0x4(ap),0x14(r0)
   14b86:	14 
   14b87:	d0 01 a0 10 	movl $0x1,0x10(r0)
   14b8b:	04          	ret
   14b8c:	d4 50       	clrf r0
   14b8e:	04          	ret
   14b8f:	01          	nop

00014b90 <__mult_D2A>:
   14b90:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   14b92:	c2 14 5e    	subl2 $0x14,sp
   14b95:	d0 ac 04 57 	movl 0x4(ap),r7
   14b99:	d0 ac 08 58 	movl 0x8(ap),r8
   14b9d:	d1 a7 10 a8 	cmpl 0x10(r7),0x10(r8)
   14ba1:	10 
   14ba2:	18 0b       	bgeq 14baf <__mult_D2A+0x1f>
   14ba4:	d0 57 ad f8 	movl r7,0xfffffff8(fp)
   14ba8:	d0 58 57    	movl r8,r7
   14bab:	d0 ad f8 58 	movl 0xfffffff8(fp),r8
   14baf:	d0 a7 04 50 	movl 0x4(r7),r0
   14bb3:	d0 a7 10 59 	movl 0x10(r7),r9
   14bb7:	d0 a8 10 5a 	movl 0x10(r8),r10
   14bbb:	c1 59 5a 5b 	addl3 r9,r10,r11
   14bbf:	d1 5b a7 08 	cmpl r11,0x8(r7)
   14bc3:	15 02       	bleq 14bc7 <__mult_D2A+0x37>
   14bc5:	d6 50       	incl r0
   14bc7:	dd 50       	pushl r0
   14bc9:	fb 01 ef c0 	calls $0x1,14890 <__Balloc_D2A>
   14bcd:	fc ff ff 
   14bd0:	d0 50 ad f8 	movl r0,0xfffffff8(fp)
   14bd4:	12 03       	bneq 14bd9 <__mult_D2A+0x49>
   14bd6:	31 bf 00    	brw 14c98 <__mult_D2A+0x108>
   14bd9:	c1 ad f8 14 	addl3 0xfffffff8(fp),$0x14,r6
   14bdd:	56 
   14bde:	de 4b 66 ad 	moval (r6)[r11],0xfffffff4(fp)
   14be2:	f4 
   14be3:	d1 56 ad f4 	cmpl r6,0xfffffff4(fp)
   14be7:	1e 08       	bcc 14bf1 <__mult_D2A+0x61>
   14be9:	d4 86       	clrf (r6)+
   14beb:	d1 56 ad f4 	cmpl r6,0xfffffff4(fp)
   14bef:	1f f8       	blssu 14be9 <__mult_D2A+0x59>
   14bf1:	c1 57 14 ad 	addl3 r7,$0x14,0xfffffff4(fp)
   14bf5:	f4 
   14bf6:	d0 ad f4 50 	movl 0xfffffff4(fp),r0
   14bfa:	de 49 60 ad 	moval (r0)[r9],0xfffffff0(fp)
   14bfe:	f0 
   14bff:	c1 58 14 59 	addl3 r8,$0x14,r9
   14c03:	de 4a 69 ad 	moval (r9)[r10],0xffffffec(fp)
   14c07:	ec 
   14c08:	c1 ad f8 14 	addl3 0xfffffff8(fp),$0x14,r10
   14c0c:	5a 
   14c0d:	d1 59 ad ec 	cmpl r9,0xffffffec(fp)
   14c11:	1e 5f       	bcc 14c72 <__mult_D2A+0xe2>
   14c13:	d0 89 58    	movl (r9)+,r8
   14c16:	13 51       	beql 14c69 <__mult_D2A+0xd9>
   14c18:	d0 ad f4 56 	movl 0xfffffff4(fp),r6
   14c1c:	d0 5a 57    	movl r10,r7
   14c1f:	7c 54       	clrd r4
   14c21:	d0 86 51    	movl (r6)+,r1
   14c24:	7a 51 58 00 	emul r1,r8,$0x0,r2
   14c28:	52 
   14c29:	78 8f e1 51 	ashl $0xe1,r1,r0
   14c2d:	50 
   14c2e:	d2 50 50    	mcoml r0,r0
   14c31:	cb 50 58 50 	bicl3 r0,r8,r0
   14c35:	c0 50 53    	addl2 r0,r3
   14c38:	78 8f e1 58 	ashl $0xe1,r8,r0
   14c3c:	50 
   14c3d:	d2 50 50    	mcoml r0,r0
   14c40:	cb 50 51 50 	bicl3 r0,r1,r0
   14c44:	c0 50 53    	addl2 r0,r3
   14c47:	d0 67 50    	movl (r7),r0
   14c4a:	d4 51       	clrf r1
   14c4c:	c0 52 50    	addl2 r2,r0
   14c4f:	d8 53 51    	adwc r3,r1
   14c52:	c0 54 50    	addl2 r4,r0
   14c55:	d8 55 51    	adwc r5,r1
   14c58:	d0 51 54    	movl r1,r4
   14c5b:	d4 55       	clrf r5
   14c5d:	d0 50 87    	movl r0,(r7)+
   14c60:	d1 56 ad f0 	cmpl r6,0xfffffff0(fp)
   14c64:	1f bb       	blssu 14c21 <__mult_D2A+0x91>
   14c66:	d0 51 67    	movl r1,(r7)
   14c69:	c0 04 5a    	addl2 $0x4,r10
   14c6c:	d1 59 ad ec 	cmpl r9,0xffffffec(fp)
   14c70:	1f a1       	blssu 14c13 <__mult_D2A+0x83>
   14c72:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   14c76:	de 4b a0 14 	moval 0x14(r0)[r11],r7
   14c7a:	57 
   14c7b:	d5 5b       	tstl r11
   14c7d:	15 0c       	bleq 14c8b <__mult_D2A+0xfb>
   14c7f:	d5 77       	tstl -(r7)
   14c81:	12 08       	bneq 14c8b <__mult_D2A+0xfb>
   14c83:	d7 5b       	decl r11
   14c85:	15 04       	bleq 14c8b <__mult_D2A+0xfb>
   14c87:	d5 77       	tstl -(r7)
   14c89:	13 f8       	beql 14c83 <__mult_D2A+0xf3>
   14c8b:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   14c8f:	d0 5b a0 10 	movl r11,0x10(r0)
   14c93:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   14c97:	04          	ret
   14c98:	d4 50       	clrf r0
   14c9a:	04          	ret
   14c9b:	01          	nop

00014c9c <__pow5mult_D2A>:
   14c9c:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   14c9e:	c2 04 5e    	subl2 $0x4,sp
   14ca1:	d0 ac 04 59 	movl 0x4(ap),r9
   14ca5:	d0 ac 08 57 	movl 0x8(ap),r7
   14ca9:	cb 8f fc ff 	bicl3 $0xfffffffc,r7,r0
   14cad:	ff ff 57 50 
   14cb1:	13 03       	beql 14cb6 <__pow5mult_D2A+0x1a>
   14cb3:	31 f1 00    	brw 14da7 <__pow5mult_D2A+0x10b>
   14cb6:	78 8f fe 57 	ashl $0xfe,r7,r7
   14cba:	57 
   14cbb:	12 04       	bneq 14cc1 <__pow5mult_D2A+0x25>
   14cbd:	d0 59 50    	movl r9,r0
   14cc0:	04          	ret
   14cc1:	d0 ef 15 a5 	movl 5f1dc <p5s>,r8
   14cc5:	04 00 58 
   14cc8:	12 03       	bneq 14ccd <__pow5mult_D2A+0x31>
   14cca:	31 83 00    	brw 14d50 <__pow5mult_D2A+0xb4>
   14ccd:	e8 57 62    	blbs r7,14d32 <__pow5mult_D2A+0x96>
   14cd0:	78 8f ff 57 	ashl $0xff,r7,r7
   14cd4:	57 
   14cd5:	13 57       	beql 14d2e <__pow5mult_D2A+0x92>
   14cd7:	d0 68 56    	movl (r8),r6
   14cda:	13 05       	beql 14ce1 <__pow5mult_D2A+0x45>
   14cdc:	d0 56 58    	movl r6,r8
   14cdf:	11 ec       	brb 14ccd <__pow5mult_D2A+0x31>
   14ce1:	d5 ef fd 73 	tstl 5c0e4 <__isthreaded>
   14ce5:	04 00 
   14ce7:	12 36       	bneq 14d1f <__pow5mult_D2A+0x83>
   14ce9:	d0 68 56    	movl (r8),r6
   14cec:	13 17       	beql 14d05 <__pow5mult_D2A+0x69>
   14cee:	d5 ef f0 73 	tstl 5c0e4 <__isthreaded>
   14cf2:	04 00 
   14cf4:	13 e6       	beql 14cdc <__pow5mult_D2A+0x40>
   14cf6:	9f ef 2c 74 	pushab 5c128 <__dtoa_locks+0x4>
   14cfa:	04 00 
   14cfc:	fb 01 ef 43 	calls $0x1,16b46 <_weak__thread_mutex_unlock>
   14d00:	1e 00 00 
   14d03:	11 d7       	brb 14cdc <__pow5mult_D2A+0x40>
   14d05:	dd 58       	pushl r8
   14d07:	dd 58       	pushl r8
   14d09:	fb 02 ef 80 	calls $0x2,14b90 <__mult_D2A>
   14d0d:	fe ff ff 
   14d10:	d0 50 68    	movl r0,(r8)
   14d13:	d0 50 56    	movl r0,r6
   14d16:	13 04       	beql 14d1c <__pow5mult_D2A+0x80>
   14d18:	d4 60       	clrf (r0)
   14d1a:	11 d2       	brb 14cee <__pow5mult_D2A+0x52>
   14d1c:	d4 50       	clrf r0
   14d1e:	04          	ret
   14d1f:	9f ef 03 74 	pushab 5c128 <__dtoa_locks+0x4>
   14d23:	04 00 
   14d25:	fb 01 ef 14 	calls $0x1,16b40 <_weak__thread_mutex_lock>
   14d29:	1e 00 00 
   14d2c:	11 bb       	brb 14ce9 <__pow5mult_D2A+0x4d>
   14d2e:	d0 59 50    	movl r9,r0
   14d31:	04          	ret
   14d32:	dd 58       	pushl r8
   14d34:	dd 59       	pushl r9
   14d36:	fb 02 ef 53 	calls $0x2,14b90 <__mult_D2A>
   14d3a:	fe ff ff 
   14d3d:	d0 50 56    	movl r0,r6
   14d40:	13 da       	beql 14d1c <__pow5mult_D2A+0x80>
   14d42:	dd 59       	pushl r9
   14d44:	fb 01 ef 09 	calls $0x1,14954 <__Bfree_D2A>
   14d48:	fc ff ff 
   14d4b:	d0 56 59    	movl r6,r9
   14d4e:	11 80       	brb 14cd0 <__pow5mult_D2A+0x34>
   14d50:	d5 ef 8e 73 	tstl 5c0e4 <__isthreaded>
   14d54:	04 00 
   14d56:	12 40       	bneq 14d98 <__pow5mult_D2A+0xfc>
   14d58:	d0 ef 7e a4 	movl 5f1dc <p5s>,r8
   14d5c:	04 00 58 
   14d5f:	13 1b       	beql 14d7c <__pow5mult_D2A+0xe0>
   14d61:	d5 ef 7d 73 	tstl 5c0e4 <__isthreaded>
   14d65:	04 00 
   14d67:	12 03       	bneq 14d6c <__pow5mult_D2A+0xd0>
   14d69:	31 61 ff    	brw 14ccd <__pow5mult_D2A+0x31>
   14d6c:	9f ef b6 73 	pushab 5c128 <__dtoa_locks+0x4>
   14d70:	04 00 
   14d72:	fb 01 ef cd 	calls $0x1,16b46 <_weak__thread_mutex_unlock>
   14d76:	1d 00 00 
   14d79:	31 51 ff    	brw 14ccd <__pow5mult_D2A+0x31>
   14d7c:	3c 8f 71 02 	movzwl $0x0271,-(sp)
   14d80:	7e 
   14d81:	fb 01 ef e8 	calls $0x1,14b70 <__i2b_D2A>
   14d85:	fd ff ff 
   14d88:	d0 50 ef 4d 	movl r0,5f1dc <p5s>
   14d8c:	a4 04 00 
   14d8f:	d0 50 58    	movl r0,r8
   14d92:	13 88       	beql 14d1c <__pow5mult_D2A+0x80>
   14d94:	d4 60       	clrf (r0)
   14d96:	11 c9       	brb 14d61 <__pow5mult_D2A+0xc5>
   14d98:	9f ef 8a 73 	pushab 5c128 <__dtoa_locks+0x4>
   14d9c:	04 00 
   14d9e:	fb 01 ef 9b 	calls $0x1,16b40 <_weak__thread_mutex_lock>
   14da2:	1d 00 00 
   14da5:	11 b1       	brb 14d58 <__pow5mult_D2A+0xbc>
   14da7:	d4 7e       	clrf -(sp)
   14da9:	dd 40 ef 64 	pushl 5c114 <pmem_next>[r0]
   14dad:	73 04 00 
   14db0:	dd 59       	pushl r9
   14db2:	fb 03 ef 87 	calls $0x3,14a40 <__multadd_D2A>
   14db6:	fc ff ff 
   14db9:	d0 50 59    	movl r0,r9
   14dbc:	13 03       	beql 14dc1 <__pow5mult_D2A+0x125>
   14dbe:	31 f5 fe    	brw 14cb6 <__pow5mult_D2A+0x1a>
   14dc1:	31 58 ff    	brw 14d1c <__pow5mult_D2A+0x80>

00014dc4 <__lshift_D2A>:
   14dc4:	c0 07       	.word 0x07c0 # Entry mask: < r10 r9 r8 r7 r6 >
   14dc6:	c2 04 5e    	subl2 $0x4,sp
   14dc9:	d0 ac 04 5a 	movl 0x4(ap),r10
   14dcd:	d0 ac 08 56 	movl 0x8(ap),r6
   14dd1:	78 8f fb 56 	ashl $0xfb,r6,r8
   14dd5:	58 
   14dd6:	d0 aa 04 54 	movl 0x4(r10),r4
   14dda:	c1 58 aa 10 	addl3 r8,0x10(r10),r0
   14dde:	50 
   14ddf:	c1 50 01 57 	addl3 r0,$0x1,r7
   14de3:	d0 aa 08 50 	movl 0x8(r10),r0
   14de7:	d1 57 50    	cmpl r7,r0
   14dea:	15 0a       	bleq 14df6 <__lshift_D2A+0x32>
   14dec:	d6 54       	incl r4
   14dee:	c0 50 50    	addl2 r0,r0
   14df1:	d1 57 50    	cmpl r7,r0
   14df4:	14 f6       	bgtr 14dec <__lshift_D2A+0x28>
   14df6:	dd 54       	pushl r4
   14df8:	fb 01 ef 91 	calls $0x1,14890 <__Balloc_D2A>
   14dfc:	fa ff ff 
   14dff:	d0 50 59    	movl r0,r9
   14e02:	13 69       	beql 14e6d <__lshift_D2A+0xa9>
   14e04:	c1 50 14 53 	addl3 r0,$0x14,r3
   14e08:	d5 58       	tstl r8
   14e0a:	15 09       	bleq 14e15 <__lshift_D2A+0x51>
   14e0c:	d0 58 50    	movl r8,r0
   14e0f:	d4 83       	clrf (r3)+
   14e11:	d7 50       	decl r0
   14e13:	12 fa       	bneq 14e0f <__lshift_D2A+0x4b>
   14e15:	c1 5a 14 52 	addl3 r10,$0x14,r2
   14e19:	78 02 aa 10 	ashl $0x2,0x10(r10),r0
   14e1d:	50 
   14e1e:	c1 52 50 55 	addl3 r2,r0,r5
   14e22:	ca 8f e0 ff 	bicl2 $0xffffffe0,r6
   14e26:	ff ff 56 
   14e29:	13 38       	beql 14e63 <__lshift_D2A+0x9f>
   14e2b:	c3 56 20 54 	subl3 r6,$0x20,r4
   14e2f:	d4 51       	clrf r1
   14e31:	78 56 62 50 	ashl r6,(r2),r0
   14e35:	c9 51 50 83 	bisl3 r1,r0,(r3)+
   14e39:	d0 82 51    	movl (r2)+,r1
   14e3c:	83 54 20 50 	subb3 r4,$0x20,r0
   14e40:	ef 54 50 51 	extzv r4,r0,r1,r1
   14e44:	51 
   14e45:	d1 52 55    	cmpl r2,r5
   14e48:	1f e7       	blssu 14e31 <__lshift_D2A+0x6d>
   14e4a:	d0 51 63    	movl r1,(r3)
   14e4d:	13 02       	beql 14e51 <__lshift_D2A+0x8d>
   14e4f:	d6 57       	incl r7
   14e51:	c3 01 57 a9 	subl3 $0x1,r7,0x10(r9)
   14e55:	10 
   14e56:	dd 5a       	pushl r10
   14e58:	fb 01 ef f5 	calls $0x1,14954 <__Bfree_D2A>
   14e5c:	fa ff ff 
   14e5f:	d0 59 50    	movl r9,r0
   14e62:	04          	ret
   14e63:	d0 82 83    	movl (r2)+,(r3)+
   14e66:	d1 52 55    	cmpl r2,r5
   14e69:	1f f8       	blssu 14e63 <__lshift_D2A+0x9f>
   14e6b:	11 e4       	brb 14e51 <__lshift_D2A+0x8d>
   14e6d:	d4 50       	clrf r0
   14e6f:	04          	ret

00014e70 <__cmp_D2A>:
   14e70:	00 00       	.word 0x0000 # Entry mask: < >
   14e72:	c2 04 5e    	subl2 $0x4,sp
   14e75:	d0 ac 04 52 	movl 0x4(ap),r2
   14e79:	d0 ac 08 53 	movl 0x8(ap),r3
   14e7d:	d0 a3 10 51 	movl 0x10(r3),r1
   14e81:	c3 51 a2 10 	subl3 r1,0x10(r2),r0
   14e85:	50 
   14e86:	12 27       	bneq 14eaf <__cmp_D2A+0x3f>
   14e88:	c1 52 14 54 	addl3 r2,$0x14,r4
   14e8c:	de 41 9f 00 	moval *0x0[r1],r0
   14e90:	00 00 00 50 
   14e94:	c1 54 50 51 	addl3 r4,r0,r1
   14e98:	9e 43 a0 14 	movab 0x14(r0)[r3],r0
   14e9c:	50 
   14e9d:	d0 71 53    	movl -(r1),r3
   14ea0:	d0 70 52    	movl -(r0),r2
   14ea3:	d1 53 52    	cmpl r3,r2
   14ea6:	12 08       	bneq 14eb0 <__cmp_D2A+0x40>
   14ea8:	d1 51 54    	cmpl r1,r4
   14eab:	1a f0       	bgtru 14e9d <__cmp_D2A+0x2d>
   14ead:	d4 50       	clrf r0
   14eaf:	04          	ret
   14eb0:	d1 53 52    	cmpl r3,r2
   14eb3:	1e 04       	bcc 14eb9 <__cmp_D2A+0x49>
   14eb5:	d2 00 50    	mcoml $0x0,r0
   14eb8:	04          	ret
   14eb9:	d0 01 50    	movl $0x1,r0
   14ebc:	04          	ret
   14ebd:	01          	nop

00014ebe <__diff_D2A>:
   14ebe:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   14ec0:	c2 08 5e    	subl2 $0x8,sp
   14ec3:	d0 ac 04 57 	movl 0x4(ap),r7
   14ec7:	d0 ac 08 5a 	movl 0x8(ap),r10
   14ecb:	dd 5a       	pushl r10
   14ecd:	dd 57       	pushl r7
   14ecf:	fb 02 ef 9a 	calls $0x2,14e70 <__cmp_D2A>
   14ed3:	ff ff ff 
   14ed6:	d0 50 56    	movl r0,r6
   14ed9:	12 03       	bneq 14ede <__diff_D2A+0x20>
   14edb:	31 b0 00    	brw 14f8e <__diff_D2A+0xd0>
   14ede:	18 03       	bgeq 14ee3 <__diff_D2A+0x25>
   14ee0:	31 9c 00    	brw 14f7f <__diff_D2A+0xc1>
   14ee3:	d4 56       	clrf r6
   14ee5:	dd a7 04    	pushl 0x4(r7)
   14ee8:	fb 01 ef a1 	calls $0x1,14890 <__Balloc_D2A>
   14eec:	f9 ff ff 
   14eef:	d0 50 5b    	movl r0,r11
   14ef2:	12 03       	bneq 14ef7 <__diff_D2A+0x39>
   14ef4:	31 85 00    	brw 14f7c <__diff_D2A+0xbe>
   14ef7:	d0 56 a0 0c 	movl r6,0xc(r0)
   14efb:	d0 a7 10 59 	movl 0x10(r7),r9
   14eff:	c0 14 57    	addl2 $0x14,r7
   14f02:	de 49 67 ad 	moval (r7)[r9],0xfffffff8(fp)
   14f06:	f8 
   14f07:	c1 5a 14 58 	addl3 r10,$0x14,r8
   14f0b:	78 02 aa 10 	ashl $0x2,0x10(r10),r0
   14f0f:	50 
   14f10:	c1 58 50 5a 	addl3 r8,r0,r10
   14f14:	c1 5b 14 56 	addl3 r11,$0x14,r6
   14f18:	7c 54       	clrd r4
   14f1a:	d0 87 50    	movl (r7)+,r0
   14f1d:	d4 51       	clrf r1
   14f1f:	7d 50 52    	movq r0,r2
   14f22:	d0 88 50    	movl (r8)+,r0
   14f25:	c2 50 52    	subl2 r0,r2
   14f28:	d9 51 53    	sbwc r1,r3
   14f2b:	c2 54 52    	subl2 r4,r2
   14f2e:	d9 55 53    	sbwc r5,r3
   14f31:	cb 8f fe ff 	bicl3 $0xfffffffe,r3,r4
   14f35:	ff ff 53 54 
   14f39:	d4 55       	clrf r5
   14f3b:	d0 52 86    	movl r2,(r6)+
   14f3e:	d1 58 5a    	cmpl r8,r10
   14f41:	1f d7       	blssu 14f1a <__diff_D2A+0x5c>
   14f43:	d1 57 ad f8 	cmpl r7,0xfffffff8(fp)
   14f47:	1e 21       	bcc 14f6a <__diff_D2A+0xac>
   14f49:	d0 87 50    	movl (r7)+,r0
   14f4c:	d4 51       	clrf r1
   14f4e:	7d 50 52    	movq r0,r2
   14f51:	c2 54 52    	subl2 r4,r2
   14f54:	d9 55 53    	sbwc r5,r3
   14f57:	cb 8f fe ff 	bicl3 $0xfffffffe,r3,r4
   14f5b:	ff ff 53 54 
   14f5f:	d4 55       	clrf r5
   14f61:	d0 52 86    	movl r2,(r6)+
   14f64:	d1 57 ad f8 	cmpl r7,0xfffffff8(fp)
   14f68:	1f df       	blssu 14f49 <__diff_D2A+0x8b>
   14f6a:	d5 76       	tstl -(r6)
   14f6c:	12 06       	bneq 14f74 <__diff_D2A+0xb6>
   14f6e:	d7 59       	decl r9
   14f70:	d5 76       	tstl -(r6)
   14f72:	13 fa       	beql 14f6e <__diff_D2A+0xb0>
   14f74:	d0 59 ab 10 	movl r9,0x10(r11)
   14f78:	d0 5b 50    	movl r11,r0
   14f7b:	04          	ret
   14f7c:	d4 50       	clrf r0
   14f7e:	04          	ret
   14f7f:	d0 57 5b    	movl r7,r11
   14f82:	d0 5a 57    	movl r10,r7
   14f85:	d0 5b 5a    	movl r11,r10
   14f88:	d0 01 56    	movl $0x1,r6
   14f8b:	31 57 ff    	brw 14ee5 <__diff_D2A+0x27>
   14f8e:	d4 7e       	clrf -(sp)
   14f90:	fb 01 ef f9 	calls $0x1,14890 <__Balloc_D2A>
   14f94:	f8 ff ff 
   14f97:	d0 50 5b    	movl r0,r11
   14f9a:	13 e0       	beql 14f7c <__diff_D2A+0xbe>
   14f9c:	d0 01 a0 10 	movl $0x1,0x10(r0)
   14fa0:	d4 a0 14    	clrf 0x14(r0)
   14fa3:	04          	ret

00014fa4 <__b2d_D2A>:
   14fa4:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   14fa6:	c2 10 5e    	subl2 $0x10,sp
   14fa9:	d0 ef e9 6f 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   14fad:	02 00 ad f8 
   14fb1:	d0 ac 04 50 	movl 0x4(ap),r0
   14fb5:	d0 ac 08 56 	movl 0x8(ap),r6
   14fb9:	c1 50 14 59 	addl3 r0,$0x14,r9
   14fbd:	78 02 a0 10 	ashl $0x2,0x10(r0),r0
   14fc1:	50 
   14fc2:	c1 59 50 57 	addl3 r9,r0,r7
   14fc6:	d0 77 58    	movl -(r7),r8
   14fc9:	dd 58       	pushl r8
   14fcb:	fb 01 ef 3e 	calls $0x1,14b10 <__hi0bits_D2A>
   14fcf:	fb ff ff 
   14fd2:	d0 50 53    	movl r0,r3
   14fd5:	c3 50 20 66 	subl3 r0,$0x20,(r6)
   14fd9:	d1 50 07    	cmpl r0,$0x7
   14fdc:	14 03       	bgtr 14fe1 <__b2d_D2A+0x3d>
   14fde:	31 87 00    	brw 15068 <__b2d_D2A+0xc4>
   14fe1:	d1 57 59    	cmpl r7,r9
   14fe4:	1b 7e       	blequ 15064 <__b2d_D2A+0xc0>
   14fe6:	d0 77 54    	movl -(r7),r4
   14fe9:	c2 08 53    	subl2 $0x8,r3
   14fec:	13 69       	beql 15057 <__b2d_D2A+0xb3>
   14fee:	78 53 58 50 	ashl r3,r8,r0
   14ff2:	c3 53 20 52 	subl3 r3,$0x20,r2
   14ff6:	83 52 20 51 	subb3 r2,$0x20,r1
   14ffa:	ef 52 51 54 	extzv r2,r1,r4,r1
   14ffe:	51 
   14fff:	c8 51 50    	bisl2 r1,r0
   15002:	c9 8f 00 00 	bisl3 $0x40800000,r0,r5
   15006:	80 40 50 55 
   1500a:	d1 57 59    	cmpl r7,r9
   1500d:	1b 44       	blequ 15053 <__b2d_D2A+0xaf>
   1500f:	d0 a7 fc 58 	movl 0xfffffffc(r7),r8
   15013:	78 53 54 52 	ashl r3,r4,r2
   15017:	c3 53 20 51 	subl3 r3,$0x20,r1
   1501b:	83 51 20 50 	subb3 r1,$0x20,r0
   1501f:	ef 51 50 58 	extzv r1,r0,r8,r0
   15023:	50 
   15024:	c8 52 50    	bisl2 r2,r0
   15027:	9c 10 55 ad 	rotl $0x10,r5,0xfffffff0(fp)
   1502b:	f0 
   1502c:	9c 10 50 ad 	rotl $0x10,r0,0xfffffff4(fp)
   15030:	f4 
   15031:	70 ad f0 50 	movd 0xfffffff0(fp),r0
   15035:	d0 ad f8 52 	movl 0xfffffff8(fp),r2
   15039:	d1 52 ef 58 	cmpl r2,3bf98 <__guard_local>
   1503d:	6f 02 00 
   15040:	13 10       	beql 15052 <__b2d_D2A+0xae>
   15042:	dd ad f8    	pushl 0xfffffff8(fp)
   15045:	9f ef a5 5c 	pushab 2acf0 <__tens_D2A+0xc8>
   15049:	01 00 
   1504b:	fb 02 ef 1a 	calls $0x2,1666c <__stack_smash_handler>
   1504f:	16 00 00 
   15052:	04          	ret
   15053:	d4 58       	clrf r8
   15055:	11 bc       	brb 15013 <__b2d_D2A+0x6f>
   15057:	c9 8f 00 00 	bisl3 $0x40800000,r8,r5
   1505b:	80 40 58 55 
   1505f:	d0 54 50    	movl r4,r0
   15062:	11 c3       	brb 15027 <__b2d_D2A+0x83>
   15064:	d4 54       	clrf r4
   15066:	11 81       	brb 14fe9 <__b2d_D2A+0x45>
   15068:	c3 50 08 51 	subl3 r0,$0x8,r1
   1506c:	83 51 20 50 	subb3 r1,$0x20,r0
   15070:	ef 51 50 58 	extzv r1,r0,r8,r0
   15074:	50 
   15075:	c9 8f 00 00 	bisl3 $0x40800000,r0,r5
   15079:	80 40 50 55 
   1507d:	d1 57 59    	cmpl r7,r9
   15080:	1b 1e       	blequ 150a0 <__b2d_D2A+0xfc>
   15082:	d0 a7 fc 54 	movl 0xfffffffc(r7),r4
   15086:	c1 53 18 50 	addl3 r3,$0x18,r0
   1508a:	78 50 58 50 	ashl r0,r8,r0
   1508e:	c3 53 08 52 	subl3 r3,$0x8,r2
   15092:	83 52 20 51 	subb3 r2,$0x20,r1
   15096:	ef 52 51 54 	extzv r2,r1,r4,r1
   1509a:	51 
   1509b:	c8 51 50    	bisl2 r1,r0
   1509e:	11 87       	brb 15027 <__b2d_D2A+0x83>
   150a0:	d4 54       	clrf r4
   150a2:	11 e2       	brb 15086 <__b2d_D2A+0xe2>

000150a4 <__d2b_D2A>:
   150a4:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   150a6:	c2 18 5e    	subl2 $0x18,sp
   150a9:	d0 ef e9 6e 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   150ad:	02 00 ad f8 
   150b1:	d0 ac 0c 5a 	movl 0xc(ap),r10
   150b5:	d0 ac 10 5b 	movl 0x10(ap),r11
   150b9:	70 ac 04 ad 	movd 0x4(ap),0xfffffff0(fp)
   150bd:	f0 
   150be:	9c 10 ad f0 	rotl $0x10,0xfffffff0(fp),r6
   150c2:	56 
   150c3:	9c 10 ad f4 	rotl $0x10,0xfffffff4(fp),r8
   150c7:	58 
   150c8:	dd 01       	pushl $0x1
   150ca:	fb 01 ef bf 	calls $0x1,14890 <__Balloc_D2A>
   150ce:	f7 ff ff 
   150d1:	d0 50 57    	movl r0,r7
   150d4:	12 03       	bneq 150d9 <__d2b_D2A+0x35>
   150d6:	31 b0 00    	brw 15189 <__d2b_D2A+0xe5>
   150d9:	c1 50 14 59 	addl3 r0,$0x14,r9
   150dd:	cb 8f 00 00 	bicl3 $0xff800000,r6,r0
   150e1:	80 ff 56 50 
   150e5:	d0 50 ad e8 	movl r0,0xffffffe8(fp)
   150e9:	9c 09 56 56 	rotl $0x9,r6,r6
   150ed:	9a 56 56    	movzbl r6,r6
   150f0:	c9 8f 00 00 	bisl3 $0x00800000,r0,0xffffffe8(fp)
   150f4:	80 00 50 ad 
   150f8:	e8 
   150f9:	d0 58 ad ec 	movl r8,0xffffffec(fp)
   150fd:	13 72       	beql 15171 <__d2b_D2A+0xcd>
   150ff:	9f ad ec    	pushab 0xffffffec(fp)
   15102:	fb 01 ef a9 	calls $0x1,149b2 <__lo0bits_D2A>
   15106:	f8 ff ff 
   15109:	d0 50 52    	movl r0,r2
   1510c:	13 5d       	beql 1516b <__d2b_D2A+0xc7>
   1510e:	c3 50 20 50 	subl3 r0,$0x20,r0
   15112:	78 50 ad e8 	ashl r0,0xffffffe8(fp),r0
   15116:	50 
   15117:	c9 50 ad ec 	bisl3 r0,0xffffffec(fp),(r9)
   1511b:	69 
   1511c:	83 52 20 51 	subb3 r2,$0x20,r1
   15120:	d0 ad e8 50 	movl 0xffffffe8(fp),r0
   15124:	ef 52 51 50 	extzv r2,r1,r0,0xffffffe8(fp)
   15128:	ad e8 
   1512a:	d0 ad e8 50 	movl 0xffffffe8(fp),r0
   1512e:	d0 50 a9 04 	movl r0,0x4(r9)
   15132:	13 32       	beql 15166 <__d2b_D2A+0xc2>
   15134:	d0 02 50    	movl $0x2,r0
   15137:	d0 50 a7 10 	movl r0,0x10(r7)
   1513b:	9e 46 c2 48 	movab 0xffffff48(r2)[r6],(r10)
   1513f:	ff 6a 
   15141:	c3 52 38 6b 	subl3 r2,$0x38,(r11)
   15145:	d0 57 50    	movl r7,r0
   15148:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   1514c:	d1 51 ef 45 	cmpl r1,3bf98 <__guard_local>
   15150:	6e 02 00 
   15153:	13 10       	beql 15165 <__d2b_D2A+0xc1>
   15155:	dd ad f8    	pushl 0xfffffff8(fp)
   15158:	9f ef 9c 5b 	pushab 2acfa <__tens_D2A+0xd2>
   1515c:	01 00 
   1515e:	fb 02 ef 07 	calls $0x2,1666c <__stack_smash_handler>
   15162:	15 00 00 
   15165:	04          	ret
   15166:	d0 01 50    	movl $0x1,r0
   15169:	11 cc       	brb 15137 <__d2b_D2A+0x93>
   1516b:	d0 ad ec 69 	movl 0xffffffec(fp),(r9)
   1516f:	11 b9       	brb 1512a <__d2b_D2A+0x86>
   15171:	9f ad e8    	pushab 0xffffffe8(fp)
   15174:	fb 01 ef 37 	calls $0x1,149b2 <__lo0bits_D2A>
   15178:	f8 ff ff 
   1517b:	d0 ad e8 69 	movl 0xffffffe8(fp),(r9)
   1517f:	d0 01 a7 10 	movl $0x1,0x10(r7)
   15183:	c1 50 20 52 	addl3 r0,$0x20,r2
   15187:	11 b2       	brb 1513b <__d2b_D2A+0x97>
   15189:	d4 50       	clrf r0
   1518b:	11 bb       	brb 15148 <__d2b_D2A+0xa4>
   1518d:	01          	nop

0001518e <strcp_D2A>:
   1518e:	00 00       	.word 0x0000 # Entry mask: < >
   15190:	c2 04 5e    	subl2 $0x4,sp
   15193:	d0 ac 04 52 	movl 0x4(ap),r2
   15197:	d0 ac 08 51 	movl 0x8(ap),r1
   1519b:	90 81 50    	movb (r1)+,r0
   1519e:	90 50 62    	movb r0,(r2)
   151a1:	13 0a       	beql 151ad <strcp_D2A+0x1f>
   151a3:	d6 52       	incl r2
   151a5:	90 81 50    	movb (r1)+,r0
   151a8:	90 50 62    	movb r0,(r2)
   151ab:	12 f6       	bneq 151a3 <strcp_D2A+0x15>
   151ad:	d0 52 50    	movl r2,r0
   151b0:	04          	ret
   151b1:	01          	nop

000151b2 <__negdi2>:
   151b2:	00 00       	.word 0x0000 # Entry mask: < >
   151b4:	c2 04 5e    	subl2 $0x4,sp
   151b7:	7d ac 04 50 	movq 0x4(ap),r0
   151bb:	ce 50 52    	mnegl r0,r2
   151be:	d0 52 53    	movl r2,r3
   151c1:	ce 51 51    	mnegl r1,r1
   151c4:	d5 52       	tstl r2
   151c6:	13 02       	beql 151ca <__negdi2+0x18>
   151c8:	d7 51       	decl r1
   151ca:	d0 51 54    	movl r1,r4
   151cd:	7d 53 50    	movq r3,r0
   151d0:	04          	ret
   151d1:	01          	nop

000151d2 <__sfvwrite>:
   151d2:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   151d4:	c2 08 5e    	subl2 $0x8,sp
   151d7:	d0 ac 04 5a 	movl 0x4(ap),r10
   151db:	d0 ac 08 50 	movl 0x8(ap),r0
   151df:	d5 a0 08    	tstl 0x8(r0)
   151e2:	13 7b       	beql 1525f <__sfvwrite+0x8d>
   151e4:	e1 03 aa 0c 	bbc $0x3,0xc(r10),151ee <__sfvwrite+0x1c>
   151e8:	05 
   151e9:	d5 aa 10    	tstl 0x10(r10)
   151ec:	12 10       	bneq 151fe <__sfvwrite+0x2c>
   151ee:	dd 5a       	pushl r10
   151f0:	fb 01 ef d1 	calls $0x1,155c8 <__swsetup>
   151f4:	03 00 00 
   151f7:	d5 50       	tstl r0
   151f9:	13 03       	beql 151fe <__sfvwrite+0x2c>
   151fb:	31 7c 02    	brw 1547a <__sfvwrite+0x2a8>
   151fe:	d0 ac 08 51 	movl 0x8(ap),r1
   15202:	d0 61 56    	movl (r1),r6
   15205:	d0 66 59    	movl (r6),r9
   15208:	d0 a6 04 58 	movl 0x4(r6),r8
   1520c:	c0 08 56    	addl2 $0x8,r6
   1520f:	32 aa 0c 50 	cvtwl 0xc(r10),r0
   15213:	e1 01 50 55 	bbc $0x1,r0,1526c <__sfvwrite+0x9a>
   15217:	d5 58       	tstl r8
   15219:	12 0e       	bneq 15229 <__sfvwrite+0x57>
   1521b:	d0 66 59    	movl (r6),r9
   1521e:	d0 a6 04 58 	movl 0x4(r6),r8
   15222:	c0 08 56    	addl2 $0x8,r6
   15225:	d5 58       	tstl r8
   15227:	13 f2       	beql 1521b <__sfvwrite+0x49>
   15229:	d0 58 50    	movl r8,r0
   1522c:	d1 58 8f 00 	cmpl r8,$0x00000400
   15230:	04 00 00 
   15233:	1b 05       	blequ 1523a <__sfvwrite+0x68>
   15235:	3c 8f 00 04 	movzwl $0x0400,r0
   15239:	50 
   1523a:	dd 50       	pushl r0
   1523c:	dd 59       	pushl r9
   1523e:	dd aa 1c    	pushl 0x1c(r10)
   15241:	fb 03 ba 2c 	calls $0x3,*0x2c(r10)
   15245:	d0 50 57    	movl r0,r7
   15248:	15 18       	bleq 15262 <__sfvwrite+0x90>
   1524a:	c0 50 59    	addl2 r0,r9
   1524d:	c2 50 58    	subl2 r0,r8
   15250:	d0 ac 08 51 	movl 0x8(ap),r1
   15254:	c3 50 a1 08 	subl3 r0,0x8(r1),r0
   15258:	50 
   15259:	d0 50 a1 08 	movl r0,0x8(r1)
   1525d:	12 b8       	bneq 15217 <__sfvwrite+0x45>
   1525f:	d4 50       	clrf r0
   15261:	04          	ret
   15262:	a8 8f 40 00 	bisw2 $0x0040,0xc(r10)
   15266:	aa 0c 
   15268:	d2 00 50    	mcoml $0x0,r0
   1526b:	04          	ret
   1526c:	e9 50 03    	blbc r0,15272 <__sfvwrite+0xa0>
   1526f:	31 1b 01    	brw 1538d <__sfvwrite+0x1bb>
   15272:	d5 58       	tstl r8
   15274:	12 0e       	bneq 15284 <__sfvwrite+0xb2>
   15276:	d0 66 59    	movl (r6),r9
   15279:	d0 a6 04 58 	movl 0x4(r6),r8
   1527d:	c0 08 56    	addl2 $0x8,r6
   15280:	d5 58       	tstl r8
   15282:	13 f2       	beql 15276 <__sfvwrite+0xa4>
   15284:	b0 aa 0c 50 	movw 0xc(r10),r0
   15288:	ca 8f ff bd 	bicl2 $0xffffbdff,r0
   1528c:	ff ff 50 
   1528f:	d1 50 8f 00 	cmpl r0,$0x00004200
   15293:	42 00 00 
   15296:	12 03       	bneq 1529b <__sfvwrite+0xc9>
   15298:	31 a2 00    	brw 1533d <__sfvwrite+0x16b>
   1529b:	d0 aa 08 57 	movl 0x8(r10),r7
   1529f:	e1 01 aa 0d 	bbc $0x1,0xd(r10),152da <__sfvwrite+0x108>
   152a3:	36 
   152a4:	d1 58 57    	cmpl r8,r7
   152a7:	1e 03       	bcc 152ac <__sfvwrite+0xda>
   152a9:	d0 58 57    	movl r8,r7
   152ac:	dd 57       	pushl r7
   152ae:	dd 59       	pushl r9
   152b0:	dd 6a       	pushl (r10)
   152b2:	fb 03 ef 35 	calls $0x3,166ee <memcpy>
   152b6:	14 00 00 
   152b9:	c2 57 aa 08 	subl2 r7,0x8(r10)
   152bd:	c0 57 6a    	addl2 r7,(r10)
   152c0:	d0 58 57    	movl r8,r7
   152c3:	c0 57 59    	addl2 r7,r9
   152c6:	c2 57 58    	subl2 r7,r8
   152c9:	d0 ac 08 51 	movl 0x8(ap),r1
   152cd:	c3 57 a1 08 	subl3 r7,0x8(r1),r0
   152d1:	50 
   152d2:	d0 50 a1 08 	movl r0,0x8(r1)
   152d6:	12 9a       	bneq 15272 <__sfvwrite+0xa0>
   152d8:	11 85       	brb 1525f <__sfvwrite+0x8d>
   152da:	d0 6a 50    	movl (r10),r0
   152dd:	d1 50 aa 10 	cmpl r0,0x10(r10)
   152e1:	1b 05       	blequ 152e8 <__sfvwrite+0x116>
   152e3:	d1 58 57    	cmpl r8,r7
   152e6:	1a 35       	bgtru 1531d <__sfvwrite+0x14b>
   152e8:	d0 aa 14 57 	movl 0x14(r10),r7
   152ec:	d1 58 57    	cmpl r8,r7
   152ef:	1f 13       	blssu 15304 <__sfvwrite+0x132>
   152f1:	dd 57       	pushl r7
   152f3:	dd 59       	pushl r9
   152f5:	dd aa 1c    	pushl 0x1c(r10)
   152f8:	fb 03 ba 2c 	calls $0x3,*0x2c(r10)
   152fc:	d0 50 57    	movl r0,r7
   152ff:	14 c2       	bgtr 152c3 <__sfvwrite+0xf1>
   15301:	31 5e ff    	brw 15262 <__sfvwrite+0x90>
   15304:	d0 58 57    	movl r8,r7
   15307:	dd 58       	pushl r8
   15309:	dd 59       	pushl r9
   1530b:	dd 6a       	pushl (r10)
   1530d:	fb 03 ef da 	calls $0x3,166ee <memcpy>
   15311:	13 00 00 
   15314:	c2 58 aa 08 	subl2 r8,0x8(r10)
   15318:	c0 58 6a    	addl2 r8,(r10)
   1531b:	11 a6       	brb 152c3 <__sfvwrite+0xf1>
   1531d:	dd 57       	pushl r7
   1531f:	dd 59       	pushl r9
   15321:	dd 50       	pushl r0
   15323:	fb 03 ef c4 	calls $0x3,166ee <memcpy>
   15327:	13 00 00 
   1532a:	c0 57 6a    	addl2 r7,(r10)
   1532d:	dd 5a       	pushl r10
   1532f:	fb 01 ef ba 	calls $0x1,154f0 <__sflush>
   15333:	01 00 00 
   15336:	d5 50       	tstl r0
   15338:	13 89       	beql 152c3 <__sfvwrite+0xf1>
   1533a:	31 25 ff    	brw 15262 <__sfvwrite+0x90>
   1533d:	d1 aa 08 58 	cmpl 0x8(r10),r8
   15341:	1f 03       	blssu 15346 <__sfvwrite+0x174>
   15343:	31 55 ff    	brw 1529b <__sfvwrite+0xc9>
   15346:	c3 aa 10 6a 	subl3 0x10(r10),(r10),r11
   1534a:	5b 
   1534b:	d0 aa 14 57 	movl 0x14(r10),r7
   1534f:	3e 47 9f 01 	movaw *0x1[r7],r7
   15353:	00 00 00 57 
   15357:	c1 5b 58 50 	addl3 r11,r8,r0
   1535b:	d1 57 50    	cmpl r7,r0
   1535e:	1f ef       	blssu 1534f <__sfvwrite+0x17d>
   15360:	9f a7 01    	pushab 0x1(r7)
   15363:	dd aa 10    	pushl 0x10(r10)
   15366:	fb 02 ef 1b 	calls $0x2,18c88 <realloc>
   1536a:	39 00 00 
   1536d:	d0 50 51    	movl r0,r1
   15370:	12 03       	bneq 15375 <__sfvwrite+0x1a3>
   15372:	31 ed fe    	brw 15262 <__sfvwrite+0x90>
   15375:	c3 aa 14 57 	subl3 0x14(r10),r7,r0
   15379:	50 
   1537a:	c0 50 aa 08 	addl2 r0,0x8(r10)
   1537e:	d0 51 aa 10 	movl r1,0x10(r10)
   15382:	d0 57 aa 14 	movl r7,0x14(r10)
   15386:	c1 51 5b 6a 	addl3 r1,r11,(r10)
   1538a:	31 0e ff    	brw 1529b <__sfvwrite+0xc9>
   1538d:	d4 ad f8    	clrf 0xfffffff8(fp)
   15390:	d4 5b       	clrf r11
   15392:	d5 58       	tstl r8
   15394:	12 11       	bneq 153a7 <__sfvwrite+0x1d5>
   15396:	d4 ad f8    	clrf 0xfffffff8(fp)
   15399:	d0 66 59    	movl (r6),r9
   1539c:	d0 a6 04 58 	movl 0x4(r6),r8
   153a0:	c0 08 56    	addl2 $0x8,r6
   153a3:	d5 58       	tstl r8
   153a5:	13 ef       	beql 15396 <__sfvwrite+0x1c4>
   153a7:	d5 ad f8    	tstl 0xfffffff8(fp)
   153aa:	12 03       	bneq 153af <__sfvwrite+0x1dd>
   153ac:	31 a6 00    	brw 15455 <__sfvwrite+0x283>
   153af:	d0 5b 50    	movl r11,r0
   153b2:	d1 5b 58    	cmpl r11,r8
   153b5:	1b 03       	blequ 153ba <__sfvwrite+0x1e8>
   153b7:	d0 58 50    	movl r8,r0
   153ba:	c1 aa 08 aa 	addl3 0x8(r10),0x14(r10),r7
   153be:	14 57 
   153c0:	d0 6a 51    	movl (r10),r1
   153c3:	d1 51 aa 10 	cmpl r1,0x10(r10)
   153c7:	1b 05       	blequ 153ce <__sfvwrite+0x1fc>
   153c9:	d1 50 57    	cmpl r0,r7
   153cc:	14 67       	bgtr 15435 <__sfvwrite+0x263>
   153ce:	d0 aa 14 57 	movl 0x14(r10),r7
   153d2:	d1 50 57    	cmpl r0,r7
   153d5:	19 45       	blss 1541c <__sfvwrite+0x24a>
   153d7:	dd 57       	pushl r7
   153d9:	dd 59       	pushl r9
   153db:	dd aa 1c    	pushl 0x1c(r10)
   153de:	fb 03 ba 2c 	calls $0x3,*0x2c(r10)
   153e2:	d0 50 57    	movl r0,r7
   153e5:	14 03       	bgtr 153ea <__sfvwrite+0x218>
   153e7:	31 78 fe    	brw 15262 <__sfvwrite+0x90>
   153ea:	c2 57 5b    	subl2 r7,r11
   153ed:	13 18       	beql 15407 <__sfvwrite+0x235>
   153ef:	c0 57 59    	addl2 r7,r9
   153f2:	c2 57 58    	subl2 r7,r8
   153f5:	d0 ac 08 51 	movl 0x8(ap),r1
   153f9:	c3 57 a1 08 	subl3 r7,0x8(r1),r0
   153fd:	50 
   153fe:	d0 50 a1 08 	movl r0,0x8(r1)
   15402:	12 8e       	bneq 15392 <__sfvwrite+0x1c0>
   15404:	31 58 fe    	brw 1525f <__sfvwrite+0x8d>
   15407:	dd 5a       	pushl r10
   15409:	fb 01 ef e0 	calls $0x1,154f0 <__sflush>
   1540d:	00 00 00 
   15410:	d5 50       	tstl r0
   15412:	13 03       	beql 15417 <__sfvwrite+0x245>
   15414:	31 4b fe    	brw 15262 <__sfvwrite+0x90>
   15417:	d4 ad f8    	clrf 0xfffffff8(fp)
   1541a:	11 d3       	brb 153ef <__sfvwrite+0x21d>
   1541c:	d0 50 57    	movl r0,r7
   1541f:	dd 50       	pushl r0
   15421:	dd 59       	pushl r9
   15423:	dd 6a       	pushl (r10)
   15425:	fb 03 ef c2 	calls $0x3,166ee <memcpy>
   15429:	12 00 00 
   1542c:	c2 57 aa 08 	subl2 r7,0x8(r10)
   15430:	c0 57 6a    	addl2 r7,(r10)
   15433:	11 b5       	brb 153ea <__sfvwrite+0x218>
   15435:	dd 57       	pushl r7
   15437:	dd 59       	pushl r9
   15439:	dd 51       	pushl r1
   1543b:	fb 03 ef ac 	calls $0x3,166ee <memcpy>
   1543f:	12 00 00 
   15442:	c0 57 6a    	addl2 r7,(r10)
   15445:	dd 5a       	pushl r10
   15447:	fb 01 ef a2 	calls $0x1,154f0 <__sflush>
   1544b:	00 00 00 
   1544e:	d5 50       	tstl r0
   15450:	13 98       	beql 153ea <__sfvwrite+0x218>
   15452:	31 0d fe    	brw 15262 <__sfvwrite+0x90>
   15455:	dd 58       	pushl r8
   15457:	dd 0a       	pushl $0xa
   15459:	dd 59       	pushl r9
   1545b:	fb 03 ef e4 	calls $0x3,15846 <memchr>
   1545f:	03 00 00 
   15462:	d5 50       	tstl r0
   15464:	13 0e       	beql 15474 <__sfvwrite+0x2a2>
   15466:	c2 59 50    	subl2 r9,r0
   15469:	c1 50 01 5b 	addl3 r0,$0x1,r11
   1546d:	d0 01 ad f8 	movl $0x1,0xfffffff8(fp)
   15471:	31 3b ff    	brw 153af <__sfvwrite+0x1dd>
   15474:	c1 58 01 5b 	addl3 r8,$0x1,r11
   15478:	11 f3       	brb 1546d <__sfvwrite+0x29b>
   1547a:	fb 00 ef 47 	calls $0x0,109c8 <___errno>
   1547e:	b5 ff ff 
   15481:	d0 09 60    	movl $0x9,(r0)
   15484:	d2 00 50    	mcoml $0x0,r0
   15487:	04          	ret

00015488 <fflush>:
   15488:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   1548a:	c2 04 5e    	subl2 $0x4,sp
   1548d:	d0 ac 04 56 	movl 0x4(ap),r6
   15491:	13 4e       	beql 154e1 <fflush+0x59>
   15493:	d5 ef 4b 6c 	tstl 5c0e4 <__isthreaded>
   15497:	04 00 
   15499:	12 3b       	bneq 154d6 <fflush+0x4e>
   1549b:	b0 a6 0c 50 	movw 0xc(r6),r0
   1549f:	d3 50 18    	bitl r0,$0x18
   154a2:	12 24       	bneq 154c8 <fflush+0x40>
   154a4:	fb 00 ef 1d 	calls $0x0,109c8 <___errno>
   154a8:	b5 ff ff 
   154ab:	d0 09 60    	movl $0x9,(r0)
   154ae:	d2 00 57    	mcoml $0x0,r7
   154b1:	d5 ef 2d 6c 	tstl 5c0e4 <__isthreaded>
   154b5:	04 00 
   154b7:	12 04       	bneq 154bd <fflush+0x35>
   154b9:	d0 57 50    	movl r7,r0
   154bc:	04          	ret
   154bd:	dd 56       	pushl r6
   154bf:	fb 01 ef 62 	calls $0x1,16b28 <_weak_funlockfile>
   154c3:	16 00 00 
   154c6:	11 f1       	brb 154b9 <fflush+0x31>
   154c8:	dd 56       	pushl r6
   154ca:	fb 01 ef 1f 	calls $0x1,154f0 <__sflush>
   154ce:	00 00 00 
   154d1:	d0 50 57    	movl r0,r7
   154d4:	11 db       	brb 154b1 <fflush+0x29>
   154d6:	dd 56       	pushl r6
   154d8:	fb 01 ef 3b 	calls $0x1,16b1a <_weak_flockfile>
   154dc:	16 00 00 
   154df:	11 ba       	brb 1549b <fflush+0x13>
   154e1:	9f ef 65 00 	pushab 1554c <__sflush_locked>
   154e5:	00 00 
   154e7:	fb 01 ef 9e 	calls $0x1,1558c <_fwalk>
   154eb:	00 00 00 
   154ee:	04          	ret
   154ef:	01          	nop

000154f0 <__sflush>:
   154f0:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   154f2:	c2 04 5e    	subl2 $0x4,sp
   154f5:	d0 ac 04 58 	movl 0x4(ap),r8
   154f9:	32 a8 0c 50 	cvtwl 0xc(r8),r0
   154fd:	e1 03 50 48 	bbc $0x3,r0,15549 <__sflush+0x59>
   15501:	d0 a8 10 57 	movl 0x10(r8),r7
   15505:	13 42       	beql 15549 <__sflush+0x59>
   15507:	c3 57 68 56 	subl3 r7,(r8),r6
   1550b:	d0 57 68    	movl r7,(r8)
   1550e:	d3 50 03    	bitl r0,$0x3
   15511:	12 32       	bneq 15545 <__sflush+0x55>
   15513:	d0 a8 14 50 	movl 0x14(r8),r0
   15517:	d0 50 a8 08 	movl r0,0x8(r8)
   1551b:	d5 56       	tstl r6
   1551d:	15 19       	bleq 15538 <__sflush+0x48>
   1551f:	dd 56       	pushl r6
   15521:	dd 57       	pushl r7
   15523:	dd a8 1c    	pushl 0x1c(r8)
   15526:	fb 03 b8 2c 	calls $0x3,*0x2c(r8)
   1552a:	d5 50       	tstl r0
   1552c:	15 0d       	bleq 1553b <__sflush+0x4b>
   1552e:	c2 50 56    	subl2 r0,r6
   15531:	c0 50 57    	addl2 r0,r7
   15534:	d5 56       	tstl r6
   15536:	14 e7       	bgtr 1551f <__sflush+0x2f>
   15538:	d4 50       	clrf r0
   1553a:	04          	ret
   1553b:	a8 8f 40 00 	bisw2 $0x0040,0xc(r8)
   1553f:	a8 0c 
   15541:	d2 00 50    	mcoml $0x0,r0
   15544:	04          	ret
   15545:	d4 50       	clrf r0
   15547:	11 ce       	brb 15517 <__sflush+0x27>
   15549:	d4 50       	clrf r0
   1554b:	04          	ret

0001554c <__sflush_locked>:
   1554c:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   1554e:	c2 04 5e    	subl2 $0x4,sp
   15551:	d0 ac 04 57 	movl 0x4(ap),r7
   15555:	d5 ef 89 6b 	tstl 5c0e4 <__isthreaded>
   15559:	04 00 
   1555b:	12 23       	bneq 15580 <__sflush_locked+0x34>
   1555d:	dd 57       	pushl r7
   1555f:	fb 01 ef 8a 	calls $0x1,154f0 <__sflush>
   15563:	ff ff ff 
   15566:	d0 50 56    	movl r0,r6
   15569:	d5 ef 75 6b 	tstl 5c0e4 <__isthreaded>
   1556d:	04 00 
   1556f:	12 04       	bneq 15575 <__sflush_locked+0x29>
   15571:	d0 56 50    	movl r6,r0
   15574:	04          	ret
   15575:	dd 57       	pushl r7
   15577:	fb 01 ef aa 	calls $0x1,16b28 <_weak_funlockfile>
   1557b:	15 00 00 
   1557e:	11 f1       	brb 15571 <__sflush_locked+0x25>
   15580:	dd 57       	pushl r7
   15582:	fb 01 ef 91 	calls $0x1,16b1a <_weak_flockfile>
   15586:	15 00 00 
   15589:	11 d2       	brb 1555d <__sflush_locked+0x11>
   1558b:	01          	nop

0001558c <_fwalk>:
   1558c:	c0 07       	.word 0x07c0 # Entry mask: < r10 r9 r8 r7 r6 >
   1558e:	c2 04 5e    	subl2 $0x4,sp
   15591:	d0 ac 04 5a 	movl 0x4(ap),r10
   15595:	d4 58       	clrf r8
   15597:	9e ef 3b 6b 	movab 5c0d8 <__sglue>,r9
   1559b:	04 00 59 
   1559e:	13 24       	beql 155c4 <_fwalk+0x38>
   155a0:	d0 a9 08 57 	movl 0x8(r9),r7
   155a4:	c3 01 a9 04 	subl3 $0x1,0x4(r9),r6
   155a8:	56 
   155a9:	19 14       	blss 155bf <_fwalk+0x33>
   155ab:	b5 a7 0c    	tstw 0xc(r7)
   155ae:	15 08       	bleq 155b8 <_fwalk+0x2c>
   155b0:	dd 57       	pushl r7
   155b2:	fb 01 6a    	calls $0x1,(r10)
   155b5:	c8 50 58    	bisl2 r0,r8
   155b8:	9e a7 58 57 	movab 0x58(r7),r7
   155bc:	f4 56 ec    	sobgeq r6,155ab <_fwalk+0x1f>
   155bf:	d0 69 59    	movl (r9),r9
   155c2:	12 dc       	bneq 155a0 <_fwalk+0x14>
   155c4:	d0 58 50    	movl r8,r0
   155c7:	04          	ret

000155c8 <__swsetup>:
   155c8:	40 00       	.word 0x0040 # Entry mask: < r6 >
   155ca:	c2 04 5e    	subl2 $0x4,sp
   155cd:	d0 ac 04 56 	movl 0x4(ap),r6
   155d1:	d5 ef 7d ce 	tstl 62454 <__sdidinit>
   155d5:	04 00 
   155d7:	12 03       	bneq 155dc <__swsetup+0x14>
   155d9:	31 84 00    	brw 15660 <__swsetup+0x98>
   155dc:	32 a6 0c 50 	cvtwl 0xc(r6),r0
   155e0:	e0 03 50 32 	bbs $0x3,r0,15616 <__swsetup+0x4e>
   155e4:	e1 04 50 74 	bbc $0x4,r0,1565c <__swsetup+0x94>
   155e8:	e1 02 50 26 	bbc $0x2,r0,15612 <__swsetup+0x4a>
   155ec:	d0 b6 30 51 	movl *0x30(r6),r1
   155f0:	13 15       	beql 15607 <__swsetup+0x3f>
   155f2:	9e a6 40 50 	movab 0x40(r6),r0
   155f6:	d1 51 50    	cmpl r1,r0
   155f9:	13 09       	beql 15604 <__swsetup+0x3c>
   155fb:	dd 51       	pushl r1
   155fd:	fb 01 ef c4 	calls $0x1,188c8 <free>
   15601:	32 00 00 
   15604:	d4 b6 30    	clrf *0x30(r6)
   15607:	aa 24 a6 0c 	bicw2 $0x24,0xc(r6)
   1560b:	d4 a6 04    	clrf 0x4(r6)
   1560e:	d0 a6 10 66 	movl 0x10(r6),(r6)
   15612:	a8 08 a6 0c 	bisw2 $0x8,0xc(r6)
   15616:	d5 a6 10    	tstl 0x10(r6)
   15619:	12 1d       	bneq 15638 <__swsetup+0x70>
   1561b:	b0 a6 0c 50 	movw 0xc(r6),r0
   1561f:	ca 8f ff bd 	bicl2 $0xffffbdff,r0
   15623:	ff ff 50 
   15626:	d1 50 8f 00 	cmpl r0,$0x00000200
   1562a:	02 00 00 
   1562d:	13 2d       	beql 1565c <__swsetup+0x94>
   1562f:	dd 56       	pushl r6
   15631:	fb 01 ef 32 	calls $0x1,1566a <__smakebuf>
   15635:	00 00 00 
   15638:	32 a6 0c 50 	cvtwl 0xc(r6),r0
   1563c:	e9 50 0b    	blbc r0,1564a <__swsetup+0x82>
   1563f:	d4 a6 08    	clrf 0x8(r6)
   15642:	ce a6 14 a6 	mnegl 0x14(r6),0x18(r6)
   15646:	18 
   15647:	d4 50       	clrf r0
   15649:	04          	ret
   1564a:	e0 01 50 0a 	bbs $0x1,r0,15658 <__swsetup+0x90>
   1564e:	d0 a6 14 50 	movl 0x14(r6),r0
   15652:	d0 50 a6 08 	movl r0,0x8(r6)
   15656:	11 ef       	brb 15647 <__swsetup+0x7f>
   15658:	d4 50       	clrf r0
   1565a:	11 f6       	brb 15652 <__swsetup+0x8a>
   1565c:	d2 00 50    	mcoml $0x0,r0
   1565f:	04          	ret
   15660:	fb 00 ef ef 	calls $0x0,10b56 <__sinit>
   15664:	b4 ff ff 
   15667:	31 72 ff    	brw 155dc <__swsetup+0x14>

0001566a <__smakebuf>:
   1566a:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   1566c:	c2 0c 5e    	subl2 $0xc,sp
   1566f:	d0 ac 04 56 	movl 0x4(ap),r6
   15673:	e1 01 a6 0c 	bbc $0x1,0xc(r6),15688 <__smakebuf+0x1e>
   15677:	10 
   15678:	9e a6 43 50 	movab 0x43(r6),r0
   1567c:	d0 50 66    	movl r0,(r6)
   1567f:	d0 50 a6 10 	movl r0,0x10(r6)
   15683:	d0 01 a6 14 	movl $0x1,0x14(r6)
   15687:	04          	ret
   15688:	9f ad f8    	pushab 0xfffffff8(fp)
   1568b:	9f ad f4    	pushab 0xfffffff4(fp)
   1568e:	dd 56       	pushl r6
   15690:	fb 03 ef 49 	calls $0x3,156e0 <__swhatbuf>
   15694:	00 00 00 
   15697:	d0 50 57    	movl r0,r7
   1569a:	dd ad f4    	pushl 0xfffffff4(fp)
   1569d:	fb 01 ef 7e 	calls $0x1,18622 <malloc>
   156a1:	2f 00 00 
   156a4:	d5 50       	tstl r0
   156a6:	13 31       	beql 156d9 <__smakebuf+0x6f>
   156a8:	c8 8f 80 00 	bisl2 $0x00000080,r7
   156ac:	00 00 57 
   156af:	d0 50 66    	movl r0,(r6)
   156b2:	d0 50 a6 10 	movl r0,0x10(r6)
   156b6:	d0 ad f4 a6 	movl 0xfffffff4(fp),0x14(r6)
   156ba:	14 
   156bb:	d5 ad f8    	tstl 0xfffffff8(fp)
   156be:	12 05       	bneq 156c5 <__smakebuf+0x5b>
   156c0:	a8 57 a6 0c 	bisw2 r7,0xc(r6)
   156c4:	04          	ret
   156c5:	32 a6 0e 7e 	cvtwl 0xe(r6),-(sp)
   156c9:	fb 01 ef 52 	calls $0x1,15822 <isatty>
   156cd:	01 00 00 
   156d0:	d5 50       	tstl r0
   156d2:	13 ec       	beql 156c0 <__smakebuf+0x56>
   156d4:	c8 01 57    	bisl2 $0x1,r7
   156d7:	11 e7       	brb 156c0 <__smakebuf+0x56>
   156d9:	a8 02 a6 0c 	bisw2 $0x2,0xc(r6)
   156dd:	11 99       	brb 15678 <__smakebuf+0xe>
   156df:	01          	nop

000156e0 <__swhatbuf>:
   156e0:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   156e2:	9e ae 90 5e 	movab 0xffffff90(sp),sp
   156e6:	d0 ac 04 56 	movl 0x4(ap),r6
   156ea:	d0 ac 08 57 	movl 0x8(ap),r7
   156ee:	d0 ac 0c 58 	movl 0xc(ap),r8
   156f2:	b0 a6 0e 50 	movw 0xe(r6),r0
   156f6:	19 11       	blss 15709 <__swhatbuf+0x29>
   156f8:	9f ad 90    	pushab 0xffffff90(fp)
   156fb:	32 50 7e    	cvtwl r0,-(sp)
   156fe:	fb 02 ef a7 	calls $0x2,16aac <_thread_sys_fstat>
   15702:	13 00 00 
   15705:	d5 50       	tstl r0
   15707:	18 0d       	bgeq 15716 <__swhatbuf+0x36>
   15709:	d4 68       	clrf (r8)
   1570b:	3c 8f 00 04 	movzwl $0x0400,(r7)
   1570f:	67 
   15710:	3c 8f 00 08 	movzwl $0x0800,r0
   15714:	50 
   15715:	04          	ret
   15716:	d4 50       	clrf r0
   15718:	cb 8f ff 0f 	bicl3 $0xffff0fff,0xffffff90(fp),r1
   1571c:	ff ff ad 90 
   15720:	51 
   15721:	d1 51 8f 00 	cmpl r1,$0x00002000
   15725:	20 00 00 
   15728:	13 2f       	beql 15759 <__swhatbuf+0x79>
   1572a:	d0 50 68    	movl r0,(r8)
   1572d:	d0 ad e4 50 	movl 0xffffffe4(fp),r0
   15731:	13 d8       	beql 1570b <__swhatbuf+0x2b>
   15733:	d0 50 67    	movl r0,(r7)
   15736:	d0 50 a6 4c 	movl r0,0x4c(r6)
   1573a:	d1 51 8f 00 	cmpl r1,$0x00008000
   1573e:	80 00 00 
   15741:	13 06       	beql 15749 <__swhatbuf+0x69>
   15743:	3c 8f 00 08 	movzwl $0x0800,r0
   15747:	50 
   15748:	04          	ret
   15749:	d1 a6 28 8f 	cmpl 0x28(r6),$0x000157cc
   1574d:	cc 57 01 00 
   15751:	12 f0       	bneq 15743 <__swhatbuf+0x63>
   15753:	3c 8f 00 04 	movzwl $0x0400,r0
   15757:	50 
   15758:	04          	ret
   15759:	d0 01 50    	movl $0x1,r0
   1575c:	11 cc       	brb 1572a <__swhatbuf+0x4a>

0001575e <__sread>:
   1575e:	40 00       	.word 0x0040 # Entry mask: < r6 >
   15760:	c2 04 5e    	subl2 $0x4,sp
   15763:	d0 ac 04 56 	movl 0x4(ap),r6
   15767:	dd ac 0c    	pushl 0xc(ap)
   1576a:	dd ac 08    	pushl 0x8(ap)
   1576d:	32 a6 0e 7e 	cvtwl 0xe(r6),-(sp)
   15771:	fb 03 ef e4 	calls $0x3,16b5c <_thread_sys_read>
   15775:	13 00 00 
   15778:	d0 50 52    	movl r0,r2
   1577b:	19 11       	blss 1578e <__sread+0x30>
   1577d:	78 8f e1 50 	ashl $0xe1,r0,r1
   15781:	51 
   15782:	c0 50 a6 50 	addl2 r0,0x50(r6)
   15786:	d8 51 a6 54 	adwc r1,0x54(r6)
   1578a:	d0 52 50    	movl r2,r0
   1578d:	04          	ret
   1578e:	aa 8f 00 10 	bicw2 $0x1000,0xc(r6)
   15792:	a6 0c 
   15794:	11 f4       	brb 1578a <__sread+0x2c>

00015796 <__swrite>:
   15796:	40 00       	.word 0x0040 # Entry mask: < r6 >
   15798:	c2 04 5e    	subl2 $0x4,sp
   1579b:	d0 ac 04 56 	movl 0x4(ap),r6
   1579f:	e8 a6 0d 18 	blbs 0xd(r6),157bb <__swrite+0x25>
   157a3:	aa 8f 00 10 	bicw2 $0x1000,0xc(r6)
   157a7:	a6 0c 
   157a9:	dd ac 0c    	pushl 0xc(ap)
   157ac:	dd ac 08    	pushl 0x8(ap)
   157af:	32 a6 0e 7e 	cvtwl 0xe(r6),-(sp)
   157b3:	fb 03 ef 36 	calls $0x3,169f0 <_thread_sys_write>
   157b7:	12 00 00 
   157ba:	04          	ret
   157bb:	dd 02       	pushl $0x2
   157bd:	7c 7e       	clrd -(sp)
   157bf:	32 a6 0e 7e 	cvtwl 0xe(r6),-(sp)
   157c3:	fb 04 ef 40 	calls $0x4,16a0a <_thread_sys_lseek>
   157c7:	12 00 00 
   157ca:	11 d7       	brb 157a3 <__swrite+0xd>

000157cc <__sseek>:
   157cc:	40 00       	.word 0x0040 # Entry mask: < r6 >
   157ce:	c2 04 5e    	subl2 $0x4,sp
   157d1:	d0 ac 04 56 	movl 0x4(ap),r6
   157d5:	dd ac 10    	pushl 0x10(ap)
   157d8:	7d ac 08 7e 	movq 0x8(ap),-(sp)
   157dc:	32 a6 0e 7e 	cvtwl 0xe(r6),-(sp)
   157e0:	fb 04 ef 23 	calls $0x4,16a0a <_thread_sys_lseek>
   157e4:	12 00 00 
   157e7:	d1 50 8f ff 	cmpl r0,$0xffffffff
   157eb:	ff ff ff 
   157ee:	13 0b       	beql 157fb <__sseek+0x2f>
   157f0:	a8 8f 00 10 	bisw2 $0x1000,0xc(r6)
   157f4:	a6 0c 
   157f6:	7d 50 a6 50 	movq r0,0x50(r6)
   157fa:	04          	ret
   157fb:	d1 51 8f ff 	cmpl r1,$0xffffffff
   157ff:	ff ff ff 
   15802:	12 ec       	bneq 157f0 <__sseek+0x24>
   15804:	aa 8f 00 10 	bicw2 $0x1000,0xc(r6)
   15808:	a6 0c 
   1580a:	04          	ret
   1580b:	01          	nop

0001580c <__sclose>:
   1580c:	00 00       	.word 0x0000 # Entry mask: < >
   1580e:	c2 04 5e    	subl2 $0x4,sp
   15811:	d0 ac 04 50 	movl 0x4(ap),r0
   15815:	32 a0 0e 7e 	cvtwl 0xe(r0),-(sp)
   15819:	fb 01 ef 78 	calls $0x1,10698 <_thread_sys_close>
   1581d:	ae ff ff 
   15820:	04          	ret
   15821:	01          	nop

00015822 <isatty>:
   15822:	40 00       	.word 0x0040 # Entry mask: < r6 >
   15824:	c2 04 5e    	subl2 $0x4,sp
   15827:	d4 56       	clrf r6
   15829:	dd 0b       	pushl $0xb
   1582b:	dd ac 04    	pushl 0x4(ap)
   1582e:	fb 02 ef 63 	calls $0x2,16a98 <_thread_sys_fcntl>
   15832:	12 00 00 
   15835:	d1 50 8f ff 	cmpl r0,$0xffffffff
   15839:	ff ff ff 
   1583c:	13 03       	beql 15841 <isatty+0x1f>
   1583e:	d0 01 56    	movl $0x1,r6
   15841:	d0 56 50    	movl r6,r0
   15844:	04          	ret
   15845:	01          	nop

00015846 <memchr>:
   15846:	00 00       	.word 0x0000 # Entry mask: < >
   15848:	c2 04 5e    	subl2 $0x4,sp
   1584b:	d0 ac 08 52 	movl 0x8(ap),r2
   1584f:	d0 ac 0c 51 	movl 0xc(ap),r1
   15853:	13 0d       	beql 15862 <memchr+0x1c>
   15855:	d0 ac 04 50 	movl 0x4(ap),r0
   15859:	91 80 52    	cmpb (r0)+,r2
   1585c:	13 07       	beql 15865 <memchr+0x1f>
   1585e:	d7 51       	decl r1
   15860:	12 f7       	bneq 15859 <memchr+0x13>
   15862:	d4 50       	clrf r0
   15864:	04          	ret
   15865:	d7 50       	decl r0
   15867:	04          	ret

00015868 <__udivdi3>:
   15868:	00 00       	.word 0x0000 # Entry mask: < >
   1586a:	c2 04 5e    	subl2 $0x4,sp
   1586d:	d4 7e       	clrf -(sp)
   1586f:	7d ac 0c 7e 	movq 0xc(ap),-(sp)
   15873:	7d ac 04 7e 	movq 0x4(ap),-(sp)
   15877:	fb 05 ef 1e 	calls $0x5,1589c <__qdivrem>
   1587b:	00 00 00 
   1587e:	04          	ret
   1587f:	01          	nop

00015880 <__umoddi3>:
   15880:	00 00       	.word 0x0000 # Entry mask: < >
   15882:	c2 0c 5e    	subl2 $0xc,sp
   15885:	9f ad f4    	pushab 0xfffffff4(fp)
   15888:	7d ac 0c 7e 	movq 0xc(ap),-(sp)
   1588c:	7d ac 04 7e 	movq 0x4(ap),-(sp)
   15890:	fb 05 ef 05 	calls $0x5,1589c <__qdivrem>
   15894:	00 00 00 
   15897:	7d ad f4 50 	movq 0xfffffff4(fp),r0
   1589b:	04          	ret

0001589c <__qdivrem>:
   1589c:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   1589e:	9e ae a0 5e 	movab 0xffffffa0(sp),sp
   158a2:	7c ad cc    	clrd 0xffffffcc(fp)
   158a5:	7d ac 04 56 	movq 0x4(ap),r6
   158a9:	7d ac 0c 53 	movq 0xc(ap),r3
   158ad:	d0 ef e5 66 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   158b1:	02 00 ad f8 
   158b5:	d0 ac 14 ad 	movl 0x14(ap),0xffffffa0(fp)
   158b9:	a0 
   158ba:	c9 54 53 50 	bisl3 r4,r3,r0
   158be:	12 45       	bneq 15905 <__qdivrem+0x69>
   158c0:	9f ff 6e 68 	pushab *5c134 <zero.0>
   158c4:	04 00 
   158c6:	dd 01       	pushl $0x1
   158c8:	fb 02 ef 15 	calls $0x2,15ce4 <__udiv>
   158cc:	04 00 00 
   158cf:	d0 50 ad cc 	movl r0,0xffffffcc(fp)
   158d3:	d0 50 ad d0 	movl r0,0xffffffd0(fp)
   158d7:	d5 ad a0    	tstl 0xffffffa0(fp)
   158da:	13 07       	beql 158e3 <__qdivrem+0x47>
   158dc:	d0 ad a0 50 	movl 0xffffffa0(fp),r0
   158e0:	7d 56 60    	movq r6,(r0)
   158e3:	7d ad cc 50 	movq 0xffffffcc(fp),r0
   158e7:	d0 ad f8 52 	movl 0xfffffff8(fp),r2
   158eb:	d1 52 ef a6 	cmpl r2,3bf98 <__guard_local>
   158ef:	66 02 00 
   158f2:	13 10       	beql 15904 <__qdivrem+0x68>
   158f4:	dd ad f8    	pushl 0xfffffff8(fp)
   158f7:	9f ef 07 54 	pushab 2ad04 <__tens_D2A+0xdc>
   158fb:	01 00 
   158fd:	fb 02 ef 68 	calls $0x2,1666c <__stack_smash_handler>
   15901:	0d 00 00 
   15904:	04          	ret
   15905:	d1 54 57    	cmpl r4,r7
   15908:	1b 03       	blequ 1590d <__qdivrem+0x71>
   1590a:	31 7e 03    	brw 15c8b <__qdivrem+0x3ef>
   1590d:	12 03       	bneq 15912 <__qdivrem+0x76>
   1590f:	31 71 03    	brw 15c83 <__qdivrem+0x3e7>
   15912:	c3 14 5d 5b 	subl3 $0x14,fp,r11
   15916:	c3 20 5d ad 	subl3 $0x20,fp,0xffffffc8(fp)
   1591a:	c8 
   1591b:	c3 2c 5d ad 	subl3 $0x2c,fp,0xffffffc4(fp)
   1591f:	c4 
   15920:	7d 56 ad cc 	movq r6,0xffffffcc(fp)
   15924:	b4 6b       	clrw (r11)
   15926:	d0 10 52    	movl $0x10,r2
   15929:	ef 52 52 ad 	extzv r2,r2,0xffffffd0(fp),r0
   1592d:	d0 50 
   1592f:	b0 50 ad ee 	movw r0,0xffffffee(fp)
   15933:	b0 ad d0 ad 	movw 0xffffffd0(fp),0xfffffff0(fp)
   15937:	f0 
   15938:	ef 52 52 ad 	extzv r2,r2,0xffffffcc(fp),r0
   1593c:	cc 50 
   1593e:	b0 50 ad f2 	movw r0,0xfffffff2(fp)
   15942:	b0 ad cc ad 	movw 0xffffffcc(fp),0xfffffff4(fp)
   15946:	f4 
   15947:	7d 53 ad cc 	movq r3,0xffffffcc(fp)
   1594b:	ef 52 52 ad 	extzv r2,r2,0xffffffd0(fp),r0
   1594f:	d0 50 
   15951:	b0 50 ad e2 	movw r0,0xffffffe2(fp)
   15955:	b0 ad d0 ad 	movw 0xffffffd0(fp),0xffffffe4(fp)
   15959:	e4 
   1595a:	ef 52 52 ad 	extzv r2,r2,0xffffffcc(fp),r1
   1595e:	cc 51 
   15960:	b0 51 ad e6 	movw r1,0xffffffe6(fp)
   15964:	b0 ad cc ad 	movw 0xffffffcc(fp),0xffffffe8(fp)
   15968:	e8 
   15969:	d0 04 ad b8 	movl $0x4,0xffffffb8(fp)
   1596d:	b5 50       	tstw r0
   1596f:	12 19       	bneq 1598a <__qdivrem+0xee>
   15971:	d7 ad b8    	decl 0xffffffb8(fp)
   15974:	d1 ad b8 01 	cmpl 0xffffffb8(fp),$0x1
   15978:	12 03       	bneq 1597d <__qdivrem+0xe1>
   1597a:	31 54 02    	brw 15bd1 <__qdivrem+0x335>
   1597d:	c0 02 ad c8 	addl2 $0x2,0xffffffc8(fp)
   15981:	d0 ad c8 54 	movl 0xffffffc8(fp),r4
   15985:	b5 a4 02    	tstw 0x2(r4)
   15988:	13 e7       	beql 15971 <__qdivrem+0xd5>
   1598a:	c3 ad b8 04 	subl3 0xffffffb8(fp),$0x4,0xffffffbc(fp)
   1598e:	ad bc 
   15990:	b5 ab 02    	tstw 0x2(r11)
   15993:	12 0b       	bneq 159a0 <__qdivrem+0x104>
   15995:	d7 ad bc    	decl 0xffffffbc(fp)
   15998:	c0 02 5b    	addl2 $0x2,r11
   1599b:	b5 ab 02    	tstw 0x2(r11)
   1599e:	13 f5       	beql 15995 <__qdivrem+0xf9>
   159a0:	c3 ad bc 03 	subl3 0xffffffbc(fp),$0x3,r3
   159a4:	53 
   159a5:	19 0a       	blss 159b1 <__qdivrem+0x115>
   159a7:	d0 ad c4 50 	movl 0xffffffc4(fp),r0
   159ab:	b4 43 60    	clrw (r0)[r3]
   159ae:	f4 53 f6    	sobgeq r3,159a7 <__qdivrem+0x10b>
   159b1:	c3 ad bc 04 	subl3 0xffffffbc(fp),$0x4,r0
   159b5:	50 
   159b6:	d0 ad c4 51 	movl 0xffffffc4(fp),r1
   159ba:	3e 40 61 ad 	movaw (r1)[r0],0xffffffc4(fp)
   159be:	c4 
   159bf:	d4 ad b4    	clrf 0xffffffb4(fp)
   159c2:	d0 ad c8 52 	movl 0xffffffc8(fp),r2
   159c6:	3c a2 02 58 	movzwl 0x2(r2),r8
   159ca:	d1 58 8f ff 	cmpl r8,$0x00007fff
   159ce:	7f 00 00 
   159d1:	1a 0f       	bgtru 159e2 <__qdivrem+0x146>
   159d3:	d6 ad b4    	incl 0xffffffb4(fp)
   159d6:	c0 58 58    	addl2 r8,r8
   159d9:	d1 58 8f ff 	cmpl r8,$0x00007fff
   159dd:	7f 00 00 
   159e0:	1b f1       	blequ 159d3 <__qdivrem+0x137>
   159e2:	d5 ad b4    	tstl 0xffffffb4(fp)
   159e5:	15 23       	bleq 15a0a <__qdivrem+0x16e>
   159e7:	dd ad b4    	pushl 0xffffffb4(fp)
   159ea:	c1 ad bc ad 	addl3 0xffffffbc(fp),0xffffffb8(fp),-(sp)
   159ee:	b8 7e 
   159f0:	dd 5b       	pushl r11
   159f2:	9e cf a6 02 	movab 15c9c <shl>,r6
   159f6:	56 
   159f7:	fb 03 66    	calls $0x3,(r6)
   159fa:	dd ad b4    	pushl 0xffffffb4(fp)
   159fd:	c3 01 ad b8 	subl3 $0x1,0xffffffb8(fp),-(sp)
   15a01:	7e 
   15a02:	c1 ad c8 02 	addl3 0xffffffc8(fp),$0x2,-(sp)
   15a06:	7e 
   15a07:	fb 03 66    	calls $0x3,(r6)
   15a0a:	d4 57       	clrf r7
   15a0c:	d0 ad c8 54 	movl 0xffffffc8(fp),r4
   15a10:	b0 a4 02 ad 	movw 0x2(r4),0xffffffc2(fp)
   15a14:	c2 
   15a15:	b0 a4 04 ad 	movw 0x4(r4),0xffffffc0(fp)
   15a19:	c0 
   15a1a:	d0 5b 5a    	movl r11,r10
   15a1d:	b0 6a 56    	movw (r10),r6
   15a20:	b0 aa 02 50 	movw 0x2(r10),r0
   15a24:	b0 aa 04 58 	movw 0x4(r10),r8
   15a28:	b1 56 ad c2 	cmpw r6,0xffffffc2(fp)
   15a2c:	12 03       	bneq 15a31 <__qdivrem+0x195>
   15a2e:	31 93 01    	brw 15bc4 <__qdivrem+0x328>
   15a31:	78 10 56 56 	ashl $0x10,r6,r6
   15a35:	3c 50 50    	movzwl r0,r0
   15a38:	c8 50 56    	bisl2 r0,r6
   15a3b:	3c ad c2 ad 	movzwl 0xffffffc2(fp),0xffffffa4(fp)
   15a3f:	a4 
   15a40:	dd ad a4    	pushl 0xffffffa4(fp)
   15a43:	dd 56       	pushl r6
   15a45:	fb 02 ef 98 	calls $0x2,15ce4 <__udiv>
   15a49:	02 00 00 
   15a4c:	d0 50 59    	movl r0,r9
   15a4f:	dd ad a4    	pushl 0xffffffa4(fp)
   15a52:	dd 56       	pushl r6
   15a54:	fb 02 ef e5 	calls $0x2,15d40 <__urem>
   15a58:	02 00 00 
   15a5b:	d0 50 53    	movl r0,r3
   15a5e:	3c ad c0 52 	movzwl 0xffffffc0(fp),r2
   15a62:	c4 59 52    	mull2 r9,r2
   15a65:	78 10 50 50 	ashl $0x10,r0,r0
   15a69:	3c 58 51    	movzwl r8,r1
   15a6c:	c8 51 50    	bisl2 r1,r0
   15a6f:	d1 52 50    	cmpl r2,r0
   15a72:	1b 28       	blequ 15a9c <__qdivrem+0x200>
   15a74:	d7 59       	decl r9
   15a76:	3c ad c2 50 	movzwl 0xffffffc2(fp),r0
   15a7a:	c0 50 53    	addl2 r0,r3
   15a7d:	d1 53 8f ff 	cmpl r3,$0x0000ffff
   15a81:	ff 00 00 
   15a84:	1a 16       	bgtru 15a9c <__qdivrem+0x200>
   15a86:	3c ad c0 50 	movzwl 0xffffffc0(fp),r0
   15a8a:	c4 59 50    	mull2 r9,r0
   15a8d:	78 10 53 51 	ashl $0x10,r3,r1
   15a91:	3c 58 52    	movzwl r8,r2
   15a94:	c8 52 51    	bisl2 r2,r1
   15a97:	d1 50 51    	cmpl r0,r1
   15a9a:	1a d8       	bgtru 15a74 <__qdivrem+0x1d8>
   15a9c:	d4 58       	clrf r8
   15a9e:	d0 ad b8 53 	movl 0xffffffb8(fp),r3
   15aa2:	15 36       	bleq 15ada <__qdivrem+0x23e>
   15aa4:	c1 53 57 52 	addl3 r3,r7,r2
   15aa8:	3c 42 6b 51 	movzwl (r11)[r2],r1
   15aac:	d0 ad c8 54 	movl 0xffffffc8(fp),r4
   15ab0:	3c 43 64 50 	movzwl (r4)[r3],r0
   15ab4:	c4 59 50    	mull2 r9,r0
   15ab7:	c2 50 51    	subl2 r0,r1
   15aba:	c3 58 51 58 	subl3 r8,r1,r8
   15abe:	b0 58 42 6b 	movw r8,(r11)[r2]
   15ac2:	ef 10 10 58 	extzv $0x10,$0x10,r8,r0
   15ac6:	50 
   15ac7:	c3 50 8f 00 	subl3 r0,$0x00010000,r0
   15acb:	00 01 00 50 
   15acf:	cb 8f 00 00 	bicl3 $0xffff0000,r0,r8
   15ad3:	ff ff 50 58 
   15ad7:	f5 53 ca    	sobgtr r3,15aa4 <__qdivrem+0x208>
   15ada:	3c 6a 50    	movzwl (r10),r0
   15add:	c3 58 50 58 	subl3 r8,r0,r8
   15ae1:	b0 58 6a    	movw r8,(r10)
   15ae4:	ef 10 10 58 	extzv $0x10,$0x10,r8,r0
   15ae8:	50 
   15ae9:	13 32       	beql 15b1d <__qdivrem+0x281>
   15aeb:	d7 59       	decl r9
   15aed:	d4 58       	clrf r8
   15aef:	d0 ad b8 53 	movl 0xffffffb8(fp),r3
   15af3:	15 25       	bleq 15b1a <__qdivrem+0x27e>
   15af5:	c1 53 57 50 	addl3 r3,r7,r0
   15af9:	3c 40 6b 51 	movzwl (r11)[r0],r1
   15afd:	d0 ad c8 54 	movl 0xffffffc8(fp),r4
   15b01:	3c 43 64 52 	movzwl (r4)[r3],r2
   15b05:	c0 52 51    	addl2 r2,r1
   15b08:	c0 51 58    	addl2 r1,r8
   15b0b:	b0 58 40 6b 	movw r8,(r11)[r0]
   15b0f:	ef 10 10 58 	extzv $0x10,$0x10,r8,r0
   15b13:	50 
   15b14:	d0 50 58    	movl r0,r8
   15b17:	f5 53 db    	sobgtr r3,15af5 <__qdivrem+0x259>
   15b1a:	a0 58 6a    	addw2 r8,(r10)
   15b1d:	d0 ad c4 51 	movl 0xffffffc4(fp),r1
   15b21:	b0 59 47 61 	movw r9,(r1)[r7]
   15b25:	c0 02 5a    	addl2 $0x2,r10
   15b28:	f3 ad bc 57 	aobleq 0xffffffbc(fp),r7,15b2f <__qdivrem+0x293>
   15b2c:	02 
   15b2d:	11 03       	brb 15b32 <__qdivrem+0x296>
   15b2f:	31 eb fe    	brw 15a1d <__qdivrem+0x181>
   15b32:	d5 ad a0    	tstl 0xffffffa0(fp)
   15b35:	13 68       	beql 15b9f <__qdivrem+0x303>
   15b37:	d5 ad b4    	tstl 0xffffffb4(fp)
   15b3a:	13 39       	beql 15b75 <__qdivrem+0x2d9>
   15b3c:	c1 ad bc ad 	addl3 0xffffffbc(fp),0xffffffb8(fp),r3
   15b40:	b8 53 
   15b42:	d1 53 ad bc 	cmpl r3,0xffffffbc(fp)
   15b46:	15 2a       	bleq 15b72 <__qdivrem+0x2d6>
   15b48:	3c 43 6b 52 	movzwl (r11)[r3],r2
   15b4c:	83 ad b4 20 	subb3 0xffffffb4(fp),$0x20,r0
   15b50:	50 
   15b51:	ef ad b4 50 	extzv 0xffffffb4(fp),r0,r2,r2
   15b55:	52 52 
   15b57:	3c 43 ab fe 	movzwl 0xfffffffe(r11)[r3],r0
   15b5b:	50 
   15b5c:	c3 ad b4 10 	subl3 0xffffffb4(fp),$0x10,r1
   15b60:	51 
   15b61:	78 51 50 50 	ashl r1,r0,r0
   15b65:	a9 50 52 43 	bisw3 r0,r2,(r11)[r3]
   15b69:	6b 
   15b6a:	d7 53       	decl r3
   15b6c:	d1 53 ad bc 	cmpl r3,0xffffffbc(fp)
   15b70:	14 d6       	bgtr 15b48 <__qdivrem+0x2ac>
   15b72:	b4 43 6b    	clrw (r11)[r3]
   15b75:	b0 ad ee 52 	movw 0xffffffee(fp),r2
   15b79:	78 10 52 51 	ashl $0x10,r2,r1
   15b7d:	3c ad f0 50 	movzwl 0xfffffff0(fp),r0
   15b81:	c9 50 51 ad 	bisl3 r0,r1,0xffffffd0(fp)
   15b85:	d0 
   15b86:	b0 ad f2 54 	movw 0xfffffff2(fp),r4
   15b8a:	78 10 54 51 	ashl $0x10,r4,r1
   15b8e:	3c ad f4 50 	movzwl 0xfffffff4(fp),r0
   15b92:	c9 50 51 ad 	bisl3 r0,r1,0xffffffcc(fp)
   15b96:	cc 
   15b97:	d0 ad a0 50 	movl 0xffffffa0(fp),r0
   15b9b:	7d ad cc 60 	movq 0xffffffcc(fp),(r0)
   15b9f:	b0 ad d6 52 	movw 0xffffffd6(fp),r2
   15ba3:	78 10 52 51 	ashl $0x10,r2,r1
   15ba7:	3c ad d8 50 	movzwl 0xffffffd8(fp),r0
   15bab:	c9 50 51 ad 	bisl3 r0,r1,0xffffffd0(fp)
   15baf:	d0 
   15bb0:	b0 ad da 54 	movw 0xffffffda(fp),r4
   15bb4:	78 10 54 51 	ashl $0x10,r4,r1
   15bb8:	3c ad dc 50 	movzwl 0xffffffdc(fp),r0
   15bbc:	c9 50 51 ad 	bisl3 r0,r1,0xffffffcc(fp)
   15bc0:	cc 
   15bc1:	31 1f fd    	brw 158e3 <__qdivrem+0x47>
   15bc4:	d0 8f 00 00 	movl $0x00010000,r9
   15bc8:	01 00 59 
   15bcb:	3c 50 53    	movzwl r0,r3
   15bce:	31 a3 fe    	brw 15a74 <__qdivrem+0x1d8>
   15bd1:	d0 ad c8 52 	movl 0xffffffc8(fp),r2
   15bd5:	3c a2 04 58 	movzwl 0x4(r2),r8
   15bd9:	3c ab 02 56 	movzwl 0x2(r11),r6
   15bdd:	9e ef 01 01 	movab 15ce4 <__udiv>,r9
   15be1:	00 00 59 
   15be4:	dd 58       	pushl r8
   15be6:	dd 56       	pushl r6
   15be8:	fb 02 69    	calls $0x2,(r9)
   15beb:	b0 50 ad b0 	movw r0,0xffffffb0(fp)
   15bef:	9e ef 4b 01 	movab 15d40 <__urem>,r10
   15bf3:	00 00 5a 
   15bf6:	dd 58       	pushl r8
   15bf8:	dd 56       	pushl r6
   15bfa:	fb 02 6a    	calls $0x2,(r10)
   15bfd:	78 10 50 50 	ashl $0x10,r0,r0
   15c01:	3c ab 04 51 	movzwl 0x4(r11),r1
   15c05:	c9 51 50 56 	bisl3 r1,r0,r6
   15c09:	dd 58       	pushl r8
   15c0b:	dd 56       	pushl r6
   15c0d:	fb 02 69    	calls $0x2,(r9)
   15c10:	b0 50 ad ae 	movw r0,0xffffffae(fp)
   15c14:	dd 58       	pushl r8
   15c16:	dd 56       	pushl r6
   15c18:	fb 02 6a    	calls $0x2,(r10)
   15c1b:	78 10 50 50 	ashl $0x10,r0,r0
   15c1f:	3c ab 06 51 	movzwl 0x6(r11),r1
   15c23:	c9 51 50 56 	bisl3 r1,r0,r6
   15c27:	dd 58       	pushl r8
   15c29:	dd 56       	pushl r6
   15c2b:	fb 02 69    	calls $0x2,(r9)
   15c2e:	b0 50 ad a8 	movw r0,0xffffffa8(fp)
   15c32:	dd 58       	pushl r8
   15c34:	dd 56       	pushl r6
   15c36:	fb 02 6a    	calls $0x2,(r10)
   15c39:	78 10 50 50 	ashl $0x10,r0,r0
   15c3d:	3c ab 08 51 	movzwl 0x8(r11),r1
   15c41:	c9 51 50 56 	bisl3 r1,r0,r6
   15c45:	dd 58       	pushl r8
   15c47:	dd 56       	pushl r6
   15c49:	fb 02 69    	calls $0x2,(r9)
   15c4c:	b0 50 57    	movw r0,r7
   15c4f:	d5 ad a0    	tstl 0xffffffa0(fp)
   15c52:	13 10       	beql 15c64 <__qdivrem+0x3c8>
   15c54:	dd 58       	pushl r8
   15c56:	dd 56       	pushl r6
   15c58:	fb 02 6a    	calls $0x2,(r10)
   15c5b:	d4 51       	clrf r1
   15c5d:	d0 ad a0 54 	movl 0xffffffa0(fp),r4
   15c61:	7d 50 64    	movq r0,(r4)
   15c64:	b0 ad b0 50 	movw 0xffffffb0(fp),r0
   15c68:	78 10 50 51 	ashl $0x10,r0,r1
   15c6c:	3c ad ae 50 	movzwl 0xffffffae(fp),r0
   15c70:	c9 50 51 ad 	bisl3 r0,r1,0xffffffd0(fp)
   15c74:	d0 
   15c75:	b0 ad a8 52 	movw 0xffffffa8(fp),r2
   15c79:	78 10 52 51 	ashl $0x10,r2,r1
   15c7d:	3c 57 50    	movzwl r7,r0
   15c80:	31 39 ff    	brw 15bbc <__qdivrem+0x320>
   15c83:	d1 53 56    	cmpl r3,r6
   15c86:	1a 03       	bgtru 15c8b <__qdivrem+0x3ef>
   15c88:	31 87 fc    	brw 15912 <__qdivrem+0x76>
   15c8b:	d5 ad a0    	tstl 0xffffffa0(fp)
   15c8e:	13 07       	beql 15c97 <__qdivrem+0x3fb>
   15c90:	d0 ad a0 51 	movl 0xffffffa0(fp),r1
   15c94:	7d 56 61    	movq r6,(r1)
   15c97:	7c 50       	clrd r0
   15c99:	31 4b fc    	brw 158e7 <__qdivrem+0x4b>

00015c9c <shl>:
   15c9c:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   15c9e:	c2 04 5e    	subl2 $0x4,sp
   15ca1:	d0 ac 04 55 	movl 0x4(ap),r5
   15ca5:	d0 ac 08 57 	movl 0x8(ap),r7
   15ca9:	d0 ac 0c 56 	movl 0xc(ap),r6
   15cad:	d4 54       	clrf r4
   15caf:	d1 54 57    	cmpl r4,r7
   15cb2:	18 23       	bgeq 15cd7 <shl+0x3b>
   15cb4:	3c 44 65 53 	movzwl (r5)[r4],r3
   15cb8:	78 56 53 53 	ashl r6,r3,r3
   15cbc:	3c 44 a5 02 	movzwl 0x2(r5)[r4],r0
   15cc0:	50 
   15cc1:	c3 56 10 52 	subl3 r6,$0x10,r2
   15cc5:	83 52 20 51 	subb3 r2,$0x20,r1
   15cc9:	ef 52 51 50 	extzv r2,r1,r0,r0
   15ccd:	50 
   15cce:	a9 50 53 44 	bisw3 r0,r3,(r5)[r4]
   15cd2:	65 
   15cd3:	f2 57 54 dd 	aoblss r7,r4,15cb4 <shl+0x18>
   15cd7:	3c 44 65 50 	movzwl (r5)[r4],r0
   15cdb:	78 56 50 50 	ashl r6,r0,r0
   15cdf:	b0 50 44 65 	movw r0,(r5)[r4]
   15ce3:	04          	ret

00015ce4 <__udiv>:
   15ce4:	04 00       	.word 0x0004 # Entry mask: < r2 >
   15ce6:	d0 ac 08 52 	movl 0x8(ap),r2
   15cea:	19 12       	blss 15cfe <Leasy>
   15cec:	d0 ac 04 50 	movl 0x4(ap),r0
   15cf0:	19 04       	blss 15cf6 <Lhard>
   15cf2:	c6 52 50    	divl2 r2,r0
   15cf5:	04          	ret

00015cf6 <Lhard>:
   15cf6:	d4 51       	clrf r1
   15cf8:	7b 52 50 50 	ediv r2,r0,r0,r1
   15cfc:	51 
   15cfd:	04          	ret

00015cfe <Leasy>:
   15cfe:	d1 ac 04 52 	cmpl 0x4(ap),r2
   15d02:	1e 03       	bcc 15d07 <Lone>
   15d04:	d4 50       	clrf r0
   15d06:	04          	ret

00015d07 <Lone>:
   15d07:	d0 01 50    	movl $0x1,r0
   15d0a:	04          	ret
   15d0b:	01          	nop

00015d0c <__audiv>:
   15d0c:	0c 00       	.word 0x000c # Entry mask: < r3 r2 >
   15d0e:	d0 ac 04 53 	movl 0x4(ap),r3
   15d12:	d0 ac 08 52 	movl 0x8(ap),r2
   15d16:	19 17       	blss 15d2f <La_easy>
   15d18:	d0 63 50    	movl (r3),r0
   15d1b:	19 07       	blss 15d24 <La_hard>
   15d1d:	c6 52 50    	divl2 r2,r0
   15d20:	d0 50 63    	movl r0,(r3)
   15d23:	04          	ret

00015d24 <La_hard>:
   15d24:	d4 51       	clrf r1
   15d26:	7b 52 50 50 	ediv r2,r0,r0,r1
   15d2a:	51 
   15d2b:	d0 50 63    	movl r0,(r3)
   15d2e:	04          	ret

00015d2f <La_easy>:
   15d2f:	d1 63 52    	cmpl (r3),r2
   15d32:	1e 05       	bcc 15d39 <La_one>
   15d34:	d4 50       	clrf r0
   15d36:	d4 63       	clrf (r3)
   15d38:	04          	ret

00015d39 <La_one>:
   15d39:	d0 01 50    	movl $0x1,r0
   15d3c:	d0 50 63    	movl r0,(r3)
   15d3f:	04          	ret

00015d40 <__urem>:
   15d40:	04 00       	.word 0x0004 # Entry mask: < r2 >
   15d42:	d0 ac 08 52 	movl 0x8(ap),r2
   15d46:	19 19       	blss 15d61 <Leasy>
   15d48:	d0 ac 04 50 	movl 0x4(ap),r0
   15d4c:	19 0b       	blss 15d59 <Lhard>
   15d4e:	c7 52 50 51 	divl3 r2,r0,r1
   15d52:	c4 52 51    	mull2 r2,r1
   15d55:	c2 51 50    	subl2 r1,r0
   15d58:	04          	ret

00015d59 <Lhard>:
   15d59:	d4 51       	clrf r1
   15d5b:	7b 52 50 51 	ediv r2,r0,r1,r0
   15d5f:	50 
   15d60:	04          	ret

00015d61 <Leasy>:
   15d61:	c3 52 ac 04 	subl3 r2,0x4(ap),r0
   15d65:	50 
   15d66:	1e 04       	bcc 15d6c <Ldifference>
   15d68:	d0 ac 04 50 	movl 0x4(ap),r0

00015d6c <Ldifference>:
   15d6c:	04          	ret
   15d6d:	01          	nop
   15d6e:	01          	nop
   15d6f:	01          	nop

00015d70 <__aurem>:
   15d70:	0c 00       	.word 0x000c # Entry mask: < r3 r2 >
   15d72:	d0 ac 04 53 	movl 0x4(ap),r3
   15d76:	d0 ac 08 52 	movl 0x8(ap),r2
   15d7a:	19 1e       	blss 15d9a <La_easy>
   15d7c:	d0 63 50    	movl (r3),r0
   15d7f:	19 0e       	blss 15d8f <La_hard>
   15d81:	c7 52 50 51 	divl3 r2,r0,r1
   15d85:	c4 52 51    	mull2 r2,r1
   15d88:	c2 51 50    	subl2 r1,r0
   15d8b:	d0 50 63    	movl r0,(r3)
   15d8e:	04          	ret

00015d8f <La_hard>:
   15d8f:	d4 51       	clrf r1
   15d91:	7b 52 50 51 	ediv r2,r0,r1,r0
   15d95:	50 
   15d96:	d0 50 63    	movl r0,(r3)
   15d99:	04          	ret

00015d9a <La_easy>:
   15d9a:	c3 52 63 50 	subl3 r2,(r3),r0
   15d9e:	1f 04       	blssu 15da4 <La_dividend>
   15da0:	d0 50 63    	movl r0,(r3)
   15da3:	04          	ret

00015da4 <La_dividend>:
   15da4:	d0 63 50    	movl (r3),r0
   15da7:	04          	ret

00015da8 <bcopy>:
   15da8:	7c 00       	.word 0x007c # Entry mask: < r6 r5 r4 r3 r2 >
   15daa:	d0 ac 04 51 	movl 0x4(ap),r1
   15dae:	d0 ac 08 53 	movl 0x8(ap),r3
   15db2:	d0 ac 0c 56 	movl 0xc(ap),r6
   15db6:	d1 51 53    	cmpl r1,r3
   15db9:	14 0a       	bgtr 15dc5 <bcopy+0x1d>
   15dbb:	19 17       	blss 15dd4 <bcopy+0x2c>
   15dbd:	04          	ret
   15dbe:	c2 50 56    	subl2 r0,r6
   15dc1:	28 50 61 63 	movc3 r0,(r1),(r3)
   15dc5:	3c 8f ff ff 	movzwl $0xffff,r0
   15dc9:	50 
   15dca:	d1 56 50    	cmpl r6,r0
   15dcd:	14 ef       	bgtr 15dbe <bcopy+0x16>
   15dcf:	28 56 61 63 	movc3 r6,(r1),(r3)
   15dd3:	04          	ret
   15dd4:	c0 56 51    	addl2 r6,r1
   15dd7:	c0 56 53    	addl2 r6,r3
   15dda:	3c 8f ff ff 	movzwl $0xffff,r0
   15dde:	50 
   15ddf:	11 18       	brb 15df9 <bcopy+0x51>
   15de1:	c2 50 56    	subl2 r0,r6
   15de4:	c2 50 51    	subl2 r0,r1
   15de7:	c2 50 53    	subl2 r0,r3
   15dea:	28 50 61 63 	movc3 r0,(r1),(r3)
   15dee:	3c 8f ff ff 	movzwl $0xffff,r0
   15df2:	50 
   15df3:	c2 50 51    	subl2 r0,r1
   15df6:	c2 50 53    	subl2 r0,r3
   15df9:	d1 56 50    	cmpl r6,r0
   15dfc:	14 e3       	bgtr 15de1 <bcopy+0x39>
   15dfe:	c2 56 51    	subl2 r6,r1
   15e01:	c2 56 53    	subl2 r6,r3
   15e04:	28 56 61 63 	movc3 r6,(r1),(r3)
   15e08:	04          	ret
   15e09:	01          	nop

00015e0a <getpagesize>:
   15e0a:	00 00       	.word 0x0000 # Entry mask: < >
   15e0c:	c2 14 5e    	subl2 $0x14,sp
   15e0f:	d0 ef 83 61 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   15e13:	02 00 ad f8 
   15e17:	d5 ef c3 93 	tstl 5f1e0 <pagsz.0>
   15e1b:	04 00 
   15e1d:	13 25       	beql 15e44 <getpagesize+0x3a>
   15e1f:	d0 ef bb 93 	movl 5f1e0 <pagsz.0>,r0
   15e23:	04 00 50 
   15e26:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   15e2a:	d1 51 ef 67 	cmpl r1,3bf98 <__guard_local>
   15e2e:	61 02 00 
   15e31:	13 10       	beql 15e43 <getpagesize+0x39>
   15e33:	dd ad f8    	pushl 0xfffffff8(fp)
   15e36:	9f ef d2 4e 	pushab 2ad0e <__tens_D2A+0xe6>
   15e3a:	01 00 
   15e3c:	fb 02 ef 29 	calls $0x2,1666c <__stack_smash_handler>
   15e40:	08 00 00 
   15e43:	04          	ret
   15e44:	d0 06 ad f0 	movl $0x6,0xfffffff0(fp)
   15e48:	d0 07 ad f4 	movl $0x7,0xfffffff4(fp)
   15e4c:	d0 04 ad ec 	movl $0x4,0xffffffec(fp)
   15e50:	d4 7e       	clrf -(sp)
   15e52:	d4 7e       	clrf -(sp)
   15e54:	9f ad ec    	pushab 0xffffffec(fp)
   15e57:	9f ef 83 93 	pushab 5f1e0 <pagsz.0>
   15e5b:	04 00 
   15e5d:	dd 02       	pushl $0x2
   15e5f:	9f ad f0    	pushab 0xfffffff0(fp)
   15e62:	fb 06 ef 0b 	calls $0x6,15e74 <sysctl>
   15e66:	00 00 00 
   15e69:	d1 50 8f ff 	cmpl r0,$0xffffffff
   15e6d:	ff ff ff 
   15e70:	12 ad       	bneq 15e1f <getpagesize+0x15>
   15e72:	11 b2       	brb 15e26 <getpagesize+0x1c>

00015e74 <sysctl>:
   15e74:	00 00       	.word 0x0000 # Entry mask: < >
   15e76:	c2 04 5e    	subl2 $0x4,sp
   15e79:	dd ac 18    	pushl 0x18(ap)
   15e7c:	dd ac 14    	pushl 0x14(ap)
   15e7f:	dd ac 10    	pushl 0x10(ap)
   15e82:	dd ac 0c    	pushl 0xc(ap)
   15e85:	dd ac 08    	pushl 0x8(ap)
   15e88:	dd ac 04    	pushl 0x4(ap)
   15e8b:	fb 06 ef 6e 	calls $0x6,16a00 <_thread_sys___sysctl>
   15e8f:	0b 00 00 
   15e92:	04          	ret
   15e93:	01          	nop

00015e94 <mbsinit>:
   15e94:	00 00       	.word 0x0000 # Entry mask: < >
   15e96:	c2 04 5e    	subl2 $0x4,sp
   15e99:	d0 ac 04 51 	movl 0x4(ap),r1
   15e9d:	13 1a       	beql 15eb9 <mbsinit+0x25>
   15e9f:	d0 61 50    	movl (r1),r0
   15ea2:	13 0c       	beql 15eb0 <mbsinit+0x1c>
   15ea4:	d0 d0 50 0c 	movl *0xc50(r0),r0
   15ea8:	50 
   15ea9:	dd 51       	pushl r1
   15eab:	fb 01 b0 04 	calls $0x1,*0x4(r0)
   15eaf:	04          	ret
   15eb0:	d0 ef 52 6f 	movl 5ce08 <_CurrentRuneLocale>,r0
   15eb4:	04 00 50 
   15eb7:	11 eb       	brb 15ea4 <mbsinit+0x10>
   15eb9:	d0 01 50    	movl $0x1,r0
   15ebc:	04          	ret
   15ebd:	01          	nop

00015ebe <mbrtowc>:
   15ebe:	00 00       	.word 0x0000 # Entry mask: < >
   15ec0:	c2 04 5e    	subl2 $0x4,sp
   15ec3:	d0 ac 10 51 	movl 0x10(ap),r1
   15ec7:	13 1d       	beql 15ee6 <mbrtowc+0x28>
   15ec9:	d0 ef 39 6f 	movl 5ce08 <_CurrentRuneLocale>,r0
   15ecd:	04 00 50 
   15ed0:	d0 d0 50 0c 	movl *0xc50(r0),r0
   15ed4:	50 
   15ed5:	9f a1 04    	pushab 0x4(r1)
   15ed8:	dd ac 0c    	pushl 0xc(ap)
   15edb:	dd ac 08    	pushl 0x8(ap)
   15ede:	dd ac 04    	pushl 0x4(ap)
   15ee1:	fb 04 b0 00 	calls $0x4,*0x0(r0)
   15ee5:	04          	ret
   15ee6:	9e ef f8 92 	movab 5f1e4 <mbs.0>,r1
   15eea:	04 00 51 
   15eed:	11 da       	brb 15ec9 <mbrtowc+0xb>
   15eef:	01          	nop

00015ef0 <mbsrtowcs>:
   15ef0:	00 00       	.word 0x0000 # Entry mask: < >
   15ef2:	c2 04 5e    	subl2 $0x4,sp
   15ef5:	d0 ac 10 50 	movl 0x10(ap),r0
   15ef9:	13 16       	beql 15f11 <mbsrtowcs+0x21>
   15efb:	dd 50       	pushl r0
   15efd:	dd ac 0c    	pushl 0xc(ap)
   15f00:	d2 00 7e    	mcoml $0x0,-(sp)
   15f03:	dd ac 08    	pushl 0x8(ap)
   15f06:	dd ac 04    	pushl 0x4(ap)
   15f09:	fb 05 ef 0a 	calls $0x5,15f1a <mbsnrtowcs>
   15f0d:	00 00 00 
   15f10:	04          	ret
   15f11:	9e ef 4d 93 	movab 5f264 <mbs.1>,r0
   15f15:	04 00 50 
   15f18:	11 e1       	brb 15efb <mbsrtowcs+0xb>

00015f1a <mbsnrtowcs>:
   15f1a:	00 00       	.word 0x0000 # Entry mask: < >
   15f1c:	c2 04 5e    	subl2 $0x4,sp
   15f1f:	d0 ac 14 51 	movl 0x14(ap),r1
   15f23:	13 20       	beql 15f45 <mbsnrtowcs+0x2b>
   15f25:	d0 ef dd 6e 	movl 5ce08 <_CurrentRuneLocale>,r0
   15f29:	04 00 50 
   15f2c:	d0 d0 50 0c 	movl *0xc50(r0),r0
   15f30:	50 
   15f31:	9f a1 04    	pushab 0x4(r1)
   15f34:	dd ac 10    	pushl 0x10(ap)
   15f37:	dd ac 0c    	pushl 0xc(ap)
   15f3a:	dd ac 08    	pushl 0x8(ap)
   15f3d:	dd ac 04    	pushl 0x4(ap)
   15f40:	fb 05 b0 08 	calls $0x5,*0x8(r0)
   15f44:	04          	ret
   15f45:	9e ef 99 93 	movab 5f2e4 <mbs.2>,r1
   15f49:	04 00 51 
   15f4c:	11 d7       	brb 15f25 <mbsnrtowcs+0xb>

00015f4e <wcrtomb>:
   15f4e:	00 00       	.word 0x0000 # Entry mask: < >
   15f50:	c2 04 5e    	subl2 $0x4,sp
   15f53:	d0 ac 0c 51 	movl 0xc(ap),r1
   15f57:	13 1a       	beql 15f73 <wcrtomb+0x25>
   15f59:	d0 ef a9 6e 	movl 5ce08 <_CurrentRuneLocale>,r0
   15f5d:	04 00 50 
   15f60:	d0 d0 50 0c 	movl *0xc50(r0),r0
   15f64:	50 
   15f65:	9f a1 04    	pushab 0x4(r1)
   15f68:	dd ac 08    	pushl 0x8(ap)
   15f6b:	dd ac 04    	pushl 0x4(ap)
   15f6e:	fb 03 b0 0c 	calls $0x3,*0xc(r0)
   15f72:	04          	ret
   15f73:	9e ef eb 93 	movab 5f364 <mbs.3>,r1
   15f77:	04 00 51 
   15f7a:	11 dd       	brb 15f59 <wcrtomb+0xb>

00015f7c <wcsrtombs>:
   15f7c:	00 00       	.word 0x0000 # Entry mask: < >
   15f7e:	c2 04 5e    	subl2 $0x4,sp
   15f81:	d0 ac 10 50 	movl 0x10(ap),r0
   15f85:	13 16       	beql 15f9d <wcsrtombs+0x21>
   15f87:	dd 50       	pushl r0
   15f89:	dd ac 0c    	pushl 0xc(ap)
   15f8c:	d2 00 7e    	mcoml $0x0,-(sp)
   15f8f:	dd ac 08    	pushl 0x8(ap)
   15f92:	dd ac 04    	pushl 0x4(ap)
   15f95:	fb 05 ef 0a 	calls $0x5,15fa6 <wcsnrtombs>
   15f99:	00 00 00 
   15f9c:	04          	ret
   15f9d:	9e ef 41 94 	movab 5f3e4 <mbs.4>,r0
   15fa1:	04 00 50 
   15fa4:	11 e1       	brb 15f87 <wcsrtombs+0xb>

00015fa6 <wcsnrtombs>:
   15fa6:	00 00       	.word 0x0000 # Entry mask: < >
   15fa8:	c2 04 5e    	subl2 $0x4,sp
   15fab:	d0 ac 14 51 	movl 0x14(ap),r1
   15faf:	13 20       	beql 15fd1 <wcsnrtombs+0x2b>
   15fb1:	d0 ef 51 6e 	movl 5ce08 <_CurrentRuneLocale>,r0
   15fb5:	04 00 50 
   15fb8:	d0 d0 50 0c 	movl *0xc50(r0),r0
   15fbc:	50 
   15fbd:	9f a1 04    	pushab 0x4(r1)
   15fc0:	dd ac 10    	pushl 0x10(ap)
   15fc3:	dd ac 0c    	pushl 0xc(ap)
   15fc6:	dd ac 08    	pushl 0x8(ap)
   15fc9:	dd ac 04    	pushl 0x4(ap)
   15fcc:	fb 05 b0 10 	calls $0x5,*0x10(r0)
   15fd0:	04          	ret
   15fd1:	9e ef 8d 94 	movab 5f464 <mbs.5>,r1
   15fd5:	04 00 51 
   15fd8:	11 d7       	brb 15fb1 <wcsnrtombs+0xb>

00015fda <_citrus_ctype_open>:
   15fda:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   15fdc:	c2 04 5e    	subl2 $0x4,sp
   15fdf:	d0 ac 04 58 	movl 0x4(ap),r8
   15fe3:	d0 ac 08 57 	movl 0x8(ap),r7
   15fe7:	9f ef 79 4d 	pushab 2ad66 <__tens_D2A+0x13e>
   15feb:	01 00 
   15fed:	dd 57       	pushl r7
   15fef:	9e ef 59 08 	movab 1684e <strcmp>,r6
   15ff3:	00 00 56 
   15ff6:	fb 02 66    	calls $0x2,(r6)
   15ff9:	d5 50       	tstl r0
   15ffb:	12 0a       	bneq 16007 <_citrus_ctype_open+0x2d>
   15ffd:	9e ef 09 6e 	movab 5ce0c <_citrus_ctype_none>,(r8)
   16001:	04 00 68 
   16004:	d4 50       	clrf r0
   16006:	04          	ret
   16007:	9f ef 5e 4d 	pushab 2ad6b <__tens_D2A+0x143>
   1600b:	01 00 
   1600d:	dd 57       	pushl r7
   1600f:	fb 02 66    	calls $0x2,(r6)
   16012:	d5 50       	tstl r0
   16014:	12 09       	bneq 1601f <_citrus_ctype_open+0x45>
   16016:	9e ef f8 6d 	movab 5ce14 <_citrus_ctype_utf8>,(r8)
   1601a:	04 00 68 
   1601d:	11 e5       	brb 16004 <_citrus_ctype_open+0x2a>
   1601f:	d2 00 50    	mcoml $0x0,r0
   16022:	04          	ret
   16023:	01          	nop

00016024 <_citrus_none_ctype_mbrtowc>:
   16024:	00 00       	.word 0x0000 # Entry mask: < >
   16026:	c2 04 5e    	subl2 $0x4,sp
   16029:	d0 ac 04 50 	movl 0x4(ap),r0
   1602d:	d0 ac 08 51 	movl 0x8(ap),r1
   16031:	13 19       	beql 1604c <_citrus_none_ctype_mbrtowc+0x28>
   16033:	d5 ac 0c    	tstl 0xc(ap)
   16036:	13 10       	beql 16048 <_citrus_none_ctype_mbrtowc+0x24>
   16038:	d5 50       	tstl r0
   1603a:	13 03       	beql 1603f <_citrus_none_ctype_mbrtowc+0x1b>
   1603c:	9a 61 60    	movzbl (r1),(r0)
   1603f:	d4 50       	clrf r0
   16041:	95 61       	tstb (r1)
   16043:	13 02       	beql 16047 <_citrus_none_ctype_mbrtowc+0x23>
   16045:	d6 50       	incl r0
   16047:	04          	ret
   16048:	d2 01 50    	mcoml $0x1,r0
   1604b:	04          	ret
   1604c:	d4 50       	clrf r0
   1604e:	04          	ret
   1604f:	01          	nop

00016050 <_citrus_none_ctype_mbsinit>:
   16050:	00 00       	.word 0x0000 # Entry mask: < >
   16052:	c2 04 5e    	subl2 $0x4,sp
   16055:	d0 01 50    	movl $0x1,r0
   16058:	04          	ret
   16059:	01          	nop

0001605a <_citrus_none_ctype_mbsnrtowcs>:
   1605a:	00 00       	.word 0x0000 # Entry mask: < >
   1605c:	c2 04 5e    	subl2 $0x4,sp
   1605f:	d0 ac 04 55 	movl 0x4(ap),r5
   16063:	d0 ac 08 52 	movl 0x8(ap),r2
   16067:	d0 ac 0c 53 	movl 0xc(ap),r3
   1606b:	d0 ac 10 54 	movl 0x10(ap),r4
   1606f:	d5 55       	tstl r5
   16071:	13 30       	beql 160a3 <_citrus_none_ctype_mbsnrtowcs+0x49>
   16073:	d4 51       	clrf r1
   16075:	d1 51 53    	cmpl r1,r3
   16078:	1e 1c       	bcc 16096 <_citrus_none_ctype_mbsnrtowcs+0x3c>
   1607a:	d1 51 54    	cmpl r1,r4
   1607d:	1e 17       	bcc 16096 <_citrus_none_ctype_mbsnrtowcs+0x3c>
   1607f:	9a 41 b2 00 	movzbl *0x0(r2)[r1],r0
   16083:	50 
   16084:	d0 50 41 65 	movl r0,(r5)[r1]
   16088:	13 13       	beql 1609d <_citrus_none_ctype_mbsnrtowcs+0x43>
   1608a:	d6 51       	incl r1
   1608c:	d1 51 53    	cmpl r1,r3
   1608f:	1e 05       	bcc 16096 <_citrus_none_ctype_mbsnrtowcs+0x3c>
   16091:	d1 51 54    	cmpl r1,r4
   16094:	1f e9       	blssu 1607f <_citrus_none_ctype_mbsnrtowcs+0x25>
   16096:	c0 51 62    	addl2 r1,(r2)
   16099:	d0 51 50    	movl r1,r0
   1609c:	04          	ret
   1609d:	d4 62       	clrf (r2)
   1609f:	d0 51 50    	movl r1,r0
   160a2:	04          	ret
   160a3:	dd 53       	pushl r3
   160a5:	dd 62       	pushl (r2)
   160a7:	fb 02 ef bc 	calls $0x2,1616a <strnlen>
   160ab:	00 00 00 
   160ae:	04          	ret
   160af:	01          	nop

000160b0 <_citrus_none_ctype_wcrtomb>:
   160b0:	00 00       	.word 0x0000 # Entry mask: < >
   160b2:	c2 04 5e    	subl2 $0x4,sp
   160b5:	d0 ac 04 51 	movl 0x4(ap),r1
   160b9:	d0 ac 08 50 	movl 0x8(ap),r0
   160bd:	d5 51       	tstl r1
   160bf:	13 1f       	beql 160e0 <_citrus_none_ctype_wcrtomb+0x30>
   160c1:	d1 50 8f ff 	cmpl r0,$0x000000ff
   160c5:	00 00 00 
   160c8:	1a 07       	bgtru 160d1 <_citrus_none_ctype_wcrtomb+0x21>
   160ca:	90 50 61    	movb r0,(r1)
   160cd:	d0 01 50    	movl $0x1,r0
   160d0:	04          	ret
   160d1:	fb 00 ef f0 	calls $0x0,109c8 <___errno>
   160d5:	a8 ff ff 
   160d8:	9a 8f 54 60 	movzbl $0x54,(r0)
   160dc:	d2 00 50    	mcoml $0x0,r0
   160df:	04          	ret
   160e0:	d0 01 50    	movl $0x1,r0
   160e3:	04          	ret

000160e4 <_citrus_none_ctype_wcsnrtombs>:
   160e4:	40 00       	.word 0x0040 # Entry mask: < r6 >
   160e6:	c2 04 5e    	subl2 $0x4,sp
   160e9:	d0 ac 04 55 	movl 0x4(ap),r5
   160ed:	d0 ac 08 53 	movl 0x8(ap),r3
   160f1:	d0 ac 0c 54 	movl 0xc(ap),r4
   160f5:	d0 ac 10 56 	movl 0x10(ap),r6
   160f9:	d5 55       	tstl r5
   160fb:	13 4c       	beql 16149 <_citrus_none_ctype_wcsnrtombs+0x65>
   160fd:	d4 50       	clrf r0
   160ff:	d1 50 54    	cmpl r0,r4
   16102:	1e 29       	bcc 1612d <_citrus_none_ctype_wcsnrtombs+0x49>
   16104:	d1 50 56    	cmpl r0,r6
   16107:	1e 24       	bcc 1612d <_citrus_none_ctype_wcsnrtombs+0x49>
   16109:	d0 63 52    	movl (r3),r2
   1610c:	d0 40 62 51 	movl (r2)[r0],r1
   16110:	d1 51 8f ff 	cmpl r1,$0x000000ff
   16114:	00 00 00 
   16117:	1a 1d       	bgtru 16136 <_citrus_none_ctype_wcsnrtombs+0x52>
   16119:	90 51 45 60 	movb r1,(r0)[r5]
   1611d:	d5 51       	tstl r1
   1611f:	13 12       	beql 16133 <_citrus_none_ctype_wcsnrtombs+0x4f>
   16121:	d6 50       	incl r0
   16123:	d1 50 54    	cmpl r0,r4
   16126:	1e 05       	bcc 1612d <_citrus_none_ctype_wcsnrtombs+0x49>
   16128:	d1 50 56    	cmpl r0,r6
   1612b:	1f dc       	blssu 16109 <_citrus_none_ctype_wcsnrtombs+0x25>
   1612d:	de 40 b3 00 	moval *0x0(r3)[r0],(r3)
   16131:	63 
   16132:	04          	ret
   16133:	d4 63       	clrf (r3)
   16135:	04          	ret
   16136:	de 40 62 63 	moval (r2)[r0],(r3)
   1613a:	fb 00 ef 87 	calls $0x0,109c8 <___errno>
   1613e:	a8 ff ff 
   16141:	9a 8f 54 60 	movzbl $0x54,(r0)
   16145:	d2 00 50    	mcoml $0x0,r0
   16148:	04          	ret
   16149:	d4 50       	clrf r0
   1614b:	d1 50 54    	cmpl r0,r4
   1614e:	1e e2       	bcc 16132 <_citrus_none_ctype_wcsnrtombs+0x4e>
   16150:	d0 40 b3 00 	movl *0x0(r3)[r0],r1
   16154:	51 
   16155:	d1 51 8f ff 	cmpl r1,$0x000000ff
   16159:	00 00 00 
   1615c:	1a dc       	bgtru 1613a <_citrus_none_ctype_wcsnrtombs+0x56>
   1615e:	d5 51       	tstl r1
   16160:	13 d0       	beql 16132 <_citrus_none_ctype_wcsnrtombs+0x4e>
   16162:	d6 50       	incl r0
   16164:	d1 50 54    	cmpl r0,r4
   16167:	1f e7       	blssu 16150 <_citrus_none_ctype_wcsnrtombs+0x6c>
   16169:	04          	ret

0001616a <strnlen>:
   1616a:	00 00       	.word 0x0000 # Entry mask: < >
   1616c:	c2 04 5e    	subl2 $0x4,sp
   1616f:	d0 ac 04 52 	movl 0x4(ap),r2
   16173:	d0 ac 08 51 	movl 0x8(ap),r1
   16177:	d0 52 50    	movl r2,r0
   1617a:	d5 51       	tstl r1
   1617c:	13 0e       	beql 1618c <strnlen+0x22>
   1617e:	95 62       	tstb (r2)
   16180:	13 0a       	beql 1618c <strnlen+0x22>
   16182:	d6 50       	incl r0
   16184:	d7 51       	decl r1
   16186:	13 04       	beql 1618c <strnlen+0x22>
   16188:	95 60       	tstb (r0)
   1618a:	12 f6       	bneq 16182 <strnlen+0x18>
   1618c:	c2 52 50    	subl2 r2,r0
   1618f:	04          	ret

00016190 <_citrus_utf8_ctype_mbrtowc>:
   16190:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   16192:	c2 04 5e    	subl2 $0x4,sp
   16195:	d0 ac 04 58 	movl 0x4(ap),r8
   16199:	d0 ac 08 53 	movl 0x8(ap),r3
   1619d:	d0 ac 0c 56 	movl 0xc(ap),r6
   161a1:	d0 ac 10 57 	movl 0x10(ap),r7
   161a5:	d0 a7 04 50 	movl 0x4(r7),r0
   161a9:	d1 50 04    	cmpl r0,$0x4
   161ac:	1b 03       	blequ 161b1 <_citrus_utf8_ctype_mbrtowc+0x21>
   161ae:	31 6d 01    	brw 1631e <_citrus_utf8_ctype_mbrtowc+0x18e>
   161b1:	d5 53       	tstl r3
   161b3:	12 03       	bneq 161b8 <_citrus_utf8_ctype_mbrtowc+0x28>
   161b5:	31 57 01    	brw 1630f <_citrus_utf8_ctype_mbrtowc+0x17f>
   161b8:	d5 56       	tstl r6
   161ba:	12 03       	bneq 161bf <_citrus_utf8_ctype_mbrtowc+0x2f>
   161bc:	31 db 00    	brw 1629a <_citrus_utf8_ctype_mbrtowc+0x10a>
   161bf:	d5 50       	tstl r0
   161c1:	12 18       	bneq 161db <_citrus_utf8_ctype_mbrtowc+0x4b>
   161c3:	9a 63 51    	movzbl (r3),r1
   161c6:	e0 07 63 11 	bbs $0x7,(r3),161db <_citrus_utf8_ctype_mbrtowc+0x4b>
   161ca:	d5 58       	tstl r8
   161cc:	13 03       	beql 161d1 <_citrus_utf8_ctype_mbrtowc+0x41>
   161ce:	d0 51 68    	movl r1,(r8)
   161d1:	d0 51 50    	movl r1,r0
   161d4:	13 04       	beql 161da <_citrus_utf8_ctype_mbrtowc+0x4a>
   161d6:	d0 01 50    	movl $0x1,r0
   161d9:	04          	ret
   161da:	04          	ret
   161db:	d0 a7 04 50 	movl 0x4(r7),r0
   161df:	13 03       	beql 161e4 <_citrus_utf8_ctype_mbrtowc+0x54>
   161e1:	31 21 01    	brw 16305 <_citrus_utf8_ctype_mbrtowc+0x175>
   161e4:	9a 63 51    	movzbl (r3),r1
   161e7:	93 51 8f 80 	bitb r1,$0x80
   161eb:	13 03       	beql 161f0 <_citrus_utf8_ctype_mbrtowc+0x60>
   161ed:	31 b4 00    	brw 162a4 <_citrus_utf8_ctype_mbrtowc+0x114>
   161f0:	9a 8f 7f 52 	movzbl $0x7f,r2
   161f4:	d0 01 55    	movl $0x1,r5
   161f7:	d4 59       	clrf r9
   161f9:	d5 a7 04    	tstl 0x4(r7)
   161fc:	13 03       	beql 16201 <_citrus_utf8_ctype_mbrtowc+0x71>
   161fe:	31 9d 00    	brw 1629e <_citrus_utf8_ctype_mbrtowc+0x10e>
   16201:	9a 83 50    	movzbl (r3)+,r0
   16204:	d2 50 50    	mcoml r0,r0
   16207:	ca 50 52    	bicl2 r0,r2
   1620a:	d4 54       	clrf r4
   1620c:	d5 a7 04    	tstl 0x4(r7)
   1620f:	12 03       	bneq 16214 <_citrus_utf8_ctype_mbrtowc+0x84>
   16211:	d0 01 54    	movl $0x1,r4
   16214:	d0 56 50    	movl r6,r0
   16217:	d1 56 55    	cmpl r6,r5
   1621a:	1b 03       	blequ 1621f <_citrus_utf8_ctype_mbrtowc+0x8f>
   1621c:	d0 55 50    	movl r5,r0
   1621f:	d1 54 50    	cmpl r4,r0
   16222:	1e 38       	bcc 1625c <_citrus_utf8_ctype_mbrtowc+0xcc>
   16224:	98 63 51    	cvtbl (r3),r1
   16227:	cb 8f 3f ff 	bicl3 $0xffffff3f,r1,r0
   1622b:	ff ff 51 50 
   1622f:	d1 50 8f 80 	cmpl r0,$0x00000080
   16233:	00 00 00 
   16236:	12 15       	bneq 1624d <_citrus_utf8_ctype_mbrtowc+0xbd>
   16238:	78 06 52 52 	ashl $0x6,r2,r2
   1623c:	cb 8f c0 ff 	bicl3 $0xffffffc0,r1,r0
   16240:	ff ff 51 50 
   16244:	c8 50 52    	bisl2 r0,r2
   16247:	d6 53       	incl r3
   16249:	d6 54       	incl r4
   1624b:	11 c7       	brb 16214 <_citrus_utf8_ctype_mbrtowc+0x84>
   1624d:	fb 00 ef 74 	calls $0x0,109c8 <___errno>
   16251:	a7 ff ff 
   16254:	9a 8f 54 60 	movzbl $0x54,(r0)
   16258:	d2 00 50    	mcoml $0x0,r0
   1625b:	04          	ret
   1625c:	d1 54 55    	cmpl r4,r5
   1625f:	19 2d       	blss 1628e <_citrus_utf8_ctype_mbrtowc+0xfe>
   16261:	d1 52 59    	cmpl r2,r9
   16264:	19 e7       	blss 1624d <_citrus_utf8_ctype_mbrtowc+0xbd>
   16266:	c1 52 8f 00 	addl3 r2,$0xffff2800,r0
   1626a:	28 ff ff 50 
   1626e:	d1 50 8f ff 	cmpl r0,$0x000007ff
   16272:	07 00 00 
   16275:	1b d6       	blequ 1624d <_citrus_utf8_ctype_mbrtowc+0xbd>
   16277:	d5 58       	tstl r8
   16279:	13 03       	beql 1627e <_citrus_utf8_ctype_mbrtowc+0xee>
   1627b:	d0 52 68    	movl r2,(r8)
   1627e:	d4 a7 04    	clrf 0x4(r7)
   16281:	d5 52       	tstl r2
   16283:	13 04       	beql 16289 <_citrus_utf8_ctype_mbrtowc+0xf9>
   16285:	d0 55 50    	movl r5,r0
   16288:	04          	ret
   16289:	d4 50       	clrf r0
   1628b:	31 4c ff    	brw 161da <_citrus_utf8_ctype_mbrtowc+0x4a>
   1628e:	c3 54 55 a7 	subl3 r4,r5,0x4(r7)
   16292:	04 
   16293:	d0 59 a7 08 	movl r9,0x8(r7)
   16297:	d0 52 67    	movl r2,(r7)
   1629a:	d2 01 50    	mcoml $0x1,r0
   1629d:	04          	ret
   1629e:	d0 67 52    	movl (r7),r2
   162a1:	31 66 ff    	brw 1620a <_citrus_utf8_ctype_mbrtowc+0x7a>
   162a4:	cb 8f 1f ff 	bicl3 $0xffffff1f,r1,r0
   162a8:	ff ff 51 50 
   162ac:	d1 50 8f c0 	cmpl r0,$0x000000c0
   162b0:	00 00 00 
   162b3:	13 43       	beql 162f8 <_citrus_utf8_ctype_mbrtowc+0x168>
   162b5:	cb 8f 0f ff 	bicl3 $0xffffff0f,r1,r0
   162b9:	ff ff 51 50 
   162bd:	d1 50 8f e0 	cmpl r0,$0x000000e0
   162c1:	00 00 00 
   162c4:	13 24       	beql 162ea <_citrus_utf8_ctype_mbrtowc+0x15a>
   162c6:	cb 8f 07 ff 	bicl3 $0xffffff07,r1,r0
   162ca:	ff ff 51 50 
   162ce:	d1 50 8f f0 	cmpl r0,$0x000000f0
   162d2:	00 00 00 
   162d5:	13 03       	beql 162da <_citrus_utf8_ctype_mbrtowc+0x14a>
   162d7:	31 73 ff    	brw 1624d <_citrus_utf8_ctype_mbrtowc+0xbd>
   162da:	d0 07 52    	movl $0x7,r2
   162dd:	d0 04 55    	movl $0x4,r5
   162e0:	d0 8f 00 00 	movl $0x00010000,r9
   162e4:	01 00 59 
   162e7:	31 0f ff    	brw 161f9 <_citrus_utf8_ctype_mbrtowc+0x69>
   162ea:	d0 0f 52    	movl $0xf,r2
   162ed:	d0 03 55    	movl $0x3,r5
   162f0:	3c 8f 00 08 	movzwl $0x0800,r9
   162f4:	59 
   162f5:	31 01 ff    	brw 161f9 <_citrus_utf8_ctype_mbrtowc+0x69>
   162f8:	d0 1f 52    	movl $0x1f,r2
   162fb:	d0 02 55    	movl $0x2,r5
   162fe:	9a 8f 80 59 	movzbl $0x80,r9
   16302:	31 f4 fe    	brw 161f9 <_citrus_utf8_ctype_mbrtowc+0x69>
   16305:	d0 50 55    	movl r0,r5
   16308:	d0 a7 08 59 	movl 0x8(r7),r9
   1630c:	31 ea fe    	brw 161f9 <_citrus_utf8_ctype_mbrtowc+0x69>
   1630f:	9e ef 0b 4d 	movab 2b020 <_DefaultTimeLocale+0x208>,r3
   16313:	01 00 53 
   16316:	d0 01 56    	movl $0x1,r6
   16319:	d4 58       	clrf r8
   1631b:	31 9a fe    	brw 161b8 <_citrus_utf8_ctype_mbrtowc+0x28>
   1631e:	fb 00 ef a3 	calls $0x0,109c8 <___errno>
   16322:	a6 ff ff 
   16325:	d0 16 60    	movl $0x16,(r0)
   16328:	31 2d ff    	brw 16258 <_citrus_utf8_ctype_mbrtowc+0xc8>
   1632b:	01          	nop

0001632c <_citrus_utf8_ctype_mbsinit>:
   1632c:	00 00       	.word 0x0000 # Entry mask: < >
   1632e:	c2 04 5e    	subl2 $0x4,sp
   16331:	d0 ac 04 51 	movl 0x4(ap),r1
   16335:	d4 50       	clrf r0
   16337:	d5 51       	tstl r1
   16339:	13 05       	beql 16340 <_citrus_utf8_ctype_mbsinit+0x14>
   1633b:	d5 a1 04    	tstl 0x4(r1)
   1633e:	12 03       	bneq 16343 <_citrus_utf8_ctype_mbsinit+0x17>
   16340:	d0 01 50    	movl $0x1,r0
   16343:	04          	ret

00016344 <_citrus_utf8_ctype_mbsnrtowcs>:
   16344:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   16346:	c2 08 5e    	subl2 $0x8,sp
   16349:	d0 ac 08 59 	movl 0x8(ap),r9
   1634d:	d0 ac 0c 5a 	movl 0xc(ap),r10
   16351:	d0 ac 10 5b 	movl 0x10(ap),r11
   16355:	d0 ac 14 ad 	movl 0x14(ap),0xfffffff8(fp)
   16359:	f8 
   1635a:	d5 ac 04    	tstl 0x4(ap)
   1635d:	12 03       	bneq 16362 <_citrus_utf8_ctype_mbsnrtowcs+0x1e>
   1635f:	31 a8 00    	brw 1640a <_citrus_utf8_ctype_mbsnrtowcs+0xc6>
   16362:	d5 5b       	tstl r11
   16364:	13 15       	beql 1637b <_citrus_utf8_ctype_mbsnrtowcs+0x37>
   16366:	d5 5a       	tstl r10
   16368:	13 11       	beql 1637b <_citrus_utf8_ctype_mbsnrtowcs+0x37>
   1636a:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   1636e:	d5 a1 04    	tstl 0x4(r1)
   16371:	15 08       	bleq 1637b <_citrus_utf8_ctype_mbsnrtowcs+0x37>
   16373:	95 b9 00    	tstb *0x0(r9)
   16376:	19 03       	blss 1637b <_citrus_utf8_ctype_mbsnrtowcs+0x37>
   16378:	31 80 00    	brw 163fb <_citrus_utf8_ctype_mbsnrtowcs+0xb7>
   1637b:	d4 57       	clrf r7
   1637d:	d4 56       	clrf r6
   1637f:	d1 57 5a    	cmpl r7,r10
   16382:	1e 35       	bcc 163b9 <_citrus_utf8_ctype_mbsnrtowcs+0x75>
   16384:	d1 57 5b    	cmpl r7,r11
   16387:	1e 30       	bcc 163b9 <_citrus_utf8_ctype_mbsnrtowcs+0x75>
   16389:	d0 ac 04 58 	movl 0x4(ap),r8
   1638d:	d0 69 51    	movl (r9),r1
   16390:	90 41 66 50 	movb (r6)[r1],r0
   16394:	19 30       	blss 163c6 <_citrus_utf8_ctype_mbsnrtowcs+0x82>
   16396:	d0 ac 04 51 	movl 0x4(ap),r1
   1639a:	9a 50 47 61 	movzbl r0,(r1)[r7]
   1639e:	95 46 b9 00 	tstb *0x0(r9)[r6]
   163a2:	13 1c       	beql 163c0 <_citrus_utf8_ctype_mbsnrtowcs+0x7c>
   163a4:	d0 01 50    	movl $0x1,r0
   163a7:	c0 50 56    	addl2 r0,r6
   163aa:	d6 57       	incl r7
   163ac:	c0 04 58    	addl2 $0x4,r8
   163af:	d1 56 5a    	cmpl r6,r10
   163b2:	1e 05       	bcc 163b9 <_citrus_utf8_ctype_mbsnrtowcs+0x75>
   163b4:	d1 57 5b    	cmpl r7,r11
   163b7:	1f d4       	blssu 1638d <_citrus_utf8_ctype_mbsnrtowcs+0x49>
   163b9:	c0 56 69    	addl2 r6,(r9)
   163bc:	d0 57 50    	movl r7,r0
   163bf:	04          	ret
   163c0:	d4 69       	clrf (r9)
   163c2:	d0 57 50    	movl r7,r0
   163c5:	04          	ret
   163c6:	dd ad f8    	pushl 0xfffffff8(fp)
   163c9:	c3 56 5a 7e 	subl3 r6,r10,-(sp)
   163cd:	c1 51 56 7e 	addl3 r1,r6,-(sp)
   163d1:	dd 58       	pushl r8
   163d3:	fb 04 ef b6 	calls $0x4,16190 <_citrus_utf8_ctype_mbrtowc>
   163d7:	fd ff ff 
   163da:	d1 50 8f ff 	cmpl r0,$0xffffffff
   163de:	ff ff ff 
   163e1:	13 14       	beql 163f7 <_citrus_utf8_ctype_mbsnrtowcs+0xb3>
   163e3:	d1 50 8f fe 	cmpl r0,$0xfffffffe
   163e7:	ff ff ff 
   163ea:	13 06       	beql 163f2 <_citrus_utf8_ctype_mbsnrtowcs+0xae>
   163ec:	d5 50       	tstl r0
   163ee:	12 b7       	bneq 163a7 <_citrus_utf8_ctype_mbsnrtowcs+0x63>
   163f0:	11 ce       	brb 163c0 <_citrus_utf8_ctype_mbsnrtowcs+0x7c>
   163f2:	c0 5a 69    	addl2 r10,(r9)
   163f5:	11 cb       	brb 163c2 <_citrus_utf8_ctype_mbsnrtowcs+0x7e>
   163f7:	c0 56 69    	addl2 r6,(r9)
   163fa:	04          	ret
   163fb:	fb 00 ef c6 	calls $0x0,109c8 <___errno>
   163ff:	a5 ff ff 
   16402:	9a 8f 54 60 	movzbl $0x54,(r0)
   16406:	d2 00 50    	mcoml $0x0,r0
   16409:	04          	ret
   1640a:	d5 5a       	tstl r10
   1640c:	13 0e       	beql 1641c <_citrus_utf8_ctype_mbsnrtowcs+0xd8>
   1640e:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   16412:	d5 a0 04    	tstl 0x4(r0)
   16415:	15 05       	bleq 1641c <_citrus_utf8_ctype_mbsnrtowcs+0xd8>
   16417:	95 b9 00    	tstb *0x0(r9)
   1641a:	18 df       	bgeq 163fb <_citrus_utf8_ctype_mbsnrtowcs+0xb7>
   1641c:	d4 57       	clrf r7
   1641e:	d4 56       	clrf r6
   16420:	d1 57 5a    	cmpl r7,r10
   16423:	1e 9d       	bcc 163c2 <_citrus_utf8_ctype_mbsnrtowcs+0x7e>
   16425:	d0 69 51    	movl (r9),r1
   16428:	90 41 66 50 	movb (r6)[r1],r0
   1642c:	19 11       	blss 1643f <_citrus_utf8_ctype_mbsnrtowcs+0xfb>
   1642e:	13 92       	beql 163c2 <_citrus_utf8_ctype_mbsnrtowcs+0x7e>
   16430:	d0 01 50    	movl $0x1,r0
   16433:	c0 50 56    	addl2 r0,r6
   16436:	d6 57       	incl r7
   16438:	d1 56 5a    	cmpl r6,r10
   1643b:	1f e8       	blssu 16425 <_citrus_utf8_ctype_mbsnrtowcs+0xe1>
   1643d:	11 83       	brb 163c2 <_citrus_utf8_ctype_mbsnrtowcs+0x7e>
   1643f:	dd ad f8    	pushl 0xfffffff8(fp)
   16442:	c3 56 5a 7e 	subl3 r6,r10,-(sp)
   16446:	c1 51 56 7e 	addl3 r1,r6,-(sp)
   1644a:	d4 7e       	clrf -(sp)
   1644c:	fb 04 ef 3d 	calls $0x4,16190 <_citrus_utf8_ctype_mbrtowc>
   16450:	fd ff ff 
   16453:	d1 50 8f ff 	cmpl r0,$0xffffffff
   16457:	ff ff ff 
   1645a:	12 03       	bneq 1645f <_citrus_utf8_ctype_mbsnrtowcs+0x11b>
   1645c:	31 60 ff    	brw 163bf <_citrus_utf8_ctype_mbsnrtowcs+0x7b>
   1645f:	d1 50 8f fe 	cmpl r0,$0xfffffffe
   16463:	ff ff ff 
   16466:	12 03       	bneq 1646b <_citrus_utf8_ctype_mbsnrtowcs+0x127>
   16468:	31 57 ff    	brw 163c2 <_citrus_utf8_ctype_mbsnrtowcs+0x7e>
   1646b:	d5 50       	tstl r0
   1646d:	12 c4       	bneq 16433 <_citrus_utf8_ctype_mbsnrtowcs+0xef>
   1646f:	31 50 ff    	brw 163c2 <_citrus_utf8_ctype_mbsnrtowcs+0x7e>

00016472 <_citrus_utf8_ctype_wcrtomb>:
   16472:	00 00       	.word 0x0000 # Entry mask: < >
   16474:	c2 04 5e    	subl2 $0x4,sp
   16477:	d0 ac 04 53 	movl 0x4(ap),r3
   1647b:	d0 ac 08 52 	movl 0x8(ap),r2
   1647f:	d0 ac 0c 50 	movl 0xc(ap),r0
   16483:	d5 a0 04    	tstl 0x4(r0)
   16486:	12 75       	bneq 164fd <_citrus_utf8_ctype_wcrtomb+0x8b>
   16488:	d5 53       	tstl r3
   1648a:	13 0c       	beql 16498 <_citrus_utf8_ctype_wcrtomb+0x26>
   1648c:	d3 52 8f 80 	bitl r2,$0xffffff80
   16490:	ff ff ff 
   16493:	12 07       	bneq 1649c <_citrus_utf8_ctype_wcrtomb+0x2a>
   16495:	90 52 63    	movb r2,(r3)
   16498:	d0 01 50    	movl $0x1,r0
   1649b:	04          	ret
   1649c:	d3 52 8f 00 	bitl r2,$0xfffff800
   164a0:	f8 ff ff 
   164a3:	12 27       	bneq 164cc <_citrus_utf8_ctype_wcrtomb+0x5a>
   164a5:	92 3f 55    	mcomb $0x3f,r5
   164a8:	d0 02 54    	movl $0x2,r4
   164ab:	c3 01 54 51 	subl3 $0x1,r4,r1
   164af:	15 13       	bleq 164c4 <_citrus_utf8_ctype_wcrtomb+0x52>
   164b1:	8b 8f c0 52 	bicb3 $0xc0,r2,r0
   164b5:	50 
   164b6:	89 8f 80 50 	bisb3 $0x80,r0,(r1)[r3]
   164ba:	43 61 
   164bc:	78 8f fa 52 	ashl $0xfa,r2,r2
   164c0:	52 
   164c1:	f5 51 ed    	sobgtr r1,164b1 <_citrus_utf8_ctype_wcrtomb+0x3f>
   164c4:	89 52 55 63 	bisb3 r2,r5,(r3)
   164c8:	d0 54 50    	movl r4,r0
   164cb:	04          	ret
   164cc:	d3 52 8f 00 	bitl r2,$0xffff0000
   164d0:	00 ff ff 
   164d3:	12 08       	bneq 164dd <_citrus_utf8_ctype_wcrtomb+0x6b>
   164d5:	92 1f 55    	mcomb $0x1f,r5
   164d8:	d0 03 54    	movl $0x3,r4
   164db:	11 ce       	brb 164ab <_citrus_utf8_ctype_wcrtomb+0x39>
   164dd:	d3 52 8f 00 	bitl r2,$0xffe00000
   164e1:	00 e0 ff 
   164e4:	12 08       	bneq 164ee <_citrus_utf8_ctype_wcrtomb+0x7c>
   164e6:	92 0f 55    	mcomb $0xf,r5
   164e9:	d0 04 54    	movl $0x4,r4
   164ec:	11 bd       	brb 164ab <_citrus_utf8_ctype_wcrtomb+0x39>
   164ee:	fb 00 ef d3 	calls $0x0,109c8 <___errno>
   164f2:	a4 ff ff 
   164f5:	9a 8f 54 60 	movzbl $0x54,(r0)
   164f9:	d2 00 50    	mcoml $0x0,r0
   164fc:	04          	ret
   164fd:	fb 00 ef c4 	calls $0x0,109c8 <___errno>
   16501:	a4 ff ff 
   16504:	d0 16 60    	movl $0x16,(r0)
   16507:	11 f0       	brb 164f9 <_citrus_utf8_ctype_wcrtomb+0x87>
   16509:	01          	nop

0001650a <_citrus_utf8_ctype_wcsnrtombs>:
   1650a:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   1650c:	c2 14 5e    	subl2 $0x14,sp
   1650f:	d0 ef 83 5a 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   16513:	02 00 ad f8 
   16517:	d0 ac 04 5b 	movl 0x4(ap),r11
   1651b:	d0 ac 08 5a 	movl 0x8(ap),r10
   1651f:	d0 ac 14 ad 	movl 0x14(ap),0xfffffff0(fp)
   16523:	f0 
   16524:	d0 ad f0 50 	movl 0xfffffff0(fp),r0
   16528:	d5 a0 04    	tstl 0x4(r0)
   1652b:	13 03       	beql 16530 <_citrus_utf8_ctype_wcsnrtombs+0x26>
   1652d:	31 2c 01    	brw 1665c <_citrus_utf8_ctype_wcsnrtombs+0x152>
   16530:	d5 5b       	tstl r11
   16532:	12 03       	bneq 16537 <_citrus_utf8_ctype_wcsnrtombs+0x2d>
   16534:	31 d5 00    	brw 1660c <_citrus_utf8_ctype_wcsnrtombs+0x102>
   16537:	d4 57       	clrf r7
   16539:	d4 58       	clrf r8
   1653b:	d1 57 ac 0c 	cmpl r7,0xc(ap)
   1653f:	1e 37       	bcc 16578 <_citrus_utf8_ctype_wcsnrtombs+0x6e>
   16541:	d1 57 ac 10 	cmpl r7,0x10(ap)
   16545:	1e 31       	bcc 16578 <_citrus_utf8_ctype_wcsnrtombs+0x6e>
   16547:	d4 ad ec    	clrf 0xffffffec(fp)
   1654a:	d0 48 ba 00 	movl *0x0(r10)[r8],r0
   1654e:	50 
   1654f:	d1 50 8f 7f 	cmpl r0,$0x0000007f
   16553:	00 00 00 
   16556:	1a 4a       	bgtru 165a2 <_citrus_utf8_ctype_wcsnrtombs+0x98>
   16558:	90 50 4b 67 	movb r0,(r7)[r11]
   1655c:	d5 50       	tstl r0
   1655e:	13 3e       	beql 1659e <_citrus_utf8_ctype_wcsnrtombs+0x94>
   16560:	d0 01 56    	movl $0x1,r6
   16563:	d6 58       	incl r8
   16565:	c0 04 ad ec 	addl2 $0x4,0xffffffec(fp)
   16569:	c0 56 57    	addl2 r6,r7
   1656c:	d1 58 ac 0c 	cmpl r8,0xc(ap)
   16570:	1e 06       	bcc 16578 <_citrus_utf8_ctype_wcsnrtombs+0x6e>
   16572:	d1 57 ac 10 	cmpl r7,0x10(ap)
   16576:	1f d2       	blssu 1654a <_citrus_utf8_ctype_wcsnrtombs+0x40>
   16578:	de 48 ba 00 	moval *0x0(r10)[r8],(r10)
   1657c:	6a 
   1657d:	d0 57 50    	movl r7,r0
   16580:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   16584:	d1 51 ef 0d 	cmpl r1,3bf98 <__guard_local>
   16588:	5a 02 00 
   1658b:	13 10       	beql 1659d <_citrus_utf8_ctype_wcsnrtombs+0x93>
   1658d:	dd ad f8    	pushl 0xfffffff8(fp)
   16590:	9f ef da 47 	pushab 2ad70 <__tens_D2A+0x148>
   16594:	01 00 
   16596:	fb 02 ef cf 	calls $0x2,1666c <__stack_smash_handler>
   1659a:	00 00 00 
   1659d:	04          	ret
   1659e:	d4 6a       	clrf (r10)
   165a0:	11 db       	brb 1657d <_citrus_utf8_ctype_wcsnrtombs+0x73>
   165a2:	c3 57 ac 10 	subl3 r7,0x10(ap),r9
   165a6:	59 
   165a7:	d1 59 03    	cmpl r9,$0x3
   165aa:	1b 22       	blequ 165ce <_citrus_utf8_ctype_wcsnrtombs+0xc4>
   165ac:	dd ad f0    	pushl 0xfffffff0(fp)
   165af:	dd 50       	pushl r0
   165b1:	c1 5b 57 7e 	addl3 r11,r7,-(sp)
   165b5:	fb 03 ef b6 	calls $0x3,16472 <_citrus_utf8_ctype_wcrtomb>
   165b9:	fe ff ff 
   165bc:	d0 50 56    	movl r0,r6
   165bf:	d1 50 8f ff 	cmpl r0,$0xffffffff
   165c3:	ff ff ff 
   165c6:	12 9b       	bneq 16563 <_citrus_utf8_ctype_wcsnrtombs+0x59>
   165c8:	c0 ad ec 6a 	addl2 0xffffffec(fp),(r10)
   165cc:	11 b2       	brb 16580 <_citrus_utf8_ctype_wcsnrtombs+0x76>
   165ce:	dd ad f0    	pushl 0xfffffff0(fp)
   165d1:	dd 50       	pushl r0
   165d3:	9f ad f4    	pushab 0xfffffff4(fp)
   165d6:	fb 03 ef 95 	calls $0x3,16472 <_citrus_utf8_ctype_wcrtomb>
   165da:	fe ff ff 
   165dd:	d0 50 56    	movl r0,r6
   165e0:	d1 50 8f ff 	cmpl r0,$0xffffffff
   165e4:	ff ff ff 
   165e7:	13 18       	beql 16601 <_citrus_utf8_ctype_wcsnrtombs+0xf7>
   165e9:	d1 50 59    	cmpl r0,r9
   165ec:	1a 8a       	bgtru 16578 <_citrus_utf8_ctype_wcsnrtombs+0x6e>
   165ee:	dd 50       	pushl r0
   165f0:	9f ad f4    	pushab 0xfffffff4(fp)
   165f3:	c1 5b 57 7e 	addl3 r11,r7,-(sp)
   165f7:	fb 03 ef f0 	calls $0x3,166ee <memcpy>
   165fb:	00 00 00 
   165fe:	31 62 ff    	brw 16563 <_citrus_utf8_ctype_wcsnrtombs+0x59>
   16601:	de 48 ba 00 	moval *0x0(r10)[r8],(r10)
   16605:	6a 
   16606:	d0 56 50    	movl r6,r0
   16609:	31 74 ff    	brw 16580 <_citrus_utf8_ctype_wcsnrtombs+0x76>
   1660c:	d4 57       	clrf r7
   1660e:	d4 58       	clrf r8
   16610:	d1 57 ac 0c 	cmpl r7,0xc(ap)
   16614:	1f 03       	blssu 16619 <_citrus_utf8_ctype_wcsnrtombs+0x10f>
   16616:	31 64 ff    	brw 1657d <_citrus_utf8_ctype_wcsnrtombs+0x73>
   16619:	d0 48 ba 00 	movl *0x0(r10)[r8],r0
   1661d:	50 
   1661e:	d1 50 8f 7f 	cmpl r0,$0x0000007f
   16622:	00 00 00 
   16625:	1a 18       	bgtru 1663f <_citrus_utf8_ctype_wcsnrtombs+0x135>
   16627:	d5 50       	tstl r0
   16629:	12 03       	bneq 1662e <_citrus_utf8_ctype_wcsnrtombs+0x124>
   1662b:	31 4f ff    	brw 1657d <_citrus_utf8_ctype_wcsnrtombs+0x73>
   1662e:	d0 01 56    	movl $0x1,r6
   16631:	d6 58       	incl r8
   16633:	c0 56 57    	addl2 r6,r7
   16636:	d1 58 ac 0c 	cmpl r8,0xc(ap)
   1663a:	1f dd       	blssu 16619 <_citrus_utf8_ctype_wcsnrtombs+0x10f>
   1663c:	31 3e ff    	brw 1657d <_citrus_utf8_ctype_wcsnrtombs+0x73>
   1663f:	dd ad f0    	pushl 0xfffffff0(fp)
   16642:	dd 50       	pushl r0
   16644:	9f ad f4    	pushab 0xfffffff4(fp)
   16647:	fb 03 ef 24 	calls $0x3,16472 <_citrus_utf8_ctype_wcrtomb>
   1664b:	fe ff ff 
   1664e:	d0 50 56    	movl r0,r6
   16651:	d1 50 8f ff 	cmpl r0,$0xffffffff
   16655:	ff ff ff 
   16658:	12 d7       	bneq 16631 <_citrus_utf8_ctype_wcsnrtombs+0x127>
   1665a:	11 aa       	brb 16606 <_citrus_utf8_ctype_wcsnrtombs+0xfc>
   1665c:	fb 00 ef 65 	calls $0x0,109c8 <___errno>
   16660:	a3 ff ff 
   16663:	d0 16 60    	movl $0x16,(r0)
   16666:	d2 00 50    	mcoml $0x0,r0
   16669:	31 14 ff    	brw 16580 <_citrus_utf8_ctype_wcsnrtombs+0x76>

0001666c <__stack_smash_handler>:
   1666c:	40 00       	.word 0x0040 # Entry mask: < r6 >
   1666e:	9e ae b8 5e 	movab 0xffffffb8(sp),sp
   16672:	d0 ef 20 59 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   16676:	02 00 ad f8 
   1667a:	d0 ac 04 56 	movl 0x4(ap),r6
   1667e:	28 10 ef 0b 	movc3 $0x10,2ad90 <__tens_D2A+0x168>,0xffffffc8(fp)
   16682:	47 01 00 ad 
   16686:	c8 
   16687:	28 1e ef 12 	movc3 $0x1e,2ada0 <__tens_D2A+0x178>,0xffffffd8(fp)
   1668b:	47 01 00 ad 
   1668f:	d8 
   16690:	d2 00 ad b8 	mcoml $0x0,0xffffffb8(fp)
   16694:	d2 20 ad b8 	mcoml $0x20,0xffffffb8(fp)
   16698:	d4 7e       	clrf -(sp)
   1669a:	9f ad b8    	pushab 0xffffffb8(fp)
   1669d:	dd 01       	pushl $0x1
   1669f:	fb 03 ef 5a 	calls $0x3,16800 <_thread_sys_sigprocmask>
   166a3:	01 00 00 
   166a6:	dd 56       	pushl r6
   166a8:	9f ad d8    	pushab 0xffffffd8(fp)
   166ab:	9f ad c8    	pushab 0xffffffc8(fp)
   166ae:	dd 02       	pushl $0x2
   166b0:	fb 04 ef fd 	calls $0x4,16cb4 <syslog_r>
   166b4:	05 00 00 
   166b7:	7c ad bc    	clrd 0xffffffbc(fp)
   166ba:	d4 ad c4    	clrf 0xffffffc4(fp)
   166bd:	d4 ad c0    	clrf 0xffffffc0(fp)
   166c0:	d4 ad bc    	clrf 0xffffffbc(fp)
   166c3:	d4 7e       	clrf -(sp)
   166c5:	9f ad bc    	pushab 0xffffffbc(fp)
   166c8:	dd 06       	pushl $0x6
   166ca:	fb 03 ef 67 	calls $0x3,16a38 <_thread_sys_sigaction>
   166ce:	03 00 00 
   166d1:	dd 06       	pushl $0x6
   166d3:	fb 00 ef 6e 	calls $0x0,16a48 <_thread_sys_getpid>
   166d7:	03 00 00 
   166da:	dd 50       	pushl r0
   166dc:	fb 02 ef 55 	calls $0x2,16b38 <_thread_sys_kill>
   166e0:	04 00 00 
   166e3:	9a 8f 7f 7e 	movzbl $0x7f,-(sp)
   166e7:	fb 01 ef ca 	calls $0x1,169b8 <_thread_sys__exit>
   166eb:	02 00 00 

000166ee <memcpy>:
   166ee:	00 00       	.word 0x0000 # Entry mask: < >
   166f0:	c2 14 5e    	subl2 $0x14,sp
   166f3:	d0 ac 04 54 	movl 0x4(ap),r4
   166f7:	d0 ac 0c 53 	movl 0xc(ap),r3
   166fb:	d0 54 52    	movl r4,r2
   166fe:	d0 ac 08 51 	movl 0x8(ap),r1
   16702:	d5 53       	tstl r3
   16704:	12 03       	bneq 16709 <memcpy+0x1b>
   16706:	31 8c 00    	brw 16795 <memcpy+0xa7>
   16709:	d1 54 51    	cmpl r4,r1
   1670c:	12 03       	bneq 16711 <memcpy+0x23>
   1670e:	31 84 00    	brw 16795 <memcpy+0xa7>
   16711:	1e 2b       	bcc 1673e <memcpy+0x50>
   16713:	c1 54 53 50 	addl3 r4,r3,r0
   16717:	d1 50 51    	cmpl r0,r1
   1671a:	1b 22       	blequ 1673e <memcpy+0x50>
   1671c:	28 10 ef 9d 	movc3 $0x10,2adc0 <__tens_D2A+0x198>,0xffffffec(fp)
   16720:	46 01 00 ad 
   16724:	ec 
   16725:	9f ef a5 46 	pushab 2add0 <__tens_D2A+0x1a8>
   16729:	01 00 
   1672b:	9f ad ec    	pushab 0xffffffec(fp)
   1672e:	dd 02       	pushl $0x2
   16730:	fb 03 ef 7d 	calls $0x3,16cb4 <syslog_r>
   16734:	05 00 00 
   16737:	fb 00 ef 6a 	calls $0x0,167a8 <abort>
   1673b:	00 00 00 
   1673e:	d1 51 54    	cmpl r1,r4
   16741:	1e 09       	bcc 1674c <memcpy+0x5e>
   16743:	c1 51 53 50 	addl3 r1,r3,r0
   16747:	d1 50 54    	cmpl r0,r4
   1674a:	1a d0       	bgtru 1671c <memcpy+0x2e>
   1674c:	c9 52 51 50 	bisl3 r2,r1,r0
   16750:	d3 50 03    	bitl r0,$0x3
   16753:	13 1b       	beql 16770 <memcpy+0x82>
   16755:	cd 52 51 50 	xorl3 r2,r1,r0
   16759:	d3 50 03    	bitl r0,$0x3
   1675c:	12 05       	bneq 16763 <memcpy+0x75>
   1675e:	d1 53 03    	cmpl r3,$0x3
   16761:	1a 36       	bgtru 16799 <memcpy+0xab>
   16763:	d0 53 50    	movl r3,r0
   16766:	c2 50 53    	subl2 r0,r3
   16769:	90 81 82    	movb (r1)+,(r2)+
   1676c:	d7 50       	decl r0
   1676e:	12 f9       	bneq 16769 <memcpy+0x7b>
   16770:	9c 1e 53 50 	rotl $0x1e,r3,r0
   16774:	ca 8f 00 00 	bicl2 $0xc0000000,r0
   16778:	00 c0 50 
   1677b:	13 07       	beql 16784 <memcpy+0x96>
   1677d:	d0 81 82    	movl (r1)+,(r2)+
   16780:	d7 50       	decl r0
   16782:	12 f9       	bneq 1677d <memcpy+0x8f>
   16784:	cb 8f fc ff 	bicl3 $0xfffffffc,r3,r0
   16788:	ff ff 53 50 
   1678c:	13 07       	beql 16795 <memcpy+0xa7>
   1678e:	90 81 82    	movb (r1)+,(r2)+
   16791:	d7 50       	decl r0
   16793:	12 f9       	bneq 1678e <memcpy+0xa0>
   16795:	d0 54 50    	movl r4,r0
   16798:	04          	ret
   16799:	cb 8f fc ff 	bicl3 $0xfffffffc,r1,r0
   1679d:	ff ff 51 50 
   167a1:	c3 50 04 50 	subl3 r0,$0x4,r0
   167a5:	11 bf       	brb 16766 <memcpy+0x78>
   167a7:	01          	nop

000167a8 <abort>:
   167a8:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   167aa:	c2 08 5e    	subl2 $0x8,sp
   167ad:	d2 00 ad f8 	mcoml $0x0,0xfffffff8(fp)
   167b1:	d2 20 ad f8 	mcoml $0x20,0xfffffff8(fp)
   167b5:	d4 7e       	clrf -(sp)
   167b7:	9f ad f8    	pushab 0xfffffff8(fp)
   167ba:	dd 03       	pushl $0x3
   167bc:	9e ef 3e 00 	movab 16800 <_thread_sys_sigprocmask>,r7
   167c0:	00 00 57 
   167c3:	fb 03 67    	calls $0x3,(r7)
   167c6:	dd 06       	pushl $0x6
   167c8:	9e ef 54 00 	movab 16822 <raise>,r6
   167cc:	00 00 56 
   167cf:	fb 01 66    	calls $0x1,(r6)
   167d2:	d4 7e       	clrf -(sp)
   167d4:	dd 06       	pushl $0x6
   167d6:	fb 02 ef 6f 	calls $0x2,1694c <_signal>
   167da:	01 00 00 
   167dd:	d4 7e       	clrf -(sp)
   167df:	9f ad f8    	pushab 0xfffffff8(fp)
   167e2:	dd 03       	pushl $0x3
   167e4:	fb 03 67    	calls $0x3,(r7)
   167e7:	dd 06       	pushl $0x6
   167e9:	fb 01 66    	calls $0x1,(r6)
   167ec:	dd 01       	pushl $0x1
   167ee:	fb 01 ef c3 	calls $0x1,169b8 <_thread_sys__exit>
   167f2:	01 00 00 
   167f5:	01          	nop
   167f6:	01          	nop
   167f7:	01          	nop

000167f8 <err>:
   167f8:	17 ef bb a1 	jmp 109b9 <___cerror>
   167fc:	ff ff 
   167fe:	01          	nop
   167ff:	01          	nop

00016800 <_thread_sys_sigprocmask>:
   16800:	00 00       	.word 0x0000 # Entry mask: < >
   16802:	d5 ac 08    	tstl 0x8(ap)
   16805:	12 06       	bneq 1680d <_thread_sys_sigprocmask+0xd>
   16807:	d0 01 ac 04 	movl $0x1,0x4(ap)
   1680b:	11 05       	brb 16812 <_thread_sys_sigprocmask+0x12>
   1680d:	d0 bc 08 ac 	movl *0x8(ap),0x8(ap)
   16811:	08 
   16812:	bc 30       	chmk $0x30
   16814:	1f e2       	blssu 167f8 <err>
   16816:	d5 ac 0c    	tstl 0xc(ap)
   16819:	13 04       	beql 1681f <out>
   1681b:	d0 50 bc 0c 	movl r0,*0xc(ap)

0001681f <out>:
   1681f:	d4 50       	clrf r0
   16821:	04          	ret

00016822 <raise>:
   16822:	00 00       	.word 0x0000 # Entry mask: < >
   16824:	c2 04 5e    	subl2 $0x4,sp
   16827:	dd ac 04    	pushl 0x4(ap)
   1682a:	fb 00 ef 13 	calls $0x0,16844 <_thread_sys_getthrid>
   1682e:	00 00 00 
   16831:	dd 50       	pushl r0
   16833:	fb 02 ef fe 	calls $0x2,16b38 <_thread_sys_kill>
   16837:	02 00 00 
   1683a:	04          	ret
   1683b:	01          	nop
   1683c:	17 ef 77 a1 	jmp 109b9 <___cerror>
   16840:	ff ff 
   16842:	01          	nop
   16843:	01          	nop

00016844 <_thread_sys_getthrid>:
   16844:	00 00       	.word 0x0000 # Entry mask: < >
   16846:	bc 8f 2b 01 	chmk $0x012b
   1684a:	1f f0       	blssu 1683c <raise+0x1a>
   1684c:	04          	ret
   1684d:	01          	nop

0001684e <strcmp>:
   1684e:	00 00       	.word 0x0000 # Entry mask: < >
   16850:	c2 04 5e    	subl2 $0x4,sp
   16853:	d0 ac 04 51 	movl 0x4(ap),r1
   16857:	d0 ac 08 52 	movl 0x8(ap),r2
   1685b:	90 61 50    	movb (r1),r0
   1685e:	91 50 82    	cmpb r0,(r2)+
   16861:	13 0c       	beql 1686f <strcmp+0x21>
   16863:	9a 61 51    	movzbl (r1),r1
   16866:	9a a2 ff 50 	movzbl 0xffffffff(r2),r0
   1686a:	c3 50 51 50 	subl3 r0,r1,r0
   1686e:	04          	ret
   1686f:	d6 51       	incl r1
   16871:	95 50       	tstb r0
   16873:	13 0a       	beql 1687f <strcmp+0x31>
   16875:	90 61 50    	movb (r1),r0
   16878:	91 50 82    	cmpb r0,(r2)+
   1687b:	13 f2       	beql 1686f <strcmp+0x21>
   1687d:	11 e4       	brb 16863 <strcmp+0x15>
   1687f:	d4 50       	clrf r0
   16881:	04          	ret
   16882:	01          	nop
   16883:	01          	nop

00016884 <memmove>:
   16884:	3c 00       	.word 0x003c # Entry mask: < r5 r4 r3 r2 >
   16886:	3c 8f ff ff 	movzwl $0xffff,r0
   1688a:	50 
   1688b:	7d ac 08 51 	movq 0x8(ap),r1
   1688f:	d0 ac 04 53 	movl 0x4(ap),r3
   16893:	d1 51 53    	cmpl r1,r3
   16896:	1a 0d       	bgtru 168a5 <memmove+0x21>
   16898:	13 14       	beql 168ae <memmove+0x2a>
   1689a:	c0 52 51    	addl2 r2,r1
   1689d:	d1 51 53    	cmpl r1,r3
   168a0:	1a 21       	bgtru 168c3 <memmove+0x3f>
   168a2:	c2 52 51    	subl2 r2,r1
   168a5:	d1 52 50    	cmpl r2,r0
   168a8:	1a 09       	bgtru 168b3 <memmove+0x2f>
   168aa:	28 52 61 63 	movc3 r2,(r1),(r3)
   168ae:	d0 ac 04 50 	movl 0x4(ap),r0
   168b2:	04          	ret
   168b3:	c2 50 ac 0c 	subl2 r0,0xc(ap)
   168b7:	28 50 61 63 	movc3 r0,(r1),(r3)
   168bb:	d0 ac 0c 52 	movl 0xc(ap),r2
   168bf:	b7 50       	decw r0
   168c1:	11 e2       	brb 168a5 <memmove+0x21>
   168c3:	c0 52 53    	addl2 r2,r3
   168c6:	d1 52 50    	cmpl r2,r0
   168c9:	1a 0f       	bgtru 168da <memmove+0x56>
   168cb:	c2 52 51    	subl2 r2,r1
   168ce:	c2 52 53    	subl2 r2,r3
   168d1:	28 52 61 63 	movc3 r2,(r1),(r3)
   168d5:	d0 ac 04 50 	movl 0x4(ap),r0
   168d9:	04          	ret
   168da:	c2 50 ac 0c 	subl2 r0,0xc(ap)
   168de:	c2 50 51    	subl2 r0,r1
   168e1:	c2 50 53    	subl2 r0,r3
   168e4:	28 50 61 63 	movc3 r0,(r1),(r3)
   168e8:	d0 ac 0c 52 	movl 0xc(ap),r2
   168ec:	b7 50       	decw r0
   168ee:	c2 50 51    	subl2 r0,r1
   168f1:	c2 50 53    	subl2 r0,r3
   168f4:	11 d0       	brb 168c6 <memmove+0x42>
   168f6:	01          	nop
   168f7:	01          	nop

000168f8 <memset>:
   168f8:	3c 00       	.word 0x003c # Entry mask: < r5 r4 r3 r2 >
   168fa:	d0 ac 04 53 	movl 0x4(ap),r3
   168fe:	3c 8f ff ff 	movzwl $0xffff,r0
   16902:	50 
   16903:	7d ac 08 51 	movq 0x8(ap),r1
   16907:	d1 52 50    	cmpl r2,r0
   1690a:	1a 0a       	bgtru 16916 <memset+0x1e>
   1690c:	2c 00 63 51 	movc5 $0x0,(r3),r1,r2,(r3)
   16910:	52 63 
   16912:	d0 51 50    	movl r1,r0
   16915:	04          	ret
   16916:	c2 50 ac 0c 	subl2 r0,0xc(ap)
   1691a:	2c 00 63 51 	movc5 $0x0,(r3),r1,r0,(r3)
   1691e:	50 63 
   16920:	11 dc       	brb 168fe <memset+0x6>

00016922 <strlen>:
   16922:	00 00       	.word 0x0000 # Entry mask: < >
   16924:	c2 04 5e    	subl2 $0x4,sp
   16927:	d0 ac 04 51 	movl 0x4(ap),r1
   1692b:	d0 51 50    	movl r1,r0
   1692e:	95 61       	tstb (r1)
   16930:	13 06       	beql 16938 <strlen+0x16>
   16932:	d6 50       	incl r0
   16934:	95 60       	tstb (r0)
   16936:	12 fa       	bneq 16932 <strlen+0x10>
   16938:	c2 51 50    	subl2 r1,r0
   1693b:	04          	ret
   1693c:	17 ef 77 a0 	jmp 109b9 <___cerror>
   16940:	ff ff 
   16942:	01          	nop
   16943:	01          	nop

00016944 <_thread_sys_recvfrom>:
   16944:	00 00       	.word 0x0000 # Entry mask: < >
   16946:	bc 1d       	chmk $0x1d
   16948:	1f f2       	blssu 1693c <strlen+0x1a>
   1694a:	04          	ret
   1694b:	01          	nop

0001694c <_signal>:
   1694c:	40 00       	.word 0x0040 # Entry mask: < r6 >
   1694e:	c2 1c 5e    	subl2 $0x1c,sp
   16951:	d0 ac 04 56 	movl 0x4(ap),r6
   16955:	7c ad f0    	clrd 0xfffffff0(fp)
   16958:	d4 ad f8    	clrf 0xfffffff8(fp)
   1695b:	d0 ac 08 ad 	movl 0x8(ap),0xfffffff0(fp)
   1695f:	f0 
   16960:	d4 ad f4    	clrf 0xfffffff4(fp)
   16963:	c3 01 56 52 	subl3 $0x1,r6,r2
   16967:	d1 52 1f    	cmpl r2,$0x1f
   1696a:	1a 3b       	bgtru 169a7 <_signal+0x5b>
   1696c:	d0 ef ea ba 	movl 6245c <__sigintr>,r0
   16970:	04 00 50 
   16973:	83 52 20 51 	subb3 r2,$0x20,r1
   16977:	ef 52 51 50 	extzv r2,r1,r0,r0
   1697b:	50 
   1697c:	ca 8f fe ff 	bicl2 $0xfffffffe,r0
   16980:	ff ff 50 
   16983:	d5 50       	tstl r0
   16985:	12 04       	bneq 1698b <_signal+0x3f>
   16987:	c8 02 ad f8 	bisl2 $0x2,0xfffffff8(fp)
   1698b:	9f ad e4    	pushab 0xffffffe4(fp)
   1698e:	9f ad f0    	pushab 0xfffffff0(fp)
   16991:	dd 56       	pushl r6
   16993:	fb 03 ef 9e 	calls $0x3,16a38 <_thread_sys_sigaction>
   16997:	00 00 00 
   1699a:	d5 50       	tstl r0
   1699c:	19 05       	blss 169a3 <_signal+0x57>
   1699e:	d0 ad e4 50 	movl 0xffffffe4(fp),r0
   169a2:	04          	ret
   169a3:	d2 00 50    	mcoml $0x0,r0
   169a6:	04          	ret
   169a7:	fb 00 ef 1a 	calls $0x0,109c8 <___errno>
   169ab:	a0 ff ff 
   169ae:	d0 16 60    	movl $0x16,(r0)
   169b1:	d2 00 50    	mcoml $0x0,r0
   169b4:	11 cd       	brb 16983 <_signal+0x37>
   169b6:	01          	nop
   169b7:	01          	nop

000169b8 <_thread_sys__exit>:
   169b8:	00 00       	.word 0x0000 # Entry mask: < >
   169ba:	bc 01       	chmk $0x1
   169bc:	04          	ret
   169bd:	01          	nop
   169be:	01          	nop
   169bf:	01          	nop
   169c0:	17 ef f3 9f 	jmp 109b9 <___cerror>
   169c4:	ff ff 
   169c6:	01          	nop
   169c7:	01          	nop

000169c8 <_thread_sys_sendto>:
   169c8:	00 00       	.word 0x0000 # Entry mask: < >
   169ca:	bc 8f 85 00 	chmk $0x0085
   169ce:	1f f0       	blssu 169c0 <_thread_sys__exit+0x8>
   169d0:	04          	ret
   169d1:	01          	nop

000169d2 <_weak__thread_tag_lock>:
   169d2:	00 00       	.word 0x0000 # Entry mask: < >
   169d4:	c2 04 5e    	subl2 $0x4,sp
   169d7:	04          	ret

000169d8 <_weak__thread_tag_unlock>:
   169d8:	00 00       	.word 0x0000 # Entry mask: < >
   169da:	c2 04 5e    	subl2 $0x4,sp
   169dd:	04          	ret

000169de <_weak__thread_tag_storage>:
   169de:	00 00       	.word 0x0000 # Entry mask: < >
   169e0:	c2 04 5e    	subl2 $0x4,sp
   169e3:	d0 ac 08 50 	movl 0x8(ap),r0
   169e7:	04          	ret
   169e8:	17 ef cb 9f 	jmp 109b9 <___cerror>
   169ec:	ff ff 
   169ee:	01          	nop
   169ef:	01          	nop

000169f0 <_thread_sys_write>:
   169f0:	00 00       	.word 0x0000 # Entry mask: < >
   169f2:	bc 04       	chmk $0x4
   169f4:	1f f2       	blssu 169e8 <_weak__thread_tag_storage+0xa>
   169f6:	04          	ret
   169f7:	01          	nop
   169f8:	17 ef bb 9f 	jmp 109b9 <___cerror>
   169fc:	ff ff 
   169fe:	01          	nop
   169ff:	01          	nop

00016a00 <_thread_sys___sysctl>:
   16a00:	00 00       	.word 0x0000 # Entry mask: < >
   16a02:	bc 8f ca 00 	chmk $0x00ca
   16a06:	1f f0       	blssu 169f8 <_thread_sys_write+0x8>
   16a08:	04          	ret
   16a09:	01          	nop

00016a0a <_thread_sys_lseek>:
   16a0a:	00 00       	.word 0x0000 # Entry mask: < >
   16a0c:	c2 04 5e    	subl2 $0x4,sp
   16a0f:	dd ac 10    	pushl 0x10(ap)
   16a12:	7d ac 08 7e 	movq 0x8(ap),-(sp)
   16a16:	d4 7e       	clrf -(sp)
   16a18:	dd ac 04    	pushl 0x4(ap)
   16a1b:	7d 8f c7 00 	movq $0x00000000000000c7,-(sp)
   16a1f:	00 00 00 00 
   16a23:	00 00 7e 
   16a26:	fb 07 ef e3 	calls $0x7,16b10 <_thread_sys___syscall>
   16a2a:	00 00 00 
   16a2d:	04          	ret
   16a2e:	01          	nop
   16a2f:	01          	nop
   16a30:	17 ef 83 9f 	jmp 109b9 <___cerror>
   16a34:	ff ff 
   16a36:	01          	nop
   16a37:	01          	nop

00016a38 <_thread_sys_sigaction>:
   16a38:	00 00       	.word 0x0000 # Entry mask: < >
   16a3a:	bc 2e       	chmk $0x2e
   16a3c:	1f f2       	blssu 16a30 <_thread_sys_lseek+0x26>
   16a3e:	04          	ret
   16a3f:	01          	nop
   16a40:	17 ef 73 9f 	jmp 109b9 <___cerror>
   16a44:	ff ff 
   16a46:	01          	nop
   16a47:	01          	nop

00016a48 <_thread_sys_getpid>:
   16a48:	00 00       	.word 0x0000 # Entry mask: < >
   16a4a:	bc 14       	chmk $0x14
   16a4c:	1f f2       	blssu 16a40 <_thread_sys_sigaction+0x8>
   16a4e:	04          	ret
   16a4f:	01          	nop
   16a50:	17 ef 63 9f 	jmp 109b9 <___cerror>
   16a54:	ff ff 
   16a56:	01          	nop
   16a57:	01          	nop

00016a58 <_thread_sys_mprotect>:
   16a58:	00 00       	.word 0x0000 # Entry mask: < >
   16a5a:	bc 8f 4a 00 	chmk $0x004a
   16a5e:	1f f0       	blssu 16a50 <_thread_sys_getpid+0x8>
   16a60:	04          	ret
   16a61:	01          	nop

00016a62 <_thread_sys_mmap>:
   16a62:	00 00       	.word 0x0000 # Entry mask: < >
   16a64:	c2 04 5e    	subl2 $0x4,sp
   16a67:	7d ac 18 7e 	movq 0x18(ap),-(sp)
   16a6b:	d4 7e       	clrf -(sp)
   16a6d:	dd ac 14    	pushl 0x14(ap)
   16a70:	dd ac 10    	pushl 0x10(ap)
   16a73:	dd ac 0c    	pushl 0xc(ap)
   16a76:	dd ac 08    	pushl 0x8(ap)
   16a79:	dd ac 04    	pushl 0x4(ap)
   16a7c:	7d 8f c5 00 	movq $0x00000000000000c5,-(sp)
   16a80:	00 00 00 00 
   16a84:	00 00 7e 
   16a87:	fb 0a ef 82 	calls $0xa,16b10 <_thread_sys___syscall>
   16a8b:	00 00 00 
   16a8e:	04          	ret
   16a8f:	01          	nop
   16a90:	17 ef 23 9f 	jmp 109b9 <___cerror>
   16a94:	ff ff 
   16a96:	01          	nop
   16a97:	01          	nop

00016a98 <_thread_sys_fcntl>:
   16a98:	00 00       	.word 0x0000 # Entry mask: < >
   16a9a:	bc 8f 5c 00 	chmk $0x005c
   16a9e:	1f f0       	blssu 16a90 <_thread_sys_mmap+0x2e>
   16aa0:	04          	ret
   16aa1:	01          	nop
   16aa2:	01          	nop
   16aa3:	01          	nop
   16aa4:	17 ef 0f 9f 	jmp 109b9 <___cerror>
   16aa8:	ff ff 
   16aaa:	01          	nop
   16aab:	01          	nop

00016aac <_thread_sys_fstat>:
   16aac:	00 00       	.word 0x0000 # Entry mask: < >
   16aae:	bc 35       	chmk $0x35
   16ab0:	1f f2       	blssu 16aa4 <_thread_sys_fcntl+0xc>
   16ab2:	04          	ret
   16ab3:	01          	nop

00016ab4 <err>:
   16ab4:	17 ef ff 9e 	jmp 109b9 <___cerror>
   16ab8:	ff ff 
   16aba:	01          	nop
   16abb:	01          	nop

00016abc <_thread_sys_fork>:
   16abc:	00 00       	.word 0x0000 # Entry mask: < >
   16abe:	bc 02       	chmk $0x2
   16ac0:	1f f2       	blssu 16ab4 <err>
   16ac2:	04          	ret
   16ac3:	01          	nop
   16ac4:	17 ef ef 9e 	jmp 109b9 <___cerror>
   16ac8:	ff ff 
   16aca:	01          	nop
   16acb:	01          	nop

00016acc <_thread_sys_munmap>:
   16acc:	00 00       	.word 0x0000 # Entry mask: < >
   16ace:	bc 8f 49 00 	chmk $0x0049
   16ad2:	1f f0       	blssu 16ac4 <_thread_sys_fork+0x8>
   16ad4:	04          	ret
   16ad5:	01          	nop

00016ad6 <_weak__thread_malloc_lock>:
   16ad6:	00 00       	.word 0x0000 # Entry mask: < >
   16ad8:	c2 04 5e    	subl2 $0x4,sp
   16adb:	04          	ret

00016adc <_weak__thread_malloc_unlock>:
   16adc:	00 00       	.word 0x0000 # Entry mask: < >
   16ade:	c2 04 5e    	subl2 $0x4,sp
   16ae1:	04          	ret

00016ae2 <_weak__thread_atexit_lock>:
   16ae2:	00 00       	.word 0x0000 # Entry mask: < >
   16ae4:	c2 04 5e    	subl2 $0x4,sp
   16ae7:	04          	ret

00016ae8 <_weak__thread_atexit_unlock>:
   16ae8:	00 00       	.word 0x0000 # Entry mask: < >
   16aea:	c2 04 5e    	subl2 $0x4,sp
   16aed:	04          	ret

00016aee <_weak__thread_atfork_lock>:
   16aee:	00 00       	.word 0x0000 # Entry mask: < >
   16af0:	c2 04 5e    	subl2 $0x4,sp
   16af3:	04          	ret

00016af4 <_weak__thread_atfork_unlock>:
   16af4:	00 00       	.word 0x0000 # Entry mask: < >
   16af6:	c2 04 5e    	subl2 $0x4,sp
   16af9:	04          	ret

00016afa <_weak__thread_arc4_lock>:
   16afa:	00 00       	.word 0x0000 # Entry mask: < >
   16afc:	c2 04 5e    	subl2 $0x4,sp
   16aff:	04          	ret

00016b00 <_weak__thread_arc4_unlock>:
   16b00:	00 00       	.word 0x0000 # Entry mask: < >
   16b02:	c2 04 5e    	subl2 $0x4,sp
   16b05:	04          	ret
   16b06:	01          	nop
   16b07:	01          	nop
   16b08:	17 ef ab 9e 	jmp 109b9 <___cerror>
   16b0c:	ff ff 
   16b0e:	01          	nop
   16b0f:	01          	nop

00016b10 <_thread_sys___syscall>:
   16b10:	00 00       	.word 0x0000 # Entry mask: < >
   16b12:	bc 8f c6 00 	chmk $0x00c6
   16b16:	1f f0       	blssu 16b08 <_weak__thread_arc4_unlock+0x8>
   16b18:	04          	ret
   16b19:	01          	nop

00016b1a <_weak_flockfile>:
   16b1a:	00 00       	.word 0x0000 # Entry mask: < >
   16b1c:	c2 04 5e    	subl2 $0x4,sp
   16b1f:	04          	ret

00016b20 <_weak_ftrylockfile>:
   16b20:	00 00       	.word 0x0000 # Entry mask: < >
   16b22:	c2 04 5e    	subl2 $0x4,sp
   16b25:	d4 50       	clrf r0
   16b27:	04          	ret

00016b28 <_weak_funlockfile>:
   16b28:	00 00       	.word 0x0000 # Entry mask: < >
   16b2a:	c2 04 5e    	subl2 $0x4,sp
   16b2d:	04          	ret
   16b2e:	01          	nop
   16b2f:	01          	nop
   16b30:	17 ef 83 9e 	jmp 109b9 <___cerror>
   16b34:	ff ff 
   16b36:	01          	nop
   16b37:	01          	nop

00016b38 <_thread_sys_kill>:
   16b38:	00 00       	.word 0x0000 # Entry mask: < >
   16b3a:	bc 25       	chmk $0x25
   16b3c:	1f f2       	blssu 16b30 <_weak_funlockfile+0x8>
   16b3e:	04          	ret
   16b3f:	01          	nop

00016b40 <_weak__thread_mutex_lock>:
   16b40:	00 00       	.word 0x0000 # Entry mask: < >
   16b42:	c2 04 5e    	subl2 $0x4,sp
   16b45:	04          	ret

00016b46 <_weak__thread_mutex_unlock>:
   16b46:	00 00       	.word 0x0000 # Entry mask: < >
   16b48:	c2 04 5e    	subl2 $0x4,sp
   16b4b:	04          	ret

00016b4c <_weak__thread_mutex_destroy>:
   16b4c:	00 00       	.word 0x0000 # Entry mask: < >
   16b4e:	c2 04 5e    	subl2 $0x4,sp
   16b51:	04          	ret
   16b52:	01          	nop
   16b53:	01          	nop
   16b54:	17 ef 5f 9e 	jmp 109b9 <___cerror>
   16b58:	ff ff 
   16b5a:	01          	nop
   16b5b:	01          	nop

00016b5c <_thread_sys_read>:
   16b5c:	00 00       	.word 0x0000 # Entry mask: < >
   16b5e:	bc 03       	chmk $0x3
   16b60:	1f f2       	blssu 16b54 <_weak__thread_mutex_destroy+0x8>
   16b62:	04          	ret
   16b63:	01          	nop

00016b64 <nl_langinfo>:
   16b64:	00 00       	.word 0x0000 # Entry mask: < >
   16b66:	c2 04 5e    	subl2 $0x4,sp
   16b69:	d0 ac 04 51 	movl 0x4(ap),r1
   16b6d:	d1 51 33    	cmpl r1,$0x33
   16b70:	1b 03       	blequ 16b75 <nl_langinfo+0x11>
   16b72:	31 36 01    	brw 16cab <nl_langinfo+0x147>
   16b75:	cf 51 00 33 	casel r1,$0x0,$0x33
   16b79:	68 00 75    	cvtdb $0x0 [d-float],-(r5)
   16b7c:	00          	halt
   16b7d:	82 00 8f 00 	subb2 $0x0,$0x00
   16b81:	9c 00 9c 00 	rotl $0x0,@(ap)+,$0x0
   16b85:	aa 00 aa 00 	bicw2 $0x0,0x0(r10)
   16b89:	aa 00 aa 00 	bicw2 $0x0,0x0(r10)
   16b8d:	aa 00 aa 00 	bicw2 $0x0,0x0(r10)
   16b91:	aa 00 b7 00 	bicw2 $0x0,*0x0(r7)
   16b95:	b7 00       	decw $0x0
   16b97:	b7 00       	decw $0x0
   16b99:	b7 00       	decw $0x0
   16b9b:	b7 00       	decw $0x0
   16b9d:	b7 00       	decw $0x0
   16b9f:	b7 00       	decw $0x0
   16ba1:	c4 00 c4 00 	mull2 $0x0,0xffffc400(r4)
   16ba5:	c4 
   16ba6:	00          	halt
   16ba7:	c4 00 c4 00 	mull2 $0x0,0xffffc400(r4)
   16bab:	c4 
   16bac:	00          	halt
   16bad:	c4 00 c4 00 	mull2 $0x0,0xffffc400(r4)
   16bb1:	c4 
   16bb2:	00          	halt
   16bb3:	c4 00 c4 00 	mull2 $0x0,0xffffc400(r4)
   16bb7:	c4 
   16bb8:	00          	halt
   16bb9:	d1 00 d1 00 	cmpl $0x0,*0xffffd100(r1)
   16bbd:	d1 
   16bbe:	00          	halt
   16bbf:	d1 00 d1 00 	cmpl $0x0,*0xffffd100(r1)
   16bc3:	d1 
   16bc4:	00          	halt
   16bc5:	d1 00 d1 00 	cmpl $0x0,*0xffffd100(r1)
   16bc9:	d1 
   16bca:	00          	halt
   16bcb:	d1 00 d1 00 	cmpl $0x0,*0xffffd100(r1)
   16bcf:	d1 
   16bd0:	00          	halt
   16bd1:	de 00 e6 00 	moval $0x0,0xfe00f200(r6)
   16bd5:	f2 00 fe 
   16bd8:	00          	halt
   16bd9:	06          	ldpctx
   16bda:	01          	nop
   16bdb:	12 01       	bneq 16bde <nl_langinfo+0x7a>
   16bdd:	1b 01       	blequ 16be0 <nl_langinfo+0x7c>
   16bdf:	23 01 d0 ef 	subp6 $0x1,*0x65ef(r0),(r2),$0x4,$0x0,r0
   16be3:	65 62 04 00 
   16be7:	50 
   16be8:	d0 c0 a0 00 	movl 0xa0(r0),r0
   16bec:	50 
   16bed:	04          	ret
   16bee:	d0 ef 58 62 	movl 5ce4c <_CurrentTimeLocale>,r0
   16bf2:	04 00 50 
   16bf5:	d0 c0 a4 00 	movl 0xa4(r0),r0
   16bf9:	50 
   16bfa:	04          	ret
   16bfb:	d0 ef 4b 62 	movl 5ce4c <_CurrentTimeLocale>,r0
   16bff:	04 00 50 
   16c02:	d0 c0 a8 00 	movl 0xa8(r0),r0
   16c06:	50 
   16c07:	04          	ret
   16c08:	d0 ef 3e 62 	movl 5ce4c <_CurrentTimeLocale>,r0
   16c0c:	04 00 50 
   16c0f:	d0 c0 ac 00 	movl 0xac(r0),r0
   16c13:	50 
   16c14:	04          	ret
   16c15:	d0 ef 31 62 	movl 5ce4c <_CurrentTimeLocale>,r0
   16c19:	04 00 50 
   16c1c:	d0 41 c0 88 	movl 0x88(r0)[r1],r0
   16c20:	00 50 
   16c22:	04          	ret
   16c23:	d0 ef 23 62 	movl 5ce4c <_CurrentTimeLocale>,r0
   16c27:	04 00 50 
   16c2a:	d0 41 a0 04 	movl 0x4(r0)[r1],r0
   16c2e:	50 
   16c2f:	04          	ret
   16c30:	d0 ef 16 62 	movl 5ce4c <_CurrentTimeLocale>,r0
   16c34:	04 00 50 
   16c37:	d0 41 a0 cc 	movl 0xffffffcc(r0)[r1],r0
   16c3b:	50 
   16c3c:	04          	ret
   16c3d:	d0 ef 09 62 	movl 5ce4c <_CurrentTimeLocale>,r0
   16c41:	04 00 50 
   16c44:	d0 41 a0 18 	movl 0x18(r0)[r1],r0
   16c48:	50 
   16c49:	04          	ret
   16c4a:	d0 ef fc 61 	movl 5ce4c <_CurrentTimeLocale>,r0
   16c4e:	04 00 50 
   16c51:	d0 41 a0 b8 	movl 0xffffffb8(r0)[r1],r0
   16c55:	50 
   16c56:	04          	ret
   16c57:	d0 ff eb 61 	movl *5ce48 <_CurrentNumericLocale>,r0
   16c5b:	04 00 50 
   16c5e:	04          	ret
   16c5f:	d0 ef e3 61 	movl 5ce48 <_CurrentNumericLocale>,r0
   16c63:	04 00 50 
   16c66:	d0 a0 04 50 	movl 0x4(r0),r0
   16c6a:	04          	ret
   16c6b:	d0 ef d3 61 	movl 5ce44 <_CurrentMessagesLocale>,r0
   16c6f:	04 00 50 
   16c72:	d0 a0 08 50 	movl 0x8(r0),r0
   16c76:	04          	ret
   16c77:	d0 ff c7 61 	movl *5ce44 <_CurrentMessagesLocale>,r0
   16c7b:	04 00 50 
   16c7e:	04          	ret
   16c7f:	d0 ef bf 61 	movl 5ce44 <_CurrentMessagesLocale>,r0
   16c83:	04 00 50 
   16c86:	d0 a0 0c 50 	movl 0xc(r0),r0
   16c8a:	04          	ret
   16c8b:	d0 ef b3 61 	movl 5ce44 <_CurrentMessagesLocale>,r0
   16c8f:	04 00 50 
   16c92:	11 d2       	brb 16c66 <nl_langinfo+0x102>
   16c94:	9e ef 86 43 	movab 2b020 <_DefaultTimeLocale+0x208>,r0
   16c98:	01 00 50 
   16c9b:	04          	ret
   16c9c:	d0 ef 66 61 	movl 5ce08 <_CurrentRuneLocale>,r0
   16ca0:	04 00 50 
   16ca3:	d0 c0 4c 0c 	movl 0xc4c(r0),r0
   16ca7:	50 
   16ca8:	13 ea       	beql 16c94 <nl_langinfo+0x130>
   16caa:	04          	ret
   16cab:	9e ef 6f 43 	movab 2b020 <_DefaultTimeLocale+0x208>,r0
   16caf:	01 00 50 
   16cb2:	11 f6       	brb 16caa <nl_langinfo+0x146>

00016cb4 <syslog_r>:
   16cb4:	00 00       	.word 0x0000 # Entry mask: < >
   16cb6:	c2 04 5e    	subl2 $0x4,sp
   16cb9:	9f ac 10    	pushab 0x10(ap)
   16cbc:	dd ac 0c    	pushl 0xc(ap)
   16cbf:	dd ac 08    	pushl 0x8(ap)
   16cc2:	dd ac 04    	pushl 0x4(ap)
   16cc5:	fb 04 ef 02 	calls $0x4,16cce <vsyslog_r>
   16cc9:	00 00 00 
   16ccc:	04          	ret
   16ccd:	01          	nop

00016cce <vsyslog_r>:
   16cce:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   16cd0:	c2 04 5e    	subl2 $0x4,sp
   16cd3:	d0 ac 08 56 	movl 0x8(ap),r6
   16cd7:	dd ac 10    	pushl 0x10(ap)
   16cda:	dd ac 0c    	pushl 0xc(ap)
   16cdd:	d4 7e       	clrf -(sp)
   16cdf:	dd 56       	pushl r6
   16ce1:	dd ac 04    	pushl 0x4(ap)
   16ce4:	fb 05 ef 13 	calls $0x5,16cfe <__vsyslog_r>
   16ce8:	00 00 00 
   16ceb:	d0 a6 04 57 	movl 0x4(r6),r7
   16cef:	dd 56       	pushl r6
   16cf1:	fb 01 ef b6 	calls $0x1,170ae <closelog_r>
   16cf5:	03 00 00 
   16cf8:	d0 57 a6 04 	movl r7,0x4(r6)
   16cfc:	04          	ret
   16cfd:	01          	nop

00016cfe <__vsyslog_r>:
   16cfe:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   16d00:	9e ce c4 f3 	movab 0xfffff3c4(sp),sp
   16d04:	5e 
   16d05:	d0 ac 04 56 	movl 0x4(ap),r6
   16d09:	d0 ac 10 57 	movl 0x10(ap),r7
   16d0d:	d0 ef 85 52 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   16d11:	02 00 ad f8 
   16d15:	d0 ac 08 5a 	movl 0x8(ap),r10
   16d19:	d0 ac 0c cd 	movl 0xc(ap),0xfffff3c8(fp)
   16d1d:	c8 f3 
   16d1f:	d0 ac 14 cd 	movl 0x14(ap),0xfffff3c4(fp)
   16d23:	c4 f3 
   16d25:	d4 cd d0 f3 	clrf 0xfffff3d0(fp)
   16d29:	d4 cd cc f3 	clrf 0xfffff3cc(fp)
   16d2d:	d3 56 8f 00 	bitl r6,$0xfffffc00
   16d31:	fc ff ff 
   16d34:	13 2c       	beql 16d62 <__vsyslog_r+0x64>
   16d36:	dd 56       	pushl r6
   16d38:	d5 cd c8 f3 	tstl 0xfffff3c8(fp)
   16d3c:	12 03       	bneq 16d41 <__vsyslog_r+0x43>
   16d3e:	31 32 03    	brw 17073 <__vsyslog_r+0x375>
   16d41:	9e ef d9 42 	movab 2b020 <_DefaultTimeLocale+0x208>,r0
   16d45:	01 00 50 
   16d48:	dd 50       	pushl r0
   16d4a:	9f ef 88 42 	pushab 2afd8 <_DefaultTimeLocale+0x1c0>
   16d4e:	01 00 
   16d50:	dd 5a       	pushl r10
   16d52:	dd 23       	pushl $0x23
   16d54:	fb 05 ef 59 	calls $0x5,16cb4 <syslog_r>
   16d58:	ff ff ff 
   16d5b:	ca 8f 00 fc 	bicl2 $0xfffffc00,r6
   16d5f:	ff ff 56 
   16d62:	cb 8f f8 ff 	bicl3 $0xfffffff8,r6,r0
   16d66:	ff ff 56 50 
   16d6a:	e0 50 aa 0c 	bbs r0,0xc(r10),16d8d <__vsyslog_r+0x8f>
   16d6e:	1e 
   16d6f:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   16d73:	d1 50 ef 1e 	cmpl r0,3bf98 <__guard_local>
   16d77:	52 02 00 
   16d7a:	13 10       	beql 16d8c <__vsyslog_r+0x8e>
   16d7c:	dd ad f8    	pushl 0xfffffff8(fp)
   16d7f:	9f ef 7b 42 	pushab 2b000 <_DefaultTimeLocale+0x1e8>
   16d83:	01 00 
   16d85:	fb 02 ef e0 	calls $0x2,1666c <__stack_smash_handler>
   16d89:	f8 ff ff 
   16d8c:	04          	ret
   16d8d:	fb 00 ef 34 	calls $0x0,109c8 <___errno>
   16d91:	9c ff ff 
   16d94:	d0 60 cd d4 	movl (r0),0xfffff3d4(fp)
   16d98:	f3 
   16d99:	d3 56 8f f8 	bitl r6,$0x000003f8
   16d9d:	03 00 00 
   16da0:	12 04       	bneq 16da6 <__vsyslog_r+0xa8>
   16da2:	c8 aa 08 56 	bisl2 0x8(r10),r6
   16da6:	9e cd d8 f7 	movab 0xfffff7d8(fp),r9
   16daa:	59 
   16dab:	3c 8f 00 08 	movzwl $0x0800,r11
   16daf:	5b 
   16db0:	dd 56       	pushl r6
   16db2:	9f ef 54 42 	pushab 2b00c <_DefaultTimeLocale+0x1f4>
   16db6:	01 00 
   16db8:	dd 5b       	pushl r11
   16dba:	dd 59       	pushl r9
   16dbc:	fb 04 ef 3b 	calls $0x4,19efe <snprintf>
   16dc0:	31 00 00 
   16dc3:	d5 50       	tstl r0
   16dc5:	18 03       	bgeq 16dca <__vsyslog_r+0xcc>
   16dc7:	31 a4 02    	brw 1706e <__vsyslog_r+0x370>
   16dca:	d1 50 5b    	cmpl r0,r11
   16dcd:	19 05       	blss 16dd4 <__vsyslog_r+0xd6>
   16dcf:	3c 8f ff 07 	movzwl $0x07ff,r0
   16dd3:	50 
   16dd4:	c0 50 59    	addl2 r0,r9
   16dd7:	c2 50 5b    	subl2 r0,r11
   16dda:	e1 01 6a 05 	bbc $0x1,(r10),16de3 <__vsyslog_r+0xe5>
   16dde:	d0 59 cd d0 	movl r9,0xfffff3d0(fp)
   16de2:	f3 
   16de3:	d5 cd c8 f3 	tstl 0xfffff3c8(fp)
   16de7:	13 22       	beql 16e0b <__vsyslog_r+0x10d>
   16de9:	dd 5b       	pushl r11
   16deb:	dd 59       	pushl r9
   16ded:	d0 cd c8 f3 	movl 0xfffff3c8(fp),r1
   16df1:	51 
   16df2:	fb 02 61    	calls $0x2,(r1)
   16df5:	d5 50       	tstl r0
   16df7:	18 03       	bgeq 16dfc <__vsyslog_r+0xfe>
   16df9:	31 6d 02    	brw 17069 <__vsyslog_r+0x36b>
   16dfc:	d1 50 5b    	cmpl r0,r11
   16dff:	19 04       	blss 16e05 <__vsyslog_r+0x107>
   16e01:	c3 01 5b 50 	subl3 $0x1,r11,r0
   16e05:	c0 50 59    	addl2 r0,r9
   16e08:	c2 50 5b    	subl2 r0,r11
   16e0b:	e1 05 6a 05 	bbc $0x5,(r10),16e14 <__vsyslog_r+0x116>
   16e0f:	d0 59 cd cc 	movl r9,0xfffff3cc(fp)
   16e13:	f3 
   16e14:	d5 aa 04    	tstl 0x4(r10)
   16e17:	12 08       	bneq 16e21 <__vsyslog_r+0x123>
   16e19:	d0 ef 91 51 	movl 5bfb0 <__data_start>,0x4(r10)
   16e1d:	04 00 aa 04 
   16e21:	d0 aa 04 50 	movl 0x4(r10),r0
   16e25:	13 03       	beql 16e2a <__vsyslog_r+0x12c>
   16e27:	31 0e 02    	brw 17038 <__vsyslog_r+0x33a>
   16e2a:	e9 6a 03    	blbc (r10),16e30 <__vsyslog_r+0x132>
   16e2d:	31 d4 01    	brw 17004 <__vsyslog_r+0x306>
   16e30:	d5 aa 04    	tstl 0x4(r10)
   16e33:	13 14       	beql 16e49 <__vsyslog_r+0x14b>
   16e35:	d1 5b 01    	cmpl r11,$0x1
   16e38:	15 05       	bleq 16e3f <__vsyslog_r+0x141>
   16e3a:	90 3a 89    	movb $0x3a,(r9)+
   16e3d:	d7 5b       	decl r11
   16e3f:	d1 5b 01    	cmpl r11,$0x1
   16e42:	15 05       	bleq 16e49 <__vsyslog_r+0x14b>
   16e44:	90 20 89    	movb $0x20,(r9)+
   16e47:	d7 5b       	decl r11
   16e49:	9e cd d8 f3 	movab 0xfffff3d8(fp),r8
   16e4d:	58 
   16e4e:	3c 8f 00 04 	movzwl $0x0400,r6
   16e52:	56 
   16e53:	90 67 50    	movb (r7),r0
   16e56:	13 21       	beql 16e79 <__vsyslog_r+0x17b>
   16e58:	91 50 25    	cmpb r0,$0x25
   16e5b:	12 03       	bneq 16e60 <__vsyslog_r+0x162>
   16e5d:	31 4e 01    	brw 16fae <__vsyslog_r+0x2b0>
   16e60:	91 50 25    	cmpb r0,$0x25
   16e63:	12 03       	bneq 16e68 <__vsyslog_r+0x16a>
   16e65:	31 27 01    	brw 16f8f <__vsyslog_r+0x291>
   16e68:	d1 56 01    	cmpl r6,$0x1
   16e6b:	15 05       	bleq 16e72 <__vsyslog_r+0x174>
   16e6d:	90 50 88    	movb r0,(r8)+
   16e70:	d7 56       	decl r6
   16e72:	d6 57       	incl r7
   16e74:	90 67 50    	movb (r7),r0
   16e77:	12 df       	bneq 16e58 <__vsyslog_r+0x15a>
   16e79:	94 68       	clrb (r8)
   16e7b:	dd cd c4 f3 	pushl 0xfffff3c4(fp)
   16e7f:	9f cd d8 f3 	pushab 0xfffff3d8(fp)
   16e83:	dd 5b       	pushl r11
   16e85:	dd 59       	pushl r9
   16e87:	fb 04 ef 50 	calls $0x4,170de <vsnprintf>
   16e8b:	02 00 00 
   16e8e:	d5 50       	tstl r0
   16e90:	18 03       	bgeq 16e95 <__vsyslog_r+0x197>
   16e92:	31 f5 00    	brw 16f8a <__vsyslog_r+0x28c>
   16e95:	d1 50 5b    	cmpl r0,r11
   16e98:	19 04       	blss 16e9e <__vsyslog_r+0x1a0>
   16e9a:	c3 01 5b 50 	subl3 $0x1,r11,r0
   16e9e:	c0 50 59    	addl2 r0,r9
   16ea1:	9e cd d8 f7 	movab 0xfffff7d8(fp),r0
   16ea5:	50 
   16ea6:	c3 50 59 56 	subl3 r0,r9,r6
   16eaa:	15 09       	bleq 16eb5 <__vsyslog_r+0x1b7>
   16eac:	91 a9 ff 0a 	cmpb 0xffffffff(r9),$0xa
   16eb0:	12 03       	bneq 16eb5 <__vsyslog_r+0x1b7>
   16eb2:	31 c3 00    	brw 16f78 <__vsyslog_r+0x27a>
   16eb5:	e1 05 6a 3b 	bbc $0x5,(r10),16ef4 <__vsyslog_r+0x1f6>
   16eb9:	d0 cd cc f3 	movl 0xfffff3cc(fp),0xffffffe8(fp)
   16ebd:	ad e8 
   16ebf:	9e cd d8 f7 	movab 0xfffff7d8(fp),r0
   16ec3:	50 
   16ec4:	c3 50 cd cc 	subl3 r0,0xfffff3cc(fp),r0
   16ec8:	f3 50 
   16eca:	d1 56 50    	cmpl r6,r0
   16ecd:	14 03       	bgtr 16ed2 <__vsyslog_r+0x1d4>
   16ecf:	31 a1 00    	brw 16f73 <__vsyslog_r+0x275>
   16ed2:	c3 50 56 50 	subl3 r0,r6,r0
   16ed6:	d0 50 ad ec 	movl r0,0xffffffec(fp)
   16eda:	9e ef 3f 41 	movab 2b01f <_DefaultTimeLocale+0x207>,0xfffffff0(fp)
   16ede:	01 00 ad f0 
   16ee2:	d0 01 ad f4 	movl $0x1,0xfffffff4(fp)
   16ee6:	dd 02       	pushl $0x2
   16ee8:	9f ad e8    	pushab 0xffffffe8(fp)
   16eeb:	dd 02       	pushl $0x2
   16eed:	fb 03 ef c4 	calls $0x3,19fb8 <_thread_sys_writev>
   16ef1:	30 00 00 
   16ef4:	dd 56       	pushl r6
   16ef6:	9e cd d8 f7 	movab 0xfffff7d8(fp),r7
   16efa:	57 
   16efb:	dd 57       	pushl r7
   16efd:	fb 02 ef d8 	calls $0x2,19fdc <_thread_sys_sendsyslog>
   16f01:	30 00 00 
   16f04:	d1 50 8f ff 	cmpl r0,$0xffffffff
   16f08:	ff ff ff 
   16f0b:	13 03       	beql 16f10 <__vsyslog_r+0x212>
   16f0d:	31 5f fe    	brw 16d6f <__vsyslog_r+0x71>
   16f10:	e0 01 6a 03 	bbs $0x1,(r10),16f17 <__vsyslog_r+0x219>
   16f14:	31 58 fe    	brw 16d6f <__vsyslog_r+0x71>
   16f17:	d4 7e       	clrf -(sp)
   16f19:	dd 05       	pushl $0x5
   16f1b:	9f ef f0 40 	pushab 2b011 <_DefaultTimeLocale+0x1f9>
   16f1f:	01 00 
   16f21:	fb 03 ef 80 	calls $0x3,19fa8 <_thread_sys_open>
   16f25:	30 00 00 
   16f28:	d0 50 58    	movl r0,r8
   16f2b:	18 03       	bgeq 16f30 <__vsyslog_r+0x232>
   16f2d:	31 3f fe    	brw 16d6f <__vsyslog_r+0x71>
   16f30:	d0 cd d0 f3 	movl 0xfffff3d0(fp),0xffffffd8(fp)
   16f34:	ad d8 
   16f36:	c3 57 cd d0 	subl3 r7,0xfffff3d0(fp),r0
   16f3a:	f3 50 
   16f3c:	d1 56 50    	cmpl r6,r0
   16f3f:	15 2e       	bleq 16f6f <__vsyslog_r+0x271>
   16f41:	c3 50 56 50 	subl3 r0,r6,r0
   16f45:	d0 50 ad dc 	movl r0,0xffffffdc(fp)
   16f49:	9e ef cf 40 	movab 2b01e <_DefaultTimeLocale+0x206>,0xffffffe0(fp)
   16f4d:	01 00 ad e0 
   16f51:	d0 02 ad e4 	movl $0x2,0xffffffe4(fp)
   16f55:	dd 02       	pushl $0x2
   16f57:	9f ad d8    	pushab 0xffffffd8(fp)
   16f5a:	dd 58       	pushl r8
   16f5c:	fb 03 ef 55 	calls $0x3,19fb8 <_thread_sys_writev>
   16f60:	30 00 00 
   16f63:	dd 58       	pushl r8
   16f65:	fb 01 ef 2c 	calls $0x1,10698 <_thread_sys_close>
   16f69:	97 ff ff 
   16f6c:	31 00 fe    	brw 16d6f <__vsyslog_r+0x71>
   16f6f:	d4 50       	clrf r0
   16f71:	11 d2       	brb 16f45 <__vsyslog_r+0x247>
   16f73:	d4 50       	clrf r0
   16f75:	31 5e ff    	brw 16ed6 <__vsyslog_r+0x1d8>
   16f78:	94 79       	clrb -(r9)
   16f7a:	d7 56       	decl r6
   16f7c:	14 03       	bgtr 16f81 <__vsyslog_r+0x283>
   16f7e:	31 34 ff    	brw 16eb5 <__vsyslog_r+0x1b7>
   16f81:	91 a9 ff 0a 	cmpb 0xffffffff(r9),$0xa
   16f85:	13 f1       	beql 16f78 <__vsyslog_r+0x27a>
   16f87:	31 2b ff    	brw 16eb5 <__vsyslog_r+0x1b7>
   16f8a:	d4 50       	clrf r0
   16f8c:	31 06 ff    	brw 16e95 <__vsyslog_r+0x197>
   16f8f:	91 a7 01 25 	cmpb 0x1(r7),$0x25
   16f93:	13 03       	beql 16f98 <__vsyslog_r+0x29a>
   16f95:	31 d0 fe    	brw 16e68 <__vsyslog_r+0x16a>
   16f98:	d1 56 02    	cmpl r6,$0x2
   16f9b:	14 03       	bgtr 16fa0 <__vsyslog_r+0x2a2>
   16f9d:	31 c8 fe    	brw 16e68 <__vsyslog_r+0x16a>
   16fa0:	90 50 88    	movb r0,(r8)+
   16fa3:	90 50 88    	movb r0,(r8)+
   16fa6:	d6 57       	incl r7
   16fa8:	c2 02 56    	subl2 $0x2,r6
   16fab:	31 c4 fe    	brw 16e72 <__vsyslog_r+0x174>
   16fae:	91 a7 01 8f 	cmpb 0x1(r7),$0x6d
   16fb2:	6d 
   16fb3:	13 03       	beql 16fb8 <__vsyslog_r+0x2ba>
   16fb5:	31 a8 fe    	brw 16e60 <__vsyslog_r+0x162>
   16fb8:	d6 57       	incl r7
   16fba:	d5 cd c8 f3 	tstl 0xfffff3c8(fp)
   16fbe:	13 38       	beql 16ff8 <__vsyslog_r+0x2fa>
   16fc0:	dd cd d4 f3 	pushl 0xfffff3d4(fp)
   16fc4:	fb 01 ef f1 	calls $0x1,170bc <strerror>
   16fc8:	00 00 00 
   16fcb:	dd 50       	pushl r0
   16fcd:	9f ef e8 3d 	pushab 2adbb <__tens_D2A+0x193>
   16fd1:	01 00 
   16fd3:	dd 56       	pushl r6
   16fd5:	dd 58       	pushl r8
   16fd7:	fb 04 ef 20 	calls $0x4,19efe <snprintf>
   16fdb:	2f 00 00 
   16fde:	d5 50       	tstl r0
   16fe0:	19 12       	blss 16ff4 <__vsyslog_r+0x2f6>
   16fe2:	d1 50 56    	cmpl r0,r6
   16fe5:	19 04       	blss 16feb <__vsyslog_r+0x2ed>
   16fe7:	c3 01 56 50 	subl3 $0x1,r6,r0
   16feb:	c0 50 58    	addl2 r0,r8
   16fee:	c2 50 56    	subl2 r0,r6
   16ff1:	31 7e fe    	brw 16e72 <__vsyslog_r+0x174>
   16ff4:	d4 50       	clrf r0
   16ff6:	11 ea       	brb 16fe2 <__vsyslog_r+0x2e4>
   16ff8:	dd cd d4 f3 	pushl 0xfffff3d4(fp)
   16ffc:	9f ef 1f 40 	pushab 2b021 <_DefaultTimeLocale+0x209>
   17000:	01 00 
   17002:	11 cf       	brb 16fd3 <__vsyslog_r+0x2d5>
   17004:	fb 00 ef 3d 	calls $0x0,16a48 <_thread_sys_getpid>
   17008:	fa ff ff 
   1700b:	dd 50       	pushl r0
   1700d:	9f ef 17 40 	pushab 2b02a <_DefaultTimeLocale+0x212>
   17011:	01 00 
   17013:	dd 5b       	pushl r11
   17015:	dd 59       	pushl r9
   17017:	fb 04 ef e0 	calls $0x4,19efe <snprintf>
   1701b:	2e 00 00 
   1701e:	d5 50       	tstl r0
   17020:	19 12       	blss 17034 <__vsyslog_r+0x336>
   17022:	d1 50 5b    	cmpl r0,r11
   17025:	19 04       	blss 1702b <__vsyslog_r+0x32d>
   17027:	c3 01 5b 50 	subl3 $0x1,r11,r0
   1702b:	c0 50 59    	addl2 r0,r9
   1702e:	c2 50 5b    	subl2 r0,r11
   17031:	31 fc fd    	brw 16e30 <__vsyslog_r+0x132>
   17034:	d4 50       	clrf r0
   17036:	11 ea       	brb 17022 <__vsyslog_r+0x324>
   17038:	dd 50       	pushl r0
   1703a:	9a 8f ff 7e 	movzbl $0xff,-(sp)
   1703e:	9f ef ec 3f 	pushab 2b030 <_DefaultTimeLocale+0x218>
   17042:	01 00 
   17044:	dd 5b       	pushl r11
   17046:	dd 59       	pushl r9
   17048:	fb 05 ef af 	calls $0x5,19efe <snprintf>
   1704c:	2e 00 00 
   1704f:	d5 50       	tstl r0
   17051:	19 12       	blss 17065 <__vsyslog_r+0x367>
   17053:	d1 50 5b    	cmpl r0,r11
   17056:	19 04       	blss 1705c <__vsyslog_r+0x35e>
   17058:	c3 01 5b 50 	subl3 $0x1,r11,r0
   1705c:	c0 50 59    	addl2 r0,r9
   1705f:	c2 50 5b    	subl2 r0,r11
   17062:	31 c5 fd    	brw 16e2a <__vsyslog_r+0x12c>
   17065:	d4 50       	clrf r0
   17067:	11 ea       	brb 17053 <__vsyslog_r+0x355>
   17069:	d4 50       	clrf r0
   1706b:	31 8e fd    	brw 16dfc <__vsyslog_r+0xfe>
   1706e:	d4 50       	clrf r0
   17070:	31 57 fd    	brw 16dca <__vsyslog_r+0xcc>
   17073:	9e ef 90 3f 	movab 2b009 <_DefaultTimeLocale+0x1f1>,r0
   17077:	01 00 50 
   1707a:	31 cb fc    	brw 16d48 <__vsyslog_r+0x4a>
   1707d:	01          	nop

0001707e <openlog_r>:
   1707e:	00 00       	.word 0x0000 # Entry mask: < >
   17080:	c2 04 5e    	subl2 $0x4,sp
   17083:	d0 ac 04 52 	movl 0x4(ap),r2
   17087:	d0 ac 0c 51 	movl 0xc(ap),r1
   1708b:	d0 ac 10 50 	movl 0x10(ap),r0
   1708f:	d5 52       	tstl r2
   17091:	13 04       	beql 17097 <openlog_r+0x19>
   17093:	d0 52 a0 04 	movl r2,0x4(r0)
   17097:	d0 ac 08 60 	movl 0x8(ap),(r0)
   1709b:	d5 51       	tstl r1
   1709d:	13 0d       	beql 170ac <openlog_r+0x2e>
   1709f:	d3 51 8f 07 	bitl r1,$0xfffffc07
   170a3:	fc ff ff 
   170a6:	12 04       	bneq 170ac <openlog_r+0x2e>
   170a8:	d0 51 a0 08 	movl r1,0x8(r0)
   170ac:	04          	ret
   170ad:	01          	nop

000170ae <closelog_r>:
   170ae:	00 00       	.word 0x0000 # Entry mask: < >
   170b0:	c2 04 5e    	subl2 $0x4,sp
   170b3:	d0 ac 04 50 	movl 0x4(ap),r0
   170b7:	d4 a0 04    	clrf 0x4(r0)
   170ba:	04          	ret
   170bb:	01          	nop

000170bc <strerror>:
   170bc:	00 00       	.word 0x0000 # Entry mask: < >
   170be:	c2 04 5e    	subl2 $0x4,sp
   170c1:	9a 8f ff 7e 	movzbl $0xff,-(sp)
   170c5:	9f ef 19 84 	pushab 5f4e4 <buf.0>
   170c9:	04 00 
   170cb:	dd ac 04    	pushl 0x4(ap)
   170ce:	fb 03 ef c1 	calls $0x3,1a196 <strerror_r>
   170d2:	30 00 00 
   170d5:	9e ef 09 84 	movab 5f4e4 <buf.0>,r0
   170d9:	04 00 50 
   170dc:	04          	ret
   170dd:	01          	nop

000170de <vsnprintf>:
   170de:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   170e0:	9e ce 88 fe 	movab 0xfffffe88(sp),sp
   170e4:	5e 
   170e5:	d0 ac 08 56 	movl 0x8(ap),r6
   170e9:	d0 ef a9 4e 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   170ed:	02 00 ad f8 
   170f1:	d0 ac 04 57 	movl 0x4(ap),r7
   170f5:	d0 ac 10 58 	movl 0x10(ap),r8
   170f9:	9e cd 8c fe 	movab 0xfffffe8c(fp),r0
   170fd:	50 
   170fe:	d0 50 ad d0 	movl r0,0xffffffd0(fp)
   17102:	d4 60       	clrf (r0)
   17104:	d4 a0 04    	clrf 0x4(r0)
   17107:	3c 8f 0c 01 	movzwl $0x010c,-(sp)
   1710b:	7e 
   1710c:	d4 7e       	clrf -(sp)
   1710e:	9f a0 08    	pushab 0x8(r0)
   17111:	fb 03 ef e0 	calls $0x3,168f8 <memset>
   17115:	f7 ff ff 
   17118:	d5 56       	tstl r6
   1711a:	19 5a       	blss 17176 <vsnprintf+0x98>
   1711c:	d5 56       	tstl r6
   1711e:	12 08       	bneq 17128 <vsnprintf+0x4a>
   17120:	9e cd 8b fe 	movab 0xfffffe8b(fp),r7
   17124:	57 
   17125:	d0 01 56    	movl $0x1,r6
   17128:	b2 00 ad ae 	mcomw $0x0,0xffffffae(fp)
   1712c:	b0 8f 08 02 	movw $0x0208,0xffffffac(fp)
   17130:	ad ac 
   17132:	d0 57 ad a0 	movl r7,0xffffffa0(fp)
   17136:	d0 57 ad b0 	movl r7,0xffffffb0(fp)
   1713a:	c3 01 56 50 	subl3 $0x1,r6,r0
   1713e:	d0 50 ad a8 	movl r0,0xffffffa8(fp)
   17142:	d0 50 ad b4 	movl r0,0xffffffb4(fp)
   17146:	dd 58       	pushl r8
   17148:	dd ac 0c    	pushl 0xc(ap)
   1714b:	9f ad a0    	pushab 0xffffffa0(fp)
   1714e:	fb 03 ef 51 	calls $0x3,114a6 <__vfprintf>
   17152:	a3 ff ff 
   17155:	94 bd a0    	clrb *0xffffffa0(fp)
   17158:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   1715c:	d1 51 ef 35 	cmpl r1,3bf98 <__guard_local>
   17160:	4e 02 00 
   17163:	13 10       	beql 17175 <vsnprintf+0x97>
   17165:	dd ad f8    	pushl 0xfffffff8(fp)
   17168:	9f ef c7 3e 	pushab 2b035 <_DefaultTimeLocale+0x21d>
   1716c:	01 00 
   1716e:	fb 02 ef f7 	calls $0x2,1666c <__stack_smash_handler>
   17172:	f4 ff ff 
   17175:	04          	ret
   17176:	d0 8f ff ff 	movl $0x7fffffff,r6
   1717a:	ff 7f 56 
   1717d:	11 9d       	brb 1711c <vsnprintf+0x3e>
   1717f:	01          	nop

00017180 <wrterror>:
   17180:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   17182:	9e ae 94 5e 	movab 0xffffff94(sp),sp
   17186:	d0 ef 0c 4e 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   1718a:	02 00 ad f8 
   1718e:	d0 ac 04 58 	movl 0x4(ap),r8
   17192:	d0 ac 08 5a 	movl 0x8(ap),r10
   17196:	9e ef 3b 41 	movab 2b2d7 <tau+0x3a>,r7
   1719a:	01 00 57 
   1719d:	fb 00 ef 24 	calls $0x0,109c8 <___errno>
   171a1:	98 ff ff 
   171a4:	d0 60 ad 94 	movl (r0),0xffffff94(fp)
   171a8:	d0 ef 02 4e 	movl 5bfb0 <__data_start>,0xffffffc0(fp)
   171ac:	04 00 ad c0 
   171b0:	dd ef fa 4d 	pushl 5bfb0 <__data_start>
   171b4:	04 00 
   171b6:	9e ef 66 f7 	movab 16922 <strlen>,r9
   171ba:	ff ff 59 
   171bd:	fb 01 69    	calls $0x1,(r9)
   171c0:	d0 50 ad c4 	movl r0,0xffffffc4(fp)
   171c4:	9e ad ac 56 	movab 0xffffffac(fp),r6
   171c8:	d0 56 ad c8 	movl r6,0xffffffc8(fp)
   171cc:	fb 00 ef 75 	calls $0x0,16a48 <_thread_sys_getpid>
   171d0:	f8 ff ff 
   171d3:	dd 50       	pushl r0
   171d5:	9f ef 96 3e 	pushab 2b071 <q.0+0x32>
   171d9:	01 00 
   171db:	dd 14       	pushl $0x14
   171dd:	dd 56       	pushl r6
   171df:	9e ef 19 2d 	movab 19efe <snprintf>,r11
   171e3:	00 00 5b 
   171e6:	fb 04 6b    	calls $0x4,(r11)
   171e9:	dd 56       	pushl r6
   171eb:	fb 01 69    	calls $0x1,(r9)
   171ee:	d0 50 ad cc 	movl r0,0xffffffcc(fp)
   171f2:	d0 ef 08 ae 	movl 62000 <malloc_func>,0xffffffd0(fp)
   171f6:	04 00 ad d0 
   171fa:	dd ef 00 ae 	pushl 62000 <malloc_func>
   171fe:	04 00 
   17200:	fb 01 69    	calls $0x1,(r9)
   17203:	d0 50 ad d4 	movl r0,0xffffffd4(fp)
   17207:	d0 57 ad d8 	movl r7,0xffffffd8(fp)
   1720b:	dd 57       	pushl r7
   1720d:	fb 01 69    	calls $0x1,(r9)
   17210:	d0 50 ad dc 	movl r0,0xffffffdc(fp)
   17214:	d0 58 ad e0 	movl r8,0xffffffe0(fp)
   17218:	dd 58       	pushl r8
   1721a:	fb 01 69    	calls $0x1,(r9)
   1721d:	d0 50 ad e4 	movl r0,0xffffffe4(fp)
   17221:	9e ad 98 56 	movab 0xffffff98(fp),r6
   17225:	d0 56 ad e8 	movl r6,0xffffffe8(fp)
   17229:	d5 5a       	tstl r10
   1722b:	13 63       	beql 17290 <wrterror+0x110>
   1722d:	dd 5a       	pushl r10
   1722f:	9f ef 9f 3d 	pushab 2afd4 <_DefaultTimeLocale+0x1bc>
   17233:	01 00 
   17235:	dd 14       	pushl $0x14
   17237:	dd 56       	pushl r6
   17239:	fb 04 6b    	calls $0x4,(r11)
   1723c:	dd 56       	pushl r6
   1723e:	fb 01 69    	calls $0x1,(r9)
   17241:	d0 50 ad ec 	movl r0,0xffffffec(fp)
   17245:	9e ef d4 3d 	movab 2b01f <_DefaultTimeLocale+0x207>,0xfffffff0(fp)
   17249:	01 00 ad f0 
   1724d:	d0 01 ad f4 	movl $0x1,0xfffffff4(fp)
   17251:	dd 07       	pushl $0x7
   17253:	9f ad c0    	pushab 0xffffffc0(fp)
   17256:	dd 02       	pushl $0x2
   17258:	fb 03 ef 59 	calls $0x3,19fb8 <_thread_sys_writev>
   1725c:	2d 00 00 
   1725f:	fb 00 ef 62 	calls $0x0,109c8 <___errno>
   17263:	97 ff ff 
   17266:	d0 ad 94 60 	movl 0xffffff94(fp),(r0)
   1726a:	d5 ef 94 9d 	tstl 61004 <malloc_readonly+0x4>
   1726e:	04 00 
   17270:	12 23       	bneq 17295 <wrterror+0x115>
   17272:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   17276:	d1 50 ef 1b 	cmpl r0,3bf98 <__guard_local>
   1727a:	4d 02 00 
   1727d:	13 10       	beql 1728f <wrterror+0x10f>
   1727f:	dd ad f8    	pushl 0xfffffff8(fp)
   17282:	9f ef f2 3d 	pushab 2b07a <q.0+0x3b>
   17286:	01 00 
   17288:	fb 02 ef dd 	calls $0x2,1666c <__stack_smash_handler>
   1728c:	f3 ff ff 
   1728f:	04          	ret
   17290:	d4 ad ec    	clrf 0xffffffec(fp)
   17293:	11 b0       	brb 17245 <wrterror+0xc5>
   17295:	fb 00 ef 0c 	calls $0x0,167a8 <abort>
   17299:	f5 ff ff 

0001729c <rbytes_init>:
   1729c:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   1729e:	c2 04 5e    	subl2 $0x4,sp
   172a1:	d0 ac 04 57 	movl 0x4(ap),r7
   172a5:	dd 20       	pushl $0x20
   172a7:	9e c7 48 09 	movab 0x948(r7),r6
   172ab:	56 
   172ac:	dd 56       	pushl r6
   172ae:	fb 02 ef 55 	calls $0x2,19e0a <arc4random_buf>
   172b2:	2b 00 00 
   172b5:	90 66 50    	movb (r6),r0
   172b8:	ca 8f f0 ff 	bicl2 $0xfffffff0,r0
   172bc:	ff ff 50 
   172bf:	c1 50 01 c7 	addl3 r0,$0x1,0x944(r7)
   172c3:	44 09 
   172c5:	04          	ret

000172c6 <unmap>:
   172c6:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   172c8:	c2 08 5e    	subl2 $0x8,sp
   172cb:	d0 ac 04 58 	movl 0x4(ap),r8
   172cf:	d0 ac 0c 5b 	movl 0xc(ap),r11
   172d3:	ef 0c 14 5b 	extzv $0xc,$0x14,r11,0xfffffff8(fp)
   172d7:	ad f8 
   172d9:	9e cb ff 0f 	movab 0xfff(r11),r0
   172dd:	50 
   172de:	ca 8f ff 0f 	bicl2 $0x00000fff,r0
   172e2:	00 00 50 
   172e5:	d1 5b 50    	cmpl r11,r0
   172e8:	13 0e       	beql 172f8 <unmap+0x32>
   172ea:	d4 7e       	clrf -(sp)
   172ec:	9f ef 91 3d 	pushab 2b083 <q.0+0x44>
   172f0:	01 00 
   172f2:	fb 02 cf 89 	calls $0x2,17180 <wrterror>
   172f6:	fe 
   172f7:	04          	ret
   172f8:	9e ef 2a 9d 	movab 61028 <malloc_readonly+0x28>,r6
   172fc:	04 00 56 
   172ff:	d0 66 50    	movl (r6),r0
   17302:	d1 ad f8 50 	cmpl 0xfffffff8(fp),r0
   17306:	1b 03       	blequ 1730b <unmap+0x45>
   17308:	31 69 01    	brw 17474 <unmap+0x1ae>
   1730b:	d4 59       	clrf r9
   1730d:	c2 c8 00 01 	subl2 0x100(r8),r0
   17311:	50 
   17312:	d1 ad f8 50 	cmpl 0xfffffff8(fp),r0
   17316:	1b 05       	blequ 1731d <unmap+0x57>
   17318:	c3 50 ad f8 	subl3 r0,0xfffffff8(fp),r9
   1731c:	59 
   1731d:	d1 c8 44 09 	cmpl 0x944(r8),$0x1f
   17321:	1f 
   17322:	1b 03       	blequ 17327 <unmap+0x61>
   17324:	31 43 01    	brw 1746a <unmap+0x1a4>
   17327:	c1 c8 44 09 	addl3 0x944(r8),r8,r0
   1732b:	58 50 
   1732d:	d6 c8 44 09 	incl 0x944(r8)
   17331:	9a c0 48 09 	movzbl 0x948(r0),r10
   17335:	5a 
   17336:	d4 57       	clrf r7
   17338:	d5 59       	tstl r9
   1733a:	13 34       	beql 17370 <unmap+0xaa>
   1733c:	d1 57 66    	cmpl r7,(r6)
   1733f:	1e 2f       	bcc 17370 <unmap+0xaa>
   17341:	c1 57 5a 50 	addl3 r7,r10,r0
   17345:	c3 01 ef dc 	subl3 $0x1,61028 <malloc_readonly+0x28>,r1
   17349:	9c 04 00 51 
   1734d:	d2 50 50    	mcoml r0,r0
   17350:	cb 50 51 50 	bicl3 r0,r1,r0
   17354:	7e 40 c8 04 	movaq 0x104(r8)[r0],r6
   17358:	01 56 
   1735a:	d5 66       	tstl (r6)
   1735c:	13 03       	beql 17361 <unmap+0x9b>
   1735e:	31 ca 00    	brw 1742b <unmap+0x165>
   17361:	d6 57       	incl r7
   17363:	d5 59       	tstl r9
   17365:	13 09       	beql 17370 <unmap+0xaa>
   17367:	d1 57 ef ba 	cmpl r7,61028 <malloc_readonly+0x28>
   1736b:	9c 04 00 
   1736e:	1f d1       	blssu 17341 <unmap+0x7b>
   17370:	d5 59       	tstl r9
   17372:	13 03       	beql 17377 <unmap+0xb1>
   17374:	31 a4 00    	brw 1741b <unmap+0x155>
   17377:	d4 57       	clrf r7
   17379:	9e ef a9 9c 	movab 61028 <malloc_readonly+0x28>,r3
   1737d:	04 00 53 
   17380:	d1 57 63    	cmpl r7,(r3)
   17383:	1e 23       	bcc 173a8 <unmap+0xe2>
   17385:	c1 57 5a 50 	addl3 r7,r10,r0
   17389:	d0 63 52    	movl (r3),r2
   1738c:	c3 01 52 51 	subl3 $0x1,r2,r1
   17390:	d2 50 50    	mcoml r0,r0
   17393:	cb 50 51 50 	bicl3 r0,r1,r0
   17397:	7e 40 c8 04 	movaq 0x104(r8)[r0],r6
   1739b:	01 56 
   1739d:	d5 66       	tstl (r6)
   1739f:	13 39       	beql 173da <unmap+0x114>
   173a1:	d6 57       	incl r7
   173a3:	d1 57 52    	cmpl r7,r2
   173a6:	1f dd       	blssu 17385 <unmap+0xbf>
   173a8:	9e ef 7a 9c 	movab 61028 <malloc_readonly+0x28>,r6
   173ac:	04 00 56 
   173af:	d1 57 66    	cmpl r7,(r6)
   173b2:	13 17       	beql 173cb <unmap+0x105>
   173b4:	d1 c8 00 01 	cmpl 0x100(r8),(r6)
   173b8:	66 
   173b9:	1a 01       	bgtru 173bc <unmap+0xf6>
   173bb:	04          	ret
   173bc:	d4 7e       	clrf -(sp)
   173be:	9f ef cc 3c 	pushab 2b090 <q.0+0x51>
   173c2:	01 00 
   173c4:	fb 02 cf b7 	calls $0x2,17180 <wrterror>
   173c8:	fd 
   173c9:	11 f0       	brb 173bb <unmap+0xf5>
   173cb:	d4 7e       	clrf -(sp)
   173cd:	9f ef d3 3c 	pushab 2b0a6 <q.0+0x67>
   173d1:	01 00 
   173d3:	fb 02 cf a8 	calls $0x2,17180 <wrterror>
   173d7:	fd 
   173d8:	11 da       	brb 173b4 <unmap+0xee>
   173da:	d5 ef 30 9c 	tstl 61010 <malloc_readonly+0x10>
   173de:	04 00 
   173e0:	12 29       	bneq 1740b <unmap+0x145>
   173e2:	d5 ef 24 9c 	tstl 6100c <malloc_readonly+0xc>
   173e6:	04 00 
   173e8:	12 11       	bneq 173fb <unmap+0x135>
   173ea:	d0 ac 08 66 	movl 0x8(ap),(r6)
   173ee:	d0 ad f8 a6 	movl 0xfffffff8(fp),0x4(r6)
   173f2:	04 
   173f3:	c0 ad f8 c8 	addl2 0xfffffff8(fp),0x100(r8)
   173f7:	00 01 
   173f9:	11 ad       	brb 173a8 <unmap+0xe2>
   173fb:	d4 7e       	clrf -(sp)
   173fd:	dd 5b       	pushl r11
   173ff:	dd ac 08    	pushl 0x8(ap)
   17402:	fb 03 ef 4f 	calls $0x3,16a58 <_thread_sys_mprotect>
   17406:	f6 ff ff 
   17409:	11 df       	brb 173ea <unmap+0x124>
   1740b:	dd 06       	pushl $0x6
   1740d:	dd 5b       	pushl r11
   1740f:	dd ac 08    	pushl 0x8(ap)
   17412:	fb 03 ef 3b 	calls $0x3,1a054 <_thread_sys_madvise>
   17416:	2c 00 00 
   17419:	11 c7       	brb 173e2 <unmap+0x11c>
   1741b:	d4 7e       	clrf -(sp)
   1741d:	9f ef 99 3c 	pushab 2b0bc <q.0+0x7d>
   17421:	01 00 
   17423:	fb 02 cf 58 	calls $0x2,17180 <wrterror>
   17427:	fd 
   17428:	31 4c ff    	brw 17377 <unmap+0xb1>
   1742b:	78 0c a6 04 	ashl $0xc,0x4(r6),-(sp)
   1742f:	7e 
   17430:	dd 66       	pushl (r6)
   17432:	fb 02 ef 93 	calls $0x2,16acc <_thread_sys_munmap>
   17436:	f6 ff ff 
   17439:	d5 50       	tstl r0
   1743b:	12 1e       	bneq 1745b <unmap+0x195>
   1743d:	d4 66       	clrf (r6)
   1743f:	d0 a6 04 50 	movl 0x4(r6),r0
   17443:	d1 59 50    	cmpl r9,r0
   17446:	1b 0f       	blequ 17457 <unmap+0x191>
   17448:	c2 50 59    	subl2 r0,r9
   1744b:	c2 a6 04 c8 	subl2 0x4(r6),0x100(r8)
   1744f:	00 01 
   17451:	d4 a6 04    	clrf 0x4(r6)
   17454:	31 0a ff    	brw 17361 <unmap+0x9b>
   17457:	d4 59       	clrf r9
   17459:	11 f0       	brb 1744b <unmap+0x185>
   1745b:	dd 66       	pushl (r6)
   1745d:	9f ef 70 3c 	pushab 2b0d3 <q.0+0x94>
   17461:	01 00 
   17463:	fb 02 cf 18 	calls $0x2,17180 <wrterror>
   17467:	fd 
   17468:	11 d3       	brb 1743d <unmap+0x177>
   1746a:	dd 58       	pushl r8
   1746c:	fb 01 cf 2b 	calls $0x1,1729c <rbytes_init>
   17470:	fe 
   17471:	31 b3 fe    	brw 17327 <unmap+0x61>
   17474:	dd 5b       	pushl r11
   17476:	dd ac 08    	pushl 0x8(ap)
   17479:	fb 02 ef 4c 	calls $0x2,16acc <_thread_sys_munmap>
   1747d:	f6 ff ff 
   17480:	d0 50 57    	movl r0,r7
   17483:	12 03       	bneq 17488 <unmap+0x1c2>
   17485:	31 33 ff    	brw 173bb <unmap+0xf5>
   17488:	dd ac 08    	pushl 0x8(ap)
   1748b:	9f ef 42 3c 	pushab 2b0d3 <q.0+0x94>
   1748f:	01 00 
   17491:	31 5e fe    	brw 172f2 <unmap+0x2c>

00017494 <zapcacheregion>:
   17494:	c0 07       	.word 0x07c0 # Entry mask: < r10 r9 r8 r7 r6 >
   17496:	c2 04 5e    	subl2 $0x4,sp
   17499:	d0 ac 04 59 	movl 0x4(ap),r9
   1749d:	d0 ac 08 58 	movl 0x8(ap),r8
   174a1:	d0 ac 0c 5a 	movl 0xc(ap),r10
   174a5:	d4 57       	clrf r7
   174a7:	d1 57 ef 7a 	cmpl r7,61028 <malloc_readonly+0x28>
   174ab:	9b 04 00 
   174ae:	1e 24       	bcc 174d4 <zapcacheregion+0x40>
   174b0:	9e c9 04 01 	movab 0x104(r9),r6
   174b4:	56 
   174b5:	d0 66 51    	movl (r6),r1
   174b8:	d1 51 58    	cmpl r1,r8
   174bb:	1f 09       	blssu 174c6 <zapcacheregion+0x32>
   174bd:	c1 58 5a 50 	addl3 r8,r10,r0
   174c1:	d1 51 50    	cmpl r1,r0
   174c4:	1b 0f       	blequ 174d5 <zapcacheregion+0x41>
   174c6:	d6 57       	incl r7
   174c8:	c0 08 56    	addl2 $0x8,r6
   174cb:	d1 57 ef 56 	cmpl r7,61028 <malloc_readonly+0x28>
   174cf:	9b 04 00 
   174d2:	1f e1       	blssu 174b5 <zapcacheregion+0x21>
   174d4:	04          	ret
   174d5:	78 0c a6 04 	ashl $0xc,0x4(r6),-(sp)
   174d9:	7e 
   174da:	dd 51       	pushl r1
   174dc:	fb 02 ef e9 	calls $0x2,16acc <_thread_sys_munmap>
   174e0:	f5 ff ff 
   174e3:	d5 50       	tstl r0
   174e5:	12 0d       	bneq 174f4 <zapcacheregion+0x60>
   174e7:	d4 66       	clrf (r6)
   174e9:	c2 a6 04 c9 	subl2 0x4(r6),0x100(r9)
   174ed:	00 01 
   174ef:	d4 a6 04    	clrf 0x4(r6)
   174f2:	11 d2       	brb 174c6 <zapcacheregion+0x32>
   174f4:	dd 66       	pushl (r6)
   174f6:	9f ef d7 3b 	pushab 2b0d3 <q.0+0x94>
   174fa:	01 00 
   174fc:	fb 02 cf 7f 	calls $0x2,17180 <wrterror>
   17500:	fc 
   17501:	11 e4       	brb 174e7 <zapcacheregion+0x53>
   17503:	01          	nop

00017504 <map>:
   17504:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   17506:	c2 04 5e    	subl2 $0x4,sp
   17509:	d0 ac 04 57 	movl 0x4(ap),r7
   1750d:	d0 ac 08 59 	movl 0x8(ap),r9
   17511:	d0 ac 0c 5a 	movl 0xc(ap),r10
   17515:	9c 14 5a 58 	rotl $0x14,r10,r8
   17519:	ca 8f 00 00 	bicl2 $0xfff00000,r8
   1751d:	f0 ff 58 
   17520:	d4 5b       	clrf r11
   17522:	d0 67 51    	movl (r7),r1
   17525:	cd 57 51 50 	xorl3 r7,r1,r0
   17529:	d1 ef fd 9a 	cmpl 6102c <malloc_readonly+0x2c>,r0
   1752d:	04 00 50 
   17530:	12 03       	bneq 17535 <map+0x31>
   17532:	31 4a 02    	brw 1777f <map+0x27b>
   17535:	d4 7e       	clrf -(sp)
   17537:	9f ef 9d 3b 	pushab 2b0da <q.0+0x9b>
   1753b:	01 00 
   1753d:	fb 02 cf 3e 	calls $0x2,17180 <wrterror>
   17541:	fc 
   17542:	9e ca ff 0f 	movab 0xfff(r10),r0
   17546:	50 
   17547:	ca 8f ff 0f 	bicl2 $0x00000fff,r0
   1754b:	00 00 50 
   1754e:	d1 5a 50    	cmpl r10,r0
   17551:	13 11       	beql 17564 <map+0x60>
   17553:	d4 7e       	clrf -(sp)
   17555:	9f ef 2b 3b 	pushab 2b086 <q.0+0x47>
   17559:	01 00 
   1755b:	fb 02 cf 20 	calls $0x2,17180 <wrterror>
   1755f:	fc 
   17560:	d2 00 50    	mcoml $0x0,r0
   17563:	04          	ret
   17564:	d5 59       	tstl r9
   17566:	12 03       	bneq 1756b <map+0x67>
   17568:	31 be 01    	brw 17729 <map+0x225>
   1756b:	d1 c7 44 09 	cmpl 0x944(r7),$0x1f
   1756f:	1f 
   17570:	1b 03       	blequ 17575 <map+0x71>
   17572:	31 aa 01    	brw 1771f <map+0x21b>
   17575:	c1 c7 44 09 	addl3 0x944(r7),r7,r0
   17579:	57 50 
   1757b:	d6 c7 44 09 	incl 0x944(r7)
   1757f:	9a c0 48 09 	movzbl 0x948(r0),r3
   17583:	53 
   17584:	d4 52       	clrf r2
   17586:	9e ef 9c 9a 	movab 61028 <malloc_readonly+0x28>,r1
   1758a:	04 00 51 
   1758d:	d1 52 61    	cmpl r2,(r1)
   17590:	1e 37       	bcc 175c9 <map+0xc5>
   17592:	c1 52 53 50 	addl3 r2,r3,r0
   17596:	c3 01 61 51 	subl3 $0x1,(r1),r1
   1759a:	d2 50 50    	mcoml r0,r0
   1759d:	cb 50 51 50 	bicl3 r0,r1,r0
   175a1:	7e 40 c7 04 	movaq 0x104(r7)[r0],r6
   175a5:	01 56 
   175a7:	d0 66 50    	movl (r6),r0
   175aa:	13 0f       	beql 175bb <map+0xb7>
   175ac:	d5 59       	tstl r9
   175ae:	12 03       	bneq 175b3 <map+0xaf>
   175b0:	31 fc 00    	brw 176af <map+0x1ab>
   175b3:	d1 50 59    	cmpl r0,r9
   175b6:	12 03       	bneq 175bb <map+0xb7>
   175b8:	31 f4 00    	brw 176af <map+0x1ab>
   175bb:	d6 52       	incl r2
   175bd:	9e ef 65 9a 	movab 61028 <malloc_readonly+0x28>,r1
   175c1:	04 00 51 
   175c4:	d1 52 61    	cmpl r2,(r1)
   175c7:	1f c9       	blssu 17592 <map+0x8e>
   175c9:	d5 5b       	tstl r11
   175cb:	13 75       	beql 17642 <map+0x13e>
   175cd:	d0 5b 56    	movl r11,r6
   175d0:	d0 6b 59    	movl (r11),r9
   175d3:	78 0c 58 50 	ashl $0xc,r8,r0
   175d7:	c1 59 50 6b 	addl3 r9,r0,(r11)
   175db:	9e ef 2b 9a 	movab 6100c <malloc_readonly+0xc>,r11
   175df:	04 00 5b 
   175e2:	d5 6b       	tstl (r11)
   175e4:	12 4d       	bneq 17633 <map+0x12f>
   175e6:	d5 ef 24 9a 	tstl 61010 <malloc_readonly+0x10>
   175ea:	04 00 
   175ec:	12 36       	bneq 17624 <map+0x120>
   175ee:	c2 58 a6 04 	subl2 r8,0x4(r6)
   175f2:	c2 58 c7 00 	subl2 r8,0x100(r7)
   175f6:	01 
   175f7:	d5 ac 10    	tstl 0x10(ap)
   175fa:	12 22       	bneq 1761e <map+0x11a>
   175fc:	d1 ef 12 9a 	cmpl 61014 <malloc_readonly+0x14>,$0x2
   17600:	04 00 02 
   17603:	13 04       	beql 17609 <map+0x105>
   17605:	d0 59 50    	movl r9,r0
   17608:	04          	ret
   17609:	d5 6b       	tstl (r11)
   1760b:	13 f8       	beql 17605 <map+0x101>
   1760d:	dd 5a       	pushl r10
   1760f:	9a 8f df 7e 	movzbl $0xdf,-(sp)
   17613:	dd 59       	pushl r9
   17615:	fb 03 ef dc 	calls $0x3,168f8 <memset>
   17619:	f2 ff ff 
   1761c:	11 e7       	brb 17605 <map+0x101>
   1761e:	dd 5a       	pushl r10
   17620:	d4 7e       	clrf -(sp)
   17622:	11 ef       	brb 17613 <map+0x10f>
   17624:	d4 7e       	clrf -(sp)
   17626:	dd 5a       	pushl r10
   17628:	dd 59       	pushl r9
   1762a:	fb 03 ef 23 	calls $0x3,1a054 <_thread_sys_madvise>
   1762e:	2a 00 00 
   17631:	11 bb       	brb 175ee <map+0xea>
   17633:	dd 03       	pushl $0x3
   17635:	dd 5a       	pushl r10
   17637:	dd 59       	pushl r9
   17639:	fb 03 ef 18 	calls $0x3,16a58 <_thread_sys_mprotect>
   1763d:	f4 ff ff 
   17640:	11 a4       	brb 175e6 <map+0xe2>
   17642:	d5 59       	tstl r9
   17644:	13 03       	beql 17649 <map+0x145>
   17646:	31 17 ff    	brw 17560 <map+0x5c>
   17649:	d1 c7 00 01 	cmpl 0x100(r7),61028 <malloc_readonly+0x28>
   1764d:	ef d6 99 04 
   17651:	00 
   17652:	1a 4c       	bgtru 176a0 <map+0x19c>
   17654:	d5 ef 8a 4a 	tstl 5c0e4 <__isthreaded>
   17658:	04 00 
   1765a:	12 35       	bneq 17691 <map+0x18d>
   1765c:	7c 7e       	clrd -(sp)
   1765e:	d2 00 7e    	mcoml $0x0,-(sp)
   17661:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   17665:	7e 
   17666:	dd 03       	pushl $0x3
   17668:	dd 5a       	pushl r10
   1766a:	d4 7e       	clrf -(sp)
   1766c:	fb 07 ef ef 	calls $0x7,16a62 <_thread_sys_mmap>
   17670:	f3 ff ff 
   17673:	d0 50 59    	movl r0,r9
   17676:	d5 ef 68 4a 	tstl 5c0e4 <__isthreaded>
   1767a:	04 00 
   1767c:	12 04       	bneq 17682 <map+0x17e>
   1767e:	d0 59 50    	movl r9,r0
   17681:	04          	ret
   17682:	fb 00 ef 4d 	calls $0x0,16ad6 <_weak__thread_malloc_lock>
   17686:	f4 ff ff 
   17689:	d6 ef 75 a9 	incl 62004 <malloc_active>
   1768d:	04 00 
   1768f:	11 ed       	brb 1767e <map+0x17a>
   17691:	d7 ef 6d a9 	decl 62004 <malloc_active>
   17695:	04 00 
   17697:	fb 00 ef 3e 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   1769b:	f4 ff ff 
   1769e:	11 bc       	brb 1765c <map+0x158>
   176a0:	d4 7e       	clrf -(sp)
   176a2:	9f ef 4a 3a 	pushab 2b0f2 <q.0+0xb3>
   176a6:	01 00 
   176a8:	fb 02 cf d3 	calls $0x2,17180 <wrterror>
   176ac:	fa 
   176ad:	11 a5       	brb 17654 <map+0x150>
   176af:	d0 a6 04 51 	movl 0x4(r6),r1
   176b3:	d1 51 58    	cmpl r1,r8
   176b6:	13 0b       	beql 176c3 <map+0x1bf>
   176b8:	1a 03       	bgtru 176bd <map+0x1b9>
   176ba:	31 fe fe    	brw 175bb <map+0xb7>
   176bd:	d0 56 5b    	movl r6,r11
   176c0:	31 f8 fe    	brw 175bb <map+0xb7>
   176c3:	d0 50 59    	movl r0,r9
   176c6:	d4 66       	clrf (r6)
   176c8:	d4 a6 04    	clrf 0x4(r6)
   176cb:	c2 58 c7 00 	subl2 r8,0x100(r7)
   176cf:	01 
   176d0:	9e ef 36 99 	movab 6100c <malloc_readonly+0xc>,r6
   176d4:	04 00 56 
   176d7:	d5 66       	tstl (r6)
   176d9:	12 35       	bneq 17710 <map+0x20c>
   176db:	d5 ef 2f 99 	tstl 61010 <malloc_readonly+0x10>
   176df:	04 00 
   176e1:	12 1e       	bneq 17701 <map+0x1fd>
   176e3:	d5 ac 10    	tstl 0x10(ap)
   176e6:	13 03       	beql 176eb <map+0x1e7>
   176e8:	31 33 ff    	brw 1761e <map+0x11a>
   176eb:	d1 ef 23 99 	cmpl 61014 <malloc_readonly+0x14>,$0x2
   176ef:	04 00 02 
   176f2:	13 03       	beql 176f7 <map+0x1f3>
   176f4:	31 0e ff    	brw 17605 <map+0x101>
   176f7:	d5 66       	tstl (r6)
   176f9:	12 03       	bneq 176fe <map+0x1fa>
   176fb:	31 07 ff    	brw 17605 <map+0x101>
   176fe:	31 0c ff    	brw 1760d <map+0x109>
   17701:	d4 7e       	clrf -(sp)
   17703:	dd 5a       	pushl r10
   17705:	dd 59       	pushl r9
   17707:	fb 03 ef 46 	calls $0x3,1a054 <_thread_sys_madvise>
   1770b:	29 00 00 
   1770e:	11 d3       	brb 176e3 <map+0x1df>
   17710:	dd 03       	pushl $0x3
   17712:	dd 5a       	pushl r10
   17714:	dd 50       	pushl r0
   17716:	fb 03 ef 3b 	calls $0x3,16a58 <_thread_sys_mprotect>
   1771a:	f3 ff ff 
   1771d:	11 bc       	brb 176db <map+0x1d7>
   1771f:	dd 57       	pushl r7
   17721:	fb 01 cf 76 	calls $0x1,1729c <rbytes_init>
   17725:	fb 
   17726:	31 4c fe    	brw 17575 <map+0x71>
   17729:	d1 58 c7 00 	cmpl r8,0x100(r7)
   1772d:	01 
   1772e:	1a 03       	bgtru 17733 <map+0x22f>
   17730:	31 38 fe    	brw 1756b <map+0x67>
   17733:	d5 ef ab 49 	tstl 5c0e4 <__isthreaded>
   17737:	04 00 
   17739:	12 35       	bneq 17770 <map+0x26c>
   1773b:	7c 7e       	clrd -(sp)
   1773d:	d2 00 7e    	mcoml $0x0,-(sp)
   17740:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   17744:	7e 
   17745:	dd 03       	pushl $0x3
   17747:	dd 5a       	pushl r10
   17749:	d4 7e       	clrf -(sp)
   1774b:	fb 07 ef 10 	calls $0x7,16a62 <_thread_sys_mmap>
   1774f:	f3 ff ff 
   17752:	d0 50 59    	movl r0,r9
   17755:	d5 ef 89 49 	tstl 5c0e4 <__isthreaded>
   17759:	04 00 
   1775b:	12 03       	bneq 17760 <map+0x25c>
   1775d:	31 a5 fe    	brw 17605 <map+0x101>
   17760:	fb 00 ef 6f 	calls $0x0,16ad6 <_weak__thread_malloc_lock>
   17764:	f3 ff ff 
   17767:	d6 ef 97 a8 	incl 62004 <malloc_active>
   1776b:	04 00 
   1776d:	31 95 fe    	brw 17605 <map+0x101>
   17770:	d7 ef 8e a8 	decl 62004 <malloc_active>
   17774:	04 00 
   17776:	fb 00 ef 5f 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   1777a:	f3 ff ff 
   1777d:	11 bc       	brb 1773b <map+0x237>
   1777f:	d2 c7 6c 09 	mcoml 0x96c(r7),r0
   17783:	50 
   17784:	d1 51 50    	cmpl r1,r0
   17787:	13 03       	beql 1778c <map+0x288>
   17789:	31 a9 fd    	brw 17535 <map+0x31>
   1778c:	31 b3 fd    	brw 17542 <map+0x3e>
   1778f:	01          	nop

00017790 <omalloc_init>:
   17790:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   17792:	9e ae b8 5e 	movab 0xffffffb8(sp),sp
   17796:	d0 ef fc 47 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   1779a:	02 00 ad f8 
   1779e:	d0 ac 04 59 	movl 0x4(ap),r9
   177a2:	d0 01 ef 5b 	movl $0x1,61004 <malloc_readonly+0x4>
   177a6:	98 04 00 
   177a9:	d0 01 ef 64 	movl $0x1,61014 <malloc_readonly+0x14>
   177ad:	98 04 00 
   177b0:	d0 01 ef 61 	movl $0x1,61018 <malloc_readonly+0x18>
   177b4:	98 04 00 
   177b7:	9a 8f 40 ef 	movzbl $0x40,61028 <malloc_readonly+0x28>
   177bb:	69 98 04 00 
   177bf:	d4 58       	clrf r8
   177c1:	d1 58 01    	cmpl r8,$0x1
   177c4:	12 03       	bneq 177c9 <omalloc_init+0x39>
   177c6:	31 51 03    	brw 17b1a <omalloc_init+0x38a>
   177c9:	14 03       	bgtr 177ce <omalloc_init+0x3e>
   177cb:	31 20 03    	brw 17aee <omalloc_init+0x35e>
   177ce:	d1 58 02    	cmpl r8,$0x2
   177d1:	12 03       	bneq 177d6 <omalloc_init+0x46>
   177d3:	31 0e 03    	brw 17ae4 <omalloc_init+0x354>
   177d6:	d4 57       	clrf r7
   177d8:	d5 57       	tstl r7
   177da:	12 03       	bneq 177df <omalloc_init+0x4f>
   177dc:	31 ba 00    	brw 17899 <omalloc_init+0x109>
   177df:	95 67       	tstb (r7)
   177e1:	12 03       	bneq 177e6 <omalloc_init+0x56>
   177e3:	31 b3 00    	brw 17899 <omalloc_init+0x109>
   177e6:	98 67 50    	cvtbl (r7),r0
   177e9:	c2 3c 50    	subl2 $0x3c,r0
   177ec:	d1 50 3c    	cmpl r0,$0x3c
   177ef:	1b 03       	blequ 177f4 <omalloc_init+0x64>
   177f1:	31 d3 02    	brw 17ac7 <omalloc_init+0x337>
   177f4:	cf 50 00 3c 	casel r0,$0x0,$0x3c
   177f8:	d9 01 cf 02 	sbwc $0x1,1f1ff <__fini+0x48b5>
   177fc:	7a 
   177fd:	00          	halt
   177fe:	cf 02 cf 02 	casel $0x2,16c05 <nl_langinfo+0xa1>,$0x1
   17802:	f4 01 
   17804:	cf 02 cf 02 	casel $0x2,1470b <__quorem_D2A+0x21>,$0x2
   17808:	cf 02 
   1780a:	cf 02 fe 01 	casel $0x2,*0x1b020f01(sp),$0x2
   1780e:	0f 02 1b 02 
   17812:	cf 02 25 02 	casel $0x2,$0x25,$0x2
   17816:	cf 02 cf 02 	casel $0x2,1471d <__quorem_D2A+0x33>,$0x2
   1781a:	cf 02 
   1781c:	96 00       	incb $0x0
   1781e:	cf 02 2f 02 	casel $0x2,$0x2f,$0x2
   17822:	cf 02 39 02 	casel $0x2,$0x39,$0x2
   17826:	43 02 cf 02 	subf3 $0x2 [f-float],17d2d <insert+0x25>,$0x2 [f-float]
   1782a:	05 02 
   1782c:	cf 02 cf 02 	casel $0x2,1db33 <__fini+0x31e9>,$0x2
   17830:	63 02 
   17832:	cf 02 cf 02 	casel $0x2,14739 <__quorem_D2A+0x4f>,$0x2
   17836:	cf 02 
   17838:	cf 02 cf 02 	casel $0x2,1473f <__quorem_D2A+0x55>,$0x2
   1783c:	cf 02 
   1783e:	cf 02 cf 02 	casel $0x2,1e545 <__fini+0x3bfb>,$0x2
   17842:	6d 02 
   17844:	cf 02 cf 02 	casel $0x2,1474b <__quorem_D2A+0x61>,$0x2
   17848:	cf 02 
   1784a:	cf 02 76 02 	casel $0x2,-(r6),$0x2
   1784e:	85 02 8e 02 	mulb3 $0x2,(sp)+,$0x2
   17852:	cf 02 97 02 	casel $0x2,@(r7)+,$0x2
   17856:	cf 02 cf 02 	casel $0x2,1475d <__quorem_D2A+0x73>,$0x2
   1785a:	cf 02 
   1785c:	96 00       	incb $0x0
   1785e:	cf 02 a0 02 	casel $0x2,0x2(r0),12167 <__vfprintf+0xcc1>
   17862:	cf 02 a9 
   17865:	02          	rei
   17866:	b2 02 cf 02 	mcomw $0x2,1f46d <__fini+0x4b23>
   1786a:	7c 
   1786b:	02          	rei
   1786c:	cf 02 cf 02 	casel $0x2,15b73 <__qdivrem+0x2d7>,$0x2
   17870:	e3 02 
   17872:	9e ef b0 97 	movab 61028 <malloc_readonly+0x28>,r1
   17876:	04 00 51 
   17879:	78 01 61 50 	ashl $0x1,(r1),r0
   1787d:	d0 50 61    	movl r0,(r1)
   17880:	d1 50 8f 00 	cmpl r0,$0x00000100
   17884:	01 00 00 
   17887:	1b 05       	blequ 1788e <omalloc_init+0xfe>
   17889:	3c 8f 00 01 	movzwl $0x0100,(r1)
   1788d:	61 
   1788e:	d6 57       	incl r7
   17890:	13 07       	beql 17899 <omalloc_init+0x109>
   17892:	95 67       	tstb (r7)
   17894:	13 03       	beql 17899 <omalloc_init+0x109>
   17896:	31 4d ff    	brw 177e6 <omalloc_init+0x56>
   17899:	f3 02 58 02 	aobleq $0x2,r8,1789f <omalloc_init+0x10f>
   1789d:	11 03       	brb 178a2 <omalloc_init+0x112>
   1789f:	31 1f ff    	brw 177c1 <omalloc_init+0x31>
   178a2:	fb 00 ef d1 	calls $0x0,19d7a <arc4random>
   178a6:	24 00 00 
   178a9:	d0 50 ef 7c 	movl r0,6102c <malloc_readonly+0x2c>
   178ad:	97 04 00 
   178b0:	13 f0       	beql 178a2 <omalloc_init+0x112>
   178b2:	7c 7e       	clrd -(sp)
   178b4:	d2 00 7e    	mcoml $0x0,-(sp)
   178b7:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   178bb:	7e 
   178bc:	dd 03       	pushl $0x3
   178be:	3c 8f 00 30 	movzwl $0x3000,-(sp)
   178c2:	7e 
   178c3:	d4 7e       	clrf -(sp)
   178c5:	9e ef 97 f1 	movab 16a62 <_thread_sys_mmap>,r8
   178c9:	ff ff 58 
   178cc:	fb 07 68    	calls $0x7,(r8)
   178cf:	d0 50 57    	movl r0,r7
   178d2:	d1 50 8f ff 	cmpl r0,$0xffffffff
   178d6:	ff ff ff 
   178d9:	12 03       	bneq 178de <omalloc_init+0x14e>
   178db:	31 aa 00    	brw 17988 <omalloc_init+0x1f8>
   178de:	d4 7e       	clrf -(sp)
   178e0:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   178e4:	7e 
   178e5:	dd 50       	pushl r0
   178e7:	9e ef 6b f1 	movab 16a58 <_thread_sys_mprotect>,r6
   178eb:	ff ff 56 
   178ee:	fb 03 66    	calls $0x3,(r6)
   178f1:	d4 7e       	clrf -(sp)
   178f3:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   178f7:	7e 
   178f8:	9f c7 00 20 	pushab 0x2000(r7)
   178fc:	fb 03 66    	calls $0x3,(r6)
   178ff:	9a 8f 69 7e 	movzbl $0x69,-(sp)
   17903:	fb 01 ef 14 	calls $0x1,1911e <arc4random_uniform>
   17907:	18 00 00 
   1790a:	78 04 50 50 	ashl $0x4,r0,r0
   1790e:	9e 47 c0 00 	movab 0x1000(r0)[r7],r6
   17912:	10 56 
   17914:	dd 56       	pushl r6
   17916:	fb 01 cf 81 	calls $0x1,1729c <rbytes_init>
   1791a:	f9 
   1791b:	3c 8f 00 02 	movzwl $0x0200,0x8(r6)
   1791f:	a6 08 
   17921:	3c 8f 00 02 	movzwl $0x0200,0xc(r6)
   17925:	a6 0c 
   17927:	7c 7e       	clrd -(sp)
   17929:	d2 00 7e    	mcoml $0x0,-(sp)
   1792c:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   17930:	7e 
   17931:	dd 03       	pushl $0x3
   17933:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   17937:	7e 
   17938:	d4 7e       	clrf -(sp)
   1793a:	fb 07 68    	calls $0x7,(r8)
   1793d:	d0 50 a6 04 	movl r0,0x4(r6)
   17941:	d1 50 8f ff 	cmpl r0,$0xffffffff
   17945:	ff ff ff 
   17948:	13 72       	beql 179bc <omalloc_init+0x22c>
   1794a:	d4 58       	clrf r8
   1794c:	d0 56 52    	movl r6,r2
   1794f:	d4 48 a6 10 	clrf 0x10(r6)[r8]
   17953:	d0 03 50    	movl $0x3,r0
   17956:	9e a2 40 51 	movab 0x40(r2),r1
   1795a:	d4 81       	clrf (r1)+
   1795c:	f4 50 fb    	sobgeq r0,1795a <omalloc_init+0x1ca>
   1795f:	c0 10 52    	addl2 $0x10,r2
   17962:	f3 0b 58 e9 	aobleq $0xb,r8,1794f <omalloc_init+0x1bf>
   17966:	cd 56 ef bf 	xorl3 r6,6102c <malloc_readonly+0x2c>,r0
   1796a:	96 04 00 50 
   1796e:	d0 50 66    	movl r0,(r6)
   17971:	d2 50 c6 6c 	mcoml r0,0x96c(r6)
   17975:	09 
   17976:	d0 56 69    	movl r6,(r9)
   17979:	d3 8f 00 10 	bitl $0x00061000,$0x00000fff
   1797d:	06 00 8f ff 
   17981:	0f 00 00 
   17984:	13 20       	beql 179a6 <omalloc_init+0x216>
   17986:	d4 50       	clrf r0
   17988:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   1798c:	d1 51 ef 05 	cmpl r1,3bf98 <__guard_local>
   17990:	46 02 00 
   17993:	13 10       	beql 179a5 <omalloc_init+0x215>
   17995:	dd ad f8    	pushl 0xfffffff8(fp)
   17998:	9f ef 61 37 	pushab 2b0ff <q.0+0xc0>
   1799c:	01 00 
   1799e:	fb 02 ef c7 	calls $0x2,1666c <__stack_smash_handler>
   179a2:	ec ff ff 
   179a5:	04          	ret
   179a6:	dd 01       	pushl $0x1
   179a8:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   179ac:	7e 
   179ad:	9f ef 4d 96 	pushab 61000 <malloc_readonly>
   179b1:	04 00 
   179b3:	fb 03 ef 9e 	calls $0x3,16a58 <_thread_sys_mprotect>
   179b7:	f0 ff ff 
   179ba:	11 ca       	brb 17986 <omalloc_init+0x1f6>
   179bc:	d4 7e       	clrf -(sp)
   179be:	9f ef 48 37 	pushab 2b10c <q.0+0xcd>
   179c2:	01 00 
   179c4:	fb 02 cf b7 	calls $0x2,17180 <wrterror>
   179c8:	f7 
   179c9:	d4 a6 08    	clrf 0x8(r6)
   179cc:	d0 01 50    	movl $0x1,r0
   179cf:	11 b7       	brb 17988 <omalloc_init+0x1f8>
   179d1:	9e ef 51 96 	movab 61028 <malloc_readonly+0x28>,r1
   179d5:	04 00 51 
   179d8:	d0 61 50    	movl (r1),r0
   179db:	9c 1f 50 50 	rotl $0x1f,r0,r0
   179df:	ca 8f 00 00 	bicl2 $0x80000000,r0
   179e3:	00 80 50 
   179e6:	d0 50 61    	movl r0,(r1)
   179e9:	31 a2 fe    	brw 1788e <omalloc_init+0xfe>
   179ec:	d0 01 ef 11 	movl $0x1,61004 <malloc_readonly+0x4>
   179f0:	96 04 00 
   179f3:	31 98 fe    	brw 1788e <omalloc_init+0xfe>
   179f6:	d0 01 ef 0b 	movl $0x1,61008 <malloc_readonly+0x8>
   179fa:	96 04 00 
   179fd:	d0 01 ef 08 	movl $0x1,6100c <malloc_readonly+0xc>
   17a01:	96 04 00 
   17a04:	31 87 fe    	brw 1788e <omalloc_init+0xfe>
   17a07:	3c 8f 00 10 	movzwl $0x1000,61024 <malloc_readonly+0x24>
   17a0b:	ef 14 96 04 
   17a0f:	00 
   17a10:	31 7b fe    	brw 1788e <omalloc_init+0xfe>
   17a13:	d0 01 ef f6 	movl $0x1,61010 <malloc_readonly+0x10>
   17a17:	95 04 00 
   17a1a:	31 71 fe    	brw 1788e <omalloc_init+0xfe>
   17a1d:	d0 02 ef f0 	movl $0x2,61014 <malloc_readonly+0x14>
   17a21:	95 04 00 
   17a24:	31 67 fe    	brw 1788e <omalloc_init+0xfe>
   17a27:	d0 01 ef ea 	movl $0x1,61018 <malloc_readonly+0x18>
   17a2b:	95 04 00 
   17a2e:	31 5d fe    	brw 1788e <omalloc_init+0xfe>
   17a31:	d0 01 ef e4 	movl $0x1,6101c <malloc_readonly+0x1c>
   17a35:	95 04 00 
   17a38:	31 53 fe    	brw 1788e <omalloc_init+0xfe>
   17a3b:	d0 01 ef ca 	movl $0x1,6100c <malloc_readonly+0xc>
   17a3f:	95 04 00 
   17a42:	d0 02 ef cb 	movl $0x2,61014 <malloc_readonly+0x14>
   17a46:	95 04 00 
   17a49:	3c 8f 00 10 	movzwl $0x1000,61024 <malloc_readonly+0x24>
   17a4d:	ef d2 95 04 
   17a51:	00 
   17a52:	d4 ef d0 95 	clrf 61028 <malloc_readonly+0x28>
   17a56:	04 00 
   17a58:	31 33 fe    	brw 1788e <omalloc_init+0xfe>
   17a5b:	d0 01 ef be 	movl $0x1,61020 <malloc_readonly+0x20>
   17a5f:	95 04 00 
   17a62:	31 29 fe    	brw 1788e <omalloc_init+0xfe>
   17a65:	d4 ef 99 95 	clrf 61004 <malloc_readonly+0x4>
   17a69:	04 00 
   17a6b:	31 20 fe    	brw 1788e <omalloc_init+0xfe>
   17a6e:	d4 ef 94 95 	clrf 61008 <malloc_readonly+0x8>
   17a72:	04 00 
   17a74:	d4 ef 92 95 	clrf 6100c <malloc_readonly+0xc>
   17a78:	04 00 
   17a7a:	31 11 fe    	brw 1788e <omalloc_init+0xfe>
   17a7d:	d4 ef a1 95 	clrf 61024 <malloc_readonly+0x24>
   17a81:	04 00 
   17a83:	31 08 fe    	brw 1788e <omalloc_init+0xfe>
   17a86:	d4 ef 84 95 	clrf 61010 <malloc_readonly+0x10>
   17a8a:	04 00 
   17a8c:	31 ff fd    	brw 1788e <omalloc_init+0xfe>
   17a8f:	d4 ef 7f 95 	clrf 61014 <malloc_readonly+0x14>
   17a93:	04 00 
   17a95:	31 f6 fd    	brw 1788e <omalloc_init+0xfe>
   17a98:	d4 ef 7a 95 	clrf 61018 <malloc_readonly+0x18>
   17a9c:	04 00 
   17a9e:	31 ed fd    	brw 1788e <omalloc_init+0xfe>
   17aa1:	d4 ef 75 95 	clrf 6101c <malloc_readonly+0x1c>
   17aa5:	04 00 
   17aa7:	31 e4 fd    	brw 1788e <omalloc_init+0xfe>
   17aaa:	d4 ef 64 95 	clrf 61014 <malloc_readonly+0x14>
   17aae:	04 00 
   17ab0:	d4 ef 56 95 	clrf 6100c <malloc_readonly+0xc>
   17ab4:	04 00 
   17ab6:	d4 ef 68 95 	clrf 61024 <malloc_readonly+0x24>
   17aba:	04 00 
   17abc:	9a 8f 40 ef 	movzbl $0x40,61028 <malloc_readonly+0x28>
   17ac0:	64 95 04 00 
   17ac4:	31 c7 fd    	brw 1788e <omalloc_init+0xfe>
   17ac7:	dd 31       	pushl $0x31
   17ac9:	9f ef 70 35 	pushab 2b03f <q.0>
   17acd:	01 00 
   17acf:	dd 02       	pushl $0x2
   17ad1:	fb 03 ef 18 	calls $0x3,169f0 <_thread_sys_write>
   17ad5:	ef ff ff 
   17ad8:	31 b3 fd    	brw 1788e <omalloc_init+0xfe>
   17adb:	d4 ef 3f 95 	clrf 61020 <malloc_readonly+0x20>
   17adf:	04 00 
   17ae1:	31 aa fd    	brw 1788e <omalloc_init+0xfe>
   17ae4:	d0 ef 76 a9 	movl 62460 <malloc_options>,r7
   17ae8:	04 00 57 
   17aeb:	31 ea fc    	brw 177d8 <omalloc_init+0x48>
   17aee:	d5 58       	tstl r8
   17af0:	13 03       	beql 17af5 <omalloc_init+0x365>
   17af2:	31 e1 fc    	brw 177d6 <omalloc_init+0x46>
   17af5:	dd 3f       	pushl $0x3f
   17af7:	9e ad b8 56 	movab 0xffffffb8(fp),r6
   17afb:	dd 56       	pushl r6
   17afd:	9f ef 21 36 	pushab 2b124 <q.0+0xe5>
   17b01:	01 00 
   17b03:	fb 03 ef c2 	calls $0x3,19fcc <_thread_sys_readlink>
   17b07:	24 00 00 
   17b0a:	d5 50       	tstl r0
   17b0c:	14 03       	bgtr 17b11 <omalloc_init+0x381>
   17b0e:	31 88 fd    	brw 17899 <omalloc_init+0x109>
   17b11:	94 46 60    	clrb (r0)[r6]
   17b14:	d0 56 57    	movl r6,r7
   17b17:	31 be fc    	brw 177d8 <omalloc_init+0x48>
   17b1a:	fb 00 ef 0f 	calls $0x0,1a030 <_thread_sys_issetugid>
   17b1e:	25 00 00 
   17b21:	d5 50       	tstl r0
   17b23:	13 03       	beql 17b28 <omalloc_init+0x398>
   17b25:	31 71 fd    	brw 17899 <omalloc_init+0x109>
   17b28:	9f ef 07 36 	pushab 2b135 <q.0+0xf6>
   17b2c:	01 00 
   17b2e:	fb 01 ef 8b 	calls $0x1,191c0 <getenv>
   17b32:	16 00 00 
   17b35:	d0 50 57    	movl r0,r7
   17b38:	31 9d fc    	brw 177d8 <omalloc_init+0x48>
   17b3b:	01          	nop

00017b3c <omalloc_grow>:
   17b3c:	c0 07       	.word 0x07c0 # Entry mask: < r10 r9 r8 r7 r6 >
   17b3e:	c2 04 5e    	subl2 $0x4,sp
   17b41:	d0 ac 04 57 	movl 0x4(ap),r7
   17b45:	d0 a7 08 50 	movl 0x8(r7),r0
   17b49:	d1 50 8f ff 	cmpl r0,$0x0fffffff
   17b4d:	ff ff 0f 
   17b50:	1b 04       	blequ 17b56 <omalloc_grow+0x1a>
   17b52:	d0 01 50    	movl $0x1,r0
   17b55:	04          	ret
   17b56:	c1 50 50 5a 	addl3 r0,r0,r10
   17b5a:	7e 4a 9f 00 	movaq *0x0[r10],r9
   17b5e:	00 00 00 59 
   17b62:	c3 01 5a 58 	subl3 $0x1,r10,r8
   17b66:	7c 7e       	clrd -(sp)
   17b68:	d2 00 7e    	mcoml $0x0,-(sp)
   17b6b:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   17b6f:	7e 
   17b70:	dd 03       	pushl $0x3
   17b72:	dd 59       	pushl r9
   17b74:	d4 7e       	clrf -(sp)
   17b76:	fb 07 ef e5 	calls $0x7,16a62 <_thread_sys_mmap>
   17b7a:	ee ff ff 
   17b7d:	d0 50 56    	movl r0,r6
   17b80:	d1 50 8f ff 	cmpl r0,$0xffffffff
   17b84:	ff ff ff 
   17b87:	13 c9       	beql 17b52 <omalloc_grow+0x16>
   17b89:	dd 59       	pushl r9
   17b8b:	d4 7e       	clrf -(sp)
   17b8d:	dd 50       	pushl r0
   17b8f:	fb 03 ef 62 	calls $0x3,168f8 <memset>
   17b93:	ed ff ff 
   17b96:	d4 53       	clrf r3
   17b98:	d1 53 a7 08 	cmpl r3,0x8(r7)
   17b9c:	1e 58       	bcc 17bf6 <omalloc_grow+0xba>
   17b9e:	d4 54       	clrf r4
   17ba0:	c1 54 a7 04 	addl3 r4,0x4(r7),r0
   17ba4:	50 
   17ba5:	d0 60 50    	movl (r0),r0
   17ba8:	13 41       	beql 17beb <omalloc_grow+0xaf>
   17baa:	9c 14 50 52 	rotl $0x14,r0,r2
   17bae:	ca 8f 00 00 	bicl2 $0xfff00000,r2
   17bb2:	f0 ff 52 
   17bb5:	78 07 52 50 	ashl $0x7,r2,r0
   17bb9:	c2 52 50    	subl2 r2,r0
   17bbc:	d0 10 51    	movl $0x10,r1
   17bbf:	ef 51 51 52 	extzv r1,r1,r2,r2
   17bc3:	52 
   17bc4:	c0 52 50    	addl2 r2,r0
   17bc7:	d2 50 50    	mcoml r0,r0
   17bca:	cb 50 58 52 	bicl3 r0,r8,r2
   17bce:	7e 42 66 50 	movaq (r6)[r2],r0
   17bd2:	d5 60       	tstl (r0)
   17bd4:	13 0f       	beql 17be5 <omalloc_grow+0xa9>
   17bd6:	ce 52 50    	mnegl r2,r0
   17bd9:	cb 50 58 52 	bicl3 r0,r8,r2
   17bdd:	7e 42 66 50 	movaq (r6)[r2],r0
   17be1:	d5 60       	tstl (r0)
   17be3:	12 f1       	bneq 17bd6 <omalloc_grow+0x9a>
   17be5:	7d 43 b7 04 	movq *0x4(r7)[r3],(r6)[r2]
   17be9:	42 66 
   17beb:	d6 53       	incl r3
   17bed:	c0 08 54    	addl2 $0x8,r4
   17bf0:	d1 53 a7 08 	cmpl r3,0x8(r7)
   17bf4:	1f aa       	blssu 17ba0 <omalloc_grow+0x64>
   17bf6:	78 03 a7 08 	ashl $0x3,0x8(r7),-(sp)
   17bfa:	7e 
   17bfb:	dd a7 04    	pushl 0x4(r7)
   17bfe:	fb 02 ef c7 	calls $0x2,16acc <_thread_sys_munmap>
   17c02:	ee ff ff 
   17c05:	d5 50       	tstl r0
   17c07:	12 10       	bneq 17c19 <omalloc_grow+0xdd>
   17c09:	c0 a7 08 a7 	addl2 0x8(r7),0xc(r7)
   17c0d:	0c 
   17c0e:	d0 5a a7 08 	movl r10,0x8(r7)
   17c12:	d0 56 a7 04 	movl r6,0x4(r7)
   17c16:	d4 50       	clrf r0
   17c18:	04          	ret
   17c19:	dd a7 04    	pushl 0x4(r7)
   17c1c:	9f ef b1 34 	pushab 2b0d3 <q.0+0x94>
   17c20:	01 00 
   17c22:	fb 02 cf 59 	calls $0x2,17180 <wrterror>
   17c26:	f5 
   17c27:	11 e0       	brb 17c09 <omalloc_grow+0xcd>
   17c29:	01          	nop

00017c2a <alloc_chunk_info>:
   17c2a:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   17c2c:	c2 04 5e    	subl2 $0x4,sp
   17c2f:	d0 ac 04 59 	movl 0x4(ap),r9
   17c33:	d0 ac 08 57 	movl 0x8(ap),r7
   17c37:	13 03       	beql 17c3c <alloc_chunk_info+0x12>
   17c39:	31 ba 00    	brw 17cf6 <alloc_chunk_info+0xcc>
   17c3c:	3c 8f 00 01 	movzwl $0x0100,r2
   17c40:	52 
   17c41:	c1 52 0f 50 	addl3 r2,$0xf,r0
   17c45:	9c 1c 50 58 	rotl $0x1c,r0,r8
   17c49:	ca 8f 00 00 	bicl2 $0xf0000000,r8
   17c4d:	00 f0 58 
   17c50:	3e 48 9f 1d 	movaw *0x1d[r8],r0
   17c54:	00 00 00 50 
   17c58:	cb 03 50 58 	bicl3 $0x3,r0,r8
   17c5c:	d5 47 a9 10 	tstl 0x10(r9)[r7]
   17c60:	13 28       	beql 17c8a <alloc_chunk_info+0x60>
   17c62:	d0 47 a9 10 	movl 0x10(r9)[r7],r6
   17c66:	56 
   17c67:	d0 66 50    	movl (r6),r0
   17c6a:	13 05       	beql 17c71 <alloc_chunk_info+0x47>
   17c6c:	d0 a6 04 a0 	movl 0x4(r6),0x4(r0)
   17c70:	04 
   17c71:	d0 66 b6 04 	movl (r6),*0x4(r6)
   17c75:	dd 58       	pushl r8
   17c77:	d4 7e       	clrf -(sp)
   17c79:	dd 56       	pushl r6
   17c7b:	fb 03 ef 76 	calls $0x3,168f8 <memset>
   17c7f:	ec ff ff 
   17c82:	d0 69 a6 0c 	movl (r9),0xc(r6)
   17c86:	d0 56 50    	movl r6,r0
   17c89:	04          	ret
   17c8a:	7c 7e       	clrd -(sp)
   17c8c:	d2 00 7e    	mcoml $0x0,-(sp)
   17c8f:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   17c93:	7e 
   17c94:	dd 03       	pushl $0x3
   17c96:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   17c9a:	7e 
   17c9b:	d4 7e       	clrf -(sp)
   17c9d:	fb 07 ef be 	calls $0x7,16a62 <_thread_sys_mmap>
   17ca1:	ed ff ff 
   17ca4:	d0 50 56    	movl r0,r6
   17ca7:	d1 50 8f ff 	cmpl r0,$0xffffffff
   17cab:	ff ff ff 
   17cae:	13 43       	beql 17cf3 <alloc_chunk_info+0xc9>
   17cb0:	dd 58       	pushl r8
   17cb2:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   17cb6:	7e 
   17cb7:	fb 02 ef 26 	calls $0x2,15ce4 <__udiv>
   17cbb:	e0 ff ff 
   17cbe:	d0 50 52    	movl r0,r2
   17cc1:	d4 51       	clrf r1
   17cc3:	d1 51 50    	cmpl r1,r0
   17cc6:	1e 9a       	bcc 17c62 <alloc_chunk_info+0x38>
   17cc8:	d0 47 a9 10 	movl 0x10(r9)[r7],r0
   17ccc:	50 
   17ccd:	d0 50 66    	movl r0,(r6)
   17cd0:	13 09       	beql 17cdb <alloc_chunk_info+0xb1>
   17cd2:	d0 47 a9 10 	movl 0x10(r9)[r7],r0
   17cd6:	50 
   17cd7:	d0 56 a0 04 	movl r6,0x4(r0)
   17cdb:	d0 56 47 a9 	movl r6,0x10(r9)[r7]
   17cdf:	10 
   17ce0:	de 47 a9 10 	moval 0x10(r9)[r7],0x4(r6)
   17ce4:	a6 04 
   17ce6:	d6 51       	incl r1
   17ce8:	c0 58 56    	addl2 r8,r6
   17ceb:	d1 51 52    	cmpl r1,r2
   17cee:	1f d8       	blssu 17cc8 <alloc_chunk_info+0x9e>
   17cf0:	31 6f ff    	brw 17c62 <alloc_chunk_info+0x38>
   17cf3:	d4 50       	clrf r0
   17cf5:	04          	ret
   17cf6:	83 57 20 51 	subb3 r7,$0x20,r1
   17cfa:	3c 8f 00 10 	movzwl $0x1000,r0
   17cfe:	50 
   17cff:	ef 57 51 50 	extzv r7,r1,r0,r2
   17d03:	52 
   17d04:	31 3a ff    	brw 17c41 <alloc_chunk_info+0x17>
   17d07:	01          	nop

00017d08 <insert>:
   17d08:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   17d0a:	c2 04 5e    	subl2 $0x4,sp
   17d0d:	d0 ac 04 56 	movl 0x4(ap),r6
   17d11:	d0 ac 08 57 	movl 0x8(ap),r7
   17d15:	78 02 a6 0c 	ashl $0x2,0xc(r6),r0
   17d19:	50 
   17d1a:	d1 50 a6 08 	cmpl r0,0x8(r6)
   17d1e:	1f 63       	blssu 17d83 <insert+0x7b>
   17d20:	c3 01 a6 08 	subl3 $0x1,0x8(r6),r3
   17d24:	53 
   17d25:	9c 14 57 52 	rotl $0x14,r7,r2
   17d29:	ca 8f 00 00 	bicl2 $0xfff00000,r2
   17d2d:	f0 ff 52 
   17d30:	78 07 52 50 	ashl $0x7,r2,r0
   17d34:	c2 52 50    	subl2 r2,r0
   17d37:	d0 10 51    	movl $0x10,r1
   17d3a:	ef 51 51 52 	extzv r1,r1,r2,r2
   17d3e:	52 
   17d3f:	c0 52 50    	addl2 r2,r0
   17d42:	d2 50 50    	mcoml r0,r0
   17d45:	cb 50 53 51 	bicl3 r0,r3,r1
   17d49:	d0 a6 04 52 	movl 0x4(r6),r2
   17d4d:	7e 41 62 50 	movaq (r2)[r1],r0
   17d51:	d5 60       	tstl (r0)
   17d53:	13 0f       	beql 17d64 <insert+0x5c>
   17d55:	ce 51 50    	mnegl r1,r0
   17d58:	cb 50 53 51 	bicl3 r0,r3,r1
   17d5c:	7e 41 62 50 	movaq (r2)[r1],r0
   17d60:	d5 60       	tstl (r0)
   17d62:	12 f1       	bneq 17d55 <insert+0x4d>
   17d64:	7e 41 9f 00 	movaq *0x0[r1],r0
   17d68:	00 00 00 50 
   17d6c:	c1 50 a6 04 	addl3 r0,0x4(r6),r1
   17d70:	51 
   17d71:	d0 57 61    	movl r7,(r1)
   17d74:	c0 a6 04 50 	addl2 0x4(r6),r0
   17d78:	d0 ac 0c a0 	movl 0xc(ap),0x4(r0)
   17d7c:	04 
   17d7d:	d7 a6 0c    	decl 0xc(r6)
   17d80:	d4 50       	clrf r0
   17d82:	04          	ret
   17d83:	dd 56       	pushl r6
   17d85:	fb 01 cf b2 	calls $0x1,17b3c <omalloc_grow>
   17d89:	fd 
   17d8a:	d5 50       	tstl r0
   17d8c:	13 92       	beql 17d20 <insert+0x18>
   17d8e:	d0 01 50    	movl $0x1,r0
   17d91:	04          	ret

00017d92 <find>:
   17d92:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   17d94:	c2 04 5e    	subl2 $0x4,sp
   17d97:	d0 ac 04 57 	movl 0x4(ap),r7
   17d9b:	d0 ac 08 56 	movl 0x8(ap),r6
   17d9f:	c3 01 a7 08 	subl3 $0x1,0x8(r7),r8
   17da3:	58 
   17da4:	d0 67 51    	movl (r7),r1
   17da7:	cd 57 51 50 	xorl3 r7,r1,r0
   17dab:	d1 ef 7b 92 	cmpl 6102c <malloc_readonly+0x2c>,r0
   17daf:	04 00 50 
   17db2:	12 03       	bneq 17db7 <find+0x25>
   17db4:	31 83 00    	brw 17e3a <find+0xa8>
   17db7:	d4 7e       	clrf -(sp)
   17db9:	9f ef 1b 33 	pushab 2b0da <q.0+0x9b>
   17dbd:	01 00 
   17dbf:	fb 02 cf bc 	calls $0x2,17180 <wrterror>
   17dc3:	f3 
   17dc4:	ca 8f ff 0f 	bicl2 $0x00000fff,r6
   17dc8:	00 00 56 
   17dcb:	9c 14 56 52 	rotl $0x14,r6,r2
   17dcf:	ca 8f 00 00 	bicl2 $0xfff00000,r2
   17dd3:	f0 ff 52 
   17dd6:	78 07 52 50 	ashl $0x7,r2,r0
   17dda:	c2 52 50    	subl2 r2,r0
   17ddd:	d0 10 51    	movl $0x10,r1
   17de0:	ef 51 51 52 	extzv r1,r1,r2,r2
   17de4:	52 
   17de5:	c0 52 50    	addl2 r2,r0
   17de8:	d2 50 50    	mcoml r0,r0
   17deb:	cb 50 58 52 	bicl3 r0,r8,r2
   17def:	7e 42 b7 04 	movaq *0x4(r7)[r2],r0
   17df3:	50 
   17df4:	d0 60 50    	movl (r0),r0
   17df7:	cb 8f ff 0f 	bicl3 $0x00000fff,r0,r1
   17dfb:	00 00 50 51 
   17dff:	d1 51 56    	cmpl r1,r6
   17e02:	13 24       	beql 17e28 <find+0x96>
   17e04:	d5 50       	tstl r0
   17e06:	13 20       	beql 17e28 <find+0x96>
   17e08:	ce 52 50    	mnegl r2,r0
   17e0b:	cb 50 58 52 	bicl3 r0,r8,r2
   17e0f:	7e 42 b7 04 	movaq *0x4(r7)[r2],r0
   17e13:	50 
   17e14:	d0 60 50    	movl (r0),r0
   17e17:	cb 8f ff 0f 	bicl3 $0x00000fff,r0,r1
   17e1b:	00 00 50 51 
   17e1f:	d1 51 56    	cmpl r1,r6
   17e22:	13 04       	beql 17e28 <find+0x96>
   17e24:	d5 50       	tstl r0
   17e26:	12 e0       	bneq 17e08 <find+0x76>
   17e28:	d1 51 56    	cmpl r1,r6
   17e2b:	13 03       	beql 17e30 <find+0x9e>
   17e2d:	d4 50       	clrf r0
   17e2f:	04          	ret
   17e30:	d5 50       	tstl r0
   17e32:	13 f9       	beql 17e2d <find+0x9b>
   17e34:	7e 42 b7 04 	movaq *0x4(r7)[r2],r0
   17e38:	50 
   17e39:	04          	ret
   17e3a:	d2 c7 6c 09 	mcoml 0x96c(r7),r0
   17e3e:	50 
   17e3f:	d1 51 50    	cmpl r1,r0
   17e42:	13 03       	beql 17e47 <find+0xb5>
   17e44:	31 70 ff    	brw 17db7 <find+0x25>
   17e47:	31 7a ff    	brw 17dc4 <find+0x32>

00017e4a <delete>:
   17e4a:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   17e4c:	c2 04 5e    	subl2 $0x4,sp
   17e4f:	d0 ac 04 57 	movl 0x4(ap),r7
   17e53:	d0 a7 08 50 	movl 0x8(r7),r0
   17e57:	c3 01 50 56 	subl3 $0x1,r0,r6
   17e5b:	d3 50 56    	bitl r0,r6
   17e5e:	13 03       	beql 17e63 <delete+0x19>
   17e60:	31 85 00    	brw 17ee8 <delete+0x9e>
   17e63:	d6 a7 0c    	incl 0xc(r7)
   17e66:	c3 a7 04 ac 	subl3 0x4(r7),0x8(ap),r0
   17e6a:	08 50 
   17e6c:	78 8f fd 50 	ashl $0xfd,r0,r3
   17e70:	53 
   17e71:	7e 43 9f 00 	movaq *0x0[r3],r0
   17e75:	00 00 00 50 
   17e79:	c1 50 a7 04 	addl3 r0,0x4(r7),r1
   17e7d:	51 
   17e7e:	d4 61       	clrf (r1)
   17e80:	c0 a7 04 50 	addl2 0x4(r7),r0
   17e84:	d4 a0 04    	clrf 0x4(r0)
   17e87:	d0 53 55    	movl r3,r5
   17e8a:	ce 53 50    	mnegl r3,r0
   17e8d:	cb 50 56 53 	bicl3 r0,r6,r3
   17e91:	d0 a7 04 54 	movl 0x4(r7),r4
   17e95:	7e 43 64 50 	movaq (r4)[r3],r0
   17e99:	d0 60 50    	movl (r0),r0
   17e9c:	13 49       	beql 17ee7 <delete+0x9d>
   17e9e:	9c 14 50 50 	rotl $0x14,r0,r0
   17ea2:	ca 8f 00 00 	bicl2 $0xfff00000,r0
   17ea6:	f0 ff 50 
   17ea9:	78 07 50 51 	ashl $0x7,r0,r1
   17ead:	c2 50 51    	subl2 r0,r1
   17eb0:	d0 10 52    	movl $0x10,r2
   17eb3:	ef 52 52 50 	extzv r2,r2,r0,r0
   17eb7:	50 
   17eb8:	c0 50 51    	addl2 r0,r1
   17ebb:	d2 51 51    	mcoml r1,r1
   17ebe:	cb 51 56 50 	bicl3 r1,r6,r0
   17ec2:	d1 53 50    	cmpl r3,r0
   17ec5:	1a 05       	bgtru 17ecc <delete+0x82>
   17ec7:	d1 50 55    	cmpl r0,r5
   17eca:	1f be       	blssu 17e8a <delete+0x40>
   17ecc:	d1 50 55    	cmpl r0,r5
   17ecf:	1e 05       	bcc 17ed6 <delete+0x8c>
   17ed1:	d1 55 53    	cmpl r5,r3
   17ed4:	1f b4       	blssu 17e8a <delete+0x40>
   17ed6:	d1 55 53    	cmpl r5,r3
   17ed9:	1e 05       	bcc 17ee0 <delete+0x96>
   17edb:	d1 53 50    	cmpl r3,r0
   17ede:	1b aa       	blequ 17e8a <delete+0x40>
   17ee0:	7d 43 64 45 	movq (r4)[r3],(r4)[r5]
   17ee4:	64 
   17ee5:	11 8a       	brb 17e71 <delete+0x27>
   17ee7:	04          	ret
   17ee8:	d4 7e       	clrf -(sp)
   17eea:	9f ef 54 32 	pushab 2b144 <q.0+0x105>
   17eee:	01 00 
   17ef0:	fb 02 cf 8b 	calls $0x2,17180 <wrterror>
   17ef4:	f2 
   17ef5:	31 6b ff    	brw 17e63 <delete+0x19>

00017ef8 <omalloc_make_chunks>:
   17ef8:	c0 07       	.word 0x07c0 # Entry mask: < r10 r9 r8 r7 r6 >
   17efa:	c2 04 5e    	subl2 $0x4,sp
   17efd:	d0 ac 04 5a 	movl 0x4(ap),r10
   17f01:	d0 ac 08 57 	movl 0x8(ap),r7
   17f05:	d4 7e       	clrf -(sp)
   17f07:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   17f0b:	7e 
   17f0c:	d4 7e       	clrf -(sp)
   17f0e:	dd 5a       	pushl r10
   17f10:	fb 04 cf ef 	calls $0x4,17504 <map>
   17f14:	f5 
   17f15:	d0 50 58    	movl r0,r8
   17f18:	d1 50 8f ff 	cmpl r0,$0xffffffff
   17f1c:	ff ff ff 
   17f1f:	12 03       	bneq 17f24 <omalloc_make_chunks+0x2c>
   17f21:	31 23 01    	brw 18047 <omalloc_make_chunks+0x14f>
   17f24:	dd 57       	pushl r7
   17f26:	dd 5a       	pushl r10
   17f28:	fb 02 cf fd 	calls $0x2,17c2a <alloc_chunk_info>
   17f2c:	fc 
   17f2d:	d0 50 56    	movl r0,r6
   17f30:	12 03       	bneq 17f35 <omalloc_make_chunks+0x3d>
   17f32:	31 3e 01    	brw 18073 <omalloc_make_chunks+0x17b>
   17f35:	d5 57       	tstl r7
   17f37:	13 03       	beql 17f3c <omalloc_make_chunks+0x44>
   17f39:	31 0e 01    	brw 1804a <omalloc_make_chunks+0x152>
   17f3c:	b4 a0 10    	clrw 0x10(r0)
   17f3f:	b0 01 a0 12 	movw $0x1,0x12(r0)
   17f43:	d0 07 52    	movl $0x7,r2
   17f46:	b0 01 51    	movw $0x1,r1
   17f49:	b6 51       	incw r1
   17f4b:	78 8f ff 52 	ashl $0xff,r2,r2
   17f4f:	52 
   17f50:	12 f7       	bneq 17f49 <omalloc_make_chunks+0x51>
   17f52:	b0 51 a6 12 	movw r1,0x12(r6)
   17f56:	3c 51 51    	movzwl r1,r1
   17f59:	3c 8f 00 10 	movzwl $0x1000,r9
   17f5d:	59 
   17f5e:	83 51 20 50 	subb3 r1,$0x20,r0
   17f62:	ef 51 50 59 	extzv r1,r0,r9,r0
   17f66:	50 
   17f67:	b0 50 a6 14 	movw r0,0x14(r6)
   17f6b:	b0 50 a6 16 	movw r0,0x16(r6)
   17f6f:	d0 58 a6 08 	movl r8,0x8(r6)
   17f73:	d4 7e       	clrf -(sp)
   17f75:	dd 59       	pushl r9
   17f77:	dd 58       	pushl r8
   17f79:	fb 03 ef d8 	calls $0x3,16a58 <_thread_sys_mprotect>
   17f7d:	ea ff ff 
   17f80:	d5 50       	tstl r0
   17f82:	18 03       	bgeq 17f87 <omalloc_make_chunks+0x8f>
   17f84:	31 9b 00    	brw 18022 <omalloc_make_chunks+0x12a>
   17f87:	3c a6 16 53 	movzwl 0x16(r6),r3
   17f8b:	d4 52       	clrf r2
   17f8d:	d1 53 0f    	cmpl r3,$0xf
   17f90:	1b 1c       	blequ 17fae <omalloc_make_chunks+0xb6>
   17f92:	9c 1c 52 50 	rotl $0x1c,r2,r0
   17f96:	ca 8f 00 00 	bicl2 $0xf0000000,r0
   17f9a:	00 f0 50 
   17f9d:	b2 00 40 a6 	mcomw $0x0,0x18(r6)[r0]
   17fa1:	18 
   17fa2:	c0 10 52    	addl2 $0x10,r2
   17fa5:	c3 52 53 50 	subl3 r2,r3,r0
   17fa9:	d1 50 0f    	cmpl r0,$0xf
   17fac:	1a e4       	bgtru 17f92 <omalloc_make_chunks+0x9a>
   17fae:	d1 52 53    	cmpl r2,r3
   17fb1:	18 20       	bgeq 17fd3 <omalloc_make_chunks+0xdb>
   17fb3:	9c 1c 52 51 	rotl $0x1c,r2,r1
   17fb7:	ca 8f 00 00 	bicl2 $0xf0000000,r1
   17fbb:	00 f0 51 
   17fbe:	cb 8f f0 ff 	bicl3 $0xfffffff0,r2,r0
   17fc2:	ff ff 52 50 
   17fc6:	78 50 01 50 	ashl r0,$0x1,r0
   17fca:	a8 50 41 a6 	bisw2 r0,0x18(r6)[r1]
   17fce:	18 
   17fcf:	f2 53 52 e0 	aoblss r3,r2,17fb3 <omalloc_make_chunks+0xbb>
   17fd3:	78 04 57 50 	ashl $0x4,r7,r0
   17fd7:	c0 5a 50    	addl2 r10,r0
   17fda:	d0 ac 0c 51 	movl 0xc(ap),r1
   17fde:	de 41 a0 40 	moval 0x40(r0)[r1],r1
   17fe2:	51 
   17fe3:	d0 61 50    	movl (r1),r0
   17fe6:	d0 50 66    	movl r0,(r6)
   17fe9:	13 07       	beql 17ff2 <omalloc_make_chunks+0xfa>
   17feb:	d0 61 50    	movl (r1),r0
   17fee:	d0 56 a0 04 	movl r6,0x4(r0)
   17ff2:	d0 56 61    	movl r6,(r1)
   17ff5:	d0 51 a6 04 	movl r1,0x4(r6)
   17ff9:	d6 57       	incl r7
   17ffb:	d3 58 57    	bitl r8,r7
   17ffe:	12 13       	bneq 18013 <omalloc_make_chunks+0x11b>
   18000:	d4 7e       	clrf -(sp)
   18002:	dd 56       	pushl r6
   18004:	c9 57 58 7e 	bisl3 r7,r8,-(sp)
   18008:	dd 5a       	pushl r10
   1800a:	fb 04 cf f9 	calls $0x4,17d08 <insert>
   1800e:	fc 
   1800f:	d0 56 50    	movl r6,r0
   18012:	04          	ret
   18013:	dd 58       	pushl r8
   18015:	9f ef 3f 31 	pushab 2b15a <q.0+0x11b>
   18019:	01 00 
   1801b:	fb 02 cf 60 	calls $0x2,17180 <wrterror>
   1801f:	f1 
   18020:	11 de       	brb 18000 <omalloc_make_chunks+0x108>
   18022:	dd 59       	pushl r9
   18024:	dd 58       	pushl r8
   18026:	dd 5a       	pushl r10
   18028:	fb 03 cf 99 	calls $0x3,172c6 <unmap>
   1802c:	f2 
   1802d:	d0 aa 10 50 	movl 0x10(r10),r0
   18031:	d0 50 66    	movl r0,(r6)
   18034:	13 08       	beql 1803e <omalloc_make_chunks+0x146>
   18036:	d0 aa 10 50 	movl 0x10(r10),r0
   1803a:	d0 56 a0 04 	movl r6,0x4(r0)
   1803e:	d0 56 aa 10 	movl r6,0x10(r10)
   18042:	c1 5a 10 a6 	addl3 r10,$0x10,0x4(r6)
   18046:	04 
   18047:	d4 50       	clrf r0
   18049:	04          	ret
   1804a:	78 57 01 50 	ashl r7,$0x1,r0
   1804e:	b0 50 a6 10 	movw r0,0x10(r6)
   18052:	b0 57 a6 12 	movw r7,0x12(r6)
   18056:	83 57 20 51 	subb3 r7,$0x20,r1
   1805a:	3c 8f 00 10 	movzwl $0x1000,r0
   1805e:	50 
   1805f:	ef 57 51 50 	extzv r7,r1,r0,r0
   18063:	50 
   18064:	b0 50 a6 14 	movw r0,0x14(r6)
   18068:	b0 50 a6 16 	movw r0,0x16(r6)
   1806c:	d0 58 a6 08 	movl r8,0x8(r6)
   18070:	31 14 ff    	brw 17f87 <omalloc_make_chunks+0x8f>
   18073:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   18077:	7e 
   18078:	dd 58       	pushl r8
   1807a:	dd 5a       	pushl r10
   1807c:	fb 03 cf 45 	calls $0x3,172c6 <unmap>
   18080:	f2 
   18081:	11 c4       	brb 18047 <omalloc_make_chunks+0x14f>
   18083:	01          	nop

00018084 <malloc_bytes>:
   18084:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   18086:	c2 04 5e    	subl2 $0x4,sp
   18089:	d0 ac 04 59 	movl 0x4(ap),r9
   1808d:	d0 ac 08 56 	movl 0x8(ap),r6
   18091:	d0 69 51    	movl (r9),r1
   18094:	cd 59 51 50 	xorl3 r9,r1,r0
   18098:	d1 ef 8e 8f 	cmpl 6102c <malloc_readonly+0x2c>,r0
   1809c:	04 00 50 
   1809f:	12 03       	bneq 180a4 <malloc_bytes+0x20>
   180a1:	31 8f 01    	brw 18233 <malloc_bytes+0x1af>
   180a4:	d4 7e       	clrf -(sp)
   180a6:	9f ef 2e 30 	pushab 2b0da <q.0+0x9b>
   180aa:	01 00 
   180ac:	fb 02 cf cf 	calls $0x2,17180 <wrterror>
   180b0:	f0 
   180b1:	c3 01 56 50 	subl3 $0x1,r6,r0
   180b5:	d1 50 0e    	cmpl r0,$0xe
   180b8:	1a 03       	bgtru 180bd <malloc_bytes+0x39>
   180ba:	d0 10 56    	movl $0x10,r6
   180bd:	d5 56       	tstl r6
   180bf:	13 03       	beql 180c4 <malloc_bytes+0x40>
   180c1:	31 47 01    	brw 1820b <malloc_bytes+0x187>
   180c4:	d4 58       	clrf r8
   180c6:	d1 c9 44 09 	cmpl 0x944(r9),$0x1f
   180ca:	1f 
   180cb:	1b 03       	blequ 180d0 <malloc_bytes+0x4c>
   180cd:	31 31 01    	brw 18201 <malloc_bytes+0x17d>
   180d0:	c1 c9 44 09 	addl3 0x944(r9),r9,r0
   180d4:	59 50 
   180d6:	d6 c9 44 09 	incl 0x944(r9)
   180da:	90 c0 48 09 	movb 0x948(r0),r1
   180de:	51 
   180df:	ca 8f fc ff 	bicl2 $0xfffffffc,r1
   180e3:	ff ff 51 
   180e6:	78 04 58 50 	ashl $0x4,r8,r0
   180ea:	c0 59 50    	addl2 r9,r0
   180ed:	d0 41 a0 40 	movl 0x40(r0)[r1],r7
   180f1:	57 
   180f2:	12 03       	bneq 180f7 <malloc_bytes+0x73>
   180f4:	31 f4 00    	brw 181eb <malloc_bytes+0x167>
   180f7:	d1 a7 0c 69 	cmpl 0xc(r7),(r9)
   180fb:	13 0d       	beql 1810a <malloc_bytes+0x86>
   180fd:	d4 7e       	clrf -(sp)
   180ff:	9f ef 5f 30 	pushab 2b164 <q.0+0x125>
   18103:	01 00 
   18105:	fb 02 cf 76 	calls $0x2,17180 <wrterror>
   18109:	f0 
   1810a:	3c c9 68 09 	movzwl 0x968(r9),r6
   1810e:	56 
   1810f:	b1 a7 14 01 	cmpw 0x14(r7),$0x1
   18113:	1b 1c       	blequ 18131 <malloc_bytes+0xad>
   18115:	d1 c9 44 09 	cmpl 0x944(r9),$0x1f
   18119:	1f 
   1811a:	1b 03       	blequ 1811f <malloc_bytes+0x9b>
   1811c:	31 c2 00    	brw 181e1 <malloc_bytes+0x15d>
   1811f:	c1 c9 44 09 	addl3 0x944(r9),r9,r0
   18123:	59 50 
   18125:	d6 c9 44 09 	incl 0x944(r9)
   18129:	9a c0 48 09 	movzbl 0x948(r0),r0
   1812d:	50 
   1812e:	c0 50 56    	addl2 r0,r6
   18131:	3c a7 16 51 	movzwl 0x16(r7),r1
   18135:	d1 56 51    	cmpl r6,r1
   18138:	19 09       	blss 18143 <malloc_bytes+0xbf>
   1813a:	d7 51       	decl r1
   1813c:	d2 56 50    	mcoml r6,r0
   1813f:	cb 50 51 56 	bicl3 r0,r1,r6
   18143:	9c 1c 56 50 	rotl $0x1c,r6,r0
   18147:	ca 8f 00 00 	bicl2 $0xf0000000,r0
   1814b:	00 f0 50 
   1814e:	3e 40 a7 18 	movaw 0x18(r7)[r0],r1
   18152:	51 
   18153:	b0 61 50    	movw (r1),r0
   18156:	12 13       	bneq 1816b <malloc_bytes+0xe7>
   18158:	c0 10 56    	addl2 $0x10,r6
   1815b:	ca 0f 56    	bicl2 $0xf,r6
   1815e:	3c a7 16 50 	movzwl 0x16(r7),r0
   18162:	d1 56 50    	cmpl r6,r0
   18165:	19 dc       	blss 18143 <malloc_bytes+0xbf>
   18167:	d4 56       	clrf r6
   18169:	11 d8       	brb 18143 <malloc_bytes+0xbf>
   1816b:	cb 8f f0 ff 	bicl3 $0xfffffff0,r6,r8
   1816f:	ff ff 56 58 
   18173:	78 58 01 52 	ashl r8,$0x1,r2
   18177:	b3 50 52    	bitw r0,r2
   1817a:	12 0a       	bneq 18186 <malloc_bytes+0x102>
   1817c:	3c a7 16 50 	movzwl 0x16(r7),r0
   18180:	f2 50 56 bf 	aoblss r0,r6,18143 <malloc_bytes+0xbf>
   18184:	11 e1       	brb 18167 <malloc_bytes+0xe3>
   18186:	a1 c9 68 09 	addw3 0x968(r9),r6,r0
   1818a:	56 50 
   1818c:	a1 50 01 c9 	addw3 r0,$0x1,0x968(r9)
   18190:	68 09 
   18192:	ac 52 61    	xorw2 r2,(r1)
   18195:	b7 a7 14    	decw 0x14(r7)
   18198:	12 0e       	bneq 181a8 <malloc_bytes+0x124>
   1819a:	d0 67 50    	movl (r7),r0
   1819d:	13 05       	beql 181a4 <malloc_bytes+0x120>
   1819f:	d0 a7 04 a0 	movl 0x4(r7),0x4(r0)
   181a3:	04 
   181a4:	d0 67 b7 04 	movl (r7),*0x4(r7)
   181a8:	c3 57 51 50 	subl3 r7,r1,r0
   181ac:	7e 40 c8 40 	movaq 0xffffff40(r8)[r0],r8
   181b0:	ff 58 
   181b2:	78 a7 12 58 	ashl 0x12(r7),r8,r8
   181b6:	58 
   181b7:	d1 ef 57 8e 	cmpl 61014 <malloc_readonly+0x14>,$0x2
   181bb:	04 00 02 
   181be:	13 06       	beql 181c6 <malloc_bytes+0x142>
   181c0:	c1 a7 08 58 	addl3 0x8(r7),r8,r0
   181c4:	50 
   181c5:	04          	ret
   181c6:	b0 a7 10 50 	movw 0x10(r7),r0
   181ca:	13 f4       	beql 181c0 <malloc_bytes+0x13c>
   181cc:	3c 50 7e    	movzwl r0,-(sp)
   181cf:	9a 8f d0 7e 	movzbl $0xd0,-(sp)
   181d3:	c1 a7 08 58 	addl3 0x8(r7),r8,-(sp)
   181d7:	7e 
   181d8:	fb 03 ef 19 	calls $0x3,168f8 <memset>
   181dc:	e7 ff ff 
   181df:	11 df       	brb 181c0 <malloc_bytes+0x13c>
   181e1:	dd 59       	pushl r9
   181e3:	fb 01 cf b4 	calls $0x1,1729c <rbytes_init>
   181e7:	f0 
   181e8:	31 34 ff    	brw 1811f <malloc_bytes+0x9b>
   181eb:	dd 51       	pushl r1
   181ed:	dd 58       	pushl r8
   181ef:	dd 59       	pushl r9
   181f1:	fb 03 cf 02 	calls $0x3,17ef8 <omalloc_make_chunks>
   181f5:	fd 
   181f6:	d0 50 57    	movl r0,r7
   181f9:	13 03       	beql 181fe <malloc_bytes+0x17a>
   181fb:	31 f9 fe    	brw 180f7 <malloc_bytes+0x73>
   181fe:	d4 50       	clrf r0
   18200:	04          	ret
   18201:	dd 59       	pushl r9
   18203:	fb 01 cf 94 	calls $0x1,1729c <rbytes_init>
   18207:	f0 
   18208:	31 c5 fe    	brw 180d0 <malloc_bytes+0x4c>
   1820b:	d0 04 58    	movl $0x4,r8
   1820e:	c3 01 56 50 	subl3 $0x1,r6,r0
   18212:	9c 1d 50 56 	rotl $0x1d,r0,r6
   18216:	ca 8f 00 00 	bicl2 $0xe0000000,r6
   1821a:	00 e0 56 
   1821d:	78 8f ff 56 	ashl $0xff,r6,r6
   18221:	56 
   18222:	12 03       	bneq 18227 <malloc_bytes+0x1a3>
   18224:	31 9f fe    	brw 180c6 <malloc_bytes+0x42>
   18227:	d6 58       	incl r8
   18229:	78 8f ff 56 	ashl $0xff,r6,r6
   1822d:	56 
   1822e:	12 f7       	bneq 18227 <malloc_bytes+0x1a3>
   18230:	31 93 fe    	brw 180c6 <malloc_bytes+0x42>
   18233:	d2 c9 6c 09 	mcoml 0x96c(r9),r0
   18237:	50 
   18238:	d1 51 50    	cmpl r1,r0
   1823b:	13 03       	beql 18240 <malloc_bytes+0x1bc>
   1823d:	31 64 fe    	brw 180a4 <malloc_bytes+0x20>
   18240:	31 6e fe    	brw 180b1 <malloc_bytes+0x2d>
   18243:	01          	nop

00018244 <find_chunknum>:
   18244:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   18246:	c2 04 5e    	subl2 $0x4,sp
   18249:	d0 ac 0c 57 	movl 0xc(ap),r7
   1824d:	d0 ac 08 50 	movl 0x8(ap),r0
   18251:	d0 a0 04 56 	movl 0x4(r0),r6
   18255:	d1 a6 0c bc 	cmpl 0xc(r6),*0x4(ap)
   18259:	04 
   1825a:	13 0d       	beql 18269 <find_chunknum+0x25>
   1825c:	d4 7e       	clrf -(sp)
   1825e:	9f ef 00 2f 	pushab 2b164 <q.0+0x125>
   18262:	01 00 
   18264:	fb 02 cf 17 	calls $0x2,17180 <wrterror>
   18268:	ef 
   18269:	cb 8f 00 f0 	bicl3 $0xfffff000,r7,r0
   1826d:	ff ff 57 50 
   18271:	3c a6 12 51 	movzwl 0x12(r6),r1
   18275:	83 51 20 52 	subb3 r1,$0x20,r2
   18279:	ef 51 52 50 	extzv r1,r2,r0,r3
   1827d:	53 
   1827e:	78 51 01 51 	ashl r1,$0x1,r1
   18282:	d7 51       	decl r1
   18284:	d3 57 51    	bitl r7,r1
   18287:	12 39       	bneq 182c2 <find_chunknum+0x7e>
   18289:	9c 1c 53 50 	rotl $0x1c,r3,r0
   1828d:	ca 8f 00 00 	bicl2 $0xf0000000,r0
   18291:	00 f0 50 
   18294:	3c 40 a6 18 	movzwl 0x18(r6)[r0],r0
   18298:	50 
   18299:	cb 8f f0 ff 	bicl3 $0xfffffff0,r3,r2
   1829d:	ff ff 53 52 
   182a1:	83 52 20 51 	subb3 r2,$0x20,r1
   182a5:	ef 52 51 50 	extzv r2,r1,r0,r0
   182a9:	50 
   182aa:	e8 50 04    	blbs r0,182b1 <find_chunknum+0x6d>
   182ad:	d0 53 50    	movl r3,r0
   182b0:	04          	ret
   182b1:	dd 57       	pushl r7
   182b3:	9f ef c0 2e 	pushab 2b179 <q.0+0x13a>
   182b7:	01 00 
   182b9:	fb 02 cf c2 	calls $0x2,17180 <wrterror>
   182bd:	ee 
   182be:	d2 00 50    	mcoml $0x0,r0
   182c1:	04          	ret
   182c2:	dd 57       	pushl r7
   182c4:	9f ef c5 2e 	pushab 2b18f <q.0+0x150>
   182c8:	01 00 
   182ca:	11 ed       	brb 182b9 <find_chunknum+0x75>

000182cc <free_bytes>:
   182cc:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   182ce:	c2 04 5e    	subl2 $0x4,sp
   182d1:	d0 ac 04 57 	movl 0x4(ap),r7
   182d5:	d0 ac 08 58 	movl 0x8(ap),r8
   182d9:	d0 a8 04 56 	movl 0x4(r8),r6
   182dd:	dd ac 0c    	pushl 0xc(ap)
   182e0:	dd 58       	pushl r8
   182e2:	dd 57       	pushl r7
   182e4:	fb 03 cf 5b 	calls $0x3,18244 <find_chunknum>
   182e8:	ff 
   182e9:	d1 50 8f ff 	cmpl r0,$0xffffffff
   182ed:	ff ff ff 
   182f0:	13 30       	beql 18322 <free_bytes+0x56>
   182f2:	9c 1c 50 51 	rotl $0x1c,r0,r1
   182f6:	ca 8f 00 00 	bicl2 $0xf0000000,r1
   182fa:	00 f0 51 
   182fd:	ca 8f f0 ff 	bicl2 $0xfffffff0,r0
   18301:	ff ff 50 
   18304:	78 50 01 50 	ashl r0,$0x1,r0
   18308:	a8 50 41 a6 	bisw2 r0,0x18(r6)[r1]
   1830c:	18 
   1830d:	b6 a6 14    	incw 0x14(r6)
   18310:	b0 a6 14 50 	movw 0x14(r6),r0
   18314:	b1 50 01    	cmpw r0,$0x1
   18317:	12 03       	bneq 1831c <free_bytes+0x50>
   18319:	31 84 00    	brw 183a0 <free_bytes+0xd4>
   1831c:	b1 50 a6 16 	cmpw r0,0x16(r6)
   18320:	13 01       	beql 18323 <free_bytes+0x57>
   18322:	04          	ret
   18323:	d0 66 50    	movl (r6),r0
   18326:	13 05       	beql 1832d <free_bytes+0x61>
   18328:	d0 a6 04 a0 	movl 0x4(r6),0x4(r0)
   1832c:	04 
   1832d:	d0 66 b6 04 	movl (r6),*0x4(r6)
   18331:	b5 a6 10    	tstw 0x10(r6)
   18334:	12 08       	bneq 1833e <free_bytes+0x72>
   18336:	d5 ef d0 8c 	tstl 6100c <malloc_readonly+0xc>
   1833a:	04 00 
   1833c:	13 4f       	beql 1838d <free_bytes+0xc1>
   1833e:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   18342:	7e 
   18343:	dd a6 08    	pushl 0x8(r6)
   18346:	dd 57       	pushl r7
   18348:	fb 03 cf 79 	calls $0x3,172c6 <unmap>
   1834c:	ef 
   1834d:	dd 58       	pushl r8
   1834f:	dd 57       	pushl r7
   18351:	fb 02 cf f4 	calls $0x2,17e4a <delete>
   18355:	fa 
   18356:	b5 a6 10    	tstw 0x10(r6)
   18359:	13 2c       	beql 18387 <free_bytes+0xbb>
   1835b:	b0 a6 12 51 	movw 0x12(r6),r1
   1835f:	9c 02 51 50 	rotl $0x2,r1,r0
   18363:	ca 8f 03 00 	bicl2 $0xfffc0003,r0
   18367:	fc ff 50 
   1836a:	9e 47 a0 10 	movab 0x10(r0)[r7],r1
   1836e:	51 
   1836f:	d0 61 50    	movl (r1),r0
   18372:	d0 50 66    	movl r0,(r6)
   18375:	13 07       	beql 1837e <free_bytes+0xb2>
   18377:	d0 61 50    	movl (r1),r0
   1837a:	d0 56 a0 04 	movl r6,0x4(r0)
   1837e:	d0 56 61    	movl r6,(r1)
   18381:	d0 51 a6 04 	movl r1,0x4(r6)
   18385:	11 9b       	brb 18322 <free_bytes+0x56>
   18387:	c1 57 10 51 	addl3 r7,$0x10,r1
   1838b:	11 e2       	brb 1836f <free_bytes+0xa3>
   1838d:	dd 03       	pushl $0x3
   1838f:	3c 8f 00 10 	movzwl $0x1000,-(sp)
   18393:	7e 
   18394:	dd a6 08    	pushl 0x8(r6)
   18397:	fb 03 ef ba 	calls $0x3,16a58 <_thread_sys_mprotect>
   1839b:	e6 ff ff 
   1839e:	11 9e       	brb 1833e <free_bytes+0x72>
   183a0:	d1 c7 44 09 	cmpl 0x944(r7),$0x1f
   183a4:	1f 
   183a5:	1a 50       	bgtru 183f7 <free_bytes+0x12b>
   183a7:	c1 c7 44 09 	addl3 0x944(r7),r7,r0
   183ab:	57 50 
   183ad:	d6 c7 44 09 	incl 0x944(r7)
   183b1:	90 c0 48 09 	movb 0x948(r0),r1
   183b5:	51 
   183b6:	ca 8f fc ff 	bicl2 $0xfffffffc,r1
   183ba:	ff ff 51 
   183bd:	b5 a6 10    	tstw 0x10(r6)
   183c0:	13 2e       	beql 183f0 <free_bytes+0x124>
   183c2:	b0 a6 12 52 	movw 0x12(r6),r2
   183c6:	9c 04 52 50 	rotl $0x4,r2,r0
   183ca:	ca 8f 0f 00 	bicl2 $0xfff0000f,r0
   183ce:	f0 ff 50 
   183d1:	c0 57 50    	addl2 r7,r0
   183d4:	de 41 a0 40 	moval 0x40(r0)[r1],r1
   183d8:	51 
   183d9:	d0 61 50    	movl (r1),r0
   183dc:	d0 50 66    	movl r0,(r6)
   183df:	13 07       	beql 183e8 <free_bytes+0x11c>
   183e1:	d0 61 50    	movl (r1),r0
   183e4:	d0 56 a0 04 	movl r6,0x4(r0)
   183e8:	d0 56 61    	movl r6,(r1)
   183eb:	d0 51 a6 04 	movl r1,0x4(r6)
   183ef:	04          	ret
   183f0:	de 41 a7 40 	moval 0x40(r7)[r1],r1
   183f4:	51 
   183f5:	11 e2       	brb 183d9 <free_bytes+0x10d>
   183f7:	dd 57       	pushl r7
   183f9:	fb 01 cf 9e 	calls $0x1,1729c <rbytes_init>
   183fd:	ee 
   183fe:	11 a7       	brb 183a7 <free_bytes+0xdb>

00018400 <omalloc>:
   18400:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   18402:	c2 04 5e    	subl2 $0x4,sp
   18405:	d0 ac 04 56 	movl 0x4(ap),r6
   18409:	d0 ac 0c 5a 	movl 0xc(ap),r10
   1840d:	d0 ef ed 8b 	movl 61000 <malloc_readonly>,r7
   18411:	04 00 57 
   18414:	d1 56 8f 00 	cmpl r6,$0x00000800
   18418:	08 00 00 
   1841b:	1a 03       	bgtru 18420 <omalloc+0x20>
   1841d:	31 44 01    	brw 18564 <omalloc+0x164>
   18420:	9e ef fe 8b 	movab 61024 <malloc_readonly+0x24>,r11
   18424:	04 00 5b 
   18427:	d0 6b 51    	movl (r11),r1
   1842a:	c3 51 8f ff 	subl3 r1,$0xffffefff,r0
   1842e:	ef ff ff 50 
   18432:	d1 56 50    	cmpl r6,r0
   18435:	1f 03       	blssu 1843a <omalloc+0x3a>
   18437:	31 1d 01    	brw 18557 <omalloc+0x157>
   1843a:	c0 51 56    	addl2 r1,r6
   1843d:	9e c6 ff 0f 	movab 0xfff(r6),r0
   18441:	50 
   18442:	cb 8f ff 0f 	bicl3 $0x00000fff,r0,r9
   18446:	00 00 50 59 
   1844a:	dd ac 08    	pushl 0x8(ap)
   1844d:	dd 59       	pushl r9
   1844f:	d4 7e       	clrf -(sp)
   18451:	dd 57       	pushl r7
   18453:	fb 04 cf ac 	calls $0x4,17504 <map>
   18457:	f0 
   18458:	d0 50 58    	movl r0,r8
   1845b:	d1 50 8f ff 	cmpl r0,$0xffffffff
   1845f:	ff ff ff 
   18462:	12 03       	bneq 18467 <omalloc+0x67>
   18464:	31 f0 00    	brw 18557 <omalloc+0x157>
   18467:	dd 5a       	pushl r10
   18469:	dd 56       	pushl r6
   1846b:	dd 50       	pushl r0
   1846d:	dd 57       	pushl r7
   1846f:	fb 04 cf 94 	calls $0x4,17d08 <insert>
   18473:	f8 
   18474:	d5 50       	tstl r0
   18476:	13 03       	beql 1847b <omalloc+0x7b>
   18478:	31 d1 00    	brw 1854c <omalloc+0x14c>
   1847b:	d0 6b 51    	movl (r11),r1
   1847e:	13 03       	beql 18483 <omalloc+0x83>
   18480:	31 9f 00    	brw 18522 <omalloc+0x122>
   18483:	d5 ef 8f 8b 	tstl 61018 <malloc_readonly+0x18>
   18487:	04 00 
   18489:	13 65       	beql 184f0 <omalloc+0xf0>
   1848b:	9e ef 93 8b 	movab 61024 <malloc_readonly+0x24>,r7
   1848f:	04 00 57 
   18492:	d0 67 51    	movl (r7),r1
   18495:	c3 51 56 50 	subl3 r1,r6,r0
   18499:	d1 50 8f ff 	cmpl r0,$0x00000fff
   1849d:	0f 00 00 
   184a0:	1a 4e       	bgtru 184f0 <omalloc+0xf0>
   184a2:	9e ef 6c 8b 	movab 61014 <malloc_readonly+0x14>,r10
   184a6:	04 00 5a 
   184a9:	d1 6a 02    	cmpl (r10),$0x2
   184ac:	13 2f       	beql 184dd <omalloc+0xdd>
   184ae:	c3 67 56 51 	subl3 (r7),r6,r1
   184b2:	c3 51 8f 00 	subl3 r1,$0x00001000,r0
   184b6:	10 00 00 50 
   184ba:	ca 0f 50    	bicl2 $0xf,r0
   184bd:	c0 50 58    	addl2 r0,r8
   184c0:	d5 ac 08    	tstl 0x8(ap)
   184c3:	13 05       	beql 184ca <omalloc+0xca>
   184c5:	d1 6a 02    	cmpl (r10),$0x2
   184c8:	13 04       	beql 184ce <omalloc+0xce>
   184ca:	d0 58 50    	movl r8,r0
   184cd:	04          	ret
   184ce:	dd 51       	pushl r1
   184d0:	d4 7e       	clrf -(sp)
   184d2:	dd 58       	pushl r8
   184d4:	fb 03 ef 1d 	calls $0x3,168f8 <memset>
   184d8:	e4 ff ff 
   184db:	11 ed       	brb 184ca <omalloc+0xca>
   184dd:	c3 51 59 7e 	subl3 r1,r9,-(sp)
   184e1:	9a 8f d0 7e 	movzbl $0xd0,-(sp)
   184e5:	dd 58       	pushl r8
   184e7:	fb 03 ef 0a 	calls $0x3,168f8 <memset>
   184eb:	e4 ff ff 
   184ee:	11 be       	brb 184ae <omalloc+0xae>
   184f0:	d1 ef 1e 8b 	cmpl 61014 <malloc_readonly+0x14>,$0x2
   184f4:	04 00 02 
   184f7:	12 d1       	bneq 184ca <omalloc+0xca>
   184f9:	d5 ac 08    	tstl 0x8(ap)
   184fc:	13 16       	beql 18514 <omalloc+0x114>
   184fe:	c3 56 59 7e 	subl3 r6,r9,-(sp)
   18502:	9a 8f d0 7e 	movzbl $0xd0,-(sp)
   18506:	c1 58 56 50 	addl3 r8,r6,r0
   1850a:	c3 ef 14 8b 	subl3 61024 <malloc_readonly+0x24>,r0,-(sp)
   1850e:	04 00 50 7e 
   18512:	11 c0       	brb 184d4 <omalloc+0xd4>
   18514:	c3 ef 0a 8b 	subl3 61024 <malloc_readonly+0x24>,r9,-(sp)
   18518:	04 00 59 7e 
   1851c:	9a 8f d0 7e 	movzbl $0xd0,-(sp)
   18520:	11 b0       	brb 184d2 <omalloc+0xd2>
   18522:	d4 7e       	clrf -(sp)
   18524:	dd 51       	pushl r1
   18526:	c1 58 59 50 	addl3 r8,r9,r0
   1852a:	c3 51 50 7e 	subl3 r1,r0,-(sp)
   1852e:	fb 03 ef 23 	calls $0x3,16a58 <_thread_sys_mprotect>
   18532:	e5 ff ff 
   18535:	d5 50       	tstl r0
   18537:	12 03       	bneq 1853c <omalloc+0x13c>
   18539:	31 47 ff    	brw 18483 <omalloc+0x83>
   1853c:	d4 7e       	clrf -(sp)
   1853e:	9f ef 62 2c 	pushab 2b1a6 <q.0+0x167>
   18542:	01 00 
   18544:	fb 02 cf 37 	calls $0x2,17180 <wrterror>
   18548:	ec 
   18549:	31 37 ff    	brw 18483 <omalloc+0x83>
   1854c:	dd 59       	pushl r9
   1854e:	dd 58       	pushl r8
   18550:	dd 57       	pushl r7
   18552:	fb 03 cf 6f 	calls $0x3,172c6 <unmap>
   18556:	ed 
   18557:	fb 00 ef 6a 	calls $0x0,109c8 <___errno>
   1855b:	84 ff ff 
   1855e:	d0 0c 60    	movl $0xc,(r0)
   18561:	d4 50       	clrf r0
   18563:	04          	ret
   18564:	dd 5a       	pushl r10
   18566:	dd 56       	pushl r6
   18568:	dd 57       	pushl r7
   1856a:	fb 03 cf 15 	calls $0x3,18084 <malloc_bytes>
   1856e:	fb 
   1856f:	d0 50 58    	movl r0,r8
   18572:	d5 ac 08    	tstl 0x8(ap)
   18575:	12 03       	bneq 1857a <omalloc+0x17a>
   18577:	31 50 ff    	brw 184ca <omalloc+0xca>
   1857a:	d5 50       	tstl r0
   1857c:	12 03       	bneq 18581 <omalloc+0x181>
   1857e:	31 49 ff    	brw 184ca <omalloc+0xca>
   18581:	d5 56       	tstl r6
   18583:	12 03       	bneq 18588 <omalloc+0x188>
   18585:	31 42 ff    	brw 184ca <omalloc+0xca>
   18588:	dd 56       	pushl r6
   1858a:	31 43 ff    	brw 184d0 <omalloc+0xd0>
   1858d:	01          	nop

0001858e <malloc_recurse>:
   1858e:	00 00       	.word 0x0000 # Entry mask: < >
   18590:	c2 04 5e    	subl2 $0x4,sp
   18593:	d5 ef 67 7a 	tstl 60000 <noprint.1>
   18597:	04 00 
   18599:	13 22       	beql 185bd <malloc_recurse+0x2f>
   1859b:	d7 ef 63 9a 	decl 62004 <malloc_active>
   1859f:	04 00 
   185a1:	d5 ef 3d 3b 	tstl 5c0e4 <__isthreaded>
   185a5:	04 00 
   185a7:	12 0b       	bneq 185b4 <malloc_recurse+0x26>
   185a9:	fb 00 ef 18 	calls $0x0,109c8 <___errno>
   185ad:	84 ff ff 
   185b0:	d0 0b 60    	movl $0xb,(r0)
   185b3:	04          	ret
   185b4:	fb 00 ef 21 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   185b8:	e5 ff ff 
   185bb:	11 ec       	brb 185a9 <malloc_recurse+0x1b>
   185bd:	d0 01 ef 3c 	movl $0x1,60000 <noprint.1>
   185c1:	7a 04 00 
   185c4:	d4 7e       	clrf -(sp)
   185c6:	9f ef e3 2b 	pushab 2b1af <q.0+0x170>
   185ca:	01 00 
   185cc:	fb 02 cf af 	calls $0x2,17180 <wrterror>
   185d0:	eb 
   185d1:	11 c8       	brb 1859b <malloc_recurse+0xd>
   185d3:	01          	nop

000185d4 <malloc_init>:
   185d4:	00 00       	.word 0x0000 # Entry mask: < >
   185d6:	c2 04 5e    	subl2 $0x4,sp
   185d9:	9f ef 21 8a 	pushab 61000 <malloc_readonly>
   185dd:	04 00 
   185df:	fb 01 cf ac 	calls $0x1,17790 <omalloc_init>
   185e3:	f1 
   185e4:	d5 50       	tstl r0
   185e6:	12 03       	bneq 185eb <malloc_init+0x17>
   185e8:	d4 50       	clrf r0
   185ea:	04          	ret
   185eb:	d5 ef f3 3a 	tstl 5c0e4 <__isthreaded>
   185ef:	04 00 
   185f1:	12 25       	bneq 18618 <malloc_init+0x44>
   185f3:	d5 ef 27 8a 	tstl 61020 <malloc_readonly+0x20>
   185f7:	04 00 
   185f9:	12 0e       	bneq 18609 <malloc_init+0x35>
   185fb:	fb 00 ef c6 	calls $0x0,109c8 <___errno>
   185ff:	83 ff ff 
   18602:	d0 0c 60    	movl $0xc,(r0)
   18605:	d2 00 50    	mcoml $0x0,r0
   18608:	04          	ret
   18609:	d4 7e       	clrf -(sp)
   1860b:	9f ef ad 2b 	pushab 2b1be <q.0+0x17f>
   1860f:	01 00 
   18611:	fb 02 cf 6a 	calls $0x2,17180 <wrterror>
   18615:	eb 
   18616:	11 e3       	brb 185fb <malloc_init+0x27>
   18618:	fb 00 ef bd 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   1861c:	e4 ff ff 
   1861f:	11 d2       	brb 185f3 <malloc_init+0x1f>
   18621:	01          	nop

00018622 <malloc>:
   18622:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   18624:	c2 04 5e    	subl2 $0x4,sp
   18627:	fb 00 ef 9a 	calls $0x0,109c8 <___errno>
   1862b:	83 ff ff 
   1862e:	d0 60 57    	movl (r0),r7
   18631:	d5 ef ad 3a 	tstl 5c0e4 <__isthreaded>
   18635:	04 00 
   18637:	13 03       	beql 1863c <malloc+0x1a>
   18639:	31 92 00    	brw 186ce <malloc+0xac>
   1863c:	9e ef 8a 2b 	movab 2b1cc <q.0+0x18d>,62000 <malloc_func>
   18640:	01 00 ef b9 
   18644:	99 04 00 
   18647:	d5 ef b3 89 	tstl 61000 <malloc_readonly>
   1864b:	04 00 
   1864d:	13 74       	beql 186c3 <malloc+0xa1>
   1864f:	d6 ef af 99 	incl 62004 <malloc_active>
   18653:	04 00 
   18655:	d1 ef a9 99 	cmpl 62004 <malloc_active>,$0x1
   18659:	04 00 01 
   1865c:	12 5d       	bneq 186bb <malloc+0x99>
   1865e:	d4 7e       	clrf -(sp)
   18660:	d4 7e       	clrf -(sp)
   18662:	dd ac 04    	pushl 0x4(ap)
   18665:	fb 03 cf 96 	calls $0x3,18400 <omalloc>
   18669:	fd 
   1866a:	d0 50 56    	movl r0,r6
   1866d:	d7 ef 91 99 	decl 62004 <malloc_active>
   18671:	04 00 
   18673:	d5 ef 6b 3a 	tstl 5c0e4 <__isthreaded>
   18677:	04 00 
   18679:	12 37       	bneq 186b2 <malloc+0x90>
   1867b:	d5 56       	tstl r6
   1867d:	13 12       	beql 18691 <malloc+0x6f>
   1867f:	d5 56       	tstl r6
   18681:	13 0a       	beql 1868d <malloc+0x6b>
   18683:	fb 00 ef 3e 	calls $0x0,109c8 <___errno>
   18687:	83 ff ff 
   1868a:	d0 57 60    	movl r7,(r0)
   1868d:	d0 56 50    	movl r6,r0
   18690:	04          	ret
   18691:	d5 ef 89 89 	tstl 61020 <malloc_readonly+0x20>
   18695:	04 00 
   18697:	13 e6       	beql 1867f <malloc+0x5d>
   18699:	d4 7e       	clrf -(sp)
   1869b:	9f ef 1d 2b 	pushab 2b1be <q.0+0x17f>
   1869f:	01 00 
   186a1:	fb 02 cf da 	calls $0x2,17180 <wrterror>
   186a5:	ea 
   186a6:	fb 00 ef 1b 	calls $0x0,109c8 <___errno>
   186aa:	83 ff ff 
   186ad:	d0 0c 60    	movl $0xc,(r0)
   186b0:	11 cd       	brb 1867f <malloc+0x5d>
   186b2:	fb 00 ef 23 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   186b6:	e4 ff ff 
   186b9:	11 c0       	brb 1867b <malloc+0x59>
   186bb:	fb 00 cf ce 	calls $0x0,1858e <malloc_recurse>
   186bf:	fe 
   186c0:	d4 50       	clrf r0
   186c2:	04          	ret
   186c3:	fb 00 cf 0c 	calls $0x0,185d4 <malloc_init>
   186c7:	ff 
   186c8:	d5 50       	tstl r0
   186ca:	13 83       	beql 1864f <malloc+0x2d>
   186cc:	11 f2       	brb 186c0 <malloc+0x9e>
   186ce:	fb 00 ef 01 	calls $0x0,16ad6 <_weak__thread_malloc_lock>
   186d2:	e4 ff ff 
   186d5:	31 64 ff    	brw 1863c <malloc+0x1a>

000186d8 <ofree>:
   186d8:	c0 07       	.word 0x07c0 # Entry mask: < r10 r9 r8 r7 r6 >
   186da:	c2 04 5e    	subl2 $0x4,sp
   186dd:	d0 ac 04 58 	movl 0x4(ap),r8
   186e1:	d0 ef 19 89 	movl 61000 <malloc_readonly>,r9
   186e5:	04 00 59 
   186e8:	dd 58       	pushl r8
   186ea:	dd 59       	pushl r9
   186ec:	fb 02 cf a1 	calls $0x2,17d92 <find>
   186f0:	f6 
   186f1:	d0 50 57    	movl r0,r7
   186f4:	12 03       	bneq 186f9 <ofree+0x21>
   186f6:	31 41 01    	brw 1883a <ofree+0x162>
   186f9:	cb 8f 00 f0 	bicl3 $0xfffff000,(r0),r6
   186fd:	ff ff 60 56 
   18701:	13 03       	beql 18706 <ofree+0x2e>
   18703:	31 ac 01    	brw 188b2 <ofree+0x1da>
   18706:	d0 a0 04 50 	movl 0x4(r0),r0
   1870a:	d0 50 56    	movl r0,r6
   1870d:	d1 50 8f 00 	cmpl r0,$0x00000800
   18711:	08 00 00 
   18714:	1a 03       	bgtru 18719 <ofree+0x41>
   18716:	31 ec 00    	brw 18805 <ofree+0x12d>
   18719:	c2 ef 05 89 	subl2 61024 <malloc_readonly+0x24>,r0
   1871d:	04 00 50 
   18720:	d1 50 8f ff 	cmpl r0,$0x00000fff
   18724:	0f 00 00 
   18727:	1a 03       	bgtru 1872c <ofree+0x54>
   18729:	31 d3 00    	brw 187ff <ofree+0x127>
   1872c:	d1 67 58    	cmpl (r7),r8
   1872f:	13 0e       	beql 1873f <ofree+0x67>
   18731:	dd 58       	pushl r8
   18733:	9f ef 9d 2a 	pushab 2b1d6 <q.0+0x197>
   18737:	01 00 
   18739:	fb 02 cf 42 	calls $0x2,17180 <wrterror>
   1873d:	ea 
   1873e:	04          	ret
   1873f:	9e ef df 88 	movab 61024 <malloc_readonly+0x24>,r10
   18743:	04 00 5a 
   18746:	d0 6a 50    	movl (r10),r0
   18749:	13 10       	beql 1875b <ofree+0x83>
   1874b:	d1 56 50    	cmpl r6,r0
   1874e:	1e 03       	bcc 18753 <ofree+0x7b>
   18750:	31 9c 00    	brw 187ef <ofree+0x117>
   18753:	d5 ef b3 88 	tstl 6100c <malloc_readonly+0xc>
   18757:	04 00 
   18759:	13 5f       	beql 187ba <ofree+0xe2>
   1875b:	d0 ef b3 88 	movl 61014 <malloc_readonly+0x14>,r0
   1875f:	04 00 50 
   18762:	13 2f       	beql 18793 <ofree+0xbb>
   18764:	d5 ef a2 88 	tstl 6100c <malloc_readonly+0xc>
   18768:	04 00 
   1876a:	12 27       	bneq 18793 <ofree+0xbb>
   1876c:	d1 50 01    	cmpl r0,$0x1
   1876f:	13 42       	beql 187b3 <ofree+0xdb>
   18771:	9e c6 ff 0f 	movab 0xfff(r6),r0
   18775:	50 
   18776:	ca 8f ff 0f 	bicl2 $0x00000fff,r0
   1877a:	00 00 50 
   1877d:	c2 ef a1 88 	subl2 61024 <malloc_readonly+0x24>,r0
   18781:	04 00 50 
   18784:	dd 50       	pushl r0
   18786:	9a 8f df 7e 	movzbl $0xdf,-(sp)
   1878a:	dd 58       	pushl r8
   1878c:	fb 03 ef 65 	calls $0x3,168f8 <memset>
   18790:	e1 ff ff 
   18793:	9e c6 ff 0f 	movab 0xfff(r6),r0
   18797:	50 
   18798:	cb 8f ff 0f 	bicl3 $0x00000fff,r0,-(sp)
   1879c:	00 00 50 7e 
   187a0:	dd 58       	pushl r8
   187a2:	dd 59       	pushl r9
   187a4:	fb 03 cf 1d 	calls $0x3,172c6 <unmap>
   187a8:	eb 
   187a9:	dd 57       	pushl r7
   187ab:	dd 59       	pushl r9
   187ad:	fb 02 cf 98 	calls $0x2,17e4a <delete>
   187b1:	f6 
   187b2:	04          	ret
   187b3:	3c 8f 00 08 	movzwl $0x0800,r0
   187b7:	50 
   187b8:	11 ca       	brb 18784 <ofree+0xac>
   187ba:	dd 03       	pushl $0x3
   187bc:	dd 6a       	pushl (r10)
   187be:	9e c6 ff 0f 	movab 0xfff(r6),r0
   187c2:	50 
   187c3:	ca 8f ff 0f 	bicl2 $0x00000fff,r0
   187c7:	00 00 50 
   187ca:	c0 58 50    	addl2 r8,r0
   187cd:	c3 6a 50 7e 	subl3 (r10),r0,-(sp)
   187d1:	fb 03 ef 80 	calls $0x3,16a58 <_thread_sys_mprotect>
   187d5:	e2 ff ff 
   187d8:	d5 50       	tstl r0
   187da:	12 03       	bneq 187df <ofree+0x107>
   187dc:	31 7c ff    	brw 1875b <ofree+0x83>
   187df:	d4 7e       	clrf -(sp)
   187e1:	9f ef bf 29 	pushab 2b1a6 <q.0+0x167>
   187e5:	01 00 
   187e7:	fb 02 cf 94 	calls $0x2,17180 <wrterror>
   187eb:	e9 
   187ec:	31 6c ff    	brw 1875b <ofree+0x83>
   187ef:	d4 7e       	clrf -(sp)
   187f1:	9f ef ed 29 	pushab 2b1e4 <q.0+0x1a5>
   187f5:	01 00 
   187f7:	fb 02 cf 84 	calls $0x2,17180 <wrterror>
   187fb:	e9 
   187fc:	31 54 ff    	brw 18753 <ofree+0x7b>
   187ff:	d0 67 58    	movl (r7),r8
   18802:	31 3a ff    	brw 1873f <ofree+0x67>
   18805:	d5 ef 09 88 	tstl 61014 <malloc_readonly+0x14>
   18809:	04 00 
   1880b:	13 07       	beql 18814 <ofree+0x13c>
   1880d:	d5 50       	tstl r0
   1880f:	13 03       	beql 18814 <ofree+0x13c>
   18811:	31 8c 00    	brw 188a0 <ofree+0x1c8>
   18814:	d5 ef ee 87 	tstl 61008 <malloc_readonly+0x8>
   18818:	04 00 
   1881a:	13 29       	beql 18845 <ofree+0x16d>
   1881c:	d5 58       	tstl r8
   1881e:	13 19       	beql 18839 <ofree+0x161>
   18820:	dd 58       	pushl r8
   18822:	dd 59       	pushl r9
   18824:	fb 02 cf 69 	calls $0x2,17d92 <find>
   18828:	f5 
   18829:	d0 50 57    	movl r0,r7
   1882c:	13 0c       	beql 1883a <ofree+0x162>
   1882e:	dd 58       	pushl r8
   18830:	dd 50       	pushl r0
   18832:	dd 59       	pushl r9
   18834:	fb 03 cf 93 	calls $0x3,182cc <free_bytes>
   18838:	fa 
   18839:	04          	ret
   1883a:	dd 58       	pushl r8
   1883c:	9f ef ad 29 	pushab 2b1ef <q.0+0x1b0>
   18840:	01 00 
   18842:	31 f4 fe    	brw 18739 <ofree+0x61>
   18845:	dd 58       	pushl r8
   18847:	dd 57       	pushl r7
   18849:	dd 59       	pushl r9
   1884b:	fb 03 cf f4 	calls $0x3,18244 <find_chunknum>
   1884f:	f9 
   18850:	d1 50 8f ff 	cmpl r0,$0xffffffff
   18854:	ff ff ff 
   18857:	13 e0       	beql 18839 <ofree+0x161>
   18859:	d1 c9 44 09 	cmpl 0x944(r9),$0x1f
   1885d:	1f 
   1885e:	1a 37       	bgtru 18897 <ofree+0x1bf>
   18860:	c1 c9 44 09 	addl3 0x944(r9),r9,r0
   18864:	59 50 
   18866:	d6 c9 44 09 	incl 0x944(r9)
   1886a:	90 c0 48 09 	movb 0x948(r0),r1
   1886e:	51 
   1886f:	ca 8f f0 ff 	bicl2 $0xfffffff0,r1
   18873:	ff ff 51 
   18876:	d0 58 50    	movl r8,r0
   18879:	d0 41 c9 04 	movl 0x904(r9)[r1],r8
   1887d:	09 58 
   1887f:	d1 50 58    	cmpl r0,r8
   18882:	13 08       	beql 1888c <ofree+0x1b4>
   18884:	d0 50 41 c9 	movl r0,0x904(r9)[r1]
   18888:	04 09 
   1888a:	11 90       	brb 1881c <ofree+0x144>
   1888c:	dd 58       	pushl r8
   1888e:	9f ef 78 29 	pushab 2b20c <q.0+0x1cd>
   18892:	01 00 
   18894:	31 a2 fe    	brw 18739 <ofree+0x61>
   18897:	dd 59       	pushl r9
   18899:	fb 01 cf fe 	calls $0x1,1729c <rbytes_init>
   1889d:	e9 
   1889e:	11 c0       	brb 18860 <ofree+0x188>
   188a0:	dd 50       	pushl r0
   188a2:	9a 8f df 7e 	movzbl $0xdf,-(sp)
   188a6:	dd 58       	pushl r8
   188a8:	fb 03 ef 49 	calls $0x3,168f8 <memset>
   188ac:	e0 ff ff 
   188af:	31 62 ff    	brw 18814 <ofree+0x13c>
   188b2:	d1 56 01    	cmpl r6,$0x1
   188b5:	13 0b       	beql 188c2 <ofree+0x1ea>
   188b7:	c3 01 56 50 	subl3 $0x1,r6,r0
   188bb:	78 50 01 50 	ashl r0,$0x1,r0
   188bf:	31 48 fe    	brw 1870a <ofree+0x32>
   188c2:	d4 50       	clrf r0
   188c4:	31 43 fe    	brw 1870a <ofree+0x32>
   188c7:	01          	nop

000188c8 <free>:
   188c8:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   188ca:	c2 04 5e    	subl2 $0x4,sp
   188cd:	d0 ac 04 56 	movl 0x4(ap),r6
   188d1:	9e ef f1 80 	movab 109c8 <___errno>,r8
   188d5:	ff ff 58 
   188d8:	fb 00 68    	calls $0x0,(r8)
   188db:	d0 60 57    	movl (r0),r7
   188de:	d5 56       	tstl r6
   188e0:	13 6a       	beql 1894c <free+0x84>
   188e2:	d5 ef fc 37 	tstl 5c0e4 <__isthreaded>
   188e6:	04 00 
   188e8:	12 6c       	bneq 18956 <free+0x8e>
   188ea:	9e ef 28 29 	movab 2b218 <q.0+0x1d9>,62000 <malloc_func>
   188ee:	01 00 ef 0b 
   188f2:	97 04 00 
   188f5:	d5 ef 05 87 	tstl 61000 <malloc_readonly>
   188f9:	04 00 
   188fb:	12 1f       	bneq 1891c <free+0x54>
   188fd:	d5 ef e1 37 	tstl 5c0e4 <__isthreaded>
   18901:	04 00 
   18903:	12 0e       	bneq 18913 <free+0x4b>
   18905:	d4 7e       	clrf -(sp)
   18907:	9f ef 13 29 	pushab 2b220 <q.0+0x1e1>
   1890b:	01 00 
   1890d:	fb 02 cf 6e 	calls $0x2,17180 <wrterror>
   18911:	e8 
   18912:	04          	ret
   18913:	fb 00 ef c2 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   18917:	e1 ff ff 
   1891a:	11 e9       	brb 18905 <free+0x3d>
   1891c:	d6 ef e2 96 	incl 62004 <malloc_active>
   18920:	04 00 
   18922:	d1 ef dc 96 	cmpl 62004 <malloc_active>,$0x1
   18926:	04 00 01 
   18929:	13 06       	beql 18931 <free+0x69>
   1892b:	fb 00 cf 5e 	calls $0x0,1858e <malloc_recurse>
   1892f:	fc 
   18930:	04          	ret
   18931:	dd 56       	pushl r6
   18933:	fb 01 cf a0 	calls $0x1,186d8 <ofree>
   18937:	fd 
   18938:	d7 ef c6 96 	decl 62004 <malloc_active>
   1893c:	04 00 
   1893e:	d5 ef a0 37 	tstl 5c0e4 <__isthreaded>
   18942:	04 00 
   18944:	12 07       	bneq 1894d <free+0x85>
   18946:	fb 00 68    	calls $0x0,(r8)
   18949:	d0 57 60    	movl r7,(r0)
   1894c:	04          	ret
   1894d:	fb 00 ef 88 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   18951:	e1 ff ff 
   18954:	11 f0       	brb 18946 <free+0x7e>
   18956:	fb 00 ef 79 	calls $0x0,16ad6 <_weak__thread_malloc_lock>
   1895a:	e1 ff ff 
   1895d:	11 8b       	brb 188ea <free+0x22>
   1895f:	01          	nop

00018960 <orealloc>:
   18960:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   18962:	c2 18 5e    	subl2 $0x18,sp
   18965:	d0 ac 04 5a 	movl 0x4(ap),r10
   18969:	d0 ac 08 58 	movl 0x8(ap),r8
   1896d:	d0 ef 8d 86 	movl 61000 <malloc_readonly>,r11
   18971:	04 00 5b 
   18974:	d5 5a       	tstl r10
   18976:	12 03       	bneq 1897b <orealloc+0x1b>
   18978:	31 ff 02    	brw 18c7a <orealloc+0x31a>
   1897b:	dd 5a       	pushl r10
   1897d:	dd 5b       	pushl r11
   1897f:	fb 02 cf 0e 	calls $0x2,17d92 <find>
   18983:	f4 
   18984:	d0 50 59    	movl r0,r9
   18987:	12 03       	bneq 1898c <orealloc+0x2c>
   18989:	31 de 02    	brw 18c6a <orealloc+0x30a>
   1898c:	c3 ef 92 86 	subl3 61024 <malloc_readonly+0x24>,$0xffffefff,r0
   18990:	04 00 8f ff 
   18994:	ef ff ff 50 
   18998:	d1 58 50    	cmpl r8,r0
   1899b:	1f 03       	blssu 189a0 <orealloc+0x40>
   1899d:	31 bd 02    	brw 18c5d <orealloc+0x2fd>
   189a0:	cb 8f 00 f0 	bicl3 $0xfffff000,(r9),r6
   189a4:	ff ff 69 56 
   189a8:	13 03       	beql 189ad <orealloc+0x4d>
   189aa:	31 9b 02    	brw 18c48 <orealloc+0x2e8>
   189ad:	d0 a9 04 50 	movl 0x4(r9),r0
   189b1:	d0 50 56    	movl r0,r6
   189b4:	d0 50 ad f8 	movl r0,0xfffffff8(fp)
   189b8:	d1 50 8f 00 	cmpl r0,$0x00000800
   189bc:	08 00 00 
   189bf:	1b 12       	blequ 189d3 <orealloc+0x73>
   189c1:	9e ef 5d 86 	movab 61024 <malloc_readonly+0x24>,r7
   189c5:	04 00 57 
   189c8:	d1 50 67    	cmpl r0,(r7)
   189cb:	1e 03       	bcc 189d0 <orealloc+0x70>
   189cd:	31 68 02    	brw 18c38 <orealloc+0x2d8>
   189d0:	c2 67 56    	subl2 (r7),r6
   189d3:	d0 58 57    	movl r8,r7
   189d6:	d1 58 8f 00 	cmpl r8,$0x00000800
   189da:	08 00 00 
   189dd:	1b 08       	blequ 189e7 <orealloc+0x87>
   189df:	c1 58 ef 3e 	addl3 r8,61024 <malloc_readonly+0x24>,r7
   189e3:	86 04 00 57 
   189e7:	d1 58 8f 00 	cmpl r8,$0x00000800
   189eb:	08 00 00 
   189ee:	1b 11       	blequ 18a01 <orealloc+0xa1>
   189f0:	d1 56 8f 00 	cmpl r6,$0x00000800
   189f4:	08 00 00 
   189f7:	1b 08       	blequ 18a01 <orealloc+0xa1>
   189f9:	d1 5a 69    	cmpl r10,(r9)
   189fc:	12 03       	bneq 18a01 <orealloc+0xa1>
   189fe:	31 8a 00    	brw 18a8b <orealloc+0x12b>
   18a01:	d1 58 56    	cmpl r8,r6
   18a04:	1a 35       	bgtru 18a3b <orealloc+0xdb>
   18a06:	ed 01 1f 56 	cmpzv $0x1,$0x1f,r6,r8
   18a0a:	58 
   18a0b:	1e 2e       	bcc 18a3b <orealloc+0xdb>
   18a0d:	d5 ef 09 86 	tstl 6101c <malloc_readonly+0x1c>
   18a11:	04 00 
   18a13:	12 26       	bneq 18a3b <orealloc+0xdb>
   18a15:	d1 ef f9 85 	cmpl 61014 <malloc_readonly+0x14>,$0x2
   18a19:	04 00 02 
   18a1c:	13 04       	beql 18a22 <orealloc+0xc2>
   18a1e:	d0 5a 50    	movl r10,r0
   18a21:	04          	ret
   18a22:	d5 58       	tstl r8
   18a24:	13 f8       	beql 18a1e <orealloc+0xbe>
   18a26:	c3 58 56 7e 	subl3 r8,r6,-(sp)
   18a2a:	9a 8f d0 7e 	movzbl $0xd0,-(sp)
   18a2e:	c1 5a 58 7e 	addl3 r10,r8,-(sp)
   18a32:	fb 03 ef bf 	calls $0x3,168f8 <memset>
   18a36:	de ff ff 
   18a39:	11 e3       	brb 18a1e <orealloc+0xbe>
   18a3b:	d1 58 56    	cmpl r8,r6
   18a3e:	13 3f       	beql 18a7f <orealloc+0x11f>
   18a40:	dd ac 0c    	pushl 0xc(ap)
   18a43:	d4 7e       	clrf -(sp)
   18a45:	dd 58       	pushl r8
   18a47:	fb 03 cf b4 	calls $0x3,18400 <omalloc>
   18a4b:	f9 
   18a4c:	d0 50 57    	movl r0,r7
   18a4f:	13 2b       	beql 18a7c <orealloc+0x11c>
   18a51:	d5 58       	tstl r8
   18a53:	13 1c       	beql 18a71 <orealloc+0x111>
   18a55:	d5 56       	tstl r6
   18a57:	13 18       	beql 18a71 <orealloc+0x111>
   18a59:	d0 58 50    	movl r8,r0
   18a5c:	d1 58 56    	cmpl r8,r6
   18a5f:	1b 03       	blequ 18a64 <orealloc+0x104>
   18a61:	d0 56 50    	movl r6,r0
   18a64:	dd 50       	pushl r0
   18a66:	dd 5a       	pushl r10
   18a68:	dd 57       	pushl r7
   18a6a:	fb 03 ef 7d 	calls $0x3,166ee <memcpy>
   18a6e:	dc ff ff 
   18a71:	dd 5a       	pushl r10
   18a73:	fb 01 cf 60 	calls $0x1,186d8 <ofree>
   18a77:	fc 
   18a78:	d0 57 50    	movl r7,r0
   18a7b:	04          	ret
   18a7c:	d4 50       	clrf r0
   18a7e:	04          	ret
   18a7f:	d5 ef 97 85 	tstl 6101c <malloc_readonly+0x1c>
   18a83:	04 00 
   18a85:	12 b9       	bneq 18a40 <orealloc+0xe0>
   18a87:	d0 5a 50    	movl r10,r0
   18a8a:	04          	ret
   18a8b:	d5 ef 8b 85 	tstl 6101c <malloc_readonly+0x1c>
   18a8f:	04 00 
   18a91:	13 03       	beql 18a96 <orealloc+0x136>
   18a93:	31 6b ff    	brw 18a01 <orealloc+0xa1>
   18a96:	c1 ad f8 8f 	addl3 0xfffffff8(fp),$0x00000fff,r0
   18a9a:	ff 0f 00 00 
   18a9e:	50 
   18a9f:	cb 8f ff 0f 	bicl3 $0x00000fff,r0,0xfffffff4(fp)
   18aa3:	00 00 50 ad 
   18aa7:	f4 
   18aa8:	9e c7 ff 0f 	movab 0xfff(r7),r0
   18aac:	50 
   18aad:	cb 8f ff 0f 	bicl3 $0x00000fff,r0,0xfffffff0(fp)
   18ab1:	00 00 50 ad 
   18ab5:	f0 
   18ab6:	d1 ad f0 ad 	cmpl 0xfffffff0(fp),0xfffffff4(fp)
   18aba:	f4 
   18abb:	1a 03       	bgtru 18ac0 <orealloc+0x160>
   18abd:	31 d3 00    	brw 18b93 <orealloc+0x233>
   18ac0:	d5 ef 5e 85 	tstl 61024 <malloc_readonly+0x24>
   18ac4:	04 00 
   18ac6:	13 03       	beql 18acb <orealloc+0x16b>
   18ac8:	31 36 ff    	brw 18a01 <orealloc+0xa1>
   18acb:	c1 5a ad f4 	addl3 r10,0xfffffff4(fp),0xffffffec(fp)
   18acf:	ad ec 
   18ad1:	c3 ad f4 ad 	subl3 0xfffffff4(fp),0xfffffff0(fp),0xffffffe8(fp)
   18ad5:	f0 ad e8 
   18ad8:	d4 7e       	clrf -(sp)
   18ada:	dd ad e8    	pushl 0xffffffe8(fp)
   18add:	dd ad ec    	pushl 0xffffffec(fp)
   18ae0:	dd 5b       	pushl r11
   18ae2:	fb 04 cf 1d 	calls $0x4,17504 <map>
   18ae6:	ea 
   18ae7:	d0 50 57    	movl r0,r7
   18aea:	d1 50 ad ec 	cmpl r0,0xffffffec(fp)
   18aee:	13 64       	beql 18b54 <orealloc+0x1f4>
   18af0:	dd ad e8    	pushl 0xffffffe8(fp)
   18af3:	dd ad ec    	pushl 0xffffffec(fp)
   18af6:	dd 5b       	pushl r11
   18af8:	fb 03 cf 97 	calls $0x3,17494 <zapcacheregion>
   18afc:	e9 
   18afd:	7c 7e       	clrd -(sp)
   18aff:	d2 00 7e    	mcoml $0x0,-(sp)
   18b02:	3c 8f 12 10 	movzwl $0x1012,-(sp)
   18b06:	7e 
   18b07:	dd 03       	pushl $0x3
   18b09:	dd ad e8    	pushl 0xffffffe8(fp)
   18b0c:	dd ad ec    	pushl 0xffffffec(fp)
   18b0f:	fb 07 ef d0 	calls $0x7,19fe6 <_thread_sys_mquery>
   18b13:	14 00 00 
   18b16:	d1 50 ad ec 	cmpl r0,0xffffffec(fp)
   18b1a:	13 5a       	beql 18b76 <orealloc+0x216>
   18b1c:	d2 00 57    	mcoml $0x0,r7
   18b1f:	d1 57 ad ec 	cmpl r7,0xffffffec(fp)
   18b23:	13 2f       	beql 18b54 <orealloc+0x1f4>
   18b25:	d1 57 8f ff 	cmpl r7,$0xffffffff
   18b29:	ff ff ff 
   18b2c:	12 03       	bneq 18b31 <orealloc+0x1d1>
   18b2e:	31 d0 fe    	brw 18a01 <orealloc+0xa1>
   18b31:	dd ad e8    	pushl 0xffffffe8(fp)
   18b34:	dd 57       	pushl r7
   18b36:	fb 02 ef 8f 	calls $0x2,16acc <_thread_sys_munmap>
   18b3a:	df ff ff 
   18b3d:	d5 50       	tstl r0
   18b3f:	12 03       	bneq 18b44 <orealloc+0x1e4>
   18b41:	31 bd fe    	brw 18a01 <orealloc+0xa1>
   18b44:	dd 57       	pushl r7
   18b46:	9f ef 87 25 	pushab 2b0d3 <q.0+0x94>
   18b4a:	01 00 
   18b4c:	fb 02 cf 2f 	calls $0x2,17180 <wrterror>
   18b50:	e6 
   18b51:	31 ad fe    	brw 18a01 <orealloc+0xa1>
   18b54:	d1 ef ba 84 	cmpl 61014 <malloc_readonly+0x14>,$0x2
   18b58:	04 00 02 
   18b5b:	13 07       	beql 18b64 <orealloc+0x204>
   18b5d:	d0 58 a9 04 	movl r8,0x4(r9)
   18b61:	31 ba fe    	brw 18a1e <orealloc+0xbe>
   18b64:	dd ad e8    	pushl 0xffffffe8(fp)
   18b67:	9a 8f d0 7e 	movzbl $0xd0,-(sp)
   18b6b:	dd 57       	pushl r7
   18b6d:	fb 03 ef 84 	calls $0x3,168f8 <memset>
   18b71:	dd ff ff 
   18b74:	11 e7       	brb 18b5d <orealloc+0x1fd>
   18b76:	7c 7e       	clrd -(sp)
   18b78:	d2 00 7e    	mcoml $0x0,-(sp)
   18b7b:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   18b7f:	7e 
   18b80:	dd 03       	pushl $0x3
   18b82:	dd ad e8    	pushl 0xffffffe8(fp)
   18b85:	dd 50       	pushl r0
   18b87:	fb 07 ef d4 	calls $0x7,16a62 <_thread_sys_mmap>
   18b8b:	de ff ff 
   18b8e:	d0 50 57    	movl r0,r7
   18b91:	11 8c       	brb 18b1f <orealloc+0x1bf>
   18b93:	d1 ad f0 ad 	cmpl 0xfffffff0(fp),0xfffffff4(fp)
   18b97:	f4 
   18b98:	1e 72       	bcc 18c0c <orealloc+0x2ac>
   18b9a:	9e ef 84 84 	movab 61024 <malloc_readonly+0x24>,r6
   18b9e:	04 00 56 
   18ba1:	d0 66 51    	movl (r6),r1
   18ba4:	12 19       	bneq 18bbf <orealloc+0x25f>
   18ba6:	c3 ad f0 ad 	subl3 0xfffffff0(fp),0xfffffff4(fp),-(sp)
   18baa:	f4 7e 
   18bac:	c1 5a ad f0 	addl3 r10,0xfffffff0(fp),-(sp)
   18bb0:	7e 
   18bb1:	dd 5b       	pushl r11
   18bb3:	fb 03 cf 0e 	calls $0x3,172c6 <unmap>
   18bb7:	e7 
   18bb8:	d0 57 a9 04 	movl r7,0x4(r9)
   18bbc:	31 5f fe    	brw 18a1e <orealloc+0xbe>
   18bbf:	dd 03       	pushl $0x3
   18bc1:	dd 51       	pushl r1
   18bc3:	c1 5a ad f4 	addl3 r10,0xfffffff4(fp),r0
   18bc7:	50 
   18bc8:	c3 51 50 7e 	subl3 r1,r0,-(sp)
   18bcc:	9e ef 86 de 	movab 16a58 <_thread_sys_mprotect>,r8
   18bd0:	ff ff 58 
   18bd3:	fb 03 68    	calls $0x3,(r8)
   18bd6:	d5 50       	tstl r0
   18bd8:	12 23       	bneq 18bfd <orealloc+0x29d>
   18bda:	d4 7e       	clrf -(sp)
   18bdc:	dd 66       	pushl (r6)
   18bde:	c1 5a ad f0 	addl3 r10,0xfffffff0(fp),r0
   18be2:	50 
   18be3:	c3 66 50 7e 	subl3 (r6),r0,-(sp)
   18be7:	fb 03 68    	calls $0x3,(r8)
   18bea:	d5 50       	tstl r0
   18bec:	13 b8       	beql 18ba6 <orealloc+0x246>
   18bee:	d4 7e       	clrf -(sp)
   18bf0:	9f ef b0 25 	pushab 2b1a6 <q.0+0x167>
   18bf4:	01 00 
   18bf6:	fb 02 cf 85 	calls $0x2,17180 <wrterror>
   18bfa:	e5 
   18bfb:	11 a9       	brb 18ba6 <orealloc+0x246>
   18bfd:	d4 7e       	clrf -(sp)
   18bff:	9f ef a1 25 	pushab 2b1a6 <q.0+0x167>
   18c03:	01 00 
   18c05:	fb 02 cf 76 	calls $0x2,17180 <wrterror>
   18c09:	e5 
   18c0a:	11 ce       	brb 18bda <orealloc+0x27a>
   18c0c:	d1 58 56    	cmpl r8,r6
   18c0f:	1b a7       	blequ 18bb8 <orealloc+0x258>
   18c11:	d1 ef fd 83 	cmpl 61014 <malloc_readonly+0x14>,$0x2
   18c15:	04 00 02 
   18c18:	12 9e       	bneq 18bb8 <orealloc+0x258>
   18c1a:	c3 ef 04 84 	subl3 61024 <malloc_readonly+0x24>,0xfffffff0(fp),r0
   18c1e:	04 00 ad f0 
   18c22:	50 
   18c23:	c3 58 50 7e 	subl3 r8,r0,-(sp)
   18c27:	9a 8f d0 7e 	movzbl $0xd0,-(sp)
   18c2b:	c1 5a 58 7e 	addl3 r10,r8,-(sp)
   18c2f:	fb 03 ef c2 	calls $0x3,168f8 <memset>
   18c33:	dc ff ff 
   18c36:	11 80       	brb 18bb8 <orealloc+0x258>
   18c38:	d4 7e       	clrf -(sp)
   18c3a:	9f ef a4 25 	pushab 2b1e4 <q.0+0x1a5>
   18c3e:	01 00 
   18c40:	fb 02 cf 3b 	calls $0x2,17180 <wrterror>
   18c44:	e5 
   18c45:	31 88 fd    	brw 189d0 <orealloc+0x70>
   18c48:	d1 56 01    	cmpl r6,$0x1
   18c4b:	13 0b       	beql 18c58 <orealloc+0x2f8>
   18c4d:	c3 01 56 50 	subl3 $0x1,r6,r0
   18c51:	78 50 01 50 	ashl r0,$0x1,r0
   18c55:	31 59 fd    	brw 189b1 <orealloc+0x51>
   18c58:	d4 50       	clrf r0
   18c5a:	31 54 fd    	brw 189b1 <orealloc+0x51>
   18c5d:	fb 00 ef 64 	calls $0x0,109c8 <___errno>
   18c61:	7d ff ff 
   18c64:	d0 0c 60    	movl $0xc,(r0)
   18c67:	31 12 fe    	brw 18a7c <orealloc+0x11c>
   18c6a:	dd 5a       	pushl r10
   18c6c:	9f ef 7d 25 	pushab 2b1ef <q.0+0x1b0>
   18c70:	01 00 
   18c72:	fb 02 cf 09 	calls $0x2,17180 <wrterror>
   18c76:	e5 
   18c77:	31 02 fe    	brw 18a7c <orealloc+0x11c>
   18c7a:	dd ac 0c    	pushl 0xc(ap)
   18c7d:	d4 7e       	clrf -(sp)
   18c7f:	dd 58       	pushl r8
   18c81:	fb 03 cf 7a 	calls $0x3,18400 <omalloc>
   18c85:	f7 
   18c86:	04          	ret
   18c87:	01          	nop

00018c88 <realloc>:
   18c88:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   18c8a:	c2 04 5e    	subl2 $0x4,sp
   18c8d:	fb 00 ef 34 	calls $0x0,109c8 <___errno>
   18c91:	7d ff ff 
   18c94:	d0 60 57    	movl (r0),r7
   18c97:	d5 ef 47 34 	tstl 5c0e4 <__isthreaded>
   18c9b:	04 00 
   18c9d:	13 03       	beql 18ca2 <realloc+0x1a>
   18c9f:	31 93 00    	brw 18d35 <realloc+0xad>
   18ca2:	9e ef 98 25 	movab 2b240 <q.0+0x201>,62000 <malloc_func>
   18ca6:	01 00 ef 53 
   18caa:	93 04 00 
   18cad:	d5 ef 4d 83 	tstl 61000 <malloc_readonly>
   18cb1:	04 00 
   18cb3:	13 75       	beql 18d2a <realloc+0xa2>
   18cb5:	d6 ef 49 93 	incl 62004 <malloc_active>
   18cb9:	04 00 
   18cbb:	d1 ef 43 93 	cmpl 62004 <malloc_active>,$0x1
   18cbf:	04 00 01 
   18cc2:	12 5e       	bneq 18d22 <realloc+0x9a>
   18cc4:	d4 7e       	clrf -(sp)
   18cc6:	dd ac 08    	pushl 0x8(ap)
   18cc9:	dd ac 04    	pushl 0x4(ap)
   18ccc:	fb 03 cf 8f 	calls $0x3,18960 <orealloc>
   18cd0:	fc 
   18cd1:	d0 50 56    	movl r0,r6
   18cd4:	d7 ef 2a 93 	decl 62004 <malloc_active>
   18cd8:	04 00 
   18cda:	d5 ef 04 34 	tstl 5c0e4 <__isthreaded>
   18cde:	04 00 
   18ce0:	12 37       	bneq 18d19 <realloc+0x91>
   18ce2:	d5 56       	tstl r6
   18ce4:	13 12       	beql 18cf8 <realloc+0x70>
   18ce6:	d5 56       	tstl r6
   18ce8:	13 0a       	beql 18cf4 <realloc+0x6c>
   18cea:	fb 00 ef d7 	calls $0x0,109c8 <___errno>
   18cee:	7c ff ff 
   18cf1:	d0 57 60    	movl r7,(r0)
   18cf4:	d0 56 50    	movl r6,r0
   18cf7:	04          	ret
   18cf8:	d5 ef 22 83 	tstl 61020 <malloc_readonly+0x20>
   18cfc:	04 00 
   18cfe:	13 e6       	beql 18ce6 <realloc+0x5e>
   18d00:	d4 7e       	clrf -(sp)
   18d02:	9f ef b6 24 	pushab 2b1be <q.0+0x17f>
   18d06:	01 00 
   18d08:	fb 02 cf 73 	calls $0x2,17180 <wrterror>
   18d0c:	e4 
   18d0d:	fb 00 ef b4 	calls $0x0,109c8 <___errno>
   18d11:	7c ff ff 
   18d14:	d0 0c 60    	movl $0xc,(r0)
   18d17:	11 cd       	brb 18ce6 <realloc+0x5e>
   18d19:	fb 00 ef bc 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   18d1d:	dd ff ff 
   18d20:	11 c0       	brb 18ce2 <realloc+0x5a>
   18d22:	fb 00 cf 67 	calls $0x0,1858e <malloc_recurse>
   18d26:	f8 
   18d27:	d4 50       	clrf r0
   18d29:	04          	ret
   18d2a:	fb 00 cf a5 	calls $0x0,185d4 <malloc_init>
   18d2e:	f8 
   18d2f:	d5 50       	tstl r0
   18d31:	13 82       	beql 18cb5 <realloc+0x2d>
   18d33:	11 f2       	brb 18d27 <realloc+0x9f>
   18d35:	fb 00 ef 9a 	calls $0x0,16ad6 <_weak__thread_malloc_lock>
   18d39:	dd ff ff 
   18d3c:	31 63 ff    	brw 18ca2 <realloc+0x1a>
   18d3f:	01          	nop

00018d40 <calloc>:
   18d40:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   18d42:	c2 04 5e    	subl2 $0x4,sp
   18d45:	d0 ac 04 56 	movl 0x4(ap),r6
   18d49:	d0 ac 08 57 	movl 0x8(ap),r7
   18d4d:	fb 00 ef 74 	calls $0x0,109c8 <___errno>
   18d51:	7c ff ff 
   18d54:	d0 60 58    	movl (r0),r8
   18d57:	d5 ef 87 33 	tstl 5c0e4 <__isthreaded>
   18d5b:	04 00 
   18d5d:	13 03       	beql 18d62 <calloc+0x22>
   18d5f:	31 f7 00    	brw 18e59 <calloc+0x119>
   18d62:	9e ef e3 24 	movab 2b24b <q.0+0x20c>,62000 <malloc_func>
   18d66:	01 00 ef 93 
   18d6a:	92 04 00 
   18d6d:	d5 ef 8d 82 	tstl 61000 <malloc_readonly>
   18d71:	04 00 
   18d73:	12 03       	bneq 18d78 <calloc+0x38>
   18d75:	31 d3 00    	brw 18e4b <calloc+0x10b>
   18d78:	d1 56 8f ff 	cmpl r6,$0x0000ffff
   18d7c:	ff 00 00 
   18d7f:	1a 09       	bgtru 18d8a <calloc+0x4a>
   18d81:	d1 57 8f ff 	cmpl r7,$0x0000ffff
   18d85:	ff 00 00 
   18d88:	1b 15       	blequ 18d9f <calloc+0x5f>
   18d8a:	d5 56       	tstl r6
   18d8c:	13 11       	beql 18d9f <calloc+0x5f>
   18d8e:	dd 56       	pushl r6
   18d90:	d2 00 7e    	mcoml $0x0,-(sp)
   18d93:	fb 02 ef 4a 	calls $0x2,15ce4 <__udiv>
   18d97:	cf ff ff 
   18d9a:	d1 50 57    	cmpl r0,r7
   18d9d:	1f 78       	blssu 18e17 <calloc+0xd7>
   18d9f:	d6 ef 5f 92 	incl 62004 <malloc_active>
   18da3:	04 00 
   18da5:	d0 ef 59 92 	movl 62004 <malloc_active>,r0
   18da9:	04 00 50 
   18dac:	d1 50 01    	cmpl r0,$0x1
   18daf:	12 5e       	bneq 18e0f <calloc+0xcf>
   18db1:	d4 7e       	clrf -(sp)
   18db3:	dd 50       	pushl r0
   18db5:	c5 57 56 7e 	mull3 r7,r6,-(sp)
   18db9:	fb 03 cf 42 	calls $0x3,18400 <omalloc>
   18dbd:	f6 
   18dbe:	d0 50 56    	movl r0,r6
   18dc1:	d7 ef 3d 92 	decl 62004 <malloc_active>
   18dc5:	04 00 
   18dc7:	d5 ef 17 33 	tstl 5c0e4 <__isthreaded>
   18dcb:	04 00 
   18dcd:	12 37       	bneq 18e06 <calloc+0xc6>
   18dcf:	d5 56       	tstl r6
   18dd1:	13 12       	beql 18de5 <calloc+0xa5>
   18dd3:	d5 56       	tstl r6
   18dd5:	13 0a       	beql 18de1 <calloc+0xa1>
   18dd7:	fb 00 ef ea 	calls $0x0,109c8 <___errno>
   18ddb:	7b ff ff 
   18dde:	d0 58 60    	movl r8,(r0)
   18de1:	d0 56 50    	movl r6,r0
   18de4:	04          	ret
   18de5:	d5 ef 35 82 	tstl 61020 <malloc_readonly+0x20>
   18de9:	04 00 
   18deb:	13 e6       	beql 18dd3 <calloc+0x93>
   18ded:	d4 7e       	clrf -(sp)
   18def:	9f ef c9 23 	pushab 2b1be <q.0+0x17f>
   18df3:	01 00 
   18df5:	fb 02 cf 86 	calls $0x2,17180 <wrterror>
   18df9:	e3 
   18dfa:	fb 00 ef c7 	calls $0x0,109c8 <___errno>
   18dfe:	7b ff ff 
   18e01:	d0 0c 60    	movl $0xc,(r0)
   18e04:	11 cd       	brb 18dd3 <calloc+0x93>
   18e06:	fb 00 ef cf 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   18e0a:	dc ff ff 
   18e0d:	11 c0       	brb 18dcf <calloc+0x8f>
   18e0f:	fb 00 cf 7a 	calls $0x0,1858e <malloc_recurse>
   18e13:	f7 
   18e14:	d4 50       	clrf r0
   18e16:	04          	ret
   18e17:	d5 ef c7 32 	tstl 5c0e4 <__isthreaded>
   18e1b:	04 00 
   18e1d:	12 23       	bneq 18e42 <calloc+0x102>
   18e1f:	d5 ef fb 81 	tstl 61020 <malloc_readonly+0x20>
   18e23:	04 00 
   18e25:	12 0c       	bneq 18e33 <calloc+0xf3>
   18e27:	fb 00 ef 9a 	calls $0x0,109c8 <___errno>
   18e2b:	7b ff ff 
   18e2e:	d0 0c 60    	movl $0xc,(r0)
   18e31:	11 e1       	brb 18e14 <calloc+0xd4>
   18e33:	d4 7e       	clrf -(sp)
   18e35:	9f ef 83 23 	pushab 2b1be <q.0+0x17f>
   18e39:	01 00 
   18e3b:	fb 02 cf 40 	calls $0x2,17180 <wrterror>
   18e3f:	e3 
   18e40:	11 e5       	brb 18e27 <calloc+0xe7>
   18e42:	fb 00 ef 93 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   18e46:	dc ff ff 
   18e49:	11 d4       	brb 18e1f <calloc+0xdf>
   18e4b:	fb 00 cf 84 	calls $0x0,185d4 <malloc_init>
   18e4f:	f7 
   18e50:	d5 50       	tstl r0
   18e52:	12 03       	bneq 18e57 <calloc+0x117>
   18e54:	31 21 ff    	brw 18d78 <calloc+0x38>
   18e57:	11 bb       	brb 18e14 <calloc+0xd4>
   18e59:	fb 00 ef 76 	calls $0x0,16ad6 <_weak__thread_malloc_lock>
   18e5d:	dc ff ff 
   18e60:	31 ff fe    	brw 18d62 <calloc+0x22>
   18e63:	01          	nop

00018e64 <mapalign>:
   18e64:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   18e66:	c2 04 5e    	subl2 $0x4,sp
   18e69:	d0 ac 08 56 	movl 0x8(ap),r6
   18e6d:	d0 ac 0c 58 	movl 0xc(ap),r8
   18e71:	d1 56 8f ff 	cmpl r6,$0x00000fff
   18e75:	0f 00 00 
   18e78:	1b 09       	blequ 18e83 <mapalign+0x1f>
   18e7a:	ce 56 57    	mnegl r6,r7
   18e7d:	cb 57 56 50 	bicl3 r7,r6,r0
   18e81:	13 11       	beql 18e94 <mapalign+0x30>
   18e83:	d4 7e       	clrf -(sp)
   18e85:	9f ef ca 23 	pushab 2b255 <q.0+0x216>
   18e89:	01 00 
   18e8b:	fb 02 cf f0 	calls $0x2,17180 <wrterror>
   18e8f:	e2 
   18e90:	d2 00 50    	mcoml $0x0,r0
   18e93:	04          	ret
   18e94:	9e c8 ff 0f 	movab 0xfff(r8),r0
   18e98:	50 
   18e99:	ca 8f ff 0f 	bicl2 $0x00000fff,r0
   18e9d:	00 00 50 
   18ea0:	d1 58 50    	cmpl r8,r0
   18ea3:	13 0a       	beql 18eaf <mapalign+0x4b>
   18ea5:	d4 7e       	clrf -(sp)
   18ea7:	9f ef bf 23 	pushab 2b26c <q.0+0x22d>
   18eab:	01 00 
   18ead:	11 dc       	brb 18e8b <mapalign+0x27>
   18eaf:	d2 58 50    	mcoml r8,r0
   18eb2:	d1 56 50    	cmpl r6,r0
   18eb5:	1a d9       	bgtru 18e90 <mapalign+0x2c>
   18eb7:	dd ac 10    	pushl 0x10(ap)
   18eba:	c1 58 56 7e 	addl3 r8,r6,-(sp)
   18ebe:	d4 7e       	clrf -(sp)
   18ec0:	dd ac 04    	pushl 0x4(ap)
   18ec3:	fb 04 cf 3c 	calls $0x4,17504 <map>
   18ec7:	e6 
   18ec8:	d0 50 59    	movl r0,r9
   18ecb:	d1 50 8f ff 	cmpl r0,$0xffffffff
   18ecf:	ff ff ff 
   18ed2:	13 3d       	beql 18f11 <mapalign+0xad>
   18ed4:	9e 40 a6 ff 	movab 0xffffffff(r6)[r0],r0
   18ed8:	50 
   18ed9:	d2 50 50    	mcoml r0,r0
   18edc:	ca 50 57    	bicl2 r0,r7
   18edf:	d1 57 59    	cmpl r7,r9
   18ee2:	13 11       	beql 18ef5 <mapalign+0x91>
   18ee4:	c3 59 57 7e 	subl3 r9,r7,-(sp)
   18ee8:	dd 59       	pushl r9
   18eea:	fb 02 ef db 	calls $0x2,16acc <_thread_sys_munmap>
   18eee:	db ff ff 
   18ef1:	d5 50       	tstl r0
   18ef3:	12 2c       	bneq 18f21 <mapalign+0xbd>
   18ef5:	c3 59 57 50 	subl3 r9,r7,r0
   18ef9:	c3 50 56 7e 	subl3 r0,r6,-(sp)
   18efd:	c1 57 58 56 	addl3 r7,r8,r6
   18f01:	dd 56       	pushl r6
   18f03:	fb 02 ef c2 	calls $0x2,16acc <_thread_sys_munmap>
   18f07:	db ff ff 
   18f0a:	d5 50       	tstl r0
   18f0c:	12 04       	bneq 18f12 <mapalign+0xae>
   18f0e:	d0 57 50    	movl r7,r0
   18f11:	04          	ret
   18f12:	dd 56       	pushl r6
   18f14:	9f ef b9 21 	pushab 2b0d3 <q.0+0x94>
   18f18:	01 00 
   18f1a:	fb 02 cf 61 	calls $0x2,17180 <wrterror>
   18f1e:	e2 
   18f1f:	11 ed       	brb 18f0e <mapalign+0xaa>
   18f21:	dd 59       	pushl r9
   18f23:	9f ef aa 21 	pushab 2b0d3 <q.0+0x94>
   18f27:	01 00 
   18f29:	fb 02 cf 52 	calls $0x2,17180 <wrterror>
   18f2d:	e2 
   18f2e:	11 c5       	brb 18ef5 <mapalign+0x91>

00018f30 <omemalign>:
   18f30:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   18f32:	c2 04 5e    	subl2 $0x4,sp
   18f35:	d0 ac 04 52 	movl 0x4(ap),r2
   18f39:	d0 ac 08 56 	movl 0x8(ap),r6
   18f3d:	d0 ac 0c 5a 	movl 0xc(ap),r10
   18f41:	d0 ac 10 5b 	movl 0x10(ap),r11
   18f45:	d0 ef b5 80 	movl 61000 <malloc_readonly>,r8
   18f49:	04 00 58 
   18f4c:	d1 52 8f 00 	cmpl r2,$0x00001000
   18f50:	10 00 00 
   18f53:	1a 14       	bgtru 18f69 <omemalign+0x39>
   18f55:	d1 56 52    	cmpl r6,r2
   18f58:	1e 03       	bcc 18f5d <omemalign+0x2d>
   18f5a:	d0 52 56    	movl r2,r6
   18f5d:	dd 5b       	pushl r11
   18f5f:	dd 5a       	pushl r10
   18f61:	dd 56       	pushl r6
   18f63:	fb 03 cf 98 	calls $0x3,18400 <omalloc>
   18f67:	f4 
   18f68:	04          	ret
   18f69:	d0 ef b5 80 	movl 61024 <malloc_readonly+0x24>,r1
   18f6d:	04 00 51 
   18f70:	c3 51 8f ff 	subl3 r1,$0xffffefff,r0
   18f74:	ef ff ff 50 
   18f78:	d1 56 50    	cmpl r6,r0
   18f7b:	1f 03       	blssu 18f80 <omemalign+0x50>
   18f7d:	31 ae 00    	brw 1902e <omemalign+0xfe>
   18f80:	c0 51 56    	addl2 r1,r6
   18f83:	9e c6 ff 0f 	movab 0xfff(r6),r0
   18f87:	50 
   18f88:	cb 8f ff 0f 	bicl3 $0x00000fff,r0,r9
   18f8c:	00 00 50 59 
   18f90:	dd 5a       	pushl r10
   18f92:	dd 59       	pushl r9
   18f94:	dd 52       	pushl r2
   18f96:	dd 58       	pushl r8
   18f98:	fb 04 cf c7 	calls $0x4,18e64 <mapalign>
   18f9c:	fe 
   18f9d:	d0 50 57    	movl r0,r7
   18fa0:	12 03       	bneq 18fa5 <omemalign+0x75>
   18fa2:	31 89 00    	brw 1902e <omemalign+0xfe>
   18fa5:	dd 5b       	pushl r11
   18fa7:	dd 56       	pushl r6
   18fa9:	dd 50       	pushl r0
   18fab:	dd 58       	pushl r8
   18fad:	fb 04 cf 56 	calls $0x4,17d08 <insert>
   18fb1:	ed 
   18fb2:	d5 50       	tstl r0
   18fb4:	12 6d       	bneq 19023 <omemalign+0xf3>
   18fb6:	d0 ef 68 80 	movl 61024 <malloc_readonly+0x24>,r1
   18fba:	04 00 51 
   18fbd:	12 3e       	bneq 18ffd <omemalign+0xcd>
   18fbf:	d1 ef 4f 80 	cmpl 61014 <malloc_readonly+0x14>,$0x2
   18fc3:	04 00 02 
   18fc6:	13 04       	beql 18fcc <omemalign+0x9c>
   18fc8:	d0 57 50    	movl r7,r0
   18fcb:	04          	ret
   18fcc:	d5 5a       	tstl r10
   18fce:	13 1d       	beql 18fed <omemalign+0xbd>
   18fd0:	c3 56 59 7e 	subl3 r6,r9,-(sp)
   18fd4:	9a 8f d0 7e 	movzbl $0xd0,-(sp)
   18fd8:	c1 57 56 50 	addl3 r7,r6,r0
   18fdc:	c3 ef 42 80 	subl3 61024 <malloc_readonly+0x24>,r0,-(sp)
   18fe0:	04 00 50 7e 
   18fe4:	fb 03 ef 0d 	calls $0x3,168f8 <memset>
   18fe8:	d9 ff ff 
   18feb:	11 db       	brb 18fc8 <omemalign+0x98>
   18fed:	c3 ef 31 80 	subl3 61024 <malloc_readonly+0x24>,r9,-(sp)
   18ff1:	04 00 59 7e 
   18ff5:	9a 8f d0 7e 	movzbl $0xd0,-(sp)
   18ff9:	dd 57       	pushl r7
   18ffb:	11 e7       	brb 18fe4 <omemalign+0xb4>
   18ffd:	d4 7e       	clrf -(sp)
   18fff:	dd 51       	pushl r1
   19001:	c1 57 59 50 	addl3 r7,r9,r0
   19005:	c3 51 50 7e 	subl3 r1,r0,-(sp)
   19009:	fb 03 ef 48 	calls $0x3,16a58 <_thread_sys_mprotect>
   1900d:	da ff ff 
   19010:	d5 50       	tstl r0
   19012:	13 ab       	beql 18fbf <omemalign+0x8f>
   19014:	d4 7e       	clrf -(sp)
   19016:	9f ef 8a 21 	pushab 2b1a6 <q.0+0x167>
   1901a:	01 00 
   1901c:	fb 02 cf 5f 	calls $0x2,17180 <wrterror>
   19020:	e1 
   19021:	11 9c       	brb 18fbf <omemalign+0x8f>
   19023:	dd 59       	pushl r9
   19025:	dd 57       	pushl r7
   19027:	dd 58       	pushl r8
   19029:	fb 03 cf 98 	calls $0x3,172c6 <unmap>
   1902d:	e2 
   1902e:	fb 00 ef 93 	calls $0x0,109c8 <___errno>
   19032:	79 ff ff 
   19035:	d0 0c 60    	movl $0xc,(r0)
   19038:	d4 50       	clrf r0
   1903a:	04          	ret
   1903b:	01          	nop

0001903c <posix_memalign>:
   1903c:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   1903e:	c2 04 5e    	subl2 $0x4,sp
   19041:	d0 ac 08 56 	movl 0x8(ap),r6
   19045:	9e ef 7d 79 	movab 109c8 <___errno>,r7
   19049:	ff ff 57 
   1904c:	fb 00 67    	calls $0x0,(r7)
   1904f:	d0 60 58    	movl (r0),r8
   19052:	ce 56 50    	mnegl r6,r0
   19055:	cb 50 56 50 	bicl3 r0,r6,r0
   19059:	12 05       	bneq 19060 <posix_memalign+0x24>
   1905b:	d1 56 03    	cmpl r6,$0x3
   1905e:	1a 04       	bgtru 19064 <posix_memalign+0x28>
   19060:	d0 16 50    	movl $0x16,r0
   19063:	04          	ret
   19064:	d5 ef 7a 30 	tstl 5c0e4 <__isthreaded>
   19068:	04 00 
   1906a:	13 03       	beql 1906f <posix_memalign+0x33>
   1906c:	31 a5 00    	brw 19114 <posix_memalign+0xd8>
   1906f:	9e ef 06 22 	movab 2b27b <q.0+0x23c>,62000 <malloc_func>
   19073:	01 00 ef 86 
   19077:	8f 04 00 
   1907a:	d5 ef 80 7f 	tstl 61000 <malloc_readonly>
   1907e:	04 00 
   19080:	12 03       	bneq 19085 <posix_memalign+0x49>
   19082:	31 81 00    	brw 19106 <posix_memalign+0xca>
   19085:	d6 ef 79 8f 	incl 62004 <malloc_active>
   19089:	04 00 
   1908b:	d1 ef 73 8f 	cmpl 62004 <malloc_active>,$0x1
   1908f:	04 00 01 
   19092:	13 1c       	beql 190b0 <posix_memalign+0x74>
   19094:	fb 00 cf f5 	calls $0x0,1858e <malloc_recurse>
   19098:	f4 
   19099:	9e ef 29 79 	movab 109c8 <___errno>,r6
   1909d:	ff ff 56 
   190a0:	fb 00 66    	calls $0x0,(r6)
   190a3:	d0 60 57    	movl (r0),r7
   190a6:	fb 00 66    	calls $0x0,(r6)
   190a9:	d0 58 60    	movl r8,(r0)
   190ac:	d0 57 50    	movl r7,r0
   190af:	04          	ret
   190b0:	d4 7e       	clrf -(sp)
   190b2:	d4 7e       	clrf -(sp)
   190b4:	dd ac 0c    	pushl 0xc(ap)
   190b7:	dd 56       	pushl r6
   190b9:	fb 04 cf 72 	calls $0x4,18f30 <omemalign>
   190bd:	fe 
   190be:	d0 50 56    	movl r0,r6
   190c1:	d7 ef 3d 8f 	decl 62004 <malloc_active>
   190c5:	04 00 
   190c7:	d5 ef 17 30 	tstl 5c0e4 <__isthreaded>
   190cb:	04 00 
   190cd:	12 2e       	bneq 190fd <posix_memalign+0xc1>
   190cf:	d5 56       	tstl r6
   190d1:	13 0d       	beql 190e0 <posix_memalign+0xa4>
   190d3:	fb 00 67    	calls $0x0,(r7)
   190d6:	d0 58 60    	movl r8,(r0)
   190d9:	d0 56 bc 04 	movl r6,*0x4(ap)
   190dd:	d4 50       	clrf r0
   190df:	04          	ret
   190e0:	d5 ef 3a 7f 	tstl 61020 <malloc_readonly+0x20>
   190e4:	04 00 
   190e6:	13 b1       	beql 19099 <posix_memalign+0x5d>
   190e8:	d4 7e       	clrf -(sp)
   190ea:	9f ef ce 20 	pushab 2b1be <q.0+0x17f>
   190ee:	01 00 
   190f0:	fb 02 cf 8b 	calls $0x2,17180 <wrterror>
   190f4:	e0 
   190f5:	fb 00 67    	calls $0x0,(r7)
   190f8:	d0 0c 60    	movl $0xc,(r0)
   190fb:	11 9c       	brb 19099 <posix_memalign+0x5d>
   190fd:	fb 00 ef d8 	calls $0x0,16adc <_weak__thread_malloc_unlock>
   19101:	d9 ff ff 
   19104:	11 c9       	brb 190cf <posix_memalign+0x93>
   19106:	fb 00 cf c9 	calls $0x0,185d4 <malloc_init>
   1910a:	f4 
   1910b:	d5 50       	tstl r0
   1910d:	12 03       	bneq 19112 <posix_memalign+0xd6>
   1910f:	31 73 ff    	brw 19085 <posix_memalign+0x49>
   19112:	11 85       	brb 19099 <posix_memalign+0x5d>
   19114:	fb 00 ef bb 	calls $0x0,16ad6 <_weak__thread_malloc_lock>
   19118:	d9 ff ff 
   1911b:	31 51 ff    	brw 1906f <posix_memalign+0x33>

0001911e <arc4random_uniform>:
   1911e:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   19120:	c2 04 5e    	subl2 $0x4,sp
   19123:	d0 ac 04 57 	movl 0x4(ap),r7
   19127:	d1 57 01    	cmpl r7,$0x1
   1912a:	1a 03       	bgtru 1912f <arc4random_uniform+0x11>
   1912c:	d4 50       	clrf r0
   1912e:	04          	ret
   1912f:	dd 57       	pushl r7
   19131:	ce 57 7e    	mnegl r7,-(sp)
   19134:	fb 02 ef 05 	calls $0x2,15d40 <__urem>
   19138:	cc ff ff 
   1913b:	d0 50 56    	movl r0,r6
   1913e:	fb 00 ef 35 	calls $0x0,19d7a <arc4random>
   19142:	0c 00 00 
   19145:	d1 50 56    	cmpl r0,r6
   19148:	1f f4       	blssu 1913e <arc4random_uniform+0x20>
   1914a:	dd 57       	pushl r7
   1914c:	dd 50       	pushl r0
   1914e:	fb 02 ef eb 	calls $0x2,15d40 <__urem>
   19152:	cb ff ff 
   19155:	04          	ret

00019156 <__findenv>:
   19156:	40 00       	.word 0x0040 # Entry mask: < r6 >
   19158:	c2 04 5e    	subl2 $0x4,sp
   1915b:	d0 ac 04 54 	movl 0x4(ap),r4
   1915f:	d0 ac 08 55 	movl 0x8(ap),r5
   19163:	d0 ac 0c 56 	movl 0xc(ap),r6
   19167:	d5 54       	tstl r4
   19169:	13 09       	beql 19174 <__findenv+0x1e>
   1916b:	d0 ef 9f 8e 	movl 62010 <environ>,r1
   1916f:	04 00 51 
   19172:	12 03       	bneq 19177 <__findenv+0x21>
   19174:	d4 50       	clrf r0
   19176:	04          	ret
   19177:	78 02 66 50 	ashl $0x2,(r6),r0
   1917b:	c0 51 50    	addl2 r1,r0
   1917e:	d0 60 51    	movl (r0),r1
   19181:	13 2a       	beql 191ad <__findenv+0x57>
   19183:	d0 54 53    	movl r4,r3
   19186:	d0 55 52    	movl r5,r2
   19189:	13 11       	beql 1919c <__findenv+0x46>
   1918b:	95 61       	tstb (r1)
   1918d:	13 0d       	beql 1919c <__findenv+0x46>
   1918f:	91 81 83    	cmpb (r1)+,(r3)+
   19192:	12 08       	bneq 1919c <__findenv+0x46>
   19194:	d7 52       	decl r2
   19196:	13 04       	beql 1919c <__findenv+0x46>
   19198:	95 61       	tstb (r1)
   1919a:	12 f3       	bneq 1918f <__findenv+0x39>
   1919c:	d5 52       	tstl r2
   1919e:	12 05       	bneq 191a5 <__findenv+0x4f>
   191a0:	91 81 3d    	cmpb (r1)+,$0x3d
   191a3:	13 0b       	beql 191b0 <__findenv+0x5a>
   191a5:	c0 04 50    	addl2 $0x4,r0
   191a8:	d0 60 51    	movl (r0),r1
   191ab:	12 d6       	bneq 19183 <__findenv+0x2d>
   191ad:	d4 50       	clrf r0
   191af:	04          	ret
   191b0:	c2 ef 5a 8e 	subl2 62010 <environ>,r0
   191b4:	04 00 50 
   191b7:	78 8f fe 50 	ashl $0xfe,r0,(r6)
   191bb:	66 
   191bc:	d0 51 50    	movl r1,r0
   191bf:	04          	ret

000191c0 <getenv>:
   191c0:	00 00       	.word 0x0000 # Entry mask: < >
   191c2:	c2 08 5e    	subl2 $0x8,sp
   191c5:	d0 ac 04 52 	movl 0x4(ap),r2
   191c9:	d4 ad f8    	clrf 0xfffffff8(fp)
   191cc:	d0 52 51    	movl r2,r1
   191cf:	90 62 50    	movb (r2),r0
   191d2:	13 11       	beql 191e5 <getenv+0x25>
   191d4:	91 50 3d    	cmpb r0,$0x3d
   191d7:	13 0c       	beql 191e5 <getenv+0x25>
   191d9:	d6 51       	incl r1
   191db:	90 61 50    	movb (r1),r0
   191de:	13 05       	beql 191e5 <getenv+0x25>
   191e0:	91 50 3d    	cmpb r0,$0x3d
   191e3:	12 f4       	bneq 191d9 <getenv+0x19>
   191e5:	9f ad f8    	pushab 0xfffffff8(fp)
   191e8:	c3 52 51 7e 	subl3 r2,r1,-(sp)
   191ec:	dd 52       	pushl r2
   191ee:	fb 03 ef 61 	calls $0x3,19156 <__findenv>
   191f2:	ff ff ff 
   191f5:	04          	ret

000191f6 <chacha_keysetup>:
   191f6:	00 00       	.word 0x0000 # Entry mask: < >
   191f8:	c2 04 5e    	subl2 $0x4,sp
   191fb:	d0 ac 04 54 	movl 0x4(ap),r4
   191ff:	d0 ac 08 52 	movl 0x8(ap),r2
   19203:	9a 62 50    	movzbl (r2),r0
   19206:	90 a2 01 53 	movb 0x1(r2),r3
   1920a:	9c 08 53 51 	rotl $0x8,r3,r1
   1920e:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   19212:	ff ff 51 
   19215:	c8 51 50    	bisl2 r1,r0
   19218:	90 a2 02 55 	movb 0x2(r2),r5
   1921c:	9c 10 55 51 	rotl $0x10,r5,r1
   19220:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   19224:	00 ff 51 
   19227:	c8 51 50    	bisl2 r1,r0
   1922a:	90 a2 03 53 	movb 0x3(r2),r3
   1922e:	78 18 53 51 	ashl $0x18,r3,r1
   19232:	c9 51 50 a4 	bisl3 r1,r0,0x10(r4)
   19236:	10 
   19237:	9a a2 04 50 	movzbl 0x4(r2),r0
   1923b:	90 a2 05 55 	movb 0x5(r2),r5
   1923f:	9c 08 55 51 	rotl $0x8,r5,r1
   19243:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   19247:	ff ff 51 
   1924a:	c8 51 50    	bisl2 r1,r0
   1924d:	90 a2 06 53 	movb 0x6(r2),r3
   19251:	9c 10 53 51 	rotl $0x10,r3,r1
   19255:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   19259:	00 ff 51 
   1925c:	c8 51 50    	bisl2 r1,r0
   1925f:	90 a2 07 55 	movb 0x7(r2),r5
   19263:	78 18 55 51 	ashl $0x18,r5,r1
   19267:	c9 51 50 a4 	bisl3 r1,r0,0x14(r4)
   1926b:	14 
   1926c:	9a a2 08 50 	movzbl 0x8(r2),r0
   19270:	90 a2 09 53 	movb 0x9(r2),r3
   19274:	9c 08 53 51 	rotl $0x8,r3,r1
   19278:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   1927c:	ff ff 51 
   1927f:	c8 51 50    	bisl2 r1,r0
   19282:	90 a2 0a 55 	movb 0xa(r2),r5
   19286:	9c 10 55 51 	rotl $0x10,r5,r1
   1928a:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   1928e:	00 ff 51 
   19291:	c8 51 50    	bisl2 r1,r0
   19294:	90 a2 0b 53 	movb 0xb(r2),r3
   19298:	78 18 53 51 	ashl $0x18,r3,r1
   1929c:	c9 51 50 a4 	bisl3 r1,r0,0x18(r4)
   192a0:	18 
   192a1:	9a a2 0c 50 	movzbl 0xc(r2),r0
   192a5:	90 a2 0d 55 	movb 0xd(r2),r5
   192a9:	9c 08 55 51 	rotl $0x8,r5,r1
   192ad:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   192b1:	ff ff 51 
   192b4:	c8 51 50    	bisl2 r1,r0
   192b7:	90 a2 0e 53 	movb 0xe(r2),r3
   192bb:	9c 10 53 51 	rotl $0x10,r3,r1
   192bf:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   192c3:	00 ff 51 
   192c6:	c8 51 50    	bisl2 r1,r0
   192c9:	90 a2 0f 55 	movb 0xf(r2),r5
   192cd:	78 18 55 51 	ashl $0x18,r5,r1
   192d1:	c9 51 50 a4 	bisl3 r1,r0,0x1c(r4)
   192d5:	1c 
   192d6:	d1 ac 0c 8f 	cmpl 0xc(ap),$0x00000100
   192da:	00 01 00 00 
   192de:	12 03       	bneq 192e3 <chacha_keysetup+0xed>
   192e0:	31 75 01    	brw 19458 <chacha_keysetup+0x262>
   192e3:	9e ef b4 1f 	movab 2b29d <tau>,r3
   192e7:	01 00 53 
   192ea:	9a 62 50    	movzbl (r2),r0
   192ed:	90 a2 01 55 	movb 0x1(r2),r5
   192f1:	9c 08 55 51 	rotl $0x8,r5,r1
   192f5:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   192f9:	ff ff 51 
   192fc:	c8 51 50    	bisl2 r1,r0
   192ff:	90 a2 02 55 	movb 0x2(r2),r5
   19303:	9c 10 55 51 	rotl $0x10,r5,r1
   19307:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   1930b:	00 ff 51 
   1930e:	c8 51 50    	bisl2 r1,r0
   19311:	90 a2 03 55 	movb 0x3(r2),r5
   19315:	78 18 55 51 	ashl $0x18,r5,r1
   19319:	c9 51 50 a4 	bisl3 r1,r0,0x20(r4)
   1931d:	20 
   1931e:	9a a2 04 50 	movzbl 0x4(r2),r0
   19322:	90 a2 05 55 	movb 0x5(r2),r5
   19326:	9c 08 55 51 	rotl $0x8,r5,r1
   1932a:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   1932e:	ff ff 51 
   19331:	c8 51 50    	bisl2 r1,r0
   19334:	90 a2 06 55 	movb 0x6(r2),r5
   19338:	9c 10 55 51 	rotl $0x10,r5,r1
   1933c:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   19340:	00 ff 51 
   19343:	c8 51 50    	bisl2 r1,r0
   19346:	90 a2 07 55 	movb 0x7(r2),r5
   1934a:	78 18 55 51 	ashl $0x18,r5,r1
   1934e:	c9 51 50 a4 	bisl3 r1,r0,0x24(r4)
   19352:	24 
   19353:	9a a2 08 50 	movzbl 0x8(r2),r0
   19357:	90 a2 09 55 	movb 0x9(r2),r5
   1935b:	9c 08 55 51 	rotl $0x8,r5,r1
   1935f:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   19363:	ff ff 51 
   19366:	c8 51 50    	bisl2 r1,r0
   19369:	90 a2 0a 55 	movb 0xa(r2),r5
   1936d:	9c 10 55 51 	rotl $0x10,r5,r1
   19371:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   19375:	00 ff 51 
   19378:	c8 51 50    	bisl2 r1,r0
   1937b:	90 a2 0b 55 	movb 0xb(r2),r5
   1937f:	78 18 55 51 	ashl $0x18,r5,r1
   19383:	c9 51 50 a4 	bisl3 r1,r0,0x28(r4)
   19387:	28 
   19388:	9a a2 0c 50 	movzbl 0xc(r2),r0
   1938c:	90 a2 0d 55 	movb 0xd(r2),r5
   19390:	9c 08 55 51 	rotl $0x8,r5,r1
   19394:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   19398:	ff ff 51 
   1939b:	c8 51 50    	bisl2 r1,r0
   1939e:	90 a2 0e 55 	movb 0xe(r2),r5
   193a2:	9c 10 55 51 	rotl $0x10,r5,r1
   193a6:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   193aa:	00 ff 51 
   193ad:	c8 51 50    	bisl2 r1,r0
   193b0:	90 a2 0f 52 	movb 0xf(r2),r2
   193b4:	78 18 52 51 	ashl $0x18,r2,r1
   193b8:	c9 51 50 a4 	bisl3 r1,r0,0x2c(r4)
   193bc:	2c 
   193bd:	98 63 51    	cvtbl (r3),r1
   193c0:	98 a3 01 50 	cvtbl 0x1(r3),r0
   193c4:	78 08 50 50 	ashl $0x8,r0,r0
   193c8:	c8 50 51    	bisl2 r0,r1
   193cb:	98 a3 02 50 	cvtbl 0x2(r3),r0
   193cf:	78 10 50 50 	ashl $0x10,r0,r0
   193d3:	c8 50 51    	bisl2 r0,r1
   193d6:	90 a3 03 52 	movb 0x3(r3),r2
   193da:	78 18 52 50 	ashl $0x18,r2,r0
   193de:	c9 50 51 64 	bisl3 r0,r1,(r4)
   193e2:	98 a3 04 51 	cvtbl 0x4(r3),r1
   193e6:	98 a3 05 50 	cvtbl 0x5(r3),r0
   193ea:	78 08 50 50 	ashl $0x8,r0,r0
   193ee:	c8 50 51    	bisl2 r0,r1
   193f1:	98 a3 06 50 	cvtbl 0x6(r3),r0
   193f5:	78 10 50 50 	ashl $0x10,r0,r0
   193f9:	c8 50 51    	bisl2 r0,r1
   193fc:	90 a3 07 55 	movb 0x7(r3),r5
   19400:	78 18 55 50 	ashl $0x18,r5,r0
   19404:	c9 50 51 a4 	bisl3 r0,r1,0x4(r4)
   19408:	04 
   19409:	98 a3 08 51 	cvtbl 0x8(r3),r1
   1940d:	98 a3 09 50 	cvtbl 0x9(r3),r0
   19411:	78 08 50 50 	ashl $0x8,r0,r0
   19415:	c8 50 51    	bisl2 r0,r1
   19418:	98 a3 0a 50 	cvtbl 0xa(r3),r0
   1941c:	78 10 50 50 	ashl $0x10,r0,r0
   19420:	c8 50 51    	bisl2 r0,r1
   19423:	90 a3 0b 52 	movb 0xb(r3),r2
   19427:	78 18 52 50 	ashl $0x18,r2,r0
   1942b:	c9 50 51 a4 	bisl3 r0,r1,0x8(r4)
   1942f:	08 
   19430:	98 a3 0c 51 	cvtbl 0xc(r3),r1
   19434:	98 a3 0d 50 	cvtbl 0xd(r3),r0
   19438:	78 08 50 50 	ashl $0x8,r0,r0
   1943c:	c8 50 51    	bisl2 r0,r1
   1943f:	98 a3 0e 50 	cvtbl 0xe(r3),r0
   19443:	78 10 50 50 	ashl $0x10,r0,r0
   19447:	c8 50 51    	bisl2 r0,r1
   1944a:	90 a3 0f 53 	movb 0xf(r3),r3
   1944e:	78 18 53 50 	ashl $0x18,r3,r0
   19452:	c9 50 51 a4 	bisl3 r0,r1,0xc(r4)
   19456:	0c 
   19457:	04          	ret
   19458:	c0 10 52    	addl2 $0x10,r2
   1945b:	9e ef 2c 1e 	movab 2b28d <sigma>,r3
   1945f:	01 00 53 
   19462:	31 85 fe    	brw 192ea <chacha_keysetup+0xf4>
   19465:	01          	nop

00019466 <chacha_ivsetup>:
   19466:	00 00       	.word 0x0000 # Entry mask: < >
   19468:	c2 04 5e    	subl2 $0x4,sp
   1946b:	d0 ac 04 53 	movl 0x4(ap),r3
   1946f:	d0 ac 08 52 	movl 0x8(ap),r2
   19473:	d4 a3 30    	clrf 0x30(r3)
   19476:	d4 a3 34    	clrf 0x34(r3)
   19479:	9a 62 50    	movzbl (r2),r0
   1947c:	90 a2 01 54 	movb 0x1(r2),r4
   19480:	9c 08 54 51 	rotl $0x8,r4,r1
   19484:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   19488:	ff ff 51 
   1948b:	c8 51 50    	bisl2 r1,r0
   1948e:	90 a2 02 54 	movb 0x2(r2),r4
   19492:	9c 10 54 51 	rotl $0x10,r4,r1
   19496:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   1949a:	00 ff 51 
   1949d:	c8 51 50    	bisl2 r1,r0
   194a0:	90 a2 03 54 	movb 0x3(r2),r4
   194a4:	78 18 54 51 	ashl $0x18,r4,r1
   194a8:	c9 51 50 a3 	bisl3 r1,r0,0x38(r3)
   194ac:	38 
   194ad:	9a a2 04 50 	movzbl 0x4(r2),r0
   194b1:	90 a2 05 54 	movb 0x5(r2),r4
   194b5:	9c 08 54 51 	rotl $0x8,r4,r1
   194b9:	ca 8f ff 00 	bicl2 $0xffff00ff,r1
   194bd:	ff ff 51 
   194c0:	c8 51 50    	bisl2 r1,r0
   194c3:	90 a2 06 54 	movb 0x6(r2),r4
   194c7:	9c 10 54 51 	rotl $0x10,r4,r1
   194cb:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   194cf:	00 ff 51 
   194d2:	c8 51 50    	bisl2 r1,r0
   194d5:	90 a2 07 52 	movb 0x7(r2),r2
   194d9:	78 18 52 51 	ashl $0x18,r2,r1
   194dd:	c9 51 50 a3 	bisl3 r1,r0,0x3c(r3)
   194e1:	3c 
   194e2:	04          	ret
   194e3:	01          	nop

000194e4 <chacha_encrypt_bytes>:
   194e4:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   194e6:	9e ce 50 ff 	movab 0xffffff50(sp),sp
   194ea:	5e 
   194eb:	d0 ef a7 2a 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   194ef:	02 00 ad f8 
   194f3:	d0 ac 04 cd 	movl 0x4(ap),0xffffff58(fp)
   194f7:	58 ff 
   194f9:	d0 ac 0c cd 	movl 0xc(ap),0xffffff54(fp)
   194fd:	54 ff 
   194ff:	d4 cd 60 ff 	clrf 0xffffff60(fp)
   19503:	d5 ac 10    	tstl 0x10(ap)
   19506:	12 03       	bneq 1950b <chacha_encrypt_bytes+0x27>
   19508:	31 f1 05    	brw 19afc <chacha_encrypt_bytes+0x618>
   1950b:	d0 cd 58 ff 	movl 0xffffff58(fp),r0
   1950f:	50 
   19510:	d0 60 ad a0 	movl (r0),0xffffffa0(fp)
   19514:	d0 a0 04 ad 	movl 0x4(r0),0xffffff9c(fp)
   19518:	9c 
   19519:	d0 a0 08 ad 	movl 0x8(r0),0xffffff98(fp)
   1951d:	98 
   1951e:	d0 a0 0c ad 	movl 0xc(r0),0xffffff94(fp)
   19522:	94 
   19523:	d0 a0 10 ad 	movl 0x10(r0),0xffffff90(fp)
   19527:	90 
   19528:	d0 a0 14 ad 	movl 0x14(r0),0xffffff8c(fp)
   1952c:	8c 
   1952d:	d0 a0 18 ad 	movl 0x18(r0),0xffffff88(fp)
   19531:	88 
   19532:	d0 a0 1c ad 	movl 0x1c(r0),0xffffff84(fp)
   19536:	84 
   19537:	d0 a0 20 ad 	movl 0x20(r0),0xffffff80(fp)
   1953b:	80 
   1953c:	d0 a0 24 cd 	movl 0x24(r0),0xffffff7c(fp)
   19540:	7c ff 
   19542:	d0 a0 28 cd 	movl 0x28(r0),0xffffff78(fp)
   19546:	78 ff 
   19548:	d0 a0 2c cd 	movl 0x2c(r0),0xffffff74(fp)
   1954c:	74 ff 
   1954e:	d0 a0 30 cd 	movl 0x30(r0),0xffffff70(fp)
   19552:	70 ff 
   19554:	d0 a0 34 cd 	movl 0x34(r0),0xffffff6c(fp)
   19558:	6c ff 
   1955a:	d0 a0 38 cd 	movl 0x38(r0),0xffffff68(fp)
   1955e:	68 ff 
   19560:	d0 a0 3c cd 	movl 0x3c(r0),0xffffff64(fp)
   19564:	64 ff 
   19566:	d1 ac 10 3f 	cmpl 0x10(ap),$0x3f
   1956a:	1a 3b       	bgtru 195a7 <chacha_encrypt_bytes+0xc3>
   1956c:	d4 cd 5c ff 	clrf 0xffffff5c(fp)
   19570:	d1 cd 5c ff 	cmpl 0xffffff5c(fp),0x10(ap)
   19574:	ac 10 
   19576:	1e 1d       	bcc 19595 <chacha_encrypt_bytes+0xb1>
   19578:	d0 cd 5c ff 	movl 0xffffff5c(fp),r1
   1957c:	51 
   1957d:	d0 ac 08 52 	movl 0x8(ap),r2
   19581:	90 42 61 4d 	movb (r1)[r2],0xffffffb8(r1)[fp]
   19585:	a1 b8 
   19587:	c1 51 01 cd 	addl3 r1,$0x1,0xffffff5c(fp)
   1958b:	5c ff 
   1958d:	d1 cd 5c ff 	cmpl 0xffffff5c(fp),0x10(ap)
   19591:	ac 10 
   19593:	1f e3       	blssu 19578 <chacha_encrypt_bytes+0x94>
   19595:	9e ad b8 ac 	movab 0xffffffb8(fp),0x8(ap)
   19599:	08 
   1959a:	d0 cd 54 ff 	movl 0xffffff54(fp),0xffffff60(fp)
   1959e:	cd 60 ff 
   195a1:	d0 ac 08 cd 	movl 0x8(ap),0xffffff54(fp)
   195a5:	54 ff 
   195a7:	d0 ad a0 57 	movl 0xffffffa0(fp),r7
   195ab:	d0 ad 9c 58 	movl 0xffffff9c(fp),r8
   195af:	d0 ad 98 59 	movl 0xffffff98(fp),r9
   195b3:	d0 ad 94 5a 	movl 0xffffff94(fp),r10
   195b7:	d0 ad 90 5b 	movl 0xffffff90(fp),r11
   195bb:	d0 ad 8c 56 	movl 0xffffff8c(fp),r6
   195bf:	d0 ad 88 55 	movl 0xffffff88(fp),r5
   195c3:	d0 ad 84 54 	movl 0xffffff84(fp),r4
   195c7:	d0 ad 80 53 	movl 0xffffff80(fp),r3
   195cb:	d0 cd 7c ff 	movl 0xffffff7c(fp),r2
   195cf:	52 
   195d0:	d0 cd 78 ff 	movl 0xffffff78(fp),r1
   195d4:	51 
   195d5:	d0 cd 74 ff 	movl 0xffffff74(fp),0xffffffb4(fp)
   195d9:	ad b4 
   195db:	d0 cd 70 ff 	movl 0xffffff70(fp),0xffffffb0(fp)
   195df:	ad b0 
   195e1:	d0 cd 6c ff 	movl 0xffffff6c(fp),0xffffffac(fp)
   195e5:	ad ac 
   195e7:	d0 cd 68 ff 	movl 0xffffff68(fp),0xffffffa8(fp)
   195eb:	ad a8 
   195ed:	d0 cd 64 ff 	movl 0xffffff64(fp),0xffffffa4(fp)
   195f1:	ad a4 
   195f3:	d0 14 cd 5c 	movl $0x14,0xffffff5c(fp)
   195f7:	ff 
   195f8:	c0 5b 57    	addl2 r11,r7
   195fb:	cd 57 ad b0 	xorl3 r7,0xffffffb0(fp),r0
   195ff:	50 
   19600:	9c 10 50 ad 	rotl $0x10,r0,0xffffffb0(fp)
   19604:	b0 
   19605:	c0 ad b0 53 	addl2 0xffffffb0(fp),r3
   19609:	cd 53 5b 50 	xorl3 r3,r11,r0
   1960d:	9c 0c 50 5b 	rotl $0xc,r0,r11
   19611:	c0 5b 57    	addl2 r11,r7
   19614:	cd 57 ad b0 	xorl3 r7,0xffffffb0(fp),r0
   19618:	50 
   19619:	9c 08 50 ad 	rotl $0x8,r0,0xffffffb0(fp)
   1961d:	b0 
   1961e:	c0 ad b0 53 	addl2 0xffffffb0(fp),r3
   19622:	cd 53 5b 50 	xorl3 r3,r11,r0
   19626:	9c 07 50 5b 	rotl $0x7,r0,r11
   1962a:	c0 56 58    	addl2 r6,r8
   1962d:	cd 58 ad ac 	xorl3 r8,0xffffffac(fp),r0
   19631:	50 
   19632:	9c 10 50 ad 	rotl $0x10,r0,0xffffffac(fp)
   19636:	ac 
   19637:	c0 ad ac 52 	addl2 0xffffffac(fp),r2
   1963b:	cd 52 56 50 	xorl3 r2,r6,r0
   1963f:	9c 0c 50 56 	rotl $0xc,r0,r6
   19643:	c0 56 58    	addl2 r6,r8
   19646:	cd 58 ad ac 	xorl3 r8,0xffffffac(fp),r0
   1964a:	50 
   1964b:	9c 08 50 ad 	rotl $0x8,r0,0xffffffac(fp)
   1964f:	ac 
   19650:	c0 ad ac 52 	addl2 0xffffffac(fp),r2
   19654:	cd 52 56 50 	xorl3 r2,r6,r0
   19658:	9c 07 50 56 	rotl $0x7,r0,r6
   1965c:	c0 55 59    	addl2 r5,r9
   1965f:	cd 59 ad a8 	xorl3 r9,0xffffffa8(fp),r0
   19663:	50 
   19664:	9c 10 50 ad 	rotl $0x10,r0,0xffffffa8(fp)
   19668:	a8 
   19669:	c0 ad a8 51 	addl2 0xffffffa8(fp),r1
   1966d:	cd 51 55 50 	xorl3 r1,r5,r0
   19671:	9c 0c 50 55 	rotl $0xc,r0,r5
   19675:	c0 55 59    	addl2 r5,r9
   19678:	cd 59 ad a8 	xorl3 r9,0xffffffa8(fp),r0
   1967c:	50 
   1967d:	9c 08 50 ad 	rotl $0x8,r0,0xffffffa8(fp)
   19681:	a8 
   19682:	c0 ad a8 51 	addl2 0xffffffa8(fp),r1
   19686:	cd 51 55 50 	xorl3 r1,r5,r0
   1968a:	9c 07 50 55 	rotl $0x7,r0,r5
   1968e:	c0 54 5a    	addl2 r4,r10
   19691:	cd 5a ad a4 	xorl3 r10,0xffffffa4(fp),r0
   19695:	50 
   19696:	9c 10 50 ad 	rotl $0x10,r0,0xffffffa4(fp)
   1969a:	a4 
   1969b:	c0 ad a4 ad 	addl2 0xffffffa4(fp),0xffffffb4(fp)
   1969f:	b4 
   196a0:	cd ad b4 54 	xorl3 0xffffffb4(fp),r4,r0
   196a4:	50 
   196a5:	9c 0c 50 54 	rotl $0xc,r0,r4
   196a9:	c0 54 5a    	addl2 r4,r10
   196ac:	cd 5a ad a4 	xorl3 r10,0xffffffa4(fp),r0
   196b0:	50 
   196b1:	9c 08 50 ad 	rotl $0x8,r0,0xffffffa4(fp)
   196b5:	a4 
   196b6:	c0 ad a4 ad 	addl2 0xffffffa4(fp),0xffffffb4(fp)
   196ba:	b4 
   196bb:	cd ad b4 54 	xorl3 0xffffffb4(fp),r4,r0
   196bf:	50 
   196c0:	9c 07 50 54 	rotl $0x7,r0,r4
   196c4:	c0 56 57    	addl2 r6,r7
   196c7:	cd 57 ad a4 	xorl3 r7,0xffffffa4(fp),r0
   196cb:	50 
   196cc:	9c 10 50 ad 	rotl $0x10,r0,0xffffffa4(fp)
   196d0:	a4 
   196d1:	c0 ad a4 51 	addl2 0xffffffa4(fp),r1
   196d5:	cd 51 56 50 	xorl3 r1,r6,r0
   196d9:	9c 0c 50 56 	rotl $0xc,r0,r6
   196dd:	c0 56 57    	addl2 r6,r7
   196e0:	cd 57 ad a4 	xorl3 r7,0xffffffa4(fp),r0
   196e4:	50 
   196e5:	9c 08 50 ad 	rotl $0x8,r0,0xffffffa4(fp)
   196e9:	a4 
   196ea:	c0 ad a4 51 	addl2 0xffffffa4(fp),r1
   196ee:	cd 51 56 50 	xorl3 r1,r6,r0
   196f2:	9c 07 50 56 	rotl $0x7,r0,r6
   196f6:	c0 55 58    	addl2 r5,r8
   196f9:	cd 58 ad b0 	xorl3 r8,0xffffffb0(fp),r0
   196fd:	50 
   196fe:	9c 10 50 ad 	rotl $0x10,r0,0xffffffb0(fp)
   19702:	b0 
   19703:	c0 ad b0 ad 	addl2 0xffffffb0(fp),0xffffffb4(fp)
   19707:	b4 
   19708:	cd ad b4 55 	xorl3 0xffffffb4(fp),r5,r0
   1970c:	50 
   1970d:	9c 0c 50 55 	rotl $0xc,r0,r5
   19711:	c0 55 58    	addl2 r5,r8
   19714:	cd 58 ad b0 	xorl3 r8,0xffffffb0(fp),r0
   19718:	50 
   19719:	9c 08 50 ad 	rotl $0x8,r0,0xffffffb0(fp)
   1971d:	b0 
   1971e:	c0 ad b0 ad 	addl2 0xffffffb0(fp),0xffffffb4(fp)
   19722:	b4 
   19723:	cd ad b4 55 	xorl3 0xffffffb4(fp),r5,r0
   19727:	50 
   19728:	9c 07 50 55 	rotl $0x7,r0,r5
   1972c:	c0 54 59    	addl2 r4,r9
   1972f:	cd 59 ad ac 	xorl3 r9,0xffffffac(fp),r0
   19733:	50 
   19734:	9c 10 50 ad 	rotl $0x10,r0,0xffffffac(fp)
   19738:	ac 
   19739:	c0 ad ac 53 	addl2 0xffffffac(fp),r3
   1973d:	cd 53 54 50 	xorl3 r3,r4,r0
   19741:	9c 0c 50 54 	rotl $0xc,r0,r4
   19745:	c0 54 59    	addl2 r4,r9
   19748:	cd 59 ad ac 	xorl3 r9,0xffffffac(fp),r0
   1974c:	50 
   1974d:	9c 08 50 ad 	rotl $0x8,r0,0xffffffac(fp)
   19751:	ac 
   19752:	c0 ad ac 53 	addl2 0xffffffac(fp),r3
   19756:	cd 53 54 50 	xorl3 r3,r4,r0
   1975a:	9c 07 50 54 	rotl $0x7,r0,r4
   1975e:	c0 5b 5a    	addl2 r11,r10
   19761:	cd 5a ad a8 	xorl3 r10,0xffffffa8(fp),r0
   19765:	50 
   19766:	9c 10 50 ad 	rotl $0x10,r0,0xffffffa8(fp)
   1976a:	a8 
   1976b:	c0 ad a8 52 	addl2 0xffffffa8(fp),r2
   1976f:	cd 52 5b 50 	xorl3 r2,r11,r0
   19773:	9c 0c 50 5b 	rotl $0xc,r0,r11
   19777:	c0 5b 5a    	addl2 r11,r10
   1977a:	cd 5a ad a8 	xorl3 r10,0xffffffa8(fp),r0
   1977e:	50 
   1977f:	9c 08 50 ad 	rotl $0x8,r0,0xffffffa8(fp)
   19783:	a8 
   19784:	c0 ad a8 52 	addl2 0xffffffa8(fp),r2
   19788:	cd 52 5b 50 	xorl3 r2,r11,r0
   1978c:	9c 07 50 5b 	rotl $0x7,r0,r11
   19790:	c2 02 cd 5c 	subl2 $0x2,0xffffff5c(fp)
   19794:	ff 
   19795:	13 03       	beql 1979a <chacha_encrypt_bytes+0x2b6>
   19797:	31 5e fe    	brw 195f8 <chacha_encrypt_bytes+0x114>
   1979a:	c0 ad a0 57 	addl2 0xffffffa0(fp),r7
   1979e:	c0 ad 9c 58 	addl2 0xffffff9c(fp),r8
   197a2:	c0 ad 98 59 	addl2 0xffffff98(fp),r9
   197a6:	c0 ad 94 5a 	addl2 0xffffff94(fp),r10
   197aa:	c0 ad 90 5b 	addl2 0xffffff90(fp),r11
   197ae:	c0 ad 8c 56 	addl2 0xffffff8c(fp),r6
   197b2:	c0 ad 88 55 	addl2 0xffffff88(fp),r5
   197b6:	c0 ad 84 54 	addl2 0xffffff84(fp),r4
   197ba:	c0 ad 80 53 	addl2 0xffffff80(fp),r3
   197be:	c0 cd 7c ff 	addl2 0xffffff7c(fp),r2
   197c2:	52 
   197c3:	c0 cd 78 ff 	addl2 0xffffff78(fp),r1
   197c7:	51 
   197c8:	c0 cd 74 ff 	addl2 0xffffff74(fp),0xffffffb4(fp)
   197cc:	ad b4 
   197ce:	c0 cd 70 ff 	addl2 0xffffff70(fp),0xffffffb0(fp)
   197d2:	ad b0 
   197d4:	c0 cd 6c ff 	addl2 0xffffff6c(fp),0xffffffac(fp)
   197d8:	ad ac 
   197da:	c0 cd 68 ff 	addl2 0xffffff68(fp),0xffffffa8(fp)
   197de:	ad a8 
   197e0:	c0 cd 64 ff 	addl2 0xffffff64(fp),0xffffffa4(fp)
   197e4:	ad a4 
   197e6:	d6 cd 70 ff 	incl 0xffffff70(fp)
   197ea:	12 04       	bneq 197f0 <chacha_encrypt_bytes+0x30c>
   197ec:	d6 cd 6c ff 	incl 0xffffff6c(fp)
   197f0:	d0 cd 54 ff 	movl 0xffffff54(fp),r0
   197f4:	50 
   197f5:	90 57 60    	movb r7,(r0)
   197f8:	ef 08 18 57 	extzv $0x8,$0x18,r7,0xffffff50(fp)
   197fc:	cd 50 ff 
   197ff:	90 cd 50 ff 	movb 0xffffff50(fp),0x1(r0)
   19803:	a0 01 
   19805:	ef 10 10 57 	extzv $0x10,$0x10,r7,0xffffff50(fp)
   19809:	cd 50 ff 
   1980c:	90 cd 50 ff 	movb 0xffffff50(fp),0x2(r0)
   19810:	a0 02 
   19812:	9c 08 57 50 	rotl $0x8,r7,r0
   19816:	9a 50 50    	movzbl r0,r0
   19819:	d0 cd 54 ff 	movl 0xffffff54(fp),r7
   1981d:	57 
   1981e:	90 50 a7 03 	movb r0,0x3(r7)
   19822:	90 58 a7 04 	movb r8,0x4(r7)
   19826:	9c 18 58 50 	rotl $0x18,r8,r0
   1982a:	ca 8f 00 00 	bicl2 $0xff000000,r0
   1982e:	00 ff 50 
   19831:	90 50 a7 05 	movb r0,0x5(r7)
   19835:	9c 10 58 50 	rotl $0x10,r8,r0
   19839:	3c 50 50    	movzwl r0,r0
   1983c:	90 50 a7 06 	movb r0,0x6(r7)
   19840:	9c 08 58 50 	rotl $0x8,r8,r0
   19844:	9a 50 50    	movzbl r0,r0
   19847:	90 50 a7 07 	movb r0,0x7(r7)
   1984b:	90 59 a7 08 	movb r9,0x8(r7)
   1984f:	9c 18 59 50 	rotl $0x18,r9,r0
   19853:	ca 8f 00 00 	bicl2 $0xff000000,r0
   19857:	00 ff 50 
   1985a:	90 50 a7 09 	movb r0,0x9(r7)
   1985e:	9c 10 59 50 	rotl $0x10,r9,r0
   19862:	3c 50 50    	movzwl r0,r0
   19865:	90 50 a7 0a 	movb r0,0xa(r7)
   19869:	9c 08 59 50 	rotl $0x8,r9,r0
   1986d:	9a 50 50    	movzbl r0,r0
   19870:	90 50 a7 0b 	movb r0,0xb(r7)
   19874:	90 5a a7 0c 	movb r10,0xc(r7)
   19878:	9c 18 5a 50 	rotl $0x18,r10,r0
   1987c:	ca 8f 00 00 	bicl2 $0xff000000,r0
   19880:	00 ff 50 
   19883:	90 50 a7 0d 	movb r0,0xd(r7)
   19887:	9c 10 5a 50 	rotl $0x10,r10,r0
   1988b:	3c 50 50    	movzwl r0,r0
   1988e:	90 50 a7 0e 	movb r0,0xe(r7)
   19892:	9c 08 5a 50 	rotl $0x8,r10,r0
   19896:	9a 50 50    	movzbl r0,r0
   19899:	90 50 a7 0f 	movb r0,0xf(r7)
   1989d:	90 5b a7 10 	movb r11,0x10(r7)
   198a1:	9c 18 5b 50 	rotl $0x18,r11,r0
   198a5:	ca 8f 00 00 	bicl2 $0xff000000,r0
   198a9:	00 ff 50 
   198ac:	90 50 a7 11 	movb r0,0x11(r7)
   198b0:	9c 10 5b 50 	rotl $0x10,r11,r0
   198b4:	3c 50 50    	movzwl r0,r0
   198b7:	90 50 a7 12 	movb r0,0x12(r7)
   198bb:	9c 08 5b 50 	rotl $0x8,r11,r0
   198bf:	9a 50 50    	movzbl r0,r0
   198c2:	90 50 a7 13 	movb r0,0x13(r7)
   198c6:	90 56 a7 14 	movb r6,0x14(r7)
   198ca:	9c 18 56 50 	rotl $0x18,r6,r0
   198ce:	ca 8f 00 00 	bicl2 $0xff000000,r0
   198d2:	00 ff 50 
   198d5:	90 50 a7 15 	movb r0,0x15(r7)
   198d9:	9c 10 56 50 	rotl $0x10,r6,r0
   198dd:	3c 50 50    	movzwl r0,r0
   198e0:	90 50 a7 16 	movb r0,0x16(r7)
   198e4:	9c 08 56 50 	rotl $0x8,r6,r0
   198e8:	9a 50 50    	movzbl r0,r0
   198eb:	90 50 a7 17 	movb r0,0x17(r7)
   198ef:	90 55 a7 18 	movb r5,0x18(r7)
   198f3:	9c 18 55 50 	rotl $0x18,r5,r0
   198f7:	ca 8f 00 00 	bicl2 $0xff000000,r0
   198fb:	00 ff 50 
   198fe:	90 50 a7 19 	movb r0,0x19(r7)
   19902:	9c 10 55 50 	rotl $0x10,r5,r0
   19906:	3c 50 50    	movzwl r0,r0
   19909:	90 50 a7 1a 	movb r0,0x1a(r7)
   1990d:	9c 08 55 50 	rotl $0x8,r5,r0
   19911:	9a 50 50    	movzbl r0,r0
   19914:	90 50 a7 1b 	movb r0,0x1b(r7)
   19918:	90 54 a7 1c 	movb r4,0x1c(r7)
   1991c:	9c 18 54 50 	rotl $0x18,r4,r0
   19920:	ca 8f 00 00 	bicl2 $0xff000000,r0
   19924:	00 ff 50 
   19927:	90 50 a7 1d 	movb r0,0x1d(r7)
   1992b:	9c 10 54 50 	rotl $0x10,r4,r0
   1992f:	3c 50 50    	movzwl r0,r0
   19932:	90 50 a7 1e 	movb r0,0x1e(r7)
   19936:	9c 08 54 50 	rotl $0x8,r4,r0
   1993a:	9a 50 50    	movzbl r0,r0
   1993d:	90 50 a7 1f 	movb r0,0x1f(r7)
   19941:	90 53 a7 20 	movb r3,0x20(r7)
   19945:	9c 18 53 50 	rotl $0x18,r3,r0
   19949:	ca 8f 00 00 	bicl2 $0xff000000,r0
   1994d:	00 ff 50 
   19950:	90 50 a7 21 	movb r0,0x21(r7)
   19954:	9c 10 53 50 	rotl $0x10,r3,r0
   19958:	3c 50 50    	movzwl r0,r0
   1995b:	90 50 a7 22 	movb r0,0x22(r7)
   1995f:	9c 08 53 50 	rotl $0x8,r3,r0
   19963:	9a 50 50    	movzbl r0,r0
   19966:	90 50 a7 23 	movb r0,0x23(r7)
   1996a:	90 52 a7 24 	movb r2,0x24(r7)
   1996e:	9c 18 52 50 	rotl $0x18,r2,r0
   19972:	ca 8f 00 00 	bicl2 $0xff000000,r0
   19976:	00 ff 50 
   19979:	90 50 a7 25 	movb r0,0x25(r7)
   1997d:	9c 10 52 50 	rotl $0x10,r2,r0
   19981:	3c 50 50    	movzwl r0,r0
   19984:	90 50 a7 26 	movb r0,0x26(r7)
   19988:	9c 08 52 50 	rotl $0x8,r2,r0
   1998c:	9a 50 50    	movzbl r0,r0
   1998f:	90 50 a7 27 	movb r0,0x27(r7)
   19993:	90 51 a7 28 	movb r1,0x28(r7)
   19997:	9c 18 51 50 	rotl $0x18,r1,r0
   1999b:	ca 8f 00 00 	bicl2 $0xff000000,r0
   1999f:	00 ff 50 
   199a2:	90 50 a7 29 	movb r0,0x29(r7)
   199a6:	9c 10 51 50 	rotl $0x10,r1,r0
   199aa:	3c 50 50    	movzwl r0,r0
   199ad:	90 50 a7 2a 	movb r0,0x2a(r7)
   199b1:	9c 08 51 50 	rotl $0x8,r1,r0
   199b5:	9a 50 50    	movzbl r0,r0
   199b8:	90 50 a7 2b 	movb r0,0x2b(r7)
   199bc:	90 ad b4 a7 	movb 0xffffffb4(fp),0x2c(r7)
   199c0:	2c 
   199c1:	9c 18 ad b4 	rotl $0x18,0xffffffb4(fp),r0
   199c5:	50 
   199c6:	ca 8f 00 00 	bicl2 $0xff000000,r0
   199ca:	00 ff 50 
   199cd:	90 50 a7 2d 	movb r0,0x2d(r7)
   199d1:	9c 10 ad b4 	rotl $0x10,0xffffffb4(fp),r0
   199d5:	50 
   199d6:	3c 50 50    	movzwl r0,r0
   199d9:	90 50 a7 2e 	movb r0,0x2e(r7)
   199dd:	9c 08 ad b4 	rotl $0x8,0xffffffb4(fp),r0
   199e1:	50 
   199e2:	9a 50 50    	movzbl r0,r0
   199e5:	90 50 a7 2f 	movb r0,0x2f(r7)
   199e9:	90 ad b0 a7 	movb 0xffffffb0(fp),0x30(r7)
   199ed:	30 
   199ee:	9c 18 ad b0 	rotl $0x18,0xffffffb0(fp),r0
   199f2:	50 
   199f3:	ca 8f 00 00 	bicl2 $0xff000000,r0
   199f7:	00 ff 50 
   199fa:	90 50 a7 31 	movb r0,0x31(r7)
   199fe:	9c 10 ad b0 	rotl $0x10,0xffffffb0(fp),r0
   19a02:	50 
   19a03:	3c 50 50    	movzwl r0,r0
   19a06:	90 50 a7 32 	movb r0,0x32(r7)
   19a0a:	9c 08 ad b0 	rotl $0x8,0xffffffb0(fp),r0
   19a0e:	50 
   19a0f:	9a 50 50    	movzbl r0,r0
   19a12:	90 50 a7 33 	movb r0,0x33(r7)
   19a16:	90 ad ac a7 	movb 0xffffffac(fp),0x34(r7)
   19a1a:	34 
   19a1b:	9c 18 ad ac 	rotl $0x18,0xffffffac(fp),r0
   19a1f:	50 
   19a20:	ca 8f 00 00 	bicl2 $0xff000000,r0
   19a24:	00 ff 50 
   19a27:	90 50 a7 35 	movb r0,0x35(r7)
   19a2b:	9c 10 ad ac 	rotl $0x10,0xffffffac(fp),r0
   19a2f:	50 
   19a30:	3c 50 50    	movzwl r0,r0
   19a33:	90 50 a7 36 	movb r0,0x36(r7)
   19a37:	9c 08 ad ac 	rotl $0x8,0xffffffac(fp),r0
   19a3b:	50 
   19a3c:	9a 50 50    	movzbl r0,r0
   19a3f:	90 50 a7 37 	movb r0,0x37(r7)
   19a43:	90 ad a8 a7 	movb 0xffffffa8(fp),0x38(r7)
   19a47:	38 
   19a48:	9c 18 ad a8 	rotl $0x18,0xffffffa8(fp),r0
   19a4c:	50 
   19a4d:	ca 8f 00 00 	bicl2 $0xff000000,r0
   19a51:	00 ff 50 
   19a54:	90 50 a7 39 	movb r0,0x39(r7)
   19a58:	9c 10 ad a8 	rotl $0x10,0xffffffa8(fp),r0
   19a5c:	50 
   19a5d:	3c 50 50    	movzwl r0,r0
   19a60:	90 50 a7 3a 	movb r0,0x3a(r7)
   19a64:	9c 08 ad a8 	rotl $0x8,0xffffffa8(fp),r0
   19a68:	50 
   19a69:	9a 50 50    	movzbl r0,r0
   19a6c:	90 50 a7 3b 	movb r0,0x3b(r7)
   19a70:	90 ad a4 a7 	movb 0xffffffa4(fp),0x3c(r7)
   19a74:	3c 
   19a75:	9c 18 ad a4 	rotl $0x18,0xffffffa4(fp),r0
   19a79:	50 
   19a7a:	ca 8f 00 00 	bicl2 $0xff000000,r0
   19a7e:	00 ff 50 
   19a81:	90 50 a7 3d 	movb r0,0x3d(r7)
   19a85:	9c 10 ad a4 	rotl $0x10,0xffffffa4(fp),r0
   19a89:	50 
   19a8a:	3c 50 50    	movzwl r0,r0
   19a8d:	90 50 a7 3e 	movb r0,0x3e(r7)
   19a91:	9c 08 ad a4 	rotl $0x8,0xffffffa4(fp),r0
   19a95:	50 
   19a96:	9a 50 50    	movzbl r0,r0
   19a99:	90 50 a7 3f 	movb r0,0x3f(r7)
   19a9d:	d1 ac 10 8f 	cmpl 0x10(ap),$0x00000040
   19aa1:	40 00 00 00 
   19aa5:	1b 14       	blequ 19abb <chacha_encrypt_bytes+0x5d7>
   19aa7:	c0 8f c0 ff 	addl2 $0xffffffc0,0x10(ap)
   19aab:	ff ff ac 10 
   19aaf:	c0 8f 40 00 	addl2 $0x00000040,0xffffff54(fp)
   19ab3:	00 00 cd 54 
   19ab7:	ff 
   19ab8:	31 ab fa    	brw 19566 <chacha_encrypt_bytes+0x82>
   19abb:	d1 ac 10 3f 	cmpl 0x10(ap),$0x3f
   19abf:	1a 2a       	bgtru 19aeb <chacha_encrypt_bytes+0x607>
   19ac1:	d1 cd 5c ff 	cmpl 0xffffff5c(fp),0x10(ap)
   19ac5:	ac 10 
   19ac7:	1e 22       	bcc 19aeb <chacha_encrypt_bytes+0x607>
   19ac9:	d0 cd 60 ff 	movl 0xffffff60(fp),r0
   19acd:	50 
   19ace:	d0 cd 5c ff 	movl 0xffffff5c(fp),r1
   19ad2:	51 
   19ad3:	d0 cd 54 ff 	movl 0xffffff54(fp),r2
   19ad7:	52 
   19ad8:	90 42 61 40 	movb (r1)[r2],(r1)[r0]
   19adc:	61 
   19add:	c1 51 01 cd 	addl3 r1,$0x1,0xffffff5c(fp)
   19ae1:	5c ff 
   19ae3:	d1 cd 5c ff 	cmpl 0xffffff5c(fp),0x10(ap)
   19ae7:	ac 10 
   19ae9:	1f de       	blssu 19ac9 <chacha_encrypt_bytes+0x5e5>
   19aeb:	d0 cd 58 ff 	movl 0xffffff58(fp),r3
   19aef:	53 
   19af0:	d0 cd 70 ff 	movl 0xffffff70(fp),0x30(r3)
   19af4:	a3 30 
   19af6:	d0 cd 6c ff 	movl 0xffffff6c(fp),0x34(r3)
   19afa:	a3 34 
   19afc:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   19b00:	d1 50 ef 91 	cmpl r0,3bf98 <__guard_local>
   19b04:	24 02 00 
   19b07:	13 10       	beql 19b19 <chacha_encrypt_bytes+0x635>
   19b09:	dd ad f8    	pushl 0xfffffff8(fp)
   19b0c:	9f ef 9b 17 	pushab 2b2ad <tau+0x10>
   19b10:	01 00 
   19b12:	fb 02 ef 53 	calls $0x2,1666c <__stack_smash_handler>
   19b16:	cb ff ff 
   19b19:	04          	ret

00019b1a <_rs_stir>:
   19b1a:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   19b1c:	c2 30 5e    	subl2 $0x30,sp
   19b1f:	d0 ef 73 24 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   19b23:	02 00 ad f8 
   19b27:	dd 28       	pushl $0x28
   19b29:	c3 30 5d 56 	subl3 $0x30,fp,r6
   19b2d:	dd 56       	pushl r6
   19b2f:	fb 02 ef 0e 	calls $0x2,1a044 <_thread_sys_getentropy>
   19b33:	05 00 00 
   19b36:	d1 50 8f ff 	cmpl r0,$0xffffffff
   19b3a:	ff ff ff 
   19b3d:	12 03       	bneq 19b42 <_rs_stir+0x28>
   19b3f:	31 09 01    	brw 19c4b <_rs_stir+0x131>
   19b42:	d5 ef c0 84 	tstl 62008 <rs>
   19b46:	04 00 
   19b48:	13 03       	beql 19b4d <_rs_stir+0x33>
   19b4a:	31 f4 00    	brw 19c41 <_rs_stir+0x127>
   19b4d:	d0 56 58    	movl r6,r8
   19b50:	7c 7e       	clrd -(sp)
   19b52:	d2 00 7e    	mcoml $0x0,-(sp)
   19b55:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   19b59:	7e 
   19b5a:	dd 03       	pushl $0x3
   19b5c:	3c 8f 48 04 	movzwl $0x0448,-(sp)
   19b60:	7e 
   19b61:	d4 7e       	clrf -(sp)
   19b63:	fb 07 ef f8 	calls $0x7,16a62 <_thread_sys_mmap>
   19b67:	ce ff ff 
   19b6a:	d0 50 56    	movl r0,r6
   19b6d:	d1 50 8f ff 	cmpl r0,$0xffffffff
   19b71:	ff ff ff 
   19b74:	13 30       	beql 19ba6 <_rs_stir+0x8c>
   19b76:	dd 03       	pushl $0x3
   19b78:	3c 8f 48 04 	movzwl $0x0448,-(sp)
   19b7c:	7e 
   19b7d:	dd 50       	pushl r0
   19b7f:	fb 03 ef 96 	calls $0x3,1a01c <_thread_sys_minherit>
   19b83:	04 00 00 
   19b86:	d0 50 57    	movl r0,r7
   19b89:	d1 50 8f ff 	cmpl r0,$0xffffffff
   19b8d:	ff ff ff 
   19b90:	12 03       	bneq 19b95 <_rs_stir+0x7b>
   19b92:	31 98 00    	brw 19c2d <_rs_stir+0x113>
   19b95:	d0 56 ef 6c 	movl r6,62008 <rs>
   19b99:	84 04 00 
   19b9c:	c1 56 08 ef 	addl3 r6,$0x8,6200c <rsx>
   19ba0:	68 84 04 00 
   19ba4:	d4 50       	clrf r0
   19ba6:	d1 50 8f ff 	cmpl r0,$0xffffffff
   19baa:	ff ff ff 
   19bad:	12 03       	bneq 19bb2 <_rs_stir+0x98>
   19baf:	31 a5 00    	brw 19c57 <_rs_stir+0x13d>
   19bb2:	d4 7e       	clrf -(sp)
   19bb4:	3c 8f 00 01 	movzwl $0x0100,-(sp)
   19bb8:	7e 
   19bb9:	dd 58       	pushl r8
   19bbb:	dd ef 4b 84 	pushl 6200c <rsx>
   19bbf:	04 00 
   19bc1:	fb 04 cf 30 	calls $0x4,191f6 <chacha_keysetup>
   19bc5:	f6 
   19bc6:	9f a8 20    	pushab 0x20(r8)
   19bc9:	dd ef 3d 84 	pushl 6200c <rsx>
   19bcd:	04 00 
   19bcf:	fb 02 cf 92 	calls $0x2,19466 <chacha_ivsetup>
   19bd3:	f8 
   19bd4:	dd 28       	pushl $0x28
   19bd6:	9f ad d0    	pushab 0xffffffd0(fp)
   19bd9:	fb 02 ef f8 	calls $0x2,19ed8 <explicit_bzero>
   19bdd:	02 00 00 
   19be0:	d4 ff 22 84 	clrf *62008 <rs>
   19be4:	04 00 
   19be6:	3c 8f 00 04 	movzwl $0x0400,-(sp)
   19bea:	7e 
   19beb:	d4 7e       	clrf -(sp)
   19bed:	c1 ef 19 84 	addl3 6200c <rsx>,$0x00000040,-(sp)
   19bf1:	04 00 8f 40 
   19bf5:	00 00 00 7e 
   19bf9:	fb 03 ef f8 	calls $0x3,168f8 <memset>
   19bfd:	cc ff ff 
   19c00:	d0 ef 02 84 	movl 62008 <rs>,r0
   19c04:	04 00 50 
   19c07:	d0 8f 00 6a 	movl $0x00186a00,0x4(r0)
   19c0b:	18 00 a0 04 
   19c0f:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   19c13:	d1 50 ef 7e 	cmpl r0,3bf98 <__guard_local>
   19c17:	23 02 00 
   19c1a:	13 10       	beql 19c2c <_rs_stir+0x112>
   19c1c:	dd ad f8    	pushl 0xfffffff8(fp)
   19c1f:	9f ef 9d 16 	pushab 2b2c2 <tau+0x25>
   19c23:	01 00 
   19c25:	fb 02 ef 40 	calls $0x2,1666c <__stack_smash_handler>
   19c29:	ca ff ff 
   19c2c:	04          	ret
   19c2d:	3c 8f 48 04 	movzwl $0x0448,-(sp)
   19c31:	7e 
   19c32:	dd 56       	pushl r6
   19c34:	fb 02 ef 91 	calls $0x2,16acc <_thread_sys_munmap>
   19c38:	ce ff ff 
   19c3b:	d0 57 50    	movl r7,r0
   19c3e:	31 65 ff    	brw 19ba6 <_rs_stir+0x8c>
   19c41:	dd 28       	pushl $0x28
   19c43:	dd 56       	pushl r6
   19c45:	fb 02 af 15 	calls $0x2,19c5e <_rs_rekey>
   19c49:	11 89       	brb 19bd4 <_rs_stir+0xba>
   19c4b:	dd 09       	pushl $0x9
   19c4d:	fb 01 ef ce 	calls $0x1,16822 <raise>
   19c51:	cb ff ff 
   19c54:	31 eb fe    	brw 19b42 <_rs_stir+0x28>
   19c57:	fb 00 ef 4a 	calls $0x0,167a8 <abort>
   19c5b:	cb ff ff 

00019c5e <_rs_rekey>:
   19c5e:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   19c60:	c2 04 5e    	subl2 $0x4,sp
   19c63:	d0 ac 04 56 	movl 0x4(ap),r6
   19c67:	3c 8f 00 04 	movzwl $0x0400,-(sp)
   19c6b:	7e 
   19c6c:	d0 ef 9a 83 	movl 6200c <rsx>,r1
   19c70:	04 00 51 
   19c73:	9e a1 40 50 	movab 0x40(r1),r0
   19c77:	dd 50       	pushl r0
   19c79:	dd 50       	pushl r0
   19c7b:	dd 51       	pushl r1
   19c7d:	fb 04 cf 62 	calls $0x4,194e4 <chacha_encrypt_bytes>
   19c81:	f8 
   19c82:	d5 56       	tstl r6
   19c84:	13 27       	beql 19cad <_rs_rekey+0x4f>
   19c86:	d0 ac 08 52 	movl 0x8(ap),r2
   19c8a:	d1 52 28    	cmpl r2,$0x28
   19c8d:	1b 03       	blequ 19c92 <_rs_rekey+0x34>
   19c8f:	d0 28 52    	movl $0x28,r2
   19c92:	d4 51       	clrf r1
   19c94:	d1 51 52    	cmpl r1,r2
   19c97:	1e 14       	bcc 19cad <_rs_rekey+0x4f>
   19c99:	c1 51 ef 6c 	addl3 r1,6200c <rsx>,r0
   19c9d:	83 04 00 50 
   19ca1:	8c 46 61 a0 	xorb2 (r1)[r6],0x40(r0)
   19ca5:	40 
   19ca6:	d6 51       	incl r1
   19ca8:	d1 51 52    	cmpl r1,r2
   19cab:	1f ec       	blssu 19c99 <_rs_rekey+0x3b>
   19cad:	c1 ef 59 83 	addl3 6200c <rsx>,$0x00000040,r8
   19cb1:	04 00 8f 40 
   19cb5:	00 00 00 58 
   19cb9:	d5 ef 49 83 	tstl 62008 <rs>
   19cbd:	04 00 
   19cbf:	12 5c       	bneq 19d1d <_rs_rekey+0xbf>
   19cc1:	7c 7e       	clrd -(sp)
   19cc3:	d2 00 7e    	mcoml $0x0,-(sp)
   19cc6:	3c 8f 02 10 	movzwl $0x1002,-(sp)
   19cca:	7e 
   19ccb:	dd 03       	pushl $0x3
   19ccd:	3c 8f 48 04 	movzwl $0x0448,-(sp)
   19cd1:	7e 
   19cd2:	d4 7e       	clrf -(sp)
   19cd4:	fb 07 ef 87 	calls $0x7,16a62 <_thread_sys_mmap>
   19cd8:	cd ff ff 
   19cdb:	d0 50 56    	movl r0,r6
   19cde:	d1 50 8f ff 	cmpl r0,$0xffffffff
   19ce2:	ff ff ff 
   19ce5:	13 2d       	beql 19d14 <_rs_rekey+0xb6>
   19ce7:	dd 03       	pushl $0x3
   19ce9:	3c 8f 48 04 	movzwl $0x0448,-(sp)
   19ced:	7e 
   19cee:	dd 50       	pushl r0
   19cf0:	fb 03 ef 25 	calls $0x3,1a01c <_thread_sys_minherit>
   19cf4:	03 00 00 
   19cf7:	d0 50 57    	movl r0,r7
   19cfa:	d1 50 8f ff 	cmpl r0,$0xffffffff
   19cfe:	ff ff ff 
   19d01:	13 5c       	beql 19d5f <_rs_rekey+0x101>
   19d03:	d0 56 ef fe 	movl r6,62008 <rs>
   19d07:	82 04 00 
   19d0a:	c1 56 08 ef 	addl3 r6,$0x8,6200c <rsx>
   19d0e:	fa 82 04 00 
   19d12:	d4 50       	clrf r0
   19d14:	d1 50 8f ff 	cmpl r0,$0xffffffff
   19d18:	ff ff ff 
   19d1b:	13 55       	beql 19d72 <_rs_rekey+0x114>
   19d1d:	d4 7e       	clrf -(sp)
   19d1f:	3c 8f 00 01 	movzwl $0x0100,-(sp)
   19d23:	7e 
   19d24:	dd 58       	pushl r8
   19d26:	dd ef e0 82 	pushl 6200c <rsx>
   19d2a:	04 00 
   19d2c:	fb 04 cf c5 	calls $0x4,191f6 <chacha_keysetup>
   19d30:	f4 
   19d31:	9f a8 20    	pushab 0x20(r8)
   19d34:	dd ef d2 82 	pushl 6200c <rsx>
   19d38:	04 00 
   19d3a:	fb 02 cf 27 	calls $0x2,19466 <chacha_ivsetup>
   19d3e:	f7 
   19d3f:	c1 ef c7 82 	addl3 6200c <rsx>,$0x00000040,r0
   19d43:	04 00 8f 40 
   19d47:	00 00 00 50 
   19d4b:	7c 80       	clrd (r0)+
   19d4d:	7c 80       	clrd (r0)+
   19d4f:	7c 80       	clrd (r0)+
   19d51:	7c 80       	clrd (r0)+
   19d53:	7c 60       	clrd (r0)
   19d55:	3c 8f d8 03 	movzwl $0x03d8,*62008 <rs>
   19d59:	ff aa 82 04 
   19d5d:	00 
   19d5e:	04          	ret
   19d5f:	3c 8f 48 04 	movzwl $0x0448,-(sp)
   19d63:	7e 
   19d64:	dd 56       	pushl r6
   19d66:	fb 02 ef 5f 	calls $0x2,16acc <_thread_sys_munmap>
   19d6a:	cd ff ff 
   19d6d:	d0 57 50    	movl r7,r0
   19d70:	11 a2       	brb 19d14 <_rs_rekey+0xb6>
   19d72:	fb 00 ef 2f 	calls $0x0,167a8 <abort>
   19d76:	ca ff ff 
   19d79:	01          	nop

00019d7a <arc4random>:
   19d7a:	40 00       	.word 0x0040 # Entry mask: < r6 >
   19d7c:	c2 08 5e    	subl2 $0x8,sp
   19d7f:	d5 ef 5f 23 	tstl 5c0e4 <__isthreaded>
   19d83:	04 00 
   19d85:	12 79       	bneq 19e00 <arc4random+0x86>
   19d87:	d0 04 56    	movl $0x4,r6
   19d8a:	d0 ef 78 82 	movl 62008 <rs>,r0
   19d8e:	04 00 50 
   19d91:	13 06       	beql 19d99 <arc4random+0x1f>
   19d93:	d1 a0 04 56 	cmpl 0x4(r0),r6
   19d97:	1a 05       	bgtru 19d9e <arc4random+0x24>
   19d99:	fb 00 cf 7c 	calls $0x0,19b1a <_rs_stir>
   19d9d:	fd 
   19d9e:	d0 ef 64 82 	movl 62008 <rs>,r0
   19da2:	04 00 50 
   19da5:	d0 a0 04 51 	movl 0x4(r0),r1
   19da9:	d1 51 56    	cmpl r1,r6
   19dac:	1a 4b       	bgtru 19df9 <arc4random+0x7f>
   19dae:	d4 a0 04    	clrf 0x4(r0)
   19db1:	d1 ff 51 82 	cmpl *62008 <rs>,$0x3
   19db5:	04 00 03 
   19db8:	1b 34       	blequ 19dee <arc4random+0x74>
   19dba:	c3 ff 48 82 	subl3 *62008 <rs>,6200c <rsx>,r0
   19dbe:	04 00 ef 47 
   19dc2:	82 04 00 50 
   19dc6:	9e c0 40 04 	movab 0x440(r0),r0
   19dca:	50 
   19dcb:	d0 60 ad f8 	movl (r0),0xfffffff8(fp)
   19dcf:	d4 60       	clrf (r0)
   19dd1:	c2 04 ff 30 	subl2 $0x4,*62008 <rs>
   19dd5:	82 04 00 
   19dd8:	d5 ef 06 23 	tstl 5c0e4 <__isthreaded>
   19ddc:	04 00 
   19dde:	12 05       	bneq 19de5 <arc4random+0x6b>
   19de0:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   19de4:	04          	ret
   19de5:	fb 00 ef 14 	calls $0x0,16b00 <_weak__thread_arc4_unlock>
   19de9:	cd ff ff 
   19dec:	11 f2       	brb 19de0 <arc4random+0x66>
   19dee:	d4 7e       	clrf -(sp)
   19df0:	d4 7e       	clrf -(sp)
   19df2:	fb 02 cf 67 	calls $0x2,19c5e <_rs_rekey>
   19df6:	fe 
   19df7:	11 c1       	brb 19dba <arc4random+0x40>
   19df9:	c3 56 51 a0 	subl3 r6,r1,0x4(r0)
   19dfd:	04 
   19dfe:	11 b1       	brb 19db1 <arc4random+0x37>
   19e00:	fb 00 ef f3 	calls $0x0,16afa <_weak__thread_arc4_lock>
   19e04:	cc ff ff 
   19e07:	31 7d ff    	brw 19d87 <arc4random+0xd>

00019e0a <arc4random_buf>:
   19e0a:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   19e0c:	c2 04 5e    	subl2 $0x4,sp
   19e0f:	d5 ef cf 22 	tstl 5c0e4 <__isthreaded>
   19e13:	04 00 
   19e15:	13 03       	beql 19e1a <arc4random_buf+0x10>
   19e17:	31 ae 00    	brw 19ec8 <arc4random_buf+0xbe>
   19e1a:	d0 ac 08 58 	movl 0x8(ap),r8
   19e1e:	d0 ac 04 59 	movl 0x4(ap),r9
   19e22:	d0 58 56    	movl r8,r6
   19e25:	d0 ef dd 81 	movl 62008 <rs>,r0
   19e29:	04 00 50 
   19e2c:	13 06       	beql 19e34 <arc4random_buf+0x2a>
   19e2e:	d1 a0 04 58 	cmpl 0x4(r0),r8
   19e32:	1a 05       	bgtru 19e39 <arc4random_buf+0x2f>
   19e34:	fb 00 cf e1 	calls $0x0,19b1a <_rs_stir>
   19e38:	fc 
   19e39:	d0 ef c9 81 	movl 62008 <rs>,r0
   19e3d:	04 00 50 
   19e40:	d0 a0 04 51 	movl 0x4(r0),r1
   19e44:	d1 51 56    	cmpl r1,r6
   19e47:	1a 78       	bgtru 19ec1 <arc4random_buf+0xb7>
   19e49:	d4 a0 04    	clrf 0x4(r0)
   19e4c:	d5 58       	tstl r8
   19e4e:	13 54       	beql 19ea4 <arc4random_buf+0x9a>
   19e50:	d0 ff b2 81 	movl *62008 <rs>,r0
   19e54:	04 00 50 
   19e57:	13 3f       	beql 19e98 <arc4random_buf+0x8e>
   19e59:	d0 50 57    	movl r0,r7
   19e5c:	d1 50 58    	cmpl r0,r8
   19e5f:	1b 03       	blequ 19e64 <arc4random_buf+0x5a>
   19e61:	d0 58 57    	movl r8,r7
   19e64:	c3 50 ef a1 	subl3 r0,6200c <rsx>,r6
   19e68:	81 04 00 56 
   19e6c:	9e c6 40 04 	movab 0x440(r6),r6
   19e70:	56 
   19e71:	dd 57       	pushl r7
   19e73:	dd 56       	pushl r6
   19e75:	dd 59       	pushl r9
   19e77:	fb 03 ef 70 	calls $0x3,166ee <memcpy>
   19e7b:	c8 ff ff 
   19e7e:	dd 57       	pushl r7
   19e80:	d4 7e       	clrf -(sp)
   19e82:	dd 56       	pushl r6
   19e84:	fb 03 ef 6d 	calls $0x3,168f8 <memset>
   19e88:	ca ff ff 
   19e8b:	c0 57 59    	addl2 r7,r9
   19e8e:	c2 57 58    	subl2 r7,r8
   19e91:	c2 57 ff 70 	subl2 r7,*62008 <rs>
   19e95:	81 04 00 
   19e98:	d5 ff 6a 81 	tstl *62008 <rs>
   19e9c:	04 00 
   19e9e:	13 16       	beql 19eb6 <arc4random_buf+0xac>
   19ea0:	d5 58       	tstl r8
   19ea2:	12 ac       	bneq 19e50 <arc4random_buf+0x46>
   19ea4:	d5 ef 3a 22 	tstl 5c0e4 <__isthreaded>
   19ea8:	04 00 
   19eaa:	12 01       	bneq 19ead <arc4random_buf+0xa3>
   19eac:	04          	ret
   19ead:	fb 00 ef 4c 	calls $0x0,16b00 <_weak__thread_arc4_unlock>
   19eb1:	cc ff ff 
   19eb4:	11 f6       	brb 19eac <arc4random_buf+0xa2>
   19eb6:	d4 7e       	clrf -(sp)
   19eb8:	d4 7e       	clrf -(sp)
   19eba:	fb 02 cf 9f 	calls $0x2,19c5e <_rs_rekey>
   19ebe:	fd 
   19ebf:	11 df       	brb 19ea0 <arc4random_buf+0x96>
   19ec1:	c3 56 51 a0 	subl3 r6,r1,0x4(r0)
   19ec5:	04 
   19ec6:	11 84       	brb 19e4c <arc4random_buf+0x42>
   19ec8:	fb 00 ef 2b 	calls $0x0,16afa <_weak__thread_arc4_lock>
   19ecc:	cc ff ff 
   19ecf:	31 48 ff    	brw 19e1a <arc4random_buf+0x10>

00019ed2 <__explicit_bzero_hook>:
   19ed2:	00 00       	.word 0x0000 # Entry mask: < >
   19ed4:	c2 04 5e    	subl2 $0x4,sp
   19ed7:	04          	ret

00019ed8 <explicit_bzero>:
   19ed8:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   19eda:	c2 04 5e    	subl2 $0x4,sp
   19edd:	d0 ac 04 57 	movl 0x4(ap),r7
   19ee1:	d0 ac 08 56 	movl 0x8(ap),r6
   19ee5:	dd 56       	pushl r6
   19ee7:	d4 7e       	clrf -(sp)
   19ee9:	dd 57       	pushl r7
   19eeb:	fb 03 ef 06 	calls $0x3,168f8 <memset>
   19eef:	ca ff ff 
   19ef2:	dd 56       	pushl r6
   19ef4:	dd 57       	pushl r7
   19ef6:	fb 02 ef d5 	calls $0x2,19ed2 <__explicit_bzero_hook>
   19efa:	ff ff ff 
   19efd:	04          	ret

00019efe <snprintf>:
   19efe:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   19f00:	9e ce 88 fe 	movab 0xfffffe88(sp),sp
   19f04:	5e 
   19f05:	d0 ac 08 56 	movl 0x8(ap),r6
   19f09:	d0 ef 89 20 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   19f0d:	02 00 ad f8 
   19f11:	d0 ac 04 57 	movl 0x4(ap),r7
   19f15:	d5 56       	tstl r6
   19f17:	19 7a       	blss 19f93 <snprintf+0x95>
   19f19:	d5 56       	tstl r6
   19f1b:	12 08       	bneq 19f25 <snprintf+0x27>
   19f1d:	9e cd 8b fe 	movab 0xfffffe8b(fp),r7
   19f21:	57 
   19f22:	d0 01 56    	movl $0x1,r6
   19f25:	9e cd 8c fe 	movab 0xfffffe8c(fp),r0
   19f29:	50 
   19f2a:	d0 50 ad d0 	movl r0,0xffffffd0(fp)
   19f2e:	d4 60       	clrf (r0)
   19f30:	d4 a0 04    	clrf 0x4(r0)
   19f33:	3c 8f 0c 01 	movzwl $0x010c,-(sp)
   19f37:	7e 
   19f38:	d4 7e       	clrf -(sp)
   19f3a:	9f a0 08    	pushab 0x8(r0)
   19f3d:	fb 03 ef b4 	calls $0x3,168f8 <memset>
   19f41:	c9 ff ff 
   19f44:	b2 00 ad ae 	mcomw $0x0,0xffffffae(fp)
   19f48:	b0 8f 08 02 	movw $0x0208,0xffffffac(fp)
   19f4c:	ad ac 
   19f4e:	d0 57 ad a0 	movl r7,0xffffffa0(fp)
   19f52:	d0 57 ad b0 	movl r7,0xffffffb0(fp)
   19f56:	c3 01 56 50 	subl3 $0x1,r6,r0
   19f5a:	d0 50 ad a8 	movl r0,0xffffffa8(fp)
   19f5e:	d0 50 ad b4 	movl r0,0xffffffb4(fp)
   19f62:	9f ac 10    	pushab 0x10(ap)
   19f65:	dd ac 0c    	pushl 0xc(ap)
   19f68:	9f ad a0    	pushab 0xffffffa0(fp)
   19f6b:	fb 03 ef 34 	calls $0x3,114a6 <__vfprintf>
   19f6f:	75 ff ff 
   19f72:	94 bd a0    	clrb *0xffffffa0(fp)
   19f75:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   19f79:	d1 51 ef 18 	cmpl r1,3bf98 <__guard_local>
   19f7d:	20 02 00 
   19f80:	13 10       	beql 19f92 <snprintf+0x94>
   19f82:	dd ad f8    	pushl 0xfffffff8(fp)
   19f85:	9f ef ab 10 	pushab 2b036 <_DefaultTimeLocale+0x21e>
   19f89:	01 00 
   19f8b:	fb 02 ef da 	calls $0x2,1666c <__stack_smash_handler>
   19f8f:	c6 ff ff 
   19f92:	04          	ret
   19f93:	d0 8f ff ff 	movl $0x7fffffff,r6
   19f97:	ff 7f 56 
   19f9a:	31 7c ff    	brw 19f19 <snprintf+0x1b>
   19f9d:	01          	nop
   19f9e:	01          	nop
   19f9f:	01          	nop
   19fa0:	17 ef 13 6a 	jmp 109b9 <___cerror>
   19fa4:	ff ff 
   19fa6:	01          	nop
   19fa7:	01          	nop

00019fa8 <_thread_sys_open>:
   19fa8:	00 00       	.word 0x0000 # Entry mask: < >
   19faa:	bc 05       	chmk $0x5
   19fac:	1f f2       	blssu 19fa0 <snprintf+0xa2>
   19fae:	04          	ret
   19faf:	01          	nop
   19fb0:	17 ef 03 6a 	jmp 109b9 <___cerror>
   19fb4:	ff ff 
   19fb6:	01          	nop
   19fb7:	01          	nop

00019fb8 <_thread_sys_writev>:
   19fb8:	00 00       	.word 0x0000 # Entry mask: < >
   19fba:	bc 8f 79 00 	chmk $0x0079
   19fbe:	1f f0       	blssu 19fb0 <_thread_sys_open+0x8>
   19fc0:	04          	ret
   19fc1:	01          	nop
   19fc2:	01          	nop
   19fc3:	01          	nop
   19fc4:	17 ef ef 69 	jmp 109b9 <___cerror>
   19fc8:	ff ff 
   19fca:	01          	nop
   19fcb:	01          	nop

00019fcc <_thread_sys_readlink>:
   19fcc:	00 00       	.word 0x0000 # Entry mask: < >
   19fce:	bc 3a       	chmk $0x3a
   19fd0:	1f f2       	blssu 19fc4 <_thread_sys_writev+0xc>
   19fd2:	04          	ret
   19fd3:	01          	nop
   19fd4:	17 ef df 69 	jmp 109b9 <___cerror>
   19fd8:	ff ff 
   19fda:	01          	nop
   19fdb:	01          	nop

00019fdc <_thread_sys_sendsyslog>:
   19fdc:	00 00       	.word 0x0000 # Entry mask: < >
   19fde:	bc 8f 53 00 	chmk $0x0053
   19fe2:	1f f0       	blssu 19fd4 <_thread_sys_readlink+0x8>
   19fe4:	04          	ret
   19fe5:	01          	nop

00019fe6 <_thread_sys_mquery>:
   19fe6:	00 00       	.word 0x0000 # Entry mask: < >
   19fe8:	c2 04 5e    	subl2 $0x4,sp
   19feb:	7d ac 18 7e 	movq 0x18(ap),-(sp)
   19fef:	d4 7e       	clrf -(sp)
   19ff1:	dd ac 14    	pushl 0x14(ap)
   19ff4:	dd ac 10    	pushl 0x10(ap)
   19ff7:	dd ac 0c    	pushl 0xc(ap)
   19ffa:	dd ac 08    	pushl 0x8(ap)
   19ffd:	dd ac 04    	pushl 0x4(ap)
   1a000:	7d 8f 1e 01 	movq $0x000000000000011e,-(sp)
   1a004:	00 00 00 00 
   1a008:	00 00 7e 
   1a00b:	fb 0a ef fe 	calls $0xa,16b10 <_thread_sys___syscall>
   1a00f:	ca ff ff 
   1a012:	04          	ret
   1a013:	01          	nop
   1a014:	17 ef 9f 69 	jmp 109b9 <___cerror>
   1a018:	ff ff 
   1a01a:	01          	nop
   1a01b:	01          	nop

0001a01c <_thread_sys_minherit>:
   1a01c:	00 00       	.word 0x0000 # Entry mask: < >
   1a01e:	bc 8f fa 00 	chmk $0x00fa
   1a022:	1f f0       	blssu 1a014 <_thread_sys_mquery+0x2e>
   1a024:	04          	ret
   1a025:	01          	nop
   1a026:	01          	nop
   1a027:	01          	nop
   1a028:	17 ef 8b 69 	jmp 109b9 <___cerror>
   1a02c:	ff ff 
   1a02e:	01          	nop
   1a02f:	01          	nop

0001a030 <_thread_sys_issetugid>:
   1a030:	00 00       	.word 0x0000 # Entry mask: < >
   1a032:	bc 8f fd 00 	chmk $0x00fd
   1a036:	1f f0       	blssu 1a028 <_thread_sys_minherit+0xc>
   1a038:	04          	ret
   1a039:	01          	nop
   1a03a:	01          	nop
   1a03b:	01          	nop
   1a03c:	17 ef 77 69 	jmp 109b9 <___cerror>
   1a040:	ff ff 
   1a042:	01          	nop
   1a043:	01          	nop

0001a044 <_thread_sys_getentropy>:
   1a044:	00 00       	.word 0x0000 # Entry mask: < >
   1a046:	bc 07       	chmk $0x7
   1a048:	1f f2       	blssu 1a03c <_thread_sys_issetugid+0xc>
   1a04a:	04          	ret
   1a04b:	01          	nop
   1a04c:	17 ef 67 69 	jmp 109b9 <___cerror>
   1a050:	ff ff 
   1a052:	01          	nop
   1a053:	01          	nop

0001a054 <_thread_sys_madvise>:
   1a054:	00 00       	.word 0x0000 # Entry mask: < >
   1a056:	bc 8f 4b 00 	chmk $0x004b
   1a05a:	1f f0       	blssu 1a04c <_thread_sys_getentropy+0x8>
   1a05c:	04          	ret
   1a05d:	01          	nop

0001a05e <__digits10>:
   1a05e:	40 00       	.word 0x0040 # Entry mask: < r6 >
   1a060:	c2 04 5e    	subl2 $0x4,sp
   1a063:	d0 ac 04 50 	movl 0x4(ap),r0
   1a067:	d4 56       	clrf r6
   1a069:	dd 0a       	pushl $0xa
   1a06b:	dd 50       	pushl r0
   1a06d:	fb 02 ef 70 	calls $0x2,15ce4 <__udiv>
   1a071:	bc ff ff 
   1a074:	d6 56       	incl r6
   1a076:	d5 50       	tstl r0
   1a078:	12 ef       	bneq 1a069 <__digits10+0xb>
   1a07a:	d0 56 50    	movl r6,r0
   1a07d:	04          	ret

0001a07e <__itoa>:
   1a07e:	c0 03       	.word 0x03c0 # Entry mask: < r9 r8 r7 r6 >
   1a080:	c2 04 5e    	subl2 $0x4,sp
   1a083:	d0 ac 04 50 	movl 0x4(ap),r0
   1a087:	d0 ac 0c 58 	movl 0xc(ap),r8
   1a08b:	d5 ac 08    	tstl 0x8(ap)
   1a08e:	13 04       	beql 1a094 <__itoa+0x16>
   1a090:	d5 50       	tstl r0
   1a092:	19 52       	blss 1a0e6 <__itoa+0x68>
   1a094:	d0 50 57    	movl r0,r7
   1a097:	d4 59       	clrf r9
   1a099:	dd 57       	pushl r7
   1a09b:	fb 01 af bf 	calls $0x1,1a05e <__digits10>
   1a09f:	c1 ac 10 50 	addl3 0x10(ap),r0,r6
   1a0a3:	56 
   1a0a4:	d5 59       	tstl r9
   1a0a6:	13 02       	beql 1a0aa <__itoa+0x2c>
   1a0a8:	d6 56       	incl r6
   1a0aa:	d1 56 ac 14 	cmpl r6,0x14(ap)
   1a0ae:	1e 32       	bcc 1a0e2 <__itoa+0x64>
   1a0b0:	94 48 66    	clrb (r6)[r8]
   1a0b3:	d7 56       	decl r6
   1a0b5:	dd 0a       	pushl $0xa
   1a0b7:	dd 57       	pushl r7
   1a0b9:	fb 02 ef 80 	calls $0x2,15d40 <__urem>
   1a0bd:	bc ff ff 
   1a0c0:	81 50 30 48 	addb3 r0,$0x30,(r6)[r8]
   1a0c4:	66 
   1a0c5:	d7 56       	decl r6
   1a0c7:	dd 0a       	pushl $0xa
   1a0c9:	dd 57       	pushl r7
   1a0cb:	fb 02 ef 12 	calls $0x2,15ce4 <__udiv>
   1a0cf:	bc ff ff 
   1a0d2:	d0 50 57    	movl r0,r7
   1a0d5:	12 de       	bneq 1a0b5 <__itoa+0x37>
   1a0d7:	d5 59       	tstl r9
   1a0d9:	13 04       	beql 1a0df <__itoa+0x61>
   1a0db:	90 2d 48 66 	movb $0x2d,(r6)[r8]
   1a0df:	d4 50       	clrf r0
   1a0e1:	04          	ret
   1a0e2:	d0 22 50    	movl $0x22,r0
   1a0e5:	04          	ret
   1a0e6:	ce 50 57    	mnegl r0,r7
   1a0e9:	d0 01 59    	movl $0x1,r9
   1a0ec:	11 ab       	brb 1a099 <__itoa+0x1b>

0001a0ee <__num2string>:
   1a0ee:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   1a0f0:	c2 04 5e    	subl2 $0x4,sp
   1a0f3:	d0 ac 04 58 	movl 0x4(ap),r8
   1a0f7:	d0 ac 0c 5b 	movl 0xc(ap),r11
   1a0fb:	d0 ac 10 5a 	movl 0x10(ap),r10
   1a0ff:	d0 ac 14 59 	movl 0x14(ap),r9
   1a103:	d4 57       	clrf r7
   1a105:	dd 01       	pushl $0x1
   1a107:	9f ef be 11 	pushab 2b2cb <tau+0x2e>
   1a10b:	01 00 
   1a10d:	fb 02 ef ba 	calls $0x2,1a4ce <_catopen>
   1a111:	03 00 00 
   1a114:	d0 50 56    	movl r0,r6
   1a117:	d5 58       	tstl r8
   1a119:	19 06       	blss 1a121 <__num2string+0x33>
   1a11b:	d1 58 ac 1c 	cmpl r8,0x1c(ap)
   1a11f:	1f 4f       	blssu 1a170 <__num2string+0x82>
   1a121:	dd 59       	pushl r9
   1a123:	dd ac 20    	pushl 0x20(ap)
   1a126:	3c 8f ff ff 	movzwl $0xffff,-(sp)
   1a12a:	7e 
   1a12b:	dd 5b       	pushl r11
   1a12d:	dd 56       	pushl r6
   1a12f:	fb 04 ef 16 	calls $0x4,1a24c <_catgets>
   1a133:	01 00 00 
   1a136:	dd 50       	pushl r0
   1a138:	dd 5a       	pushl r10
   1a13a:	fb 03 ef a9 	calls $0x3,1a8ea <strlcpy>
   1a13e:	07 00 00 
   1a141:	d1 50 59    	cmpl r0,r9
   1a144:	1f 10       	blssu 1a156 <__num2string+0x68>
   1a146:	d0 22 57    	movl $0x22,r7
   1a149:	dd 56       	pushl r6
   1a14b:	fb 01 ef be 	calls $0x1,1a210 <_catclose>
   1a14f:	00 00 00 
   1a152:	d0 57 50    	movl r7,r0
   1a155:	04          	ret
   1a156:	dd 59       	pushl r9
   1a158:	dd 50       	pushl r0
   1a15a:	dd 5a       	pushl r10
   1a15c:	dd ac 08    	pushl 0x8(ap)
   1a15f:	dd 58       	pushl r8
   1a161:	fb 05 cf 18 	calls $0x5,1a07e <__itoa>
   1a165:	ff 
   1a166:	d0 50 57    	movl r0,r7
   1a169:	12 de       	bneq 1a149 <__num2string+0x5b>
   1a16b:	d0 16 57    	movl $0x16,r7
   1a16e:	11 d9       	brb 1a149 <__num2string+0x5b>
   1a170:	dd 59       	pushl r9
   1a172:	dd 48 bc 18 	pushl *0x18(ap)[r8]
   1a176:	dd 58       	pushl r8
   1a178:	dd 5b       	pushl r11
   1a17a:	dd 50       	pushl r0
   1a17c:	fb 04 ef c9 	calls $0x4,1a24c <_catgets>
   1a180:	00 00 00 
   1a183:	dd 50       	pushl r0
   1a185:	dd 5a       	pushl r10
   1a187:	fb 03 ef 5c 	calls $0x3,1a8ea <strlcpy>
   1a18b:	07 00 00 
   1a18e:	d1 50 59    	cmpl r0,r9
   1a191:	1f b6       	blssu 1a149 <__num2string+0x5b>
   1a193:	11 b1       	brb 1a146 <__num2string+0x58>
   1a195:	01          	nop

0001a196 <strerror_r>:
   1a196:	c0 01       	.word 0x01c0 # Entry mask: < r8 r7 r6 >
   1a198:	c2 04 5e    	subl2 $0x4,sp
   1a19b:	9e ef 27 68 	movab 109c8 <___errno>,r6
   1a19f:	ff ff 56 
   1a1a2:	fb 00 66    	calls $0x0,(r6)
   1a1a5:	d0 60 58    	movl (r0),r8
   1a1a8:	9f ef 22 11 	pushab 2b2d0 <tau+0x33>
   1a1ac:	01 00 
   1a1ae:	dd ef 9c 2c 	pushl 5ce50 <_sys_nerr>
   1a1b2:	04 00 
   1a1b4:	9f ef b6 11 	pushab 2b370 <_sys_errlist>
   1a1b8:	01 00 
   1a1ba:	dd ac 0c    	pushl 0xc(ap)
   1a1bd:	dd ac 08    	pushl 0x8(ap)
   1a1c0:	dd 01       	pushl $0x1
   1a1c2:	dd 01       	pushl $0x1
   1a1c4:	dd ac 04    	pushl 0x4(ap)
   1a1c7:	fb 08 cf 22 	calls $0x8,1a0ee <__num2string>
   1a1cb:	ff 
   1a1cc:	d0 50 57    	movl r0,r7
   1a1cf:	fb 00 66    	calls $0x0,(r6)
   1a1d2:	d0 57 51    	movl r7,r1
   1a1d5:	12 03       	bneq 1a1da <strerror_r+0x44>
   1a1d7:	d0 58 51    	movl r8,r1
   1a1da:	d0 51 60    	movl r1,(r0)
   1a1dd:	d0 57 50    	movl r7,r0
   1a1e0:	04          	ret
   1a1e1:	01          	nop

0001a1e2 <__strsignal>:
   1a1e2:	40 00       	.word 0x0040 # Entry mask: < r6 >
   1a1e4:	c2 04 5e    	subl2 $0x4,sp
   1a1e7:	d0 ac 08 56 	movl 0x8(ap),r6
   1a1eb:	9f ef ef 10 	pushab 2b2e0 <tau+0x43>
   1a1ef:	01 00 
   1a1f1:	dd 21       	pushl $0x21
   1a1f3:	9f ef 1f 1b 	pushab 2bd18 <_sys_siglist>
   1a1f7:	01 00 
   1a1f9:	9a 8f ff 7e 	movzbl $0xff,-(sp)
   1a1fd:	dd 56       	pushl r6
   1a1ff:	dd 02       	pushl $0x2
   1a201:	d4 7e       	clrf -(sp)
   1a203:	dd ac 04    	pushl 0x4(ap)
   1a206:	fb 08 cf e3 	calls $0x8,1a0ee <__num2string>
   1a20a:	fe 
   1a20b:	d0 56 50    	movl r6,r0
   1a20e:	04          	ret
   1a20f:	01          	nop

0001a210 <_catclose>:
   1a210:	40 00       	.word 0x0040 # Entry mask: < r6 >
   1a212:	c2 04 5e    	subl2 $0x4,sp
   1a215:	d0 ac 04 56 	movl 0x4(ap),r6
   1a219:	d1 56 8f ff 	cmpl r6,$0xffffffff
   1a21d:	ff ff ff 
   1a220:	13 1c       	beql 1a23e <_catclose+0x2e>
   1a222:	d5 56       	tstl r6
   1a224:	13 15       	beql 1a23b <_catclose+0x2b>
   1a226:	dd a6 04    	pushl 0x4(r6)
   1a229:	dd 66       	pushl (r6)
   1a22b:	fb 02 ef 9a 	calls $0x2,16acc <_thread_sys_munmap>
   1a22f:	c8 ff ff 
   1a232:	dd 56       	pushl r6
   1a234:	fb 01 ef 8d 	calls $0x1,188c8 <free>
   1a238:	e6 ff ff 
   1a23b:	d4 50       	clrf r0
   1a23d:	04          	ret
   1a23e:	fb 00 ef 83 	calls $0x0,109c8 <___errno>
   1a242:	67 ff ff 
   1a245:	d0 09 60    	movl $0x9,(r0)
   1a248:	d0 56 50    	movl r6,r0
   1a24b:	04          	ret

0001a24c <_catgets>:
   1a24c:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   1a24e:	c2 08 5e    	subl2 $0x8,sp
   1a251:	d1 ac 04 8f 	cmpl 0x4(ap),$0xffffffff
   1a255:	ff ff ff ff 
   1a259:	12 03       	bneq 1a25e <_catgets+0x12>
   1a25b:	31 62 02    	brw 1a4c0 <_catgets+0x274>
   1a25e:	d0 ac 04 50 	movl 0x4(ap),r0
   1a262:	d0 60 ad f8 	movl (r0),0xfffffff8(fp)
   1a266:	c1 ad f8 14 	addl3 0xfffffff8(fp),$0x14,r11
   1a26a:	5b 
   1a26b:	d4 57       	clrf r7
   1a26d:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   1a271:	d0 a1 04 50 	movl 0x4(r1),r0
   1a275:	78 18 50 52 	ashl $0x18,r0,r2
   1a279:	9c 08 50 51 	rotl $0x8,r0,r1
   1a27d:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   1a281:	00 ff 51 
   1a284:	c8 51 52    	bisl2 r1,r2
   1a287:	cb 8f ff ff 	bicl3 $0xff00ffff,r0,r1
   1a28b:	00 ff 50 51 
   1a28f:	d0 08 53    	movl $0x8,r3
   1a292:	ef 53 18 51 	extzv r3,$0x18,r1,r1
   1a296:	51 
   1a297:	c8 51 52    	bisl2 r1,r2
   1a29a:	ca 8f ff ff 	bicl2 $0x00ffffff,r0
   1a29e:	ff 00 50 
   1a2a1:	ef 18 53 50 	extzv $0x18,r3,r0,r0
   1a2a5:	50 
   1a2a6:	c8 50 52    	bisl2 r0,r2
   1a2a9:	c3 01 52 54 	subl3 $0x1,r2,r4
   1a2ad:	d1 57 54    	cmpl r7,r4
   1a2b0:	14 62       	bgtr 1a314 <_catgets+0xc8>
   1a2b2:	c1 57 54 50 	addl3 r7,r4,r0
   1a2b6:	c7 02 50 53 	divl3 $0x2,r0,r3
   1a2ba:	c5 53 0c 50 	mull3 r3,$0xc,r0
   1a2be:	c1 50 5b 55 	addl3 r0,r11,r5
   1a2c2:	d0 65 50    	movl (r5),r0
   1a2c5:	78 18 50 52 	ashl $0x18,r0,r2
   1a2c9:	9c 08 50 51 	rotl $0x8,r0,r1
   1a2cd:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   1a2d1:	00 ff 51 
   1a2d4:	c8 51 52    	bisl2 r1,r2
   1a2d7:	cb 8f ff ff 	bicl3 $0xff00ffff,r0,r1
   1a2db:	00 ff 50 51 
   1a2df:	d0 08 56    	movl $0x8,r6
   1a2e2:	90 18 5a    	movb $0x18,r10
   1a2e5:	ef 56 5a 51 	extzv r6,r10,r1,r1
   1a2e9:	51 
   1a2ea:	c8 51 52    	bisl2 r1,r2
   1a2ed:	ca 8f ff ff 	bicl2 $0x00ffffff,r0
   1a2f1:	ff 00 50 
   1a2f4:	d0 18 59    	movl $0x18,r9
   1a2f7:	90 56 58    	movb r6,r8
   1a2fa:	ef 59 56 50 	extzv r9,r6,r0,r0
   1a2fe:	50 
   1a2ff:	c8 50 52    	bisl2 r0,r2
   1a302:	c3 52 ac 08 	subl3 r2,0x8(ap),r0
   1a306:	50 
   1a307:	13 16       	beql 1a31f <_catgets+0xd3>
   1a309:	19 0e       	blss 1a319 <_catgets+0xcd>
   1a30b:	c1 53 01 57 	addl3 r3,$0x1,r7
   1a30f:	d1 57 54    	cmpl r7,r4
   1a312:	15 9e       	bleq 1a2b2 <_catgets+0x66>
   1a314:	d0 ac 10 50 	movl 0x10(ap),r0
   1a318:	04          	ret
   1a319:	c3 01 53 54 	subl3 $0x1,r3,r4
   1a31d:	11 f0       	brb 1a30f <_catgets+0xc3>
   1a31f:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   1a323:	d0 a0 0c 51 	movl 0xc(r0),r1
   1a327:	78 5a 51 52 	ashl r10,r1,r2
   1a32b:	9c 08 51 50 	rotl $0x8,r1,r0
   1a32f:	ca 8f ff ff 	bicl2 $0xff00ffff,r0
   1a333:	00 ff 50 
   1a336:	c8 50 52    	bisl2 r0,r2
   1a339:	cb 8f ff ff 	bicl3 $0xff00ffff,r1,r0
   1a33d:	00 ff 51 50 
   1a341:	ef 56 5a 50 	extzv r6,r10,r0,r0
   1a345:	50 
   1a346:	c8 50 52    	bisl2 r0,r2
   1a349:	ca 8f ff ff 	bicl2 $0x00ffffff,r1
   1a34d:	ff 00 51 
   1a350:	ef 59 56 51 	extzv r9,r6,r1,r1
   1a354:	51 
   1a355:	c8 51 52    	bisl2 r1,r2
   1a358:	d0 ac 04 51 	movl 0x4(ap),r1
   1a35c:	c0 61 52    	addl2 (r1),r2
   1a35f:	c1 52 14 5b 	addl3 r2,$0x14,r11
   1a363:	d0 a5 08 51 	movl 0x8(r5),r1
   1a367:	78 5a 51 52 	ashl r10,r1,r2
   1a36b:	9c 08 51 50 	rotl $0x8,r1,r0
   1a36f:	ca 8f ff ff 	bicl2 $0xff00ffff,r0
   1a373:	00 ff 50 
   1a376:	c8 50 52    	bisl2 r0,r2
   1a379:	cb 8f ff ff 	bicl3 $0xff00ffff,r1,r0
   1a37d:	00 ff 51 50 
   1a381:	ef 56 5a 50 	extzv r6,r10,r0,r0
   1a385:	50 
   1a386:	c8 50 52    	bisl2 r0,r2
   1a389:	ca 8f ff ff 	bicl2 $0x00ffffff,r1
   1a38d:	ff 00 51 
   1a390:	ef 59 56 51 	extzv r9,r6,r1,r1
   1a394:	51 
   1a395:	c9 51 52 57 	bisl3 r1,r2,r7
   1a399:	d0 a5 04 51 	movl 0x4(r5),r1
   1a39d:	78 5a 51 52 	ashl r10,r1,r2
   1a3a1:	9c 08 51 50 	rotl $0x8,r1,r0
   1a3a5:	ca 8f ff ff 	bicl2 $0xff00ffff,r0
   1a3a9:	00 ff 50 
   1a3ac:	c8 50 52    	bisl2 r0,r2
   1a3af:	cb 8f ff ff 	bicl3 $0xff00ffff,r1,r0
   1a3b3:	00 ff 51 50 
   1a3b7:	ef 56 5a 50 	extzv r6,r10,r0,r0
   1a3bb:	50 
   1a3bc:	c8 50 52    	bisl2 r0,r2
   1a3bf:	ca 8f ff ff 	bicl2 $0x00ffffff,r1
   1a3c3:	ff 00 51 
   1a3c6:	ef 59 56 51 	extzv r9,r6,r1,r1
   1a3ca:	51 
   1a3cb:	c8 51 52    	bisl2 r1,r2
   1a3ce:	9e 47 a2 ff 	movab 0xffffffff(r2)[r7],r4
   1a3d2:	54 
   1a3d3:	d1 57 54    	cmpl r7,r4
   1a3d6:	14 62       	bgtr 1a43a <_catgets+0x1ee>
   1a3d8:	c1 57 54 50 	addl3 r7,r4,r0
   1a3dc:	c7 02 50 53 	divl3 $0x2,r0,r3
   1a3e0:	c5 53 0c 50 	mull3 r3,$0xc,r0
   1a3e4:	c1 50 5b 5a 	addl3 r0,r11,r10
   1a3e8:	d0 6a 50    	movl (r10),r0
   1a3eb:	78 18 50 52 	ashl $0x18,r0,r2
   1a3ef:	9c 08 50 51 	rotl $0x8,r0,r1
   1a3f3:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   1a3f7:	00 ff 51 
   1a3fa:	c8 51 52    	bisl2 r1,r2
   1a3fd:	cb 8f ff ff 	bicl3 $0xff00ffff,r0,r1
   1a401:	00 ff 50 51 
   1a405:	d0 08 55    	movl $0x8,r5
   1a408:	90 18 59    	movb $0x18,r9
   1a40b:	ef 55 59 51 	extzv r5,r9,r1,r1
   1a40f:	51 
   1a410:	c8 51 52    	bisl2 r1,r2
   1a413:	ca 8f ff ff 	bicl2 $0x00ffffff,r0
   1a417:	ff 00 50 
   1a41a:	d0 18 58    	movl $0x18,r8
   1a41d:	90 55 56    	movb r5,r6
   1a420:	ef 58 55 50 	extzv r8,r5,r0,r0
   1a424:	50 
   1a425:	c8 50 52    	bisl2 r0,r2
   1a428:	c3 52 ac 0c 	subl3 r2,0xc(ap),r0
   1a42c:	50 
   1a42d:	13 16       	beql 1a445 <_catgets+0x1f9>
   1a42f:	19 0e       	blss 1a43f <_catgets+0x1f3>
   1a431:	c1 53 01 57 	addl3 r3,$0x1,r7
   1a435:	d1 57 54    	cmpl r7,r4
   1a438:	15 9e       	bleq 1a3d8 <_catgets+0x18c>
   1a43a:	d0 ac 10 50 	movl 0x10(ap),r0
   1a43e:	04          	ret
   1a43f:	c3 01 53 54 	subl3 $0x1,r3,r4
   1a443:	11 f0       	brb 1a435 <_catgets+0x1e9>
   1a445:	d0 ad f8 50 	movl 0xfffffff8(fp),r0
   1a449:	d0 a0 10 51 	movl 0x10(r0),r1
   1a44d:	78 18 51 53 	ashl $0x18,r1,r3
   1a451:	9c 08 51 50 	rotl $0x8,r1,r0
   1a455:	ca 8f ff ff 	bicl2 $0xff00ffff,r0
   1a459:	00 ff 50 
   1a45c:	c8 50 53    	bisl2 r0,r3
   1a45f:	cb 8f ff ff 	bicl3 $0xff00ffff,r1,r0
   1a463:	00 ff 51 50 
   1a467:	ef 55 59 50 	extzv r5,r9,r0,r0
   1a46b:	50 
   1a46c:	c8 50 53    	bisl2 r0,r3
   1a46f:	ca 8f ff ff 	bicl2 $0x00ffffff,r1
   1a473:	ff 00 51 
   1a476:	ef 58 56 51 	extzv r8,r6,r1,r1
   1a47a:	51 
   1a47b:	c8 51 53    	bisl2 r1,r3
   1a47e:	d0 ac 04 51 	movl 0x4(ap),r1
   1a482:	c0 61 53    	addl2 (r1),r3
   1a485:	d0 aa 08 51 	movl 0x8(r10),r1
   1a489:	78 18 51 52 	ashl $0x18,r1,r2
   1a48d:	9c 08 51 50 	rotl $0x8,r1,r0
   1a491:	ca 8f ff ff 	bicl2 $0xff00ffff,r0
   1a495:	00 ff 50 
   1a498:	c8 50 52    	bisl2 r0,r2
   1a49b:	cb 8f ff ff 	bicl3 $0xff00ffff,r1,r0
   1a49f:	00 ff 51 50 
   1a4a3:	ef 55 59 50 	extzv r5,r9,r0,r0
   1a4a7:	50 
   1a4a8:	c8 50 52    	bisl2 r0,r2
   1a4ab:	ca 8f ff ff 	bicl2 $0x00ffffff,r1
   1a4af:	ff 00 51 
   1a4b2:	ef 58 56 51 	extzv r8,r6,r1,r1
   1a4b6:	51 
   1a4b7:	c8 51 52    	bisl2 r1,r2
   1a4ba:	9e 43 a2 14 	movab 0x14(r2)[r3],r0
   1a4be:	50 
   1a4bf:	04          	ret
   1a4c0:	fb 00 ef 01 	calls $0x0,109c8 <___errno>
   1a4c4:	65 ff ff 
   1a4c7:	d0 09 60    	movl $0x9,(r0)
   1a4ca:	31 6d ff    	brw 1a43a <_catgets+0x1ee>
   1a4cd:	01          	nop

0001a4ce <_catopen>:
   1a4ce:	c0 0f       	.word 0x0fc0 # Entry mask: < r11 r10 r9 r8 r7 r6 >
   1a4d0:	9e ce f8 fb 	movab 0xfffffbf8(sp),sp
   1a4d4:	5e 
   1a4d5:	d0 ac 04 59 	movl 0x4(ap),r9
   1a4d9:	d0 ef b9 1a 	movl 3bf98 <__guard_local>,0xfffffff8(fp)
   1a4dd:	02 00 ad f8 
   1a4e1:	d5 59       	tstl r9
   1a4e3:	13 04       	beql 1a4e9 <_catopen+0x1b>
   1a4e5:	95 69       	tstb (r9)
   1a4e7:	12 21       	bneq 1a50a <_catopen+0x3c>
   1a4e9:	d2 00 50    	mcoml $0x0,r0
   1a4ec:	d0 ad f8 51 	movl 0xfffffff8(fp),r1
   1a4f0:	d1 51 ef a1 	cmpl r1,3bf98 <__guard_local>
   1a4f4:	1a 02 00 
   1a4f7:	13 10       	beql 1a509 <_catopen+0x3b>
   1a4f9:	dd ad f8    	pushl 0xfffffff8(fp)
   1a4fc:	9f ef ef 0d 	pushab 2b2f1 <tau+0x54>
   1a500:	01 00 
   1a502:	fb 02 ef 63 	calls $0x2,1666c <__stack_smash_handler>
   1a506:	c1 ff ff 
   1a509:	04          	ret
   1a50a:	dd 2f       	pushl $0x2f
   1a50c:	dd 59       	pushl r9
   1a50e:	fb 02 ef 17 	calls $0x2,1a92c <strchr>
   1a512:	04 00 00 
   1a515:	d5 50       	tstl r0
   1a517:	13 09       	beql 1a522 <_catopen+0x54>
   1a519:	dd 59       	pushl r9
   1a51b:	fb 01 cf ca 	calls $0x1,1a7ea <load_msgcat>
   1a51f:	02 
   1a520:	11 ca       	brb 1a4ec <_catopen+0x1e>
   1a522:	fb 00 ef 07 	calls $0x0,1a030 <_thread_sys_issetugid>
   1a526:	fb ff ff 
   1a529:	d5 50       	tstl r0
   1a52b:	12 03       	bneq 1a530 <_catopen+0x62>
   1a52d:	31 a2 02    	brw 1a7d2 <_catopen+0x304>
   1a530:	9e ef c4 0d 	movab 2b2fa <tau+0x5d>,r6
   1a534:	01 00 56 
   1a537:	d4 5b       	clrf r11
   1a539:	d0 ac 08 50 	movl 0x8(ap),r0
   1a53d:	e9 50 03    	blbc r0,1a543 <_catopen+0x75>
   1a540:	31 68 02    	brw 1a7ab <_catopen+0x2dd>
   1a543:	d5 5b       	tstl r11
   1a545:	12 03       	bneq 1a54a <_catopen+0x7c>
   1a547:	31 4e 02    	brw 1a798 <_catopen+0x2ca>
   1a54a:	d5 5b       	tstl r11
   1a54c:	12 03       	bneq 1a551 <_catopen+0x83>
   1a54e:	31 3d 02    	brw 1a78e <_catopen+0x2c0>
   1a551:	9f ef f1 0d 	pushab 2b348 <tau+0xab>
   1a555:	01 00 
   1a557:	dd 5b       	pushl r11
   1a559:	fb 02 ef ee 	calls $0x2,1684e <strcmp>
   1a55d:	c2 ff ff 
   1a560:	d5 50       	tstl r0
   1a562:	12 07       	bneq 1a56b <_catopen+0x9d>
   1a564:	9e ef e4 0d 	movab 2b34e <tau+0xb1>,r11
   1a568:	01 00 5b 
   1a56b:	9e cd f8 fb 	movab 0xfffffbf8(fp),r7
   1a56f:	57 
   1a570:	9a 8f 5f 7e 	movzbl $0x5f,-(sp)
   1a574:	dd 5b       	pushl r11
   1a576:	fb 02 ef af 	calls $0x2,1a92c <strchr>
   1a57a:	03 00 00 
   1a57d:	d0 50 5a    	movl r0,r10
   1a580:	dd 2e       	pushl $0x2e
   1a582:	dd 5b       	pushl r11
   1a584:	fb 02 ef 33 	calls $0x2,1a8be <strrchr>
   1a588:	03 00 00 
   1a58b:	d0 50 58    	movl r0,r8
   1a58e:	13 0b       	beql 1a59b <_catopen+0xcd>
   1a590:	d5 5a       	tstl r10
   1a592:	13 07       	beql 1a59b <_catopen+0xcd>
   1a594:	d1 50 5a    	cmpl r0,r10
   1a597:	1e 02       	bcc 1a59b <_catopen+0xcd>
   1a599:	d4 58       	clrf r8
   1a59b:	d5 58       	tstl r8
   1a59d:	12 03       	bneq 1a5a2 <_catopen+0xd4>
   1a59f:	31 e2 01    	brw 1a784 <_catopen+0x2b6>
   1a5a2:	90 66 50    	movb (r6),r0
   1a5a5:	13 25       	beql 1a5cc <_catopen+0xfe>
   1a5a7:	91 50 3a    	cmpb r0,$0x3a
   1a5aa:	13 20       	beql 1a5cc <_catopen+0xfe>
   1a5ac:	90 66 51    	movb (r6),r1
   1a5af:	91 51 25    	cmpb r1,$0x25
   1a5b2:	13 3f       	beql 1a5f3 <_catopen+0x125>
   1a5b4:	c3 09 5d 50 	subl3 $0x9,fp,r0
   1a5b8:	d1 57 50    	cmpl r7,r0
   1a5bb:	1e 03       	bcc 1a5c0 <_catopen+0xf2>
   1a5bd:	90 51 87    	movb r1,(r7)+
   1a5c0:	d6 56       	incl r6
   1a5c2:	90 66 50    	movb (r6),r0
   1a5c5:	13 05       	beql 1a5cc <_catopen+0xfe>
   1a5c7:	91 50 3a    	cmpb r0,$0x3a
   1a5ca:	12 e0       	bneq 1a5ac <_catopen+0xde>
   1a5cc:	94 67       	clrb (r7)
   1a5ce:	9e cd f8 fb 	movab 0xfffffbf8(fp),r7
   1a5d2:	57 
   1a5d3:	dd 57       	pushl r7
   1a5d5:	fb 01 cf 10 	calls $0x1,1a7ea <load_msgcat>
   1a5d9:	02 
   1a5da:	d1 50 8f ff 	cmpl r0,$0xffffffff
   1a5de:	ff ff ff 
   1a5e1:	13 03       	beql 1a5e6 <_catopen+0x118>
   1a5e3:	31 06 ff    	brw 1a4ec <_catopen+0x1e>
   1a5e6:	95 66       	tstb (r6)
   1a5e8:	13 02       	beql 1a5ec <_catopen+0x11e>
   1a5ea:	d6 56       	incl r6
   1a5ec:	95 66       	tstb (r6)
   1a5ee:	12 b2       	bneq 1a5a2 <_catopen+0xd4>
   1a5f0:	31 f9 fe    	brw 1a4ec <_catopen+0x1e>
   1a5f3:	d6 56       	incl r6
   1a5f5:	98 66 50    	cvtbl (r6),r0
   1a5f8:	9e a0 b4 50 	movab 0xffffffb4(r0),r0
   1a5fc:	d1 50 28    	cmpl r0,$0x28
   1a5ff:	1b 03       	blequ 1a604 <_catopen+0x136>
   1a601:	31 2a 01    	brw 1a72e <_catopen+0x260>
   1a604:	cf 50 00 28 	casel r0,$0x0,$0x28
   1a608:	52 00 26    	mnegf $0x0 [f-float],$0x26 [f-float]
   1a60b:	01          	nop
   1a60c:	7e 00 26    	movaq $0x0,$0x26
   1a60f:	01          	nop
   1a610:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a614:	26 01 
   1a616:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a61a:	26 01 
   1a61c:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a620:	26 01 
   1a622:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a626:	26 01 
   1a628:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a62c:	26 01 
   1a62e:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a632:	26 01 
   1a634:	26 01 aa 00 	cvttp $0x1,0x0(r10),$0x26,$0x1,$0x26
   1a638:	26 01 26 
   1a63b:	01          	nop
   1a63c:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a640:	26 01 
   1a642:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a646:	26 01 
   1a648:	de 00 26    	moval $0x0,$0x26
   1a64b:	01          	nop
   1a64c:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a650:	26 01 
   1a652:	26 01 26 01 	cvttp $0x1,$0x26,$0x1,$0x26,$0x1
   1a656:	26 01 
   1a658:	38 01 d0 5b 	editpc $0x1,*0x515b(r0),@(r0)+,(r11)
   1a65c:	51 90 6b 
   1a65f:	50 12 03    	movf $0x12 [f-float],$0x3 [f-float]
   1a662:	31 5b ff    	brw 1a5c0 <_catopen+0xf2>
   1a665:	c3 09 5d 52 	subl3 $0x9,fp,r2
   1a669:	d1 57 52    	cmpl r7,r2
   1a66c:	1f 03       	blssu 1a671 <_catopen+0x1a3>
   1a66e:	31 4f ff    	brw 1a5c0 <_catopen+0xf2>
   1a671:	d6 51       	incl r1
   1a673:	90 50 87    	movb r0,(r7)+
   1a676:	90 61 50    	movb (r1),r0
   1a679:	12 03       	bneq 1a67e <_catopen+0x1b0>
   1a67b:	31 42 ff    	brw 1a5c0 <_catopen+0xf2>
   1a67e:	d1 57 52    	cmpl r7,r2
   1a681:	1f ee       	blssu 1a671 <_catopen+0x1a3>
   1a683:	31 3a ff    	brw 1a5c0 <_catopen+0xf2>
   1a686:	d0 59 51    	movl r9,r1
   1a689:	90 69 50    	movb (r9),r0
   1a68c:	12 03       	bneq 1a691 <_catopen+0x1c3>
   1a68e:	31 2f ff    	brw 1a5c0 <_catopen+0xf2>
   1a691:	c3 09 5d 52 	subl3 $0x9,fp,r2
   1a695:	d1 57 52    	cmpl r7,r2
   1a698:	1f 03       	blssu 1a69d <_catopen+0x1cf>
   1a69a:	31 23 ff    	brw 1a5c0 <_catopen+0xf2>
   1a69d:	d6 51       	incl r1
   1a69f:	90 50 87    	movb r0,(r7)+
   1a6a2:	90 61 50    	movb (r1),r0
   1a6a5:	12 03       	bneq 1a6aa <_catopen+0x1dc>
   1a6a7:	31 16 ff    	brw 1a5c0 <_catopen+0xf2>
   1a6aa:	d1 57 52    	cmpl r7,r2
   1a6ad:	1f ee       	blssu 1a69d <_catopen+0x1cf>
   1a6af:	31 0e ff    	brw 1a5c0 <_catopen+0xf2>
   1a6b2:	d5 58       	tstl r8
   1a6b4:	12 03       	bneq 1a6b9 <_catopen+0x1eb>
   1a6b6:	31 07 ff    	brw 1a5c0 <_catopen+0xf2>
   1a6b9:	c1 58 01 51 	addl3 r8,$0x1,r1
   1a6bd:	90 61 50    	movb (r1),r0
   1a6c0:	12 03       	bneq 1a6c5 <_catopen+0x1f7>
   1a6c2:	31 fb fe    	brw 1a5c0 <_catopen+0xf2>
   1a6c5:	c3 09 5d 52 	subl3 $0x9,fp,r2
   1a6c9:	d1 57 52    	cmpl r7,r2
   1a6cc:	1f 03       	blssu 1a6d1 <_catopen+0x203>
   1a6ce:	31 ef fe    	brw 1a5c0 <_catopen+0xf2>
   1a6d1:	d6 51       	incl r1
   1a6d3:	90 50 87    	movb r0,(r7)+
   1a6d6:	90 61 50    	movb (r1),r0
   1a6d9:	12 03       	bneq 1a6de <_catopen+0x210>
   1a6db:	31 e2 fe    	brw 1a5c0 <_catopen+0xf2>
   1a6de:	d1 57 52    	cmpl r7,r2
   1a6e1:	1f ee       	blssu 1a6d1 <_catopen+0x203>
   1a6e3:	31 da fe    	brw 1a5c0 <_catopen+0xf2>
   1a6e6:	d0 5b 51    	movl r11,r1
   1a6e9:	90 6b 52    	movb (r11),r2
   1a6ec:	12 03       	bneq 1a6f1 <_catopen+0x223>
   1a6ee:	31 cf fe    	brw 1a5c0 <_catopen+0xf2>
   1a6f1:	c3 09 5d 50 	subl3 $0x9,fp,r0
   1a6f5:	d1 57 50    	cmpl r7,r0
   1a6f8:	1f 03       	blssu 1a6fd <_catopen+0x22f>
   1a6fa:	31 c3 fe    	brw 1a5c0 <_catopen+0xf2>
   1a6fd:	d6 51       	incl r1
   1a6ff:	90 52 87    	movb r2,(r7)+
   1a702:	d5 5a       	tstl r10
   1a704:	13 08       	beql 1a70e <_catopen+0x240>
   1a706:	d1 51 5a    	cmpl r1,r10
   1a709:	1f 03       	blssu 1a70e <_catopen+0x240>
   1a70b:	31 b2 fe    	brw 1a5c0 <_catopen+0xf2>
   1a70e:	d5 58       	tstl r8
   1a710:	13 08       	beql 1a71a <_catopen+0x24c>
   1a712:	d1 51 58    	cmpl r1,r8
   1a715:	1f 03       	blssu 1a71a <_catopen+0x24c>
   1a717:	31 a6 fe    	brw 1a5c0 <_catopen+0xf2>
   1a71a:	90 61 52    	movb (r1),r2
   1a71d:	12 03       	bneq 1a722 <_catopen+0x254>
   1a71f:	31 9e fe    	brw 1a5c0 <_catopen+0xf2>
   1a722:	c3 09 5d 50 	subl3 $0x9,fp,r0
   1a726:	d1 57 50    	cmpl r7,r0
   1a729:	1f d2       	blssu 1a6fd <_catopen+0x22f>
   1a72b:	31 92 fe    	brw 1a5c0 <_catopen+0xf2>
   1a72e:	c3 09 5d 50 	subl3 $0x9,fp,r0
   1a732:	d1 57 50    	cmpl r7,r0
   1a735:	1f 03       	blssu 1a73a <_catopen+0x26c>
   1a737:	31 86 fe    	brw 1a5c0 <_catopen+0xf2>
   1a73a:	90 66 87    	movb (r6),(r7)+
   1a73d:	31 80 fe    	brw 1a5c0 <_catopen+0xf2>
   1a740:	d5 5a       	tstl r10
   1a742:	12 03       	bneq 1a747 <_catopen+0x279>
   1a744:	31 79 fe    	brw 1a5c0 <_catopen+0xf2>
   1a747:	c1 5a 01 51 	addl3 r10,$0x1,r1
   1a74b:	90 61 52    	movb (r1),r2
   1a74e:	12 03       	bneq 1a753 <_catopen+0x285>
   1a750:	31 6d fe    	brw 1a5c0 <_catopen+0xf2>
   1a753:	c3 09 5d 50 	subl3 $0x9,fp,r0
   1a757:	d1 57 50    	cmpl r7,r0
   1a75a:	1f 03       	blssu 1a75f <_catopen+0x291>
   1a75c:	31 61 fe    	brw 1a5c0 <_catopen+0xf2>
   1a75f:	d6 51       	incl r1
   1a761:	90 52 87    	movb r2,(r7)+
   1a764:	d5 58       	tstl r8
   1a766:	13 08       	beql 1a770 <_catopen+0x2a2>
   1a768:	d1 51 58    	cmpl r1,r8
   1a76b:	1f 03       	blssu 1a770 <_catopen+0x2a2>
   1a76d:	31 50 fe    	brw 1a5c0 <_catopen+0xf2>
   1a770:	90 61 52    	movb (r1),r2
   1a773:	12 03       	bneq 1a778 <_catopen+0x2aa>
   1a775:	31 48 fe    	brw 1a5c0 <_catopen+0xf2>
   1a778:	c3 09 5d 50 	subl3 $0x9,fp,r0
   1a77c:	d1 57 50    	cmpl r7,r0
   1a77f:	1f de       	blssu 1a75f <_catopen+0x291>
   1a781:	31 3c fe    	brw 1a5c0 <_catopen+0xf2>
   1a784:	9e ef c4 0b 	movab 2b34e <tau+0xb1>,r11
   1a788:	01 00 5b 
   1a78b:	31 14 fe    	brw 1a5a2 <_catopen+0xd4>
   1a78e:	9e ef ba 0b 	movab 2b34e <tau+0xb1>,r11
   1a792:	01 00 5b 
   1a795:	31 b9 fd    	brw 1a551 <_catopen+0x83>
   1a798:	9f ef b2 0b 	pushab 2b350 <tau+0xb3>
   1a79c:	01 00 
   1a79e:	fb 01 ef 1b 	calls $0x1,191c0 <getenv>
   1a7a2:	ea ff ff 
   1a7a5:	d0 50 5b    	movl r0,r11
   1a7a8:	31 9f fd    	brw 1a54a <_catopen+0x7c>
   1a7ab:	9f ef a4 0b 	pushab 2b355 <tau+0xb8>
   1a7af:	01 00 
   1a7b1:	9e ef 09 ea 	movab 191c0 <getenv>,r7
   1a7b5:	ff ff 57 
   1a7b8:	fb 01 67    	calls $0x1,(r7)
   1a7bb:	d0 50 5b    	movl r0,r11
   1a7be:	13 03       	beql 1a7c3 <_catopen+0x2f5>
   1a7c0:	31 80 fd    	brw 1a543 <_catopen+0x75>
   1a7c3:	9f ef 93 0b 	pushab 2b35c <tau+0xbf>
   1a7c7:	01 00 
   1a7c9:	fb 01 67    	calls $0x1,(r7)
   1a7cc:	d0 50 5b    	movl r0,r11
   1a7cf:	31 71 fd    	brw 1a543 <_catopen+0x75>
   1a7d2:	9f ef 90 0b 	pushab 2b368 <tau+0xcb>
   1a7d6:	01 00 
   1a7d8:	fb 01 ef e1 	calls $0x1,191c0 <getenv>
   1a7dc:	e9 ff ff 
   1a7df:	d0 50 56    	movl r0,r6
   1a7e2:	13 03       	beql 1a7e7 <_catopen+0x319>
   1a7e4:	31 50 fd    	brw 1a537 <_catopen+0x69>
   1a7e7:	31 46 fd    	brw 1a530 <_catopen+0x62>

0001a7ea <load_msgcat>:
   1a7ea:	c0 00       	.word 0x00c0 # Entry mask: < r7 r6 >
   1a7ec:	9e ae 90 5e 	movab 0xffffff90(sp),sp
   1a7f0:	dd 8f 00 00 	pushl $0x00010000
   1a7f4:	01 00 
   1a7f6:	dd ac 04    	pushl 0x4(ap)
   1a7f9:	fb 02 ef a8 	calls $0x2,19fa8 <_thread_sys_open>
   1a7fd:	f7 ff ff 
   1a800:	d0 50 56    	movl r0,r6
   1a803:	d1 50 8f ff 	cmpl r0,$0xffffffff
   1a807:	ff ff ff 
   1a80a:	12 03       	bneq 1a80f <load_msgcat+0x25>
   1a80c:	31 a9 00    	brw 1a8b8 <load_msgcat+0xce>
   1a80f:	9f ad 90    	pushab 0xffffff90(fp)
   1a812:	dd 50       	pushl r0
   1a814:	fb 02 ef 91 	calls $0x2,16aac <_thread_sys_fstat>
   1a818:	c2 ff ff 
   1a81b:	d5 50       	tstl r0
   1a81d:	13 0d       	beql 1a82c <load_msgcat+0x42>
   1a81f:	dd 56       	pushl r6
   1a821:	fb 01 ef 70 	calls $0x1,10698 <_thread_sys_close>
   1a825:	5e ff ff 
   1a828:	d2 00 50    	mcoml $0x0,r0
   1a82b:	04          	ret
   1a82c:	7c 7e       	clrd -(sp)
   1a82e:	dd 56       	pushl r6
   1a830:	dd 01       	pushl $0x1
   1a832:	dd 01       	pushl $0x1
   1a834:	dd ad d4    	pushl 0xffffffd4(fp)
   1a837:	d4 7e       	clrf -(sp)
   1a839:	fb 07 ef 22 	calls $0x7,16a62 <_thread_sys_mmap>
   1a83d:	c2 ff ff 
   1a840:	d0 50 57    	movl r0,r7
   1a843:	dd 56       	pushl r6
   1a845:	fb 01 ef 4c 	calls $0x1,10698 <_thread_sys_close>
   1a849:	5e ff ff 
   1a84c:	d1 57 8f ff 	cmpl r7,$0xffffffff
   1a850:	ff ff ff 
   1a853:	13 64       	beql 1a8b9 <load_msgcat+0xcf>
   1a855:	d0 67 50    	movl (r7),r0
   1a858:	78 18 50 52 	ashl $0x18,r0,r2
   1a85c:	9c 08 50 51 	rotl $0x8,r0,r1
   1a860:	ca 8f ff ff 	bicl2 $0xff00ffff,r1
   1a864:	00 ff 51 
   1a867:	c8 51 52    	bisl2 r1,r2
   1a86a:	cb 8f ff ff 	bicl3 $0xff00ffff,r0,r1
   1a86e:	00 ff 50 51 
   1a872:	d0 08 53    	movl $0x8,r3
   1a875:	ef 53 18 51 	extzv r3,$0x18,r1,r1
   1a879:	51 
   1a87a:	c8 51 52    	bisl2 r1,r2
   1a87d:	ca 8f ff ff 	bicl2 $0x00ffffff,r0
   1a881:	ff 00 50 
   1a884:	ef 18 53 50 	extzv $0x18,r3,r0,r0
   1a888:	50 
   1a889:	c8 50 52    	bisl2 r0,r2
   1a88c:	d1 52 8f 89 	cmpl r2,$0xff88ff89
   1a890:	ff 88 ff 
   1a893:	13 0e       	beql 1a8a3 <load_msgcat+0xb9>
   1a895:	dd ad d4    	pushl 0xffffffd4(fp)
   1a898:	dd 57       	pushl r7
   1a89a:	fb 02 ef 2b 	calls $0x2,16acc <_thread_sys_munmap>
   1a89e:	c2 ff ff 
   1a8a1:	11 85       	brb 1a828 <load_msgcat+0x3e>
   1a8a3:	dd 53       	pushl r3
   1a8a5:	fb 01 ef 76 	calls $0x1,18622 <malloc>
   1a8a9:	dd ff ff 
   1a8ac:	d5 50       	tstl r0
   1a8ae:	13 e5       	beql 1a895 <load_msgcat+0xab>
   1a8b0:	d0 57 60    	movl r7,(r0)
   1a8b3:	d0 ad d4 a0 	movl 0xffffffd4(fp),0x4(r0)
   1a8b7:	04 
   1a8b8:	04          	ret
   1a8b9:	d0 57 50    	movl r7,r0
   1a8bc:	04          	ret
   1a8bd:	01          	nop

0001a8be <strrchr>:
   1a8be:	00 00       	.word 0x0000 # Entry mask: < >
   1a8c0:	c2 04 5e    	subl2 $0x4,sp
   1a8c3:	d0 ac 04 52 	movl 0x4(ap),r2
   1a8c7:	d0 ac 08 53 	movl 0x8(ap),r3
   1a8cb:	d4 54       	clrf r4
   1a8cd:	90 62 51    	movb (r2),r1
   1a8d0:	98 51 50    	cvtbl r1,r0
   1a8d3:	d1 50 53    	cmpl r0,r3
   1a8d6:	13 0c       	beql 1a8e4 <strrchr+0x26>
   1a8d8:	95 51       	tstb r1
   1a8da:	13 04       	beql 1a8e0 <strrchr+0x22>
   1a8dc:	d6 52       	incl r2
   1a8de:	11 ed       	brb 1a8cd <strrchr+0xf>
   1a8e0:	d0 54 50    	movl r4,r0
   1a8e3:	04          	ret
   1a8e4:	d0 52 54    	movl r2,r4
   1a8e7:	11 ef       	brb 1a8d8 <strrchr+0x1a>
   1a8e9:	01          	nop

0001a8ea <strlcpy>:
   1a8ea:	00 00       	.word 0x0000 # Entry mask: < >
   1a8ec:	c2 04 5e    	subl2 $0x4,sp
   1a8ef:	d0 ac 04 53 	movl 0x4(ap),r3
   1a8f3:	d0 ac 08 51 	movl 0x8(ap),r1
   1a8f7:	d0 ac 0c 54 	movl 0xc(ap),r4
   1a8fb:	d0 51 55    	movl r1,r5
   1a8fe:	d0 54 52    	movl r4,r2
   1a901:	13 12       	beql 1a915 <strlcpy+0x2b>
   1a903:	c3 01 54 52 	subl3 $0x1,r4,r2
   1a907:	13 0c       	beql 1a915 <strlcpy+0x2b>
   1a909:	90 81 50    	movb (r1)+,r0
   1a90c:	90 50 83    	movb r0,(r3)+
   1a90f:	13 04       	beql 1a915 <strlcpy+0x2b>
   1a911:	d7 52       	decl r2
   1a913:	12 f4       	bneq 1a909 <strlcpy+0x1f>
   1a915:	d5 52       	tstl r2
   1a917:	12 0a       	bneq 1a923 <strlcpy+0x39>
   1a919:	d5 54       	tstl r4
   1a91b:	13 02       	beql 1a91f <strlcpy+0x35>
   1a91d:	94 63       	clrb (r3)
   1a91f:	95 81       	tstb (r1)+
   1a921:	12 fc       	bneq 1a91f <strlcpy+0x35>
   1a923:	c3 55 51 50 	subl3 r5,r1,r0
   1a927:	d7 50       	decl r0
   1a929:	04          	ret
   1a92a:	01          	nop
   1a92b:	01          	nop

0001a92c <strchr>:
   1a92c:	00 00       	.word 0x0000 # Entry mask: < >
   1a92e:	7d ac 04 50 	movq 0x4(ap),r0
   1a932:	95 51       	tstb r1
   1a934:	13 0c       	beql 1a942 <strchr+0x16>
   1a936:	91 60 51    	cmpb (r0),r1
   1a939:	13 06       	beql 1a941 <strchr+0x15>
   1a93b:	95 80       	tstb (r0)+
   1a93d:	12 f7       	bneq 1a936 <strchr+0xa>
   1a93f:	d4 50       	clrf r0
   1a941:	04          	ret
   1a942:	95 80       	tstb (r0)+
   1a944:	12 fc       	bneq 1a942 <strchr+0x16>
   1a946:	d7 50       	decl r0
   1a948:	11 f7       	brb 1a941 <strchr+0x15>
Disassembly of section .fini:

0001a94a <__fini>:
   1a94a:	00 00       	.word 0x0000 # Entry mask: < >
   1a94c:	fb 00 ef f1 	calls $0x0,10344 <pthread_atfork+0xce>
   1a950:	59 ff ff 
   1a953:	04          	ret
Disassembly of section .rodata:

0002a954 <_C_ctype_-0x118>:
   2a954:	52 65 63    	mnegf (r5),(r3)
   2a957:	76 20 66    	cvtdf $0x20 [d-float],(r6)
   2a95a:	61 69 6c 65 	addd3 (r9),(ap),(r5)
   2a95e:	64 2e 20    	muld2 $0x2e [d-float],$0x20 [d-float]
   2a961:	45 72 72 6f 	mulf3 -(r2),-(r2),(pc)
   2a965:	72 20 63    	mnegd $0x20 [d-float],(r3)
   2a968:	6f 64 65 20 	acbd (r4),(r5),$0x20 [d-float],30d93 <_sys_siglist+0x507b>
   2a96c:	25 64 
   2a96e:	0a 00 43 6c 	index $0x0,(ap)[r3],(r9),(r5),(sp),-(r4)
   2a972:	69 65 6e 74 
   2a976:	20 45 78 69 	addp4 -(r8)[r5],(r9),-(r4),$0x2e
   2a97a:	74 2e 
   2a97c:	2e 2e 0a 00 	movtc $0x2e,$0xa,$0x0,$0x25,-(r3),$0x0
   2a980:	25 73 00 
   2a983:	65 78 69 74 	muld3 -(r8),(r9),-(r4)
   2a987:	00          	halt
   2a988:	43 4f 4d 4d 	subf3 $0x20 [f-float][r4][sp][r1][fp][fp][pc],$0x24 [f-float],$0x20 [f-float]
   2a98c:	41 4e 44 20 
   2a990:	24 20 
   2a992:	00          	halt
   2a993:	53 65       	tstf (r5)
   2a995:	6e 64 20    	cvtld (r4),$0x20 [d-float]
   2a998:	66 61 69    	divd2 (r1),(r9)
   2a99b:	6c 65 64    	cvtbd (r5),(r4)
   2a99e:	2e 20 45 72 	movtc $0x20,-(r2)[r5],-(r2),(pc),-(r2),$0x20
   2a9a2:	72 6f 72 20 
   2a9a6:	63 6f 64 65 	subd3 (pc),(r4),(r5)
   2a9aa:	20 25 64 0a 	addp4 $0x25,(r4),$0xa,$0x0
   2a9ae:	00 
   2a9af:	66 75 6e    	divd2 -(r5),(sp)
   2a9b2:	63 00 50 6c 	subd3 $0x0 [d-float],r0,(ap)
   2a9b6:	65 61 73 65 	muld3 (r1),-(r3),(r5)
   2a9ba:	20 70 72 6f 	addp4 -(r0),-(r2),(pc),-(r6)
   2a9be:	76 
   2a9bf:	69 64 65    	cvtdw (r4),(r5)
   2a9c2:	20 49 50 20 	addp4 r0[r9],$0x20,(r1),(r4)
   2a9c6:	61 64 
   2a9c8:	64 72 65    	muld2 -(r2),(r5)
   2a9cb:	73 73       	tstd -(r3)
   2a9cd:	2e 20 55 73 	movtc $0x20,r5,-(r3),(r1),(r7),(r5)
   2a9d1:	61 67 65 
   2a9d4:	3a 20 63 6c 	locc $0x20,(r3),(ap)
   2a9d8:	69 65 6e    	cvtdw (r5),(sp)
   2a9db:	74 20 5b 49 	emodd $0x20 [d-float],r11,r0[r9],fp,$0xa [d-float]
   2a9df:	50 5d 0a 
   2a9e2:	00          	halt
   2a9e3:	73 6f       	tstd (pc)
   2a9e5:	63 6b 65 74 	subd3 (r11),(r5),-(r4)
   2a9e9:	20 63 72 65 	addp4 (r3),-(r2),(r5),(r1)
   2a9ed:	61 
   2a9ee:	74 69 6f 6e 	emodd (r9),(pc),(sp),$0x20,(r6)
   2a9f2:	20 66 
   2a9f4:	61 69 6c 65 	addd3 (r9),(ap),(r5)
   2a9f8:	64 2e 2e    	muld2 $0x2e [d-float],$0x2e [d-float]
   2a9fb:	2e 0a 00 53 	movtc $0xa,$0x0,r3,(pc),(r3),(r11)
   2a9ff:	6f 63 6b 
   2aa02:	65 74 20 73 	muld3 -(r4),$0x20 [d-float],-(r3)
   2aa06:	75 63 63 65 	polyd (r3),(r3),(r5)
   2aa0a:	73 73       	tstd -(r3)
   2aa0c:	66 75 6c    	divd2 -(r5),(ap)
   2aa0f:	6c 79 20    	cvtbd -(r9),$0x20 [d-float]
   2aa12:	63 72 65 61 	subd3 -(r2),(r5),(r1)
   2aa16:	74 65 64 2e 	emodd (r5),(r4),$0x2e [d-float],$0xa,$0x0 [d-float]
   2aa1a:	0a 00 
   2aa1c:	63 6f 6e 6e 	subd3 (pc),(sp),(sp)
   2aa20:	65 63 74 69 	muld3 (r3),-(r4),(r9)
   2aa24:	6f 6e 20 77 	acbd (sp),$0x20 [d-float],-(r7),31e93 <_sys_siglist+0x617b>
   2aa28:	69 74 
   2aa2a:	68 20 74    	cvtdb $0x20 [d-float],-(r4)
   2aa2d:	68 65 20    	cvtdb (r5),$0x20
   2aa30:	73 65       	tstd (r5)
   2aa32:	72 76 65    	mnegd -(r6),(r5)
   2aa35:	72 20 66    	mnegd $0x20 [d-float],(r6)
   2aa38:	61 69 6c 65 	addd3 (r9),(ap),(r5)
   2aa3c:	64 2e 2e    	muld2 $0x2e [d-float],$0x2e [d-float]
   2aa3f:	2e 0a 00 63 	movtc $0xa,$0x0,(r3),(pc),(sp),(sp)
   2aa43:	6f 6e 6e 
   2aa46:	65 63 74 65 	muld3 (r3),-(r4),(r5)
   2aa4a:	64 20 74    	muld2 $0x20 [d-float],-(r4)
   2aa4d:	6f 20 74 68 	acbd $0x20 [d-float],-(r4),(r8),2cab8 <_sys_siglist+0xda0>
   2aa51:	65 20 
   2aa53:	73 65       	tstd (r5)
   2aa55:	72 76 65    	mnegd -(r6),(r5)
   2aa58:	72 2e 2e    	mnegd $0x2e [d-float],$0x2e [d-float]
   2aa5b:	0a 00 6d 61 	index $0x0,(fp),(r1),(r9),(sp),$0x0
   2aa5f:	69 6e 00 
   2aa62:	69 6e 65    	cvtdw (sp),(r5)
   2aa65:	74 5f 61 74 	emodd pc,(r1),-(r4),(pc),(sp)
   2aa69:	6f 6e 
	...

0002aa6c <_C_ctype_>:
   2aa6c:	00          	halt
   2aa6d:	20 20 20 20 	addp4 $0x20,$0x20,$0x20,$0x20
   2aa71:	20 
   2aa72:	20 20 20 20 	addp4 $0x20,$0x20,$0x20,$0x28
   2aa76:	28 
   2aa77:	28 28 28 28 	movc3 $0x28,$0x28,$0x28
   2aa7b:	20 20 20 20 	addp4 $0x20,$0x20,$0x20,$0x20
   2aa7f:	20 
   2aa80:	20 20 20 20 	addp4 $0x20,$0x20,$0x20,$0x20
   2aa84:	20 
   2aa85:	20 20 20 20 	addp4 $0x20,$0x20,$0x20,$0x20
   2aa89:	20 
   2aa8a:	20 20 20 88 	addp4 $0x20,$0x20,(r8)+,$0x10
   2aa8e:	10 
   2aa8f:	10 10       	bsbb 2aaa1 <_C_ctype_+0x35>
   2aa91:	10 10       	bsbb 2aaa3 <_C_ctype_+0x37>
   2aa93:	10 10       	bsbb 2aaa5 <_C_ctype_+0x39>
   2aa95:	10 10       	bsbb 2aaa7 <_C_ctype_+0x3b>
   2aa97:	10 10       	bsbb 2aaa9 <_C_ctype_+0x3d>
   2aa99:	10 10       	bsbb 2aaab <_C_ctype_+0x3f>
   2aa9b:	10 10       	bsbb 2aaad <_C_ctype_+0x41>
   2aa9d:	04          	ret
   2aa9e:	04          	ret
   2aa9f:	04          	ret
   2aaa0:	04          	ret
   2aaa1:	04          	ret
   2aaa2:	04          	ret
   2aaa3:	04          	ret
   2aaa4:	04          	ret
   2aaa5:	04          	ret
   2aaa6:	04          	ret
   2aaa7:	10 10       	bsbb 2aab9 <_C_ctype_+0x4d>
   2aaa9:	10 10       	bsbb 2aabb <_C_ctype_+0x4f>
   2aaab:	10 10       	bsbb 2aabd <_C_ctype_+0x51>
   2aaad:	10 41       	bsbb 2aaf0 <_C_ctype_+0x84>
   2aaaf:	41 41 41 41 	addf3 $0x1 [f-float][r1][r1][r1][r1],$0x1 [f-float],$0x1 [f-float]
   2aab3:	41 01 01 01 
   2aab7:	01          	nop
   2aab8:	01          	nop
   2aab9:	01          	nop
   2aaba:	01          	nop
   2aabb:	01          	nop
   2aabc:	01          	nop
   2aabd:	01          	nop
   2aabe:	01          	nop
   2aabf:	01          	nop
   2aac0:	01          	nop
   2aac1:	01          	nop
   2aac2:	01          	nop
   2aac3:	01          	nop
   2aac4:	01          	nop
   2aac5:	01          	nop
   2aac6:	01          	nop
   2aac7:	01          	nop
   2aac8:	10 10       	bsbb 2aada <_C_ctype_+0x6e>
   2aaca:	10 10       	bsbb 2aadc <_C_ctype_+0x70>
   2aacc:	10 10       	bsbb 2aade <_C_ctype_+0x72>
   2aace:	42 42 42 42 	subf2 $0x2 [f-float][r2][r2][r2][r2][r2],$0x2 [f-float]
   2aad2:	42 42 02 02 
   2aad6:	02          	rei
   2aad7:	02          	rei
   2aad8:	02          	rei
   2aad9:	02          	rei
   2aada:	02          	rei
   2aadb:	02          	rei
   2aadc:	02          	rei
   2aadd:	02          	rei
   2aade:	02          	rei
   2aadf:	02          	rei
   2aae0:	02          	rei
   2aae1:	02          	rei
   2aae2:	02          	rei
   2aae3:	02          	rei
   2aae4:	02          	rei
   2aae5:	02          	rei
   2aae6:	02          	rei
   2aae7:	02          	rei
   2aae8:	10 10       	bsbb 2aafa <_C_ctype_+0x8e>
   2aaea:	10 10       	bsbb 2aafc <_C_ctype_+0x90>
   2aaec:	20 00 00 00 	addp4 $0x0,$0x0,$0x0,$0x0
   2aaf0:	00 
	...

0002ab6d <xdigs_lower.2>:
   2ab6d:	30 31 32    	bsbw 2dda1 <_sys_siglist+0x2089>
   2ab70:	33 34 35    	cvtwb $0x34,$0x35
   2ab73:	36 37 38 39 	cvtpl $0x37,$0x38,$0x39
   2ab77:	61 62 63 64 	addd3 (r2),(r3),(r4)
   2ab7b:	65 66 30 31 	muld3 (r6),$0x30 [d-float],$0x31 [d-float]

0002ab7d <xdigs_upper.3>:
   2ab7d:	30 31 32    	bsbw 2ddb1 <_sys_siglist+0x2099>
   2ab80:	33 34 35    	cvtwb $0x34,$0x35
   2ab83:	36 37 38 39 	cvtpl $0x37,$0x38,$0x39
   2ab87:	41 42 43 44 	addf3 pc[r6][r5][r4][r3][r2],pc,-(r3)
   2ab8b:	45 46 5f 5f 
   2ab8f:	73 
   2ab90:	62 70 72    	subd2 -(r0),-(r2)
   2ab93:	69 6e 74    	cvtdw (sp),-(r4)
   2ab96:	66 00 5f    	divd2 $0x0 [d-float],pc
   2ab99:	5f 77 63    	remqti -(r7),(r3)
   2ab9c:	73 63       	tstd (r3)
   2ab9e:	6f 6e 76 00 	acbd (sp),-(r6),$0x0 [d-float],30b03 <_sys_siglist+0x4deb>
   2aba2:	5f 5f 
   2aba4:	76 66 70    	cvtdf (r6),-(r0)
   2aba7:	72 69 6e    	mnegd (r9),(sp)
   2abaa:	74 66 00 62 	emodd (r6),$0x0,(r2),-(r5),(r7)
   2abae:	75 67 
   2abb0:	20 69 6e 20 	addp4 (r9),(sp),$0x20,-(r6)
   2abb4:	76 
   2abb5:	66 70 72    	divd2 -(r0),-(r2)
   2abb8:	69 6e 74    	cvtdw (sp),-(r4)
   2abbb:	66 3a 20    	divd2 $0x3a [d-float],$0x20 [d-float]
   2abbe:	62 61 64    	subd2 (r1),(r4)
   2abc1:	20 62 61 73 	addp4 (r2),(r1),-(r3),(r5)
   2abc5:	65 
   2abc6:	00          	halt
   2abc7:	69 6e 66    	cvtdw (sp),(r6)
   2abca:	00          	halt
   2abcb:	49 4e 46 00 	cvtfw $0x0 [f-float][r6][sp],(sp)
   2abcf:	6e 
   2abd0:	61 6e 00 4e 	addd3 (sp),$0x0 [d-float],$0x0 [d-float][sp][r1][sp]
   2abd4:	41 4e 00 
   2abd7:	28 6e 75 6c 	movc3 (sp),-(r5),(ap)
   2abdb:	6c 29 00    	cvtbd $0x29,$0x0 [d-float]
   2abde:	5f 5f 66    	remqti pc,(r6)
   2abe1:	69 6e 64    	cvtdw (sp),(r4)
   2abe4:	5f 61 72    	remqti (r1),-(r2)
   2abe7:	67 75 6d 65 	divd3 -(r5),(fp),(r5)
   2abeb:	6e 74 73    	cvtld -(r4),-(r3)
   2abee:	00          	halt
   2abef:	65 78 70 6f 	muld3 -(r8),-(r0),(pc)
   2abf3:	6e 65 6e    	cvtld (r5),(sp)
   2abf6:	74 00 0e 00 	emodd $0x0 [d-float],$0xe,$0x0 [d-float],$0x0,$0x0 [d-float]
   2abfa:	00 00 

0002abf8 <sigfigs.0>:
   2abf8:	0e 00 00    	insque $0x0,$0x0
   2abfb:	00          	halt
   2abfc:	5f 5f 64    	remqti pc,(r4)
   2abff:	74 6f 61 00 	emodd (pc),(r1),$0x0 [d-float],(r1)[sp],$0x0 [d-float][sp]
   2ac03:	4e 61 4e 00 
	...

0002ac08 <__bigtens_D2A>:
   2ac08:	0e 5b c9 1b 	insque r11,0x41b(r9)
   2ac0c:	04 
   2ac0d:	bf 00       	chmu $0x0
   2ac0f:	00          	halt
   2ac10:	9d 75 ad c5 	acbb -(r5),0xffffffc5(fp),$0x2b,262bf <__fini+0xb975>
   2ac14:	2b a8 b6 
   2ac17:	70 e6 25 94 	movd 0xc4959425(r6),*0xffffffe1(sp)
   2ac1b:	95 c4 be e1 

0002ac18 <__tinytens_D2A>:
   2ac18:	e6 25 94 95 	bbssi $0x25,@(r4)+,2abb1 <xdigs_upper.3+0x34>
   2ac1c:	c4 be e1 4d 	mull2 *0xffffffe1(sp),$0xb[pc][fp]
   2ac20:	4f 0b 
   2ac22:	1e b1       	bcc 2abd5 <xdigs_upper.3+0x58>
   2ac24:	45 ad 95 39 	mulf3 0xffffff95(fp),$0x39 [f-float],(r0)+
   2ac28:	80 

0002ac28 <__tens_D2A>:
   2ac28:	80 40 00 00 	addb2 $0x0[r0],$0x0
   2ac2c:	00          	halt
   2ac2d:	00          	halt
   2ac2e:	00          	halt
   2ac2f:	00          	halt
   2ac30:	20 42 00 00 	addp4 $0x0[r2],$0x0,$0x0,$0x0
   2ac34:	00 00 
   2ac36:	00          	halt
   2ac37:	00          	halt
   2ac38:	c8 43 00 00 	bisl2 $0x0[r3],$0x0
   2ac3c:	00          	halt
   2ac3d:	00          	halt
   2ac3e:	00          	halt
   2ac3f:	00          	halt
   2ac40:	7a 45 00 00 	emul $0x0[r5],$0x0,$0x0,$0x0
   2ac44:	00 00 
   2ac46:	00          	halt
   2ac47:	00          	halt
   2ac48:	1c 47       	bvc 2ac91 <__tens_D2A+0x69>
   2ac4a:	00          	halt
   2ac4b:	40 00 00    	addf2 $0x0 [f-float],$0x0 [f-float]
   2ac4e:	00          	halt
   2ac4f:	00          	halt
   2ac50:	c3 48 00 50 	subl3 $0x0[r8],r0,$0x0
   2ac54:	00 
   2ac55:	00          	halt
   2ac56:	00          	halt
   2ac57:	00          	halt
   2ac58:	74 4a 00 24 	emodd $0x0 [d-float][r10],$0x24,$0x0 [d-float],$0x0,$0x0 [d-float]
   2ac5c:	00 00 00 
   2ac5f:	00          	halt
   2ac60:	18 4c       	bgeq 2acae <__tens_D2A+0x86>
   2ac62:	80 96 00    	addb2 @(r6)+,$0x0
   2ac65:	00          	halt
   2ac66:	00          	halt
   2ac67:	00          	halt
   2ac68:	be 4d 20    	chms $0x20[fp]
   2ac6b:	bc 00       	chmk $0x0
   2ac6d:	00          	halt
   2ac6e:	00          	halt
   2ac6f:	00          	halt
   2ac70:	6e 4f 28 6b 	cvtld $0x28[pc],(r11)
   2ac74:	00          	halt
   2ac75:	00          	halt
   2ac76:	00          	halt
   2ac77:	00          	halt
   2ac78:	15 51       	bleq 2accb <__tens_D2A+0xa3>
   2ac7a:	f9 02 00 00 	cvtlp $0x2,$0x0,$0x0
   2ac7e:	00          	halt
   2ac7f:	00          	halt
   2ac80:	ba 52       	popr r2
   2ac82:	b7 43 00    	decw $0x0[r3]
   2ac85:	40 00 00    	addf2 $0x0 [f-float],$0x0 [f-float]
   2ac88:	68 54 a5 d4 	cvtdb r4,0xffffffd4(r5)
   2ac8c:	00          	halt
   2ac8d:	10 00       	bsbb 2ac8f <__tens_D2A+0x67>
   2ac8f:	00          	halt
   2ac90:	11 56       	brb 2ace8 <__tens_D2A+0xc0>
   2ac92:	e7 84 00 2a 	bbcci (r4)+,$0x0,2acc0 <__tens_D2A+0x98>
   2ac96:	00          	halt
   2ac97:	00          	halt
   2ac98:	b5 57       	tstw r7
   2ac9a:	20 e6 80 f4 	addp4 0xf480(r6),(r3),r9,0x5f(r9)
   2ac9e:	00 00 63 59 
   2aca2:	a9 5f 
   2aca4:	a0 31 00    	addw2 $0x31,$0x0
   2aca7:	00          	halt
   2aca8:	0e 5b c9 1b 	insque r11,0x41b(r9)
   2acac:	04 
   2acad:	bf 00       	chmu $0x0
   2acaf:	00          	halt
   2acb0:	b1 5c bc a2 	cmpw ap,*0xffffffa2(ap)
   2acb4:	c5 2e 00 00 	mull3 $0x2e,$0x0,$0x0
   2acb8:	5e 5e 6b    	remqhi sp,(r11)
   2acbb:	0b 76 3a 00 	crc -(r6),$0x3a,$0x0,$0xa[r0]
   2acbf:	40 0a 
   2acc1:	60 23 c7 89 	addd2 $0x23 [d-float],0x489(r7)
   2acc5:	04 
   2acc6:	00          	halt
   2acc7:	e8 ad 61 eb 	blbs 0x61(fp),2acb6 <__tens_D2A+0x8e>
   2accb:	78 ac c5 00 	ashl 0xffffffc5(ap),$0x0,(r2)
   2accf:	62 
   2acd0:	58 63 26    	adawi (r3),$0x26
   2acd3:	d7 17       	decl $0x17
   2acd5:	b7 80       	decw (r0)+
   2acd7:	7a 07 65 78 	emul $0x7,(r5),-(r8),(r6)+
   2acdb:	86 
   2acdc:	6e 32 90    	cvtld $0x32,@(r0)+
   2acdf:	ac a9 66 16 	xorw2 0x66(r9),$0x16
   2ace3:	68 0a 3f    	cvtdb $0xa [d-float],$0x3f
   2ace6:	b4 57       	clrw r7
   2ace8:	53 68       	tstf (r8)
   2acea:	1b c2       	blequ 2acae <__tens_D2A+0x86>
   2acec:	cc ce a1 ed 	xorl2 0xffffeda1(sp),pc
   2acf0:	5f 
   2acf1:	5f 62 32    	remqti (r2),$0x32
   2acf4:	64 5f 44 32 	muld2 pc,$0x32 [d-float][r4]
   2acf8:	41 00 5f 5f 	addf3 $0x0 [f-float],pc,pc
   2acfc:	64 32 62    	muld2 $0x32 [d-float],(r2)
   2acff:	5f 44 32 41 	remqti $0x32[r4],$0x0[r1]
   2ad03:	00 
   2ad04:	5f 5f 71    	remqti pc,-(r1)
   2ad07:	64 69 76    	muld2 (r9),-(r6)
   2ad0a:	72 65 6d    	mnegd (r5),(fp)
   2ad0d:	00          	halt
   2ad0e:	67 65 74 70 	divd3 (r5),-(r4),-(r0)
   2ad12:	61 67 65 73 	addd3 (r7),(r5),-(r3)
   2ad16:	69 7a 65    	cvtdw -(r10),(r5)
   2ad19:	00          	halt
   2ad1a:	55 53 2d 41 	polyf r3,$0x2d,r3[r1]
   2ad1e:	53 
   2ad1f:	43 49 49 00 	subf3 $0x0 [f-float][r9][r9],(r1),(ap)
   2ad23:	61 6c 
   2ad25:	6e 75 6d    	cvtld -(r5),(fp)
   2ad28:	00          	halt
   2ad29:	61 6c 70 68 	addd3 (ap),-(r0),(r8)
   2ad2d:	61 00 62 6c 	addd3 $0x0 [d-float],(r2),(ap)
   2ad31:	61 6e 6b 00 	addd3 (sp),(r11),$0x0 [d-float]
   2ad35:	63 6e 74 72 	subd3 (sp),-(r4),-(r2)
   2ad39:	6c 00 67    	cvtbd $0x0,(r7)
   2ad3c:	72 61 70    	mnegd (r1),-(r0)
   2ad3f:	68 00 6c    	cvtdb $0x0 [d-float],(ap)
   2ad42:	6f 77 65 72 	acbd -(r7),(r5),-(r2),31d48 <_sys_siglist+0x6030>
   2ad46:	00 70 
   2ad48:	72 69 6e    	mnegd (r9),(sp)
   2ad4b:	74 00 70 75 	emodd $0x0 [d-float],-(r0),-(r5),(sp),(r3)
   2ad4f:	6e 63 
   2ad51:	74 00 73 70 	emodd $0x0 [d-float],-(r3),-(r0),(r1),(r3)
   2ad55:	61 63 
   2ad57:	65 00 75 70 	muld3 $0x0 [d-float],-(r5),-(r0)
   2ad5b:	70 65 72    	movd (r5),-(r2)
   2ad5e:	00          	halt
   2ad5f:	78 64 69 67 	ashl (r4),(r9),(r7)
   2ad63:	69 74 00    	cvtdw -(r4),$0x0
   2ad66:	4e 4f 4e 45 	cvtlf $0x0[r5][sp][pc],r5
   2ad6a:	00 55 
   2ad6c:	54 46 38 00 	emodf $0x38 [f-float][r6],$0x0,pc,(r3),(r9)
   2ad70:	5f 63 69 
   2ad73:	74 72 75 73 	emodd -(r2),-(r5),-(r3),pc,-(r5)
   2ad77:	5f 75 
   2ad79:	74 66 38 5f 	emodd (r6),$0x38,pc,(r3),-(r4)
   2ad7d:	63 74 
   2ad7f:	79 70 65 5f 	ashq -(r0),(r5),pc
   2ad83:	77 63       	.word 0x7763
   2ad85:	73 6e       	tstd (sp)
   2ad87:	72 74 6f    	mnegd -(r4),(pc)
   2ad8a:	6d 62 73    	cvtwd (r2),-(r3)
	...
   2ad95:	00          	halt
   2ad96:	00          	halt
   2ad97:	00          	halt
   2ad98:	08 00 00 00 	cvtps $0x0,$0x0,$0x0,*7302ada1 <_end+0x72fc893d>
   2ad9c:	ff 00 00 00 
   2ada0:	73 
   2ada1:	74 61 63 6b 	emodd (r1),(r3),(r11),$0x20,(pc)
   2ada5:	20 6f 
   2ada7:	76 65 72    	cvtdf (r5),-(r2)
   2adaa:	66 6c 6f    	divd2 (ap),(pc)
   2adad:	77 20       	.word 0x7720
   2adaf:	69 6e 20    	cvtdw (sp),$0x20
   2adb2:	66 75 6e    	divd2 -(r5),(sp)
   2adb5:	63 74 69 6f 	subd3 -(r4),(r9),(pc)
   2adb9:	6e 20 25    	cvtld $0x20,$0x25 [d-float]
   2adbc:	73 00       	tstd $0x0 [d-float]
	...
   2adc6:	00          	halt
   2adc7:	00          	halt
   2adc8:	08 00 00 00 	cvtps $0x0,$0x0,$0x0,*6202add1 <_end+0x61fc896d>
   2adcc:	ff 00 00 00 
   2add0:	62 
   2add1:	61 63 6b 77 	addd3 (r3),(r11),-(r7)
   2add5:	61 72 64 73 	addd3 -(r2),(r4),-(r3)
   2add9:	20 6d 65 6d 	addp4 (fp),(r5),(fp),(r3)
   2addd:	63 
   2adde:	70 79 00    	movd -(r9),$0x0 [d-float]
   2ade1:	00          	halt
	...

0002ade4 <_DefaultMessagesLocale>:
   2ade4:	f4 ad 02 00 	sobgeq 0x2(fp),2ade8 <_DefaultMessagesLocale+0x4>
   2ade8:	fa ad 02 00 	callg 0x2(fp),$0x0
   2adec:	00          	halt
   2aded:	ae 02 00    	mnegw $0x2,$0x0
   2adf0:	04          	ret
   2adf1:	ae 02 00    	mnegw $0x2,$0x0
   2adf4:	5e 5b 59    	remqhi r11,r9
   2adf7:	79 5d 00 5e 	ashq fp,$0x0,sp
   2adfb:	5b 4e       	.word 0x5b4e
   2adfd:	6e 5d 00    	cvtld fp,$0x0 [d-float]
   2ae00:	79 65 73 00 	ashq (r5),-(r3),$0x0
   2ae04:	6e 6f 00    	cvtld (pc),$0x0 [d-float]
	...

0002ae08 <_DefaultNumericLocale>:
   2ae08:	14 ae       	bgtr 2adb8 <__tens_D2A+0x190>
   2ae0a:	02          	rei
   2ae0b:	00          	halt
   2ae0c:	20 b0 02 00 	addp4 *0x2(r0),$0x0,$0x20,*0x2(r0)
   2ae10:	20 b0 02 
   2ae13:	00          	halt
   2ae14:	2e 00 00 00 	movtc $0x0,$0x0,$0x0,0x2ae(r8),$0x0,0x2ae(ap)
   2ae18:	c8 ae 02 00 
   2ae1c:	cc ae 02 

0002ae18 <_DefaultTimeLocale>:
   2ae18:	c8 ae 02 00 	bisl2 0x2(sp),$0x0
   2ae1c:	cc ae 02 00 	xorl2 0x2(sp),$0x0
   2ae20:	d0 ae 02 00 	movl 0x2(sp),$0x0
   2ae24:	d4 ae 02    	clrf 0x2(sp)
   2ae27:	00          	halt
   2ae28:	d8 ae 02 00 	adwc 0x2(sp),$0x0
   2ae2c:	dc ae 02    	movpsl 0x2(sp)
   2ae2f:	00          	halt
   2ae30:	e0 ae 02 00 	bbs 0x2(sp),$0x0,2ae19 <_DefaultTimeLocale+0x1>
   2ae34:	e4 
   2ae35:	ae 02 00    	mnegw $0x2,$0x0
   2ae38:	eb ae 02 00 	ffc 0x2(sp),$0x0,*0xfa0002ae(r2),0x2(sp)
   2ae3c:	f2 ae 02 00 
   2ae40:	fa ae 02 
   2ae43:	00          	halt
   2ae44:	04          	ret
   2ae45:	af 02 00 0d 	casew $0x2,$0x0,$0xd
   2ae49:	af 02 00 14 	casew $0x2,$0x0,$0x14
   2ae4d:	af 02 00 1d 	casew $0x2,$0x0,$0x1d
   2ae51:	af 02 00 21 	casew $0x2,$0x0,$0x21
   2ae55:	af 02 00 25 	casew $0x2,$0x0,$0x25
   2ae59:	af 02 00 29 	casew $0x2,$0x0,$0x29
   2ae5d:	af 02 00 2d 	casew $0x2,$0x0,$0x2d
   2ae61:	af 02 00 31 	casew $0x2,$0x0,$0x31
   2ae65:	af 02 00 35 	casew $0x2,$0x0,$0x35
   2ae69:	af 02 00 39 	casew $0x2,$0x0,$0x39
   2ae6d:	af 02 00 3d 	casew $0x2,$0x0,$0x3d
   2ae71:	af 02 00 41 	casew $0x2,$0x0,2ae79 <_DefaultTimeLocale+0x61>[r1]
   2ae75:	af 02 
   2ae77:	00          	halt
   2ae78:	45 af 02 00 	mulf3 2ae7d <_DefaultTimeLocale+0x65>,$0x0 [f-float],2ae81 <_DefaultTimeLocale+0x69>[r9]
   2ae7c:	49 af 02 
   2ae7f:	00          	halt
   2ae80:	4d af 02 00 	cvtwf 2ae85 <_DefaultTimeLocale+0x6d>,$0x0 [f-float]
   2ae84:	55 af 02 00 	polyf 2ae89 <_DefaultTimeLocale+0x71>,$0x0,sp
   2ae88:	5e 
   2ae89:	af 02 00 64 	casew $0x2,$0x0,(r4)
   2ae8d:	af 02 00 2d 	casew $0x2,$0x0,$0x2d
   2ae91:	af 02 00 6a 	casew $0x2,$0x0,(r10)
   2ae95:	af 02 00 6f 	casew $0x2,$0x0,(pc)
   2ae99:	af 02 00 74 	casew $0x2,$0x0,-(r4)
   2ae9d:	af 02 00 7b 	casew $0x2,$0x0,-(r11)
   2aea1:	af 02 00 85 	casew $0x2,$0x0,(r5)+
   2aea5:	af 02 00 8d 	casew $0x2,$0x0,(fp)+
   2aea9:	af 02 00 96 	casew $0x2,$0x0,@(r6)+
   2aead:	af 02 00 9f 	casew $0x2,$0x0,*0xa20002af
   2aeb1:	af 02 00 a2 
   2aeb5:	af 02 00 a5 	casew $0x2,$0x0,0xffffffaf(r5)
   2aeb9:	af 
   2aeba:	02          	rei
   2aebb:	00          	halt
   2aebc:	ba af 02    	popr 2aec1 <_DefaultTimeLocale+0xa9>
   2aebf:	00          	halt
   2aec0:	c3 af 02 00 	subl3 2aec5 <_DefaultTimeLocale+0xad>,$0x0,0x2af(ap)
   2aec4:	cc af 02 
   2aec7:	00          	halt
   2aec8:	53 75       	tstf -(r5)
   2aeca:	6e 00 4d 6f 	cvtld $0x0,(pc)[fp]
   2aece:	6e 00 54    	cvtld $0x0,r4
   2aed1:	75 65 00 57 	polyd (r5),$0x0,r7
   2aed5:	65 64 00 54 	muld3 (r4),$0x0 [d-float],r4
   2aed9:	68 75 00    	cvtdb -(r5),$0x0
   2aedc:	46 72 69    	divf2 -(r2),(r9)
   2aedf:	00          	halt
   2aee0:	53 61       	tstf (r1)
   2aee2:	74 00 53 75 	emodd $0x0 [d-float],r3,-(r5),(sp),(r4)
   2aee6:	6e 64 
   2aee8:	61 79 00 4d 	addd3 -(r9),$0x0 [d-float],(pc)[fp]
   2aeec:	6f 
   2aeed:	6e 64 61    	cvtld (r4),(r1)
   2aef0:	79 00 54 75 	ashq $0x0,r4,-(r5)
   2aef4:	65 73 64 61 	muld3 -(r3),(r4),(r1)
   2aef8:	79 00 57 65 	ashq $0x0,r7,(r5)
   2aefc:	64 6e 65    	muld2 (sp),(r5)
   2aeff:	73 64       	tstd (r4)
   2af01:	61 79 00 54 	addd3 -(r9),$0x0 [d-float],r4
   2af05:	68 75 72    	cvtdb -(r5),-(r2)
   2af08:	73 64       	tstd (r4)
   2af0a:	61 79 00 46 	addd3 -(r9),$0x0 [d-float],-(r2)[r6]
   2af0e:	72 
   2af0f:	69 64 61    	cvtdw (r4),(r1)
   2af12:	79 00 53 61 	ashq $0x0,r3,(r1)
   2af16:	74 75 72 64 	emodd -(r5),-(r2),(r4),(r1),-(r9)
   2af1a:	61 79 
   2af1c:	00          	halt
   2af1d:	4a 61 6e    	cvtfl (r1),(sp)
   2af20:	00          	halt
   2af21:	46 65 62    	divf2 (r5),(r2)
   2af24:	00          	halt
   2af25:	4d 61 72    	cvtwf (r1),-(r2)
   2af28:	00          	halt
   2af29:	41 70 72 00 	addf3 -(r0),-(r2),$0x0 [f-float]
   2af2d:	4d 61 79    	cvtwf (r1),-(r9)
   2af30:	00          	halt
   2af31:	4a 75 6e    	cvtfl -(r5),(sp)
   2af34:	00          	halt
   2af35:	4a 75 6c    	cvtfl -(r5),(ap)
   2af38:	00          	halt
   2af39:	41 75 67 00 	addf3 -(r5),(r7),$0x0 [f-float]
   2af3d:	53 65       	tstf (r5)
   2af3f:	70 00 4f 63 	movd $0x0 [d-float],(r3)[pc]
   2af43:	74 00 4e 6f 	emodd $0x0 [d-float],(pc)[sp],-(r6),$0x0,(r5)[r4]
   2af47:	76 00 44 65 
   2af4b:	63 00 4a 61 	subd3 $0x0 [d-float],(r1)[r10],(sp)
   2af4f:	6e 
   2af50:	75 61 72 79 	polyd (r1),-(r2),-(r9)
   2af54:	00          	halt
   2af55:	46 65 62    	divf2 (r5),(r2)
   2af58:	72 75 61    	mnegd -(r5),(r1)
   2af5b:	72 79 00    	mnegd -(r9),$0x0 [d-float]
   2af5e:	4d 61 72    	cvtwf (r1),-(r2)
   2af61:	63 68 00 41 	subd3 (r8),$0x0 [d-float],-(r0)[r1]
   2af65:	70 
   2af66:	72 69 6c    	mnegd (r9),(ap)
   2af69:	00          	halt
   2af6a:	4a 75 6e    	cvtfl -(r5),(sp)
   2af6d:	65 00 4a 75 	muld3 $0x0 [d-float],-(r5)[r10],(ap)
   2af71:	6c 
   2af72:	79 00 41 75 	ashq $0x0,-(r5)[r1],(r7)
   2af76:	67 
   2af77:	75 73 74 00 	polyd -(r3),-(r4),$0x0
   2af7b:	53 65       	tstf (r5)
   2af7d:	70 74 65    	movd -(r4),(r5)
   2af80:	6d 62 65    	cvtwd (r2),(r5)
   2af83:	72 00 4f 63 	mnegd $0x0 [d-float],(r3)[pc]
   2af87:	74 6f 62 65 	emodd (pc),(r2),(r5),-(r2),$0x0 [d-float]
   2af8b:	72 00 
   2af8d:	4e 6f 76    	cvtlf (pc),-(r6)
   2af90:	65 6d 62 65 	muld3 (fp),(r2),(r5)
   2af94:	72 00 44 65 	mnegd $0x0 [d-float],(r5)[r4]
   2af98:	63 65 6d 62 	subd3 (r5),(fp),(r2)
   2af9c:	65 72 00 41 	muld3 -(r2),$0x0 [d-float],$0x0 [d-float][fp][r1]
   2afa0:	4d 00 
   2afa2:	50 4d 00 25 	movf $0x0 [f-float][fp],$0x25 [f-float]
   2afa6:	61 20 25 62 	addd3 $0x20 [d-float],$0x25 [d-float],(r2)
   2afaa:	20 25 65 20 	addp4 $0x25,(r5),$0x20,$0x25
   2afae:	25 
   2afaf:	48 3a 25    	cvtfb $0x3a [f-float],$0x25
   2afb2:	4d 3a 25    	cvtwf $0x3a,$0x25 [f-float]
   2afb5:	53 20       	tstf $0x20 [f-float]
   2afb7:	25 59 00 25 	mulp r9,$0x0,$0x25,(fp),$0x2f,$0x25
   2afbb:	6d 2f 25 
   2afbe:	64 2f 25    	muld2 $0x2f [d-float],$0x25 [d-float]
   2afc1:	79 00 25 48 	ashq $0x0,$0x25,$0x3a[r8]
   2afc5:	3a 
   2afc6:	25 4d 3a 25 	mulp $0x3a[fp],$0x25,r3,$0x0,$0x25,$0x3a[r9]
   2afca:	53 00 25 49 
   2afce:	3a 
   2afcf:	25 4d 3a 25 	mulp $0x3a[fp],$0x25,r3,$0x20,$0x25,-(r0)
   2afd3:	53 20 25 70 
   2afd7:	00          	halt
   2afd8:	73 79       	tstd -(r9)
   2afda:	73 6c       	tstd (ap)
   2afdc:	6f 67 25 73 	acbd (r7),$0x25 [d-float],-(r3),2d01c <_sys_siglist+0x1304>
   2afe0:	3a 20 
   2afe2:	75 6e 6b 6e 	polyd (sp),(r11),(sp)
   2afe6:	6f 77 6e 20 	acbd -(r7),(sp),$0x20 [d-float],31152 <_sys_siglist+0x543a>
   2afea:	66 61 
   2afec:	63 69 6c 69 	subd3 (r9),(ap),(r9)
   2aff0:	74 79 2f 70 	emodd -(r9),$0x2f,-(r0),-(r2),(r9)
   2aff4:	72 69 
   2aff6:	6f 72 69 74 	acbd -(r2),(r9),-(r4),2ea75 <_sys_siglist+0x2d5d>
   2affa:	79 3a 
   2affc:	20 25 78 00 	addp4 $0x25,-(r8),$0x0,pc
   2b000:	5f 
   2b001:	5f 76 73    	remqti -(r6),-(r3)
   2b004:	79 73 6c 6f 	ashq -(r3),(ap),(pc)
   2b008:	67 5f 72 00 	divd3 pc,-(r2),$0x0 [d-float]
   2b00c:	3c 25 64    	movzwl $0x25,(r4)
   2b00f:	3e 00 2f    	movaw $0x0,$0x2f
   2b012:	64 65 76    	muld2 (r5),-(r6)
   2b015:	2f 63 6f 6e 	movtuc (r3),(pc),(sp),-(r3),(pc),(ap)
   2b019:	73 6f 6c 
   2b01c:	65 00 0d 0a 	muld3 $0x0 [d-float],$0xd [d-float],$0xa [d-float]
   2b020:	00          	halt
   2b021:	45 72 72 6f 	mulf3 -(r2),-(r2),(pc)
   2b025:	72 20 25    	mnegd $0x20 [d-float],$0x25 [d-float]
   2b028:	64 00 5b    	muld2 $0x0 [d-float],r11
   2b02b:	25 6c 64 5d 	mulp (ap),(r4),fp,$0x0,$0x25,$0x2e
   2b02f:	00 25 2e 
   2b032:	2a 73 00 76 	scanc -(r3),$0x0,-(r6),-(r3)
   2b036:	73 
   2b037:	6e 70 72    	cvtld -(r0),-(r2)
   2b03a:	69 6e 74    	cvtdw (sp),-(r4)
   2b03d:	66 00 6d    	divd2 $0x0 [d-float],(fp)

0002b03f <q.0>:
   2b03f:	6d 61 6c    	cvtwd (r1),(ap)
   2b042:	6c 6f 63    	cvtbd (pc),(r3)
   2b045:	28 29 20 77 	movc3 $0x29,$0x20,-(r7)
   2b049:	61 72 6e 69 	addd3 -(r2),(sp),(r9)
   2b04d:	6e 67 3a    	cvtld (r7),$0x3a [d-float]
   2b050:	20 75 6e 6b 	addp4 -(r5),(sp),(r11),(sp)
   2b054:	6e 
   2b055:	6f 77 6e 20 	acbd -(r7),(sp),$0x20 [d-float],318be <_sys_siglist+0x5ba6>
   2b059:	63 68 
   2b05b:	61 72 20 69 	addd3 -(r2),$0x20 [d-float],(r9)
   2b05f:	6e 20 4d 41 	cvtld $0x20,pc[r3][pc][ap][ap][r1][fp]
   2b063:	4c 4c 4f 43 
   2b067:	5f 
   2b068:	4f 50 54 49 	acbf r0,r4,r3[sp][pc][r9],2b07b <q.0+0x3c>
   2b06c:	4f 4e 53 0a 
   2b070:	00 
   2b071:	28 25 64 29 	movc3 $0x25,(r4),$0x29
   2b075:	20 69 6e 20 	addp4 (r9),(sp),$0x20,$0x0
   2b079:	00 
   2b07a:	77 72       	.word 0x7772
   2b07c:	74 65 72 72 	emodd (r5),-(r2),-(r2),(pc),-(r2)
   2b080:	6f 72 
   2b082:	00          	halt
   2b083:	6d 75 6e    	cvtwd -(r5),(sp)
   2b086:	6d 61 70    	cvtwd (r1),-(r0)
   2b089:	20 72 6f 75 	addp4 -(r2),(pc),-(r5),(sp)
   2b08d:	6e 
   2b08e:	64 00 6d    	muld2 $0x0 [d-float],(fp)
   2b091:	61 6c 6c 6f 	addd3 (ap),(ap),(pc)
   2b095:	63 20 63 61 	subd3 $0x20 [d-float],(r3),(r1)
   2b099:	63 68 65 20 	subd3 (r8),(r5),$0x20 [d-float]
   2b09d:	6f 76 65 72 	acbd -(r6),(r5),-(r2),31d09 <_sys_siglist+0x5ff1>
   2b0a1:	66 6c 
   2b0a3:	6f 77 00 6d 	acbd -(r7),$0x0 [d-float],(fp),31d0a <_sys_siglist+0x5ff2>
   2b0a7:	61 6c 
   2b0a9:	6c 6f 63    	cvtbd (pc),(r3)
   2b0ac:	20 66 72 65 	addp4 (r6),-(r2),(r5),(r5)
   2b0b0:	65 
   2b0b1:	20 73 6c 6f 	addp4 -(r3),(ap),(pc),-(r4)
   2b0b5:	74 
   2b0b6:	20 6c 6f 73 	addp4 (ap),(pc),-(r3),-(r4)
   2b0ba:	74 
   2b0bb:	00          	halt
   2b0bc:	6d 61 6c    	cvtwd (r1),(ap)
   2b0bf:	6c 6f 63    	cvtbd (pc),(r3)
   2b0c2:	20 63 61 63 	addp4 (r3),(r1),(r3),(r8)
   2b0c6:	68 
   2b0c7:	65 20 75 6e 	muld3 $0x20 [d-float],-(r5),(sp)
   2b0cb:	64 65 72    	muld2 (r5),-(r2)
   2b0ce:	66 6c 6f    	divd2 (ap),(pc)
   2b0d1:	77 00       	.word 0x7700
   2b0d3:	6d 75 6e    	cvtwd -(r5),(sp)
   2b0d6:	6d 61 70    	cvtwd (r1),-(r0)
   2b0d9:	00          	halt
   2b0da:	69 6e 74    	cvtdw (sp),-(r4)
   2b0dd:	65 72 6e 61 	muld3 -(r2),(sp),(r1)
   2b0e1:	6c 20 73    	cvtbd $0x20,-(r3)
   2b0e4:	74 72 75 63 	emodd -(r2),-(r5),(r3),-(r4),$0x20 [d-float]
   2b0e8:	74 20 
   2b0ea:	63 6f 72 72 	subd3 (pc),-(r2),-(r2)
   2b0ee:	75 70 74 00 	polyd -(r0),-(r4),$0x0
   2b0f2:	6d 61 6c    	cvtwd (r1),(ap)
   2b0f5:	6c 6f 63    	cvtbd (pc),(r3)
   2b0f8:	20 63 61 63 	addp4 (r3),(r1),(r3),(r8)
   2b0fc:	68 
   2b0fd:	65 00 6f 6d 	muld3 $0x0 [d-float],(pc),(fp)
   2b101:	61 6c 6c 6f 	addd3 (ap),(ap),(pc)
   2b105:	63 5f 69 6e 	subd3 pc,(r9),(sp)
   2b109:	69 74 00    	cvtdw -(r4),$0x0
   2b10c:	6d 61 6c    	cvtwd (r1),(ap)
   2b10f:	6c 6f 63    	cvtbd (pc),(r3)
   2b112:	20 69 6e 69 	addp4 (r9),(sp),(r9),-(r4)
   2b116:	74 
   2b117:	20 6d 6d 61 	addp4 (fp),(fp),(r1),-(r0)
   2b11b:	70 
   2b11c:	20 66 61 69 	addp4 (r6),(r1),(r9),(ap)
   2b120:	6c 
   2b121:	65 64 00 2f 	muld3 (r4),$0x0 [d-float],$0x2f [d-float]
   2b125:	65 74 63 2f 	muld3 -(r4),(r3),$0x2f [d-float]
   2b129:	6d 61 6c    	cvtwd (r1),(ap)
   2b12c:	6c 6f 63    	cvtbd (pc),(r3)
   2b12f:	2e 63 6f 6e 	movtc (r3),(pc),(sp),(r6),$0x0,pc[r3][pc][ap][ap][r1][fp]
   2b133:	66 00 4d 41 
   2b137:	4c 4c 4f 43 
   2b13b:	5f 
   2b13c:	4f 50 54 49 	acbf r0,r4,r3[sp][pc][r9],32345 <_sys_siglist+0x662d>
   2b140:	4f 4e 53 00 
   2b144:	72 
   2b145:	65 67 69 6f 	muld3 (r7),(r9),(pc)
   2b149:	6e 73 5f    	cvtld -(r3),pc
   2b14c:	74 6f 74 61 	emodd (pc),-(r4),(r1),(ap),$0x20 [d-float]
   2b150:	6c 20 
   2b152:	6e 6f 74    	cvtld (pc),-(r4)
   2b155:	20 32 5e 78 	addp4 $0x32,sp,-(r8),$0x0
   2b159:	00 
   2b15a:	70 70 20    	movd -(r0),$0x20 [d-float]
   2b15d:	26 20 62 69 	cvttp $0x20,(r2),(r9),-(r4),-(r3)
   2b161:	74 73 
   2b163:	00          	halt
   2b164:	63 68 75 6e 	subd3 (r8),-(r5),(sp)
   2b168:	6b 20 69    	cvtrdl $0x20 [d-float],(r9)
   2b16b:	6e 66 6f    	cvtld (r6),(pc)
   2b16e:	20 63 6f 72 	addp4 (r3),(pc),-(r2),-(r2)
   2b172:	72 
   2b173:	75 70 74 65 	polyd -(r0),-(r4),(r5)
   2b177:	64 00 63    	muld2 $0x0 [d-float],(r3)
   2b17a:	68 75 6e    	cvtdb -(r5),(sp)
   2b17d:	6b 20 69    	cvtrdl $0x20 [d-float],(r9)
   2b180:	73 20       	tstd $0x20 [d-float]
   2b182:	61 6c 72 65 	addd3 (ap),-(r2),(r5)
   2b186:	61 64 79 20 	addd3 (r4),-(r9),$0x20 [d-float]
   2b18a:	66 72 65    	divd2 -(r2),(r5)
   2b18d:	65 00 6d 6f 	muld3 $0x0 [d-float],(fp),(pc)
   2b191:	64 69 66    	muld2 (r9),(r6)
   2b194:	69 65 64    	cvtdw (r5),(r4)
   2b197:	20 63 68 75 	addp4 (r3),(r8),-(r5),(sp)
   2b19b:	6e 
   2b19c:	6b 2d 70    	cvtrdl $0x2d [d-float],-(r0)
   2b19f:	6f 69 6e 74 	acbd (r9),(sp),-(r4),3240a <_sys_siglist+0x66f2>
   2b1a3:	65 72 
   2b1a5:	00          	halt
   2b1a6:	6d 70 72    	cvtwd -(r0),-(r2)
   2b1a9:	6f 74 65 63 	acbd -(r4),(r5),(r3),2b223 <q.0+0x1e4>
   2b1ad:	74 00 
   2b1af:	72 65 63    	mnegd (r5),(r3)
   2b1b2:	75 72 73 69 	polyd -(r2),-(r3),(r9)
   2b1b6:	76 65 20    	cvtdf (r5),$0x20 [f-float]
   2b1b9:	63 61 6c 6c 	subd3 (r1),(ap),(ap)
   2b1bd:	00          	halt
   2b1be:	6f 75 74 20 	acbd -(r5),-(r4),$0x20 [d-float],31833 <_sys_siglist+0x5b1b>
   2b1c2:	6f 66 
   2b1c4:	20 6d 65 6d 	addp4 (fp),(r5),(fp),(pc)
   2b1c8:	6f 
   2b1c9:	72 79 00    	mnegd -(r9),$0x0 [d-float]
   2b1cc:	6d 61 6c    	cvtwd (r1),(ap)
   2b1cf:	6c 6f 63    	cvtbd (pc),(r3)
   2b1d2:	28 29 3a 00 	movc3 $0x29,$0x3a,$0x0
   2b1d6:	62 6f 67    	subd2 (pc),(r7)
   2b1d9:	75 73 20 70 	polyd -(r3),$0x20,-(r0)
   2b1dd:	6f 69 6e 74 	acbd (r9),(sp),-(r4),32448 <_sys_siglist+0x6730>
   2b1e1:	65 72 
   2b1e3:	00          	halt
   2b1e4:	67 75 61 72 	divd3 -(r5),(r1),-(r2)
   2b1e8:	64 20 73    	muld2 $0x20 [d-float],-(r3)
   2b1eb:	69 7a 65    	cvtdw -(r10),(r5)
   2b1ee:	00          	halt
   2b1ef:	62 6f 67    	subd2 (pc),(r7)
   2b1f2:	75 73 20 70 	polyd -(r3),$0x20,-(r0)
   2b1f6:	6f 69 6e 74 	acbd (r9),(sp),-(r4),32461 <_sys_siglist+0x6749>
   2b1fa:	65 72 
   2b1fc:	20 28 64 6f 	addp4 $0x28,(r4),(pc),-(r5)
   2b200:	75 
   2b201:	62 6c 65    	subd2 (ap),(r5)
   2b204:	20 66 72 65 	addp4 (r6),-(r2),(r5),(r5)
   2b208:	65 
   2b209:	3f 29       	pushaw $0x29
   2b20b:	00          	halt
   2b20c:	64 6f 75    	muld2 (pc),-(r5)
   2b20f:	62 6c 65    	subd2 (ap),(r5)
   2b212:	20 66 72 65 	addp4 (r6),-(r2),(r5),(r5)
   2b216:	65 
   2b217:	00          	halt
   2b218:	66 72 65    	divd2 -(r2),(r5)
   2b21b:	65 28 29 3a 	muld3 $0x28 [d-float],$0x29 [d-float],$0x3a [d-float]
   2b21f:	00          	halt
   2b220:	66 72 65    	divd2 -(r2),(r5)
   2b223:	65 28 29 20 	muld3 $0x28 [d-float],$0x29 [d-float],$0x20 [d-float]
   2b227:	63 61 6c 6c 	subd3 (r1),(ap),(ap)
   2b22b:	65 64 20 62 	muld3 (r4),$0x20 [d-float],(r2)
   2b22f:	65 66 6f 72 	muld3 (r6),(pc),-(r2)
   2b233:	65 20 61 6c 	muld3 $0x20 [d-float],(r1),(ap)
   2b237:	6c 6f 63    	cvtbd (pc),(r3)
   2b23a:	61 74 69 6f 	addd3 -(r4),(r9),(pc)
   2b23e:	6e 00 72    	cvtld $0x0,-(r2)
   2b241:	65 61 6c 6c 	muld3 (r1),(ap),(ap)
   2b245:	6f 63 28 29 	acbd (r3),$0x28 [d-float],$0x29 [d-float],2b285 <q.0+0x246>
   2b249:	3a 00 
   2b24b:	63 61 6c 6c 	subd3 (r1),(ap),(ap)
   2b24f:	6f 63 28 29 	acbd (r3),$0x28 [d-float],$0x29 [d-float],2b28f <sigma+0x2>
   2b253:	3a 00 
   2b255:	6d 61 70    	cvtwd (r1),-(r0)
   2b258:	61 6c 69 67 	addd3 (ap),(r9),(r7)
   2b25c:	6e 20 62    	cvtld $0x20,(r2)
   2b25f:	61 64 20 61 	addd3 (r4),$0x20 [d-float],(r1)
   2b263:	6c 69 67    	cvtbd (r9),(r7)
   2b266:	6e 6d 65    	cvtld (fp),(r5)
   2b269:	6e 74 00    	cvtld -(r4),$0x0 [d-float]
   2b26c:	6d 61 70    	cvtwd (r1),-(r0)
   2b26f:	61 6c 69 67 	addd3 (ap),(r9),(r7)
   2b273:	6e 20 72    	cvtld $0x20,-(r2)
   2b276:	6f 75 6e 64 	acbd -(r5),(sp),(r4),3227c <_sys_siglist+0x6564>
   2b27a:	00 70 
   2b27c:	6f 73 69 78 	acbd -(r3),(r9),-(r8),31fe1 <_sys_siglist+0x62c9>
   2b280:	5f 6d 
   2b282:	65 6d 61 6c 	muld3 (fp),(r1),(ap)
   2b286:	69 67 6e    	cvtdw (r7),(sp)
   2b289:	28 29 3a 00 	movc3 $0x29,$0x3a,$0x0

0002b28d <sigma>:
   2b28d:	65 78 70 61 	muld3 -(r8),-(r0),(r1)
   2b291:	6e 64 20    	cvtld (r4),$0x20 [d-float]
   2b294:	33 32 2d    	cvtwb $0x32,$0x2d
   2b297:	62 79 74    	subd2 -(r9),-(r4)
   2b29a:	65 20 6b 65 	muld3 $0x20 [d-float],(r11),(r5)

0002b29d <tau>:
   2b29d:	65 78 70 61 	muld3 -(r8),-(r0),(r1)
   2b2a1:	6e 64 20    	cvtld (r4),$0x20 [d-float]
   2b2a4:	31 36 2d    	brw 2dfdd <_sys_siglist+0x22c5>
   2b2a7:	62 79 74    	subd2 -(r9),-(r4)
   2b2aa:	65 20 6b 63 	muld3 $0x20 [d-float],(r11),(r3)
   2b2ae:	68 61 63    	cvtdb (r1),(r3)
   2b2b1:	68 61 5f    	cvtdb (r1),pc
   2b2b4:	65 6e 63 72 	muld3 (sp),(r3),-(r2)
   2b2b8:	79 70 74 5f 	ashq -(r0),-(r4),pc
   2b2bc:	62 79 74    	subd2 -(r9),-(r4)
   2b2bf:	65 73 00 5f 	muld3 -(r3),$0x0 [d-float],pc
   2b2c3:	72 73 5f    	mnegd -(r3),pc
   2b2c6:	73 74       	tstd -(r4)
   2b2c8:	69 72 00    	cvtdw -(r2),$0x0
   2b2cb:	6c 69 62    	cvtbd (r9),(r2)
   2b2ce:	63 00 55 6e 	subd3 $0x0 [d-float],r5,(sp)
   2b2d2:	6b 6e 6f    	cvtrdl (sp),(pc)
   2b2d5:	77 6e       	.word 0x776e
   2b2d7:	20 65 72 72 	addp4 (r5),-(r2),-(r2),(pc)
   2b2db:	6f 
   2b2dc:	72 3a 20    	mnegd $0x3a [d-float],$0x20 [d-float]
   2b2df:	00          	halt
   2b2e0:	55 6e 6b 6e 	polyf (sp),(r11),(sp)
   2b2e4:	6f 77 6e 20 	acbd -(r7),(sp),$0x20 [d-float],31c5d <_sys_siglist+0x5f45>
   2b2e8:	73 69 
   2b2ea:	67 6e 61 6c 	divd3 (sp),(r1),(ap)
   2b2ee:	3a 20 00 5f 	locc $0x20,$0x0,pc
   2b2f2:	63 61 74 6f 	subd3 (r1),-(r4),(pc)
   2b2f6:	70 65 6e    	movd (r5),(sp)
   2b2f9:	00          	halt
   2b2fa:	2f 75 73 72 	movtuc -(r5),-(r3),-(r2),$0x2f,-(r3),(r8)
   2b2fe:	2f 73 68 
   2b301:	61 72 65 2f 	addd3 -(r2),(r5),$0x2f [d-float]
   2b305:	6e 6c 73    	cvtld (ap),-(r3)
   2b308:	2f 25 4c 2f 	movtuc $0x25,$0x2f[ap],$0x25,$0x2e[sp],(r3),(r1)
   2b30c:	25 4e 2e 63 
   2b310:	61 
   2b311:	74 3a 2f 75 	emodd $0x3a [d-float],$0x2f,-(r5),-(r3),-(r2)
   2b315:	73 72 
   2b317:	2f 73 68 61 	movtuc -(r3),(r8),(r1),-(r2),(r5),$0x2f
   2b31b:	72 65 2f 
   2b31e:	6e 6c 73    	cvtld (ap),-(r3)
   2b321:	2f 25 6c 2e 	movtuc $0x25,(ap),$0x2e,$0x25,(r3),$0x2f
   2b325:	25 63 2f 
   2b328:	25 4e 2e 63 	mulp $0x2e[sp],(r3),(r1),-(r4),$0x3a,$0x2f
   2b32c:	61 74 3a 2f 
   2b330:	75 73 72 2f 	polyd -(r3),-(r2),$0x2f
   2b334:	73 68       	tstd (r8)
   2b336:	61 72 65 2f 	addd3 -(r2),(r5),$0x2f [d-float]
   2b33a:	6e 6c 73    	cvtld (ap),-(r3)
   2b33d:	2f 25 6c 2f 	movtuc $0x25,(ap),$0x2f,$0x25,$0x2e[sp],(r3)
   2b341:	25 4e 2e 63 
   2b345:	61 74 00 50 	addd3 -(r4),$0x0 [d-float],r0
   2b349:	4f 53 49 58 	acbf r3,r8[r9],$0x0 [f-float],2b393 <_sys_errlist+0x23>
   2b34d:	00 43 00 
   2b350:	4c 41 4e 47 	cvtbf $0x0[r7][sp][r1],pc[r3][ap]
   2b354:	00 4c 43 5f 
   2b358:	41 4c 4c 00 	addf3 $0x0 [f-float][ap][ap],pc[r3][ap],r3[r5][fp]
   2b35c:	4c 43 5f 4d 
   2b360:	45 53 
   2b362:	53 41 47 45 	tstf r3[r5][r7][r1]
   2b366:	53 
   2b367:	00          	halt
   2b368:	4e 4c 53 50 	cvtlf r3[ap],r0
   2b36c:	41 54 48 00 	addf3 r4,$0x0 [f-float][r8],0xf30002b4(r0)
   2b370:	e0 b4 02 00 
   2b374:	f3 

0002b370 <_sys_errlist>:
   2b370:	e0 b4 02 00 	bbs *0x2(r4),$0x0,2b368 <tau+0xcb>
   2b374:	f3 
   2b375:	b4 02       	clrw $0x2
   2b377:	00          	halt
   2b378:	0b b5 02 00 	crc *0x2(r5),$0x0,$0x25,*0x2(r5)
   2b37c:	25 b5 02 
   2b37f:	00          	halt
   2b380:	35 b5 02 00 	cmpp3 *0x2(r5),$0x0,*0x2(r5)[fp]
   2b384:	4d b5 02 
   2b387:	00          	halt
   2b388:	60 b5 02 00 	addd2 *0x2(r5),$0x0 [d-float]
   2b38c:	76 b5 02 00 	cvtdf *0x2(r5),$0x0 [f-float]
   2b390:	8d b5 02 00 	xorb3 *0x2(r5),$0x0,*0xb30002b5
   2b394:	9f b5 02 00 
   2b398:	b3 
   2b399:	b5 02       	tstw $0x2
   2b39b:	00          	halt
   2b39c:	c6 b5 02 00 	divl2 *0x2(r5),$0x0
   2b3a0:	e0 b5 02 00 	bbs *0x2(r5),$0x0,2b39c <_sys_errlist+0x2c>
   2b3a4:	f7 
   2b3a5:	b5 02       	tstw $0x2
   2b3a7:	00          	halt
   2b3a8:	09 b6 02 00 	cvtsp *0x2(r6),$0x0,$0x15,*0x2(r6)
   2b3ac:	15 b6 02 
   2b3af:	00          	halt
   2b3b0:	2b b6 02 00 	spanc *0x2(r6),$0x0,$0x37,*0x2(r6)
   2b3b4:	37 b6 02 
   2b3b7:	00          	halt
   2b3b8:	43 b6 02 00 	subf3 *0x2(r6),$0x0 [f-float],r5
   2b3bc:	55 
   2b3bd:	b6 02       	incw $0x2
   2b3bf:	00          	halt
   2b3c0:	77 b6       	.word 0x77b6
   2b3c2:	02          	rei
   2b3c3:	00          	halt
   2b3c4:	87 b6 02 00 	divb3 *0x2(r6),$0x0,@(r6)+
   2b3c8:	96 
   2b3c9:	b6 02       	incw $0x2
   2b3cb:	00          	halt
   2b3cc:	a7 b6 02 00 	divw3 *0x2(r6),$0x0,0x2b6(r5)
   2b3d0:	c5 b6 02 
   2b3d3:	00          	halt
   2b3d4:	d9 b6 02 00 	sbwc *0x2(r6),$0x0
   2b3d8:	f8 b6 02 00 	ashp *0x2(r6),$0x0,$0x7,*0x2(r7),$0x0,$0x16
   2b3dc:	07 b7 02 00 
   2b3e0:	16 
   2b3e1:	b7 02       	decw $0x2
   2b3e3:	00          	halt
   2b3e4:	2e b7 02 00 	movtc *0x2(r7),$0x0,$0x3b,*0x2(r7),$0x0,r1
   2b3e8:	3b b7 02 00 
   2b3ec:	51 
   2b3ed:	b7 02       	decw $0x2
   2b3ef:	00          	halt
   2b3f0:	60 b7 02 00 	addd2 *0x2(r7),$0x0 [d-float]
   2b3f4:	6c b7 02 00 	cvtbd *0x2(r7),$0x0 [d-float]
   2b3f8:	8d b7 02 00 	xorb3 *0x2(r7),$0x0,@(sp)+
   2b3fc:	9e 
   2b3fd:	b7 02       	decw $0x2
   2b3ff:	00          	halt
   2b400:	bf b7 02    	chmu *0x2(r7)
   2b403:	00          	halt
   2b404:	d9 b7 02 00 	sbwc *0x2(r7),$0x0
   2b408:	f7 b7 02 00 	cvtlw *0x2(r7),$0x0
   2b40c:	16 b8 02    	jsb *0x2(r8)
   2b40f:	00          	halt
   2b410:	33 b8 02 00 	cvtwb *0x2(r8),$0x0
   2b414:	44 b8 02 00 	mulf2 *0x2(r8),$0x0 [f-float]
   2b418:	63 b8 02 00 	subd3 *0x2(r8),$0x0 [d-float],-(r10)
   2b41c:	7a 
   2b41d:	b8 02       	bispsw $0x2
   2b41f:	00          	halt
   2b420:	91 b8 02 00 	cmpb *0x2(r8),$0x0
   2b424:	ab b8 02 00 	bicw3 *0x2(r8),$0x0,0x2b8(r3)
   2b428:	c3 b8 02 
   2b42b:	00          	halt
   2b42c:	e1 b8 02 00 	bbc *0x2(r8),$0x0,2b442 <_sys_errlist+0xd2>
   2b430:	11 
   2b431:	b9 02       	bicpsw $0x2
   2b433:	00          	halt
   2b434:	28 b9 02 00 	movc3 *0x2(r9),$0x0,*0x2(r9)[r7]
   2b438:	47 b9 02 
   2b43b:	00          	halt
   2b43c:	57 b9       	.word 0x57b9
   2b43e:	02          	rei
   2b43f:	00          	halt
   2b440:	6e b9 02 00 	cvtld *0x2(r9),$0x0 [d-float]
   2b444:	92 b9 02 00 	mcomb *0x2(r9),$0x0
   2b448:	b3 b9 02 00 	bitw *0x2(r9),$0x0
   2b44c:	cc b9 02 00 	xorl2 *0x2(r9),$0x0
   2b450:	e6 b9 02 00 	bbssi *0x2(r9),$0x0,2b457 <_sys_errlist+0xe7>
   2b454:	02 
   2b455:	ba 02       	popr $0x2
   2b457:	00          	halt
   2b458:	1a ba       	bgtru 2b414 <_sys_errlist+0xa4>
   2b45a:	02          	rei
   2b45b:	00          	halt
   2b45c:	3b ba 02 00 	skpc *0x2(r10),$0x0,fp
   2b460:	5d 
   2b461:	ba 02       	popr $0x2
   2b463:	00          	halt
   2b464:	71 ba 02 00 	cmpd *0x2(r10),$0x0 [d-float]
   2b468:	84 ba 02 00 	mulb2 *0x2(r10),$0x0
   2b46c:	a6 ba 02 00 	divw2 *0x2(r10),$0x0
   2b470:	b9 ba 02    	bicpsw *0x2(r10)
   2b473:	00          	halt
   2b474:	c6 ba 02 00 	divl2 *0x2(r10),$0x0
   2b478:	d7 ba 02    	decl *0x2(r10)
   2b47b:	00          	halt
   2b47c:	eb ba 02 00 	ffc *0x2(r10),$0x0,*0xd0002ba(sp),*0x2(r11)
   2b480:	fe ba 02 00 
   2b484:	0d bb 02 
   2b487:	00          	halt
   2b488:	21 bb 02 00 	addp6 *0x2(r11),$0x0,$0x37,*0x2(r11),$0x0,r9
   2b48c:	37 bb 02 00 
   2b490:	59 
   2b491:	bb 02       	pushr $0x2
   2b493:	00          	halt
   2b494:	6b bb 02 00 	cvtrdl *0x2(r11),$0x0
   2b498:	7d bb 02 00 	movq *0x2(r11),$0x0
   2b49c:	91 bb 02 00 	cmpb *0x2(r11),$0x0
   2b4a0:	a7 bb 02 00 	divw3 *0x2(r11),$0x0,0x2bb(r1)
   2b4a4:	c1 bb 02 
   2b4a7:	00          	halt
   2b4a8:	d4 bb 02    	clrf *0x2(r11)
   2b4ab:	00          	halt
   2b4ac:	ed bb 02 00 	cmpzv *0x2(r11),$0x0,$0xf,*0x2(ap)
   2b4b0:	0f bc 02 
   2b4b3:	00          	halt
   2b4b4:	24 bc 02 00 	cvtpt *0x2(ap),$0x0,$0x37,*0x2(ap),$0x0
   2b4b8:	37 bc 02 00 
   2b4bc:	50 bc 02 00 	movf *0x2(ap),$0x0 [f-float]
   2b4c0:	64 bc 02 00 	muld2 *0x2(ap),$0x0 [d-float]
   2b4c4:	7a bc 02 00 	emul *0x2(ap),$0x0,(r10)+,*0x2(ap)
   2b4c8:	8a bc 02 
   2b4cb:	00          	halt
   2b4cc:	9c bc 02 00 	rotl *0x2(ap),$0x0,0x2bc(r6)
   2b4d0:	c6 bc 02 
   2b4d3:	00          	halt
   2b4d4:	d9 bc 02 00 	sbwc *0x2(ap),$0x0
   2b4d8:	ec bc 02 00 	cmpv *0x2(ap),$0x0,$0x7,*0x2(fp)
   2b4dc:	07 bd 02 
   2b4df:	00          	halt
   2b4e0:	55 6e 64 65 	polyf (sp),(r4),(r5)
   2b4e4:	66 69 6e    	divd2 (r9),(sp)
   2b4e7:	65 64 20 65 	muld3 (r4),$0x20 [d-float],(r5)
   2b4eb:	72 72 6f    	mnegd -(r2),(pc)
   2b4ee:	72 3a 20    	mnegd $0x3a [d-float],$0x20 [d-float]
   2b4f1:	30 00 4f    	bsbw 303f4 <_sys_siglist+0x46dc>
   2b4f4:	70 65 72    	movd (r5),-(r2)
   2b4f7:	61 74 69 6f 	addd3 -(r4),(r9),(pc)
   2b4fb:	6e 20 6e    	cvtld $0x20,(sp)
   2b4fe:	6f 74 20 70 	acbd -(r4),$0x20 [d-float],-(r0),32769 <_sys_siglist+0x6a51>
   2b502:	65 72 
   2b504:	6d 69 74    	cvtwd (r9),-(r4)
   2b507:	74 65 64 00 	emodd (r5),(r4),$0x0 [d-float],(pc)[sp],$0x20 [d-float]
   2b50b:	4e 6f 20 
   2b50e:	73 75       	tstd -(r5)
   2b510:	63 68 20 66 	subd3 (r8),$0x20 [d-float],(r6)
   2b514:	69 6c 65    	cvtdw (ap),(r5)
   2b517:	20 6f 72 20 	addp4 (pc),-(r2),$0x20,(r4)
   2b51b:	64 
   2b51c:	69 72 65    	cvtdw -(r2),(r5)
   2b51f:	63 74 6f 72 	subd3 -(r4),(pc),-(r2)
   2b523:	79 00 4e 6f 	ashq $0x0,(pc)[sp],$0x20
   2b527:	20 
   2b528:	73 75       	tstd -(r5)
   2b52a:	63 68 20 70 	subd3 (r8),$0x20 [d-float],-(r0)
   2b52e:	72 6f 63    	mnegd (pc),(r3)
   2b531:	65 73 73 00 	muld3 -(r3),-(r3),$0x0 [d-float]
   2b535:	49 6e 74    	cvtfw (sp),-(r4)
   2b538:	65 72 72 75 	muld3 -(r2),-(r2),-(r5)
   2b53c:	70 74 65    	movd -(r4),(r5)
   2b53f:	64 20 73    	muld2 $0x20 [d-float],-(r3)
   2b542:	79 73 74 65 	ashq -(r3),-(r4),(r5)
   2b546:	6d 20 63    	cvtwd $0x20,(r3)
   2b549:	61 6c 6c 00 	addd3 (ap),(ap),$0x0 [d-float]
   2b54d:	49 6e 70    	cvtfw (sp),-(r0)
   2b550:	75 74 2f 6f 	polyd -(r4),$0x2f,(pc)
   2b554:	75 74 70 75 	polyd -(r4),-(r0),-(r5)
   2b558:	74 20 65 72 	emodd $0x20 [d-float],(r5),-(r2),-(r2),(pc)
   2b55c:	72 6f 
   2b55e:	72 00 44 65 	mnegd $0x0 [d-float],(r5)[r4]
   2b562:	76 69 63    	cvtdf (r9),(r3)
   2b565:	65 20 6e 6f 	muld3 $0x20 [d-float],(sp),(pc)
   2b569:	74 20 63 6f 	emodd $0x20 [d-float],(r3),(pc),(sp),(r6)
   2b56d:	6e 66 
   2b56f:	69 67 75    	cvtdw (r7),-(r5)
   2b572:	72 65 64    	mnegd (r5),(r4)
   2b575:	00          	halt
   2b576:	41 72 67 75 	addf3 -(r2),(r7),-(r5)
   2b57a:	6d 65 6e    	cvtwd (r5),(sp)
   2b57d:	74 20 6c 69 	emodd $0x20 [d-float],(ap),(r9),-(r3),-(r4)
   2b581:	73 74 
   2b583:	20 74 6f 6f 	addp4 -(r4),(pc),(pc),$0x20
   2b587:	20 
   2b588:	6c 6f 6e    	cvtbd (pc),(sp)
   2b58b:	67 00 45 78 	divd3 $0x0 [d-float],-(r8)[r5],(r5)
   2b58f:	65 
   2b590:	63 20 66 6f 	subd3 $0x20 [d-float],(r6),(pc)
   2b594:	72 6d 61    	mnegd (fp),(r1)
   2b597:	74 20 65 72 	emodd $0x20 [d-float],(r5),-(r2),-(r2),(pc)
   2b59b:	72 6f 
   2b59d:	72 00 42 61 	mnegd $0x0 [d-float],(r1)[r2]
   2b5a1:	64 20 66    	muld2 $0x20 [d-float],(r6)
   2b5a4:	69 6c 65    	cvtdw (ap),(r5)
   2b5a7:	20 64 65 73 	addp4 (r4),(r5),-(r3),(r3)
   2b5ab:	63 
   2b5ac:	72 69 70    	mnegd (r9),-(r0)
   2b5af:	74 6f 72 00 	emodd (pc),-(r2),$0x0 [d-float],(pc)[sp],$0x20 [d-float]
   2b5b3:	4e 6f 20 
   2b5b6:	63 68 69 6c 	subd3 (r8),(r9),(ap)
   2b5ba:	64 20 70    	muld2 $0x20 [d-float],-(r0)
   2b5bd:	72 6f 63    	mnegd (pc),(r3)
   2b5c0:	65 73 73 65 	muld3 -(r3),-(r3),(r5)
   2b5c4:	73 00       	tstd $0x0 [d-float]
   2b5c6:	52 65 73    	mnegf (r5),-(r3)
   2b5c9:	6f 75 72 63 	acbd -(r5),-(r2),(r3),2d634 <_sys_siglist+0x191c>
   2b5cd:	65 20 
   2b5cf:	64 65 61    	muld2 (r5),(r1)
   2b5d2:	64 6c 6f    	muld2 (ap),(pc)
   2b5d5:	63 6b 20 61 	subd3 (r11),$0x20 [d-float],(r1)
   2b5d9:	76 6f 69    	cvtdf (pc),(r9)
   2b5dc:	64 65 64    	muld2 (r5),(r4)
   2b5df:	00          	halt
   2b5e0:	43 61 6e 6e 	subf3 (r1),(sp),(sp)
   2b5e4:	6f 74 20 61 	acbd -(r4),$0x20 [d-float],(r1),32256 <_sys_siglist+0x653e>
   2b5e8:	6c 6c 
   2b5ea:	6f 63 61 74 	acbd (r3),(r1),-(r4),2d655 <_sys_siglist+0x193d>
   2b5ee:	65 20 
   2b5f0:	6d 65 6d    	cvtwd (r5),(fp)
   2b5f3:	6f 72 79 00 	acbd -(r2),-(r9),$0x0 [d-float],31b49 <_sys_siglist+0x5e31>
   2b5f7:	50 65 
   2b5f9:	72 6d 69    	mnegd (fp),(r9)
   2b5fc:	73 73       	tstd -(r3)
   2b5fe:	69 6f 6e    	cvtdw (pc),(sp)
   2b601:	20 64 65 6e 	addp4 (r4),(r5),(sp),(r9)
   2b605:	69 
   2b606:	65 64 00 42 	muld3 (r4),$0x0 [d-float],(r1)[r2]
   2b60a:	61 
   2b60b:	64 20 61    	muld2 $0x20 [d-float],(r1)
   2b60e:	64 64 72    	muld2 (r4),-(r2)
   2b611:	65 73 73 00 	muld3 -(r3),-(r3),$0x0 [d-float]
   2b615:	42 6c 6f    	subf2 (ap),(pc)
   2b618:	63 6b 20 64 	subd3 (r11),$0x20 [d-float],(r4)
   2b61c:	65 76 69 63 	muld3 -(r6),(r9),(r3)
   2b620:	65 20 72 65 	muld3 $0x20 [d-float],-(r2),(r5)
   2b624:	71 75 69    	cmpd -(r5),(r9)
   2b627:	72 65 64    	mnegd (r5),(r4)
   2b62a:	00          	halt
   2b62b:	44 65 76    	mulf2 (r5),-(r6)
   2b62e:	69 63 65    	cvtdw (r3),(r5)
   2b631:	20 62 75 73 	addp4 (r2),-(r5),-(r3),-(r9)
   2b635:	79 
   2b636:	00          	halt
   2b637:	46 69 6c    	divf2 (r9),(ap)
   2b63a:	65 20 65 78 	muld3 $0x20 [d-float],(r5),-(r8)
   2b63e:	69 73 74    	cvtdw -(r3),-(r4)
   2b641:	73 00       	tstd $0x0 [d-float]
   2b643:	43 72 6f 73 	subf3 -(r2),(pc),-(r3)
   2b647:	73 2d       	tstd $0x2d [d-float]
   2b649:	64 65 76    	muld2 (r5),-(r6)
   2b64c:	69 63 65    	cvtdw (r3),(r5)
   2b64f:	20 6c 69 6e 	addp4 (ap),(r9),(sp),(r11)
   2b653:	6b 
   2b654:	00          	halt
   2b655:	4f 70 65 72 	acbf -(r0),(r5),-(r2),32abc <_sys_siglist+0x6da4>
   2b659:	61 74 
   2b65b:	69 6f 6e    	cvtdw (pc),(sp)
   2b65e:	20 6e 6f 74 	addp4 (sp),(pc),-(r4),$0x20
   2b662:	20 
   2b663:	73 75       	tstd -(r5)
   2b665:	70 70 6f    	movd -(r0),(pc)
   2b668:	72 74 65    	mnegd -(r4),(r5)
   2b66b:	64 20 62    	muld2 $0x20 [d-float],(r2)
   2b66e:	79 20 64 65 	ashq $0x20,(r4),(r5)
   2b672:	76 69 63    	cvtdf (r9),(r3)
   2b675:	65 00 4e 6f 	muld3 $0x0 [d-float],(pc)[sp],-(r4)
   2b679:	74 
   2b67a:	20 61 20 64 	addp4 (r1),$0x20,(r4),(r9)
   2b67e:	69 
   2b67f:	72 65 63    	mnegd (r5),(r3)
   2b682:	74 6f 72 79 	emodd (pc),-(r2),-(r9),$0x0,-(r3)[r9]
   2b686:	00 49 73 
   2b689:	20 61 20 64 	addp4 (r1),$0x20,(r4),(r9)
   2b68d:	69 
   2b68e:	72 65 63    	mnegd (r5),(r3)
   2b691:	74 6f 72 79 	emodd (pc),-(r2),-(r9),$0x0,(sp)[r9]
   2b695:	00 49 6e 
   2b698:	76 61 6c    	cvtdf (r1),(ap)
   2b69b:	69 64 20    	cvtdw (r4),$0x20
   2b69e:	61 72 67 75 	addd3 -(r2),(r7),-(r5)
   2b6a2:	6d 65 6e    	cvtwd (r5),(sp)
   2b6a5:	74 00 54 6f 	emodd $0x0 [d-float],r4,(pc),(pc),$0x20 [d-float]
   2b6a9:	6f 20 
   2b6ab:	6d 61 6e    	cvtwd (r1),(sp)
   2b6ae:	79 20 6f 70 	ashq $0x20,(pc),-(r0)
   2b6b2:	65 6e 20 66 	muld3 (sp),$0x20 [d-float],(r6)
   2b6b6:	69 6c 65    	cvtdw (ap),(r5)
   2b6b9:	73 20       	tstd $0x20 [d-float]
   2b6bb:	69 6e 20    	cvtdw (sp),$0x20
   2b6be:	73 79       	tstd -(r9)
   2b6c0:	73 74       	tstd -(r4)
   2b6c2:	65 6d 00 54 	muld3 (fp),$0x0 [d-float],r4
   2b6c6:	6f 6f 20 6d 	acbd (pc),$0x20 [d-float],(fp),3252d <_sys_siglist+0x6815>
   2b6ca:	61 6e 
   2b6cc:	79 20 6f 70 	ashq $0x20,(pc),-(r0)
   2b6d0:	65 6e 20 66 	muld3 (sp),$0x20 [d-float],(r6)
   2b6d4:	69 6c 65    	cvtdw (ap),(r5)
   2b6d7:	73 00       	tstd $0x0 [d-float]
   2b6d9:	49 6e 61    	cvtfw (sp),(r1)
   2b6dc:	70 70 72    	movd -(r0),-(r2)
   2b6df:	6f 70 72 69 	acbd -(r0),-(r2),(r9),32b46 <_sys_siglist+0x6e2e>
   2b6e3:	61 74 
   2b6e5:	65 20 69 6f 	muld3 $0x20 [d-float],(r9),(pc)
   2b6e9:	63 74 6c 20 	subd3 -(r4),(ap),$0x20 [d-float]
   2b6ed:	66 6f 72    	divd2 (pc),-(r2)
   2b6f0:	20 64 65 76 	addp4 (r4),(r5),-(r6),(r9)
   2b6f4:	69 
   2b6f5:	63 65 00 54 	subd3 (r5),$0x0 [d-float],r4
   2b6f9:	65 78 74 20 	muld3 -(r8),-(r4),$0x20 [d-float]
   2b6fd:	66 69 6c    	divd2 (r9),(ap)
   2b700:	65 20 62 75 	muld3 $0x20 [d-float],(r2),-(r5)
   2b704:	73 79       	tstd -(r9)
   2b706:	00          	halt
   2b707:	46 69 6c    	divf2 (r9),(ap)
   2b70a:	65 20 74 6f 	muld3 $0x20 [d-float],-(r4),(pc)
   2b70e:	6f 20 6c 61 	acbd $0x20 [d-float],(ap),(r1),31e86 <_sys_siglist+0x616e>
   2b712:	72 67 
   2b714:	65 00 4e 6f 	muld3 $0x0 [d-float],(pc)[sp],$0x20 [d-float]
   2b718:	20 
   2b719:	73 70       	tstd -(r0)
   2b71b:	61 63 65 20 	addd3 (r3),(r5),$0x20 [d-float]
   2b71f:	6c 65 66    	cvtbd (r5),(r6)
   2b722:	74 20 6f 6e 	emodd $0x20 [d-float],(pc),(sp),$0x20,(r4)
   2b726:	20 64 
   2b728:	65 76 69 63 	muld3 -(r6),(r9),(r3)
   2b72c:	65 00 49 6c 	muld3 $0x0 [d-float],(ap)[r9],(ap)
   2b730:	6c 
   2b731:	65 67 61 6c 	muld3 (r7),(r1),(ap)
   2b735:	20 73 65 65 	addp4 -(r3),(r5),(r5),(r11)
   2b739:	6b 
   2b73a:	00          	halt
   2b73b:	52 65 61    	mnegf (r5),(r1)
   2b73e:	64 2d 6f    	muld2 $0x2d [d-float],(pc)
   2b741:	6e 6c 79    	cvtld (ap),-(r9)
   2b744:	20 66 69 6c 	addp4 (r6),(r9),(ap),(r5)
   2b748:	65 
   2b749:	20 73 79 73 	addp4 -(r3),-(r9),-(r3),-(r4)
   2b74d:	74 
   2b74e:	65 6d 00 54 	muld3 (fp),$0x0 [d-float],r4
   2b752:	6f 6f 20 6d 	acbd (pc),$0x20 [d-float],(fp),325b9 <_sys_siglist+0x68a1>
   2b756:	61 6e 
   2b758:	79 20 6c 69 	ashq $0x20,(ap),(r9)
   2b75c:	6e 6b 73    	cvtld (r11),-(r3)
   2b75f:	00          	halt
   2b760:	42 72 6f    	subf2 -(r2),(pc)
   2b763:	6b 65 6e    	cvtrdl (r5),(sp)
   2b766:	20 70 69 70 	addp4 -(r0),(r9),-(r0),(r5)
   2b76a:	65 
   2b76b:	00          	halt
   2b76c:	4e 75 6d    	cvtlf -(r5),(fp)
   2b76f:	65 72 69 63 	muld3 -(r2),(r9),(r3)
   2b773:	61 6c 20 61 	addd3 (ap),$0x20 [d-float],(r1)
   2b777:	72 67 75    	mnegd (r7),-(r5)
   2b77a:	6d 65 6e    	cvtwd (r5),(sp)
   2b77d:	74 20 6f 75 	emodd $0x20 [d-float],(pc),-(r5),-(r4),$0x20 [d-float]
   2b781:	74 20 
   2b783:	6f 66 20 64 	acbd (r6),$0x20 [d-float],(r4),324f8 <_sys_siglist+0x67e0>
   2b787:	6f 6d 
   2b789:	61 69 6e 00 	addd3 (r9),(sp),$0x0 [d-float]
   2b78d:	52 65 73    	mnegf (r5),-(r3)
   2b790:	75 6c 74 20 	polyd (ap),-(r4),$0x20
   2b794:	74 6f 6f 20 	emodd (pc),(pc),$0x20 [d-float],(ap),(r1)
   2b798:	6c 61 
   2b79a:	72 67 65    	mnegd (r7),(r5)
   2b79d:	00          	halt
   2b79e:	52 65 73    	mnegf (r5),-(r3)
   2b7a1:	6f 75 72 63 	acbd -(r5),-(r2),(r3),2d80c <_sys_siglist+0x1af4>
   2b7a5:	65 20 
   2b7a7:	74 65 6d 70 	emodd (r5),(fp),-(r0),(pc),-(r2)
   2b7ab:	6f 72 
   2b7ad:	61 72 69 6c 	addd3 -(r2),(r9),(ap)
   2b7b1:	79 20 75 6e 	ashq $0x20,-(r5),(sp)
   2b7b5:	61 76 61 69 	addd3 -(r6),(r1),(r9)
   2b7b9:	6c 61 62    	cvtbd (r1),(r2)
   2b7bc:	6c 65 00    	cvtbd (r5),$0x0 [d-float]
   2b7bf:	4f 70 65 72 	acbf -(r0),(r5),-(r2),32c26 <_sys_siglist+0x6f0e>
   2b7c3:	61 74 
   2b7c5:	69 6f 6e    	cvtdw (pc),(sp)
   2b7c8:	20 6e 6f 77 	addp4 (sp),(pc),-(r7),$0x20
   2b7cc:	20 
   2b7cd:	69 6e 20    	cvtdw (sp),$0x20
   2b7d0:	70 72 6f    	movd -(r2),(pc)
   2b7d3:	67 72 65 73 	divd3 -(r2),(r5),-(r3)
   2b7d7:	73 00       	tstd $0x0 [d-float]
   2b7d9:	4f 70 65 72 	acbf -(r0),(r5),-(r2),32c40 <_sys_siglist+0x6f28>
   2b7dd:	61 74 
   2b7df:	69 6f 6e    	cvtdw (pc),(sp)
   2b7e2:	20 61 6c 72 	addp4 (r1),(ap),-(r2),(r5)
   2b7e6:	65 
   2b7e7:	61 64 79 20 	addd3 (r4),-(r9),$0x20 [d-float]
   2b7eb:	69 6e 20    	cvtdw (sp),$0x20
   2b7ee:	70 72 6f    	movd -(r2),(pc)
   2b7f1:	67 72 65 73 	divd3 -(r2),(r5),-(r3)
   2b7f5:	73 00       	tstd $0x0 [d-float]
   2b7f7:	53 6f       	tstf (pc)
   2b7f9:	63 6b 65 74 	subd3 (r11),(r5),-(r4)
   2b7fd:	20 6f 70 65 	addp4 (pc),-(r0),(r5),-(r2)
   2b801:	72 
   2b802:	61 74 69 6f 	addd3 -(r4),(r9),(pc)
   2b806:	6e 20 6f    	cvtld $0x20,(pc)
   2b809:	6e 20 6e    	cvtld $0x20,(sp)
   2b80c:	6f 6e 2d 73 	acbd (sp),$0x2d [d-float],-(r3),31b81 <_sys_siglist+0x5e69>
   2b810:	6f 63 
   2b812:	6b 65 74    	cvtrdl (r5),-(r4)
   2b815:	00          	halt
   2b816:	44 65 73    	mulf2 (r5),-(r3)
   2b819:	74 69 6e 61 	emodd (r9),(sp),(r1),-(r4),(r9)
   2b81d:	74 69 
   2b81f:	6f 6e 20 61 	acbd (sp),$0x20 [d-float],(r1),31c89 <_sys_siglist+0x5f71>
   2b823:	64 64 
   2b825:	72 65 73    	mnegd (r5),-(r3)
   2b828:	73 20       	tstd $0x20 [d-float]
   2b82a:	72 65 71    	mnegd (r5),-(r1)
   2b82d:	75 69 72 65 	polyd (r9),-(r2),(r5)
   2b831:	64 00 4d 65 	muld2 $0x0 [d-float],(r5)[fp]
   2b835:	73 73       	tstd -(r3)
   2b837:	61 67 65 20 	addd3 (r7),(r5),$0x20 [d-float]
   2b83b:	74 6f 6f 20 	emodd (pc),(pc),$0x20 [d-float],(ap),(pc)
   2b83f:	6c 6f 
   2b841:	6e 67 00    	cvtld (r7),$0x0 [d-float]
   2b844:	50 72 6f    	movf -(r2),(pc)
   2b847:	74 6f 63 6f 	emodd (pc),(r3),(pc),(ap),$0x20 [d-float]
   2b84b:	6c 20 
   2b84d:	77 72       	.word 0x7772
   2b84f:	6f 6e 67 20 	acbd (sp),(r7),$0x20 [d-float],331c9 <_sys_siglist+0x74b1>
   2b853:	74 79 
   2b855:	70 65 20    	movd (r5),$0x20 [d-float]
   2b858:	66 6f 72    	divd2 (pc),-(r2)
   2b85b:	20 73 6f 63 	addp4 -(r3),(pc),(r3),(r11)
   2b85f:	6b 
   2b860:	65 74 00 50 	muld3 -(r4),$0x0 [d-float],r0
   2b864:	72 6f 74    	mnegd (pc),-(r4)
   2b867:	6f 63 6f 6c 	acbd (r3),(pc),(ap),3268d <_sys_siglist+0x6975>
   2b86b:	20 6e 
   2b86d:	6f 74 20 61 	acbd -(r4),$0x20 [d-float],(r1),319e9 <_sys_siglist+0x5cd1>
   2b871:	76 61 
   2b873:	69 6c 61    	cvtdw (ap),(r1)
   2b876:	62 6c 65    	subd2 (ap),(r5)
   2b879:	00          	halt
   2b87a:	50 72 6f    	movf -(r2),(pc)
   2b87d:	74 6f 63 6f 	emodd (pc),(r3),(pc),(ap),$0x20 [d-float]
   2b881:	6c 20 
   2b883:	6e 6f 74    	cvtld (pc),-(r4)
   2b886:	20 73 75 70 	addp4 -(r3),-(r5),-(r0),-(r0)
   2b88a:	70 
   2b88b:	6f 72 74 65 	acbd -(r2),-(r4),(r5),2b8f5 <_sys_errlist+0x585>
   2b88f:	64 00 
   2b891:	53 6f       	tstf (pc)
   2b893:	63 6b 65 74 	subd3 (r11),(r5),-(r4)
   2b897:	20 74 79 70 	addp4 -(r4),-(r9),-(r0),(r5)
   2b89b:	65 
   2b89c:	20 6e 6f 74 	addp4 (sp),(pc),-(r4),$0x20
   2b8a0:	20 
   2b8a1:	73 75       	tstd -(r5)
   2b8a3:	70 70 6f    	movd -(r0),(pc)
   2b8a6:	72 74 65    	mnegd -(r4),(r5)
   2b8a9:	64 00 4f 70 	muld2 $0x0 [d-float],-(r0)[pc]
   2b8ad:	65 72 61 74 	muld3 -(r2),(r1),-(r4)
   2b8b1:	69 6f 6e    	cvtdw (pc),(sp)
   2b8b4:	20 6e 6f 74 	addp4 (sp),(pc),-(r4),$0x20
   2b8b8:	20 
   2b8b9:	73 75       	tstd -(r5)
   2b8bb:	70 70 6f    	movd -(r0),(pc)
   2b8be:	72 74 65    	mnegd -(r4),(r5)
   2b8c1:	64 00 50    	muld2 $0x0 [d-float],r0
   2b8c4:	72 6f 74    	mnegd (pc),-(r4)
   2b8c7:	6f 63 6f 6c 	acbd (r3),(pc),(ap),31eed <_sys_siglist+0x61d5>
   2b8cb:	20 66 
   2b8cd:	61 6d 69 6c 	addd3 (fp),(r9),(ap)
   2b8d1:	79 20 6e 6f 	ashq $0x20,(sp),(pc)
   2b8d5:	74 20 73 75 	emodd $0x20 [d-float],-(r3),-(r5),-(r0),-(r0)
   2b8d9:	70 70 
   2b8db:	6f 72 74 65 	acbd -(r2),-(r4),(r5),2b945 <_sys_errlist+0x5d5>
   2b8df:	64 00 
   2b8e1:	41 64 64 72 	addf3 (r4),(r4),-(r2)
   2b8e5:	65 73 73 20 	muld3 -(r3),-(r3),$0x20 [d-float]
   2b8e9:	66 61 6d    	divd2 (r1),(fp)
   2b8ec:	69 6c 79    	cvtdw (ap),-(r9)
   2b8ef:	20 6e 6f 74 	addp4 (sp),(pc),-(r4),$0x20
   2b8f3:	20 
   2b8f4:	73 75       	tstd -(r5)
   2b8f6:	70 70 6f    	movd -(r0),(pc)
   2b8f9:	72 74 65    	mnegd -(r4),(r5)
   2b8fc:	64 20 62    	muld2 $0x20 [d-float],(r2)
   2b8ff:	79 20 70 72 	ashq $0x20,-(r0),-(r2)
   2b903:	6f 74 6f 63 	acbd -(r4),(pc),(r3),32578 <_sys_siglist+0x6860>
   2b907:	6f 6c 
   2b909:	20 66 61 6d 	addp4 (r6),(r1),(fp),(r9)
   2b90d:	69 
   2b90e:	6c 79 00    	cvtbd -(r9),$0x0 [d-float]
   2b911:	41 64 64 72 	addf3 (r4),(r4),-(r2)
   2b915:	65 73 73 20 	muld3 -(r3),-(r3),$0x20 [d-float]
   2b919:	61 6c 72 65 	addd3 (ap),-(r2),(r5)
   2b91d:	61 64 79 20 	addd3 (r4),-(r9),$0x20 [d-float]
   2b921:	69 6e 20    	cvtdw (sp),$0x20
   2b924:	75 73 65 00 	polyd -(r3),(r5),$0x0
   2b928:	43 61 6e 27 	subf3 (r1),(sp),$0x27 [f-float]
   2b92c:	74 20 61 73 	emodd $0x20 [d-float],(r1),-(r3),-(r3),(r9)
   2b930:	73 69 
   2b932:	67 6e 20 72 	divd3 (sp),$0x20 [d-float],-(r2)
   2b936:	65 71 75 65 	muld3 -(r1),-(r5),(r5)
   2b93a:	73 74       	tstd -(r4)
   2b93c:	65 64 20 61 	muld3 (r4),$0x20 [d-float],(r1)
   2b940:	64 64 72    	muld2 (r4),-(r2)
   2b943:	65 73 73 00 	muld3 -(r3),-(r3),$0x0 [d-float]
   2b947:	4e 65 74    	cvtlf (r5),-(r4)
   2b94a:	77 6f       	.word 0x776f
   2b94c:	72 6b 20    	mnegd (r11),$0x20 [d-float]
   2b94f:	69 73 20    	cvtdw -(r3),$0x20
   2b952:	64 6f 77    	muld2 (pc),-(r7)
   2b955:	6e 00 4e 65 	cvtld $0x0,(r5)[sp]
   2b959:	74 77 6f 72 	emodd -(r7),(pc),-(r2),(r11),$0x20 [d-float]
   2b95d:	6b 20 
   2b95f:	69 73 20    	cvtdw -(r3),$0x20
   2b962:	75 6e 72 65 	polyd (sp),-(r2),(r5)
   2b966:	61 63 68 61 	addd3 (r3),(r8),(r1)
   2b96a:	62 6c 65    	subd2 (ap),(r5)
   2b96d:	00          	halt
   2b96e:	4e 65 74    	cvtlf (r5),-(r4)
   2b971:	77 6f       	.word 0x776f
   2b973:	72 6b 20    	mnegd (r11),$0x20 [d-float]
   2b976:	64 72 6f    	muld2 -(r2),(pc)
   2b979:	70 70 65    	movd -(r0),(r5)
   2b97c:	64 20 63    	muld2 $0x20 [d-float],(r3)
   2b97f:	6f 6e 6e 65 	acbd (sp),(sp),(r5),32de8 <_sys_siglist+0x70d0>
   2b983:	63 74 
   2b985:	69 6f 6e    	cvtdw (pc),(sp)
   2b988:	20 6f 6e 20 	addp4 (pc),(sp),$0x20,-(r2)
   2b98c:	72 
   2b98d:	65 73 65 74 	muld3 -(r3),(r5),-(r4)
   2b991:	00          	halt
   2b992:	53 6f       	tstf (pc)
   2b994:	66 74 77    	divd2 -(r4),-(r7)
   2b997:	61 72 65 20 	addd3 -(r2),(r5),$0x20 [d-float]
   2b99b:	63 61 75 73 	subd3 (r1),-(r5),-(r3)
   2b99f:	65 64 20 63 	muld3 (r4),$0x20 [d-float],(r3)
   2b9a3:	6f 6e 6e 65 	acbd (sp),(sp),(r5),32e0c <_sys_siglist+0x70f4>
   2b9a7:	63 74 
   2b9a9:	69 6f 6e    	cvtdw (pc),(sp)
   2b9ac:	20 61 62 6f 	addp4 (r1),(r2),(pc),-(r2)
   2b9b0:	72 
   2b9b1:	74 00 43 6f 	emodd $0x0 [d-float],(pc)[r3],(sp),(sp),(r5)
   2b9b5:	6e 6e 65 
   2b9b8:	63 74 69 6f 	subd3 -(r4),(r9),(pc)
   2b9bc:	6e 20 72    	cvtld $0x20,-(r2)
   2b9bf:	65 73 65 74 	muld3 -(r3),(r5),-(r4)
   2b9c3:	20 62 79 20 	addp4 (r2),-(r9),$0x20,-(r0)
   2b9c7:	70 
   2b9c8:	65 65 72 00 	muld3 (r5),-(r2),$0x0 [d-float]
   2b9cc:	4e 6f 20    	cvtlf (pc),$0x20 [f-float]
   2b9cf:	62 75 66    	subd2 -(r5),(r6)
   2b9d2:	66 65 72    	divd2 (r5),-(r2)
   2b9d5:	20 73 70 61 	addp4 -(r3),-(r0),(r1),(r3)
   2b9d9:	63 
   2b9da:	65 20 61 76 	muld3 $0x20 [d-float],(r1),-(r6)
   2b9de:	61 69 6c 61 	addd3 (r9),(ap),(r1)
   2b9e2:	62 6c 65    	subd2 (ap),(r5)
   2b9e5:	00          	halt
   2b9e6:	53 6f       	tstf (pc)
   2b9e8:	63 6b 65 74 	subd3 (r11),(r5),-(r4)
   2b9ec:	20 69 73 20 	addp4 (r9),-(r3),$0x20,(r1)
   2b9f0:	61 
   2b9f1:	6c 72 65    	cvtbd -(r2),(r5)
   2b9f4:	61 64 79 20 	addd3 (r4),-(r9),$0x20 [d-float]
   2b9f8:	63 6f 6e 6e 	subd3 (pc),(sp),(sp)
   2b9fc:	65 63 74 65 	muld3 (r3),-(r4),(r5)
   2ba00:	64 00 53    	muld2 $0x0 [d-float],r3
   2ba03:	6f 63 6b 65 	acbd (r3),(r11),(r5),2da7d <_sys_siglist+0x1d65>
   2ba07:	74 20 
   2ba09:	69 73 20    	cvtdw -(r3),$0x20
   2ba0c:	6e 6f 74    	cvtld (pc),-(r4)
   2ba0f:	20 63 6f 6e 	addp4 (r3),(pc),(sp),(sp)
   2ba13:	6e 
   2ba14:	65 63 74 65 	muld3 (r3),-(r4),(r5)
   2ba18:	64 00 43 61 	muld2 $0x0 [d-float],(r1)[r3]
   2ba1c:	6e 27 74    	cvtld $0x27,-(r4)
   2ba1f:	20 73 65 6e 	addp4 -(r3),(r5),(sp),(r4)
   2ba23:	64 
   2ba24:	20 61 66 74 	addp4 (r1),(r6),-(r4),(r5)
   2ba28:	65 
   2ba29:	72 20 73    	mnegd $0x20 [d-float],-(r3)
   2ba2c:	6f 63 6b 65 	acbd (r3),(r11),(r5),2daa6 <_sys_siglist+0x1d8e>
   2ba30:	74 20 
   2ba32:	73 68       	tstd (r8)
   2ba34:	75 74 64 6f 	polyd -(r4),(r4),(pc)
   2ba38:	77 6e       	.word 0x776e
   2ba3a:	00          	halt
   2ba3b:	54 6f 6f 20 	emodf (pc),(pc),$0x20 [f-float],(fp),(r1)
   2ba3f:	6d 61 
   2ba41:	6e 79 20    	cvtld -(r9),$0x20 [d-float]
   2ba44:	72 65 66    	mnegd (r5),(r6)
   2ba47:	65 72 65 6e 	muld3 -(r2),(r5),(sp)
   2ba4b:	63 65 73 3a 	subd3 (r5),-(r3),$0x3a [d-float]
   2ba4f:	20 63 61 6e 	addp4 (r3),(r1),(sp),$0x27
   2ba53:	27 
   2ba54:	74 20 73 70 	emodd $0x20 [d-float],-(r3),-(r0),(ap),(r9)
   2ba58:	6c 69 
   2ba5a:	63 65 00 4f 	subd3 (r5),$0x0 [d-float],-(r0)[pc]
   2ba5e:	70 
   2ba5f:	65 72 61 74 	muld3 -(r2),(r1),-(r4)
   2ba63:	69 6f 6e    	cvtdw (pc),(sp)
   2ba66:	20 74 69 6d 	addp4 -(r4),(r9),(fp),(r5)
   2ba6a:	65 
   2ba6b:	64 20 6f    	muld2 $0x20 [d-float],(pc)
   2ba6e:	75 74 00 43 	polyd -(r4),$0x0,(pc)[r3]
   2ba72:	6f 
   2ba73:	6e 6e 65    	cvtld (sp),(r5)
   2ba76:	63 74 69 6f 	subd3 -(r4),(r9),(pc)
   2ba7a:	6e 20 72    	cvtld $0x20,-(r2)
   2ba7d:	65 66 75 73 	muld3 (r6),-(r5),-(r3)
   2ba81:	65 64 00 54 	muld3 (r4),$0x0 [d-float],r4
   2ba85:	6f 6f 20 6d 	acbd (pc),$0x20 [d-float],(fp),328ec <_sys_siglist+0x6bd4>
   2ba89:	61 6e 
   2ba8b:	79 20 6c 65 	ashq $0x20,(ap),(r5)
   2ba8f:	76 65 6c    	cvtdf (r5),(ap)
   2ba92:	73 20       	tstd $0x20 [d-float]
   2ba94:	6f 66 20 73 	acbd (r6),$0x20 [d-float],-(r3),32813 <_sys_siglist+0x6afb>
   2ba98:	79 6d 
   2ba9a:	62 6f 6c    	subd2 (pc),(ap)
   2ba9d:	69 63 20    	cvtdw (r3),$0x20
   2baa0:	6c 69 6e    	cvtbd (r9),(sp)
   2baa3:	6b 73 00    	cvtrdl -(r3),$0x0
   2baa6:	46 69 6c    	divf2 (r9),(ap)
   2baa9:	65 20 6e 61 	muld3 $0x20 [d-float],(sp),(r1)
   2baad:	6d 65 20    	cvtwd (r5),$0x20 [d-float]
   2bab0:	74 6f 6f 20 	emodd (pc),(pc),$0x20 [d-float],(ap),(pc)
   2bab4:	6c 6f 
   2bab6:	6e 67 00    	cvtld (r7),$0x0 [d-float]
   2bab9:	48 6f 73    	cvtfb (pc),-(r3)
   2babc:	74 20 69 73 	emodd $0x20 [d-float],(r9),-(r3),$0x20,(r4)
   2bac0:	20 64 
   2bac2:	6f 77 6e 00 	acbd -(r7),(sp),$0x0 [d-float],32a16 <_sys_siglist+0x6cfe>
   2bac6:	4e 6f 
   2bac8:	20 72 6f 75 	addp4 -(r2),(pc),-(r5),-(r4)
   2bacc:	74 
   2bacd:	65 20 74 6f 	muld3 $0x20 [d-float],-(r4),(pc)
   2bad1:	20 68 6f 73 	addp4 (r8),(pc),-(r3),-(r4)
   2bad5:	74 
   2bad6:	00          	halt
   2bad7:	44 69 72    	mulf2 (r9),-(r2)
   2bada:	65 63 74 6f 	muld3 (r3),-(r4),(pc)
   2bade:	72 79 20    	mnegd -(r9),$0x20 [d-float]
   2bae1:	6e 6f 74    	cvtld (pc),-(r4)
   2bae4:	20 65 6d 70 	addp4 (r5),(fp),-(r0),-(r4)
   2bae8:	74 
   2bae9:	79 00 54 6f 	ashq $0x0,r4,(pc)
   2baed:	6f 20 6d 61 	acbd $0x20 [d-float],(fp),(r1),33461 <_sys_siglist+0x7749>
   2baf1:	6e 79 
   2baf3:	20 70 72 6f 	addp4 -(r0),-(r2),(pc),(r3)
   2baf7:	63 
   2baf8:	65 73 73 65 	muld3 -(r3),-(r3),(r5)
   2bafc:	73 00       	tstd $0x0 [d-float]
   2bafe:	54 6f 6f 20 	emodf (pc),(pc),$0x20 [f-float],(fp),(r1)
   2bb02:	6d 61 
   2bb04:	6e 79 20    	cvtld -(r9),$0x20 [d-float]
   2bb07:	75 73 65 72 	polyd -(r3),(r5),-(r2)
   2bb0b:	73 00       	tstd $0x0 [d-float]
   2bb0d:	44 69 73    	mulf2 (r9),-(r3)
   2bb10:	6b 20 71    	cvtrdl $0x20 [d-float],-(r1)
   2bb13:	75 6f 74 61 	polyd (pc),-(r4),(r1)
   2bb17:	20 65 78 63 	addp4 (r5),-(r8),(r3),(r5)
   2bb1b:	65 
   2bb1c:	65 64 65 64 	muld3 (r4),(r5),(r4)
   2bb20:	00          	halt
   2bb21:	53 74       	tstf -(r4)
   2bb23:	61 6c 65 20 	addd3 (ap),(r5),$0x20 [d-float]
   2bb27:	4e 46 53 20 	cvtlf r3[r6],$0x20 [f-float]
   2bb2b:	66 69 6c    	divd2 (r9),(ap)
   2bb2e:	65 20 68 61 	muld3 $0x20 [d-float],(r8),(r1)
   2bb32:	6e 64 6c    	cvtld (r4),(ap)
   2bb35:	65 00 54 6f 	muld3 $0x0 [d-float],r4,(pc)
   2bb39:	6f 20 6d 61 	acbd $0x20 [d-float],(fp),(r1),334ad <_sys_siglist+0x7795>
   2bb3d:	6e 79 
   2bb3f:	20 6c 65 76 	addp4 (ap),(r5),-(r6),(r5)
   2bb43:	65 
   2bb44:	6c 73 20    	cvtbd -(r3),$0x20 [d-float]
   2bb47:	6f 66 20 72 	acbd (r6),$0x20 [d-float],-(r2),328b2 <_sys_siglist+0x6b9a>
   2bb4b:	65 6d 
   2bb4d:	6f 74 65 20 	acbd -(r4),(r5),$0x20 [d-float],329bc <_sys_siglist+0x6ca4>
   2bb51:	69 6e 
   2bb53:	20 70 61 74 	addp4 -(r0),(r1),-(r4),(r8)
   2bb57:	68 
   2bb58:	00          	halt
   2bb59:	52 50 43 20 	mnegf r0,$0x20 [f-float][r3]
   2bb5d:	73 74       	tstd -(r4)
   2bb5f:	72 75 63    	mnegd -(r5),(r3)
   2bb62:	74 20 69 73 	emodd $0x20 [d-float],(r9),-(r3),$0x20,(r2)
   2bb66:	20 62 
   2bb68:	61 64 00 52 	addd3 (r4),$0x0 [d-float],r2
   2bb6c:	50 43 20 76 	movf $0x20 [f-float][r3],-(r6)
   2bb70:	65 72 73 69 	muld3 -(r2),-(r3),(r9)
   2bb74:	6f 6e 20 77 	acbd (sp),$0x20 [d-float],-(r7),32aec <_sys_siglist+0x6dd4>
   2bb78:	72 6f 
   2bb7a:	6e 67 00    	cvtld (r7),$0x0 [d-float]
   2bb7d:	52 50 43 20 	mnegf r0,$0x20 [f-float][r3]
   2bb81:	70 72 6f    	movd -(r2),(pc)
   2bb84:	67 2e 20 6e 	divd3 $0x2e [d-float],$0x20 [d-float],(sp)
   2bb88:	6f 74 20 61 	acbd -(r4),$0x20 [d-float],(r1),31d04 <_sys_siglist+0x5fec>
   2bb8c:	76 61 
   2bb8e:	69 6c 00    	cvtdw (ap),$0x0
   2bb91:	50 72 6f    	movf -(r2),(pc)
   2bb94:	67 72 61 6d 	divd3 -(r2),(r1),(fp)
   2bb98:	20 76 65 72 	addp4 -(r6),(r5),-(r2),-(r3)
   2bb9c:	73 
   2bb9d:	69 6f 6e    	cvtdw (pc),(sp)
   2bba0:	20 77 72 6f 	addp4 -(r7),-(r2),(pc),(sp)
   2bba4:	6e 
   2bba5:	67 00 42 61 	divd3 $0x0 [d-float],(r1)[r2],(r4)
   2bba9:	64 
   2bbaa:	20 70 72 6f 	addp4 -(r0),-(r2),(pc),(r3)
   2bbae:	63 
   2bbaf:	65 64 75 72 	muld3 (r4),-(r5),-(r2)
   2bbb3:	65 20 66 6f 	muld3 $0x20 [d-float],(r6),(pc)
   2bbb7:	72 20 70    	mnegd $0x20 [d-float],-(r0)
   2bbba:	72 6f 67    	mnegd (pc),(r7)
   2bbbd:	72 61 6d    	mnegd (r1),(fp)
   2bbc0:	00          	halt
   2bbc1:	4e 6f 20    	cvtlf (pc),$0x20 [f-float]
   2bbc4:	6c 6f 63    	cvtbd (pc),(r3)
   2bbc7:	6b 73 20    	cvtrdl -(r3),$0x20
   2bbca:	61 76 61 69 	addd3 -(r6),(r1),(r9)
   2bbce:	6c 61 62    	cvtbd (r1),(r2)
   2bbd1:	6c 65 00    	cvtbd (r5),$0x0 [d-float]
   2bbd4:	46 75 6e    	divf2 -(r5),(sp)
   2bbd7:	63 74 69 6f 	subd3 -(r4),(r9),(pc)
   2bbdb:	6e 20 6e    	cvtld $0x20,(sp)
   2bbde:	6f 74 20 69 	acbd -(r4),$0x20 [d-float],(r9),32c51 <_sys_siglist+0x6f39>
   2bbe2:	6d 70 
   2bbe4:	6c 65 6d    	cvtbd (r5),(fp)
   2bbe7:	65 6e 74 65 	muld3 (sp),-(r4),(r5)
   2bbeb:	64 00 49 6e 	muld2 $0x0 [d-float],(sp)[r9]
   2bbef:	61 70 70 72 	addd3 -(r0),-(r0),-(r2)
   2bbf3:	6f 70 72 69 	acbd -(r0),-(r2),(r9),3305a <_sys_siglist+0x7342>
   2bbf7:	61 74 
   2bbf9:	65 20 66 69 	muld3 $0x20 [d-float],(r6),(r9)
   2bbfd:	6c 65 20    	cvtbd (r5),$0x20 [d-float]
   2bc00:	74 79 70 65 	emodd -(r9),-(r0),(r5),$0x20,(pc)
   2bc04:	20 6f 
   2bc06:	72 20 66    	mnegd $0x20 [d-float],(r6)
   2bc09:	6f 72 6d 61 	acbd -(r2),(fp),(r1),2bc83 <_sys_errlist+0x913>
   2bc0d:	74 00 
   2bc0f:	41 75 74 68 	addf3 -(r5),-(r4),(r8)
   2bc13:	65 6e 74 69 	muld3 (sp),-(r4),(r9)
   2bc17:	63 61 74 69 	subd3 (r1),-(r4),(r9)
   2bc1b:	6f 6e 20 65 	acbd (sp),$0x20 [d-float],(r5),32e93 <_sys_siglist+0x717b>
   2bc1f:	72 72 
   2bc21:	6f 72 00 4e 	acbd -(r2),$0x0 [d-float],(r5)[sp],3208d <_sys_siglist+0x6375>
   2bc25:	65 65 64 
   2bc28:	20 61 75 74 	addp4 (r1),-(r5),-(r4),(r8)
   2bc2c:	68 
   2bc2d:	65 6e 74 69 	muld3 (sp),-(r4),(r9)
   2bc31:	63 61 74 6f 	subd3 (r1),-(r4),(pc)
   2bc35:	72 00 49 50 	mnegd $0x0 [d-float],r0[r9]
   2bc39:	73 65       	tstd (r5)
   2bc3b:	63 20 70 72 	subd3 $0x20 [d-float],-(r0),-(r2)
   2bc3f:	6f 63 65 73 	acbd (r3),(r5),-(r3),325b8 <_sys_siglist+0x68a0>
   2bc43:	73 69 
   2bc45:	6e 67 20    	cvtld (r7),$0x20 [d-float]
   2bc48:	66 61 69    	divd2 (r1),(r9)
   2bc4b:	6c 75 72    	cvtbd -(r5),-(r2)
   2bc4e:	65 00 41 74 	muld3 $0x0 [d-float],-(r4)[r1],-(r4)
   2bc52:	74 
   2bc53:	72 69 62    	mnegd (r9),(r2)
   2bc56:	75 74 65 20 	polyd -(r4),(r5),$0x20
   2bc5a:	6e 6f 74    	cvtld (pc),-(r4)
   2bc5d:	20 66 6f 75 	addp4 (r6),(pc),-(r5),(sp)
   2bc61:	6e 
   2bc62:	64 00 49 6c 	muld2 $0x0 [d-float],(ap)[r9]
   2bc66:	6c 65 67    	cvtbd (r5),(r7)
   2bc69:	61 6c 20 62 	addd3 (ap),$0x20 [d-float],(r2)
   2bc6d:	79 74 65 20 	ashq -(r4),(r5),$0x20
   2bc71:	73 65       	tstd (r5)
   2bc73:	71 75 65    	cmpd -(r5),(r5)
   2bc76:	6e 63 65    	cvtld (r3),(r5)
   2bc79:	00          	halt
   2bc7a:	4e 6f 20    	cvtlf (pc),$0x20 [f-float]
   2bc7d:	6d 65 64    	cvtwd (r5),(r4)
   2bc80:	69 75 6d    	cvtdw -(r5),(fp)
   2bc83:	20 66 6f 75 	addp4 (r6),(pc),-(r5),(sp)
   2bc87:	6e 
   2bc88:	64 00 57    	muld2 $0x0 [d-float],r7
   2bc8b:	72 6f 6e    	mnegd (pc),(sp)
   2bc8e:	67 20 6d 65 	divd3 $0x20 [d-float],(fp),(r5)
   2bc92:	64 69 75    	muld2 (r9),-(r5)
   2bc95:	6d 20 74    	cvtwd $0x20,-(r4)
   2bc98:	79 70 65 00 	ashq -(r0),(r5),$0x0
   2bc9c:	56 61 6c    	cvtfd (r1),(ap)
   2bc9f:	75 65 20 74 	polyd (r5),$0x20,-(r4)
   2bca3:	6f 6f 20 6c 	acbd (pc),$0x20 [d-float],(ap),32f0a <_sys_siglist+0x71f2>
   2bca7:	61 72 
   2bca9:	67 65 20 74 	divd3 (r5),$0x20 [d-float],-(r4)
   2bcad:	6f 20 62 65 	acbd $0x20 [d-float],(r2),(r5),32fd3 <_sys_siglist+0x72bb>
   2bcb1:	20 73 
   2bcb3:	74 6f 72 65 	emodd (pc),-(r2),(r5),(r4),$0x20 [d-float]
   2bcb7:	64 20 
   2bcb9:	69 6e 20    	cvtdw (sp),$0x20
   2bcbc:	64 61 74    	muld2 (r1),-(r4)
   2bcbf:	61 20 74 79 	addd3 $0x20 [d-float],-(r4),-(r9)
   2bcc3:	70 65 00    	movd (r5),$0x0 [d-float]
   2bcc6:	4f 70 65 72 	acbf -(r0),(r5),-(r2),3312d <_sys_siglist+0x7415>
   2bcca:	61 74 
   2bccc:	69 6f 6e    	cvtdw (pc),(sp)
   2bccf:	20 63 61 6e 	addp4 (r3),(r1),(sp),(r3)
   2bcd3:	63 
   2bcd4:	65 6c 65 64 	muld3 (ap),(r5),(r4)
   2bcd8:	00          	halt
   2bcd9:	49 64 65    	cvtfw (r4),(r5)
   2bcdc:	6e 74 69    	cvtld -(r4),(r9)
   2bcdf:	66 69 65    	divd2 (r9),(r5)
   2bce2:	72 20 72    	mnegd $0x20 [d-float],-(r2)
   2bce5:	65 6d 6f 76 	muld3 (fp),(pc),-(r6)
   2bce9:	65 64 00 4e 	muld3 (r4),$0x0 [d-float],(pc)[sp]
   2bced:	6f 
   2bcee:	20 6d 65 73 	addp4 (fp),(r5),-(r3),-(r3)
   2bcf2:	73 
   2bcf3:	61 67 65 20 	addd3 (r7),(r5),$0x20 [d-float]
   2bcf7:	6f 66 20 64 	acbd (r6),$0x20 [d-float],(r4),33062 <_sys_siglist+0x734a>
   2bcfb:	65 73 
   2bcfd:	69 72 65    	cvtdw -(r2),(r5)
   2bd00:	64 20 74    	muld2 $0x20 [d-float],-(r4)
   2bd03:	79 70 65 00 	ashq -(r0),(r5),$0x0
   2bd07:	4e 6f 74    	cvtlf (pc),-(r4)
   2bd0a:	20 73 75 70 	addp4 -(r3),-(r5),-(r0),-(r0)
   2bd0e:	70 
   2bd0f:	6f 72 74 65 	acbd -(r2),-(r4),(r5),2bd79 <_sys_siglist+0x61>
   2bd13:	64 00 
   2bd15:	00          	halt
	...

0002bd18 <_sys_siglist>:
   2bd18:	9c bd 02 00 	rotl *0x2(fp),$0x0,0xffffffbd(r5)
   2bd1c:	a5 bd 
   2bd1e:	02          	rei
   2bd1f:	00          	halt
   2bd20:	ac bd 02 00 	xorw2 *0x2(fp),$0x0
   2bd24:	b6 bd 02    	incw *0x2(fp)
   2bd27:	00          	halt
   2bd28:	bb bd 02    	pushr *0x2(fp)
   2bd2b:	00          	halt
   2bd2c:	cf bd 02 00 	casel *0x2(fp),$0x0,*0x2bd(sp)
   2bd30:	de bd 02 
   2bd33:	00          	halt
   2bd34:	e9 bd 02 00 	blbc *0x2(fp),2bd38 <_sys_siglist+0x20>
   2bd38:	f2 bd 02 00 	aoblss *0x2(fp),$0x0,2bd48 <_sys_siglist+0x30>
   2bd3c:	0b 
   2bd3d:	be 02       	chms $0x2
   2bd3f:	00          	halt
   2bd40:	12 be       	bneq 2bd00 <_sys_errlist+0x990>
   2bd42:	02          	rei
   2bd43:	00          	halt
   2bd44:	1c be       	bvc 2bd04 <_sys_errlist+0x994>
   2bd46:	02          	rei
   2bd47:	00          	halt
   2bd48:	2f be 02 00 	movtuc *0x2(sp),$0x0,(r0),*0x2(r7),$0x0,$0x3f
   2bd4c:	60 b7 02 00 
   2bd50:	3f 
   2bd51:	be 02       	chms $0x2
   2bd53:	00          	halt
   2bd54:	4b be 02 00 	cvtrfl *0x2(sp),$0x0
   2bd58:	56 be 02 00 	cvtfd *0x2(sp),$0x0 [d-float]
   2bd5c:	6b be 02 00 	cvtrdl *0x2(sp),$0x0
   2bd60:	7e be 02 00 	movaq *0x2(sp),$0x0
   2bd64:	88 be 02 00 	bisb2 *0x2(sp),$0x0
   2bd68:	92 be 02 00 	mcomb *0x2(sp),$0x0
   2bd6c:	9f be 02    	pushab *0x2(sp)
   2bd6f:	00          	halt
   2bd70:	b3 be 02 00 	bitw *0x2(sp),$0x0
   2bd74:	c8 be 02 00 	bisl2 *0x2(sp),$0x0
   2bd78:	d5 be 02    	tstl *0x2(sp)
   2bd7b:	00          	halt
   2bd7c:	ec be 02 00 	cmpv *0x2(sp),$0x0,$0x4,*2bd85 <_sys_siglist+0x6d>
   2bd80:	04 bf 02 
   2bd83:	00          	halt
   2bd84:	1a bf       	bgtru 2bd45 <_sys_siglist+0x2d>
   2bd86:	02          	rei
   2bd87:	00          	halt
   2bd88:	32 bf 02 00 	cvtwl *2bd8d <_sys_siglist+0x75>,$0x0
   2bd8c:	46 bf 02 00 	divf2 *2bd91 <_sys_siglist+0x79>,$0x0 [f-float]
   2bd90:	5a bf       	.word 0x5abf
   2bd92:	02          	rei
   2bd93:	00          	halt
   2bd94:	70 bf 02 00 	movd *2bd99 <_sys_siglist+0x81>,$0x0 [d-float]
   2bd98:	86 bf 02 00 	divb2 *2bd9d <_sys_siglist+0x85>,$0x0
   2bd9c:	53 69       	tstf (r9)
   2bd9e:	67 6e 61 6c 	divd3 (sp),(r1),(ap)
   2bda2:	20 30 00 48 	addp4 $0x30,$0x0,(r1)[r8],(sp)
   2bda6:	61 6e 
   2bda8:	67 75 70 00 	divd3 -(r5),-(r0),$0x0 [d-float]
   2bdac:	49 6e 74    	cvtfw (sp),-(r4)
   2bdaf:	65 72 72 75 	muld3 -(r2),-(r2),-(r5)
   2bdb3:	70 74 00    	movd -(r4),$0x0 [d-float]
   2bdb6:	51 75 69    	cmpf -(r5),(r9)
   2bdb9:	74 00 49 6c 	emodd $0x0 [d-float],(ap)[r9],(ap),(r5),(r7)
   2bdbd:	6c 65 67 
   2bdc0:	61 6c 20 69 	addd3 (ap),$0x20 [d-float],(r9)
   2bdc4:	6e 73 74    	cvtld -(r3),-(r4)
   2bdc7:	72 75 63    	mnegd -(r5),(r3)
   2bdca:	74 69 6f 6e 	emodd (r9),(pc),(sp),$0x0,r4
   2bdce:	00 54 
   2bdd0:	72 61 63    	mnegd (r1),(r3)
   2bdd3:	65 2f 42 50 	muld3 $0x2f [d-float],r0[r2],r4
   2bdd7:	54 
   2bdd8:	20 74 72 61 	addp4 -(r4),-(r2),(r1),-(r0)
   2bddc:	70 
   2bddd:	00          	halt
   2bdde:	41 62 6f 72 	addf3 (r2),(pc),-(r2)
   2bde2:	74 20 74 72 	emodd $0x20 [d-float],-(r4),-(r2),(r1),-(r0)
   2bde6:	61 70 
   2bde8:	00          	halt
   2bde9:	45 4d 54 20 	mulf3 r4[fp],$0x20 [f-float],-(r4)
   2bded:	74 
   2bdee:	72 61 70    	mnegd (r1),-(r0)
   2bdf1:	00          	halt
   2bdf2:	46 6c 6f    	divf2 (ap),(pc)
   2bdf5:	61 74 69 6e 	addd3 -(r4),(r9),(sp)
   2bdf9:	67 20 70 6f 	divd3 $0x20 [d-float],-(r0),(pc)
   2bdfd:	69 6e 74    	cvtdw (sp),-(r4)
   2be00:	20 65 78 63 	addp4 (r5),-(r8),(r3),(r5)
   2be04:	65 
   2be05:	70 74 69    	movd -(r4),(r9)
   2be08:	6f 6e 00 4b 	acbd (sp),$0x0 [d-float],(r9)[r11],32a7b <_sys_siglist+0x6d63>
   2be0c:	69 6c 6c 
   2be0f:	65 64 00 42 	muld3 (r4),$0x0 [d-float],-(r5)[r2]
   2be13:	75 
   2be14:	73 20       	tstd $0x20 [d-float]
   2be16:	65 72 72 6f 	muld3 -(r2),-(r2),(pc)
   2be1a:	72 00 53    	mnegd $0x0 [d-float],r3
   2be1d:	65 67 6d 65 	muld3 (r7),(fp),(r5)
   2be21:	6e 74 61    	cvtld -(r4),(r1)
   2be24:	74 69 6f 6e 	emodd (r9),(pc),(sp),$0x20,(r6)
   2be28:	20 66 
   2be2a:	61 75 6c 74 	addd3 -(r5),(ap),-(r4)
   2be2e:	00          	halt
   2be2f:	42 61 64    	subf2 (r1),(r4)
   2be32:	20 73 79 73 	addp4 -(r3),-(r9),-(r3),-(r4)
   2be36:	74 
   2be37:	65 6d 20 63 	muld3 (fp),$0x20 [d-float],(r3)
   2be3b:	61 6c 6c 00 	addd3 (ap),(ap),$0x0 [d-float]
   2be3f:	41 6c 61 72 	addf3 (ap),(r1),-(r2)
   2be43:	6d 20 63    	cvtwd $0x20,(r3)
   2be46:	6c 6f 63    	cvtbd (pc),(r3)
   2be49:	6b 00 54    	cvtrdl $0x0 [d-float],r4
   2be4c:	65 72 6d 69 	muld3 -(r2),(fp),(r9)
   2be50:	6e 61 74    	cvtld (r1),-(r4)
   2be53:	65 64 00 55 	muld3 (r4),$0x0 [d-float],r5
   2be57:	72 67 65    	mnegd (r7),(r5)
   2be5a:	6e 74 20    	cvtld -(r4),$0x20 [d-float]
   2be5d:	49 2f 4f 20 	cvtfw $0x2f [f-float],$0x20[pc]
   2be61:	63 6f 6e 64 	subd3 (pc),(sp),(r4)
   2be65:	69 74 69    	cvtdw -(r4),(r9)
   2be68:	6f 6e 00 53 	acbd (sp),$0x0 [d-float],r3,331e3 <_sys_siglist+0x74cb>
   2be6c:	75 73 
   2be6e:	70 65 6e    	movd (r5),(sp)
   2be71:	64 65 64    	muld2 (r5),(r4)
   2be74:	20 28 73 69 	addp4 $0x28,-(r3),(r9),(r7)
   2be78:	67 
   2be79:	6e 61 6c    	cvtld (r1),(ap)
   2be7c:	29 00 53 75 	cmpc3 $0x0,r3,-(r5)
   2be80:	73 70       	tstd -(r0)
   2be82:	65 6e 64 65 	muld3 (sp),(r4),(r5)
   2be86:	64 00 43 6f 	muld2 $0x0 [d-float],(pc)[r3]
   2be8a:	6e 74 69    	cvtld -(r4),(r9)
   2be8d:	6e 75 65    	cvtld -(r5),(r5)
   2be90:	64 00 43 68 	muld2 $0x0 [d-float],(r8)[r3]
   2be94:	69 6c 64    	cvtdw (ap),(r4)
   2be97:	20 65 78 69 	addp4 (r5),-(r8),(r9),-(r4)
   2be9b:	74 
   2be9c:	65 64 00 53 	muld3 (r4),$0x0 [d-float],r3
   2bea0:	74 6f 70 70 	emodd (pc),-(r0),-(r0),(r5),(r4)
   2bea4:	65 64 
   2bea6:	20 28 74 74 	addp4 $0x28,-(r4),-(r4),-(r9)
   2beaa:	79 
   2beab:	20 69 6e 70 	addp4 (r9),(sp),-(r0),-(r5)
   2beaf:	75 
   2beb0:	74 29 00 53 	emodd $0x29 [d-float],$0x0,r3,-(r4),(pc)
   2beb4:	74 6f 
   2beb6:	70 70 65    	movd -(r0),(r5)
   2beb9:	64 20 28    	muld2 $0x20 [d-float],$0x28 [d-float]
   2bebc:	74 74 79 20 	emodd -(r4),-(r9),$0x20 [d-float],(pc),-(r5)
   2bec0:	6f 75 
   2bec2:	74 70 75 74 	emodd -(r0),-(r5),-(r4),$0x29,$0x0 [d-float]
   2bec6:	29 00 
   2bec8:	49 2f 4f 20 	cvtfw $0x2f [f-float],$0x20[pc]
   2becc:	70 6f 73    	movd (pc),-(r3)
   2becf:	73 69       	tstd (r9)
   2bed1:	62 6c 65    	subd2 (ap),(r5)
   2bed4:	00          	halt
   2bed5:	43 70 75 74 	subf3 -(r0),-(r5),-(r4)
   2bed9:	69 6d 65    	cvtdw (fp),(r5)
   2bedc:	20 6c 69 6d 	addp4 (ap),(r9),(fp),(r9)
   2bee0:	69 
   2bee1:	74 20 65 78 	emodd $0x20 [d-float],(r5),-(r8),(r3),(r5)
   2bee5:	63 65 
   2bee7:	65 64 65 64 	muld3 (r4),(r5),(r4)
   2beeb:	00          	halt
   2beec:	46 69 6c    	divf2 (r9),(ap)
   2beef:	65 73 69 7a 	muld3 -(r3),(r9),-(r10)
   2bef3:	65 20 6c 69 	muld3 $0x20 [d-float],(ap),(r9)
   2bef7:	6d 69 74    	cvtwd (r9),-(r4)
   2befa:	20 65 78 63 	addp4 (r5),-(r8),(r3),(r5)
   2befe:	65 
   2beff:	65 64 65 64 	muld3 (r4),(r5),(r4)
   2bf03:	00          	halt
   2bf04:	56 69 72    	cvtfd (r9),-(r2)
   2bf07:	74 75 61 6c 	emodd -(r5),(r1),(ap),$0x20,-(r4)
   2bf0b:	20 74 
   2bf0d:	69 6d 65    	cvtdw (fp),(r5)
   2bf10:	72 20 65    	mnegd $0x20 [d-float],(r5)
   2bf13:	78 70 69 72 	ashl -(r0),(r9),-(r2)
   2bf17:	65 64 00 50 	muld3 (r4),$0x0 [d-float],r0
   2bf1b:	72 6f 66    	mnegd (pc),(r6)
   2bf1e:	69 6c 69    	cvtdw (ap),(r9)
   2bf21:	6e 67 20    	cvtld (r7),$0x20 [d-float]
   2bf24:	74 69 6d 65 	emodd (r9),(fp),(r5),-(r2),$0x20 [d-float]
   2bf28:	72 20 
   2bf2a:	65 78 70 69 	muld3 -(r8),-(r0),(r9)
   2bf2e:	72 65 64    	mnegd (r5),(r4)
   2bf31:	00          	halt
   2bf32:	57 69       	.word 0x5769
   2bf34:	6e 64 6f    	cvtld (r4),(pc)
   2bf37:	77 20       	.word 0x7720
   2bf39:	73 69       	tstd (r9)
   2bf3b:	7a 65 20 63 	emul (r5),$0x20,(r3),(r8)
   2bf3f:	68 
   2bf40:	61 6e 67 65 	addd3 (sp),(r7),(r5)
   2bf44:	73 00       	tstd $0x0 [d-float]
   2bf46:	49 6e 66    	cvtfw (sp),(r6)
   2bf49:	6f 72 6d 61 	acbd -(r2),(fp),(r1),328c3 <_sys_siglist+0x6bab>
   2bf4d:	74 69 
   2bf4f:	6f 6e 20 72 	acbd (sp),$0x20 [d-float],-(r2),330ba <_sys_siglist+0x73a2>
   2bf53:	65 71 
   2bf55:	75 65 73 74 	polyd (r5),-(r3),-(r4)
   2bf59:	00          	halt
   2bf5a:	55 73 65 72 	polyf -(r3),(r5),-(r2)
   2bf5e:	20 64 65 66 	addp4 (r4),(r5),(r6),(r9)
   2bf62:	69 
   2bf63:	6e 65 64    	cvtld (r5),(r4)
   2bf66:	20 73 69 67 	addp4 -(r3),(r9),(r7),(sp)
   2bf6a:	6e 
   2bf6b:	61 6c 20 31 	addd3 (ap),$0x20 [d-float],$0x31 [d-float]
   2bf6f:	00          	halt
   2bf70:	55 73 65 72 	polyf -(r3),(r5),-(r2)
   2bf74:	20 64 65 66 	addp4 (r4),(r5),(r6),(r9)
   2bf78:	69 
   2bf79:	6e 65 64    	cvtld (r5),(r4)
   2bf7c:	20 73 69 67 	addp4 -(r3),(r9),(r7),(sp)
   2bf80:	6e 
   2bf81:	61 6c 20 32 	addd3 (ap),$0x20 [d-float],$0x32 [d-float]
   2bf85:	00          	halt
   2bf86:	54 68 72 65 	emodf (r8),-(r2),(r5),(r1),(r4)
   2bf8a:	61 64 
   2bf8c:	addp4 r3[r1],r4,$0x0,Address 0x0002bf91 is out of bounds.

Disassembly of section .eh_frame:

0002bf94 <.eh_frame>:
   2bf94:	00          	halt
   2bf95:	00          	halt
	...
Disassembly of section .openbsd.randomdata:

0003bf98 <__guard_local>:
   3bf98:	00          	halt
   3bf99:	00          	halt
	...
Disassembly of section .jcr:

0003bf9c <.jcr>:
   3bf9c:	00          	halt
   3bf9d:	00          	halt
	...
Disassembly of section .ctors:

0004bfa0 <.ctors>:
   4bfa0:	ff ff       	.word 0xffff
   4bfa2:	ff ff       	.word 0xffff
   4bfa4:	00          	halt
   4bfa5:	00          	halt
	...
Disassembly of section .dtors:

0004bfa8 <.dtors>:
   4bfa8:	ff ff       	.word 0xffff
   4bfaa:	ff ff       	.word 0xffff
   4bfac:	00          	halt
   4bfad:	00          	halt
	...
Disassembly of section .data:

0005bfb0 <__data_start>:
   5bfb0:	20 b0 02 00 	addp4 *0x2(r0),$0x0,$0x0,$0x0
   5bfb4:	00 00 

0005bfb4 <__dso_handle>:
	...

0005bfc0 <uglue>:
   5bfc0:	00          	halt
   5bfc1:	00          	halt
   5bfc2:	00          	halt
   5bfc3:	00          	halt
   5bfc4:	11 00       	brb 5bfc6 <uglue+0x6>
   5bfc6:	00          	halt
   5bfc7:	00          	halt
   5bfc8:	7c d0 05 00 	clrd *0x5(r0)

0005bfcc <lastglue>:
   5bfcc:	c0 bf 05 00 	addl2 *5bfd4 <__sF+0x4>,$0x0

0005bfd0 <__sF>:
	...
   5bfdc:	04          	ret
	...
   5bfe9:	00          	halt
   5bfea:	00          	halt
   5bfeb:	00          	halt
   5bfec:	d0 bf 05 00 	movl *5bff4 <__sF+0x24>,$0x0
   5bff0:	0c 58 01 00 	prober r8,$0x1,$0x0
   5bff4:	5e 57 01    	remqhi r7,$0x1
   5bff7:	00          	halt
   5bff8:	cc 57 01    	xorl2 r7,$0x1
   5bffb:	00          	halt
   5bffc:	96 57       	incb r7
   5bffe:	01          	nop
   5bfff:	00          	halt
   5c000:	18 21       	bgeq 5c023 <__sF+0x53>
   5c002:	06          	ldpctx
	...
   5c033:	00          	halt
   5c034:	08 00 01 00 	cvtps $0x0,$0x1,$0x0,$0x0
   5c038:	00 
	...
   5c041:	00          	halt
   5c042:	00          	halt
   5c043:	00          	halt
   5c044:	28 c0 05 00 	movc3 0x5(r0),$0xc,r8
   5c048:	0c 58 
   5c04a:	01          	nop
   5c04b:	00          	halt
   5c04c:	5e 57 01    	remqhi r7,$0x1
   5c04f:	00          	halt
   5c050:	cc 57 01    	xorl2 r7,$0x1
   5c053:	00          	halt
   5c054:	96 57       	incb r7
   5c056:	01          	nop
   5c057:	00          	halt
   5c058:	2c 22 06 00 	movc5 $0x22,$0x6,$0x0,$0x0,$0x0
   5c05c:	00 00 
	...
   5c08a:	00          	halt
   5c08b:	00          	halt
   5c08c:	0a 00 02 00 	index $0x0,$0x2,$0x0,$0x0,$0x0,$0x0
   5c090:	00 00 00 
	...
   5c09b:	00          	halt
   5c09c:	80 c0 05 00 	addb2 0x5(r0),$0xc
   5c0a0:	0c 
   5c0a1:	58 01 00    	adawi $0x1,$0x0
   5c0a4:	5e 57 01    	remqhi r7,$0x1
   5c0a7:	00          	halt
   5c0a8:	cc 57 01    	xorl2 r7,$0x1
   5c0ab:	00          	halt
   5c0ac:	96 57       	incb r7
   5c0ae:	01          	nop
   5c0af:	00          	halt
   5c0b0:	40 23 06    	addf2 $0x23 [f-float],$0x6 [f-float]
	...

0005c0d8 <__sglue>:
   5c0d8:	c0 bf 05 00 	addl2 *5c0e0 <__sglue+0x8>,$0x0
   5c0dc:	03          	bpt
   5c0dd:	00          	halt
   5c0de:	00          	halt
   5c0df:	00          	halt
   5c0e0:	d0 bf 05 00 	movl *5c0e8 <_atfork_list>,$0x0

0005c0e4 <__isthreaded>:
   5c0e4:	00          	halt
   5c0e5:	00          	halt
	...

0005c0e8 <_atfork_list>:
   5c0e8:	00          	halt
   5c0e9:	00          	halt
   5c0ea:	00          	halt
   5c0eb:	00          	halt
   5c0ec:	e8 c0 05 00 	blbs 0x5(r0),5c15d <_DefaultRuneLocale+0x25>
   5c0f0:	6c 

0005c0f0 <_ctype_>:
   5c0f0:	6c aa 02 00 	cvtbd 0x2(r10),$0x0 [d-float]

0005c0f4 <blanks.0>:
   5c0f4:	20 20 20 20 	addp4 $0x20,$0x20,$0x20,$0x20
   5c0f8:	20 
   5c0f9:	20 20 20 20 	addp4 $0x20,$0x20,$0x20,$0x20
   5c0fd:	20 
   5c0fe:	20 20 20 20 	addp4 $0x20,$0x20,$0x20,$0x20
   5c102:	20 
   5c103:	20 30 30 30 	addp4 $0x30,$0x30,$0x30,$0x30
   5c107:	30 

0005c104 <zeroes.1>:
   5c104:	30 30 30    	bsbw 5f137 <private_mem+0x85b>
   5c107:	30 30 30    	bsbw 5f13a <private_mem+0x85e>
   5c10a:	30 30 30    	bsbw 5f13d <private_mem+0x861>
   5c10d:	30 30 30    	bsbw 5f140 <private_mem+0x864>
   5c110:	30 30 30    	bsbw 5f143 <private_mem+0x867>
   5c113:	30 dc e8    	bsbw 5a9f2 <__got_end+0xea42>

0005c114 <pmem_next>:
   5c114:	dc e8 05 00 	movpsl 0x50005(r8)
   5c118:	05 00 

0005c118 <p05.0>:
   5c118:	05          	rsb
   5c119:	00          	halt
   5c11a:	00          	halt
   5c11b:	00          	halt
   5c11c:	19 00       	blss 5c11e <p05.0+0x6>
   5c11e:	00          	halt
   5c11f:	00          	halt
   5c120:	7d 00 00    	movq $0x0,$0x0
	...

0005c124 <__dtoa_locks>:
	...

0005c12c <__mb_cur_max>:
   5c12c:	01          	nop
   5c12d:	00          	halt
	...

0005c130 <__mb_len_max_runtime>:
   5c130:	04          	ret
   5c131:	00          	halt
	...

0005c134 <zero.0>:
   5c134:	00          	halt
   5c135:	00          	halt
	...

0005c138 <_DefaultRuneLocale>:
   5c138:	52 75 6e    	mnegf -(r5),(sp)
   5c13b:	65 43 54 31 	muld3 r4[r3],$0x31 [d-float],$0x30 [d-float]
   5c13f:	30 
   5c140:	4e 4f 4e 45 	cvtlf $0x0[r5][sp][pc],$0x0 [f-float]
   5c144:	00 00 
	...
   5c15e:	00          	halt
   5c15f:	00          	halt
   5c160:	fd ff       	.word 0xfdff
   5c162:	ff ff       	.word 0xffff
   5c164:	00          	halt
   5c165:	02          	rei
   5c166:	00          	halt
   5c167:	00          	halt
   5c168:	00          	halt
   5c169:	02          	rei
   5c16a:	00          	halt
   5c16b:	00          	halt
   5c16c:	00          	halt
   5c16d:	02          	rei
   5c16e:	00          	halt
   5c16f:	00          	halt
   5c170:	00          	halt
   5c171:	02          	rei
   5c172:	00          	halt
   5c173:	00          	halt
   5c174:	00          	halt
   5c175:	02          	rei
   5c176:	00          	halt
   5c177:	00          	halt
   5c178:	00          	halt
   5c179:	02          	rei
   5c17a:	00          	halt
   5c17b:	00          	halt
   5c17c:	00          	halt
   5c17d:	02          	rei
   5c17e:	00          	halt
   5c17f:	00          	halt
   5c180:	00          	halt
   5c181:	02          	rei
   5c182:	00          	halt
   5c183:	00          	halt
   5c184:	00          	halt
   5c185:	02          	rei
   5c186:	00          	halt
   5c187:	00          	halt
   5c188:	00          	halt
   5c189:	42 02 00    	subf2 $0x2 [f-float],$0x0 [f-float]
   5c18c:	00          	halt
   5c18d:	42 00 00    	subf2 $0x0 [f-float],$0x0 [f-float]
   5c190:	00          	halt
   5c191:	42 00 00    	subf2 $0x0 [f-float],$0x0 [f-float]
   5c194:	00          	halt
   5c195:	42 00 00    	subf2 $0x0 [f-float],$0x0 [f-float]
   5c198:	00          	halt
   5c199:	42 00 00    	subf2 $0x0 [f-float],$0x0 [f-float]
   5c19c:	00          	halt
   5c19d:	02          	rei
   5c19e:	00          	halt
   5c19f:	00          	halt
   5c1a0:	00          	halt
   5c1a1:	02          	rei
   5c1a2:	00          	halt
   5c1a3:	00          	halt
   5c1a4:	00          	halt
   5c1a5:	02          	rei
   5c1a6:	00          	halt
   5c1a7:	00          	halt
   5c1a8:	00          	halt
   5c1a9:	02          	rei
   5c1aa:	00          	halt
   5c1ab:	00          	halt
   5c1ac:	00          	halt
   5c1ad:	02          	rei
   5c1ae:	00          	halt
   5c1af:	00          	halt
   5c1b0:	00          	halt
   5c1b1:	02          	rei
   5c1b2:	00          	halt
   5c1b3:	00          	halt
   5c1b4:	00          	halt
   5c1b5:	02          	rei
   5c1b6:	00          	halt
   5c1b7:	00          	halt
   5c1b8:	00          	halt
   5c1b9:	02          	rei
   5c1ba:	00          	halt
   5c1bb:	00          	halt
   5c1bc:	00          	halt
   5c1bd:	02          	rei
   5c1be:	00          	halt
   5c1bf:	00          	halt
   5c1c0:	00          	halt
   5c1c1:	02          	rei
   5c1c2:	00          	halt
   5c1c3:	00          	halt
   5c1c4:	00          	halt
   5c1c5:	02          	rei
   5c1c6:	00          	halt
   5c1c7:	00          	halt
   5c1c8:	00          	halt
   5c1c9:	02          	rei
   5c1ca:	00          	halt
   5c1cb:	00          	halt
   5c1cc:	00          	halt
   5c1cd:	02          	rei
   5c1ce:	00          	halt
   5c1cf:	00          	halt
   5c1d0:	00          	halt
   5c1d1:	02          	rei
   5c1d2:	00          	halt
   5c1d3:	00          	halt
   5c1d4:	00          	halt
   5c1d5:	02          	rei
   5c1d6:	00          	halt
   5c1d7:	00          	halt
   5c1d8:	00          	halt
   5c1d9:	02          	rei
   5c1da:	00          	halt
   5c1db:	00          	halt
   5c1dc:	00          	halt
   5c1dd:	02          	rei
   5c1de:	00          	halt
   5c1df:	00          	halt
   5c1e0:	00          	halt
   5c1e1:	02          	rei
   5c1e2:	00          	halt
   5c1e3:	00          	halt
   5c1e4:	00          	halt
   5c1e5:	40 06 40 00 	addf2 $0x6 [f-float],$0x0 [f-float][r0]
   5c1e9:	28 04 40 00 	movc3 $0x4,$0x0[r0],$0x28
   5c1ed:	28 
   5c1ee:	04          	ret
   5c1ef:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c1f2:	04          	ret
   5c1f3:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c1f6:	04          	ret
   5c1f7:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c1fa:	04          	ret
   5c1fb:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c1fe:	04          	ret
   5c1ff:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c202:	04          	ret
   5c203:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c206:	04          	ret
   5c207:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c20a:	04          	ret
   5c20b:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c20e:	04          	ret
   5c20f:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c212:	04          	ret
   5c213:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c216:	04          	ret
   5c217:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c21a:	04          	ret
   5c21b:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c21e:	04          	ret
   5c21f:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c222:	04          	ret
   5c223:	40 00 0c    	addf2 $0x0 [f-float],$0xc [f-float]
   5c226:	05          	rsb
   5c227:	40 01 0c    	addf2 $0x1 [f-float],$0xc [f-float]
   5c22a:	05          	rsb
   5c22b:	40 02 0c    	addf2 $0x2 [f-float],$0xc [f-float]
   5c22e:	05          	rsb
   5c22f:	40 03 0c    	addf2 $0x3 [f-float],$0xc [f-float]
   5c232:	05          	rsb
   5c233:	40 04 0c    	addf2 $0x4 [f-float],$0xc [f-float]
   5c236:	05          	rsb
   5c237:	40 05 0c    	addf2 $0x5 [f-float],$0xc [f-float]
   5c23a:	05          	rsb
   5c23b:	40 06 0c    	addf2 $0x6 [f-float],$0xc [f-float]
   5c23e:	05          	rsb
   5c23f:	40 07 0c    	addf2 $0x7 [f-float],$0xc [f-float]
   5c242:	05          	rsb
   5c243:	40 08 0c    	addf2 $0x8 [f-float],$0xc [f-float]
   5c246:	05          	rsb
   5c247:	40 09 0c    	addf2 $0x9 [f-float],$0xc [f-float]
   5c24a:	05          	rsb
   5c24b:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c24e:	04          	ret
   5c24f:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c252:	04          	ret
   5c253:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c256:	04          	ret
   5c257:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c25a:	04          	ret
   5c25b:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c25e:	04          	ret
   5c25f:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c262:	04          	ret
   5c263:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c266:	04          	ret
   5c267:	40 0a 89    	addf2 $0xa [f-float],(r9)+
   5c26a:	05          	rsb
   5c26b:	40 0b 89    	addf2 $0xb [f-float],(r9)+
   5c26e:	05          	rsb
   5c26f:	40 0c 89    	addf2 $0xc [f-float],(r9)+
   5c272:	05          	rsb
   5c273:	40 0d 89    	addf2 $0xd [f-float],(r9)+
   5c276:	05          	rsb
   5c277:	40 0e 89    	addf2 $0xe [f-float],(r9)+
   5c27a:	05          	rsb
   5c27b:	40 0f 89    	addf2 $0xf [f-float],(r9)+
   5c27e:	05          	rsb
   5c27f:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c282:	04          	ret
   5c283:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c286:	04          	ret
   5c287:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c28a:	04          	ret
   5c28b:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c28e:	04          	ret
   5c28f:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c292:	04          	ret
   5c293:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c296:	04          	ret
   5c297:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c29a:	04          	ret
   5c29b:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c29e:	04          	ret
   5c29f:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2a2:	04          	ret
   5c2a3:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2a6:	04          	ret
   5c2a7:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2aa:	04          	ret
   5c2ab:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2ae:	04          	ret
   5c2af:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2b2:	04          	ret
   5c2b3:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2b6:	04          	ret
   5c2b7:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2ba:	04          	ret
   5c2bb:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2be:	04          	ret
   5c2bf:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2c2:	04          	ret
   5c2c3:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2c6:	04          	ret
   5c2c7:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2ca:	04          	ret
   5c2cb:	40 00 89    	addf2 $0x0 [f-float],(r9)+
   5c2ce:	04          	ret
   5c2cf:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c2d2:	04          	ret
   5c2d3:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c2d6:	04          	ret
   5c2d7:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c2da:	04          	ret
   5c2db:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c2de:	04          	ret
   5c2df:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c2e2:	04          	ret
   5c2e3:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c2e6:	04          	ret
   5c2e7:	40 0a 19    	addf2 $0xa [f-float],$0x19 [f-float]
   5c2ea:	05          	rsb
   5c2eb:	40 0b 19    	addf2 $0xb [f-float],$0x19 [f-float]
   5c2ee:	05          	rsb
   5c2ef:	40 0c 19    	addf2 $0xc [f-float],$0x19 [f-float]
   5c2f2:	05          	rsb
   5c2f3:	40 0d 19    	addf2 $0xd [f-float],$0x19 [f-float]
   5c2f6:	05          	rsb
   5c2f7:	40 0e 19    	addf2 $0xe [f-float],$0x19 [f-float]
   5c2fa:	05          	rsb
   5c2fb:	40 0f 19    	addf2 $0xf [f-float],$0x19 [f-float]
   5c2fe:	05          	rsb
   5c2ff:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c302:	04          	ret
   5c303:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c306:	04          	ret
   5c307:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c30a:	04          	ret
   5c30b:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c30e:	04          	ret
   5c30f:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c312:	04          	ret
   5c313:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c316:	04          	ret
   5c317:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c31a:	04          	ret
   5c31b:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c31e:	04          	ret
   5c31f:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c322:	04          	ret
   5c323:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c326:	04          	ret
   5c327:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c32a:	04          	ret
   5c32b:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c32e:	04          	ret
   5c32f:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c332:	04          	ret
   5c333:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c336:	04          	ret
   5c337:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c33a:	04          	ret
   5c33b:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c33e:	04          	ret
   5c33f:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c342:	04          	ret
   5c343:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c346:	04          	ret
   5c347:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c34a:	04          	ret
   5c34b:	40 00 19    	addf2 $0x0 [f-float],$0x19 [f-float]
   5c34e:	04          	ret
   5c34f:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c352:	04          	ret
   5c353:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c356:	04          	ret
   5c357:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c35a:	04          	ret
   5c35b:	40 00 28    	addf2 $0x0 [f-float],$0x28 [f-float]
   5c35e:	04          	ret
   5c35f:	40 00 02    	addf2 $0x0 [f-float],$0x2 [f-float]
	...
   5c566:	00          	halt
   5c567:	00          	halt
   5c568:	01          	nop
   5c569:	00          	halt
   5c56a:	00          	halt
   5c56b:	00          	halt
   5c56c:	02          	rei
   5c56d:	00          	halt
   5c56e:	00          	halt
   5c56f:	00          	halt
   5c570:	03          	bpt
   5c571:	00          	halt
   5c572:	00          	halt
   5c573:	00          	halt
   5c574:	04          	ret
   5c575:	00          	halt
   5c576:	00          	halt
   5c577:	00          	halt
   5c578:	05          	rsb
   5c579:	00          	halt
   5c57a:	00          	halt
   5c57b:	00          	halt
   5c57c:	06          	ldpctx
   5c57d:	00          	halt
   5c57e:	00          	halt
   5c57f:	00          	halt
   5c580:	07          	svpctx
   5c581:	00          	halt
   5c582:	00          	halt
   5c583:	00          	halt
   5c584:	08 00 00 00 	cvtps $0x0,$0x0,$0x0,$0x9
   5c588:	09 
   5c589:	00          	halt
   5c58a:	00          	halt
   5c58b:	00          	halt
   5c58c:	0a 00 00 00 	index $0x0,$0x0,$0x0,$0xb,$0x0,$0x0
   5c590:	0b 00 00 
   5c593:	00          	halt
   5c594:	0c 00 00 00 	prober $0x0,$0x0,$0x0
   5c598:	0d 00 00 00 	probew $0x0,$0x0,$0x0
   5c59c:	0e 00 00    	insque $0x0,$0x0
   5c59f:	00          	halt
   5c5a0:	0f 00 00    	remque $0x0,$0x0
   5c5a3:	00          	halt
   5c5a4:	10 00       	bsbb 5c5a6 <_DefaultRuneLocale+0x46e>
   5c5a6:	00          	halt
   5c5a7:	00          	halt
   5c5a8:	11 00       	brb 5c5aa <_DefaultRuneLocale+0x472>
   5c5aa:	00          	halt
   5c5ab:	00          	halt
   5c5ac:	12 00       	bneq 5c5ae <_DefaultRuneLocale+0x476>
   5c5ae:	00          	halt
   5c5af:	00          	halt
   5c5b0:	13 00       	beql 5c5b2 <_DefaultRuneLocale+0x47a>
   5c5b2:	00          	halt
   5c5b3:	00          	halt
   5c5b4:	14 00       	bgtr 5c5b6 <_DefaultRuneLocale+0x47e>
   5c5b6:	00          	halt
   5c5b7:	00          	halt
   5c5b8:	15 00       	bleq 5c5ba <_DefaultRuneLocale+0x482>
   5c5ba:	00          	halt
   5c5bb:	00          	halt
   5c5bc:	16 00       	jsb $0x0
   5c5be:	00          	halt
   5c5bf:	00          	halt
   5c5c0:	17 00       	jmp $0x0
   5c5c2:	00          	halt
   5c5c3:	00          	halt
   5c5c4:	18 00       	bgeq 5c5c6 <_DefaultRuneLocale+0x48e>
   5c5c6:	00          	halt
   5c5c7:	00          	halt
   5c5c8:	19 00       	blss 5c5ca <_DefaultRuneLocale+0x492>
   5c5ca:	00          	halt
   5c5cb:	00          	halt
   5c5cc:	1a 00       	bgtru 5c5ce <_DefaultRuneLocale+0x496>
   5c5ce:	00          	halt
   5c5cf:	00          	halt
   5c5d0:	1b 00       	blequ 5c5d2 <_DefaultRuneLocale+0x49a>
   5c5d2:	00          	halt
   5c5d3:	00          	halt
   5c5d4:	1c 00       	bvc 5c5d6 <_DefaultRuneLocale+0x49e>
   5c5d6:	00          	halt
   5c5d7:	00          	halt
   5c5d8:	1d 00       	bvs 5c5da <_DefaultRuneLocale+0x4a2>
   5c5da:	00          	halt
   5c5db:	00          	halt
   5c5dc:	1e 00       	bcc 5c5de <_DefaultRuneLocale+0x4a6>
   5c5de:	00          	halt
   5c5df:	00          	halt
   5c5e0:	1f 00       	blssu 5c5e2 <_DefaultRuneLocale+0x4aa>
   5c5e2:	00          	halt
   5c5e3:	00          	halt
   5c5e4:	20 00 00 00 	addp4 $0x0,$0x0,$0x0,$0x21
   5c5e8:	21 
   5c5e9:	00          	halt
   5c5ea:	00          	halt
   5c5eb:	00          	halt
   5c5ec:	22 00 00 00 	subp4 $0x0,$0x0,$0x0,$0x23
   5c5f0:	23 
   5c5f1:	00          	halt
   5c5f2:	00          	halt
   5c5f3:	00          	halt
   5c5f4:	24 00 00 00 	cvtpt $0x0,$0x0,$0x0,$0x25,$0x0
   5c5f8:	25 00 
   5c5fa:	00          	halt
   5c5fb:	00          	halt
   5c5fc:	26 00 00 00 	cvttp $0x0,$0x0,$0x0,$0x27,$0x0
   5c600:	27 00 
   5c602:	00          	halt
   5c603:	00          	halt
   5c604:	28 00 00 00 	movc3 $0x0,$0x0,$0x0
   5c608:	29 00 00 00 	cmpc3 $0x0,$0x0,$0x0
   5c60c:	2a 00 00 00 	scanc $0x0,$0x0,$0x0,$0x2b
   5c610:	2b 
   5c611:	00          	halt
   5c612:	00          	halt
   5c613:	00          	halt
   5c614:	2c 00 00 00 	movc5 $0x0,$0x0,$0x0,$0x2d,$0x0
   5c618:	2d 00 
   5c61a:	00          	halt
   5c61b:	00          	halt
   5c61c:	2e 00 00 00 	movtc $0x0,$0x0,$0x0,$0x2f,$0x0,$0x0
   5c620:	2f 00 00 
   5c623:	00          	halt
   5c624:	30 00 00    	bsbw 5c627 <_DefaultRuneLocale+0x4ef>
   5c627:	00          	halt
   5c628:	31 00 00    	brw 5c62b <_DefaultRuneLocale+0x4f3>
   5c62b:	00          	halt
   5c62c:	32 00 00    	cvtwl $0x0,$0x0
   5c62f:	00          	halt
   5c630:	33 00 00    	cvtwb $0x0,$0x0
   5c633:	00          	halt
   5c634:	34 00 00 00 	movp $0x0,$0x0,$0x0
   5c638:	35 00 00 00 	cmpp3 $0x0,$0x0,$0x0
   5c63c:	36 00 00 00 	cvtpl $0x0,$0x0,$0x0
   5c640:	37 00 00 00 	cmpp4 $0x0,$0x0,$0x0,$0x38
   5c644:	38 
   5c645:	00          	halt
   5c646:	00          	halt
   5c647:	00          	halt
   5c648:	39 00 00 00 	matchc $0x0,$0x0,$0x0,$0x3a
   5c64c:	3a 
   5c64d:	00          	halt
   5c64e:	00          	halt
   5c64f:	00          	halt
   5c650:	3b 00 00 00 	skpc $0x0,$0x0,$0x0
   5c654:	3c 00 00    	movzwl $0x0,$0x0
   5c657:	00          	halt
   5c658:	3d 00 00 00 	acbw $0x0,$0x0,$0x0,5c69c <_DefaultRuneLocale+0x564>
   5c65c:	3e 00 
   5c65e:	00          	halt
   5c65f:	00          	halt
   5c660:	3f 00       	pushaw $0x0
   5c662:	00          	halt
   5c663:	00          	halt
   5c664:	40 00 00    	addf2 $0x0 [f-float],$0x0 [f-float]
   5c667:	00          	halt
   5c668:	61 00 00 00 	addd3 $0x0 [d-float],$0x0 [d-float],$0x0 [d-float]
   5c66c:	62 00 00    	subd2 $0x0 [d-float],$0x0 [d-float]
   5c66f:	00          	halt
   5c670:	63 00 00 00 	subd3 $0x0 [d-float],$0x0 [d-float],$0x0 [d-float]
   5c674:	64 00 00    	muld2 $0x0 [d-float],$0x0 [d-float]
   5c677:	00          	halt
   5c678:	65 00 00 00 	muld3 $0x0 [d-float],$0x0 [d-float],$0x0 [d-float]
   5c67c:	66 00 00    	divd2 $0x0 [d-float],$0x0 [d-float]
   5c67f:	00          	halt
   5c680:	67 00 00 00 	divd3 $0x0 [d-float],$0x0 [d-float],$0x0 [d-float]
   5c684:	68 00 00    	cvtdb $0x0 [d-float],$0x0
   5c687:	00          	halt
   5c688:	69 00 00    	cvtdw $0x0 [d-float],$0x0
   5c68b:	00          	halt
   5c68c:	6a 00 00    	cvtdl $0x0 [d-float],$0x0
   5c68f:	00          	halt
   5c690:	6b 00 00    	cvtrdl $0x0 [d-float],$0x0
   5c693:	00          	halt
   5c694:	6c 00 00    	cvtbd $0x0,$0x0 [d-float]
   5c697:	00          	halt
   5c698:	6d 00 00    	cvtwd $0x0,$0x0 [d-float]
   5c69b:	00          	halt
   5c69c:	6e 00 00    	cvtld $0x0,$0x0 [d-float]
   5c69f:	00          	halt
   5c6a0:	6f 00 00 00 	acbd $0x0 [d-float],$0x0 [d-float],$0x0 [d-float],5c716 <_DefaultRuneLocale+0x5de>
   5c6a4:	70 00 
   5c6a6:	00          	halt
   5c6a7:	00          	halt
   5c6a8:	71 00 00    	cmpd $0x0 [d-float],$0x0 [d-float]
   5c6ab:	00          	halt
   5c6ac:	72 00 00    	mnegd $0x0 [d-float],$0x0 [d-float]
   5c6af:	00          	halt
   5c6b0:	73 00       	tstd $0x0 [d-float]
   5c6b2:	00          	halt
   5c6b3:	00          	halt
   5c6b4:	74 00 00 00 	emodd $0x0 [d-float],$0x0,$0x0 [d-float],-(r5),$0x0 [d-float]
   5c6b8:	75 00 
   5c6ba:	00          	halt
   5c6bb:	00          	halt
   5c6bc:	76 00 00    	cvtdf $0x0 [d-float],$0x0 [f-float]
   5c6bf:	00          	halt
   5c6c0:	77 00       	.word 0x7700
   5c6c2:	00          	halt
   5c6c3:	00          	halt
   5c6c4:	78 00 00 00 	ashl $0x0,$0x0,$0x0
   5c6c8:	79 00 00 00 	ashq $0x0,$0x0,$0x0
   5c6cc:	7a 00 00 00 	emul $0x0,$0x0,$0x0,r11
   5c6d0:	5b 
   5c6d1:	00          	halt
   5c6d2:	00          	halt
   5c6d3:	00          	halt
   5c6d4:	5c 00 00    	insqhi $0x0,$0x0
   5c6d7:	00          	halt
   5c6d8:	5d 00 00    	insqti $0x0,$0x0
   5c6db:	00          	halt
   5c6dc:	5e 00 00    	remqhi $0x0,$0x0
   5c6df:	00          	halt
   5c6e0:	5f 00 00    	remqti $0x0,$0x0
   5c6e3:	00          	halt
   5c6e4:	60 00 00    	addd2 $0x0 [d-float],$0x0 [d-float]
   5c6e7:	00          	halt
   5c6e8:	61 00 00 00 	addd3 $0x0 [d-float],$0x0 [d-float],$0x0 [d-float]
   5c6ec:	62 00 00    	subd2 $0x0 [d-float],$0x0 [d-float]
   5c6ef:	00          	halt
   5c6f0:	63 00 00 00 	subd3 $0x0 [d-float],$0x0 [d-float],$0x0 [d-float]
   5c6f4:	64 00 00    	muld2 $0x0 [d-float],$0x0 [d-float]
   5c6f7:	00          	halt
   5c6f8:	65 00 00 00 	muld3 $0x0 [d-float],$0x0 [d-float],$0x0 [d-float]
   5c6fc:	66 00 00    	divd2 $0x0 [d-float],$0x0 [d-float]
   5c6ff:	00          	halt
   5c700:	67 00 00 00 	divd3 $0x0 [d-float],$0x0 [d-float],$0x0 [d-float]
   5c704:	68 00 00    	cvtdb $0x0 [d-float],$0x0
   5c707:	00          	halt
   5c708:	69 00 00    	cvtdw $0x0 [d-float],$0x0
   5c70b:	00          	halt
   5c70c:	6a 00 00    	cvtdl $0x0 [d-float],$0x0
   5c70f:	00          	halt
   5c710:	6b 00 00    	cvtrdl $0x0 [d-float],$0x0
   5c713:	00          	halt
   5c714:	6c 00 00    	cvtbd $0x0,$0x0 [d-float]
   5c717:	00          	halt
   5c718:	6d 00 00    	cvtwd $0x0,$0x0 [d-float]
   5c71b:	00          	halt
   5c71c:	6e 00 00    	cvtld $0x0,$0x0 [d-float]
   5c71f:	00          	halt
   5c720:	6f 00 00 00 	acbd $0x0 [d-float],$0x0 [d-float],$0x0 [d-float],5c796 <_DefaultRuneLocale+0x65e>
   5c724:	70 00 
   5c726:	00          	halt
   5c727:	00          	halt
   5c728:	71 00 00    	cmpd $0x0 [d-float],$0x0 [d-float]
   5c72b:	00          	halt
   5c72c:	72 00 00    	mnegd $0x0 [d-float],$0x0 [d-float]
   5c72f:	00          	halt
   5c730:	73 00       	tstd $0x0 [d-float]
   5c732:	00          	halt
   5c733:	00          	halt
   5c734:	74 00 00 00 	emodd $0x0 [d-float],$0x0,$0x0 [d-float],-(r5),$0x0 [d-float]
   5c738:	75 00 
   5c73a:	00          	halt
   5c73b:	00          	halt
   5c73c:	76 00 00    	cvtdf $0x0 [d-float],$0x0 [f-float]
   5c73f:	00          	halt
   5c740:	77 00       	.word 0x7700
   5c742:	00          	halt
   5c743:	00          	halt
   5c744:	78 00 00 00 	ashl $0x0,$0x0,$0x0
   5c748:	79 00 00 00 	ashq $0x0,$0x0,$0x0
   5c74c:	7a 00 00 00 	emul $0x0,$0x0,$0x0,-(r11)
   5c750:	7b 
   5c751:	00          	halt
   5c752:	00          	halt
   5c753:	00          	halt
   5c754:	7c 00       	clrd $0x0 [d-float]
   5c756:	00          	halt
   5c757:	00          	halt
   5c758:	7d 00 00    	movq $0x0,$0x0
   5c75b:	00          	halt
   5c75c:	7e 00 00    	movaq $0x0,$0x0
   5c75f:	00          	halt
   5c760:	7f 00       	pushaq $0x0
   5c762:	00          	halt
   5c763:	00          	halt
   5c764:	80 00 00    	addb2 $0x0,$0x0
   5c767:	00          	halt
   5c768:	81 00 00 00 	addb3 $0x0,$0x0,$0x0
   5c76c:	82 00 00    	subb2 $0x0,$0x0
   5c76f:	00          	halt
   5c770:	83 00 00 00 	subb3 $0x0,$0x0,$0x0
   5c774:	84 00 00    	mulb2 $0x0,$0x0
   5c777:	00          	halt
   5c778:	85 00 00 00 	mulb3 $0x0,$0x0,$0x0
   5c77c:	86 00 00    	divb2 $0x0,$0x0
   5c77f:	00          	halt
   5c780:	87 00 00 00 	divb3 $0x0,$0x0,$0x0
   5c784:	88 00 00    	bisb2 $0x0,$0x0
   5c787:	00          	halt
   5c788:	89 00 00 00 	bisb3 $0x0,$0x0,$0x0
   5c78c:	8a 00 00    	bicb2 $0x0,$0x0
   5c78f:	00          	halt
   5c790:	8b 00 00 00 	bicb3 $0x0,$0x0,$0x0
   5c794:	8c 00 00    	xorb2 $0x0,$0x0
   5c797:	00          	halt
   5c798:	8d 00 00 00 	xorb3 $0x0,$0x0,$0x0
   5c79c:	8e 00 00    	mnegb $0x0,$0x0
   5c79f:	00          	halt
   5c7a0:	8f 00 00 00 	caseb $0x0,$0x0,$0x0
   5c7a4:	90 00 00    	movb $0x0,$0x0
   5c7a7:	00          	halt
   5c7a8:	91 00 00    	cmpb $0x0,$0x0
   5c7ab:	00          	halt
   5c7ac:	92 00 00    	mcomb $0x0,$0x0
   5c7af:	00          	halt
   5c7b0:	93 00 00    	bitb $0x0,$0x0
   5c7b3:	00          	halt
   5c7b4:	94 00       	clrb $0x0
   5c7b6:	00          	halt
   5c7b7:	00          	halt
   5c7b8:	95 00       	tstb $0x0
   5c7ba:	00          	halt
   5c7bb:	00          	halt
   5c7bc:	96 00       	incb $0x0
   5c7be:	00          	halt
   5c7bf:	00          	halt
   5c7c0:	97 00       	decb $0x0
   5c7c2:	00          	halt
   5c7c3:	00          	halt
   5c7c4:	98 00 00    	cvtbl $0x0,$0x0
   5c7c7:	00          	halt
   5c7c8:	99 00 00    	cvtbw $0x0,$0x0
   5c7cb:	00          	halt
   5c7cc:	9a 00 00    	movzbl $0x0,$0x0
   5c7cf:	00          	halt
   5c7d0:	9b 00 00    	movzbw $0x0,$0x0
   5c7d3:	00          	halt
   5c7d4:	9c 00 00 00 	rotl $0x0,$0x0,$0x0
   5c7d8:	9d 00 00 00 	acbb $0x0,$0x0,$0x0,5c87c <_DefaultRuneLocale+0x744>
   5c7dc:	9e 00 
   5c7de:	00          	halt
   5c7df:	00          	halt
   5c7e0:	9f 00       	pushab $0x0
   5c7e2:	00          	halt
   5c7e3:	00          	halt
   5c7e4:	a0 00 00    	addw2 $0x0,$0x0
   5c7e7:	00          	halt
   5c7e8:	a1 00 00 00 	addw3 $0x0,$0x0,$0x0
   5c7ec:	a2 00 00    	subw2 $0x0,$0x0
   5c7ef:	00          	halt
   5c7f0:	a3 00 00 00 	subw3 $0x0,$0x0,$0x0
   5c7f4:	a4 00 00    	mulw2 $0x0,$0x0
   5c7f7:	00          	halt
   5c7f8:	a5 00 00 00 	mulw3 $0x0,$0x0,$0x0
   5c7fc:	a6 00 00    	divw2 $0x0,$0x0
   5c7ff:	00          	halt
   5c800:	a7 00 00 00 	divw3 $0x0,$0x0,$0x0
   5c804:	a8 00 00    	bisw2 $0x0,$0x0
   5c807:	00          	halt
   5c808:	a9 00 00 00 	bisw3 $0x0,$0x0,$0x0
   5c80c:	aa 00 00    	bicw2 $0x0,$0x0
   5c80f:	00          	halt
   5c810:	ab 00 00 00 	bicw3 $0x0,$0x0,$0x0
   5c814:	ac 00 00    	xorw2 $0x0,$0x0
   5c817:	00          	halt
   5c818:	ad 00 00 00 	xorw3 $0x0,$0x0,$0x0
   5c81c:	ae 00 00    	mnegw $0x0,$0x0
   5c81f:	00          	halt
   5c820:	af 00 00 00 	casew $0x0,$0x0,$0x0
   5c824:	b0 00 00    	movw $0x0,$0x0
   5c827:	00          	halt
   5c828:	b1 00 00    	cmpw $0x0,$0x0
   5c82b:	00          	halt
   5c82c:	b2 00 00    	mcomw $0x0,$0x0
   5c82f:	00          	halt
   5c830:	b3 00 00    	bitw $0x0,$0x0
   5c833:	00          	halt
   5c834:	b4 00       	clrw $0x0
   5c836:	00          	halt
   5c837:	00          	halt
   5c838:	b5 00       	tstw $0x0
   5c83a:	00          	halt
   5c83b:	00          	halt
   5c83c:	b6 00       	incw $0x0
   5c83e:	00          	halt
   5c83f:	00          	halt
   5c840:	b7 00       	decw $0x0
   5c842:	00          	halt
   5c843:	00          	halt
   5c844:	b8 00       	bispsw $0x0
   5c846:	00          	halt
   5c847:	00          	halt
   5c848:	b9 00       	bicpsw $0x0
   5c84a:	00          	halt
   5c84b:	00          	halt
   5c84c:	ba 00       	popr $0x0
   5c84e:	00          	halt
   5c84f:	00          	halt
   5c850:	bb 00       	pushr $0x0
   5c852:	00          	halt
   5c853:	00          	halt
   5c854:	bc 00       	chmk $0x0
   5c856:	00          	halt
   5c857:	00          	halt
   5c858:	bd 00       	chme $0x0
   5c85a:	00          	halt
   5c85b:	00          	halt
   5c85c:	be 00       	chms $0x0
   5c85e:	00          	halt
   5c85f:	00          	halt
   5c860:	bf 00       	chmu $0x0
   5c862:	00          	halt
   5c863:	00          	halt
   5c864:	c0 00 00    	addl2 $0x0,$0x0
   5c867:	00          	halt
   5c868:	c1 00 00 00 	addl3 $0x0,$0x0,$0x0
   5c86c:	c2 00 00    	subl2 $0x0,$0x0
   5c86f:	00          	halt
   5c870:	c3 00 00 00 	subl3 $0x0,$0x0,$0x0
   5c874:	c4 00 00    	mull2 $0x0,$0x0
   5c877:	00          	halt
   5c878:	c5 00 00 00 	mull3 $0x0,$0x0,$0x0
   5c87c:	c6 00 00    	divl2 $0x0,$0x0
   5c87f:	00          	halt
   5c880:	c7 00 00 00 	divl3 $0x0,$0x0,$0x0
   5c884:	c8 00 00    	bisl2 $0x0,$0x0
   5c887:	00          	halt
   5c888:	c9 00 00 00 	bisl3 $0x0,$0x0,$0x0
   5c88c:	ca 00 00    	bicl2 $0x0,$0x0
   5c88f:	00          	halt
   5c890:	cb 00 00 00 	bicl3 $0x0,$0x0,$0x0
   5c894:	cc 00 00    	xorl2 $0x0,$0x0
   5c897:	00          	halt
   5c898:	cd 00 00 00 	xorl3 $0x0,$0x0,$0x0
   5c89c:	ce 00 00    	mnegl $0x0,$0x0
   5c89f:	00          	halt
   5c8a0:	cf 00 00 00 	casel $0x0,$0x0,$0x0
   5c8a4:	d0 00 00    	movl $0x0,$0x0
   5c8a7:	00          	halt
   5c8a8:	d1 00 00    	cmpl $0x0,$0x0
   5c8ab:	00          	halt
   5c8ac:	d2 00 00    	mcoml $0x0,$0x0
   5c8af:	00          	halt
   5c8b0:	d3 00 00    	bitl $0x0,$0x0
   5c8b3:	00          	halt
   5c8b4:	d4 00       	clrf $0x0 [f-float]
   5c8b6:	00          	halt
   5c8b7:	00          	halt
   5c8b8:	d5 00       	tstl $0x0
   5c8ba:	00          	halt
   5c8bb:	00          	halt
   5c8bc:	d6 00       	incl $0x0
   5c8be:	00          	halt
   5c8bf:	00          	halt
   5c8c0:	d7 00       	decl $0x0
   5c8c2:	00          	halt
   5c8c3:	00          	halt
   5c8c4:	d8 00 00    	adwc $0x0,$0x0
   5c8c7:	00          	halt
   5c8c8:	d9 00 00    	sbwc $0x0,$0x0
   5c8cb:	00          	halt
   5c8cc:	da 00 00    	mtpr $0x0,$0x0
   5c8cf:	00          	halt
   5c8d0:	db 00 00    	mfpr $0x0,$0x0
   5c8d3:	00          	halt
   5c8d4:	dc 00       	movpsl $0x0
   5c8d6:	00          	halt
   5c8d7:	00          	halt
   5c8d8:	dd 00       	pushl $0x0
   5c8da:	00          	halt
   5c8db:	00          	halt
   5c8dc:	de 00 00    	moval $0x0,$0x0
   5c8df:	00          	halt
   5c8e0:	df 00       	pushal $0x0
   5c8e2:	00          	halt
   5c8e3:	00          	halt
   5c8e4:	e0 00 00 00 	bbs $0x0,$0x0,5c8e8 <_DefaultRuneLocale+0x7b0>
   5c8e8:	e1 00 00 00 	bbc $0x0,$0x0,5c8ec <_DefaultRuneLocale+0x7b4>
   5c8ec:	e2 00 00 00 	bbss $0x0,$0x0,5c8f0 <_DefaultRuneLocale+0x7b8>
   5c8f0:	e3 00 00 00 	bbcs $0x0,$0x0,5c8f4 <_DefaultRuneLocale+0x7bc>
   5c8f4:	e4 00 00 00 	bbsc $0x0,$0x0,5c8f8 <_DefaultRuneLocale+0x7c0>
   5c8f8:	e5 00 00 00 	bbcc $0x0,$0x0,5c8fc <_DefaultRuneLocale+0x7c4>
   5c8fc:	e6 00 00 00 	bbssi $0x0,$0x0,5c900 <_DefaultRuneLocale+0x7c8>
   5c900:	e7 00 00 00 	bbcci $0x0,$0x0,5c904 <_DefaultRuneLocale+0x7cc>
   5c904:	e8 00 00    	blbs $0x0,5c907 <_DefaultRuneLocale+0x7cf>
   5c907:	00          	halt
   5c908:	e9 00 00    	blbc $0x0,5c90b <_DefaultRuneLocale+0x7d3>
   5c90b:	00          	halt
   5c90c:	ea 00 00 00 	ffs $0x0,$0x0,$0x0,0xec000000(r11)
   5c910:	eb 00 00 00 
   5c914:	ec 
   5c915:	00          	halt
   5c916:	00          	halt
   5c917:	00          	halt
   5c918:	ed 00 00 00 	cmpzv $0x0,$0x0,$0x0,0xef000000(sp)
   5c91c:	ee 00 00 00 
   5c920:	ef 
   5c921:	00          	halt
   5c922:	00          	halt
   5c923:	00          	halt
   5c924:	f0 00 00 00 	insv $0x0,$0x0,$0x0,*0xf2000000(r1)
   5c928:	f1 00 00 00 
   5c92c:	f2 
   5c92d:	00          	halt
   5c92e:	00          	halt
   5c92f:	00          	halt
   5c930:	f3 00 00 00 	aobleq $0x0,$0x0,5c934 <_DefaultRuneLocale+0x7fc>
   5c934:	f4 00 00    	sobgeq $0x0,5c937 <_DefaultRuneLocale+0x7ff>
   5c937:	00          	halt
   5c938:	f5 00 00    	sobgtr $0x0,5c93b <_DefaultRuneLocale+0x803>
   5c93b:	00          	halt
   5c93c:	f6 00 00    	cvtlb $0x0,$0x0
   5c93f:	00          	halt
   5c940:	f7 00 00    	cvtlw $0x0,$0x0
   5c943:	00          	halt
   5c944:	f8 00 00 00 	ashp $0x0,$0x0,$0x0,*0xfa000000(r9),$0x0,$0x0
   5c948:	f9 00 00 00 
   5c94c:	fa 00 00 
   5c94f:	00          	halt
   5c950:	fb 00 00    	calls $0x0,$0x0
   5c953:	00          	halt
   5c954:	fc          	xfc
   5c955:	00          	halt
   5c956:	00          	halt
   5c957:	00          	halt
   5c958:	fd 00       	.word 0xfd00
   5c95a:	00          	halt
   5c95b:	00          	halt
   5c95c:	fe 00       	.word 0xfe00
   5c95e:	00          	halt
   5c95f:	00          	halt
   5c960:	ff 00       	.word 0xff00
   5c962:	00          	halt
   5c963:	00          	halt
   5c964:	00          	halt
   5c965:	00          	halt
   5c966:	00          	halt
   5c967:	00          	halt
   5c968:	01          	nop
   5c969:	00          	halt
   5c96a:	00          	halt
   5c96b:	00          	halt
   5c96c:	02          	rei
   5c96d:	00          	halt
   5c96e:	00          	halt
   5c96f:	00          	halt
   5c970:	03          	bpt
   5c971:	00          	halt
   5c972:	00          	halt
   5c973:	00          	halt
   5c974:	04          	ret
   5c975:	00          	halt
   5c976:	00          	halt
   5c977:	00          	halt
   5c978:	05          	rsb
   5c979:	00          	halt
   5c97a:	00          	halt
   5c97b:	00          	halt
   5c97c:	06          	ldpctx
   5c97d:	00          	halt
   5c97e:	00          	halt
   5c97f:	00          	halt
   5c980:	07          	svpctx
   5c981:	00          	halt
   5c982:	00          	halt
   5c983:	00          	halt
   5c984:	08 00 00 00 	cvtps $0x0,$0x0,$0x0,$0x9
   5c988:	09 
   5c989:	00          	halt
   5c98a:	00          	halt
   5c98b:	00          	halt
   5c98c:	0a 00 00 00 	index $0x0,$0x0,$0x0,$0xb,$0x0,$0x0
   5c990:	0b 00 00 
   5c993:	00          	halt
   5c994:	0c 00 00 00 	prober $0x0,$0x0,$0x0
   5c998:	0d 00 00 00 	probew $0x0,$0x0,$0x0
   5c99c:	0e 00 00    	insque $0x0,$0x0
   5c99f:	00          	halt
   5c9a0:	0f 00 00    	remque $0x0,$0x0
   5c9a3:	00          	halt
   5c9a4:	10 00       	bsbb 5c9a6 <_DefaultRuneLocale+0x86e>
   5c9a6:	00          	halt
   5c9a7:	00          	halt
   5c9a8:	11 00       	brb 5c9aa <_DefaultRuneLocale+0x872>
   5c9aa:	00          	halt
   5c9ab:	00          	halt
   5c9ac:	12 00       	bneq 5c9ae <_DefaultRuneLocale+0x876>
   5c9ae:	00          	halt
   5c9af:	00          	halt
   5c9b0:	13 00       	beql 5c9b2 <_DefaultRuneLocale+0x87a>
   5c9b2:	00          	halt
   5c9b3:	00          	halt
   5c9b4:	14 00       	bgtr 5c9b6 <_DefaultRuneLocale+0x87e>
   5c9b6:	00          	halt
   5c9b7:	00          	halt
   5c9b8:	15 00       	bleq 5c9ba <_DefaultRuneLocale+0x882>
   5c9ba:	00          	halt
   5c9bb:	00          	halt
   5c9bc:	16 00       	jsb $0x0
   5c9be:	00          	halt
   5c9bf:	00          	halt
   5c9c0:	17 00       	jmp $0x0
   5c9c2:	00          	halt
   5c9c3:	00          	halt
   5c9c4:	18 00       	bgeq 5c9c6 <_DefaultRuneLocale+0x88e>
   5c9c6:	00          	halt
   5c9c7:	00          	halt
   5c9c8:	19 00       	blss 5c9ca <_DefaultRuneLocale+0x892>
   5c9ca:	00          	halt
   5c9cb:	00          	halt
   5c9cc:	1a 00       	bgtru 5c9ce <_DefaultRuneLocale+0x896>
   5c9ce:	00          	halt
   5c9cf:	00          	halt
   5c9d0:	1b 00       	blequ 5c9d2 <_DefaultRuneLocale+0x89a>
   5c9d2:	00          	halt
   5c9d3:	00          	halt
   5c9d4:	1c 00       	bvc 5c9d6 <_DefaultRuneLocale+0x89e>
   5c9d6:	00          	halt
   5c9d7:	00          	halt
   5c9d8:	1d 00       	bvs 5c9da <_DefaultRuneLocale+0x8a2>
   5c9da:	00          	halt
   5c9db:	00          	halt
   5c9dc:	1e 00       	bcc 5c9de <_DefaultRuneLocale+0x8a6>
   5c9de:	00          	halt
   5c9df:	00          	halt
   5c9e0:	1f 00       	blssu 5c9e2 <_DefaultRuneLocale+0x8aa>
   5c9e2:	00          	halt
   5c9e3:	00          	halt
   5c9e4:	20 00 00 00 	addp4 $0x0,$0x0,$0x0,$0x21
   5c9e8:	21 
   5c9e9:	00          	halt
   5c9ea:	00          	halt
   5c9eb:	00          	halt
   5c9ec:	22 00 00 00 	subp4 $0x0,$0x0,$0x0,$0x23
   5c9f0:	23 
   5c9f1:	00          	halt
   5c9f2:	00          	halt
   5c9f3:	00          	halt
   5c9f4:	24 00 00 00 	cvtpt $0x0,$0x0,$0x0,$0x25,$0x0
   5c9f8:	25 00 
   5c9fa:	00          	halt
   5c9fb:	00          	halt
   5c9fc:	26 00 00 00 	cvttp $0x0,$0x0,$0x0,$0x27,$0x0
   5ca00:	27 00 
   5ca02:	00          	halt
   5ca03:	00          	halt
   5ca04:	28 00 00 00 	movc3 $0x0,$0x0,$0x0
   5ca08:	29 00 00 00 	cmpc3 $0x0,$0x0,$0x0
   5ca0c:	2a 00 00 00 	scanc $0x0,$0x0,$0x0,$0x2b
   5ca10:	2b 
   5ca11:	00          	halt
   5ca12:	00          	halt
   5ca13:	00          	halt
   5ca14:	2c 00 00 00 	movc5 $0x0,$0x0,$0x0,$0x2d,$0x0
   5ca18:	2d 00 
   5ca1a:	00          	halt
   5ca1b:	00          	halt
   5ca1c:	2e 00 00 00 	movtc $0x0,$0x0,$0x0,$0x2f,$0x0,$0x0
   5ca20:	2f 00 00 
   5ca23:	00          	halt
   5ca24:	30 00 00    	bsbw 5ca27 <_DefaultRuneLocale+0x8ef>
   5ca27:	00          	halt
   5ca28:	31 00 00    	brw 5ca2b <_DefaultRuneLocale+0x8f3>
   5ca2b:	00          	halt
   5ca2c:	32 00 00    	cvtwl $0x0,$0x0
   5ca2f:	00          	halt
   5ca30:	33 00 00    	cvtwb $0x0,$0x0
   5ca33:	00          	halt
   5ca34:	34 00 00 00 	movp $0x0,$0x0,$0x0
   5ca38:	35 00 00 00 	cmpp3 $0x0,$0x0,$0x0
   5ca3c:	36 00 00 00 	cvtpl $0x0,$0x0,$0x0
   5ca40:	37 00 00 00 	cmpp4 $0x0,$0x0,$0x0,$0x38
   5ca44:	38 
   5ca45:	00          	halt
   5ca46:	00          	halt
   5ca47:	00          	halt
   5ca48:	39 00 00 00 	matchc $0x0,$0x0,$0x0,$0x3a
   5ca4c:	3a 
   5ca4d:	00          	halt
   5ca4e:	00          	halt
   5ca4f:	00          	halt
   5ca50:	3b 00 00 00 	skpc $0x0,$0x0,$0x0
   5ca54:	3c 00 00    	movzwl $0x0,$0x0
   5ca57:	00          	halt
   5ca58:	3d 00 00 00 	acbw $0x0,$0x0,$0x0,5ca9c <_DefaultRuneLocale+0x964>
   5ca5c:	3e 00 
   5ca5e:	00          	halt
   5ca5f:	00          	halt
   5ca60:	3f 00       	pushaw $0x0
   5ca62:	00          	halt
   5ca63:	00          	halt
   5ca64:	40 00 00    	addf2 $0x0 [f-float],$0x0 [f-float]
   5ca67:	00          	halt
   5ca68:	41 00 00 00 	addf3 $0x0 [f-float],$0x0 [f-float],$0x0 [f-float]
   5ca6c:	42 00 00    	subf2 $0x0 [f-float],$0x0 [f-float]
   5ca6f:	00          	halt
   5ca70:	43 00 00 00 	subf3 $0x0 [f-float],$0x0 [f-float],$0x0 [f-float]
   5ca74:	44 00 00    	mulf2 $0x0 [f-float],$0x0 [f-float]
   5ca77:	00          	halt
   5ca78:	45 00 00 00 	mulf3 $0x0 [f-float],$0x0 [f-float],$0x0 [f-float]
   5ca7c:	46 00 00    	divf2 $0x0 [f-float],$0x0 [f-float]
   5ca7f:	00          	halt
   5ca80:	47 00 00 00 	divf3 $0x0 [f-float],$0x0 [f-float],$0x0 [f-float]
   5ca84:	48 00 00    	cvtfb $0x0 [f-float],$0x0
   5ca87:	00          	halt
   5ca88:	49 00 00    	cvtfw $0x0 [f-float],$0x0
   5ca8b:	00          	halt
   5ca8c:	4a 00 00    	cvtfl $0x0 [f-float],$0x0
   5ca8f:	00          	halt
   5ca90:	4b 00 00    	cvtrfl $0x0 [f-float],$0x0
   5ca93:	00          	halt
   5ca94:	4c 00 00    	cvtbf $0x0,$0x0 [f-float]
   5ca97:	00          	halt
   5ca98:	4d 00 00    	cvtwf $0x0,$0x0 [f-float]
   5ca9b:	00          	halt
   5ca9c:	4e 00 00    	cvtlf $0x0,$0x0 [f-float]
   5ca9f:	00          	halt
   5caa0:	4f 00 00 00 	acbf $0x0 [f-float],$0x0 [f-float],$0x0 [f-float],5caf6 <_DefaultRuneLocale+0x9be>
   5caa4:	50 00 
   5caa6:	00          	halt
   5caa7:	00          	halt
   5caa8:	51 00 00    	cmpf $0x0 [f-float],$0x0 [f-float]
   5caab:	00          	halt
   5caac:	52 00 00    	mnegf $0x0 [f-float],$0x0 [f-float]
   5caaf:	00          	halt
   5cab0:	53 00       	tstf $0x0 [f-float]
   5cab2:	00          	halt
   5cab3:	00          	halt
   5cab4:	54 00 00 00 	emodf $0x0 [f-float],$0x0,$0x0 [f-float],r5,$0x0 [f-float]
   5cab8:	55 00 
   5caba:	00          	halt
   5cabb:	00          	halt
   5cabc:	56 00 00    	cvtfd $0x0 [f-float],$0x0 [d-float]
   5cabf:	00          	halt
   5cac0:	57 00       	.word 0x5700
   5cac2:	00          	halt
   5cac3:	00          	halt
   5cac4:	58 00 00    	adawi $0x0,$0x0
   5cac7:	00          	halt
   5cac8:	59 00       	.word 0x5900
   5caca:	00          	halt
   5cacb:	00          	halt
   5cacc:	5a 00       	.word 0x5a00
   5cace:	00          	halt
   5cacf:	00          	halt
   5cad0:	5b 00       	.word 0x5b00
   5cad2:	00          	halt
   5cad3:	00          	halt
   5cad4:	5c 00 00    	insqhi $0x0,$0x0
   5cad7:	00          	halt
   5cad8:	5d 00 00    	insqti $0x0,$0x0
   5cadb:	00          	halt
   5cadc:	5e 00 00    	remqhi $0x0,$0x0
   5cadf:	00          	halt
   5cae0:	5f 00 00    	remqti $0x0,$0x0
   5cae3:	00          	halt
   5cae4:	60 00 00    	addd2 $0x0 [d-float],$0x0 [d-float]
   5cae7:	00          	halt
   5cae8:	41 00 00 00 	addf3 $0x0 [f-float],$0x0 [f-float],$0x0 [f-float]
   5caec:	42 00 00    	subf2 $0x0 [f-float],$0x0 [f-float]
   5caef:	00          	halt
   5caf0:	43 00 00 00 	subf3 $0x0 [f-float],$0x0 [f-float],$0x0 [f-float]
   5caf4:	44 00 00    	mulf2 $0x0 [f-float],$0x0 [f-float]
   5caf7:	00          	halt
   5caf8:	45 00 00 00 	mulf3 $0x0 [f-float],$0x0 [f-float],$0x0 [f-float]
   5cafc:	46 00 00    	divf2 $0x0 [f-float],$0x0 [f-float]
   5caff:	00          	halt
   5cb00:	47 00 00 00 	divf3 $0x0 [f-float],$0x0 [f-float],$0x0 [f-float]
   5cb04:	48 00 00    	cvtfb $0x0 [f-float],$0x0
   5cb07:	00          	halt
   5cb08:	49 00 00    	cvtfw $0x0 [f-float],$0x0
   5cb0b:	00          	halt
   5cb0c:	4a 00 00    	cvtfl $0x0 [f-float],$0x0
   5cb0f:	00          	halt
   5cb10:	4b 00 00    	cvtrfl $0x0 [f-float],$0x0
   5cb13:	00          	halt
   5cb14:	4c 00 00    	cvtbf $0x0,$0x0 [f-float]
   5cb17:	00          	halt
   5cb18:	4d 00 00    	cvtwf $0x0,$0x0 [f-float]
   5cb1b:	00          	halt
   5cb1c:	4e 00 00    	cvtlf $0x0,$0x0 [f-float]
   5cb1f:	00          	halt
   5cb20:	4f 00 00 00 	acbf $0x0 [f-float],$0x0 [f-float],$0x0 [f-float],5cb76 <_DefaultRuneLocale+0xa3e>
   5cb24:	50 00 
   5cb26:	00          	halt
   5cb27:	00          	halt
   5cb28:	51 00 00    	cmpf $0x0 [f-float],$0x0 [f-float]
   5cb2b:	00          	halt
   5cb2c:	52 00 00    	mnegf $0x0 [f-float],$0x0 [f-float]
   5cb2f:	00          	halt
   5cb30:	53 00       	tstf $0x0 [f-float]
   5cb32:	00          	halt
   5cb33:	00          	halt
   5cb34:	54 00 00 00 	emodf $0x0 [f-float],$0x0,$0x0 [f-float],r5,$0x0 [f-float]
   5cb38:	55 00 
   5cb3a:	00          	halt
   5cb3b:	00          	halt
   5cb3c:	56 00 00    	cvtfd $0x0 [f-float],$0x0 [d-float]
   5cb3f:	00          	halt
   5cb40:	57 00       	.word 0x5700
   5cb42:	00          	halt
   5cb43:	00          	halt
   5cb44:	58 00 00    	adawi $0x0,$0x0
   5cb47:	00          	halt
   5cb48:	59 00       	.word 0x5900
   5cb4a:	00          	halt
   5cb4b:	00          	halt
   5cb4c:	5a 00       	.word 0x5a00
   5cb4e:	00          	halt
   5cb4f:	00          	halt
   5cb50:	7b 00 00 00 	ediv $0x0,$0x0,$0x0,-(ap)
   5cb54:	7c 
   5cb55:	00          	halt
   5cb56:	00          	halt
   5cb57:	00          	halt
   5cb58:	7d 00 00    	movq $0x0,$0x0
   5cb5b:	00          	halt
   5cb5c:	7e 00 00    	movaq $0x0,$0x0
   5cb5f:	00          	halt
   5cb60:	7f 00       	pushaq $0x0
   5cb62:	00          	halt
   5cb63:	00          	halt
   5cb64:	80 00 00    	addb2 $0x0,$0x0
   5cb67:	00          	halt
   5cb68:	81 00 00 00 	addb3 $0x0,$0x0,$0x0
   5cb6c:	82 00 00    	subb2 $0x0,$0x0
   5cb6f:	00          	halt
   5cb70:	83 00 00 00 	subb3 $0x0,$0x0,$0x0
   5cb74:	84 00 00    	mulb2 $0x0,$0x0
   5cb77:	00          	halt
   5cb78:	85 00 00 00 	mulb3 $0x0,$0x0,$0x0
   5cb7c:	86 00 00    	divb2 $0x0,$0x0
   5cb7f:	00          	halt
   5cb80:	87 00 00 00 	divb3 $0x0,$0x0,$0x0
   5cb84:	88 00 00    	bisb2 $0x0,$0x0
   5cb87:	00          	halt
   5cb88:	89 00 00 00 	bisb3 $0x0,$0x0,$0x0
   5cb8c:	8a 00 00    	bicb2 $0x0,$0x0
   5cb8f:	00          	halt
   5cb90:	8b 00 00 00 	bicb3 $0x0,$0x0,$0x0
   5cb94:	8c 00 00    	xorb2 $0x0,$0x0
   5cb97:	00          	halt
   5cb98:	8d 00 00 00 	xorb3 $0x0,$0x0,$0x0
   5cb9c:	8e 00 00    	mnegb $0x0,$0x0
   5cb9f:	00          	halt
   5cba0:	8f 00 00 00 	caseb $0x0,$0x0,$0x0
   5cba4:	90 00 00    	movb $0x0,$0x0
   5cba7:	00          	halt
   5cba8:	91 00 00    	cmpb $0x0,$0x0
   5cbab:	00          	halt
   5cbac:	92 00 00    	mcomb $0x0,$0x0
   5cbaf:	00          	halt
   5cbb0:	93 00 00    	bitb $0x0,$0x0
   5cbb3:	00          	halt
   5cbb4:	94 00       	clrb $0x0
   5cbb6:	00          	halt
   5cbb7:	00          	halt
   5cbb8:	95 00       	tstb $0x0
   5cbba:	00          	halt
   5cbbb:	00          	halt
   5cbbc:	96 00       	incb $0x0
   5cbbe:	00          	halt
   5cbbf:	00          	halt
   5cbc0:	97 00       	decb $0x0
   5cbc2:	00          	halt
   5cbc3:	00          	halt
   5cbc4:	98 00 00    	cvtbl $0x0,$0x0
   5cbc7:	00          	halt
   5cbc8:	99 00 00    	cvtbw $0x0,$0x0
   5cbcb:	00          	halt
   5cbcc:	9a 00 00    	movzbl $0x0,$0x0
   5cbcf:	00          	halt
   5cbd0:	9b 00 00    	movzbw $0x0,$0x0
   5cbd3:	00          	halt
   5cbd4:	9c 00 00 00 	rotl $0x0,$0x0,$0x0
   5cbd8:	9d 00 00 00 	acbb $0x0,$0x0,$0x0,5cc7c <_DefaultRuneLocale+0xb44>
   5cbdc:	9e 00 
   5cbde:	00          	halt
   5cbdf:	00          	halt
   5cbe0:	9f 00       	pushab $0x0
   5cbe2:	00          	halt
   5cbe3:	00          	halt
   5cbe4:	a0 00 00    	addw2 $0x0,$0x0
   5cbe7:	00          	halt
   5cbe8:	a1 00 00 00 	addw3 $0x0,$0x0,$0x0
   5cbec:	a2 00 00    	subw2 $0x0,$0x0
   5cbef:	00          	halt
   5cbf0:	a3 00 00 00 	subw3 $0x0,$0x0,$0x0
   5cbf4:	a4 00 00    	mulw2 $0x0,$0x0
   5cbf7:	00          	halt
   5cbf8:	a5 00 00 00 	mulw3 $0x0,$0x0,$0x0
   5cbfc:	a6 00 00    	divw2 $0x0,$0x0
   5cbff:	00          	halt
   5cc00:	a7 00 00 00 	divw3 $0x0,$0x0,$0x0
   5cc04:	a8 00 00    	bisw2 $0x0,$0x0
   5cc07:	00          	halt
   5cc08:	a9 00 00 00 	bisw3 $0x0,$0x0,$0x0
   5cc0c:	aa 00 00    	bicw2 $0x0,$0x0
   5cc0f:	00          	halt
   5cc10:	ab 00 00 00 	bicw3 $0x0,$0x0,$0x0
   5cc14:	ac 00 00    	xorw2 $0x0,$0x0
   5cc17:	00          	halt
   5cc18:	ad 00 00 00 	xorw3 $0x0,$0x0,$0x0
   5cc1c:	ae 00 00    	mnegw $0x0,$0x0
   5cc1f:	00          	halt
   5cc20:	af 00 00 00 	casew $0x0,$0x0,$0x0
   5cc24:	b0 00 00    	movw $0x0,$0x0
   5cc27:	00          	halt
   5cc28:	b1 00 00    	cmpw $0x0,$0x0
   5cc2b:	00          	halt
   5cc2c:	b2 00 00    	mcomw $0x0,$0x0
   5cc2f:	00          	halt
   5cc30:	b3 00 00    	bitw $0x0,$0x0
   5cc33:	00          	halt
   5cc34:	b4 00       	clrw $0x0
   5cc36:	00          	halt
   5cc37:	00          	halt
   5cc38:	b5 00       	tstw $0x0
   5cc3a:	00          	halt
   5cc3b:	00          	halt
   5cc3c:	b6 00       	incw $0x0
   5cc3e:	00          	halt
   5cc3f:	00          	halt
   5cc40:	b7 00       	decw $0x0
   5cc42:	00          	halt
   5cc43:	00          	halt
   5cc44:	b8 00       	bispsw $0x0
   5cc46:	00          	halt
   5cc47:	00          	halt
   5cc48:	b9 00       	bicpsw $0x0
   5cc4a:	00          	halt
   5cc4b:	00          	halt
   5cc4c:	ba 00       	popr $0x0
   5cc4e:	00          	halt
   5cc4f:	00          	halt
   5cc50:	bb 00       	pushr $0x0
   5cc52:	00          	halt
   5cc53:	00          	halt
   5cc54:	bc 00       	chmk $0x0
   5cc56:	00          	halt
   5cc57:	00          	halt
   5cc58:	bd 00       	chme $0x0
   5cc5a:	00          	halt
   5cc5b:	00          	halt
   5cc5c:	be 00       	chms $0x0
   5cc5e:	00          	halt
   5cc5f:	00          	halt
   5cc60:	bf 00       	chmu $0x0
   5cc62:	00          	halt
   5cc63:	00          	halt
   5cc64:	c0 00 00    	addl2 $0x0,$0x0
   5cc67:	00          	halt
   5cc68:	c1 00 00 00 	addl3 $0x0,$0x0,$0x0
   5cc6c:	c2 00 00    	subl2 $0x0,$0x0
   5cc6f:	00          	halt
   5cc70:	c3 00 00 00 	subl3 $0x0,$0x0,$0x0
   5cc74:	c4 00 00    	mull2 $0x0,$0x0
   5cc77:	00          	halt
   5cc78:	c5 00 00 00 	mull3 $0x0,$0x0,$0x0
   5cc7c:	c6 00 00    	divl2 $0x0,$0x0
   5cc7f:	00          	halt
   5cc80:	c7 00 00 00 	divl3 $0x0,$0x0,$0x0
   5cc84:	c8 00 00    	bisl2 $0x0,$0x0
   5cc87:	00          	halt
   5cc88:	c9 00 00 00 	bisl3 $0x0,$0x0,$0x0
   5cc8c:	ca 00 00    	bicl2 $0x0,$0x0
   5cc8f:	00          	halt
   5cc90:	cb 00 00 00 	bicl3 $0x0,$0x0,$0x0
   5cc94:	cc 00 00    	xorl2 $0x0,$0x0
   5cc97:	00          	halt
   5cc98:	cd 00 00 00 	xorl3 $0x0,$0x0,$0x0
   5cc9c:	ce 00 00    	mnegl $0x0,$0x0
   5cc9f:	00          	halt
   5cca0:	cf 00 00 00 	casel $0x0,$0x0,$0x0
   5cca4:	d0 00 00    	movl $0x0,$0x0
   5cca7:	00          	halt
   5cca8:	d1 00 00    	cmpl $0x0,$0x0
   5ccab:	00          	halt
   5ccac:	d2 00 00    	mcoml $0x0,$0x0
   5ccaf:	00          	halt
   5ccb0:	d3 00 00    	bitl $0x0,$0x0
   5ccb3:	00          	halt
   5ccb4:	d4 00       	clrf $0x0 [f-float]
   5ccb6:	00          	halt
   5ccb7:	00          	halt
   5ccb8:	d5 00       	tstl $0x0
   5ccba:	00          	halt
   5ccbb:	00          	halt
   5ccbc:	d6 00       	incl $0x0
   5ccbe:	00          	halt
   5ccbf:	00          	halt
   5ccc0:	d7 00       	decl $0x0
   5ccc2:	00          	halt
   5ccc3:	00          	halt
   5ccc4:	d8 00 00    	adwc $0x0,$0x0
   5ccc7:	00          	halt
   5ccc8:	d9 00 00    	sbwc $0x0,$0x0
   5cccb:	00          	halt
   5cccc:	da 00 00    	mtpr $0x0,$0x0
   5cccf:	00          	halt
   5ccd0:	db 00 00    	mfpr $0x0,$0x0
   5ccd3:	00          	halt
   5ccd4:	dc 00       	movpsl $0x0
   5ccd6:	00          	halt
   5ccd7:	00          	halt
   5ccd8:	dd 00       	pushl $0x0
   5ccda:	00          	halt
   5ccdb:	00          	halt
   5ccdc:	de 00 00    	moval $0x0,$0x0
   5ccdf:	00          	halt
   5cce0:	df 00       	pushal $0x0
   5cce2:	00          	halt
   5cce3:	00          	halt
   5cce4:	e0 00 00 00 	bbs $0x0,$0x0,5cce8 <_DefaultRuneLocale+0xbb0>
   5cce8:	e1 00 00 00 	bbc $0x0,$0x0,5ccec <_DefaultRuneLocale+0xbb4>
   5ccec:	e2 00 00 00 	bbss $0x0,$0x0,5ccf0 <_DefaultRuneLocale+0xbb8>
   5ccf0:	e3 00 00 00 	bbcs $0x0,$0x0,5ccf4 <_DefaultRuneLocale+0xbbc>
   5ccf4:	e4 00 00 00 	bbsc $0x0,$0x0,5ccf8 <_DefaultRuneLocale+0xbc0>
   5ccf8:	e5 00 00 00 	bbcc $0x0,$0x0,5ccfc <_DefaultRuneLocale+0xbc4>
   5ccfc:	e6 00 00 00 	bbssi $0x0,$0x0,5cd00 <_DefaultRuneLocale+0xbc8>
   5cd00:	e7 00 00 00 	bbcci $0x0,$0x0,5cd04 <_DefaultRuneLocale+0xbcc>
   5cd04:	e8 00 00    	blbs $0x0,5cd07 <_DefaultRuneLocale+0xbcf>
   5cd07:	00          	halt
   5cd08:	e9 00 00    	blbc $0x0,5cd0b <_DefaultRuneLocale+0xbd3>
   5cd0b:	00          	halt
   5cd0c:	ea 00 00 00 	ffs $0x0,$0x0,$0x0,0xec000000(r11)
   5cd10:	eb 00 00 00 
   5cd14:	ec 
   5cd15:	00          	halt
   5cd16:	00          	halt
   5cd17:	00          	halt
   5cd18:	ed 00 00 00 	cmpzv $0x0,$0x0,$0x0,0xef000000(sp)
   5cd1c:	ee 00 00 00 
   5cd20:	ef 
   5cd21:	00          	halt
   5cd22:	00          	halt
   5cd23:	00          	halt
   5cd24:	f0 00 00 00 	insv $0x0,$0x0,$0x0,*0xf2000000(r1)
   5cd28:	f1 00 00 00 
   5cd2c:	f2 
   5cd2d:	00          	halt
   5cd2e:	00          	halt
   5cd2f:	00          	halt
   5cd30:	f3 00 00 00 	aobleq $0x0,$0x0,5cd34 <_DefaultRuneLocale+0xbfc>
   5cd34:	f4 00 00    	sobgeq $0x0,5cd37 <_DefaultRuneLocale+0xbff>
   5cd37:	00          	halt
   5cd38:	f5 00 00    	sobgtr $0x0,5cd3b <_DefaultRuneLocale+0xc03>
   5cd3b:	00          	halt
   5cd3c:	f6 00 00    	cvtlb $0x0,$0x0
   5cd3f:	00          	halt
   5cd40:	f7 00 00    	cvtlw $0x0,$0x0
   5cd43:	00          	halt
   5cd44:	f8 00 00 00 	ashp $0x0,$0x0,$0x0,*0xfa000000(r9),$0x0,$0x0
   5cd48:	f9 00 00 00 
   5cd4c:	fa 00 00 
   5cd4f:	00          	halt
   5cd50:	fb 00 00    	calls $0x0,$0x0
   5cd53:	00          	halt
   5cd54:	fc          	xfc
   5cd55:	00          	halt
   5cd56:	00          	halt
   5cd57:	00          	halt
   5cd58:	fd 00       	.word 0xfd00
   5cd5a:	00          	halt
   5cd5b:	00          	halt
   5cd5c:	fe 00       	.word 0xfe00
   5cd5e:	00          	halt
   5cd5f:	00          	halt
   5cd60:	ff 00       	.word 0xff00
	...
   5cd82:	00          	halt
   5cd83:	00          	halt
   5cd84:	1a ad       	bgtru 5cd33 <_DefaultRuneLocale+0xbfb>
   5cd86:	02          	rei
   5cd87:	00          	halt
   5cd88:	0c ce 05 00 	prober 0x5(sp),$0x0,$0x0
   5cd8c:	00 00 
	...
   5cda2:	00          	halt
   5cda3:	00          	halt
   5cda4:	23 ad 02 00 	subp6 0x2(fp),$0x0,$0x0,$0x5,$0x0,$0x0
   5cda8:	00 05 00 00 
   5cdac:	29 ad 02 00 	cmpc3 0x2(fp),$0x0,$0x0
   5cdb0:	00 
   5cdb1:	01          	nop
   5cdb2:	00          	halt
   5cdb3:	00          	halt
   5cdb4:	2f ad 02 00 	movtuc 0x2(fp),$0x0,$0x0,$0x0,$0x2,$0x0
   5cdb8:	00 00 02 00 
   5cdbc:	35 ad 02 00 	cmpp3 0x2(fp),$0x0,$0x0
   5cdc0:	00 
   5cdc1:	02          	rei
   5cdc2:	00          	halt
   5cdc3:	00          	halt
   5cdc4:	60 ad 02 00 	addd2 0x2(fp),$0x0 [d-float]
   5cdc8:	00          	halt
   5cdc9:	04          	ret
   5cdca:	00          	halt
   5cdcb:	00          	halt
   5cdcc:	3b ad 02 00 	skpc 0x2(fp),$0x0,$0x0
   5cdd0:	00 
   5cdd1:	08 00 00 41 	cvtps $0x0,$0x0,0x2(fp)[r1],$0x0
   5cdd5:	ad 02 00 
   5cdd8:	00          	halt
   5cdd9:	10 00       	bsbb 5cddb <_DefaultRuneLocale+0xca3>
   5cddb:	00          	halt
   5cddc:	47 ad 02 00 	divf3 0x2(fp),$0x0 [f-float],$0x0 [f-float]
   5cde0:	00 
   5cde1:	00          	halt
   5cde2:	04          	ret
   5cde3:	00          	halt
   5cde4:	4d ad 02 00 	cvtwf 0x2(fp),$0x0 [f-float]
   5cde8:	00          	halt
   5cde9:	20 00 00 53 	addp4 $0x0,$0x0,r3,0x2(fp)
   5cded:	ad 02 
   5cdef:	00          	halt
   5cdf0:	00          	halt
   5cdf1:	40 00 00    	addf2 $0x0 [f-float],$0x0 [f-float]
   5cdf4:	59 ad       	.word 0x59ad
   5cdf6:	02          	rei
   5cdf7:	00          	halt
   5cdf8:	00          	halt
   5cdf9:	80 00 00    	addb2 $0x0,$0x0
   5cdfc:	5f ad 02 00 	remqti 0x2(fp),$0x0
   5ce00:	00          	halt
   5ce01:	00          	halt
   5ce02:	01          	nop
   5ce03:	00          	halt
   5ce04:	00          	halt
   5ce05:	00          	halt
	...

0005ce08 <_CurrentRuneLocale>:
   5ce08:	38 c1 05 00 	editpc 0x5(r1),$0x1c,0x5(sp),$0x1
   5ce0c:	1c ce 05 00 
   5ce10:	01 

0005ce0c <_citrus_ctype_none>:
   5ce0c:	1c ce       	bvc 5cddc <_DefaultRuneLocale+0xca4>
   5ce0e:	05          	rsb
   5ce0f:	00          	halt
   5ce10:	01          	nop
   5ce11:	00          	halt
	...

0005ce14 <_citrus_ctype_utf8>:
   5ce14:	30 ce 05    	bsbw 5d3e5 <usual+0x369>
   5ce17:	00          	halt
   5ce18:	04          	ret
   5ce19:	00          	halt
	...

0005ce1c <_citrus_none_ctype_ops>:
   5ce1c:	24 60 01 00 	cvtpt (r0),$0x1,$0x0,r0,(r0)
   5ce20:	50 60 
   5ce22:	01          	nop
   5ce23:	00          	halt
   5ce24:	5a 60       	.word 0x5a60
   5ce26:	01          	nop
   5ce27:	00          	halt
   5ce28:	b0 60 01    	movw (r0),$0x1
   5ce2b:	00          	halt
   5ce2c:	e4 60 01 00 	bbsc (r0),$0x1,5ce30 <_citrus_utf8_ctype_ops>

0005ce30 <_citrus_utf8_ctype_ops>:
   5ce30:	90 61 01    	movb (r1),$0x1
   5ce33:	00          	halt
   5ce34:	2c 63 01 00 	movc5 (r3),$0x1,$0x0,(r3)[r4],$0x1
   5ce38:	44 63 01 
   5ce3b:	00          	halt
   5ce3c:	72 64 01    	mnegd (r4),$0x1 [d-float]
   5ce3f:	00          	halt
   5ce40:	0a 65 01 00 	index (r5),$0x1,$0x0,0x80002ad(r4),0x2(sp),$0x0
   5ce44:	e4 ad 02 00 
   5ce48:	08 ae 02 00 

0005ce44 <_CurrentMessagesLocale>:
   5ce44:	e4 ad 02 00 	bbsc 0x2(fp),$0x0,5ce51 <_sys_nerr+0x1>
   5ce48:	08 

0005ce48 <_CurrentNumericLocale>:
   5ce48:	08 ae 02 00 	cvtps 0x2(sp),$0x0,$0x18,0x2(sp)
   5ce4c:	18 ae 02 

0005ce4c <_CurrentTimeLocale>:
   5ce4c:	18 ae       	bgeq 5cdfc <_DefaultRuneLocale+0xcc4>
   5ce4e:	02          	rei
	...

0005ce50 <_sys_nerr>:
   5ce50:	5c 00 00    	insqhi $0x0,$0x0
	...
Disassembly of section .bss:

0005d000 <empty.0-0x20>:
	...

0005d020 <empty.0>:
	...

0005d078 <_thread_tagname___sinit_mutex.1>:
   5d078:	00          	halt
   5d079:	00          	halt
	...

0005d07c <usual>:
	...

0005d654 <usualext>:
	...

0005e8a8 <_thread_tagname___sfp_mutex>:
   5e8a8:	00          	halt
   5e8a9:	00          	halt
	...

0005e8ac <call_depth.0>:
   5e8ac:	00          	halt
   5e8ad:	00          	halt
	...

0005e8b0 <restartloop>:
   5e8b0:	00          	halt
   5e8b1:	00          	halt
	...

0005e8b4 <freelist>:
	...

0005e8dc <private_mem>:
	...

0005f1dc <p5s>:
   5f1dc:	00          	halt
   5f1dd:	00          	halt
	...

0005f1e0 <pagsz.0>:
   5f1e0:	00          	halt
   5f1e1:	00          	halt
	...

0005f1e4 <mbs.0>:
	...

0005f264 <mbs.1>:
	...

0005f2e4 <mbs.2>:
	...

0005f364 <mbs.3>:
	...

0005f3e4 <mbs.4>:
	...

0005f464 <mbs.5>:
	...

0005f4e4 <buf.0>:
	...

00060000 <noprint.1>:
	...

00061000 <malloc_readonly>:
	...

00062000 <malloc_func>:
   62000:	00          	halt
   62001:	00          	halt
	...

00062004 <malloc_active>:
   62004:	00          	halt
   62005:	00          	halt
	...

00062008 <rs>:
   62008:	00          	halt
   62009:	00          	halt
	...

0006200c <rsx>:
   6200c:	00          	halt
   6200d:	00          	halt
	...

00062010 <environ>:
   62010:	00          	halt
   62011:	00          	halt
	...

00062014 <__progname_storage>:
	...

00062114 <errno>:
   62114:	00          	halt
   62115:	00          	halt
	...

00062118 <__sFext>:
	...

00062454 <__sdidinit>:
   62454:	00          	halt
   62455:	00          	halt
	...

00062458 <__atexit>:
   62458:	00          	halt
   62459:	00          	halt
	...

0006245c <__sigintr>:
   6245c:	00          	halt
   6245d:	00          	halt
	...

00062460 <malloc_options>:
   62460:	00          	halt
   62461:	00          	halt
	...
