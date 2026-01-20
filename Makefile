TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = FreeFire

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MeuPainelFF

MeuPainelFF_FILES = Tweak.xm
MeuPainelFF_CFLAGS = -fobjc-arc
MeuPainelFF_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
