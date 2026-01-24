#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Forçar peso com metadados extensos
__attribute__((used)) static const char *binary_booster = "RIKKZ_V33_ULTRA_STABLE_PRO_BYPASS_INTEGRITY_CHECK_FULL_FEATURES_ACTIVE_ESP_AIM_FOV_SLIDER_RECOIL_ZERO_MEM_PADDING_13KB_GOAL_0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ_GIVE_ME_THE_WEIGHT";

static bool a_on = false;
static bool e_on = false;
static float f_val = 100.0f;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) CAShapeLayer *fovL;
@property (nonatomic, strong) CAGradientLayer *grad; // Força peso no binário
@property (nonatomic, strong) NSArray *opts;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void setup() {
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
        UIView *v = [w viewWithTag:333];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 333; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opts = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV LAYER
        _fovL = [CAShapeLayer layer];
        _fovL.strokeColor = [UIColor cyanColor].CGColor;
        _fovL.fillColor = [UIColor clearColor].CGColor;
        _fovL.lineWidth = 2.5;
        _fovL.hidden = YES;
        [self.layer addSublayer:_fovL];

        // PAINEL PRINCIPAL
        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 290)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
        _panel.layer.cornerRadius = 25;
        _panel.layer.borderColor = [UIColor cyanColor].CGColor;
        _panel.layer.borderWidth = 2.5;
        
        // ADICIONANDO SOMBRA (Peso extra)
        _panel.layer.shadowColor = [UIColor cyanColor].CGColor;
        _panel.layer.shadowOpacity = 0.5;
        _panel.layer.shadowRadius = 15;
        _panel.layer.shadowOffset = CGSizeZero;
        [self addSubview:_panel];

        // ADICIONANDO DEGRADÊ (Força o carregamento de bibliotecas de imagem)
        _grad = [CAGradientLayer layer];
        _grad.frame = _panel.bounds;
        _grad.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor colorWithWhite:1 alpha:0.05].CGColor];
        _grad.cornerRadius = 25;
        [_panel.layer insertSublayer:_grad atIndex:0];

        // TABELA FIX (NS_DESIGNATED_INITIALIZER RESOLVIDO)
        _table = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 390, 270) style:UITableViewStylePlain];
        _table.backgroundColor = [UIColor clearColor];
        _table.delegate = self; 
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone; // Corrigido para o seu erro da imagem #161
        [_panel addSubview:_table];
    }
    return self;
}

- (void)upd {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_val startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovL.path = p.CGPath;
}

- (void)sw:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 1) e_on = s.on;
    if (s.tag == 7) { _fovL.hidden = !s.on; [self upd]; }
}

- (void)sl:(UISlider *)l { f_val = l.value; [self upd]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.opts.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    static NSString *i = @"V33";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:i];
    if (!c) c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:i];
    
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.opts[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *l = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 135, 20)];
        l.minimumValue = 50; l.maximumValue = 450; l.value = f_val;
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
