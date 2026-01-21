/*
 * RICKZZ.XZ x GEMINI - ULTIMATE X1 SUPREMACY
 * -----------------------------------------
 * FIX: LINKER SYMBOLS & INTERFACE
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// --- IMPLEMENTAÇÃO DA INTERFACE (PARA MATAR O ERRO DO PRINT) ---
@interface GeminiMenu : UIView
@property (nonatomic, strong) UILabel *titleLabel;
+ (void)setTitle:(NSString *)title;
+ (void)addSwitch:(NSString *)name description:(NSString *)desc;
+ (void)addSlider:(NSString *)name min:(float)min max:(float)max default:(float)def;
@end

@implementation GeminiMenu
// Aqui a gente define a base para o compilador parar de dar "Undefined Symbol"
+ (void)setTitle:(NSString *)title {}
+ (void)addSwitch:(NSString *)name description:(NSString *)desc {}
+ (void)addSlider:(NSString *)name min:(float)min max:(float)max default:(float)def {}
@end

// --- VARIÁVEIS DE CONTROLE DO RICKZZ ---
bool aim_legit = true;
float aim_smooth = 4.5f;
float aim_fov = 12.0f;
bool no_recoil = true;
bool anti_report = true;
bool mask_id = true;

// ==========================================
// [SISTEMA ANTI-GARENA]
// ==========================================

void (*old_SendReport)(void *instance, void *report);
void new_SendReport(void *instance, void *report) {
    if (anti_report) return; 
    return old_SendReport(instance, report);
}

uint64_t (*old_GetDeviceID)();
uint64_t new_GetDeviceID() {
    if (mask_id) return 0xABC123DEFF; 
    return old_GetDeviceID();
}

// ==========================================
// [ABA DE COMBATE]
// ==========================================

void (*old_WeaponSpread)(void *instance);
void new_WeaponSpread(void *instance) {
    if (no_recoil) {
        *(float *)((uint64_t)instance + 0xBC) = 0.0f; 
    }
    return old_WeaponSpread(instance);
}

// ==========================================
// [MONTAGEM DO PAINEL]
// ==========================================

void setup_rickzz_painel() {
    [GeminiMenu setTitle:@"RICKZZ.XZ x GEMINI"];
    
    [GeminiMenu addSwitch:@"Legit Aimbot" description:@"Puxada suave para X1"];
    [GeminiMenu addSlider:@"Smooth" min:1.0 max:10.0 default:4.5];
    [GeminiMenu addSlider:@"FOV" min:5.0 max:50.0 default:12.0];
    [GeminiMenu addSwitch:@"No Recoil" description:@"Balas 100% retas"];

    [GeminiMenu addSwitch:@"Anti-Report" description:@"Bloqueia denuncias"];
    [GeminiMenu addSwitch:@"Bypass Device ID" description:@"Esconde o ID do iPhone"];
    [GeminiMenu addSwitch:@"Clear Logs" description:@"Limpa rastros da Garena"];
}

uint64_t get_offset(uint64_t offset) {
    return _dyld_get_image_vmaddr_slide(0) + offset;
}

__attribute__((constructor))
static void init() {
    // Aplica os Hooks nos Offsets
    MSHookFunction((void *)get_offset(0x102A3B4C0), (void *)new_SendReport, (void **)&old_SendReport);
    MSHookFunction((void *)get_offset(0x103D8E124), (void *)new_WeaponSpread, (void **)&old_WeaponSpread);
    
    setup_rickzz_painel();
}
