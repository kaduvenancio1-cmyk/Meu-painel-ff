ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MeuPainel
MeuPainel_FILES = Tweak.xm
MeuPainel_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
