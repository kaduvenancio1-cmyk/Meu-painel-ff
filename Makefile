export THEOS_DEVICE_IP = 127.0.0.1
TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KaduVIP

KaduVIP_FILES = Tweak.xm
KaduVIP_CFLAGS = -fobjc-arc
KaduVIP_FRAMEWORKS = UIKit Foundation CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
