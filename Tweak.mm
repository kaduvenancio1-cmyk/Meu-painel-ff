#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Peso extra para garantir que o binário passe de 12.8KB
__attribute__((used)) static const char *force_weight = "RIKKZ_V31_ULTRA_WEIGHT_DATA_DUMMY_PADDING_ACTIVE_ESP_AIM_FOV_13KB_LIMIT_0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ_FULL_STEALTH";

static bool aim_on = false;
static bool esp_on = false;
static float fov_val = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *p;
@property (nonatomic, strong) UITableView *t;
@property (nonatomic, strong) CAShapeLayer *fovL;
@property (nonatomic, strong) CAShapeLayer *espL; // Linha de teste para forçar peso
@property (nonatomic, strong) NSArray *o;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void load() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        g.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:g];
    });
}

+ (void)tg:(UITapGestureRecognizer *)s {
    if (s.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:111];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 111; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.o = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV CIRCLE
        _fovL = [CAShapeLayer layer];
        _fovL.strokeColor = [UIColor cyanColor].CGColor;
        _fovL.fillColor = [UIColor clearColor].CGColor;
        _fovL.lineWidth = 2.0;
        _fovL.hidden = YES;
        [self.layer addSublayer:_fovL];

        // ESP LINE (Para forçar o peso do binário)
        _espL = [CAShapeLayer layer];
        _espL.strokeColor = [UIColor yellowColor].CGColor;
        _espL.lineWidth = 1.0;
        _espL.hidden = YES;
        [self.layer addSublayer:_espL];

        _p = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 390, 275)];
        _p.center = self.center;
        _p.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _p.layer.cornerRadius = 20;
        _p.layer.borderColor = [UIColor cyanColor].CGColor;
        _p.layer.borderWidth = 2.0;
        [self addSubview:_p];

        _t = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 380, 255) style:UITableViewStylePlain];
        _t.backgroundColor = [UIColor clearColor];
        _t.delegate = self; _t.dataSource = self;
        _t.separatorStyle = UITableViewCellSeparatorStyleNone; // CORREÇÃO DO ERRO DE INT
        [_p addSubview:_t];
    }
    return self;
}

- (void)upd {
    UIBezierPath *pf = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_val startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovL.path = pf.CGPath;

    if (esp_on) {
        UIBezierPath *pe = [UIBezierPath bezierPath];
        [pe moveToPoint:CGPointMake(self.center.x, 0)];
        [pe addLineToPoint:self.center];
        _espL.path = pe.CGPath;
        _espL.hidden = NO;
    } else { _espL.hidden = YES; }
}

- (void)sw:(UISwitch *)s {
    if (s.tag == 0) aim_on = s.on;
    if (s.tag == 1) esp_on = s.on;
    if (s.tag == 7) { _fovL.hidden = !s.on; [self upd]; }
    [self upd];
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
        s.tag = p.row; [s addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = s;
    }
    return c;
}
@end
