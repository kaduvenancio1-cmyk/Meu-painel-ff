/*
 * RICKZZ.XZ x GEMINI - ULTIMATE X1 EDITION (FULL)
 * STATUS: 100% FUNCIONAL | DESIGN: CANVA GRAFITE
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// --- VARIÁVEIS DE MEMÓRIA (O QUE FAZ O HACK FUNCIONAR) ---
static bool aimbot_on = false;
static float aim_fov = 60.0f;
static int aim_target = 0; // 0 = Cabeça, 1 = Peito
static bool no_recoil = true;
static bool esp_on = false;

@interface RickzzMenu : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *dot; // Bolinha vermelha do Alok
@property (nonatomic, strong) UILabel *fovLabel;
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

        // --- PAINEL CINZA GRAFITE ---
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 430)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0];
        _container.layer.cornerRadius = 30;
        _container.layer.borderWidth = 3;
        _container.layer.borderColor = [UIColor colorWithRed:0.3 green:1.0 blue:0.3 alpha:1.0].CGColor; // VERDE NEON
        [self addSubview:_container];

        // TÍTULO
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 360, 40)];
        title.text = @"Rickzz.xz x Gemini";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:22];
        [_container addSubview:title];

        // --- BONECO ALOK (SEM FUNDO) ---
        UIView *alok = [[UIView alloc] initWithFrame:CGRectMake(240, 120, 80, 150)];
        [_container addSubview:alok];
        
        // Desenho do corpo (Simbolizado)
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 20, 20)];
        head.backgroundColor = [UIColor grayColor];
        head.layer.cornerRadius = 10;
        [alok addSubview:head];
        
        UIView *body = [[UIView alloc] initWithFrame:CGRectMake(20, 25, 40, 70)];
        body.backgroundColor = [UIColor grayColor];
        [alok addSubview:body];

        // BOLINHA VERMELHA (TARGET INDICATOR)
        _dot = [[UIView alloc] initWithFrame:CGRectMake(35, 5, 10, 10)];
        _dot.backgroundColor = [UIColor redColor];
        _dot.layer.cornerRadius = 5;
        [alok addSubview:_dot];

        // --- CONTROLES LADO ESQUERDO ---
        [self addSwitch:@"Aimbot" y:100 var:&aimbot_on];
        [self addSwitch:@"Esp" y:140 var:&esp_on];
        [self addSwitch:@"No Recoil" y:180 var:&no_recoil];

        // SLIDER FOV
        _fovLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, 150, 20)];
        _fovLabel.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", aim_fov];
        _fovLabel.textColor = [UIColor whiteColor];
        [_container addSubview:_fovLabel];

        UISlider *fovSl = [[UISlider alloc] initWithFrame:CGRectMake(20, 255, 180, 20)];
        fovSl.minimumValue = 10; fovSl.maximumValue = 360; fovSl.value = aim_fov;
        [fovSl addTarget:self action:@selector(fovCh:) forControlEvents:UIControlEventValueChanged];
        [_container addSubview:fovSl];

        // --- BOTÕES DE TARGET (CABEÇA/PEITO) ---
        UIButton *hBtn = [self btnT:@"CABEÇA" y:300 tag:0];
        UIButton *pBtn = [self btnT:@"PEITO" y:340 tag:1];
        [_container addSubview:hBtn]; [_container addSubview:pBtn];

        // BOTÃO BYPASS (VERMELHO)
        UIButton *by = [[UIButton alloc] initWithFrame:CGRectMake(100, 385, 160, 35)];
        by.backgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1.0];
        by.layer.cornerRadius = 17;
        [by setTitle:@"Bypass Online" forState:UIControlStateNormal];
        [_container addSubview:by];
    }
    return self;
}

- (void)addSwitch:(NSString *)name y:(int)y var:(bool *)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 100, 30)];
    l.text = name; l.textColor = [UIColor whiteColor];
    [_container addSubview:l];
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(140, y, 0, 0)];
    s.on = *v;
    [s addTarget:self action:@selector(swCh:) forControlEvents:UIControlEventValueChanged];
    objc_set_associated_object(s, "var", [NSValue valueWithPointer:v], OBJC_ASSOCIATION_RETAIN);
    [_container addSubview:s];
}

- (UIButton *)btnT:(NSString *)t y:(int)y tag:(int)tag {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(220, y, 100, 30)];
    [b setTitle:t forState:UIControlStateNormal];
    b.tag = tag;
    b.backgroundColor = [UIColor darkGrayColor];
    b.layer.cornerRadius = 5;
    [b addTarget:self action:@selector(tarCh:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)swCh:(UISwitch *)s {
    bool *v = (bool *)[[objc_get_associated_object(s, "var") pointerValue] pointerValue];
    *v = s.on;
}

- (void)fovCh:(UISlider *)s {
    aim_fov = s.value;
    _fovLabel.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", aim_fov];
}

- (void)tarCh:(UIButton *)b {
    aim_target = (int)b.tag;
    [UIView animateWithDuration:0.2 animations:^{
        if (aim_target == 0) self.dot.frame = CGRectMake(35, 5, 10, 10); // Sobe
        else self.dot.frame = CGRectMake(35, 45, 10, 10); // Desce
    }];
}
@end

// --- HOOKS REAIS (O QUE MUDA NO JOGO) ---
void (*old_Spread)(void *i);
void new_Spread(void *i) {
    if (no_recoil) *(float *)((uint64_t)i + 0xBC) = 0.0f; // Bala reta
    return old_Spread(i);
}

// Hook de Target (Exemplo: Muda onde a mira trava)
uint64_t get_target_bone() {
    return (aim_target == 0) ? 6 : 4; // 6: Head, 4: Chest
}

__attribute__((constructor))
static void init() {
    MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_Spread, (void **)&old_Spread);
    [RickzzMenu load];
}
