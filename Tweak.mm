#import <UIKit/UIKit.h>
#import <Security/Security.h>

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@end

@implementation RickzzMenu

// LIMPEZA PROFUNDA DE CONTA (GUEST RESET)
static void reset_guest_account() {
    // 1. Apaga todas as chaves de segurança do jogo (Keychain)
    NSArray *secClasses = @[(__bridge id)kSecClassGenericPassword, (__bridge id)kSecClassInternetPassword, (__bridge id)kSecClassCertificate, (__bridge id)kSecClassKey, (__bridge id)kSecClassIdentity];
    for (id secClass in secClasses) {
        NSDictionary *spec = @{(__bridge id)kSecClass: secClass};
        SecItemDelete((__bridge CFDictionaryRef)spec);
    }
    
    // 2. Apaga arquivos de identificação na pasta Documents
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *files = @[@"com.garena.msdk", @"device_id.txt", @"guest_info.json"];
    for (NSString *file in files) {
        [fm removeItemAtPath:[docPath stringByAppendingPathComponent:file] error:nil];
    }
    NSLog(@"[Rickzz] Limpeza profunda realizada.");
}

__attribute__((constructor))
static void init_pro() {
    // Executa a limpeza assim que o jogo abre
    reset_guest_account();

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *segurar = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(aoSegurar:)];
        segurar.numberOfTouchesRequired = 3;
        segurar.minimumPressDuration = 2.0;
        [win addGestureRecognizer:segurar];
    });
}

+ (void)aoSegurar:(UILongPressGestureRecognizer *)gesto {
    if (gesto.state == UIGestureRecognizerStateBegan) [self toggle];
}

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:999];
    if (old) { [old removeFromSuperview]; }
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 999;
        [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itens = @[@"Aimbot", @"ESP", @"Tracer", @"Skeleton", @"Distancia", @"Caixa 2D", @"Cabeça", @"Peito", @"Alerta Spect", @"Anti-Screenshot", @"Modo Streamer", @"ATIVAR/DESATIVAR FOV"];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 280)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
        _container.layer.cornerRadius = 10;
        _container.layer.borderWidth = 1.5;
        _container.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_container];

        UILabel *titulo = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 450, 25)];
        titulo.text = @"RICKZZ PRO V7 - DEEP CLEAN";
        titulo.textColor = [UIColor cyanColor];
        titulo.textAlignment = NSTextAlignmentCenter;
        titulo.font = [UIFont boldSystemFontOfSize:16];
        [_container addSubview:titulo];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 35, 430, 180)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self;
        _tabela.dataSource = self;
        _tabela.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_container addSubview:_tabela];

        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 220, 350, 30)];
        _fovSlider.minimumValue = 30;
        _fovSlider.maximumValue = 150;
        _fovSlider.hidden = YES;
        [_container addSubview:_fovSlider];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.itens.count; }
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [tv dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.itens[ip.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *s = [[UISwitch alloc] init];
    s.tag = ip.row;
    s.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [s addTarget:self action:@selector(mudouSwitch:) forControlEvents:64];
    c.accessoryView = s;
    return c;
}

- (void)mudouSwitch:(UISwitch *)sender {
    if ([self.itens[sender.tag] isEqualToString:@"ATIVAR/DESATIVAR FOV"]) {
        _fovSlider.hidden = !sender.on;
    }
}
@end
