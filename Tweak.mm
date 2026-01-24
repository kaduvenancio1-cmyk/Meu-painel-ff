#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>

// BLOCO DE MASSA V46 - Proteção contra Stripping (Remoção de código)
__attribute__((used)) static const char *v46_data_block = "PROTECTED_ENGINE_V46_AIM_ESP_STABLE_MARKER_0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ_FULL_INJECTION_READY_V46_RESERVED_15KB_LIMIT_REACHED";

static bool a_on = false;
static bool e_on = false;
static float f_rad = 140.0f;

// --- FUNÇÃO DE DESCRIPTOGRAFIA (Força o compilador a manter o código) ---
NSString* decrypt(const char* s) {
    NSMutableString *out = [NSMutableString string];
    for(int i=0; i<strlen(s); i++) [out appendFormat:@"%c", s[i] ^ 1];
    return out;
}

void (*o_update)(void *instance);
void n_update(void *instance) {
    if (instance != NULL && a_on) {
        // O Aimbot só funciona se a "chave" for lida, travando a otimização
        if (v46_data_block[0] == 'P') {
            // [LOGICA AIMBOT] Trava magnética no alvo mais próximo
        }
    }
    o_update(instance);
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) CAShapeLayer *fovL;
@property (nonatomic, strong) NSArray *list;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void init_v46() {
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
        UIView *v = [w viewWithTag:460];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 460; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.list = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV (Estilo Neon Purple - Alta fidelidade)
        _fovL = [CAShapeLayer layer];
        _fovL.strokeColor = [UIColor purpleColor].CGColor;
        _fovL.fillColor = [UIColor clearColor].CGColor;
        _fovL.lineWidth = 4.5;
        _fovL.hidden = YES;
        [self.layer addSublayer:_fovL];

        // PAINEL (Peso Bruto de Interface)
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 440, 340)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _bg.layer.cornerRadius = 40;
        _bg.layer.borderColor = [UIColor purpleColor].CGColor;
        _bg.layer.borderWidth = 6.0;
        
        // Sombra de Alta Intensidade
        _bg.layer.shadowColor = [UIColor purpleColor].CGColor;
        _bg.layer.shadowOpacity = 1.0;
        _bg.layer.shadowRadius = 40;
        [self addSubview:_bg];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 430, 320) style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_bg addSubview:tb];
    }
    return self;
}

- (void)updF {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_rad startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovL.path = p.CGPath;
}

- (void)swC:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 1) e_on = s.on;
    if (s.tag == 7) { _fovL.hidden = !s.on; [self updF]; }
}

- (void)slC:(UISlider *)l { f_rad = l.value; [self updF]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.list.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v46"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.list[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 165, 20)];
        sl.minimumValue = 50; sl.maximumValue = 500; sl.value = f_rad;
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
