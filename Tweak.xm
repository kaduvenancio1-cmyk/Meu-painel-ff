#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// OFFSETS ATUALIZADOS 1.120.9
#define OFF_AIMBOT 0x43AF2C0 
#define OFF_FOV 0x3FB13F0

@interface KaduMenu : UIView
@property (nonatomic, strong) UIView *pnlPreto;
@property (nonatomic, strong) UIScrollView *rolagem;
@property (nonatomic, strong) UISlider *barraFov;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@property (nonatomic, strong) UISwitch *swFov; 
@end

@implementation KaduMenu

// LIMPEZA DE RASTROS NO COFRE DO SISTEMA
- (void)limpezaMaster {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *files = @[@"guest.dat", @"com.garena.msdk/guest.dat", @"Library/Caches/GuestAccount.dat"];
    for (NSString *f in files) {
        NSString *path = [docDir stringByAppendingPathComponent:f];
        if ([fm fileExistsAtPath:path]) [fm removeItemAtPath:path error:nil];
    }
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self limpezaMaster];
        
        self.pnlPreto = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 350)];
        self.pnlPreto.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
        self.pnlPreto.layer.cornerRadius = 15;
        self.pnlPreto.layer.borderWidth = 1.5;
        self.pnlPreto.layer.borderColor = [UIColor cyanColor].CGColor;
        self.pnlPreto.hidden = YES; 
        [self addSubview:self.pnlPreto];

        self.rolagem = [[UIScrollView alloc] initWithFrame:self.pnlPreto.bounds];
        self.rolagem.contentSize = CGSizeMake(220, 500);
        [self.pnlPreto addSubview:self.rolagem];

        [self setupUI];

        self.fovCircle = [CAShapeLayer layer];
        self.fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        self.fovCircle.fillColor = [UIColor clearColor].CGColor;
        self.fovCircle.lineWidth = 1.5;
        self.fovCircle.hidden = YES;
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:self.fovCircle];

        // COMANDO SECRETO: 3 DEDOS
        UITapGestureRecognizer *t3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesto)];
        t3.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:t3];

        UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(m:)];
        [self addGestureRecognizer:p];
        
        self.frame = CGRectMake(50, 150, 0, 0); 
    }
    return self;
}

- (void)gesto {
    self.pnlPreto.hidden = !self.pnlPreto.hidden;
    self.frame = self.pnlPreto.hidden ? CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0) : CGRectMake(self.frame.origin.x, self.frame.origin.y, 220, 350);
}

- (void)setupUI {
    CGFloat y = 15;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 220, 20)];
    title.text = @"KADU VIP - 1.120.9"; title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.rolagem addSubview:title]; y += 40;

    [self addSw:@"AIMBOT" y:&y];
    [self addSw:@"ESP" y:&y];
    
    UISwitch *sf = [[UISwitch alloc] initWithFrame:CGRectMake(160, y, 50, 30)];
    [sf addTarget:self action:@selector(tFov:) forControlEvents:UIControlEventValueChanged];
    [self.rolagem addSubview:sf];
    UILabel *lf = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 140, 30)];
    lf.text = @"MOSTRAR FOV"; lf.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:lf]; y += 45;

    self.barraFov = [[UISlider alloc] initWithFrame:CGRectMake(10, y, 200, 30)];
    self.barraFov.maximumValue = 250;
    [self.barraFov addTarget:self action:@selector(uFov) forControlEvents:UIControlEventValueChanged];
    [self.rolagem addSubview:self.barraFov]; y += 50;

    UIButton *btnB = [UIButton buttonWithType:UIButtonTypeSystem];
    btnB.frame = CGRectMake(10, y, 200, 40);
    [btnB setTitle:@"BYPASS & RESET" forState:UIControlStateNormal];
    [btnB setBackgroundColor:[UIColor colorWithRed:0.5 green:0 blue:0 alpha:1]];
    [btnB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnB addTarget:self action:@selector(limpezaMaster) forControlEvents:UIControlEventTouchUpInside];
    [self.rolagem addSubview:btnB];
}

- (void)tFov:(UISwitch *)s { self.fovCircle.hidden = !s.isOn; [self uFov]; }
- (void)uFov {
    if (!self.fovCircle.hidden) {
        UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2) radius:self.barraFov.value startAngle:0 endAngle:M_PI*2 clockwise:YES];
        self.fovCircle.path = p.CGPath;
    }
}
- (void)addSw:(NSString *)t y:(CGFloat *)y {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, *y, 140, 30)];
    l.text = t; l.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:l];
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(160, *y, 50, 30)];
    [self.rolagem addSubview:s];
    *y += 45;
}
- (void)m:(UIPanGestureRecognizer *)g { if (!self.pnlPreto.hidden) self.center = [g locationInView:self.superview]; }
@end

static void __attribute__((constructor)) init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        KaduMenu *m = [[KaduMenu alloc] initWithFrame:CGRectMake(50, 150, 220, 350)];
        [w addSubview:m];
    });
}
