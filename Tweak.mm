#import <UIKit/UIKit.h>

static bool aim_ativo = false;
static bool esp_ativo = false;
static float fov_valor = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) CAShapeLayer *fovLayer;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void carregar_v24() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        
        // GESTO: 3 Dedos, Toque Único (Fast)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(abrir_menu:)];
        tap.numberOfTouchesRequired = 3;
        [win addGestureRecognizer:tap];
    });
}

+ (void)abrir_menu:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) [self toggle];
}

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *velho = [win viewWithTag:888];
    if (velho) [velho removeFromSuperview];
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 888;
        [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itens = @[@"Aimbot Pro", @"ESP Line", @"Tracer", @"Box 2D", @"Distancia", @"Cabeça", @"Peito", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // CÍRCULO DO FOV (Aparece no centro da tela)
        _fovLayer = [CAShapeLayer layer];
        _fovLayer.strokeColor = [UIColor cyanColor].CGColor;
        _fovLayer.fillColor = [UIColor clearColor].CGColor;
        _fovLayer.lineWidth = 1.5;
        _fovLayer.hidden = YES;
        [self.layer addSublayer:_fovLayer];

        // DESIGN DO PAINEL
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 380, 240)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithWhite:0 alpha:0.96];
        _container.layer.cornerRadius = 14;
        _container.layer.borderWidth = 1.2;
        _container.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_container];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, 370, 230)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self; _tabela.dataSource = self;
        _tabela.separatorStyle = 0;
        [_container addSubview:_tabela];
    }
    return self;
}

- (void)atualizarFOV {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_valor startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovLayer.path = path.CGPath;
}

- (void)mudou:(UISwitch *)s {
    if (s.tag == 0) aim_ativo = s.on;
    if (s.tag == 1) esp_ativo = s.on;
    if (s.tag == 7) { 
        _fovLayer.hidden = !s.on;
        [self atualizarFOV];
    }
}

- (void)sliderMudar:(UISlider *)sl {
    fov_valor = sl.value;
    [self atualizarFOV];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.itens.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.itens[ip.row];
    c.textLabel.textColor = [UIColor whiteColor];
    
    if (ip.row == 8) { // LINHA DO SLIDER
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        sl.minimumValue = 50; sl.maximumValue = 350; sl.value = fov_valor;
        sl.tintColor = [UIColor cyanColor];
        [sl addTarget:self action:@selector(sliderMudar:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = ip.row; [sw addTarget:self action:@selector(mudou:) forControlEvents:64];
        c.accessoryView = sw;
    }
    return c;
}
@end
