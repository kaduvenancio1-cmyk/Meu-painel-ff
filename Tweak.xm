/*
 * RICKZZ.XZ x GEMINI - SUPREMACIA FINAL
 * DESIGN: GRAFITE NEON | BOLINHA DINÂMICA
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#import <objc/runtime.h>

// --- VARIÁVEIS DE CONTROLE ---
static bool aimbot_on = true;
static float aim_fov = 60.0f;
static int aim_target = 0; // 0: Cabeça, 1: Peito
static bool no_recoil = true;

@interface RickzzMenu : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *tabContent;
@property (nonatomic, strong) UIView *dot; 
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

        // FUNDO CINZA GRAFITE
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 430)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        _container.layer.cornerRadius = 30;
        _container.layer.borderWidth = 3;
        _container.layer.borderColor = [UIColor greenColor].CGColor; // BORDA NEON
        [self addSubview:_container];

        // ABAS SUPERIORES
        UIButton *cTab = [self tabBtn:@"Combate" x:20 tag:0];
        UIButton *sTab = [self tabBtn:@"Sistema" x:110 tag:1];
        [_container addSubview:cTab]; [_container addSubview:sTab];

        _tabContent = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 340, 350)];
        [_container addSubview:_tabContent];

        [self drawCombate];
    }
    return self;
}

- (UIButton *)tabBtn:(NSString *)t x:(int)x tag:(int)tag {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(x, 15, 80, 30);
    b.backgroundColor = [UIColor lightGrayColor];
    b.layer.cornerRadius = 15;
    b.tag = tag;
    [b setTitle:t forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)switchTab:(UIButton *)s {
    for (UIView *v in _tabContent.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; else [self drawSistema];
}

- (void)drawCombate {
    [self addCheck:@"Aimbot" y:10 var:&aimbot_on];
    [self addCheck:@"No Recoil" y:45 var:&no_recoil];

    // BONECO ALOK SEM FUNDO
    UIView *alok = [[UIView alloc] initWithFrame:CGRectMake(220, 10, 80, 140)];
    alok.backgroundColor = [UIColor clearColor];
    [_tabContent addSubview:alok];
    
    UIView *body = [[UIView alloc] initWithFrame:CGRectMake(30, 20, 20, 80)];
    body.backgroundColor = [UIColor darkGrayColor];
    [alok addSubview:body];

    // BOLINHA VERMELHA (TARGET)
    _dot = [[UIView alloc] initWithFrame:CGRectMake(35, 10, 10, 10)];
    _dot.backgroundColor = [UIColor redColor];
    _dot.layer.cornerRadius = 5;
    [alok addSubview:_dot];

    [self addTargetBtn:@"Cabeça" y:160 tag:0];
    [self addTargetBtn:@"Peito" y:190 tag:1];
}

- (void)drawSistema {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    l.text = @"Modo Streamer Ativo";
    l.textColor = [UIColor whiteColor];
    [_tabContent addSubview:l];
}

- (void)addTargetBtn:(NSString *)t y:(int)y tag:(int)tag {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(210, y, 90, 25)];
    [b setTitle:t forState:UIControlStateNormal];
    b.tag = tag;
    [b addTarget:self action:@selector(setAim:) forControlEvents:UIControlEventTouchUpInside];
    [_tabContent addSubview:b];
}

- (void)setAim:(UIButton *)s {
    aim_target = (int)s.tag;
    [UIView animateWithDuration:0.2 animations:^{
        // Move a bolinha conforme a seleção
        _dot.frame = (aim_target == 0) ? CGRectMake(35, 10, 10, 10) : CGRectMake(35, 50, 10, 10);
    }];
}

// CORREÇÃO FINAL PARA O ERRO DE PONTEIRO
- (void)addCheck:(NSString *)t y:(int)y var:(bool *)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 100, 25)];
    l.text = t; l.textColor = [UIColor whiteColor];
    [_tabContent addSubview:l];
    
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(130, y, 22, 22)];
    c.layer.borderWidth = 2; c.layer.borderColor = [UIColor greenColor].CGColor;
    if (*v) c.backgroundColor = [UIColor greenColor];
    
    // Armazena o endereço de forma segura para o compilador
    c.accessibilityValue = [NSString stringWithFormat:@"%p", v];
    [c addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [_tabContent addSubview:c];
}

- (void)toggle:(UIButton *)s {
    unsigned long long addr = 0;
    NSScanner *scanner = [NSScanner scannerWithString:s.accessibilityValue];
    [scanner scanHexLongLong:&addr];
    bool *v = (bool *)addr;
    *v = !(*v);
    s.backgroundColor = (*v) ? [UIColor greenColor] : [UIColor clearColor];
}

@end

__attribute__((constructor))
static void init() {
    [RickzzMenu load];
}
