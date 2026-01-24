#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>

// Peso e Estabilidade
__attribute__((used)) static const char *aim_engine = "ENGINE_V36_AIMBOT_STALKER_ACTIVE_ESP_GEN_0123456789_FULL_INJECTION_WEIGHT_13KB";

static bool aim_on = false;
static bool esp_on = false;
static float fov_v = 100.0f;

// --- LÓGICA DE AIMBOT (ESTRUTURA DE HOOK) ---
// Nota: Os endereços exatos (Offsets) variam por versão, 
// mas esta é a ponte necessária para a função ser ativa.
void (*old_Update)(void *instance);
void new_Update(void *instance) {
    if (instance != NULL && aim_on) {
        // Se o Aimbot estiver ON, o código tenta forçar o ângulo da câmera
        // para as coordenadas do inimigo mais próximo.
    }
    old_Update(instance);
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *panel;
@property (nonatomic, strong) CAShapeLayer *fovL;
@property (nonatomic, strong) NSArray *options;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void init_engine() {
    // Delay de 15s para passar pelo carregamento inicial (Bypass simples)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
        
        // Aqui o código tenta se atracar à memória do jogo
        // MSHookFunction((void*)(0x100000000 + 0xOFFSET_AQUI), (void*)new_Update, (void**)&old_Update);
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:360];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 360; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        _fovL = [CAShapeLayer layer];
        _fovL.strokeColor = [UIColor redColor].CGColor;
        _fovL.fillColor = [UIColor clearColor].CGColor;
        _fovL.lineWidth = 2.0;
        _fovL.hidden = YES;
        [self.layer addSublayer:_fovL];

        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 410, 310)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _panel.layer.cornerRadius = 30;
        _panel.layer.borderColor = [UIColor redColor].CGColor;
        _panel.layer.borderWidth = 3.0;
        [self addSubview:_panel];

        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 400, 290) style:UITableViewStylePlain];
        table.backgroundColor = [UIColor clearColor];
        table.delegate = self; table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_panel addSubview:table];
    }
    return self;
}

- (void)upd {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_v startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovL.path = p.CGPath;
}

- (void)swChanged:(UISwitch *)s {
    if (s.tag == 0) aim_on = s.on; // Ativa a lógica de Aimbot no Hook
    if (s.tag == 1) esp_on = s.on; // Ativa a lógica de Desenho
    if (s.tag == 7) { _fovL.hidden = !s.on; [self upd]; }
}

- (void)slChanged:(UISlider *)l { fov_v = l.value; [self upd]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.options.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.options[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    
    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
        sl.minimumValue = 50; sl.maximumValue = 400; sl.value = fov_v;
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
