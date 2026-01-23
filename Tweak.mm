#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <mach-o/dyld.h>

// Variáveis de ativação para o Contra Squad
static bool espAtivo = false;
static bool aimAtivo = false;
static int modoTiro = 0; // 0 para Cabeça, 1 para Peito

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@end

@implementation RickzzMenu

// LIMPEZA DE CONTA (GUEST RESET)
static void deepClean() {
    NSString *guest = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:guest error:nil];
    SecItemDelete((__bridge CFDictionaryRef)@{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword});
}

__attribute__((constructor))
static void start() {
    deepClean();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *seg = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(abrirPainel:)];
        seg.numberOfTouchesRequired = 3;
        seg.minimumPressDuration = 2.0;
        [win addGestureRecognizer:seg];
    });
}

+ (void)abrirPainel:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) [self alternar];
}

+ (void)alternar {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *p = [win viewWithTag:999];
    if (p) [p removeFromSuperview];
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 999;
        menu.layer.zPosition = 9999;
        [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itens = @[@"Aimbot Pro", @"ESP Line", @"Tracer", @"Caixa 2D", @"Distancia", @"Cabeça", @"Peito", @"ATIVAR FOV"];
        
        _fovCircle = [CAShapeLayer layer];
        _fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        _fovCircle.fillColor = [UIColor clearColor].CGColor;
        _fovCircle.lineWidth = 1.0;
        _fovCircle.hidden = YES;
        [self.layer addSublayer:_fovCircle];

        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420, 260)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
        _container.layer.cornerRadius = 15;
        _container.layer.borderWidth = 1.2;
        _container.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_container];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 400, 160)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self; _tabela.dataSource = self;
        _tabela.separatorStyle = 0;
        [_container addSubview:_tabela];

        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, 210, 340, 30)];
        _fovSlider.minimumValue = 50; _fovSlider.maximumValue = 400;
        [_fovSlider addTarget:self action:@selector(fovSet:) forControlEvents:64];
        _fovSlider.hidden = YES;
        [_container addSubview:_fovSlider];
    }
    return self;
}

- (void)fovSet:(UISlider *)s {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:s.value startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = p.CGPath;
}

- (void)mudouSwitch:(UISwitch *)sw {
    NSString *opt = self.itens[sw.tag];
    if ([opt isEqualToString:@"Aimbot Pro"]) aimAtivo = sw.on;
    if ([opt containsString:@"ESP"]) espAtivo = sw.on;
    if ([opt isEqualToString:@"Cabeça"] && sw.on) { modoTiro = 0; [self off:6]; }
    if ([opt isEqualToString:@"Peito"] && sw.on) { modoTiro = 1; [self off:5]; }
    if ([opt isEqualToString:@"ATIVAR FOV"]) {
        _fovCircle.hidden = !sw.on; _fovSlider.hidden = !sw.on;
        [self fovSet:_fovSlider];
    }
}

- (void)off:(int)i {
    UITableViewCell *c = [self.tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    if (c) [(UISwitch *)c.accessoryView setOn:NO animated:YES];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.itens.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.itens[ip.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *sw = [[UISwitch alloc] init];
    sw.tag = ip.row; [sw addTarget:self action:@selector(mudouSwitch:) forControlEvents:64];
    c.accessoryView = sw;
    return c;
}
@end
