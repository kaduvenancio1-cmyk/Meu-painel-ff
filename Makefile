# Arquiteturas para iOS moderno
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Painel

# O nome do arquivo abaixo DEVE ser exatamente igual ao arquivo na sua pasta
Painel_FILES = tweak.mm
Painel_FRAMEWORKS = UIKit Foundation Security QuartzCore
Painel_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
