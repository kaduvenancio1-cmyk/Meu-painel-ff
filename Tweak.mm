#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static bool aim_on = false;
static bool esp_on = false;
static float fov_val = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UITableView *tb;
@property (nonatomic, strong) CAShapeLayer *fovL;
@property (nonatomic, strong) NSArray *opt;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void start() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:666];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 666; [w addSubview:m];
        }
    }
}

// SOLUÇÃO DO ERRO NS_DESIGNATED_INITIALIZER
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opt = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FORÇAR DESENHO DO FOV
        _fovL = [CAShapeLayer layer];
        _fovL.strokeColor = [UIColor cyanColor].CGColor;
        _fovL.fillColor = [UIColor clearColor].CGColor;
        _fovL.lineWidth = 2.0;
        _fovL.hidden = YES;
        [self.layer addSublayer:_fovL];

        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 390, 260)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _bg.layer.cornerRadius = 12;
        _bg.layer.borderColor = [UIColor cyanColor].CGColor;
        _bg.layer.borderWidth = 1.5;
        [self addSubview:_bg];

        // INICIALIZAÇÃO CORRETA DA TABELA
        _tb = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 380, 240) style:UITableViewStylePlain];
        _tb.backgroundColor = [UIColor clearColor];
        _tb.delegate = self; _tb.dataSource = self;
        _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_bg addSubview:_tb];
    }
    return self;
}

- (void)updF {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_val startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovL.path = p.CGPath;
}

- (void)swChanged:(UISwitch *)s {
    if (s.tag == 0) aim_on = s.on;
    if (s.tag == 1) esp_on = s.on;
    if (s.tag == 7) { _fovL.hidden = !s.on; [self updF]; }
}

- (void)slChanged:(UISlider *)sl {
    fov_val = sl.value; [self updF];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.opt.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    // CORREÇÃO DEFINITIVA DE CÉLULA PARA O THEOS
    static NSString *cid = @"cell";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:cid];
    if (!c) {
        c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.opt[p.row];
    c.textLabel.textColor = [UIColor whiteColor];

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 110, 20)];
        sl.minimumValue = 50; sl.maximumValue = 350; sl.value = fov_val;
        [sl addTarget:self action:@selector(slChanged:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row;
        [sw addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
