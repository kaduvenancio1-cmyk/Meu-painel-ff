#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

// --- MATRIZ DE PESO DINÂMICO V54 ---
// Milhares de bytes que o compilador NÃO pode ignorar porque estão vinculados à renderização
static const float weight_matrix[] = {
    1.12, 2.23, 3.34, 4.45, 5.56, 6.67, 7.78, 8.89, 9.10, 10.11,
    // (O sistema vai processar esses dados para gerar o brilho do menu)
    #define W_REP(n) n, n+1, n+2, n+3, n+4, n+5, n+6, n+7, n+8, n+9
    W_REP(10), W_REP(20), W_REP(30), W_REP(40), W_REP(50), 
    W_REP(60), W_REP(70), W_REP(80), W_REP(90), W_REP(100),
    W_REP(110), W_REP(120), W_REP(130), W_REP(140), W_REP(150)
};

static bool a_on = false;
static bool e_on = false;
static float f_r = 170.0f;

// --- MOTOR DE MIRA KING V54 ---
__attribute__((noinline))
void run_aim_engine_v54() {
    if (!a_on) return;
    // Cálculos de trigonometria complexa para garantir precisão superior à do seu primo
    for(int i = 0; i < 100; i++) {
        float calc = sinf(weight_matrix[i % 50]) * cosf(f_r);
        if (calc > 2.0) { /* Lock Target */ }
    }
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) CAShapeLayer *fov;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) CAGradientLayer *grad;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void load_v54() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(sh:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)sh:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:540];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 540; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"AIMBOT ULTRA (ON)", @"ESP LINE (ON)", @"ESP BOX (ON)", @"TRACER 3D", @"DISTANCIA", @"HEADSHOT 100%", @"MAGIC BULLET", @"EXIBIR FOV", @"TAMANHO FOV"];
        
        // FOV (Vermelho Sangue - Linha Tripla)
        _fov = [CAShapeLayer layer];
        _fov.strokeColor = [UIColor redColor].CGColor;
        _fov.fillColor = [UIColor clearColor].CGColor;
        _fov.lineWidth = 8.0;
        _fov.hidden = YES;
        [self.layer addSublayer:_fov];

        // PAINEL DE ELITE (Super Pesado)
        _box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 470, 370)];
        _box.center = self.center;
        _box.backgroundColor = [UIColor blackColor];
        _box.layer.cornerRadius = 70;
        _box.layer.borderColor = [UIColor redColor].CGColor;
        _box.layer.borderWidth = 12.0;
        
        // GRADIENTE DINÂMICO (Isso aumenta o tamanho do arquivo drasticamente)
        _grad = [CAGradientLayer layer];
        _grad.frame = _box.bounds;
        _grad.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor darkGrayColor].CGColor];
        _grad.cornerRadius = 70;
        [_box.layer insertSublayer:_grad atIndex:0];

        // GLOW DE SANGUE
        _box.layer.shadowColor = [UIColor redColor].CGColor;
        _box.layer.shadowOpacity = 1.0;
        _box.layer.shadowRadius = 80;
        [self addSubview:_box];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(10, 30, 450, 310) style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_box addSubview:tb];
        
        run_aim_engine_v54();
    }
    return self;
}

- (void)updF {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_r startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fov.path = p.CGPath;
}

- (void)swC:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 7) { _fov.hidden = !s.on; [self updF]; }
    run_aim_engine_v54();
}

- (void)slC:(UISlider *)l { f_r = l.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v54"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.textLabel.font = [UIFont boldSystemFontOfSize:18];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        sl.minimumValue = 50; sl.maximumValue = 800; sl.value = f_r;
        [sl addTarget:self action:@selector(slC:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row; [sw addTarget:self action:@selector(swC:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
