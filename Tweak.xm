#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define OFF_AIMBOT 0x42B8A10 
#define OFF_FOV 0x3F9A1B0

@interface KaduMenu : UIView
@property (nonatomic, strong) UIView *pnlPreto;
@property (nonatomic, strong) UIButton *btnMin;
@property (nonatomic, strong) UIScrollView *rolagem;
@property (nonatomic, strong) UISlider *barraFov;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@property (nonatomic, strong) UISwitch *swFov; 
@end

@implementation KaduMenu

// --- LIMPEZA PESADA DE CONTA CONVIDADA ---
- (void)resetGuestAccount {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // Lista de arquivos conhecidos que guardam o ID do Guest
    NSArray *guestFiles = @[
        [docPath stringByAppendingPathComponent:@"guest.dat"],
        [docPath stringByAppendingPathComponent:@"com.garena.msdk/guest.dat"],
        [docPath stringByAppendingPathComponent:@"Library/Application Support/com.garena.msdk/guest.dat"]
    ];

    for (NSString *file in guestFiles) {
        if ([fm fileExistsAtPath:file]) {
            [fm removeItemAtPath:file error:nil];
        }
    }
    
    // Limpa o ID de Publicidade na memória do App (simulação de reset)
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"advertisingIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self resetGuestAccount]; // Limpa assim que o menu nasce
        
        self.btnMin = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnMin.frame = CGRectMake(0, 0, 45, 45);
        [self.btnMin setTitle:@"+" forState:UIControlStateNormal];
        self.btnMin.backgroundColor = [UIColor blackColor];
        self.btnMin.layer.cornerRadius = 22.5;
        self.btnMin.layer.borderColor = [UIColor cyanColor].CGColor;
        self.btnMin.layer.borderWidth = 1.5;
        [self.btnMin addTarget:self action:@selector(minimizar) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnMin];

        self.pnlPreto = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 220, 350)];
        self.pnlPreto.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.pnlPreto.layer.cornerRadius = 10;
        self.pnlPreto.hidden = YES;
        [self addSubview:self.pnlPreto];

        self.rolagem = [[UIScrollView alloc] initWithFrame:self.pnlPreto.bounds];
        self.rolagem.contentSize = CGSizeMake(220, 600);
        [self.pnlPreto addSubview:self.rolagem];

        [self montarOpcoes];

        self.fovCircle = [CAShapeLayer layer];
        self.fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        self.fovCircle.fillColor = [UIColor clearColor].CGColor;
        self.fovCircle.lineWidth = 1.5;
        self.fovCircle.hidden = YES;
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:self.fovCircle];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(arrastar:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)montarOpcoes {
    CGFloat y = 15;
    [self addOpcao:@"AIMBOT" y:&y];
    [self addOpcao:@"ESP" y:&y];
    
    UILabel *labFov = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 140, 30)];
    labFov.text = @"ATIVAR FOV"; labFov.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:labFov];
    
    self.swFov = [[UISwitch alloc] initWithFrame:CGRectMake(160, y, 50, 30)];
    [self.swFov setOn:NO];
    [self.swFov addTarget:self action:@selector(toggleFovVisual) forControlEvents:UIControlEventValueChanged];
    [self.rolagem addSubview:self.swFov];
    y += 45;
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 150, 20)];
    l.text = @"REGULAR FOV:"; l.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:l]; y += 20;

    self.barraFov = [[UISlider alloc] initWithFrame:CGRectMake(10, y, 200, 30)];
    self.barraFov.minimumValue = 0; self.barraFov.maximumValue = 250;
    [self.barraFov addTarget:self action:@selector(updateFovCircle) forControlEvents:UIControlEventValueChanged];
    [self.rolagem addSubview:self.barraFov]; y += 45;

    [self addOpcao:@"CABEÇA" y:&y];
    [self addOpcao:@"PEITO" y:&y];
    [self addOpcao:@"PÉ" y:&y];

    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(10, y + 10, 200, 40);
    [b setTitle:@"ATIVAR BYPASS" forState:UIControlStateNormal];
    [b setBackgroundColor:[UIColor darkGrayColor]];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(executarBypass) forControlEvents:TouchUpInside];
    [self.rolagem addSubview:b];
}

- (void)toggleFovVisual {
    self.fovCircle.hidden = !self.swFov.isOn;
    if (self.swFov.isOn) { [self updateFovCircle]; }
}

- (void)updateFovCircle {
    if (self.swFov.isOn) {
        CGFloat radius = self.barraFov.value;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2) 
                                                            radius:radius 
                                                        startAngle:0 
                                                          endAngle:M_PI*2 
                                                         clockwise:YES];
        self.fovCircle.path = path.CGPath;
    }
}

- (void)minimizar {
    self.pnlPreto.hidden = !self.pnlPreto.hidden;
    [self.btnMin setTitle:self.pnlPreto.hidden ? @"+" : @"-" forState:UIControlStateNormal];
}

- (void)executarBypass {
    [self resetGuestAccount]; 
    self.hidden = YES;
    [self.fovCircle removeFromSuperlayer];
}

- (void)addOpcao:(NSString *)txt y:(CGFloat *)yPos {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, *yPos, 140, 30)];
    lab.text = txt; lab.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:lab];
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(160, *yPos, 50, 30)];
    [s setOn:NO];
    [self.rolagem addSubview:s];
    *yPos += 45;
}

- (void)arrastar:(UIPanGestureRecognizer *)g {
    self.center = [g locationInView:self.superview];
}
@end

static void __attribute__((constructor)) init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        KaduMenu *m = [[KaduMenu alloc] initWithFrame:CGRectMake(40, 80, 220, 400)];
        [w addSubview:m];
    });
}
