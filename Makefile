ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Painel

# O nome abaixo deve ser EXATAMENTE Tweak.mm (com T maiúsculo)
Painel_FILES = Tweak.mm
Painel_FRAMEWORKS = UIKit Foundation Security QuartzCore
Painel_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
