TARGET_DIR := target
RAMDISK := $(TARGET_DIR)/ramdisk.dmg
RDSK_RAMDISK := $(TARGET_DIR)/ramdisk_rdsk.dmg
RDSK_MAKER := rdsk_maker/rdsk_maker

.PHONY: all ramdisk rdsk clean

all: genPayload target/iboot_p1.bin target/untether.bin $(RAMDISK) $(RDSK_RAMDISK)

genPayload: main.c hfs.h $(TARGET_DIR)/target.h \
	$(TARGET_DIR)/payload.bin $(TARGET_DIR)/nettoyeur.bin
	@gcc -o genPayload main.c -I. -I$(TARGET_DIR) -std=c23

$(RAMDISK): genPayload $(TARGET_DIR)/ramdisk_base.dmg \
	$(TARGET_DIR)/payload.bin $(TARGET_DIR)/nettoyeur.bin
	@./genPayload $(TARGET_DIR)/ramdisk_base.dmg $@
	@cp $@ ramdisk.dmg

ramdisk: $(RAMDISK)

$(RDSK_MAKER): rdsk_maker/rdsk_maker.c rdsk_maker/header.h rdsk_maker/plog.h
	@gcc -O2 -o $@ rdsk_maker/rdsk_maker.c

$(RDSK_RAMDISK): $(RDSK_MAKER) $(RAMDISK) $(TARGET_DIR)/iboot_p1.bin $(TARGET_DIR)/untether.bin
	@$(RDSK_MAKER) $(RAMDISK) $@ $(TARGET_DIR)/iboot_p1.bin $(TARGET_DIR)/untether.bin
	@cp $@ rdsk.dmg

rdsk: $(RDSK_RAMDISK)

$(TARGET_DIR)/payload.bin: $(TARGET_DIR)/payload.S
	@arm-none-eabi-as -march=armv7-a -mthumb -o $(TARGET_DIR)/payload.elf -c $(TARGET_DIR)/payload.S
	@arm-none-eabi-objcopy -O binary $(TARGET_DIR)/payload.elf $@

$(TARGET_DIR)/nettoyeur.bin: $(TARGET_DIR)/nettoyeur.c
	@arm-none-eabi-gcc -march=armv7-a -mthumb -Wno-multichar -nostdlib -fno-builtin -fpie -Os -o $(TARGET_DIR)/nettoyeur.elf $(TARGET_DIR)/nettoyeur.c
	@arm-none-eabi-objcopy -O binary $(TARGET_DIR)/nettoyeur.elf $@

$(TARGET_DIR)/iboot_p1.bin: $(TARGET_DIR)/iboot_p1.s
	@arm-none-eabi-as -march=armv7-a -o $(TARGET_DIR)/iboot_p1.elf $(TARGET_DIR)/iboot_p1.s
	@arm-none-eabi-objcopy -O binary $(TARGET_DIR)/iboot_p1.elf $@

$(TARGET_DIR)/untether.bin: $(TARGET_DIR)/untether.s
	@arm-none-eabi-as -march=armv7-a -o $(TARGET_DIR)/untether.elf $(TARGET_DIR)/untether.s
	@arm-none-eabi-objcopy -O binary $(TARGET_DIR)/untether.elf $@

clean:
	@rm -f genPayload
	@rm -f $(TARGET_DIR)/*.bin
	@rm -f $(TARGET_DIR)/*.elf
	@rm -f $(RAMDISK)
	@rm -f ramdisk.dmg
	@rm -f $(RDSK_RAMDISK) rdsk.dmg
	@rm -f $(RDSK_MAKER)
