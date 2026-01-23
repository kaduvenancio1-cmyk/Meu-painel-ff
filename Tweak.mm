#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <mach-o/dyld.h>

// Variáveis de controle para o CS
static bool aimAtivo = false;
static bool espAtivo = false;
static int localAlvo = 0; 

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@end

@implementation RickzzMenu

// LIMPEZA AUTOMÁTICA DE CONTA
static void resetApp() {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    SecItemDelete((__bridge CFDictionaryRef)@{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword});
}

__attribute__((constructor))
static void load() {
    resetApp();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(show:)];
        hold.numberOfTouchesRequired = 3;
        hold.minimumPressDuration = 2.0;
        [win addGestureRecognizer:hold];
    });
}

+ (void)show:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) [self toggle];
}

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:999];
    if (old) [old removeFromSuperview];
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 999;
        [win addSubview:menu];
    }
}

// CORREÇÃO DO ERRO DE INICIALIZAÇÃO (NS_DESIGNATED_INITIALIZER)
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
        _container.layer.borderWidth = 1.0;
        _container.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_container];

        // CORREÇÃO DA TABELA
        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 400, 160) style:UITableViewStylePlain];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self;
        _tabela.dataSource = self;
        _tabela.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_container addSubview:_tabela];

        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, 210, 340, 30)];
        _fovSlider.minimumValue = 50; _fovSlider.maximumValue = 350;
        [_fovSlider addTarget:self action:@selector(ajuste:) forControlEvents:UIControlEventValueChanged];
        _fovSlider.hidden = YES;
        [_container addSubview:_fovSlider];
    }
    return self;
}

- (void)ajuste:(UISlider *)s {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:s.value startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = p.CGPath;
}

- (void)mudou:(UISwitch *)s {
    NSString *opt = self.itens[s.tag];
    if ([opt isEqualToString:@"Aimbot Pro"]) aimAtivo = s.on;
    if ([opt containsString:@"ESP"]) espAtivo = s.on;
    if ([opt isEqualToString:@"Cabeça"] && s.on) { localAlvo = 0; [self off:6]; }
    if ([opt isEqualToString:@"Peito"] && s.on) { localAlvo = 1; [self off:5]; }
    if ([opt isEqualToString:@"ATIVAR FOV"]) {
        _fovCircle.hidden = !s.on; _fovSlider.hidden = !s.on;
        [self ajuste:_fovSlider];
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
    [sw addTarget:self action:@selector(mudou:) forControlEvents:UIControlEventValueChanged];
    c.accessoryView = sw;
    return c;
}
@end
