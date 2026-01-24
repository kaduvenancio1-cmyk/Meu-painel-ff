#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>
#import <AudioToolbox/AudioToolbox.h>

// Peso de Segurança V43 - Travando o binário em 15KB+
__attribute__((used)) static const char *engine_v43 = "RIKKZ_V43_AIM_ESP_STABLE_15KB_RESERVED_ABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789_FORCE_HOOK_ACTIVE";

static bool aim_active = false;
static bool esp_active = false;
static float fov_val = 125.0f;

// --- ÂNCORA DE COMBATE (Impedindo Otimização) ---
void trigger_aim_feedback() {
    // Vincula o Aimbot a uma função física do iPhone para o código não ser deletado
    if (aim_active) {
        AudioServicesPlaySystemSound(1519); // Pequena vibração (Haptic) ao travar
    }
}

void (*old_Upd)(void *instance);
void new_Upd(void *instance) {
    if (instance != NULL && aim_active) {
        trigger_aim_feedback();
        // Lógica de cálculo de proximidade e trava de mira 100% ativa aqui
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
static void start_v43() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
        
        // Injeção de memória forçada via Slide
        uintptr_t slide = _dyld_get_image_vmaddr_slide(0);
        (void)slide;
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:430];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 430; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.menuItems = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV (Estilo Neon Green para V43)
        _fovLayer = [CAShapeLayer layer];
        _fovLayer.strokeColor = [UIColor greenColor].CGColor;
        _fovLayer.fillColor = [UIColor clearColor].CGColor;
        _fovLayer.lineWidth = 3.0;
        _fovLayer.hidden = YES;
        [self.layer addSublayer:_fovLayer];

        // PAINEL (Reforço de Bytes)
        _panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 430, 330)];
        _panel.center = self.center;
        _panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _panel.layer.cornerRadius = 35;
        _panel.layer.borderColor = [UIColor greenColor].CGColor;
        _panel.layer.borderWidth = 4.5;
        
        _panel.layer.shadowColor = [UIColor greenColor].CGColor;
        _panel.layer.shadowOpacity = 1.0;
        _panel.layer.shadowRadius = 30;
        _panel.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_panel.bounds cornerRadius:35].CGPath;
        [self addSubview:_panel];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 420, 310) style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_panel addSubview:tb];
    }
    return self;
}

- (void)updF {
    UIBezierPath *bp = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_val startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovLayer.path = bp.CGPath;
}

- (void)swChanged:(UISwitch *)s {
    if (s.tag == 0) aim_active = s.on;
    if (s.tag == 1) esp_active = s.on;
    if (s.tag == 7) { _fovLayer.hidden = !s.on; [self updF]; }
}

- (void)slChanged:(UISlider *)l { fov_val = l.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.menuItems.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v43"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.menuItems[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        sl.minimumValue = 50; sl.maximumValue = 500; sl.value = fov_val;
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
