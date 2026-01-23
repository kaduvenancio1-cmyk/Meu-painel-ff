#import <UIKit/UIKit.h>
#import <Security/Security.h>

// --- SISTEMA DE PROTEÇÃO AVANÇADA ---
static BOOL isMenuVisible = NO;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@end

@implementation RickzzMenu

// 1. GESTO DE SEGURANÇA: 3 DEDOS POR 2 SEGUNDOS
__attribute__((constructor))
static void init_bypass_v6() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *segurar = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(aoSegurar:)];
        segurar.numberOfTouchesRequired = 3;
        segurar.minimumPressDuration = 2.0;
        [win addGestureRecognizer:segurar];
        
        // Limpeza de Cache/Logs Automática no Início
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    });
}

+ (void)aoSegurar:(UILongPressGestureRecognizer *)gesto {
    if (gesto.state == UIGestureRecognizerStateBegan) {
        [self abrirFechar];
    }
}

+ (void)abrirFechar {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:999];
    if (old) {
        [old removeFromSuperview];
        isMenuVisible = NO;
    } else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:CGRectMake(0,0,320,480)];
        menu.center = win.center;
        menu.tag = 999;
        [win addSubview:menu];
        isMenuVisible = YES;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itens = @[@"Aimbot", @"ESP", @"Tracer", @"Skeleton", @"Distancia", @"Caixa 2D", @"Cabeça", @"Peito", @"Alerta Spect", @"Anti-Screenshot", @"Modo Streamer"];
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor cyanColor].CGColor;
        
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0,10,320,30)];
        t.text = @"RICKZZ PRO - V6";
        t.textColor = [UIColor cyanColor];
        t.textAlignment = NSTextAlignmentCenter;
        t.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:t];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 50, 300, 330)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self;
        _tabela.dataSource = self;
        _tabela.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tabela];

        // SLIDER FOV
        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 390, 280, 30)];
        _fovSlider.minimumValue = 30;
        _fovSlider.maximumValue = 150;
        [_fovSlider setTintColor:[UIColor cyanColor]];
        [self addSubview:_fovSlider];

        UILabel *fl = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, 320, 20)];
        fl.text = @"AJUSTE DE FOV";
        fl.textColor = [UIColor whiteColor];
        fl.textAlignment = NSTextAlignmentCenter;
        fl.font = [UIFont systemFontOfSize:10];
        [self addSubview:fl];
    }
    return self;
}

// CONFIGURAÇÃO DOS CHECKBOXES
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s { return self.itens.count; }

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    UITableViewCell *c = [tv dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.itens[ip.row];
    c.textLabel.textColor = [UIColor whiteColor];
    
    UISwitch *s = [[UISwitch alloc] init];
    s.tag = ip.row;
    [s addTarget:self action:@selector(mudouSwitch:) forControlEvents:64];
    c.accessoryView = s;
    return c;
}

- (void)mudouSwitch:(UISwitch *)sender {
    NSString *opt = self.itens[sender.tag];
    
    // Lógica Cabeça/Peito (Exclusivo)
    if ([opt isEqualToString:@"Cabeça"] && sender.on) {
        [self desmarcarOutro:7]; // Desliga Peito
    } else if ([opt isEqualToString:@"Peito"] && sender.on) {
        [self desmarcarOutro:6]; // Desliga Cabeça
    }
}

- (void)desmarcarOutro:(NSInteger)index {
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tabela cellForRowAtIndexPath:path];
    UISwitch *sw = (UISwitch *)cell.accessoryView;
    [sw setOn:NO animated:YES];
}

@end
