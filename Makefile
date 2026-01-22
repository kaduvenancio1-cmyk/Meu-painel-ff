ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TweakName = RickzzProject
$(TweakName)_FILES = Tweak.xm
$(TweakName)_FRAMEWORKS = UIKit Security
$(TweakName)_LDFLAGS = -lsubstrate
$(TweakName)_CFLAGS = -fobjc-arc -Wno-unused-variable -Wno-unused-function

include $(THEOS_MAKE_PATH)/tweak.mk
