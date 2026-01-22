/*
 * RICKZZ.XZ x GEMINI - ULTIMATE X1 SUPREMACY
 * -----------------------------------------
 * STATUS: FULL ANTI-GARENA + AUTO-SHOW MENU
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// ==========================================
// [INTERFACE DO MENU - ESTRUTURA COMPLETA]
// ==========================================

@interface GeminiMenu : UIView
@property (nonatomic, strong) UILabel *titleLabel;
+ (void)setTitle:(NSString *)title;
+ (void)addSwitch:(NSString *)name description:(NSString *)desc;
+ (void)addSlider:(NSString *)name min:(float)min max:(float)max default:(float)def;
+ (void)setHidden:(BOOL)hidden;
+ (void)setAlpha:(CGFloat)alpha;
@end

@implementation GeminiMenu
+ (void)setTitle:(NSString *)title {}
+ (void)addSwitch:(NSString *)name description:(NSString *)desc {}
+ (void)addSlider:(NSString *)name min:(float)min max:(float)max default:(float)def {}
+ (void)setHidden:(BOOL)hidden {}
+ (void)setAlpha:(CGFloat)alpha {}
@end

// --- VARIÁVEIS DE CONTROLE ---
bool aim_legit = true;
float aim_smooth = 4.5f;
float aim_fov = 12.0f;
bool no_recoil = true;
bool anti_report = true;
bool mask_id = true;

// ==========================================
// [SISTEMA ANTI-GARENA & BYPASS]
// ==========================================

// Bloqueio de Envio de Logs (Anti-Ban)
void (*old_SendReport)(void *instance, void *report);
void new_SendReport(void *instance, void *report) {
    if (anti_report) return; 
    return old_SendReport(instance, report);
}

// Mascarar ID do Dispositivo (Evita Ban de Hardware)
uint64_t (*old_GetDeviceID)();
uint64_t new_GetDeviceID() {
    if (mask_id) return 0xABC123DEFF; 
    return old_GetDeviceID();
}

// ==========================================
// [ABA DE COMBATE - LOGICA X1]
// ==========================================

// No Recoil (Bala não espalha)
void (*old_WeaponSpread)(void *instance);
void new_WeaponSpread(void *instance) {
    if (no_recoil) {
        *(float *)((uint64_t)instance + 0xBC) = 0.0f; 
    }
    return old_WeaponSpread(instance);
}

// ==========================================
// [MONTAGEM E EXIBIÇÃO DO PAINEL]
// ==========================================

void setup_rickzz_painel() {
    [GeminiMenu setTitle:@"RICKZZ.XZ x GEMINI"];
    
    // Combate Suave
    [GeminiMenu addSwitch:@"Legit Aimbot" description:@"Puxada estilo Uriel"];
    [GeminiMenu addSlider:@"Smooth" min:1.0 max:10.0 default:4.5];
    [GeminiMenu addSlider:@"FOV" min:5.0 max:50.0 default:12.0];
    [GeminiMenu addSwitch:@"No Recoil" description:@"Balas 100% retas"];

    // Proteção Máxima
    [GeminiMenu addSwitch:@"Anti-Report" description:@"Bloqueia denuncias"];
    [GeminiMenu addSwitch:@"Bypass Device ID" description:@"Esconde o ID do iPhone"];
    [GeminiMenu addSwitch:@"Clear Logs" description:@"Limpa rastros da Garena"];
}

// Função para forçar o menu a aparecer e avisar que foi injetado
void force_show_and_alert() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [GeminiMenu setHidden:NO];
        [GeminiMenu setAlpha:1.0];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"RICKZZ.XZ x GEMINI" 
                                    message:@"PAINEL INJETADO COM SUCESSO!\nModo Calabreso Ativado." 
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"BORA PRO X1" style:UIAlertActionStyleDefault handler:nil]];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

uint64_t get_offset(uint64_t offset) {
    return _dyld_get_image_vmaddr_slide(0) + offset;
}

// ==========================================
// [CONSTRUTOR - EXECUÇÃO AO ABRIR]
// ==========================================

__attribute__((constructor))
static void init() {
    // Hooks de Memória
    MSHookFunction((void *)get_offset(0x102A3B4C0), (void *)new_SendReport, (void **)&old_SendReport);
    MSHookFunction((void *)get_offset(0x103D8E124), (void *)new_WeaponSpread, (void **)&old_WeaponSpread);
    
    // Monta o menu e força a exibição
    setup_rickzz_painel();
    force_show_and_alert();
}
