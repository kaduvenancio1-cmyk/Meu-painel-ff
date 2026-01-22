ARCHS = arm64
TARGET = iphone:clang:latest:14.0
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TweakName = SystemData

# Isso aqui é o que faz o arquivo ganhar peso e ter o código dentro
SystemData_FILES = Tweak.mm
SystemData_FRAMEWORKS = UIKit Security CoreGraphics QuartzCore Foundation
SystemData_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
