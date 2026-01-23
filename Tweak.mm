#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Forçar inclusão de símbolos para aumentar o tamanho do binário
__attribute__((used)) static const char *binary_weight = "FORCE_SIZE_DATA_0123456789_FF_RIKKZ_PRO_PREMIUM_V27_STEALTH_BYPASS_INTEGRITY_CHECK_ENABLED_FULL_FEATURES_ACTIVE";

static bool aim_on = false;
static bool esp_on = false;
static float fov_val = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *p;
@property (nonatomic, strong) UITableView *t;
@property (nonatomic, strong) CAShapeLayer *f;
@property (nonatomic, strong) NSArray *o;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void load() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        g.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:g];
    });
}

+ (void)tg:(UITapGestureRecognizer *)s {
    if (s.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:777];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 777; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.o = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // Renderização Forçada de FOV
        _f = [CAShapeLayer layer];
        _f.strokeColor = [UIColor cyanColor].CGColor;
        _f.fillColor = [UIColor clearColor].CGColor;
        _f.lineWidth = 2.5;
        _f.hidden = YES;
        [self.layer addSublayer:_f];

        _p = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 395, 265)];
        _p.center = self.center;
        _p.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _p.layer.cornerRadius = 16;
        _p.layer.borderColor = [UIColor cyanColor].CGColor;
        _p.layer.borderWidth = 1.8;
        [self addSubview:_p];

        // Tabela com inicializador padrão corrigido (Fix para NS_DESIGNATED_INITIALIZER)
        _t = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 385, 245) style:UITableViewStylePlain];
        _t.backgroundColor = [UIColor clearColor];
        _t.delegate = self; _t.dataSource = self;
        _t.separatorStyle = 0;
        [_p addSubview:_t];
    }
    return self;
}

- (void)upd {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_val startAngle:0 endAngle:2*M_PI clockwise:YES];
    _f.path = path.CGPath;
}

- (void)sw:(UISwitch *)s {
    if (s.tag == 0) aim_on = s.on;
    if (s.tag == 1) esp_on = s.on;
    if (s.tag == 7) { _f.hidden = !s.on; [self upd]; }
}

- (void)sl:(UISlider *)l { fov_val = l.value; [self upd]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.o.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    static NSString *i = @"c";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:i];
    if (!c) c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:i];
    
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.o[p.row];
    c.textLabel.textColor = [UIColor whiteColor];

    if (p.row == 8) {
        UISlider *l = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        l.minimumValue = 50; l.maximumValue = 400; l.value = fov_val;
        [l addTarget:self action:@selector(sl:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = l;
    } else {
        UISwitch *s = [[UISwitch alloc] init];
        s.tag = p.row; [s addTarget:self action:@selector(sw:) forControlEvents:64];
        c.accessoryView = s;
    }
    return c;
}
@end
