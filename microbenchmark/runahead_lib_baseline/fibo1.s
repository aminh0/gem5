	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	.file	"fibo1.c"
	.option	push
	.option	arch, +a, +c, +d, +f, +zaamo, +zalrsc, +zicsr
	.text
	.globl	fibo                            # -- Begin function fibo
	.p2align	1
	.type	fibo,@function
fibo:                                   # @fibo
# %bb.0:                                # %entry
	blez	a0, .LBB0_4
# %bb.1:                                # %for.body.preheader
	li	a3, 0
	li	a2, 1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	addw	a4, a3, a2
	addiw	a0, a0, -1
	mv	a1, a2
	mv	a3, a2
	mv	a2, a4
	bnez	a0, .LBB0_2
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a1
	ret
.LBB0_4:
	li	a0, 0
	ret
.Lfunc_end0:
	.size	fibo, .Lfunc_end0-fibo
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +a, +c, +d, +f, +zaamo, +zalrsc, +zicsr
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sd	ra, 8(sp)                       # 8-byte Folded Spill
	li	a0, 0
	lui	a6, %hi(array)
	addi	a6, a6, %lo(array)
	lui	a1, 5
	addiw	a2, a1, -480
	j	.LBB1_3
.LBB1_1:                                #   in Loop: Header=BB1_3 Depth=1
	li	a4, 0
.LBB1_2:                                # %fibo.exit
                                        #   in Loop: Header=BB1_3 Depth=1
	slli	a1, a0, 2
	add	a1, a1, a6
	sw	a4, 0(a1)
	#APP
	nop
	#NO_APP
	addi	a0, a0, 1
	beq	a0, a2, .LBB1_6
.LBB1_3:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_5 Depth 2
	#APP
	nop
	#NO_APP
	beqz	a0, .LBB1_1
# %bb.4:                                # %for.body.i.preheader
                                        #   in Loop: Header=BB1_3 Depth=1
	li	a1, 0
	li	a3, 1
	mv	a5, a0
.LBB1_5:                                # %for.body.i
                                        #   Parent Loop BB1_3 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mv	a4, a3
	addi	a5, a5, -1
	add	a3, a3, a1
	mv	a1, a4
	bnez	a5, .LBB1_5
	j	.LBB1_2
.LBB1_6:                                # %for.cond.cleanup
	lui	a0, %hi(.Lstr)
	addi	a0, a0, %lo(.Lstr)
	call	puts
	li	a0, 0
	ld	ra, 8(sp)                       # 8-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.option	pop
	.type	array,@object                   # @array
	.bss
	.globl	array
	.p2align	6, 0x0
array:
	.zero	4000000
	.size	array, 4000000

	.type	.Lstr,@object                   # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"Done!"
	.size	.Lstr, 6

	.ident	"clang version 20.1.4 (git@github.com:suhipek/llvm-project.git fff63b5c18419c3a76ee7a0201549f526ae46613)"
	.section	".note.GNU-stack","",@progbits
