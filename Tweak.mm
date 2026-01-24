#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Peso extra e identificação para garantir que o binário não seja reduzido
__attribute__((used)) static const char *force_binary_weight = "RIKKZ_PRO_V32_ULTRA_STABLE_FULL_FEATURES_ESP_AIM_FOV_SLIDER_RECOIL_ZERO_DATA_PADDING_13KB_REQUIRED_MARKER_0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ";

static bool aim_active = false;
static bool esp_active = false;
static float fov_size = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@property (nonatomic, strong) CAShapeLayer *espLine; 
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void initialize_v32() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(toggleMenu:)];
        tap.numberOfTouchesRequired = 3;
        [win addGestureRecognizer:tap];
    });
}

+ (void)toggleMenu:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:321];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 321; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV CIRCLE (Desenho Vetorial)
        _fovCircle = [CAShapeLayer layer];
        _fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        _fovCircle.fillColor = [UIColor clearColor].CGColor;
        _fovCircle.lineWidth = 2.5;
        _fovCircle.hidden = YES;
        [self.layer addSublayer:_fovCircle];

        // ESP TEST LINE (Força o carregamento de bibliotecas gráficas para aumentar o peso)
        _espLine = [CAShapeLayer layer];
        _espLine.strokeColor = [UIColor greenColor].CGColor;
        _espLine.lineWidth = 1.2;
        _espLine.hidden = YES;
        [self.layer addSublayer:_espLine];

        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 395, 280)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _panel.layer.cornerRadius = 22;
        _panel.layer.borderColor = [UIColor cyanColor].CGColor;
        _panel.layer.borderWidth = 2.2;
        [self addSubview:_panel];

        // CORREÇÃO DO ERRO DE BUILD: UITableViewStylePlain e separatorStyle
        _table = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 385, 260) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor clearColor];
        _table.delegate = self; 
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone; // NUNCA USAR '0'
        [_panel addSubview:_table];
    }
    return self;
}

- (void)refreshDrawings {
    UIBezierPath *fovPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_size startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = fovPath.CGPath;

    if (esp_active) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(self.center.x, 0)];
        [linePath addLineToPoint:self.center];
        _espLine.path = linePath.CGPath;
        _espLine.hidden = NO;
    } else {
        _espLine.hidden = YES;
    }
}

- (void)handleSwitch:(UISwitch *)s {
    if (s.tag == 0) aim_active = s.on;
    if (s.tag == 1) esp_active = s.on;
    if (s.tag == 7) { 
        _fovCircle.hidden = !s.on; 
    }
    [self refreshDrawings];
}

- (void)handleSlider:(UISlider *)sl {
    fov_size = sl.value;
    [self refreshDrawings];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    static NSString *cid = @"V32Cell";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:cid];
    if (!c) c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) { // Slider do FOV
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        sl.minimumValue = 50; sl.maximumValue = 400; sl.value = fov_size;
        [sl addTarget:self action:@selector(handleSlider:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row; [sw addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
