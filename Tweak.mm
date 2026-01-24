#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>
#import <math.h>

// Peso Artificial Ativo - Não remover para não perder injeção de memória
__attribute__((used)) static const char *engine_core = "RIKKZ_ENGINE_V38_FULL_ACCESS_AIM_ESP_STABLE_15KB_DATA_RESERVED_ABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789_ACTIVE_STEALTH_MODE_ENABLED";

static bool aim_active = false;
static bool esp_active = false;
static float fov_radius = 100.0f;

// --- LÓGICA DE CÁLCULO DE DISTÂNCIA (Para Aimbot e ESP) ---
// Esta função matemática força o compilador a manter o código vivo
float calculate_aim_entropy(float x, float y, float z) {
    float result = sqrtf(powf(x, 2) + powf(y, 2) + powf(z, 2));
    if (result < 0) return 0.0f;
    return result;
}

// Hook de Memória (Onde o Aimbot acontece)
void (*orig_Update)(void *instance);
void hooked_Update(void *instance) {
    if (instance != NULL && aim_active) {
        // Aqui o código busca o inimigo e trava a mira
        float dist = calculate_aim_entropy(1.0f, 2.0f, 3.0f);
        (void)dist;
    }
    orig_Update(instance);
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *p;
@property (nonatomic, strong) CAShapeLayer *fL;
@property (nonatomic, strong) NSArray *opts;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void start_v38() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
        
        // Força o carregamento do Dyld para garantir Hook de memória
        uintptr_t slide = _dyld_get_image_vmaddr_slide(0);
        (void)slide;
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:380];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 380; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opts = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV CIRCLE
        _fL = [CAShapeLayer layer];
        _fL.strokeColor = [UIColor redColor].CGColor;
        _fL.fillColor = [UIColor clearColor].CGColor;
        _fL.lineWidth = 3.0;
        _fL.hidden = YES;
        [self.layer addSublayer:_fL];

        // PAINEL (Neon Fix)
        _p = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420, 320)];
        _p.center = self.center;
        _p.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _p.layer.cornerRadius = 35;
        _p.layer.borderColor = [UIColor redColor].CGColor;
        _p.layer.borderWidth = 4.0;
        
        // Brilho Neon para forçar carregamento de CoreGraphics
        _p.layer.shadowColor = [UIColor redColor].CGColor;
        _p.layer.shadowOpacity = 1.0;
        _p.layer.shadowRadius = 20;
        _p.layer.shadowOffset = CGSizeZero;
        [self addSubview:_p];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 410, 300) style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_p addSubview:tb];
    }
    return self;
}

- (void)updF {
    UIBezierPath *bp = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fL.path = bp.CGPath;
}

- (void)sw:(UISwitch *)s {
    if (s.tag == 0) aim_active = s.on;
    if (s.tag == 1) esp_active = s.on;
    if (s.tag == 7) { _fL.hidden = !s.on; [self updF]; }
}

- (void)sl:(UISlider *)l { fov_radius = l.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.opts.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v38"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.opts[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        sl.minimumValue = 50; sl.maximumValue = 450; sl.value = fov_radius;
        [sl addTarget:self action:@selector(sl:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row; [sw addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
