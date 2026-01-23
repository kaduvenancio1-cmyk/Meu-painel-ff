#import <UIKit/UIKit.h>
#import <Security/Security.h>

static bool p_ativa = false;
static bool e_ativa = false;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *lista;
@end

@implementation RickzzMenu

// LIMPEZA DE SEGURANÇA
static void limpar_rastro() {
    NSString *c = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:c error:nil];
}

__attribute__((constructor))
static void stealth_load() {
    limpar_rastro();
    // DELAY DE 50 SEGUNDOS - Só carrega o gesto após você entrar na partida
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *g = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(handle:)];
        g.numberOfTouchesRequired = 3;
        g.minimumPressDuration = 2.0;
        [w addGestureRecognizer:g];
    });
}

+ (void)handle:(UILongPressGestureRecognizer *)s { if (s.state == 1) [self toggle]; }

+ (void)toggle {
    UIWindow *w = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [w viewWithTag:999];
    if (old) [old removeFromSuperview];
    else {
        RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
        m.tag = 999; [w addSubview:m];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lista = @[@"Puxada Pro", @"Linha ESP", @"Tracer", @"Box 2D", @"Metros", @"Head", @"Chest", @"ATIVAR FOV"];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420, 260)];
        bg.center = self.center;
        bg.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.98];
        bg.layer.cornerRadius = 15;
        bg.layer.borderWidth = 1.0;
        bg.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:bg];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(5, 40, 410, 180)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self; _tabela.dataSource = self;
        _tabela.separatorStyle = 0;
        [bg addSubview:_tabela];
    }
    return self;
}

- (void)changed:(UISwitch *)s {
    if (s.tag == 0) p_ativa = s.on;
    if (s.tag == 1) e_ativa = s.on;
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.lista.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.lista[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *s = [[UISwitch alloc] init];
    s.tag = p.row; [s addTarget:self action:@selector(changed:) forControlEvents:64];
    c.accessoryView = s;
    return c;
}
@end
