#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#import <objc/runtime.h>

// --- VARIÁVEIS TÉCNICAS ---
static __attribute__((unused)) bool aimbot = false;
static __attribute__((unused)) bool esp = false;
static __attribute__((unused)) bool fov_on = true;
static __attribute__((unused)) float fov_val = 60.0f;
static __attribute__((unused)) bool skeleton = true;
static __attribute__((unused)) bool bypass_on = true;
static __attribute__((unused)) int aim_target = 0; // 0: Cabeça, 1: Peito

@interface RickzzCanvaMenu : UIView
@property (nonatomic, strong) UIView *mainContainer;
@property (nonatomic, strong) UIView *tabContent;
@property (nonatomic, strong) UIView *targetDot;
@property (nonatomic, strong) UIButton *btnCombate;
@property (nonatomic, strong) UIButton *btnSistema;
// Métodos declarados para evitar erro de 'no known selector'
- (void)drawCombate;
- (void)drawSistema;
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

        _mainContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 420)];
        _mainContainer.center = self.center;
        _mainContainer.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        _mainContainer.layer.cornerRadius = 25;
        _mainContainer.layer.borderWidth = 3.0;
        _mainContainer.layer.borderColor = [UIColor colorWithRed:0.4 green:1.0 blue:0.4 alpha:1.0].CGColor;
        [self addSubview:_mainContainer];

        _btnCombate = [self createTabBtn:@"Combate" x:20 tag:0];
        _btnSistema = [self createTabBtn:@"Sistema" x:110 tag:1];
        [_mainContainer addSubview:_btnCombate];
        [_mainContainer addSubview:_btnSistema];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 340, 40)];
        title.text = @"Rickzz.xz x Gemini";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:22]; // Corrigido erro de fonte
        [_mainContainer addSubview:title];

        _tabContent = [[UIView alloc] initWithFrame:CGRectMake(15, 100, 310, 240)];
        [_mainContainer addSubview:_tabContent];

        [self drawCombate];

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
    b.tag = tag;
    [b setTitle:txt forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)switchTab:(UIButton *)s {
    for (UIView *v in _tabContent.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; else [self drawSistema];
}

- (void)drawCombate {
    [self addCheck:@"Aimbot" y:10 var:&aimbot];
    [self addCheck:@"Skeleton" y:45 var:&skeleton];
    
    // Boneco Alok Simbolizado
    UIView *alok = [[UIView alloc] initWithFrame:CGRectMake(220, 20, 60, 100)];
    alok.backgroundColor = [UIColor darkGrayColor];
    alok.layer.cornerRadius = 10;
    [_tabContent addSubview:alok];
    
    _targetDot = [[UIView alloc] initWithFrame:CGRectMake(25, 10, 10, 10)];
    _targetDot.backgroundColor = [UIColor redColor];
    _targetDot.layer.cornerRadius = 5;
    [alok addSubview:_targetDot];
    
    UIButton *head = [self createTargetBtn:@"Cabeça" y:130 tag:0];
    UIButton *chest = [self createTargetBtn:@"Peito" y:160 tag:1];
    [_tabContent addSubview:head];
    [_tabContent addSubview:chest];
}

- (void)drawSistema {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    l.text = @"Modo Streamer";
    l.textColor = [UIColor whiteColor];
    [_tabContent addSubview:l];
}

- (UIButton *)createTargetBtn:(NSString *)t y:(int)y tag:(int)tag {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(210, y, 80, 25);
    b.tag = tag;
    [b setTitle:t forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:14];
    [b addTarget:self action:@selector(changeAimTarget:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)changeAimTarget:(UIButton *)s {
    aim_target = (int)s.tag;
    [UIView animateWithDuration:0.2 animations:^{
        if (aim_target == 0) _targetDot.frame = CGRectMake(25, 10, 10, 10);
        else _targetDot.frame = CGRectMake(25, 40, 10, 10);
    }];
}

- (void)addCheck:(NSString *)t y:(int)y var:(bool *)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, 25)];
    l.text = t; l.textColor = [UIColor whiteColor];
    [_tabContent addSubview:l];
    
    UIButton *c = [UIButton buttonWithType:UIButtonTypeCustom];
    c.frame = CGRectMake(120, y, 22, 22);
    c.layer.borderWidth = 2;
    c.layer.borderColor = [UIColor greenColor].CGColor;
    if (*v) c.backgroundColor = [UIColor greenColor];
    
    // Corrigido erro de Bad Receiver / Pointer
    objc_set_associated_object(c, "bool_ptr", [NSValue valueWithPointer:v], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [c addTarget:self action:@selector(toggleCheck:) forControlEvents:UIControlEventTouchUpInside];
    [_tabContent addSubview:c];
}

- (void)toggleCheck:(UIButton *)sender {
    NSValue *val = objc_get_associated_object(sender, "bool_ptr");
    bool *v = (bool *)[val pointerValue];
    *v = !(*v);
    sender.backgroundColor = (*v) ? [UIColor greenColor] : [UIColor clearColor];
}

- (void)bypassTouch { bypass_on = !bypass_on; }

@end

__attribute__((constructor))
static void init() {
    [RickzzCanvaMenu load];
}
