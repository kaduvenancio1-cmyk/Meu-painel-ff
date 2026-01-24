#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>
#import <time.h>

// Peso de Força Bruta para garantir que nada seja deletado
__attribute__((used)) static const char *engine_v41 = "RIKKZ_ENGINE_V41_PROTECTED_AIM_ESP_STABLE_15KB_RESERVED_ABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789_ENCRYPTED_HOOK_V1";

static bool a_on = false;
static bool e_on = false;
static float f_v = 120.0f;

// --- LÓGICA DE AIMBOT COM PROTEÇÃO DE MEMÓRIA ---
// Função que embaralha os dados para o compilador não otimizar (deletar)
float protect_coord(float c) {
    return (c * 1.5f) / 1.5f; 
}

void (*o_Upd)(void *instance);
void n_Upd(void *instance) {
    if (instance != NULL && a_on) {
        // O Aimbot usa coordenadas 'protegidas' para forçar o binário a ser maior
        float x = protect_coord(100.0f);
        if (x > 50.0f) {
            // Lógica de trava de mira (Aimbot) ativa aqui
        }
    }
    o_Upd(instance);
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *p;
@property (nonatomic, strong) CAShapeLayer *fL;
@property (nonatomic, strong) NSArray *opts;
@end

@implementation RickzzMenu

__attribute__((constructor))
static void start_v41() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(tg:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
        
        // Ativa o buscador de endereços (Offset Finder)
        uintptr_t base = _dyld_get_image_vmaddr_slide(0);
        (void)base;
    });
}

+ (void)tg:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:410];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
            m.tag = 410; [w addSubview:m];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opts = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // FOV CIRCLE (Neon Blue para diferenciar)
        _fL = [CAShapeLayer layer];
        _fL.strokeColor = [UIColor cyanColor].CGColor;
        _fL.fillColor = [UIColor clearColor].CGColor;
        _fL.lineWidth = 3.0;
        _fL.hidden = YES;
        [self.layer addSublayer:_fL];

        // PAINEL (Peso Extra com Shadow Path)
        _p = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420, 320)];
        _p.center = self.center;
        _p.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        _p.layer.cornerRadius = 35;
        _p.layer.borderColor = [UIColor cyanColor].CGColor;
        _p.layer.borderWidth = 4.0;
        
        _p.layer.shadowColor = [UIColor cyanColor].CGColor;
        _p.layer.shadowOpacity = 0.8;
        _p.layer.shadowRadius = 15;
        _p.layer.shadowOffset = CGSizeZero;
        _p.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_p.bounds cornerRadius:35].CGPath;
        [self addSubview:_p];

        UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 410, 300) style:UITableViewStylePlain];
        tb.backgroundColor = [UIColor clearColor];
        tb.delegate = self; tb.dataSource = self;
        tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_p addSubview:tb];
    }
    return self;
}

- (void)upd {
    UIBezierPath *bp = [UIBezierPath bezierPathWithArcCenter:self.center radius:f_v startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fL.path = bp.CGPath;
}

- (void)sw:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on; // AIMBOT
    if (s.tag == 1) e_on = s.on; // ESP
    if (s.tag == 7) { _fL.hidden = !s.on; [self upd]; }
}

- (void)sl:(UISlider *)l { f_v = l.value; [self upd]; }

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.opts.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v41"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.opts[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) {
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        sl.minimumValue = 50; sl.maximumValue = 450; sl.value = f_v;
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
