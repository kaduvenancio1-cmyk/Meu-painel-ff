/*
 * RICKZZ.XZ x GEMINI - SUPREMACIA X1
 * -----------------------------------------
 * VERSÃO: CANVA STYLE | GESTURE: 3 FINGERS
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// --- VARIÁVEIS COM ATRIBUTO PARA NÃO DAR ERRO DE 'UNUSED' ---
static __attribute__((unused)) bool aimbot_on = true;
static __attribute__((unused)) float aim_fov = 12.0f;
static __attribute__((unused)) float aim_smooth = 4.5f;
static __attribute__((unused)) bool no_recoil = true;
static __attribute__((unused)) bool anti_report = true;

@interface RickzzMenu : UIView
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UIView *contentArea;
@end

@implementation RickzzMenu

static RickzzMenu *menuInstance;
static bool isVisible = false;

// Inicializa o Gesto de 3 Dedos
+ (void)setup {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
        
        // Alerta de sucesso (O que você já viu)
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"RICKZZ.XZ x GEMINI" 
                                    message:@"PAINEL INJETADO!\n3 Dedos para abrir o Canva." 
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"BORA PRO X1" style:UIAlertActionStyleDefault handler:nil]];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

+ (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (!isVisible) [self show]; else [self hide];
    }
}

+ (void)show {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    menuInstance = [[RickzzMenu alloc] initWithFrame:win.bounds];
    [win addSubview:menuInstance];
    isVisible = true;
}

+ (void)hide {
    [menuInstance removeFromSuperview];
    isVisible = false;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        // PAINEL ESTILO CANVA
        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.10 alpha:0.98];
        _panel.layer.cornerRadius = 20;
        _panel.layer.borderColor = [UIColor greenColor].CGColor;
        _panel.layer.borderWidth = 2.0;
        [self addSubview:_panel];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 30)];
        title.text = @"RICKZZ.XZ - CANVA MENU";
        title.textColor = [UIColor greenColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:18];
        [_panel addSubview:title];

        _contentArea = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 300, 200)];
        [_panel addSubview:_contentArea];

        [self loadControls];
    }
    return self;
}

- (void)loadControls {
    // SLIDER FOV (Conectado à variável)
    UILabel *fLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
    fLab.text = [NSString stringWithFormat:@"AIM FOV: %.1f", aim_fov];
    fLab.textColor = [UIColor whiteColor];
    [_contentArea addSubview:fLab];

    UISlider *fSlide = [[UISlider alloc] initWithFrame:CGRectMake(10, 35, 280, 20)];
    fSlide.minimumValue = 1.0; fSlide.maximumValue = 180.0; fSlide.value = aim_fov;
    fSlide.minimumTrackTintColor = [UIColor greenColor];
    [fSlide addTarget:self action:@selector(fovCh:label:) forControlEvents:UIControlEventValueChanged];
    [_contentArea addSubview:fSlide];
    
    // SWITCH NO RECOIL
    UILabel *rLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 200, 30)];
    rLab.text = @"NO RECOIL (Bala Reta)";
    rLab.textColor = [UIColor whiteColor];
    [_contentArea addSubview:rLab];
    
    UISwitch *rSw = [[UISwitch alloc] initWithFrame:CGRectMake(230, 80, 0, 0)];
    rSw.on = no_recoil;
    rSw.onTintColor = [UIColor greenColor];
    [rSw addTarget:self action:@selector(recSw:) forControlEvents:UIControlEventValueChanged];
    [_contentArea addSubview:rSw];
}

- (void)fovCh:(UISlider *)s label:(UILabel *)l { aim_fov = s.value; }
- (void)recSw:(UISwitch *)s { no_recoil = s.on; }

@end

// --- HOOKS DE MEMÓRIA ---
void (*old_WeaponSpread)(void *instance);
void new_WeaponSpread(void *instance) {
    if (no_recoil) {
        *(float *)((uint64_t)instance + 0xBC) = 0.0f; 
    }
    return old_WeaponSpread(instance);
}

__attribute__((constructor))
static void init() {
    MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_WeaponSpread, (void **)&old_WeaponSpread);
    [RickzzMenu setup];
}
