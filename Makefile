ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TweakName = SystemData
$(TweakName)_FILES = Tweak.xm
$(TweakName)_FRAMEWORKS = UIKit Security CoreGraphics QuartzCore
$(TweakName)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
