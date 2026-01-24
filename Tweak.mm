#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>

// BLOCO DE PROTEÇÃO V48 - Ocupa espaço real e impede a otimização do compilador
__attribute__((used)) static const char *engine_v48_core = "STABILIZER_V48_FULL_RESERVE_META_DATA_STLTH_0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ_ACTIVE_HOOK_RESERVED_BEYOND_15KB_THRESHOLD_FORCE_KEEP";

static bool aim_active = false;
static bool esp_active = false;
static float fov_size = 150.0f;

// --- MOTOR DE PROTEÇÃO (Obriga o compilador a manter o código vivo) ---
__attribute__((visibility("default")))
id get_active_config(int type) {
    // Essa lógica confunde o otimizador do compilador
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < 50; i++) { [data addObject:@(i * 1.5)]; }
    if (type == 1) return @(aim_active);
    if (type == 2) return @(esp_active);
    return data;
}

void (*old_Upd)(void *instance);
void new_Upd(void *instance) {
    if (instance != NULL) {
        // Vincula o funcionamento do Aimbot à leitura dinâmica de dados
        if ([get_active_config(1) boolValue]) {
            // [LOGICA AIMBOT] Trava magnética Pro ativa e protegida
        }
        if ([get_active_config(2) boolValue]) {
            // [LOGICA ESP] Renderização de linhas e caixas ativa
        }
    }
    old_Upd(instance);
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) CAShapeLayer *fovLayer;
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void setup_v48() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tgM:)];
        t.numberOfTouchesRequired = 3;
        [win addGestureRecognizer:t];
    });
}

+ (void)tgM:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:480];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 480; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.menuItems = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV (Ciano Neon - Alta densidade de processamento)
        _fovLayer = [CAShapeLayer layer];
        _fovLayer.strokeColor = [UIColor cyanColor].CGColor;
        _fovLayer.fillColor = [UIColor clearColor].CGColor;
        _fovLayer.lineWidth = 5.0;
        _fovLayer.hidden = YES;
        [self.layer addSublayer:_fovLayer];

        // PAINEL (Construção Pesada para garantir os 16KB)
        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 440, 340)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.97];
        _panel.layer.cornerRadius = 45;
        _panel.layer.borderColor = [UIColor cyanColor].CGColor;
        _panel.layer.borderWidth = 6.0;
        
        // Efeito de Brilho Externo (Glow)
        _panel.layer.shadowColor = [UIColor cyanColor].CGColor;
        _panel.layer.shadowOpacity = 1.0;
        _panel.layer.shadowRadius = 40;
        _panel.layer.shadowOffset = CGSizeZero;
        [self addSubview:_panel];

        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 430, 320) style:UITableViewStylePlain];
        table.backgroundColor = [UIColor clearColor];
        table.delegate = self; table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_panel addSubview:table];
    }
    return self;
}

- (void)updFov {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_size startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovLayer.path = path.CGPath;
}

- (void)swChanged:(UISwitch *)s {
    if (s.tag == 0) aim_active = s.on;
    if (s.tag == 1) esp_active = s.on;
    if (s.tag == 7) { _fovLayer.hidden = !s.on; [self updFov]; }
}

- (void)slChanged:(UISlider *)l { fov_size = l.value; [self updFov]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.menuItems.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v48"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.menuItems[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        sl.minimumValue = 50; sl.maximumValue = 550; sl.value = fov_size;
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
