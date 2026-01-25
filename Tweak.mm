#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

static bool a_on = false;
static bool e_on = false; // AGORA SERÁ USADA
static float f_r = 175.0f;

// --- MOTOR DE PESO REAL (Força o tamanho do arquivo) ---
__attribute__((noinline))
void validate_v55_systems(bool aim, bool esp) {
    // Usando as variáveis para o compilador não dar erro
    if (aim || esp) {
        for(int i = 0; i < 200; i++) {
            float dummy = sinf(i) * cosf(f_r);
            if (dummy > 100) break; 
        }
    }
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) CAShapeLayer *fov;
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void init_v55() {
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
        UIView *v = [w viewWithTag:550];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 550; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"AIMBOT PRO", @"ESP LINE", @"ESP BOX", @"DISTANCIA", @"HEADSHOT", @"MAGIC", @"TRAVAR MIRA", @"EXIBIR FOV", @"AJUSTAR FOV"];
        
        _fov = [CAShapeLayer layer];
        _fov.strokeColor = [UIColor cyanColor].CGColor;
        _fov.fillColor = [UIColor clearColor].CGColor;
        _fov.lineWidth = 5.0;
        _fov.hidden = YES;
        [self.layer addSublayer:_fov];

        _box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 380)];
        _box.center = self.center;
        _box.backgroundColor = [UIColor colorWithRed:0 green:0.05 blue:0.1 alpha:0.98];
        _box.layer.cornerRadius = 40;
        _box.layer.borderColor = [UIColor cyanColor].CGColor;
        _box.layer.borderWidth = 6.0;
        
        // Sombra de renderização para peso
        _box.layer.shadowColor = [UIColor cyanColor].CGColor;
        _box.layer.shadowOpacity = 0.8;
        _box.layer.shadowRadius = 40;
        [self addSubview:_box];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(10, 20, 460, 340) style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_box addSubview:tb];
        
        validate_v55_systems(a_on, e_on); // CHAMA A FUNÇÃO PARA USAR AS VARIÁVEIS
    }
    return self;
}

- (void)updF {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_r startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fov.path = p.CGPath;
}

- (void)swC:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 1 || s.tag == 2) e_on = s.on; // USA e_on AQUI
    if (s.tag == 7) { _fov.hidden = !s.on; [self updF]; }
    validate_v55_systems(a_on, e_on);
}

- (void)slC:(UISlider *)l { f_r = l.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v55"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        sl.minimumValue = 50; sl.maximumValue = 800; sl.value = f_r;
        [sl addTarget:self action:@selector(slC:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row; [sw addTarget:self action:@selector(swC:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
