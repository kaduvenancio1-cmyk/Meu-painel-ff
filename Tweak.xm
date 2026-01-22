/*
 * RICKZZ.XZ x GEMINI - SUPREMACIA X1 (Gesto 3 Dedos)
 * -----------------------------------------
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// ==========================================
// [ESTRUTURA DO MENU - GESTO DE 3 DEDOS]
// ==========================================

@interface RickzzMenu : UIView
@property (nonatomic, strong) UIView *mainPanel;
+ (void)setupGesture;
@end

@implementation RickzzMenu

static RickzzMenu *menuInstance;
bool isMenuOpen = false;

// Variáveis das Funções
bool no_recoil = true;
bool anti_report = true;

+ (void)setupGesture {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        // Cria o Reconhecedor de Gesto (3 Dedos / 1 Toque)
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTap:)];
        tapGesture.numberOfTouchesRequired = 3; // OBRIGATÓRIO 3 DEDOS
        [keyWindow addGestureRecognizer:tapGesture];
        
        // Alerta para avisar que o gesto está pronto
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"RICKZZ.XZ" 
                                    message:@"SISTEMA PRONTO!\nUse 3 dedos para abrir o painel." 
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

+ (void)handleTripleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self toggleRickzzMenu];
    }
}

+ (void)toggleRickzzMenu {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (!isMenuOpen) {
        // CRIAR O PAINEL SE NÃO EXISTIR
        menuInstance = [[RickzzMenu alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
        menuInstance.center = keyWindow.center;
        menuInstance.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        menuInstance.layer.cornerRadius = 20;
        menuInstance.layer.borderWidth = 2;
        menuInstance.layer.borderColor = [UIColor greenColor].CGColor;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 280, 30)];
        title.text = @"RICKZZ.XZ x GEMINI";
        title.textColor = [UIColor greenColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:20];
        [menuInstance addSubview:title];
        
        UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 240, 150)];
        info.text = @"[+] NO RECOIL: ATIVO\n[+] ANTI-REPORT: ATIVO\n[+] BYPASS ID: ATIVO\n\n[ Dê 3 toques para fechar ]";
        info.textColor = [UIColor whiteColor];
        info.numberOfLines = 0;
        info.textAlignment = NSTextAlignmentCenter;
        [menuInstance addSubview:info];
        
        [keyWindow addSubview:menuInstance];
        isMenuOpen = true;
    } else {
        // FECHAR O PAINEL
        [menuInstance removeFromSuperview];
        isMenuOpen = false;
    }
}

@end

// ==========================================
// [FUNÇÕES DE MEMÓRIA - COMBATE E BYPASS]
// ==========================================

void (*old_SendReport)(void *instance, void *report);
void new_SendReport(void *instance, void *report) {
    if (anti_report) return; 
    return old_SendReport(instance, report);
}

void (*old_WeaponSpread)(void *instance);
void new_WeaponSpread(void *instance) {
    if (no_recoil) {
        *(float *)((uint64_t)instance + 0xBC) = 0.0f; 
    }
    return old_WeaponSpread(instance);
}

uint64_t get_offset(uint64_t offset) {
    return _dyld_get_image_vmaddr_slide(0) + offset;
}

// ==========================================
// [INICIALIZAÇÃO]
// ==========================================

__attribute__((constructor))
static void init() {
    // Aplica Hooks
    MSHookFunction((void *)get_offset(0x102A3B4C0), (void *)new_SendReport, (void **)&old_SendReport);
    MSHookFunction((void *)get_offset(0x103D8E124), (void *)new_WeaponSpread, (void **)&old_WeaponSpread);
    
    // Configura o gesto de 3 dedos
    [RickzzMenu setupGesture];
}
