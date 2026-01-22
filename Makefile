ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TweakName = SystemData
$(TweakName)_FILES = Tweak.mm
$(TweakName)_FRAMEWORKS = UIKit Security CoreGraphics QuartzCore Foundation
$(TweakName)_CFLAGS = -fobjc-arc -Wno-unused-variable

include $(THEOS_MAKE_PATH)/tweak.mk
