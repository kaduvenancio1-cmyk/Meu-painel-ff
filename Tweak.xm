#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

// OFFSETS TRAVADOS NA VERSÃO 1.120.8
#define OFF_AIMBOT 0x439A180 
#define OFF_FOV 0x3F9A1B0

@interface SystemMenu : UIView
@property (nonatomic, strong) UIView *pnlPrincipal;
@property (nonatomic, strong) UIButton *btnAbrir;
@end

@implementation SystemMenu

// LIMPEZA AUTOMÁTICA DE IDENTIFICADORES
- (void)limparRastros {
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *files = @[@"guest.dat", @"com.garena.msdk/guest.dat", @"Library/Caches/GuestAccount.dat"];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *f in files) {
        NSString *fullPath = [docs stringByAppendingPathComponent:f];
        if ([fm fileExistsAtPath:fullPath]) { [fm removeItemAtPath:fullPath error:nil]; }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self limparRastros];

        // ÍCONE DISCRETO
        self.btnAbrir = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnAbrir.frame = CGRectMake(0, 0, 40, 40);
        [self.btnAbrir setTitle:@"S" forState:UIControlStateNormal]; // 'S' de System
        self.btnAbrir.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.btnAbrir.layer.cornerRadius = 20;
        [self.btnAbrir addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnAbrir];

        // PAINEL DE CONTROLE
        self.pnlPrincipal = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 170, 180)];
        self.pnlPrincipal.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.9];
        self.pnlPrincipal.layer.cornerRadius = 12;
        self.pnlPrincipal.hidden = YES;
        [self addSubview:self.pnlPrincipal];

        [self adicionarConteudo];
    }
    return self;
}

- (void)adicionarConteudo {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 170, 20)];
    title.text = @"SYSTEM DATA v8";
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:12];
    [self.pnlPrincipal addSubview:title];

    UIButton *btnAtivar = [UIButton buttonWithType:UIButtonTypeSystem];
    btnAtivar.frame = CGRectMake(10, 50, 150, 40);
    [btnAtivar setTitle:@"INJETAR SEGURANÇA" forState:UIControlStateNormal];
    [btnAtivar setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
    [btnAtivar setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.pnlPrincipal addSubview:btnAtivar];

    UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeSystem];
    btnReset.frame = CGRectMake(10, 120, 150, 40);
    [btnReset setTitle:@"LIMPAR GUEST" forState:UIControlStateNormal];
    [btnReset setBackgroundColor:[UIColor colorWithRed:0.4 green:0.1 blue:0.1 alpha:1.0]];
    [btnReset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReset addTarget:self action:@selector(limparRastros) forControlEvents:UIControlEventTouchUpInside];
    [self.pnlPrincipal addSubview:btnReset];
}

- (void)toggle { self.pnlPrincipal.hidden = !self.pnlPrincipal.hidden; }

@end

static void __attribute__((constructor)) init() {
    // ATRASO DE 15 SEGUNDOS PARA SEGURANÇA
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        SystemMenu *menu = [[SystemMenu alloc] initWithFrame:CGRectMake(40, 100, 170, 250)];
        [window addSubview:menu];
    });
}
