#import <UIKit/UIKit.h>

// 1. GERADOR DE CONTAS (RESET GUEST)
%hook UIDevice
- (NSUUID *)identifierForVendor {
    return [NSUUID UUID];
}
%end

// 2. INTERFACE DO MENU
@interface KaduMenu : UIView
@property (nonatomic, strong) UIView *pnl;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@property (nonatomic, strong) UISlider *slideFov;
@property (nonatomic, strong) UISwitch *swFov;
@property (nonatomic, assign) CGPoint lastPoint; // Para arrastar
@end

@implementation KaduMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Painel Principal
        self.pnl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 350)];
        self.pnl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.pnl.layer.cornerRadius = 12;
        self.pnl.layer.borderWidth = 1.5;
        self.pnl.layer.borderColor = [UIColor redColor].CGColor;
        self.pnl.hidden = YES;
        [self addSubview:self.pnl];

        // Gesto para ARRASTAR o painel
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMenu:)];
        [self.pnl addGestureRecognizer:pan];

        CGFloat y = 20;
        [self addLabel:@"AIMBOT CABEÇA" y:&y withSwitch:YES];
        [self addLabel:@"AIMBOT PEITO" y:&y withSwitch:YES];
        [self addLabel:@"ESP LINHA" y:&y withSwitch:YES];
        
        // Seção FOV corrigida
        [self addLabel:@"ATIVAR FOV" y:&y withSwitch:NO];
        self.swFov = [[UISwitch alloc] initWithFrame:CGRectMake(155, y-35, 50, 30)];
        [self.swFov addTarget:self action:@selector(toggleFov) forControlEvents:UIControlEventValueChanged];
        [self.pnl addSubview:self.swFov];

        self.slideFov = [[UISlider alloc] initWithFrame:CGRectMake(10, y, 200, 30)];
        self.slideFov.maximumValue = 300;
        self.slideFov.value = 100;
        [self.slideFov addTarget:self action:@selector(drawFov) forControlEvents:UIControlEventValueChanged];
        [self.pnl addSubview:self.slideFov];
        y += 50;

        // Botão Reset Manual
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(10, y, 200, 45);
        [btn setTitle:@"LIMPAR GUEST & SAIR" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 8;
        [btn addTarget:self action:@selector(cleanExit) forControlEvents:UIControlEventTouchUpInside];
        [self.pnl addSubview:btn];

        // Camada do Círculo FOV
        self.fovCircle = [CAShapeLayer layer];
        self.fovCircle.strokeColor = [UIColor whiteColor].CGColor;
        self.fovCircle.fillColor = [UIColor clearColor].CGColor;
        self.fovCircle.lineWidth = 1.2;
        self.fovCircle.hidden = YES;
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:self.fovCircle];

        // Gesto de 3 dedos para abrir/fechar
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
        tap.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
    }
    return self;
}

// Função para Arrastar o Painel
- (void)dragMenu:(UIPanGestureRecognizer *)res {
    CGPoint point = [res locationInView:self.superview];
    if (res.state == UIGestureRecognizerStateBegan) {
        self.lastPoint = point;
    } else if (res.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = CGPointMake(point.x - self.lastPoint.x, point.y - self.lastPoint.y);
        self.center = CGPointMake(self.center.x + delta.x, self.center.y + delta.y);
        self.lastPoint = point;
    }
}

- (void)addLabel:(NSString *)text y:(CGFloat *)y withSwitch:(BOOL)hasSwitch {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, *y, 140, 30)];
    l.text = text; l.textColor = [UIColor whiteColor];
    l.font = [UIFont boldSystemFontOfSize:14];
    [self.pnl addSubview:l];
    if (hasSwitch) {
        UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(155, *y, 50, 30)];
        [self.pnl addSubview:s];
    }
    *y += 45;
}

- (void)toggleFov { self.fovCircle.hidden = !self.swFov.isOn; [self drawFov]; }

- (void)drawFov {
    if (!self.fovCircle.hidden) {
        CGPoint center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        self.fovCircle.path = [UIBezierPath bezierPathWithArcCenter:center radius:self.slideFov.value startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
    }
}

- (void)showMenu { self.pnl.hidden = !self.pnl.hidden; }

- (void)cleanExit {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    [[NSFileManager defaultManager] removeItemAtPath:[doc stringByAppendingPathComponent:@"guest.dat"] error:nil];
    exit(0);
}
@end

// 3. INICIALIZAÇÃO
static void __attribute__((constructor)) init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KaduMenu *menu = [[KaduMenu alloc] initWithFrame:CGRectMake(50, 100, 220, 350)];
        [[UIApplication sharedApplication].keyWindow addSubview:menu];
    });
}
