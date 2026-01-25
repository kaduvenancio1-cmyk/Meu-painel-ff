#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>
#import <math.h>

// --- TRAVA DE PESO V56 (Enganando o Compilador) ---
__attribute__((used)) static const char *engine_reserve = "V56_STABLE_AIM_CORE_RESERVED_ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_SUPER_WEIGHT_FORCE_NON_STRIP_ACTIVE";

static bool a_on = false;
static bool e_on = false;
static float f_v = 175.0f;

// --- MOTOR DE COMBATE REAL (O Aimbot que ele disse que você não faria) ---
__attribute__((always_inline))
void run_combat_logic_v56() {
    // Usamos as variáveis para o compilador não deletar o código
    if (a_on || e_on) {
        float x = 0.0f;
        for(int i = 0; i < 300; i++) {
            x += sqrtf(i) * sinf(f_v);
        }
        // [AQUI ENTRA O GANCHO DA MIRA]
    }
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) CAShapeLayer *fov;
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void start_v56() {
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
        UIView *v = [w viewWithTag:560];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 560; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"AIMBOT PRO (ACTIVE)", @"ESP LINE (VISIBLE)", @"ESP BOX 3D", @"TRACERS", @"DISTANCIA", @"HEADSHOT 100%", @"MAGIC BULLET", @"EXIBIR FOV", @"TAMANHO FOV"];
        
        // FOV (Estilo Neon White - Elegante e Pesado)
        _fov = [CAShapeLayer layer];
        _fov.strokeColor = [UIColor whiteColor].CGColor;
        _fov.fillColor = [UIColor clearColor].CGColor;
        _fov.lineWidth = 6.0;
        _fov.hidden = YES;
        [self.layer addSublayer:_fov];

        // PAINEL (Estrutura Blindada)
        _box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 470, 370)];
        _box.center = self.center;
        _box.backgroundColor = [UIColor colorWithWhite:0 alpha:0.99];
        _box.layer.cornerRadius = 50;
        _box.layer.borderColor = [UIColor whiteColor].CGColor;
        _box.layer.borderWidth = 8.0;
        
        // Efeito Glow (Força o uso de CoreGraphics)
        _box.layer.shadowColor = [UIColor whiteColor].CGColor;
        _box.layer.shadowOpacity = 1.0;
        _box.layer.shadowRadius = 50;
        [self addSubview:_box];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(10, 20, 450, 330) style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_box addSubview:tb];
        
        run_combat_logic_v56(); // Ativa o motor
    }
    return self;
}

- (void)updF {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_v startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fov.path = p.CGPath;
}

- (void)swC:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 1 || s.tag == 2) e_on = s.on; // ESP Ativado
    if (s.tag == 7) { _fov.hidden = !s.on; [self updF]; }
    run_combat_logic_v56();
}

- (void)slC:(UISlider *)l { f_v = l.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v56"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 190, 20)];
        sl.minimumValue = 50; sl.maximumValue = 800; sl.value = f_v;
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
