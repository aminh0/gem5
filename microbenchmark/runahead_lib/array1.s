	.attribute	4, 16
	.attribute	5, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	.file	"array1.c"
	.option	push
	.option	arch, +a, +c, +d, +f, +zaamo, +zalrsc, +zicsr
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function main
.LCPI0_0:
	.quad	7378697629483820647             # 0x6666666666666667
	.text
	.globl	main
	.p2align	1
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sd	ra, 8(sp)                       # 8-byte Folded Spill
	li	a0, 0
	li	a3, 0
	lui	t0, %hi(array)
	addi	t0, t0, %lo(array)
	lui	a1, 7813
	lui	a6, 1953
	lui	a2, %hi(.LCPI0_0)
	addiw	t1, a1, -2048
	addiw	a4, a6, 512
	ld	t2, %lo(.LCPI0_0)(a2)
	li	a7, 10
	lui	a1, 244
	addiw	t3, a1, 568
	mv	a2, t0
.LBB0_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	mv	t4, a3
	#APP
	jre	.Ltmp0
	#NO_APP
	slli	a1, a0, 6
	add	a1, a1, t0
	add	a3, a1, t1
	mv	a5, t4
	mv	a1, a2
.LBB0_2:                                # %for.body3
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	sd	a5, 0(a1)
	add	a1, a1, a4
	addi	a5, a5, 1
	bne	a1, a3, .LBB0_2
.Ltmp0:                                 # Block address taken
# %bb.3:                                # %dest
                                        #   in Loop: Header=BB0_1 Depth=1
	slli	a1, t4, 3
	add	a1, a1, t0
	add	a3, a1, a6
	ld	a3, 592(a3)
	mulh	a5, a3, t2
	srli	t5, a5, 63
	srai	a5, a5, 2
	add	a5, a5, t5
	mul	a5, a5, a7
	sub	a3, a3, a5
	sd	a3, 72(a1)
	#APP
	fence.re.end
	#NO_APP
	addi	a3, t4, 8
	addi	a2, a2, 64
	addi	a0, a0, 1
	bltu	t4, t3, .LBB0_1
# %bb.4:                                # %for.end24
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
	li	a0, 0
	ld	ra, 8(sp)                       # 8-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.option	pop
	.type	array,@object                   # @array
	.bss
	.globl	array
	.p2align	3, 0x0
array:
	.zero	32000000
	.size	array, 32000000

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Done!"
	.size	.L.str, 6

	.ident	"clang version 20.1.4 (git@github.com:suhipek/llvm-project.git fff63b5c18419c3a76ee7a0201549f526ae46613)"
	.section	".note.GNU-stack","",@progbits
