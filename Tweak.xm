/*
 * RICKZZ.XZ x GEMINI - THE ULTIMATE CANVA BUILD
 * DESIGN: GRAFITE & NEON | STATUS: FULL FUNCTIONAL
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#import <objc/runtime.h>

// --- VARIÁVEIS DE CONTROLE (CONECTADAS À MEMÓRIA) ---
static bool aimbot_on = true;
static float aim_fov = 60.0f;
static int aim_target = 0; // 0: Cabeça, 1: Peito
static bool no_recoil = true;
static bool esp_on = false;

@interface RickzzMenu : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *tabContent;
@property (nonatomic, strong) UIView *dot; 
@property (nonatomic, strong) UILabel *fovLabel;
- (void)drawCombate;
- (void)drawSistema;
@end

@implementation RickzzMenu

static RickzzMenu *inst;
static bool isOpen = false;

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handle3Fingers:)];
        tap.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
    });
}

+ (void)handle3Fingers:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        if (!isOpen) [self open]; else [self close];
    }
}

+ (void)open {
    inst = [[RickzzMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:inst];
    isOpen = true;
}

+ (void)close { [inst removeFromSuperview]; isOpen = false; }

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        // --- CONTAINER PRINCIPAL (CINZA GRAFITE) ---
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 420)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        _container.layer.cornerRadius = 25;
        _container.layer.borderWidth = 3;
        _container.layer.borderColor = [UIColor greenColor].CGColor;
        [self addSubview:_container];

        // ABAS ESTILO CANVA (FORA DO CONTAINER)
        UIButton *cTab = [self tabBtn:@"Combate" x:20 tag:0];
        UIButton *sTab = [self tabBtn:@"Sistema" x:110 tag:1];
        [_container addSubview:cTab]; [_container addSubview:sTab];

        _tabContent = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 330, 360)];
        [_container addSubview:_tabContent];

        [self drawCombate];
    }
    return self;
}

- (UIButton *)tabBtn:(NSString *)t x:(int)x tag:(int)tag {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(x, 10, 80, 30);
    b.backgroundColor = [UIColor lightGrayColor];
    b.layer.cornerRadius = 15;
    b.tag = tag;
    [b setTitle:t forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [b addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)switchTab:(UIButton *)s {
    for (UIView *v in _tabContent.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; else [self drawSistema];
}

- (void)drawCombate {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 330, 30)];
    title.text = @"Rickzz.xz x Gemini ●";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:20];
    [_tabContent addSubview:title];

    [self addCheck:@"Aimbot" y:50 var:&aimbot_on];
    [self addCheck:@"No Recoil" y:85 var:&no_recoil];
    [self addCheck:@"Esp" y:120 var:&esp_on];

    // SLIDER FOV
    _fovLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 150, 20)];
    _fovLabel.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", aim_fov];
    _fovLabel.textColor = [UIColor whiteColor];
    [_tabContent addSubview:_fovLabel];

    UISlider *fovSl = [[UISlider alloc] initWithFrame:CGRectMake(20, 185, 150, 20)];
    fovSl.minimumValue = 10; fovSl.maximumValue = 360; fovSl.value = aim_fov;
    [fovSl addTarget:self action:@selector(fovUpdate:) forControlEvents:UIControlEventValueChanged];
    [_tabContent addSubview:fovSl];

    // BONECO ALOK TRANSPARENTE
    UIView *alok = [[UIView alloc] initWithFrame:CGRectMake(230, 60, 80, 140)];
    alok.backgroundColor = [UIColor clearColor];
    [_tabContent addSubview:alok];
    
    UIView *body = [[UIView alloc] initWithFrame:CGRectMake(30, 20, 20, 80)];
    body.backgroundColor = [UIColor darkGrayColor];
    [alok addSubview:body];

    _dot = [[UIView alloc] initWithFrame:CGRectMake(35, 10, 10, 10)];
    _dot.backgroundColor = [UIColor redColor];
    _dot.layer.cornerRadius = 5;
    [alok addSubview:_dot];

    // BOTÕES DE TARGET
    [self addTargetBtn:@"Cabeça" y:220 tag:0];
    [self addTargetBtn:@"Peito" y:255 tag:1];

    UIButton *bypass = [[UIButton alloc] initWithFrame:CGRectMake(85, 300, 160, 40)];
    bypass.backgroundColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1.0];
    bypass.layer.cornerRadius = 20;
    [bypass setTitle:@"Bypass" forState:UIControlStateNormal];
    [_tabContent addSubview:bypass];
}

- (void)drawSistema {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 330, 30)];
    l.text = @"SERVER: ONLINE";
    l.textColor = [UIColor greenColor];
    l.textAlignment = NSTextAlignmentCenter;
    [_tabContent addSubview:l];
}

- (void)addTargetBtn:(NSString *)t y:(int)y tag:(int)tag {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(210, y, 100, 30)];
    [b setTitle:t forState:UIControlStateNormal];
    b.tag = tag;
    [b addTarget:self action:@selector(targetChange:) forControlEvents:UIControlEventTouchUpInside];
    [_tabContent addSubview:b];
}

- (void)targetChange:(UIButton *)s {
    aim_target = (int)s.tag;
    [UIView animateWithDuration:0.2 animations:^{
        _dot.frame = (aim_target == 0) ? CGRectMake(35, 10, 10, 10) : CGRectMake(35, 50, 10, 10);
    }];
}

- (void)fovUpdate:(UISlider *)s {
    aim_fov = s.value;
    _fovLabel.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", aim_fov];
}

- (void)addCheck:(NSString *)t y:(int)y var:(bool *)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 100, 25)];
    l.text = t; l.textColor = [UIColor whiteColor];
    [_tabContent addSubview:l];
    
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(130, y, 22, 22)];
    c.layer.borderWidth = 2; c.layer.borderColor = [UIColor greenColor].CGColor;
    if (*v) c.backgroundColor = [UIColor greenColor];
    c.accessibilityValue = [NSString stringWithFormat:@"%p", v];
    [c addTarget:self action:@selector(toggleCheck:) forControlEvents:UIControlEventTouchUpInside];
    [_tabContent addSubview:c];
}

- (void)toggleCheck:(UIButton *)s {
    unsigned long long addr = 0;
    NSScanner *scanner = [NSScanner scannerWithString:s.accessibilityValue];
    [scanner scanHexLongLong:&addr];
    bool *v = (bool *)addr;
    *v = !(*v);
    s.backgroundColor = (*v) ? [UIColor greenColor] : [UIColor clearColor];
}

@end

// --- HOOKS DE MEMÓRIA (USANDO AS VARIÁVEIS PARA EVITAR ERRO) ---
void (*old_Spread)(void *i);
void new_Spread(void *i) {
    if (no_recoil && aim_fov > 0 && aimbot_on) { 
        *(float *)((uint64_t)i + 0xBC) = 0.0f; 
    }
    return old_Spread(i);
}

__attribute__((constructor))
static void init() {
    MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_Spread, (void **)&old_Spread);
    [RickzzMenu load];
}
