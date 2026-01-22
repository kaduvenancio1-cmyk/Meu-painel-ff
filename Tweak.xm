/*
 * RICKZZ.XZ - PAINEL VIP V3 (FIX COMPILAÇÃO)
 */

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#include <substrate.h>

// Variáveis de controle
static bool aim = false;
static bool byp_on = false;
static bool l_cache = false;
static bool a_report = false;
static bool no_recoil = false;
static float fov_val __attribute__((unused)) = 60.0f;
static int aim_tgt __attribute__((unused)) = 0; 

// --- KEYCHAIN KILLER ---
void deep_clean_id() {
    NSDictionary *spec = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)spec);
    NSString *docs = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    [[NSFileManager defaultManager] removeItemAtPath:[docs stringByAppendingPathComponent:@"com.garena.msdk"] error:nil];
}

// --- INTERFACE DO MENU ---
@interface RickzzFinalMenu : UIView
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIView *alokDot;
@end

@implementation RickzzFinalMenu
static RickzzFinalMenu *inst;

// Função que o Theos executa ao iniciar o app
static void __attribute__((constructor)) initialize() {
    // Engana o Bundle ID para evitar ban de 3 segundos
    MSHookMessageEx(NSClassFromString(@"NSBundle"), @selector(bundleIdentifier), imp_implementationWithBlock(^NSString* (id self) {
        return @"com.dts.freefireth";
    }), NULL);

    // Carrega o menu após 15 segundos
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzFinalMenu class] action:@selector(show)];
        t.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:t];
    });
}

+ (void)show {
    if(!inst) {
        inst = [[RickzzFinalMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[UIApplication sharedApplication].keyWindow addSubview:inst];
    } else { [inst removeFromSuperview]; inst = nil; }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 320)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.02 alpha:0.98];
        _bg.layer.cornerRadius = 20;
        _bg.layer.borderColor = [UIColor greenColor].CGColor;
        _bg.layer.borderWidth = 1.5;
        [self addSubview:_bg];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 560, 25)];
        title.text = @"RICKZZ.XZ - PREMIUM SYSTEM";
        title.textColor = [UIColor greenColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:16];
        [_bg addSubview:title];

        [self tabBtn:@"COMBATE" x:30 tag:0];
        [self tabBtn:@"VISUAL" x:130 tag:1];
        [self tabBtn:@"SISTEMA" x:230 tag:2];
        
        _content = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 540, 250)];
        [_bg addSubview:_content];
        [self drawCombate];
    }
    return self;
}

- (void)tabBtn:(NSString*)t x:(int)x tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(x, 40, 90, 25)];
    b.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    b.layer.cornerRadius = 6; b.tag = tg;
    [b setTitle:t forState:0]; b.titleLabel.font = [UIFont systemFontOfSize:10];
    [b addTarget:self action:@selector(swTab:) forControlEvents:64];
    [_bg addSubview:b];
}

- (void)swTab:(UIButton*)s {
    for (UIView *v in _content.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; 
    else if (s.tag == 1) [self drawVisual];
    else [self drawSistema];
}

- (void)drawCombate {
    [self ck:@"Auxílio de Mira" x:20 y:20 var:&aim];
    [self ck:@"No Recoil" x:20 y:55 var:&no_recoil];
    
    UIView *al = [[UIView alloc] initWithFrame:CGRectMake(400, 20, 80, 120)];
    al.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4]; al.layer.cornerRadius = 10;
    [_content addSubview:al];
    _alokDot = [[UIView alloc] initWithFrame:CGRectMake(35, 15, 10, 10)];
    _alokDot.backgroundColor = [UIColor greenColor]; _alokDot.layer.cornerRadius = 5;
    [al addSubview:_alokDot];
    [self tgtB:@"Cabeça" y:150 tag:0]; [self tgtB:@"Peito" y:190 tag:1];
}

- (void)drawVisual {
    [self ck:@"Linhas ESP" x:20 y:20 var:&l_cache];
}

- (void)drawSistema {
    [self ck:@"Bypass v1.20.9" x:20 y:20 var:&byp_on];
    [self ck:@"Anti-Blacklist" x:20 y:55 var:&a_report];
    [self ck:@"LIMPEZA RADICAL" x:20 y:90 var:&l_cache];
}

- (void)ck:(NSString*)t x:(int)x y:(int)y var:(bool*)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 180, 20)];
    l.text = t; l.textColor = [UIColor whiteColor];
    [_content addSubview:l];
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(x+200, y, 22, 22)];
    c.layer.borderWidth = 1; c.layer.borderColor = [UIColor greenColor].CGColor;
    if(*v) [c setTitle:@"✓" forState:0];
    c.accessibilityValue = [NSString stringWithFormat:@"%p", v];
    [c addTarget:self action:@selector(tgC:) forControlEvents:64]; [_content addSubview:c];
}

- (void)tgC:(UIButton*)s {
    unsigned long long addr = 0;
    [[NSScanner scannerWithString:s.accessibilityValue] scanHexLongLong:&addr];
    bool *v = (bool *)addr; *v = !(*v);
    [s setTitle:(*v ? @"✓" : @"") forState:0];
    if (l_cache) deep_clean_id();
}

- (void)tgtB:(NSString*)t y:(int)y tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(390, y, 100, 30)];
    [b setTitle:t forState:0]; b.tag = tg; b.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    b.layer.cornerRadius = 8; [b addTarget:self action:@selector(chT:) forControlEvents:64];
    [_content addSubview:b];
}

- (void)chT:(UIButton*)s {
    aim_tgt = (int)s.tag;
    _alokDot.frame = (aim_tgt == 0) ? CGRectMake(35, 15, 10, 10) : CGRectMake(35, 60, 10, 10);
}
@end
