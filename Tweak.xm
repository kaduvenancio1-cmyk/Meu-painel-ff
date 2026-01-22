/*
 * RICKZZ.XZ x GEMINI - SUPREMACIA X1 (FINAL BUILD)
 * -----------------------------------------
 * DESIGN: CANVA STYLE | GESTURE: 3 FINGERS
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// --- VARIÁVEIS DE CONTROLE (CONECTADAS AOS SLIDERS) ---
static bool aimbot_on = true;
static float aim_fov = 12.0f;
static float aim_smooth = 4.5f;
static bool no_recoil = true;
static bool anti_report = true;

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
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        // CONTAINER (DESIGN DO CANVA)
        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.12 alpha:0.95];
        _panel.layer.cornerRadius = 15;
        _panel.layer.borderColor = [UIColor greenColor].CGColor;
        _panel.layer.borderWidth = 1.5;
        [self addSubview:_panel];

        // ÁREA DE CONTEÚDO (ABAS)
        _contentArea = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 300, 180)];
        [_panel addSubview:_contentArea];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
        title.text = @"RICKZZ.XZ x GEMINI";
        title.textColor = [UIColor greenColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:18];
        [_panel addSubview:title];

        [self loadCombatTab];
    }
    return self;
}

- (void)loadCombatTab {
    // BOTÃO PARA FECHAR NO CANTO
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(280, 5, 30, 30);
    [close setTitle:@"X" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [close addTarget:[RickzzMenu class] action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_panel addSubview:close];

    // SLIDER FOV
    UILabel *fovLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
    fovLab.text = [NSString stringWithFormat:@"AIM FOV: %.1f", aim_fov];
    fovLab.textColor = [UIColor whiteColor];
    [_contentArea addSubview:fovLab];

    UISlider *fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 35, 280, 20)];
    fovSlider.minimumValue = 1.0; fovSlider.maximumValue = 180.0; fovSlider.value = aim_fov;
    [fovSlider addTarget:self action:@selector(fovChanged:) forControlEvents:UIControlEventValueChanged];
    [_contentArea addSubview:fovSlider];
}

- (void)fovChanged:(UISlider *)sender { aim_fov = sender.value; }

@end

// --- HOOKS DE MEMÓRIA (A MÁGICA DO X1) ---
void (*old_WeaponSpread)(void *instance);
void new_WeaponSpread(void *instance) {
    if (no_recoil) {
        *(float *)((uint64_t)instance + 0xBC) = 0.0f; 
    }
    return old_WeaponSpread(instance);
}

__attribute__((constructor))
static void init() {
    // Aplica Hooks com o Offset do Recoil
    MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_WeaponSpread, (void **)&old_WeaponSpread);
    
    // Inicia o Gesto de 3 Dedos
    [RickzzMenu setup];
}
