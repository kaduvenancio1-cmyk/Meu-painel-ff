/*
 * RICKZZ.XZ x GEMINI - VERSÃO FINAL ULTRA COMPATÍVEL
 * STATUS: ANTI-CRASH E ANTI-BAN OTIMIZADOS
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// --- VARIÁVEIS DE CONTROLE ---
static bool aim = false, fov_atv = false, byp_on = false;
static bool l_cache = false, a_report = false;
static float fov_val = 60.0f;
static int aim_tgt = 0; 

// --- FUNÇÃO DE ESCRITA SEGURA (CORREÇÃO DE CRASH) ---
void write_memory(uint64_t offset, float value) {
    uintptr_t address = _dyld_get_image_vmaddr_slide(0) + offset;
    if (address < 0x100000000) return; 
    mach_port_t task = mach_task_self();
    vm_protect(task, (vm_address_t)address, 4, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    *(float *)address = value;
    vm_protect(task, (vm_address_t)address, 4, false, VM_PROT_READ | VM_PROT_EXECUTE);
}

// --- FUNÇÃO ANTI-BAN (FORMA NATIVA SEM ERRO) ---
void apply_antiban() {
    if (l_cache) {
        // Limpeza de cache usando API nativa da Apple (evita erro da função system)
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    if (a_report) {
        // Bloqueio de logs de denúncia
        write_memory(0x203A124, 0.0f); 
    }
}

@interface RickzzFinalMenu : UIView
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIView *alokDot;
@property (nonatomic, strong) UILabel *fovLab;
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
        self.backgroundColor = [UIColor clearColor];
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 320)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.95];
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
    [self ck:@"Ativar FOV" x:25 y:75 var:&fov_atv];
    
    _fovLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 110, 150, 15)];
    _fovLab.text = [NSString stringWithFormat:@"FOV: %.0f", fov_val];
    _fovLab.textColor = [UIColor whiteColor]; _fovLab.font = [UIFont systemFontOfSize:11];
    [_content addSubview:_fovLab];
    
    UISlider *s = [[UISlider alloc] initWithFrame:CGRectMake(25, 130, 140, 20)];
    s.maximumValue = 180; s.value = fov_val;
    [s addTarget:self action:@selector(fvCh:) forControlEvents:4096];
    [_content addSubview:s];

    UIView *al = [[UIView alloc] initWithFrame:CGRectMake(400, 40, 75, 120)];
    al.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5]; al.layer.cornerRadius = 10;
    [_content addSubview:al];
    _alokDot = [[UIView alloc] initWithFrame:CGRectMake(32, 15, 10, 10)];
    _alokDot.backgroundColor = [UIColor redColor]; _alokDot.layer.cornerRadius = 5;
    [al addSubview:_alokDot];

    [self tgtB:@"Cabeça" y:170 tag:0]; [self tgtB:@"Peito" y:205 tag:1];
}

- (void)drawSistema {
    [self ck:@"Bypass Online" x:40 y:40 var:&byp_on];
    [self ck:@"Anti-Report" x:40 y:80 var:&a_report];
    [self ck:@"Limpar Cache" x:40 y:120 var:&l_cache];
}

- (void)ck:(NSString*)t x:(int)x y:(int)y var:(bool*)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 150, 20)];
    l.text = t; l.textColor = [UIColor whiteColor]; [_content addSubview:l];
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(x+160, y, 22, 22)];
    c.layer.borderWidth = 1.5; c.layer.borderColor = [UIColor greenColor].CGColor;
    if(*v) [c setTitle:@"X" forState:0];
    c.accessibilityValue = [NSString stringWithFormat:@"%p", v];
    [c addTarget:self action:@selector(tgC:) forControlEvents:64]; [_content addSubview:c];
}

- (void)tgC:(UIButton*)s {
    unsigned long long addr = 0;
    [[NSScanner scannerWithString:s.accessibilityValue] scanHexLongLong:&addr];
    bool *v = (bool *)addr; *v = !(*v);
    [s setTitle:(*v ? @"X" : @"") forState:0];

    apply_antiban();
    if(byp_on) {
        if(aim) write_memory(0x103D8E124, 0.0f);
        if(fov_atv) write_memory(0x754, fov_val);
    }
}

- (void)fvCh:(UISlider*)s {
    fov_val = s.value;
    _fovLab.text = [NSString stringWithFormat:@"FOV: %.0f", fov_val];
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
