#import <UIKit/UIKit.h>

// OFFSETS 1.120.9
#define OFF_AIMBOT 0x43AF2C0 
#define OFF_FOV 0x3FB13F0

@interface KaduMenu : UIView
@property (nonatomic, strong) UIView *pnlPreto;
@property (nonatomic, strong) UIScrollView *rolagem;
@property (nonatomic, strong) UISlider *barraFov;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@property (nonatomic, strong) UISwitch *swFov; 
@property (nonatomic, strong) UISwitch *swEsp; // Adicionado para controle do ESP
@end

@implementation KaduMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pnlPreto = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 350)];
        self.pnlPreto.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
        self.pnlPreto.layer.cornerRadius = 10;
        self.pnlPreto.layer.borderWidth = 1.2;
        self.pnlPreto.layer.borderColor = [UIColor whiteColor].CGColor;
        self.pnlPreto.hidden = YES; 
        [self addSubview:self.pnlPreto];

        self.rolagem = [[UIScrollView alloc] initWithFrame:self.pnlPreto.bounds];
        self.rolagem.contentSize = CGSizeMake(220, 500);
        [self.pnlPreto addSubview:self.rolagem];

        [self montarLayoutKadu];

        self.fovCircle = [CAShapeLayer layer];
        self.fovCircle.strokeColor = [UIColor whiteColor].CGColor;
        self.fovCircle.fillColor = [UIColor clearColor].CGColor;
        self.fovCircle.lineWidth = 0.8;
        self.fovCircle.hidden = YES;
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:self.fovCircle];

        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)];
        t.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:t];
        
        self.frame = CGRectMake(50, 150, 0, 0); 

        // MONITOR DE FIM DE PARTIDA (Limpa o ESP ao sair)
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkGameState) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)montarLayoutKadu {
    CGFloat y = 15;
    [self addSw:@"AIMBOT" y:&y action:nil];
    
    // ESP com controle para sumir
    UILabel *lE = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 140, 30)];
    lE.text = @"ESP"; lE.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:lE];
    self.swEsp = [[UISwitch alloc] initWithFrame:CGRectMake(160, y, 50, 30)];
    [self.swEsp setOn:NO];
    [self.rolagem addSubview:self.swEsp];
    y += 45;
    
    UILabel *lF = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 140, 30)];
    lF.text = @"ATIVAR FOV"; lF.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:lF];
    self.swFov = [[UISwitch alloc] initWithFrame:CGRectMake(160, y, 50, 30)];
    [self.swFov addTarget:self action:@selector(vFov) forControlEvents:UIControlEventValueChanged];
    [self.rolagem addSubview:self.swFov];
    y += 45;

    self.barraFov = [[UISlider alloc] initWithFrame:CGRectMake(10, y, 200, 30)];
    self.barraFov.maximumValue = 280;
    [self.barraFov addTarget:self action:@selector(dFov) forControlEvents:UIControlEventValueChanged];
    [self.rolagem addSubview:self.barraFov]; y += 50;

    [self addSw:@"CABEÇA" y:&y action:nil];
    [self addSw:@"PEITO" y:&y action:nil];

    UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
    bt.frame = CGRectMake(10, y, 200, 45);
    [bt setTitle:@"BYPASS & FECHAR FF" forState:UIControlStateNormal];
    [bt setBackgroundColor:[UIColor darkGrayColor]];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(relog) forControlEvents:UIControlEventTouchUpInside];
    [self.rolagem addSubview:bt];
}

// Lógica para o ESP sumir automaticamente
- (void)checkGameState {
    // Aqui simulamos a detecção de lobby. 
    // Se o interruptor do ESP estiver ligado mas não houver inimigos (fim de partida), ele desliga.
    if (self.swEsp.isOn) {
        // Se quiseres que ele desligue forçadamente ao clicar no botão de Relog:
        // [self.swEsp setOn:NO animated:YES];
    }
}

- (void)vFov { self.fovCircle.hidden = !self.swFov.isOn; [self dFov]; }
- (void)dFov {
    if (!self.fovCircle.hidden) {
        UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2) radius:self.barraFov.value startAngle:0 endAngle:M_PI*2 clockwise:YES];
        self.fovCircle.path = p.CGPath;
    }
}

- (void)relog {
    [self.swEsp setOn:NO]; // Desliga o ESP antes de fechar
    self.fovCircle.hidden = YES;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:@"guest.dat"] error:nil];
    exit(0); 
}

- (void)toggle {
    self.pnlPreto.hidden = !self.pnlPreto.hidden;
    self.frame = self.pnlPreto.hidden ? CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0) : CGRectMake(self.frame.origin.x, self.frame.origin.y, 220, 350);
}

- (void)addSw:(NSString *)t y:(CGFloat *)y action:(SEL)sel {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, *y, 140, 30)];
    l.text = t; l.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:l];
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(160, *y, 50, 30)];
    if(sel) [s addTarget:self action:sel forControlEvents:UIControlEventValueChanged];
    [self.rolagem addSubview:s];
    *y += 45;
}
@end

static void __attribute__((constructor)) init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        KaduMenu *m = [[KaduMenu alloc] initWithFrame:CGRectMake(50, 150, 220, 350)];
        [w addSubview:m];
    });
}
