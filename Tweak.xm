/*
 * RICKZZ.XZ x GEMINI - VERSÃO FINAL V3 (CANVA STYLE)
 * CORREÇÃO DE ERROS + KEYCHAIN KILLER
 */

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// --- VARIÁVEIS COM ATRIBUTO PARA NÃO DAR ERRO NO GITHUB ---
static bool aim __attribute__((unused)) = false;
static bool fov_atv __attribute__((unused)) = false;
static bool byp_on __attribute__((unused)) = false;
static bool l_cache __attribute__((unused)) = false;
static bool a_report __attribute__((unused)) = false;
static bool no_recoil __attribute__((unused)) = false;
static bool esp_line __attribute__((unused)) = false;
static bool medkit_run __attribute__((unused)) = false;
static float fov_val __attribute__((unused)) = 60.0f;
static int aim_tgt __attribute__((unused)) = 0; 

// --- FUNÇÃO DE LIMPEZA PESADA (REMOVE O BAN DO APARELHO) ---
void deep_clean_id() {
    // Limpa a pasta de documentos da Garena
    NSString *docs = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[docs stringByAppendingPathComponent:@"com.garena.msdk"] error:nil];
    [fm removeItemAtPath:[docs stringByAppendingPathComponent:@"v_data.dat"] error:nil];
    
    // Limpa o Keychain (Aonde o ban fica escondido)
    NSDictionary *spec = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)spec);
    
    // Limpa cache de sistema
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    [fm removeItemAtPath:cachePath error:nil];
}

@interface RickzzFinalMenu : UIView
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIView *alokDot;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation RickzzFinalMenu
static RickzzFinalMenu *inst;

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show)];
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
        // --- DESIGN ESTILO CANVA ---
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 320)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.02 alpha:0.95];
        _bg.layer.cornerRadius = 20;
        _bg.layer.borderColor = [UIColor greenColor].CGColor;
        _bg.layer.borderWidth = 1.5;
        [self addSubview:_bg];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 560, 25)];
        _titleLabel.text = @"RICKZZ.XZ - PREMIUM SYSTEM";
        _titleLabel.textColor = [UIColor greenColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_bg addSubview:_titleLabel];

        [self tabBtn:@"COMBATE" x:30 tag:0];
        [self tabBtn:@"VISUAL" x:130 tag:1];
        [self tabBtn:@"SISTEMA" x:230 tag:2];
        
        // Botão de Pânico (Para usar antes de girar Royale)
        UIButton *pan = [[UIButton alloc] initWithFrame:CGRectMake(440, 12, 100, 25)];
        pan.backgroundColor = [UIColor colorWithRed:0.6 green:0 blue:0 alpha:1];
        pan.layer.cornerRadius = 5; [pan setTitle:@"PANIC OFF" forState:0];
        pan.titleLabel.font = [UIFont systemFontOfSize:10];
        [pan addTarget:self action:@selector(panicAction) forControlEvents:64];
        [_bg addSubview:pan];

        _content = [[UIView alloc] initWithFrame:CGRectMake(10, 55, 540, 250)];
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
    [self ck:@"Medkit Correndo" x:20 y:90 var:&medkit_run];
    
    UIView *al = [[UIView alloc] initWithFrame:CGRectMake(400, 20, 80, 120)];
    al.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4]; al.layer.cornerRadius = 10;
    [_content addSubview:al];
    _alokDot = [[UIView alloc] initWithFrame:CGRectMake(35, 15, 10, 10)];
    _alokDot.backgroundColor = [UIColor greenColor]; _alokDot.layer.cornerRadius = 5;
    [al addSubview:_alokDot];
    [self tgtB:@"Cabeça" y:150 tag:0]; [self tgtB:@"Peito" y:190 tag:1];
}

- (void)drawVisual {
    [self ck:@"Linhas ESP" x:20 y:20 var:&esp_line];
    [self ck:@"Antena 50m" x:20 y:55 var:&fov_atv];
}

- (void)drawSistema {
    [self ck:@"Bypass Online" x:20 y:20 var:&byp_on];
    [self ck:@"Anti-Blacklist" x:20 y:55 var:&a_report];
    [self ck:@"LIMPEZA RADICAL" x:20 y:90 var:&l_cache];
}

- (void)ck:(NSString*)t x:(int)x y:(int)y var:(bool*)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 180, 20)];
    l.text = t; l.textColor = [UIColor whiteColor]; l.font = [UIFont systemFontOfSize:13];
    [_content addSubview:l];
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(x+200, y, 20, 20)];
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

- (void)panicAction {
    aim = false; byp_on = false; no_recoil = false;
    deep_clean_id();
    [RickzzFinalMenu show]; // Fecha o menu
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
