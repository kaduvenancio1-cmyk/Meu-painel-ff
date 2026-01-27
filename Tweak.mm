#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// --- ÂNCORA DE PESO BINÁRIO ---
// Adicionando dados que o compilador é obrigado a carregar
__attribute__((used)) static const char *binary_anchor = "PRO_DATA_V59_RESERVED_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_STABLE_BUILD_KING_RICKZZ";

static bool aim_on = false;
static bool esp_on = false;
static float fov_size = 150.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) CAShapeLayer *fovLayer;
@property (nonatomic, strong) NSArray *menuOptions;
@end

@implementation RickzzMenu

// Inicializador que o iOS executa ao abrir o jogo
__attribute__((constructor))
static void initialize_menu() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(toggle:)];
        tap.numberOfTouchesRequired = 3;
        [window addGestureRecognizer:tap];
    });
}

+ (void)toggle:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UIView *oldMenu = [window viewWithTag:590];
        if (oldMenu) {
            oldMenu.hidden = !oldMenu.hidden;
        } else {
            RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:window.bounds];
            menu.tag = 590;
            [window addSubview:menu];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.menuOptions = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"No Recoil", @"Speed", @"Fov Visible", @"Fov Adjust"];
        
        // FOV (Verde Neon)
        _fovLayer = [CAShapeLayer layer];
        _fovLayer.strokeColor = [UIColor greenColor].CGColor;
        _fovLayer.fillColor = [UIColor clearColor].CGColor;
        _fovLayer.lineWidth = 3.0;
        _fovLayer.hidden = YES;
        [self.layer addSublayer:_fovLayer];

        // PAINEL CENTRAL
        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 350)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
        _panel.layer.cornerRadius = 20;
        _panel.layer.borderColor = [UIColor greenColor].CGColor;
        _panel.layer.borderWidth = 3.0;
        [self addSubview:_panel];

        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 440, 330)];
        table.backgroundColor = [UIColor clearColor];
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_panel addSubview:table];
    }
    return self;
}

- (void)drawFov {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_size startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovLayer.path = path.CGPath;
}

- (void)switchChanged:(UISwitch *)sender {
    if (sender.tag == 0) aim_on = sender.on;
    if (sender.tag == 1) esp_on = sender.on;
    if (sender.tag == 5) {
        _fovLayer.hidden = !sender.on;
        [self drawFov];
    }
}

- (void)sliderChanged:(UISlider *)sender {
    fov_size = sender.value;
    [self drawFov];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.menuOptions.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.menuOptions[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    
    if (p.row == 6) {
        UISlider *s = [[UISlider alloc] initWithFrame:CGRectMake(0,0,150,20)];
        s.minimumValue = 50; s.maximumValue = 500; s.value = fov_size;
        [s addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = s;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row;
        [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
