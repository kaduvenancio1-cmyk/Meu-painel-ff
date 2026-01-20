#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// --- OFFSETS ATUALIZADOS PARA 1.120.9 (VERSÃO ATUAL) ---
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

- (void)limparGuest {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *files = @[@"guest.dat", @"com.garena.msdk/guest.dat", @"Library/Caches/GuestAccount.dat"];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *f in files) {
        NSString *path = [docPath stringByAppendingPathComponent:f];
        if ([fm fileExistsAtPath:path]) { [fm removeItemAtPath:path error:nil]; }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self limparGuest];
        
        self.pnlPreto = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 350)];
        self.pnlPreto.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.pnlPreto.layer.cornerRadius = 10;
        self.pnlPreto.layer.borderWidth = 1.5;
        self.pnlPreto.layer.borderColor = [UIColor cyanColor].CGColor;
        self.pnlPreto.hidden = YES; 
        [self addSubview:self.pnlPreto];

        self.rolagem = [[UIScrollView alloc] initWithFrame:self.pnlPreto.bounds];
        self.rolagem.contentSize = CGSizeMake(220, 550);
        [self.pnlPreto addSubview:self.rolagem];

        [self montarLayout];

        self.fovCircle = [CAShapeLayer layer];
        self.fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        self.fovCircle.fillColor = [UIColor clearColor].CGColor;
        self.fovCircle.lineWidth = 1.5;
        self.fovCircle.hidden = YES;
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:self.fovCircle];

        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestoMenu)];
        tap3.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap3];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(arrastar:)];
        [self addGestureRecognizer:pan];
        
        self.frame = CGRectMake(50, 150, 0, 0); // Começa sem travar o touch
    }
    return self;
}

- (void)gestoMenu {
    self.pnlPreto.hidden = !self.pnlPreto.hidden;
    if (self.pnlPreto.hidden) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 220, 350);
    }
}

- (void)montarLayout {
    CGFloat y = 15;
    [self addChave:@"AIMBOT" y:&y];
    [self addChave:@"ESP" y:&y];
    
    UILabel *lFov = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 140, 30)];
    lFov.text = @"ATIVAR FOV"; lFov.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:lFov];
    
    self.swFov = [[UISwitch alloc] initWithFrame:CGRectMake(160, y, 50, 30)];
    [self.swFov addTarget:self action:@selector(toggleFov) forControlEvents:UIControlEventValueChanged];
    [self.rolagem addSubview:self.swFov];
    y += 45;
    
    self.barraFov = [[UISlider alloc] initWithFrame:CGRectMake(10, y, 200, 30)];
    self.barraFov.minimumValue = 0; self.barraFov.maximumValue = 250;
    [self.barraFov addTarget:self action:@selector(updateFov) forControlEvents:UIControlEventValueChanged];
    [self.rolagem addSubview:self.barraFov]; y += 40;

    [self addChave:@"CABEÇA" y:&y];
    [self addChave:@"PEITO" y:&y];

    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(10, y + 20, 200, 40);
    [b setTitle:@"BYPASS & RESET" forState:UIControlStateNormal];
    [b setBackgroundColor:[UIColor darkGrayColor]];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(executarBypass) forControlEvents:UIControlEventTouchUpInside];
    [self.rolagem addSubview:b];
}

- (void)toggleFov { self.fovCircle.hidden = !self.swFov.isOn; [self updateFov]; }
- (void)updateFov {
    if (self.swFov.isOn) {
        CGFloat r = self.barraFov.value;
        UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2) radius:r startAngle:0 endAngle:M_PI*2 clockwise:YES];
        self.fovCircle.path = p.CGPath;
    }
}

- (void)executarBypass { [self limparGuest]; [self gestoMenu]; }
- (void)addChave:(NSString *)txt y:(CGFloat *)yPos {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, *yPos, 140, 30)];
    lab.text = txt; lab.textColor = [UIColor whiteColor];
    [self.rolagem addSubview:lab];
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(160, *yPos, 50, 30)];
    [self.rolagem addSubview:s];
    *yPos += 45;
}
- (void)arrastar:(UIPanGestureRecognizer *)g { 
    if (!self.pnlPreto.hidden) {
        self.center = [g locationInView:self.superview]; 
    }
}
@end

static void __attribute__((constructor)) init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        KaduMenu *m = [[KaduMenu alloc] initWithFrame:CGRectMake(50, 150, 220, 350)];
        [w addSubview:m];
    });
}
