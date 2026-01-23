#import <UIKit/UIKit.h>

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@property (nonatomic, strong) CAShapeLayer *fovCircle; // O Círculo real
@end

@implementation RickzzMenu

__attribute__((constructor))
static void init_v8() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *segurar = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(aoSegurar:)];
        segurar.numberOfTouchesRequired = 3;
        segurar.minimumPressDuration = 2.0;
        [win addGestureRecognizer:segurar];
    });
}

+ (void)aoSegurar:(UILongPressGestureRecognizer *)gesto {
    if (gesto.state == UIGestureRecognizerStateBegan) [self toggle];
}

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:999];
    if (old) { [old removeFromSuperview]; }
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 999;
        [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itens = @[@"Aimbot", @"ESP", @"Tracer", @"Skeleton", @"Distancia", @"Caixa 2D", @"Cabeça", @"Peito", @"Alerta Spect", @"Anti-Screenshot", @"Modo Streamer", @"ATIVAR FOV"];
        
        // Círculo do FOV (Invisível no início)
        _fovCircle = [CAShapeLayer layer];
        _fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        _fovCircle.fillColor = [UIColor clearColor].CGColor;
        _fovCircle.lineWidth = 1.0;
        _fovCircle.hidden = YES;
        [self.layer addSublayer:_fovCircle];

        // Menu Deitado
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 280)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
        _container.layer.cornerRadius = 10;
        _container.layer.borderColor = [UIColor cyanColor].CGColor;
        _container.layer.borderWidth = 1.5;
        [self addSubview:_container];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 430, 180)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self;
        _tabela.dataSource = self;
        _tabela.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_container addSubview:_tabela];

        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 230, 350, 30)];
        _fovSlider.minimumValue = 50;
        _fovSlider.maximumValue = 300;
        [_fovSlider addTarget:self action:@selector(fovAjuste:) forControlEvents:UIControlEventValueChanged];
        _fovSlider.hidden = YES;
        [_container addSubview:_fovSlider];
    }
    return self;
}

- (void)fovAjuste:(UISlider *)sender {
    float r = sender.value;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:r startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = path.CGPath;
}

- (void)mudouSwitch:(UISwitch *)sender {
    NSString *opt = self.itens[sender.tag];
    if ([opt isEqualToString:@"ATIVAR FOV"]) {
        _fovCircle.hidden = !sender.on;
        _fovSlider.hidden = !sender.on;
        [self fovAjuste:_fovSlider]; // Desenha ao ligar
    }
}

// Métodos da Tabela (Obrigatórios)
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.itens.count; }
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [tv dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.itens[ip.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *s = [[UISwitch alloc] init];
    s.tag = ip.row;
    [s addTarget:self action:@selector(mudouSwitch:) forControlEvents:64];
    c.accessoryView = s;
    return c;
}

@end
