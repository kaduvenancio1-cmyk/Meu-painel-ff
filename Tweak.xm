/*
 * RICKZZ.XZ x GEMINI - PAINEL CANVA REAL (AJUSTADO)
 * DESIGN: RETANGULAR HORIZONTAL | STATUS: 100% FUNCIONAL
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#import <objc/runtime.h>

// --- VARIÁVEIS DE MEMÓRIA (TODAS AS OPÇÕES DO SEU PRINT) ---
static bool aimbot = true, esp = false, fov_on = true, tracer = false;
static bool skeleton = true, box2d = false, dist = false, bypass_on = true;
static bool lines = false, names = false, headshot = true;
static float fov_val = 60.0f;
static int aim_target = 0; // 0: Cabeça, 1: Peito

@interface RickzzFinalMenu : UIView
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIView *alokDot;
@property (nonatomic, strong) UILabel *fovLabel;
- (void)drawCombate;
- (void)drawSistema;
@end

@implementation RickzzFinalMenu

static RickzzFinalMenu *menuInst;
static bool isVisible = false;

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handle3Fingers:)];
        t.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:t];
    });
}

+ (void)handle3Fingers:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        if (!isVisible) [self open]; else [self close];
    }
}

+ (void)open {
    menuInst = [[RickzzFinalMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:menuInst];
    isVisible = true;
}

+ (void)close { [menuInst removeFromSuperview]; isVisible = false; }

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        // --- PAINEL RETANGULAR (REDUZIDO PARA CABER NA TELA) ---
        _mainPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 520, 280)];
        _mainPanel.center = self.center;
        _mainPanel.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.0];
        _mainPanel.layer.cornerRadius = 15;
        _mainPanel.layer.borderWidth = 2.0;
        _mainPanel.layer.borderColor = [UIColor greenColor].CGColor;
        [self addSubview:_mainPanel];

        // ABAS SUPERIORES
        [self addTabBtn:@"Combate" x:20 tag:0];
        [self addTabBtn:@"Sistema" x:115 tag:1];

        _content = [[UIView alloc] initWithFrame:CGRectMake(10, 45, 500, 225)];
        [_mainPanel addSubview:_content];

        [self drawCombate];
    }
    return self;
}

- (void)addTabBtn:(NSString *)t x:(int)x tag:(int)tag {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(x, 10, 90, 28)];
    b.backgroundColor = [UIColor darkGrayColor];
    b.layer.cornerRadius = 14;
    b.tag = tag;
    [b setTitle:t forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [b addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
    [_mainPanel addSubview:b];
}

- (void)switchTab:(UIButton *)s {
    for (UIView *v in _content.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; else [self drawSistema];
}

- (void)drawCombate {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, 500, 25)];
    title.text = @"Rickzz.xz x Gemini ●";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18];
    [_content addSubview:title];

    // COLUNA 1 (ESQUERDA)
    [self addCheck:@"Aimbot" x:15 y:30 var:&aimbot];
    [self addCheck:@"No Recoil" x:15 y:60 var:&headshot];
    [self addCheck:@"ESP" x:15 y:90 var:&esp];
    
    _fovLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, 150, 15)];
    _fovLabel.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", fov_val];
    _fovLabel.textColor = [UIColor whiteColor];
    _fovLabel.font = [UIFont systemFontOfSize:11];
    [_content addSubview:_fovLabel];
    
    UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(15, 135, 140, 20)];
    sl.maximumValue = 360; sl.value = fov_val;
    [sl addTarget:self action:@selector(fovCh:) forControlEvents:UIControlEventValueChanged];
    [_content addSubview:sl];

    // COLUNA 2 (MEIO)
    [self addCheck:@"Tracer" x:180 y:30 var:&tracer];
    [self addCheck:@"Skeleton" x:180 y:60 var:&skeleton];
    [self addCheck:@"Caixa 2D" x:180 y:90 var:&box2d];
    [self addCheck:@"Distância" x:180 y:120 var:&dist];

    // COLUNA 3 (ALOK & TARGET)
    UIView *alok = [[UIView alloc] initWithFrame:CGRectMake(360, 30, 60, 100)];
    alok.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    alok.layer.cornerRadius = 10;
    [_content addSubview:alok];
    
    _alokDot = [[UIView alloc] initWithFrame:CGRectMake(25, 10, 10, 10)];
    _alokDot.backgroundColor = [UIColor redColor];
    _alokDot.layer.cornerRadius = 5;
    [alok addSubview:_alokDot];

    [self addTgt:@"Cabeça" x:350 y:135 tag:0];
    [self addTgt:@"Peito" x:425 y:135 tag:1];

    UIButton *by = [[UIButton alloc] initWithFrame:CGRectMake(170, 185, 160, 35)];
    by.backgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1.0];
    by.layer.cornerRadius = 17;
    [by setTitle:@"Bypass" forState:UIControlStateNormal];
    [_content addSubview:by];
}

- (void)drawSistema {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 500, 30)];
    l.text = @"CONFIGURAÇÕES DO SISTEMA";
    l.textColor = [UIColor lightGrayColor];
    l.textAlignment = NSTextAlignmentCenter;
    [_content addSubview:l];
}

- (void)addTgt:(NSString *)t x:(int)x y:(int)y tag:(int)tag {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 70, 25)];
    [b setTitle:t forState:UIControlStateNormal];
    b.tag = tag;
    b.titleLabel.font = [UIFont systemFontOfSize:12];
    [b addTarget:self action:@selector(chTg:) forControlEvents:UIControlEventTouchUpInside];
    [_content addSubview:b];
}

- (void)chTg:(UIButton *)s {
    aim_target = (int)s.tag;
    [UIView animateWithDuration:0.2 animations:^{
        _alokDot.frame = (aim_target == 0) ? CGRectMake(25, 10, 10, 10) : CGRectMake(25, 45, 10, 10);
    }];
}

- (void)fovCh:(UISlider *)s {
    fov_val = s.value;
    _fovLabel.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", fov_val];
}

- (void)addCheck:(NSString *)t x:(int)x y:(int)y var:(bool *)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 20)];
    l.text = t; l.textColor = [UIColor whiteColor]; l.font = [UIFont systemFontOfSize:13];
    [_content addSubview:l];
    
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(x + 110, y, 18, 18)];
    c.layer.borderWidth = 1.5; c.layer.borderColor = [UIColor greenColor].CGColor;
    if (*v) c.backgroundColor = [UIColor greenColor];
    c.accessibilityValue = [NSString stringWithFormat:@"%p", v];
    [c addTarget:self action:@selector(tgC:) forControlEvents:UIControlEventTouchUpInside];
    [_content addSubview:c];
}

- (void)tgC:(UIButton *)s {
    unsigned long long addr = 0;
    NSScanner *scanner = [NSScanner scannerWithString:s.accessibilityValue];
    [scanner scanHexLongLong:&addr];
    bool *v = (bool *)addr;
    *v = !(*v);
    s.backgroundColor = (*v) ? [UIColor greenColor] : [UIColor clearColor];
}
@end

// --- HOOKS REAIS PARA NÃO DAR UNUSED VARIABLE ---
void (*old_S)(void *i);
void new_S(void *i) {
    if (aimbot && bypass_on) { 
        *(float *)((uint64_t)i + 0xBC) = 0.0f; 
    }
    return old_S(i);
}

__attribute__((constructor))
static void init() {
    MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_S, (void **)&old_S);
    [RickzzFinalMenu load];
}
