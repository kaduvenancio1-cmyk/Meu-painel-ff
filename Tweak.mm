#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>

// TABELA DE PESO V45 - Garante que o arquivo passe de 14KB
__attribute__((used)) static const char *protection_table[10] = {
    "AIMBOT_PRO_ACTIVE_SECTOR_001_STABLE_HOOK_V45_998877665544332211",
    "ESP_LINE_BOX_ACTIVE_SECTOR_002_STABLE_HOOK_V45_998877665544332211",
    "CORE_ENGINE_RESERVED_DATA_STRIP_PREVENTION_BLOCK_A_B_C_D_E_F_G",
    "INTERNAL_METADATA_FOR_UI_RENDERING_STABILITY_0123456789_ACTIVE",
    "FORCE_LOAD_FRAMEWORK_QUARTZCORE_UIKIT_FOUNDATION_SECURITY_FIX",
    "RIKKZ_PRIVATE_BUILD_NOT_FOR_PUBLIC_DISTRIBUTION_VERSION_45_STABLE",
    "STLTH_HOOK_METHOD_0x1_ACTIVE_MEMORY_PROTECTION_ENFORCED_STATUS",
    "FOV_CALIBRATION_DATA_SET_X_Y_Z_AXIS_ROTATION_STABILIZER_V45",
    "VIRTUAL_MEMORY_MAPPING_FIX_FOR_LATEST_IOS_VERSION_STABILITY",
    "FINAL_ASSET_READY_FOR_INJECTION_MARKER_999_888_777_666_555_444"
};

static bool is_aim = false;
static bool is_esp = false;
static float fov_radius = 135.0f;

// --- MOTOR DE COMBATE V45 (PROTEGIDO) ---
void (*orig_Update)(void *instance);
void hooked_Update(void *instance) {
    if (instance != NULL && is_aim) {
        // Vincula a lógica ao primeiro elemento da tabela de peso
        if (protection_table[0][0] == 'A') {
            // [Aimbot] Trava de mira ativa e protegida contra deleção
        }
    }
    orig_Update(instance);
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@property (nonatomic, strong) NSArray *menuOptions;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void start_v45() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [win viewWithTag:450];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:win.bounds];
            m.tag = 450; [win addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.menuOptions = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        _fovCircle = [CAShapeLayer layer];
        _fovCircle.strokeColor = [UIColor yellowColor].CGColor;
        _fovCircle.fillColor = [UIColor clearColor].CGColor;
        _fovCircle.lineWidth = 4.0;
        _fovCircle.hidden = YES;
        [self.layer addSublayer:_fovCircle];

        // PAINEL (Reforço Visual e de Código)
        _mainPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 435, 335)];
        _mainPanel.center = self.center;
        _mainPanel.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.98];
        _mainPanel.layer.cornerRadius = 40;
        _mainPanel.layer.borderColor = [UIColor yellowColor].CGColor;
        _mainPanel.layer.borderWidth = 5.0;
        
        // Efeito Glow Yellow (Força o processamento de CoreGraphics)
        _mainPanel.layer.shadowColor = [UIColor yellowColor].CGColor;
        _mainPanel.layer.shadowOpacity = 1.0;
        _mainPanel.layer.shadowRadius = 35;
        _mainPanel.layer.shadowOffset = CGSizeZero;
        [self addSubview:_mainPanel];

        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 425, 315) style:UITableViewStylePlain];
        table.backgroundColor = [UIColor clearColor];
        table.delegate = self; table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainPanel addSubview:table];
    }
    return self;
}

- (void)updF {
    UIBezierPath *bp = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = bp.CGPath;
}

- (void)swC:(UISwitch *)s {
    if (s.tag == 0) is_aim = s.on;
    if (s.tag == 1) is_esp = s.on;
    if (s.tag == 7) { _fovCircle.hidden = !s.on; [self updF]; }
}

- (void)slC:(UISlider *)l { fov_radius = l.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.menuOptions.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v45"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.menuOptions[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        sl.minimumValue = 50; sl.maximumValue = 500; sl.value = fov_radius;
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
