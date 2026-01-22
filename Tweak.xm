/*
 * RICKZZ.XZ x GEMINI - VERSÃO FINAL ESTÁVEL
 * DESIGN: CANVA RETANGULAR | ANTI-CRASH LOBBY
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#import <objc/runtime.h>

// --- VARIÁVEIS (TUDO FALSE AO INICIAR) ---
static bool aim = false, recoil = false, esp = false, fov_atv = false;
static bool tracer = false, skeleton = false, box2d = false, dist = false;
static bool l_cache = false, t_lache = false, a_report = false, byp_on = false;
static float fov_val = 60.0f;
static int aim_tgt = 0; 

@interface RickzzFinalMenu : UIView
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIView *alokDot;
@property (nonatomic, strong) UILabel *fovLab;
@end

@implementation RickzzFinalMenu
static RickzzFinalMenu *inst;

+ (void)load {
    // Espera 12 segundos para garantir que o jogo já passou da tela da Garena
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
        self.backgroundColor = [UIColor clearColor];
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 320)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.98];
        _bg.layer.cornerRadius = 15;
        _bg.layer.borderColor = [UIColor greenColor].CGColor;
        _bg.layer.borderWidth = 2;
        [self addSubview:_bg];

        [self tabBtn:@"Combate" x:30 tag:0];
        [self tabBtn:@"Sistema" x:130 tag:1];
        _content = [[UIView alloc] initWithFrame:CGRectMake(10, 55, 540, 255)];
        [_bg addSubview:_content];
        [self drawCombate];
    }
    return self;
}

- (void)tabBtn:(NSString*)t x:(int)x tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(x, 15, 90, 30)];
    b.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    b.layer.cornerRadius = 15; b.tag = tg;
    [b setTitle:t forState:0]; [b addTarget:self action:@selector(swTab:) forControlEvents:64];
    [_bg addSubview:b];
}

- (void)swTab:(UIButton*)s {
    for (UIView *v in _content.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; else [self drawSistema];
}

- (void)drawCombate {
    [self ck:@"Aimbot" x:25 y:40 var:&aim];
    [self ck:@"No Recoil" x:25 y:75 var:&recoil];
    [self ck:@"ESP" x:25 y:110 var:&esp];
    [self ck:@"Ativar FOV" x:25 y:145 var:&fov_atv];
    
    _fovLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 180, 150, 15)];
    _fovLab.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", fov_val];
    _fovLab.textColor = [UIColor whiteColor]; _fovLab.font = [UIFont systemFontOfSize:11];
    [_content addSubview:_fovLab];
    
    UISlider *s = [[UISlider alloc] initWithFrame:CGRectMake(25, 200, 140, 20)];
    s.maximumValue = 180; s.value = fov_val; // FOV reduzido para escala real
    [s addTarget:self action:@selector(fvCh:) forControlEvents:UIControlEventValueChanged];
    [_content addSubview:s];

    [self ck:@"Tracer" x:200 y:40 var:&tracer];
    [self ck:@"Skeleton" x:200 y:75 var:&skeleton];
    [self ck:@"Caixa 2D" x:200 y:110 var:&box2d];
    [self ck:@"Distância" x:200 y:145 var:&dist];

    UIView *al = [[UIView alloc] initWithFrame:CGRectMake(400, 40, 75, 120)];
    al.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3]; al.layer.cornerRadius = 10;
    [_content addSubview:al];
    _alokDot = [[UIView alloc] initWithFrame:CGRectMake(32, 15, 10, 10)];
    _alokDot.backgroundColor = [UIColor redColor]; _alokDot.layer.cornerRadius = 5;
    [al addSubview:_alokDot];

    [self tgtB:@"Cabeça" y:170 tag:0]; [self tgtB:@"Peito" y:205 tag:1];
}

- (void)drawSistema {
    [self ck:@"Limpar Cache" x:40 y:40 var:&l_cache];
    [self ck:@"Trava Lache" x:40 y:80 var:&t_lache];
    [self ck:@"Anti-Report" x:40 y:120 var:&a_report];
    [self ck:@"Bypass Online" x:40 y:160 var:&byp_on];
}

- (void)ck:(NSString*)t x:(int)x y:(int)y var:(bool*)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 110, 20)];
    l.text = t; l.textColor = [UIColor whiteColor]; [_content addSubview:l];
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(x+120, y, 22, 22)];
    c.layer.borderWidth = 1.5; c.layer.borderColor = [UIColor greenColor].CGColor;
    if(*v) [c setTitle:@"X" forState:0];
    [c setTitleColor:[UIColor greenColor] forState:0];
    c.accessibilityValue = [NSString stringWithFormat:@"%p", v];
    [c addTarget:self action:@selector(tgC:) forControlEvents:64]; [_content addSubview:c];
}

- (void)tgC:(UIButton*)s {
    unsigned long long addr = 0;
    [[NSScanner scannerWithString:s.accessibilityValue] scanHexLongLong:&addr];
    bool *v = (bool *)addr; *v = !(*v);
    [s setTitle:(*v ? @"X" : @"") forState:0];
}

- (void)fvCh:(UISlider*)s {
    fov_val = s.value;
    _fovLab.text = [NSString stringWithFormat:@"Ajuste FOV: %.0f", fov_val];
}

- (void)tgtB:(NSString*)t y:(int)y tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(390, y, 95, 30)];
    [b setTitle:t forState:0]; b.tag = tg;
    [b addTarget:self action:@selector(chT:) forControlEvents:64]; [_content addSubview:b];
}

- (void)chT:(UIButton*)s {
    aim_tgt = (int)s.tag;
    [UIView animateWithDuration:0.2 animations:^{
        _alokDot.frame = (aim_tgt == 0) ? CGRectMake(32, 15, 10, 10) : CGRectMake(32, 65, 10, 10);
    }];
}
@end

// --- HOOKS SEGUROS ---
void (*old_S)(void *i);
void new_S(void *i) {
    if (i != NULL && byp_on) {
        if (aim) { *(float *)((uint64_t)i + 0xBC) = 0.0f; }
        if (fov_atv) { *(float *)((uint64_t)i + 0x754) = fov_val; }
    }
    if (old_S) old_S(i);
}

__attribute__((constructor))
static void init() {
    // Injeta o hook apenas quando o jogo estiver no lobby/partida
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_S, (void **)&old_S);
    });
}
