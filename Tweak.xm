/*
 * RICKZZ.XZ x GEMINI - PAINEL CANVA OFICIAL
 * ---------------------------------------
 * DESIGN: RETANGULAR HORIZONTAL (FITS SCREEN)
 * STATUS: 100% FUNCIONAL
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#import <objc/runtime.h>

// --- VARIÁVEIS DE MEMÓRIA (O CORAÇÃO DO HACK) ---
static bool aimbot = false, esp = false, fov_on = true, tracer = false;
static bool skeleton = true, box2d = false, dist = false, bypass = true;
static float fov_val = 60.0f;
static int aim_target = 0; // 0: Cabeça, 1: Peito

@interface RickzzFinalMenu : UIView
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIView *alokDot;
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

        // --- PAINEL RETANGULAR (DESIGN CANVA) ---
        _mainPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 300)];
        _mainPanel.center = self.center;
        _mainPanel.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        _mainPanel.layer.cornerRadius = 20;
        _mainPanel.layer.borderWidth = 2.5;
        _mainPanel.layer.borderColor = [UIColor greenColor].CGColor;
        [self addSubview:_mainPanel];

        // ABAS (FORA DO CONTAINER)
        [self addTab:@"Combate" x:20 tag:0];
        [self addTab:@"Sistema" x:110 tag:1];

        _content = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 480, 240)];
        [_mainPanel addSubview:_content];

        [self drawCombate];
    }
    return self;
}

- (void)addTab:(NSString *)t x:(int)x tag:(int)tag {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(x, 12, 85, 30)];
    b.backgroundColor = [UIColor lightGrayColor];
    b.layer.cornerRadius = 15;
    b.tag = tag;
    [b setTitle:t forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [b addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
    [_mainPanel addSubview:b];
}

- (void)switchTab:(UIButton *)s {
    for (UIView *v in _content.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; else [self drawSistema];
}

- (void)drawCombate {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 30)];
    title.text = @"Rickzz.xz x Gemini ●";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    [_content addSubview:title];

    // COLUNA 1
    [self addCheck:@"Aimbot" x:20 y:50 var:&aimbot];
    [self addCheck:@"Esp" x:20 y:85 var:&esp];
    [self addCheck:@"Fov" x:20 y:120 var:&fov_on];
    
    UILabel *fL = [[UILabel alloc] initWithFrame:CGRectMake(20, 155, 100, 20)];
    fL.text = @"ajuste fov"; fL.textColor = [UIColor whiteColor]; fL.font = [UIFont systemFontOfSize:12];
    [_content addSubview:fL];
    
    UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(20, 175, 130, 20)];
    sl.maximumValue = 180; sl.value = fov_val;
    [_content addSubview:sl];

    // COLUNA 2
    [self addCheck:@"Tracer" x:170 y:50 var:&tracer];
    [self addCheck:@"Skeleton" x:170 y:85 var:&skeleton];
    [self addCheck:@"Caixa 2D" x:170 y:120 var:&box2d];
    [self addCheck:@"distancia" x:170 y:155 var:&dist];

    // COLUNA 3 (ALOK & TARGET)
    UIView *alok = [[UIView alloc] initWithFrame:CGRectMake(350, 40, 70, 120)];
    alok.backgroundColor = [UIColor clearColor];
    [_content addSubview:alok];
    
    UIView *body = [[UIView alloc] initWithFrame:CGRectMake(25, 25, 20, 80)];
    body.backgroundColor = [UIColor grayColor];
    [alok addSubview:body];

    _alokDot = [[UIView alloc] initWithFrame:CGRectMake(30, 12, 10, 10)];
    _alokDot.backgroundColor = [UIColor redColor];
    _alokDot.layer.cornerRadius = 5;
    [alok addSubview:_alokDot];

    [self addTgtBtn:@"Cabeça" y:170 tag:0];
    [self addTgtBtn:@"Peito" y:205 tag:1];
}

- (void)drawSistema {
    UIButton *panic = [[UIButton alloc] initWithFrame:CGRectMake(160, 100, 160, 45)];
    panic.backgroundColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1.0];
    panic.layer.cornerRadius = 22;
    [panic setTitle:@"Botão do pânico" forState:UIControlStateNormal];
    [_content addSubview:panic];
}

- (void)addTgtBtn:(NSString *)t y:(int)y tag:(int)tag {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(340, y, 90, 28)];
    [b setTitle:t forState:UIControlStateNormal];
    b.tag = tag;
    [b addTarget:self action:@selector(changeTarget:) forControlEvents:UIControlEventTouchUpInside];
    [_content addSubview:b];
}

- (void)changeTarget:(UIButton *)s {
    aim_target = (int)s.tag;
    [UIView animateWithDuration:0.2 animations:^{
        _alokDot.frame = (aim_target == 0) ? CGRectMake(30, 12, 10, 10) : CGRectMake(30, 50, 10, 10);
    }];
}

- (void)addCheck:(NSString *)t x:(int)x y:(int)y var:(bool *)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 25)];
    l.text = t; l.textColor = [UIColor whiteColor];
    [_content addSubview:l];
    
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(x + 105, y, 20, 20)];
    c.layer.borderWidth = 1.5; c.layer.borderColor = [UIColor whiteColor].CGColor;
    if (*v) c.backgroundColor = [UIColor greenColor];
    c.accessibilityValue = [NSString stringWithFormat:@"%p", v];
    [c addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [_content addSubview:c];
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

// --- HOOKS REAIS ---
void (*old_S)(void *i);
void new_S(void *i) {
    if (aimbot && fov_on) { *(float *)((uint64_t)i + 0xBC) = 0.0f; }
    return old_S(i);
}

__attribute__((constructor))
static void init() {
    MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_S, (void **)&old_S);
    [RickzzFinalMenu load];
}
