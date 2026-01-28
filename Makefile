# Desativa a otimização de tamanho e mantém os símbolos
DEBUG = 1
FINALPACKAGE = 0
GO_EASY_ON_ME = 1

# Força o linker a NÃO limpar o arquivo (Isso vai explodir o tamanho!)
Painel_LDFLAGS += -Wl,-dead_strip_off -Wl,-no_compact_unwind
