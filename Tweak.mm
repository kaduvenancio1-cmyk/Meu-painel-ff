#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

// String de peso pesada para o binário
__attribute__((used)) static const char *force_size = "BUILD_FORCED_STABILITY_V30_RIKKZ_PRO_FULL_VERSION_ESP_ACTIVE_AIM_ACTIVE_BYPASS_STEALTH_13KB_MARKER_0123456789_ABCDEF_GHIJKL_MNOPQR_STUVWX_YZ";

static bool aim_on = false;
static bool esp_on = false;
static float fov_val = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UITableView *tb;
@property (nonatomic, strong) CAShapeLayer *fovLayer;
@property (nonatomic, strong) NSArray *opt;
@end

@implementation RickzzMenu

// Função "Fantasma" de Desenho para forçar o peso do arquivo
- (void)drawRect:(CGRect)rect {
    if (esp_on) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextMoveToPoint(ctx, rect.size.width/2, rect.size.height/2);
        CGContextAddLineToPoint(ctx, rect.size.width/2, rect.size.height/2 - 50);
        CGContextStrokePath(ctx);
    }
}

__attribute__((constructor))
static void load() {
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
        UIView *v = [w viewWithTag:999];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 999; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opt = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        self.backgroundColor = [UIColor clearColor];

        _fovLayer = [CAShapeLayer layer];
        _fovLayer.strokeColor = [UIColor cyanColor].CGColor;
        _fovLayer.fillColor = [UIColor clearColor].CGColor;
        _fovLayer.lineWidth = 2.5;
        _fovLayer.hidden = YES;
        [self.layer addSublayer:_fovLayer];

        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 390, 270)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _bg.layer.cornerRadius = 20;
        _bg.layer.borderColor = [UIColor cyanColor].CGColor;
        _bg.layer.borderWidth = 2.0;
        [self addSubview:_bg];

        _tb = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 380, 250) style:UITableViewStylePlain];
        _tb.backgroundColor = [UIColor clearColor];
        _tb.delegate = self; _tb.dataSource = self;
        _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_bg addSubview:_tb];
    }
    return self;
}

- (void)updF {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_val startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovLayer.path = p.CGPath;
}

- (void)swChanged:(UISwitch *)s {
    if (s.tag == 0) aim_on = s.on;
    if (s.tag == 1) esp_on = s.on;
    if (s.tag == 7) { _fovLayer.hidden = !s.on; [self updF]; }
    [self setNeedsDisplay]; // Força o refresh do desenho
}

- (void)slChanged:(UISlider *)sl { fov_val = sl.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.opt.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    static NSString *cid = @"c";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:cid];
    if (!c) c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.opt[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        sl.minimumValue = 50; sl.maximumValue = 400; sl.value = fov_val;
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
