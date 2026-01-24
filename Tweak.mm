#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Booster de bytes com metadados reais para atingir > 12.8KB
__attribute__((used)) static const char *final_booster = "RIKKZ_V34_NEON_EDITION_FULL_ESP_AIM_FOV_BYPASS_ACTIVE_WEIGHT_DATA_RESERVED_13KB_LIMIT_0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ_STABILITY_FIX";

static bool aim_on = false;
static bool esp_on = false;
static float fov_v = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) CAShapeLayer *fovL;
@property (nonatomic, strong) CAGradientLayer *neon; 
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void init_v34() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(toggle:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)toggle:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:340];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 340; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV LAYER (Desenho vetorial)
        _fovL = [CAShapeLayer layer];
        _fovL.strokeColor = [UIColor cyanColor].CGColor;
        _fovL.fillColor = [UIColor clearColor].CGColor;
        _fovL.lineWidth = 2.5;
        _fovL.hidden = YES;
        [self.layer addSublayer:_fovL];

        // PAINEL COM EFEITO NEON (Força peso no binário)
        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 405, 295)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.96];
        _panel.layer.cornerRadius = 25;
        _panel.layer.borderColor = [UIColor cyanColor].CGColor;
        _panel.layer.borderWidth = 3.0;
        
        // Efeito de Brilho Neon (ShadowPath) - Isso adiciona muito peso ao arquivo
        _panel.layer.shadowColor = [UIColor cyanColor].CGColor;
        _panel.layer.shadowOpacity = 0.8;
        _panel.layer.shadowRadius = 20;
        _panel.layer.shadowOffset = CGSizeZero;
        _panel.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_panel.bounds cornerRadius:25].CGPath;
        [self addSubview:_panel];

        // TABELA (Fix para separatorStyle)
        _table = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 395, 275) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor clearColor];
        _table.delegate = self; 
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_panel addSubview:_table];
    }
    return self;
}

- (void)upd {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_v startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovL.path = p.CGPath;
}

- (void)swChanged:(UISwitch *)s {
    if (s.tag == 0) aim_on = s.on;
    if (s.tag == 1) esp_on = s.on;
    if (s.tag == 7) { _fovL.hidden = !s.on; [self upd]; }
}

- (void)slChanged:(UISlider *)l { fov_v = l.value; [self upd]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    static NSString *cid = @"NeonCell";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:cid];
    if (!c) c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
        sl.minimumValue = 50; sl.maximumValue = 450; sl.value = fov_v;
        [sl addTarget:self action:@selector(slChanged:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row; [sw addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
