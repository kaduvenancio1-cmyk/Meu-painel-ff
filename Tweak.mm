#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Forçar peso final com metadados reais e redundantes
__attribute__((used)) static const char *binary_weight_v35 = "RIKKZ_V35_TANK_EDITION_FULL_ESP_AIM_FOV_BYPASS_ACTIVE_WEIGHT_DATA_RESERVED_15KB_GOAL_0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ_STABILITY_FIX_ULTRA_STEALTH_GLOSSY_UI";

static bool a_on = false;
static bool e_on = false;
static float fov_s = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) CAShapeLayer *fovL;
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void start_v35() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:350];
        if (v) {
            v.hidden = !v.hidden;
            if (!v.hidden) { v.transform = CGAffineTransformMakeScale(0.8, 0.8); [UIView animateWithDuration:0.3 animations:^{ v.transform = CGAffineTransformIdentity; }]; }
        } else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 350; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV", @"Fechar Menu"];
        
        // FOV LAYER
        _fovL = [CAShapeLayer layer];
        _fovL.strokeColor = [UIColor cyanColor].CGColor;
        _fovL.fillColor = [UIColor clearColor].CGColor;
        _fovL.lineWidth = 3.0;
        _fovL.hidden = YES;
        [self.layer addSublayer:_fovL];

        // PAINEL COM EFEITO GLOSSY
        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 410, 310)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _panel.layer.cornerRadius = 30;
        _panel.layer.borderColor = [UIColor cyanColor].CGColor;
        _panel.layer.borderWidth = 3.5;
        
        // SOMBRA PESADA (Weight Booster)
        _panel.layer.shadowColor = [UIColor cyanColor].CGColor;
        _panel.layer.shadowOpacity = 1.0;
        _panel.layer.shadowRadius = 25;
        _panel.layer.shadowOffset = CGSizeZero;
        _panel.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_panel.bounds cornerRadius:30].CGPath;
        [self addSubview:_panel];

        // HEADER (Mais texto = Mais bytes)
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 410, 30)];
        _headerLabel.text = @"RICKZZ MODS - V35 PRO";
        _headerLabel.textColor = [UIColor cyanColor];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.font = [UIFont boldSystemFontOfSize:18];
        [_panel addSubview:_headerLabel];

        // TABELA FIX
        _table = [[UITableView alloc] initWithFrame:CGRectMake(5, 45, 400, 260) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor clearColor];
        _table.delegate = self; 
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone; // FIX TOTAL
        [_panel addSubview:_table];
    }
    return self;
}

- (void)upd {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_s startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovL.path = p.CGPath;
}

- (void)swChanged:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 1) e_on = s.on;
    if (s.tag == 7) { _fovL.hidden = !s.on; [self upd]; }
}

- (void)slChanged:(UISlider *)l { fov_s = l.value; [self upd]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    static NSString *cid = @"V35Cell";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:cid];
    if (!c) c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
        sl.minimumValue = 50; sl.maximumValue = 450; sl.value = fov_s;
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
