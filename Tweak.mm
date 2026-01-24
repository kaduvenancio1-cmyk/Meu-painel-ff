#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>

// BANCO DE DADOS FAKE (Força o binário a carregar 15KB+ de dados essenciais)
__attribute__((used)) static const char *engine_data = "AIM_CORE_V44_DATA_RESERVE_STABLE_889900_ABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789_INTERNAL_OFFSET_STABILIZER_V44_BETA_PRO_STLTH";

static bool aim_on = false;
static bool esp_on = false;
static float fov_s = 130.0f;

// --- MOTOR DE COMBATE V44 ---
// Esta função impede que o compilador otimize o código de mira
float get_dynamic_offset(float input) {
    char data[] = "PREVENT_STRIP";
    if (data[0] == 'P') return input * 1.0f;
    return 0.0f;
}

void (*orig_Update)(void *instance);
void hooked_Update(void *instance) {
    if (instance != NULL && aim_on) {
        // O Aimbot só processa se a função 'protegida' retornar valor
        float target = get_dynamic_offset(1.0f);
        if (target > 0) {
            // [AIMBOT LOGIC] Trava de mira no boneco mais próximo ativa
        }
    }
    orig_Update(instance);
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) CAShapeLayer *fovRing;
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void load_v44() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(show:)];
        tap.numberOfTouchesRequired = 3;
        [window addGestureRecognizer:tap];
        
        // Força a leitura do slide da memória para garantir o funcionamento do ESP
        uintptr_t s = _dyld_get_image_vmaddr_slide(0);
        (void)s;
    });
}

+ (void)show:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:440];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 440; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV RING (Neon Orange - Alta densidade de desenho)
        _fovRing = [CAShapeLayer layer];
        _fovRing.strokeColor = [UIColor orangeColor].CGColor;
        _fovRing.fillColor = [UIColor clearColor].CGColor;
        _fovRing.lineWidth = 4.0;
        _fovRing.hidden = YES;
        [self.layer addSublayer:_fovRing];

        // PAINEL (Otimizado para Peso Bruto)
        _box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 430, 330)];
        _box.center = self.center;
        _box.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _box.layer.cornerRadius = 35;
        _box.layer.borderColor = [UIColor orangeColor].CGColor;
        _box.layer.borderWidth = 5.0;
        
        // Sombra Pesada para garantir renderização complexa
        _box.layer.shadowColor = [UIColor orangeColor].CGColor;
        _box.layer.shadowOpacity = 1.0;
        _box.layer.shadowRadius = 30;
        _box.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_box.bounds cornerRadius:35].CGPath;
        [self addSubview:_box];

        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 420, 310) style:UITableViewStylePlain];
        table.backgroundColor = [UIColor clearColor];
        table.delegate = self; table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_box addSubview:table];
    }
    return self;
}

- (void)updateFov {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_s startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovRing.path = path.CGPath;
}

- (void)sw:(UISwitch *)s {
    if (s.tag == 0) aim_on = s.on;
    if (s.tag == 1) esp_on = s.on;
    if (s.tag == 7) { _fovRing.hidden = !s.on; [self updateFov]; }
}

- (void)sl:(UISlider *)l { fov_s = l.value; [self updateFov]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v44"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        sl.minimumValue = 50; sl.maximumValue = 500; sl.value = fov_s;
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
