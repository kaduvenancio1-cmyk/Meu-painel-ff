#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <mach-o/dyld.h>

// Controle de Memória para 1.120.11
static bool ligarESP = false;
static bool ligarAim = false;
static int localFoco = 0; // 0=Cabeça, 1=Peito

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@end

@implementation RickzzMenu

// LIMPEZA REFORÇADA PARA EVITAR TELA DE SUSPENSÃO
static void reset_account_clean() {
    NSString *p = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:p error:nil];
    SecItemDelete((__bridge CFDictionaryRef)@{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword});
}

__attribute__((constructor))
static void setup() {
    reset_account_clean();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(handle:)];
        hold.numberOfTouchesRequired = 3; hold.minimumPressDuration = 2.0;
        [win addGestureRecognizer:hold];
    });
}

+ (void)handle:(UILongPressGestureRecognizer *)g { if (g.state == 1) [self toggle]; }

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:999];
    if (old) [old removeFromSuperview];
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 999; [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itens = @[@"Aimbot Pro", @"ESP Line", @"Tracer", @"Caixa 2D", @"Distancia", @"Cabeça", @"Peito", @"ATIVAR FOV"];
        
        _fovCircle = [CAShapeLayer layer];
        _fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        _fovCircle.fillColor = [UIColor clearColor].CGColor;
        _fovCircle.lineWidth = 1.0; _fovCircle.hidden = YES;
        [self.layer addSublayer:_fovCircle];

        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 430, 270)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.96];
        _container.layer.cornerRadius = 18; _container.layer.borderWidth = 1.2;
        _container.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_container];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 410, 170)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self; _tabela.dataSource = self;
        _tabela.separatorStyle = 0;
        [_container addSubview:_tabela];

        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, 220, 350, 30)];
        _fovSlider.minimumValue = 50; _fovSlider.maximumValue = 400;
        [_fovSlider addTarget:self action:@selector(fovCh:) forControlEvents:64];
        _fovSlider.hidden = YES;
        [_container addSubview:_fovSlider];
    }
    return self;
}

- (void)fovCh:(UISlider *)s {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:s.value startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = p.CGPath;
}

- (void)swChanged:(UISwitch *)s {
    NSString *opt = self.itens[s.tag];
    if ([opt isEqualToString:@"Aimbot Pro"]) ligarAim = s.on;
    if ([opt containsString:@"ESP"]) ligarESP = s.on;
    if ([opt isEqualToString:@"Cabeça"] && s.on) { localFoco = 0; [self off:6]; }
    if ([opt isEqualToString:@"Peito"] && s.on) { localFoco = 1; [self off:5]; }
    if ([opt isEqualToString:@"ATIVAR FOV"]) {
        _fovCircle.hidden = !s.on; _fovSlider.hidden = !s.on;
        [self fovCh:_fovSlider];
    }
}

- (void)off:(int)idx {
    UITableViewCell *c = [self.tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    if (c) [(UISwitch *)c.accessoryView setOn:NO animated:YES];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.itens.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.itens[ip.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *sw = [[UISwitch alloc] init];
    sw.tag = ip.row; [sw addTarget:self action:@selector(swChanged:) forControlEvents:64];
    c.accessoryView = sw;
    return c;
}
@end
