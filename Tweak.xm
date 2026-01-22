/*
 * RICKZZ.XZ x GEMINI - EDIÇÃO LUXO (VISUAL CANVA)
 * UNINDO DESIGN + KEYCHAIN KILLER + ANTI-BAN
 */

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// --- VARIÁVEIS DO SEU PROJETO ---
static bool aim = false, fov_atv = false, byp_on = false;
static bool l_cache = false, a_report = false, no_recoil = false;
static bool esp_line = false, medkit_run = false; // Opções que estavam faltando
static float fov_val = 60.0f;
static int aim_tgt = 0; 

// --- SISTEMA DE LIMPEZA (O QUE FUNCIONOU) ---
void deep_clean_id() {
    NSString *docs = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[docs stringByAppendingPathComponent:@"com.garena.msdk"] error:nil];
    
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)query);
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        // --- ESTILO DO SEU CANVA ---
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 580, 350)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.02 alpha:0.98];
        _bg.layer.cornerRadius = 25; // Cantos arredondados do Canva
        _bg.layer.borderColor = [UIColor greenColor].CGColor;
        _bg.layer.borderWidth = 2.0;
        _bg.layer.shadowColor = [UIColor greenColor].CGColor;
        _bg.layer.shadowRadius = 10; _bg.layer.shadowOpacity = 0.5;
        [self addSubview:_bg];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 580, 30)];
        _titleLabel.text = @"RICKZZ.XZ - PREMIUM MOD";
        _titleLabel.textColor = [UIColor greenColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_bg addSubview:_titleLabel];

        [self tabBtn:@"COMBATE" x:20 tag:0];
        [self tabBtn:@"VISUAL" x:120 tag:1];
        [self tabBtn:@"SISTEMA" x:220 tag:2];
        
        // Botão de Pânico (Sair do Royale Seguro)
        UIButton *panic = [[UIButton alloc] initWithFrame:CGRectMake(460, 15, 100, 25)];
        panic.backgroundColor = [UIColor redColor]; panic.layer.cornerRadius = 5;
        [panic setTitle:@"PANIC OFF" forState:0]; panic.titleLabel.font = [UIFont systemFontOfSize:10];
        [panic addTarget:self action:@selector(panicAction) forControlEvents:64];
        [_bg addSubview:panic];

        _content = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 560, 280)];
        [_bg addSubview:_content];
        [self drawCombate];
    }
    return self;
}

- (void)tabBtn:(NSString*)t x:(int)x tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(x, 45, 90, 25)];
    b.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    b.layer.cornerRadius = 5; b.tag = tg;
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

// --- TODAS AS OPÇÕES QUE ESTAVAM FALTANDO ---
- (void)drawCombate {
    [self ck:@"Auxílio de Mira" x:20 y:20 var:&aim];
    [self ck:@"No Recoil" x:20 y:55 var:&no_recoil];
    [self ck:@"Medkit Correndo" x:20 y:90 var:&medkit_run];
    [self ck:@"Ativar FOV" x:20 y:125 var:&fov_atv];
    
    // Boneco Alok do Canva
    UIView *al = [[UIView alloc] initWithFrame:CGRectMake(420, 20, 80, 130)];
    al.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5]; al.layer.cornerRadius = 12;
    [_content addSubview:al];
    _alokDot = [[UIView alloc] initWithFrame:CGRectMake(35, 15, 10, 10)];
    _alokDot.backgroundColor = [UIColor greenColor]; _alokDot.layer.cornerRadius = 5;
    [al addSubview:_alokDot];
    [self tgtB:@"Cabeça" y:160 tag:0]; [self tgtB:@"Peito" y:200 tag:1];
}

- (void)drawVisual {
    [self ck:@"ESP Line" x:20 y:20 var:&esp_line];
    [self ck:@"Personagem Branco" x:20 y:55 var:&l_cache]; // Reutilizando var para teste
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 20)];
    msg.text = @"Opções Visuais em Beta..."; msg.textColor = [UIColor grayColor];
    [_content addSubview:msg];
}

- (void)drawSistema {
    [self ck:@"Bypass Pro" x:20 y:20 var:&byp_on];
    [self ck:@"Anti-Report" x:20 y:55 var:&a_report];
    [self ck:@"LIMPEZA RADICAL" x:20 y:90 var:&l_cache];
}

- (void)ck:(NSString*)t x:(int)x y:(int)y var:(bool*)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 180, 20)];
    l.text = t; l.textColor = [UIColor whiteColor]; l.font = [UIFont systemFontOfSize:14];
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

- (void)panicAction {
    aim = false; fov_atv = false; byp_on = false; no_recoil = false;
    deep_clean_id();
    [RickzzFinalMenu show]; // Fecha o menu após limpar
}

- (void)tgtB:(NSString*)t y:(int)y tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(410, y, 100, 30)];
    [b setTitle:t forState:0]; b.tag = tg; b.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    b.layer.cornerRadius = 8; [b addTarget:self action:@selector(chT:) forControlEvents:64];
    [_content addSubview:b];
}

- (void)chT:(UIButton*)s {
    aim_tgt = (int)s.tag;
    [UIView animateWithDuration:0.2 animations:^{
        _alokDot.frame = (aim_tgt == 0) ? CGRectMake(35, 15, 10, 10) : CGRectMake(35, 65, 10, 10);
    }];
}
@end
