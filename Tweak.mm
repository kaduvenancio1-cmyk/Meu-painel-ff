#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <mach-o/dyld.h>
#import <substrate.h>

// --- ESTRUTURA DE MEMÓRIA PARA FUNÇÕES REAIS ---
uintptr_t get_base() { return (uintptr_t)_dyld_get_image_header(0); }

// Simulação de ativação de memória (Aqui entrarão os Offsets da 1.120.11)
bool aimbotAtivo = false;
bool espAtivo = false;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@end

@implementation RickzzMenu

// LIMPEZA DE CONTA (GUEST RESET)
static void reset_now() {
    NSString *p = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:p error:nil];
    NSDictionary *q = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)q);
}

__attribute__((constructor))
static void init_v13() {
    reset_now();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *seg = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(aoSegurar:)];
        seg.numberOfTouchesRequired = 3; seg.minimumPressDuration = 2.0;
        [win addGestureRecognizer:seg];
    });
}

+ (void)aoSegurar:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) [self toggle];
}

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:999];
    if (old) { [old removeFromSuperview]; }
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 999; menu.layer.zPosition = 9999;
        [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itens = @[@"Aimbot Pro", @"ESP Line", @"Tracer", @"Skeleton", @"Distancia", @"Caixa 2D", @"Cabeça", @"Peito", @"Alerta Spect", @"ATIVAR FOV"];
        
        _fovCircle = [CAShapeLayer layer];
        _fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        _fovCircle.fillColor = [UIColor clearColor].CGColor;
        _fovCircle.lineWidth = 1.5; _fovCircle.zPosition = 10000;
        _fovCircle.hidden = YES;
        [self.layer addSublayer:_fovCircle];

        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 280)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
        _container.layer.cornerRadius = 10;
        _container.layer.borderWidth = 1.5; _container.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_container];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 430, 180)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self; _tabela.dataSource = self;
        _tabela.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_container addSubview:_tabela];

        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 230, 350, 30)];
        _fovSlider.minimumValue = 50; _fovSlider.maximumValue = 400;
        [_fovSlider addTarget:self action:@selector(fovAjuste:) forControlEvents:64];
        _fovSlider.hidden = YES;
        [_container addSubview:_fovSlider];
    }
    return self;
}

- (void)fovAjuste:(UISlider *)s {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:s.value startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = p.CGPath;
}

- (void)mudouSwitch:(UISwitch *)sender {
    NSString *opt = self.itens[sender.tag];
    
    // LÓGICA DE ATIVAÇÃO REAL
    if ([opt isEqualToString:@"Aimbot Pro"]) aimbotAtivo = sender.on;
    if ([opt containsString:@"ESP"] || [opt isEqualToString:@"Tracer"]) espAtivo = sender.on;
    
    if ([opt isEqualToString:@"ATIVAR FOV"]) {
        _fovCircle.hidden = !sender.on; _fovSlider.hidden = !sender.on;
        [self fovAjuste:_fovSlider];
    }
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.itens.count; }
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [tv dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.itens[ip.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *s = [[UISwitch alloc] init];
    s.tag = ip.row; [s addTarget:self action:@selector(mudouSwitch:) forControlEvents:64];
    c.accessoryView = s;
    return c;
}
@end
