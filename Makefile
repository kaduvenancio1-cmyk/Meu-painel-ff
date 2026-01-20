ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SystemData
# Aqui mudamos o nome para parecer um arquivo do sistema do iPhone
SystemData_FILES = Tweak.xm
SystemData_CFLAGS = -fobjc-arc
SystemData_FRAMEWORKS = UIKit Foundation Security QuartzCore

include $(THEOS)/makefiles/tweak.mk
