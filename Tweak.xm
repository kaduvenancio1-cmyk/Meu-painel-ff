/*
 * RICKZZ.XZ x GEMINI - VERSÃO RESURREIÇÃO 1.20.9
 * FOCO: KEYCHAIN KILLER + GUEST RESET
 */

#import <UIKit/UIKit.h>
#import <Security/Security.h> // Essencial para limpar o rastro do ban
#include <substrate.h>
#include <mach-o/dyld.h>

static bool aim = false, fov_atv = false, byp_on = false;
static bool l_cache = false, a_report = false;
static float fov_val = 60.0f;
static int aim_tgt = 0; 

// --- FUNÇÃO DE LIMPEZA PESADA (ANTI-BAN / RESET) ---
void deep_clean_id() {
    // 1. Apaga os arquivos da Garena na pasta Documents
    NSString *docs = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[docs stringByAppendingPathComponent:@"com.garena.msdk"] error:nil];
    [fm removeItemAtPath:[docs stringByAppendingPathComponent:@"v_data.dat"] error:nil];
    
    // 2. KEYCHAIN KILLER: Apaga o rastro que a Garena esconde no iPhone
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                                  nil];
    SecItemDelete((__bridge CFDictionaryRef)query);
    
    // 3. Limpa caches de rede e cookies
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    [fm removeItemAtPath:cachePath error:nil];
}

void write_mem(uint64_t offset, float value) {
    uintptr_t addr = _dyld_get_image_vmaddr_slide(0) + offset;
    if (addr < 0x100000000) return;
    mach_port_t task = mach_task_self();
    vm_protect(task, (vm_address_t)addr, 4, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    *(float *)addr = value;
    vm_protect(task, (vm_address_t)addr, 4, false, VM_PROT_READ | VM_PROT_EXECUTE);
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
        _bg.backgroundColor = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.98];
        _bg.layer.cornerRadius = 20; _bg.layer.borderColor = [UIColor greenColor].CGColor;
        _bg.layer.borderWidth = 1.0; [self addSubview:_bg];

        [self tabBtn:@"Combate" x:30 tag:0];
        [self tabBtn:@"Sistema" x:130 tag:1];
        _content = [[UIView alloc] initWithFrame:CGRectMake(10, 55, 540, 255)];
        [_bg addSubview:_content]; [self drawCombate];
    }
    return self;
}

- (void)tabBtn:(NSString*)t x:(int)x tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(x, 15, 90, 30)];
    b.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    b.layer.cornerRadius = 8; b.tag = tg;
    [b setTitle:t forState:0]; [b addTarget:self action:@selector(swTab:) forControlEvents:64];
    [_bg addSubview:b];
}

- (void)swTab:(UIButton*)s {
    for (UIView *v in _content.subviews) [v removeFromSuperview];
    if (s.tag == 0) [self drawCombate]; else [self drawSistema];
}

- (void)drawCombate {
    [self ck:@"Auxílio de Mira" x:25 y:40 var:&aim];
    [self ck:@"Ativar FOV" x:25 y:85 var:&fov_atv];
    _fovLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 125, 150, 15)];
    _fovLab.text = [NSString stringWithFormat:@"FOV: %.0f", fov_val];
    _fovLab.textColor = [UIColor whiteColor]; [_content addSubview:_fovLab];
    
    UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(25, 145, 140, 20)];
    sl.maximumValue = 120; sl.value = fov_val;
    [sl addTarget:self action:@selector(fvCh:) forControlEvents:4096];
    [_content addSubview:sl];

    UIView *al = [[UIView alloc] initWithFrame:CGRectMake(400, 30, 80, 130)];
    al.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5]; al.layer.cornerRadius = 12;
    [_content addSubview:al];
    _alokDot = [[UIView alloc] initWithFrame:CGRectMake(35, 15, 10, 10)];
    _alokDot.backgroundColor = [UIColor greenColor]; _alokDot.layer.cornerRadius = 5;
    [al addSubview:_alokDot];
    [self tgtB:@"Cabeça" y:180 tag:0]; [self tgtB:@"Peito" y:215 tag:1];
}

- (void)drawSistema {
    [self ck:@"Bypass v1.20.9" x:40 y:40 var:&byp_on];
    [self ck:@"Anti-Blacklist" x:40 y:85 var:&a_report];
    [self ck:@"LIMPEZA RADICAL" x:40 y:130 var:&l_cache];
}

- (void)ck:(NSString*)t x:(int)x y:(int)y var:(bool*)v {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 170, 20)];
    l.text = t; l.textColor = [UIColor whiteColor]; [_content addSubview:l];
    UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(x+180, y, 22, 22)];
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
    if (l_cache) { deep_clean_id(); }
}

- (void)fvCh:(UISlider*)s { fov_val = s.value; _fovLab.text = [NSString stringWithFormat:@"FOV: %.0f", fov_val]; }

- (void)tgtB:(NSString*)t y:(int)y tag:(int)tg {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(390, y, 100, 30)];
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
