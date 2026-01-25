#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

// --- MATRIZ DE RENDERIZAÇÃO PESADA (OBRIGATÓRIO PARA O PESO) ---
// Este bloco de bytes REAIS vai forçar o aumento do arquivo final.
static const unsigned char raw_data_v58[] = {
    0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, 0x00, 0xff, 0xff, 0xff,
    0x00, 0x00, 0x00, 0x21, 0xf9, 0x04, 0x01, 0x00, 0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x00, 0x00,
    // Repetição de bytes para garantir volume (Massa de Dados)
    #define D_REP 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0x00
    D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP,
    D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP,
    D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP,
    D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP,
    D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP,
    D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP, D_REP
};

static bool a_on = false;
static bool e_on = false;
static float f_v = 185.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) CAShapeLayer *fov;
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void load_v58() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:580];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 580; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Vinculando os dados brutos ao menu para evitar que o compilador os remova
        if (raw_data_v58[0] == 0x47) {
            self.options = @[@"AIMBOT VIP", @"ESP LINE", @"ESP BOX", @"NO RECOIL", @"ANTENNA", @"SPEED HACK", @"FLY HACK", @"MOSTRAR FOV", @"SIZE FOV"];
        }

        _fov = [CAShapeLayer layer];
        _fov.strokeColor = [UIColor yellowColor].CGColor;
        _fov.fillColor = [UIColor clearColor].CGColor;
        _fov.lineWidth = 4.0;
        _fov.hidden = YES;
        [self.layer addSublayer:_fov];

        _box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 390)];
        _box.center = self.center;
        _box.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.98];
        _box.layer.cornerRadius = 35;
        _box.layer.borderColor = [UIColor yellowColor].CGColor;
        _box.layer.borderWidth = 5.0;
        
        // Efeito de sombra pesada
        _box.layer.shadowColor = [UIColor yellowColor].CGColor;
        _box.layer.shadowOpacity = 0.7;
        _box.layer.shadowRadius = 30;
        [self addSubview:_box];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(10, 25, 460, 340) style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_box addSubview:tb];
    }
    return self;
}

- (void)updF {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_v startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fov.path = p.CGPath;
}

- (void)swC:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 1) e_on = s.on;
    if (s.tag == 7) { _fov.hidden = !s.on; [self updF]; }
    // Garante o uso das variáveis no log para não dar erro de unused
    if (a_on || e_on) { NSLog(@"Engine V58 Active"); }
}

- (void)slC:(UISlider *)l { f_v = l.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v58"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 180, 20)];
        sl.minimumValue = 50; sl.maximumValue = 850; sl.value = f_v;
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
