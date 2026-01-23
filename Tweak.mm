#import <UIKit/UIKit.h>
#import <Security/Security.h>

static bool a_on = false;
static bool e_on = false;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *t;
@property (nonatomic, strong) NSArray *i;
@end

@implementation RickzzMenu

// LIMPEZA SILENCIOSA
static void silent_clean() {
    NSString *p = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:p error:nil];
}

__attribute__((constructor))
static void v22_init() {
    silent_clean();
    // Aumentamos para 40 segundos. 
    // Isso garante que você clique em "Começar" e entre na partida ANTES do hack carregar.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *h = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(op:)];
        h.numberOfTouchesRequired = 3;
        h.minimumPressDuration = 2.0;
        [w addGestureRecognizer:h];
    });
}

+ (void)op:(UILongPressGestureRecognizer *)g { if (g.state == 1) [self tg]; }

+ (void)tg {
    UIWindow *w = [[UIApplication sharedApplication] keyWindow];
    UIView *o = [w viewWithTag:999];
    if (o) [o removeFromSuperview];
    else {
        RickzzMenu *m = [[RickzzMenu alloc] initWithFrame:w.bounds];
        m.tag = 999; [w addSubview:m];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.i = @[@"Aimbot Pro", @"ESP Line", @"Tracer", @"Caixa 2D", @"Distancia", @"Cabeça", @"Peito", @"ATIVAR FOV"];
        UIView *b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 250)];
        b.center = self.center;
        b.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.98];
        b.layer.cornerRadius = 12;
        b.layer.borderColor = [UIColor cyanColor].CGColor;
        b.layer.borderWidth = 1.0;
        [self addSubview:b];

        _t = [[UITableView alloc] initWithFrame:CGRectMake(5, 40, 390, 180)];
        _t.backgroundColor = [UIColor clearColor];
        _t.delegate = self; _t.dataSource = self;
        _t.separatorStyle = 0;
        [b addSubview:_t];
    }
    return self;
}

- (void)sw:(UISwitch *)s {
    if (s.tag == 0) a_on = s.on;
    if (s.tag == 1) e_on = s.on;
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.i.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.i[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *s = [[UISwitch alloc] init];
    s.tag = p.row; [s addTarget:self action:@selector(sw:) forControlEvents:64];
    c.accessoryView = s;
    return c;
}
@end
