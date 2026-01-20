ARCHS = arm64
TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KaduVIP
KaduVIP_FILES = Tweak.xm
KaduVIP_FRAMEWORKS = UIKit Foundation CoreGraphics
KaduVIP_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable

include $(THEOS_MAKE_PATH)/tweak.mk
