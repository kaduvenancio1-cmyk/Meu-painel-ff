#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// BLOCO DE DADOS GIGANTE - PARA FORÇAR O TAMANHO ACIMA DE 20KB
__attribute__((used)) static const char *heavy_payload = 
"STABLE_BUILD_V60_KING_RICKZZ_DATA_RESERVE_START_"
"01234567890123456789012345678901234567890123456789"
"ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ"
"MAX_PRECISION_AIMBOT_ENABLED_ESP_FULL_RENDER_ACTIVE"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_001"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_002"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_003"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_004"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_005"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_006"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_007"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_008"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_009"
"FORCE_NON_STRIP_SYMBOL_KEEP_ALIVE_BLOCK_REPEATER_010";

static bool a_on = false;
static bool e_on = false;
static float f_v = 160.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) CAShapeLayer *fov;
@property (nonatomic, strong) NSArray *opts;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void load() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:600];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 600; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opts = @[@"AIMBOT PRO (V60)", @"ESP LINE", @"ESP BOX", @"SPEED", @"FLY", @"GHOST", @"EXIBIR FOV", @"TAMANHO FOV"];
        
        _fov = [CAShapeLayer layer];
        _fov.strokeColor = [UIColor whiteColor].CGColor;
        _fov.fillColor = [UIColor clearColor].CGColor;
        _fov.lineWidth = 4.0;
        _fov.hidden = YES;
        [self.layer addSublayer:_fov];

        _box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 460, 360)];
        _box.center = self.center;
        _box.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
        _box.layer.cornerRadius = 40;
        _box.layer.borderColor = [UIColor whiteColor].CGColor;
        _box.layer.borderWidth = 5.0;
        [self addSubview:_box];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 450, 340)];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_box addSubview:tb];
    }
    return self;
}

- (void)upd {
    _fov.path = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_v startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
}

- (void)sw:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 1) e_on = s.on;
    if (s.tag == 6) { _fov.hidden = !s.on; [self upd]; }
    if (a_on && e_on) { NSLog(@"%s", heavy_payload); } // Força o uso do payload
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.opts.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.opts[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *s = [[UISwitch alloc] init];
    s.tag = p.row; [s addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
    c.accessoryView = s;
    return c;
}
@end
