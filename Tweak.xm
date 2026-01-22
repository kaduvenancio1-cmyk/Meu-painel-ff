/*
 * RICKZZ.XZ x GEMINI - CANVA ULTIMATE EDITION
 * -----------------------------------------
 * DESIGN: GRAFITE & NEON | GESTURE: 3 FINGERS
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// --- VARIÁVEIS TÉCNICAS (CONECTADAS AO PAINEL) ---
static __attribute__((unused)) bool aimbot = false;
static __attribute__((unused)) bool esp = false;
static __attribute__((unused)) bool fov_on = true;
static __attribute__((unused)) float fov_val = 60.0f;
static __attribute__((unused)) bool skeleton = true;
static __attribute__((unused)) bool bypass_on = true;
static __attribute__((unused)) int target_part = 0; // 0: Cabeça, 1: Peito

@interface RickzzCanvaMenu : UIView
@property (nonatomic, strong) UIView *mainContainer;
@property (nonatomic, strong) UIView *tabContent;
@property (nonatomic, strong) UIButton *btnCombate;
@property (nonatomic, strong) UIButton *btnSistema;
@end

@implementation RickzzCanvaMenu

static RickzzCanvaMenu *menuInst;
static bool visible = false;

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handle3Fingers:)];
        tap.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
    });
}

+ (void)handle3Fingers:(UITapGestureRecognizer *)sg {
    if (sg.state == UIGestureRecognizerStateEnded) {
        if (!visible) [self open]; else [self close];
    }
}

+ (void)open {
    menuInst = [[RickzzCanvaMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:menuInst];
    visible = true;
}

+ (void)close { [menuInst removeFromSuperview]; visible = false; }

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        // --- CONTAINER PRINCIPAL (CINZA GRAFITE) ---
        _mainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 420)];
        _mainContainer.center = self.center;
        _mainContainer.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        _mainContainer.layer.cornerRadius = 25;
        _mainContainer.layer.borderWidth = 3.0;
        _mainContainer.layer.borderColor = [UIColor colorWithRed:0.4 green:1.0 blue:0.4 alpha:1.0].CGColor; // NEON
        [self addSubview:_mainContainer];

        // --- ABAS SUPERIORES ---
        _btnCombate = [self createTabBtn:@"Combate" x:20 tag:0];
        _btnSistema = [self createTabBtn:@"Sistema" x:110 tag:1];
        [_mainContainer addSubview:_btnCombate];
        [_mainContainer addSubview:_btnSistema];

        // --- TÍTULO ---
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 340, 40)];
        title.text = @"Rickzz.xz x Gemini ●";
        title.textColor = [UIColor blackColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont italicSystemFontOfSize:24 weight:UIFontWeightBold];
        [_mainContainer addSubview:title];

        _tabContent = [[UIView alloc] initWithFrame:CGRectMake(15, 100, 310, 240)];
        [_mainContainer addSubview:_tabContent];

        [self drawCombate];

        // --- BOTÃO BYPASS/PÂNICO ---
        UIButton *bypassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bypassBtn.frame = CGRectMake(85, 350, 170, 45);
        bypassBtn.backgroundColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1.0];
        bypassBtn.layer.cornerRadius = 22;
        [bypassBtn setTitle:@"Bypass" forState:UIControlStateNormal];
        [bypassBtn addTarget:self action:@selector(bypassTouch) forControlEvents:UIControlEventTouchUpInside];
        [_mainContainer addSubview:bypassBtn];
    }
    return self;
}

- (UIButton *)createTabBtn:(NSString *)txt x:(int)x tag:(int)tag {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(x, 10, 80, 30);
    b.backgroundColor = [UIColor lightGrayColor];
    b.layer.cornerRadius = 15;
    b.layer.borderWidth = 1;
    [b setTitle:txt forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:12];
    b.tag = tag;
    [b addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)switchTab:(UIButton *)s {
    for (UIView *v in _tabContent.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; else [self drawSistema];
}

- (void)drawCombate {
    [self addCheck:@"Aimbot" y:10 var:&aimbot];
    [self addCheck:@"Esp" y:45 var:&esp];
    [self addCheck:@"Fov" y:80 var:&fov_on];
    
    UILabel *adj = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 100, 20)];
    adj.text = @"ajuste fov"; adj.textColor = [UIColor blackColor];
    [_tabContent addSubview:adj];

    UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(10, 140, 120, 20)];
    sl.minimumValue = 10; sl.maximumValue = 180; sl.value = fov_val;
    sl.minimumTrackTintColor = [UIColor blackColor];
    [_tabContent addSubview:sl];

    [self addCheck:@"Tracer" x:160 y:10 var:&aimbot];
    [self addCheck:@"Skeleton" x:160 y:45 var:&skeleton];
    [self addCheck:@"Caixa 2D" x:160 y:80 var:&aimbot];
    [self addCheck:@"distancia" x:160 y:115 var:&aimbot];
}

- (void)addCheck:(NSString *)t y:(int)y var:(bool *)v { [self addCheck:t x:10 y:y var:v]; }
- (void)addCheck:(NSString *)t x:(int)x y:(int)y var:(bool *)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 25)];
    l.text = t; l.font = [UIFont boldSystemFontOfSize:18];
    [_tabContent addSubview:l];
    
    UIButton *c = [UIButton buttonWithType:UIButtonTypeCustom];
    c.frame = CGRectMake(x + 105, y, 22, 22);
    c.layer.borderWidth = 2; c.layer.borderColor = [UIColor blackColor].CGColor;
    if (*v) [c setBackgroundColor:[UIColor blackColor]];
    [_tabContent addSubview:c];
}

- (void)bypassTouch { bypass_on = !bypass_on; }

@end

// --- MEMORY HOOKS ---
void (*old_Spread)(void *i);
void new_Spread(void *i) { if (skeleton) *(float *)((uint64_t)i + 0xBC) = 0.0f; return old_Spread(i); }

__attribute__((constructor))
static void init() {
    MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_Spread, (void **)&old_Spread);
    [RickzzCanvaMenu load];
}
