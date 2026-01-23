#import <UIKit/UIKit.h>
#import <Security/Security.h>

// Variáveis globais para o Contra Squad
static bool aimON = false;
static bool espON = false;
static int focoCorpo = 0; // 0=Cabeça, 1=Peito

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *base;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@end

@implementation RickzzMenu

// LIMPEZA DE CONTA (GUEST BYPASS)
static void limparGuest() {
    NSString *guestPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:guestPath error:nil];
    SecItemDelete((__bridge CFDictionaryRef)@{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword});
}

__attribute__((constructor))
static void initialize() {
    limparGuest();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(handleOpen:)];
        hold.numberOfTouchesRequired = 3;
        hold.minimumPressDuration = 2.0;
        [window addGestureRecognizer:hold];
    });
}

+ (void)handleOpen:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) [self toggle];
}

+ (void)toggle {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [window viewWithTag:999];
    if (old) [old removeFromSuperview];
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:window.bounds];
        menu.tag = 999;
        [window addSubview:menu];
    }
}

// Inicializador corrigido para evitar erros de compilação
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

        _base = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420, 260)];
        _base.center = self.center;
        _base.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
        _base.layer.cornerRadius = 15;
        _base.layer.borderWidth = 1.0;
        _base.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_base];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 35, 400, 175) style:UITableViewStylePlain];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self;
        _tabela.dataSource = self;
        _tabela.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_base addSubview:_tabela];

        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 220, 320, 30)];
        _fovSlider.minimumValue = 50; _fovSlider.maximumValue = 350;
        [_fovSlider addTarget:self action:@selector(fovSet:) forControlEvents:UIControlEventValueChanged];
        _fovSlider.hidden = YES;
        [_base addSubview:_fovSlider];
    }
    return self;
}

- (void)fovSet:(UISlider *)s {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:s.value startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = p.CGPath;
}

- (void)switchAlt:(UISwitch *)s {
    NSString *opt = self.itens[s.tag];
    if ([opt isEqualToString:@"Aimbot Pro"]) aimON = s.on;
    if ([opt containsString:@"ESP"]) espON = s.on;
    if ([opt isEqualToString:@"Cabeça"] && s.on) { focoCorpo = 0; [self off:6]; }
    if ([opt isEqualToString:@"Peito"] && s.on) { focoCorpo = 1; [self off:5]; }
    if ([opt isEqualToString:@"ATIVAR FOV"]) {
        _fovCircle.hidden = !s.on; _fovSlider.hidden = !s.on;
        [self fovSet:_fovSlider];
    }
}

- (void)off:(int)idx {
    UITableViewCell *c = [self.tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    if (c) [(UISwitch *)c.accessoryView setOn:NO animated:YES];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.itens.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.itens[ip.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *sw = [[UISwitch alloc] init];
    sw.tag = ip.row;
    [sw addTarget:self action:@selector(switchAlt:) forControlEvents:UIControlEventValueChanged];
    c.accessoryView = sw;
    return c;
}
@end
 
