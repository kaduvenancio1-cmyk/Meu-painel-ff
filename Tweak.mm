#import <UIKit/UIKit.h>
#import <Security/Security.h>

// Variáveis com nomes camuflados
static bool opt_a = false;
static bool opt_e = false;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *lista;
@end

@implementation RickzzMenu

// Limpeza de rastro de login
static void reset_sys() {
    NSString *p = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:p error:nil];
}

__attribute__((constructor))
static void engine_start() {
    reset_sys();
    // 45 SEGUNDOS DE ESPERA: Tempo de abrir o jogo, logar e começar o CS.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *g = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(m:)];
        g.numberOfTouchesRequired = 3;
        g.minimumPressDuration = 2.0;
        [w addGestureRecognizer:g];
    });
}

+ (void)m:(UILongPressGestureRecognizer *)s { if (s.state == 1) [self show]; }

+ (void)show {
    UIWindow *w = [[UIApplication sharedApplication] keyWindow];
    if ([w viewWithTag:999]) [[w viewWithTag:999] removeFromSuperview];
    else {
        RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
        m.tag = 999; [w addSubview:m];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lista = @[@"Puxada Pro", @"Linha ESP", @"Tracer", @"Box 2D", @"Metros", @"Head", @"Chest", @"ATIVAR CIRCULO"];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 260)];
        bg.center = self.center;
        bg.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.98];
        bg.layer.cornerRadius = 14;
        bg.layer.borderWidth = 1.0;
        bg.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:bg];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(5, 40, 390, 180)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self; _tabela.dataSource = self;
        _tabela.separatorStyle = 0;
        [bg addSubview:_tabela];
    }
    return self;
}

- (void)alt:(UISwitch *)s {
    if (s.tag == 0) opt_a = s.on;
    if (s.tag == 1) opt_e = s.on;
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.lista.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.lista[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *s = [[UISwitch alloc] init];
    s.tag = p.row; [s addTarget:self action:@selector(alt:) forControlEvents:64];
    c.accessoryView = s;
    return c;
}
@end
