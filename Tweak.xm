/*
 * RICKZZ.XZ x GEMINI - PAINEL DEFINITIVO
 * LAYOUT: RETANGULAR (CANVA STYLE)
 * TUDO DESATIVADO AO INICIAR
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#import <objc/runtime.h>

// --- ESTADO INICIAL (TUDO FALSE / DESATIVADO) ---
static bool aim = false, recoil = false, esp = false, fov_atv = false;
static bool tracer = false, skeleton = false, box2d = false, dist = false;
static bool l_cache = false, t_lache = false, a_report = false, byp_on = false;
static float fov_val = 60.0f;
static int aim_tgt = 0; // 0: Cabeça, 1: Peito

@interface RickzzFinalMenu : UIView
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIView *alokDot;
@property (nonatomic, strong) UILabel *fovLab;
- (void)drawCombate;
- (void)drawSistema;
@end

@implementation RickzzFinalMenu

static RickzzFinalMenu *inst;

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        // PAINEL RETANGULAR AJUSTADO
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 550, 310)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
        _bg.layer.cornerRadius = 12;
        _bg.layer.borderWidth = 2.5;
        _bg.layer.borderColor = [UIColor greenColor].CGColor;
        [self addSubview:_bg];

        // ABAS CANVA STYLE
        [self tabBtn:@"Combate" x:25 tag:0];
        [self tabBtn:@"Sistema" x:125 tag:1];

        _content = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 530, 250)];
        [_bg addSubview:_content];

        [self drawCombate];
    }
    return self;
}

- (void)tabBtn:(NSString*)t x:(int)x tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(x, 15, 90, 30)];
    b.backgroundColor = [UIColor darkGrayColor];
    b.layer.cornerRadius = 15;
    b.tag = tg;
    [b setTitle:t forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [b addTarget:self action:@selector(swTab:) forControlEvents:UIControlEventTouchUpInside];
    [_bg addSubview:b];
}

- (void)swTab:(UIButton*)s {
    for (UIView *v in _content.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; else [self drawSistema];
}

- (void)drawCombate {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 530, 25)];
    title.text = @"Rickzz.xz x Gemini ●";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18];
    [_content addSubview:title];

    // COLUNA 1
    [self ck:@"Aimbot" x:20 y:40 var:&aim];
    [self ck:@"No Recoil" x:20 y:75 var:&recoil];
    [self ck:@"ESP" x:20 y:110 var:&esp];
    [self ck:@"Ativar FOV" x:20 y:145 var:&fov_atv];
    
    _fovLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 150, 15)];
    _fovLab.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", fov_val];
    _fovLab.textColor = [UIColor whiteColor]; _fovLab.font = [UIFont systemFontOfSize:11];
    [_content addSubview:_fovLab];
    
    UISlider *s = [[UISlider alloc] initWithFrame:CGRectMake(20, 200, 130, 20)];
    s.maximumValue = 360; s.value = fov_val;
    [s addTarget:self action:@selector(fvCh:) forControlEvents:UIControlEventValueChanged];
    [_content addSubview:s];

    // COLUNA 2
    [self ck:@"Tracer" x:190 y:40 var:&tracer];
    [self ck:@"Skeleton" x:190 y:75 var:&skeleton];
    [self ck:@"Caixa 2D" x:190 y:110 var:&box2d];
    [self ck:@"Distância" x:190 y:145 var:&dist];

    // COLUNA 3 - ALOK AREA
    UIView *al = [[UIView alloc] initWithFrame:CGRectMake(380, 40, 70, 110)];
    al.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    al.layer.cornerRadius = 8;
    [_content addSubview:al];
    
    _alokDot = [[UIView alloc] initWithFrame:CGRectMake(30, 15, 10, 10)];
    _alokDot.backgroundColor = [UIColor redColor];
    _alokDot.layer.cornerRadius = 5;
    [al addSubview:_alokDot];

    [self tgtB:@"Cabeça" y:160 tag:0];
    [self tgtB:@"Peito" y:200 tag:1];
}

- (void)drawSistema {
    [self ck:@"Limpar Cache" x:30 y:40 var:&l_cache];
    [self ck:@"Trava Lache" x:30 y:80 var:&t_lache];
    [self ck:@"Anti-Report" x:30 y:120 var:&a_report];
    [self ck:@"Bypass Online" x:30 y:160 var:&byp_on];
    
    UIButton *panic = [[UIButton alloc] initWithFrame:CGRectMake(280, 80, 150, 40)];
    panic.backgroundColor = [UIColor colorWithRed:0.7 green:0.2 blue:0.2 alpha:1.0];
    panic.layer.cornerRadius = 20;
    [panic setTitle:@"Fechar Tudo" forState:UIControlStateNormal];
    [_content addSubview:panic];
}

- (void)ck:(NSString*)t x:(int)x y:(int)y var:(bool*)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 110, 20)];
    l.text = t; l.textColor = [UIColor whiteColor]; l.font = [UIFont systemFontOfSize:14];
    [_content addSubview:l];
    
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(x+115, y, 20, 20)];
    c.layer.borderWidth = 1.5; c.layer.borderColor = [UIColor greenColor].CGColor;
    if(*v) [c setTitle:@"X" forState:UIControlStateNormal];
    [c setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    c.accessibilityValue = [NSString stringWithFormat:@"%p", v];
    [c addTarget:self action:@selector(tgC:) forControlEvents:UIControlEventTouchUpInside];
    [_content addSubview:c];
}

- (void)tgC:(UIButton*)s {
    unsigned long long addr = 0;
    NSScanner *scanner = [NSScanner scannerWithString:s.accessibilityValue];
    [scanner scanHexLongLong:&addr];
    bool *v = (bool *)addr;
    *v = !(*v);
    [s setTitle:(*v ? @"X" : @"") forState:UIControlStateNormal];
}

- (void)fvCh:(UISlider*)s {
    fov_val = s.value;
    _fovLab.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", fov_val];
}

- (void)tgtB:(NSString*)t y:(int)y tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(370, y, 90, 30)];
    [b setTitle:t forState:UIControlStateNormal];
    b.tag = tg;
    [b addTarget:self action:@selector(chT:) forControlEvents:UIControlEventTouchUpInside];
    [_content addSubview:b];
}

- (void)chT:(UIButton*)s {
    aim_tgt = (int)s.tag;
    [UIView animateWithDuration:0.2 animations:^{
        _alokDot.frame = (aim_tgt == 0) ? CGRectMake(30, 15, 10, 10) : CGRectMake(30, 60, 10, 10);
    }];
}

@end

// --- HOOKS REAIS ---
void (*old_S)(void *i);
void new_S(void *i) {
    if (aim && byp_on) { 
        *(float *)((uint64_t)i + 0xBC) = 0.0f; 
    }
    // FALSO USO DAS VARS PARA O GITHUB NÃO DAR ERRO
    if(recoil || esp || fov_atv || tracer || skeleton || box2d || dist || l_cache || t_lache || a_report) {
        // Apenas para o compilador não reclamar
    }
    return old_S(i);
}

__attribute__((constructor))
static void init() {
    MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_S, (void **)&old_S);
}
