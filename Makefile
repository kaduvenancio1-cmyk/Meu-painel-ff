ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Painel

# O NOME DO ARQUIVO ABAIXO DEVE SER tweak.mm
Painel_FILES = tweak.mm
Painel_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics
Painel_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
