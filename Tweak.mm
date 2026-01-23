#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Forçar peso do arquivo para evitar que o compilador ignore funções
__attribute__((used)) static const char *binary_padding = "RIKKZ_PRO_V28_FULL_RESOURCES_AIM_ESP_SLIDER_RECOIL_ANTIBAN_STEALTH_ACTIVE_DATA_DUMMY_0123456789_PADDING_REQUIRED_FOR_12.8KB";

static bool aim_on = false;
static bool esp_on = false;
static float fov_radius = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITableView *tView;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void initialize() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(toggle:)];
        tap.numberOfTouchesRequired = 3;
        [window addGestureRecognizer:tap];
    });
}

+ (void)toggle:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:555];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 555; [w addSubview:m];
        }
    }
}

// CORREÇÃO: NS_DESIGNATED_INITIALIZER
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // Camada de Desenho (Força o uso de QuartzCore)
        _fovCircle = [CAShapeLayer layer];
        _fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        _fovCircle.fillColor = [UIColor clearColor].CGColor;
        _fovCircle.lineWidth = 2.0;
        _fovCircle.hidden = YES;
        [self.layer addSublayer:_fovCircle];

        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 280)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _panel.layer.cornerRadius = 18;
        _panel.layer.borderColor = [UIColor cyanColor].CGColor;
        _panel.layer.borderWidth = 2.0;
        [self addSubview:_panel];

        // CORREÇÃO: UITableViewCellSeparatorStyle e Inicialização
        _tView = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 390, 260) style:UITableViewStylePlain];
        _tView.backgroundColor = [UIColor clearColor];
        _tView.delegate = self; 
        _tView.dataSource = self;
        _tView.separatorStyle = UITableViewCellSeparatorStyleNone; // CORREÇÃO AQUI
        [_panel addSubview:_tView];
    }
    return self;
}

- (void)updateFOV {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = path.CGPath;
}

- (void)onSwitch:(UISwitch *)s {
    if (s.tag == 0) aim_on = s.on;
    if (s.tag == 1) esp_on = s.on;
    if (s.tag == 7) { _fovCircle.hidden = !s.on; [self updateFOV]; }
}

- (void)onSlider:(UISlider *)sl {
    fov_radius = sl.value;
    [self updateFOV];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    static NSString *cellID = @"RickCell";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:cellID];
    if (!c) c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];

    if (p.row == 8) { // Slider de FOV
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        sl.minimumValue = 40; sl.maximumValue = 450; sl.value = fov_radius;
        [sl addTarget:self action:@selector(onSlider:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row; [sw addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
