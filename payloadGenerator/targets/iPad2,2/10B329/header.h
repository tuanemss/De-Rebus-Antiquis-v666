/*
 * header.h
 * Copyright (c) 2021 - 2023 @ kok3shidoll
 *
 *
 */

/* iPad2,2 - 10B329 [iBoot] */
#define EXPLOIT_BASE                0x45BCC     // PC register obtained by exploit
#define EXPLOIT_SECOND_BASE         0x45BEA     // Set second point to bypass overwriting by exploit
#define EXPLOIT_SWAP_BASE           0x458F0     // Exploit area is small, so set points somewhere else

/* iPad2,2 - 10B329 [NewiBoot] */
#define PAYLOAD_BASE                0x45100      // main_task() configured for new iBoot
#define PAYLOAD_BASE_SIZE           0x44         // sz

/* iPad2,2 - 10B329 [ramdisk] */
#define RDSK_PD_BASE                0x828
#define RDSK_PD_SECOND_BASE         0x846
#define RDSK_PD_SWAP_BASE           0x570

/* payload setting */
#define EXPLOIT_BASE_SIZE           0x1E
#define EXPLOIT_SECOND_BASE_SIZE    0x6A
#define EXPLOIT_SWAP_BASE_SIZE      0x34
