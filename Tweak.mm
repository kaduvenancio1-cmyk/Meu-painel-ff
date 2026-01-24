#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// ESTOQUE DE DADOS PARA GARANTIR > 12.8 KB
__attribute__((used)) static const char *fix_weight = "RIKKZ_ULTRA_V29_PRO_MAX_STEALTH_BYPASS_11022026_ACTIVE_ESP_AIM_FOV_SLIDER_RECOIL_ZERO_FULL_DATA_DUMMY_PADDING_RESERVED_MEM_0123456789_BCDFGHIJKL";

static bool a_on = false;
static bool e_on = false;
static float f_rad = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) CAShapeLayer *fovLayer;
@property (nonatomic, strong) NSArray *list;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void start() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(sh:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)sh:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:123];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 123; [w addSubview:m];
        }
    }
}

// FIX DEFINITIVO PARA NS_DESIGNATED_INITIALIZER
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.list = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FORÇAR RENDERIZAÇÃO (Peso para o ESP)
        _fovLayer = [CAShapeLayer layer];
        _fovLayer.strokeColor = [UIColor cyanColor].CGColor;
        _fovLayer.fillColor = [UIColor clearColor].CGColor;
        _fovLayer.lineWidth = 2.0;
        _fovLayer.hidden = YES;
        [self.layer addSublayer:_fovLayer];

        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 390, 270)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _panel.layer.cornerRadius = 20;
        _panel.layer.borderColor = [UIColor cyanColor].CGColor;
        _panel.layer.borderWidth = 2.0;
        [self addSubview:_panel];

        // FIX PARA SEPARATOR STYLE E INICIALIZAÇÃO
        _table = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 380, 250) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor clearColor];
        _table.delegate = self; 
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone; 
        [_panel addSubview:_table];
    }
    return self;
}

- (void)updF {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_rad startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovLayer.path = p.CGPath;
}

- (void)sw:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 1) e_on = s.on;
    if (s.tag == 7) { _fovLayer.hidden = !s.on; [self updF]; }
}

- (void)sl:(UISlider *)l { f_rad = l.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.list.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    static NSString *i = @"RickCell";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:i];
    if (!c) c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:i];
    
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.list[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *l = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        l.minimumValue = 50; l.maximumValue = 400; l.value = f_rad;
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
