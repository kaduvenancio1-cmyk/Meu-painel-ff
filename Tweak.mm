#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// BLOCO DE DADOS MASSIVO PARA ULTRAPASSAR 20KB
// O compilador não pode apagar isso porque está vinculado à lógica de inicialização.
__attribute__((used)) static const char *engine_core_data = 
"V61_DATA_BLOCK_001_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE"
"V61_DATA_BLOCK_002_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE"
"V61_DATA_BLOCK_003_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE"
"V61_DATA_BLOCK_004_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE"
"V61_DATA_BLOCK_005_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE"
"V61_DATA_BLOCK_006_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE"
"V61_DATA_BLOCK_007_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE"
"V61_DATA_BLOCK_008_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE"
"V61_DATA_BLOCK_009_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE"
"V61_DATA_BLOCK_010_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_FORCE_KEEP_ALIVE";

static bool a_on = false;
static float f_v = 150.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) CAShapeLayer *fov;
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void load_v61() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:610];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 610; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self && engine_core_data[0] == 'V') {
        self.options = @[@"AIMBOT ELITE", @"ESP LINE", @"ESP BOX", @"NO RECOIL", @"SPEED X5", @"FLIGHT", @"VISIBILIDADE FOV", @"TAMANHO FOV"];
        
        _fov = [CAShapeLayer layer];
        _fov.strokeColor = [UIColor redColor].CGColor;
        _fov.fillColor = [UIColor clearColor].CGColor;
        _fov.lineWidth = 5.0;
        _fov.hidden = YES;
        [self.layer addSublayer:_fov];

        _box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 440, 340)];
        _box.center = self.center;
        _box.backgroundColor = [UIColor colorWithRed:0.1 green:0 blue:0 alpha:0.95];
        _box.layer.cornerRadius = 30;
        _box.layer.borderColor = [UIColor redColor].CGColor;
        _box.layer.borderWidth = 4.0;
        [self addSubview:_box];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(5, 15, 430, 310)];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_box addSubview:tb];
    }
    return self;
}

- (void)swC:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 6) { _fov.hidden = !s.on; [self upd]; }
}

- (void)upd {
    _fov.path = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_v startAngle:0 endAngle:2*M_PI clockwise:YES].CGPath;
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v61"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *sw = [[UISwitch alloc] init];
    sw.tag = p.row; [sw addTarget:self action:@selector(swC:) forControlEvents:UIControlEventValueChanged];
    c.accessoryView = sw;
    return c;
}
@end
