#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>

// ESTRUTURA DE PESO V51 - Forçando o binário para a zona de segurança (16KB+)
__attribute__((used)) static const char *v51_core_data = "V51_ULTRA_STABLE_RESERVE_DATA_STRIP_PREVENT_0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ_FORCE_KEEP_ALIVE_BLOCK_X_PRO_AIM_ESP_STSTLTH";

static bool aim_on = false;
static bool esp_on = false;
static float fov_val = 150.0f;

// --- MOTOR DE COMBATE V51 (Oculto em Animação) ---
@interface CombatEngine : NSObject
+ (void)syncCombat;
@end

@implementation CombatEngine
+ (void)syncCombat {
    // O compilador não apaga isso porque está dentro de uma classe ativa
    if (aim_on) {
        // [AIMBOT LOGIC] Cálculo de distância e trava magnética
    }
}
@end

void (*old_Upd)(void *instance);
void new_Upd(void *instance) {
    if (instance != NULL) {
        [CombatEngine syncCombat];
    }
    old_Upd(instance);
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) CAShapeLayer *fovL;
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void start_v51() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(toggle:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)toggle:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:510];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 510; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV (Estilo Neon Violet - Linha Dupla)
        _fovL = [CAShapeLayer layer];
        _fovL.strokeColor = [UIColor purpleColor].CGColor;
        _fovL.fillColor = [UIColor clearColor].CGColor;
        _fovL.lineWidth = 6.0;
        _fovL.hidden = YES;
        [self.layer addSublayer:_fovL];

        // PAINEL (Construção Ultra-Pesada para Peso)
        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 350)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _panel.layer.cornerRadius = 50;
        _panel.layer.borderColor = [UIColor purpleColor].CGColor;
        _panel.layer.borderWidth = 8.0;
        
        // Sombra de Alta Densidade (Força o CoreGraphics)
        _panel.layer.shadowColor = [UIColor purpleColor].CGColor;
        _panel.layer.shadowOpacity = 1.0;
        _panel.layer.shadowRadius = 50;
        _panel.layer.shadowOffset = CGSizeZero;
        [self addSubview:_panel];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(5, 15, 440, 320) style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_panel addSubview:tb];
    }
    return self;
}

- (void)updFov {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_val startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovL.path = p.CGPath;
}

- (void)swC:(UISwitch *)s {
    if (s.tag == 0) aim_on = s.on;
    if (s.tag == 1) esp_on = s.on;
    if (s.tag == 7) { _fovL.hidden = !s.on; [self updFov]; }
}

- (void)slC:(UISlider *)l { fov_val = l.value; [self updFov]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v51"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 180, 20)];
        sl.minimumValue = 50; sl.maximumValue = 600; sl.value = fov_val;
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
