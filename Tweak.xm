#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>

// --- GERADOR DE CONTAS INFINITAS (BYPASS DE IDFV) ---
%hook UIDevice
- (NSUUID *)identifierForVendor {
    // Retorna um ID aleatório toda vez, resetando o Guest automaticamente
    return [NSUUID UUID];
}
%end

@interface KaduMenu : UIView
@property (nonatomic, strong) UIView *pnl;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@property (nonatomic, strong) UISlider *slideFov;
@property (nonatomic, strong) UISwitch *swFov;
@end

@implementation KaduMenu
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Painel Principal
        self.pnl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 350)];
        self.pnl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.pnl.layer.borderColor = [UIColor whiteColor].CGColor;
        self.pnl.layer.borderWidth = 1.0;
        self.pnl.hidden = YES;
        [self addSubview:self.pnl];

        // Layout (Cabeça, Peito, ESP, FOV)
        CGFloat y = 20;
        [self addL:@"AIMBOT" y:&y];
        [self addL:@"ESP" y:&y];
        
        self.swFov = [[UISwitch alloc] initWithFrame:CGRectMake(160, y, 50, 30)];
        [self.swFov addTarget:self action:@selector(toggleFov) forControlEvents:UIControlEventValueChanged];
        [self.pnl addSubview:self.swFov];
        y += 40;

        self.slideFov = [[UISlider alloc] initWithFrame:CGRectMake(10, y, 200, 30)];
        self.slideFov.maximumValue = 250;
        [self.slideFov addTarget:self action:@selector(drawFov) forControlEvents:UIControlEventValueChanged];
        [self.pnl addSubview:self.slideFov];
        y += 50;

        [self addL:@"CABEÇA" y:&y];
        [self addL:@"PEITO" y:&y];

        // Botão de Limpeza e Fechamento
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(10, y, 200, 40);
        [btn setTitle:@"BYPASS & RESET GUEST" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor darkGrayColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cleanAndExit) forControlEvents:UIControlEventTouchUpInside];
        [self.pnl addSubview:btn];

        // Círculo do FOV
        self.fovCircle = [CAShapeLayer layer];
        self.fovCircle.strokeColor = [UIColor whiteColor].CGColor;
        self.fovCircle.fillColor = [UIColor clearColor].CGColor;
        self.fovCircle.lineWidth = 1.0;
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:self.fovCircle];

        // Gesto 3 dedos
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show)];
        t.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:t];
    }
    return self;
}

- (void)addL:(NSString *)t y:(CGFloat *)y {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, *y, 140, 30)];
    l.text = t; l.textColor = [UIColor whiteColor];
    [self.pnl addSubview:l];
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(160, *y, 50, 30)];
    [self.pnl addSubview:s];
    *y += 45;
}

- (void)toggleFov { self.fovCircle.hidden = !self.swFov.isOn; [self drawFov]; }
- (void)drawFov {
    if (!self.fovCircle.hidden) {
        CGPoint c = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        self.fovCircle.path = [UIBezierPath bezierPathWithArcCenter:c radius:self.slideFov.value startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
    }
}

- (void)cleanAndExit {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:@"guest.dat"] error:nil];
    exit(0);
}

- (void)show { self.pnl.hidden = !self.pnl.hidden; }
@end

static void __attribute__((constructor)) init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KaduMenu *m = [[KaduMenu alloc] initWithFrame:CGRectMake(50, 100, 220, 350)];
        [[UIApplication sharedApplication].keyWindow addSubview:m];
    });
}
