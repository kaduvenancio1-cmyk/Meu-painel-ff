#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <mach-o/dyld.h> // ADICIONADO PARA CORRIGIR O ERRO DO PRINT
#import <substrate.h>

// --- BUSCA DA BASE DO JOGO ---
uintptr_t get_base_address() {
    return (uintptr_t)_dyld_get_image_header(0);
}

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@end

@implementation RickzzMenu

// LIMPEZA DE CONTA AO INICIAR (GUEST RESET)
static void deep_clean() {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)query);
}

__attribute__((constructor))
static void init_v12() {
    deep_clean();

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(handleHold:)];
        hold.numberOfTouchesRequired = 3;
        hold.minimumPressDuration = 2.0;
        [win addGestureRecognizer:hold];
    });
}

+ (void)handleHold:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) [self toggle];
}

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:999];
    if (old) { [old removeFromSuperview]; }
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 999;
        menu.layer.zPosition = 9999;
        [win addSubview:menu];
    }
}

- (instancetype)initWithRect:(CGRect)frame { // Simplificado para build estável
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.itens = @[@"Aimbot Pro", @"ESP Line", @"Tracer", @"Skeleton", @"Distancia", @"Caixa 2D", @"Cabeça", @"Peito", @"Alerta Spect", @"Anti-Screenshot", @"Modo Streamer", @"ATIVAR FOV"];
        
        _fovCircle = [CAShapeLayer layer];
        _fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        _fovCircle.fillColor = [UIColor clearColor].CGColor;
        _fovCircle.lineWidth = 1.5;
        _fovCircle.zPosition = 10000;
        _fovCircle.hidden = YES;
        [self.layer addSublayer:_fovCircle];

        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 280)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
        _container.layer.cornerRadius = 10;
        _container.layer.borderWidth = 1.5;
        _container.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_container];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 430, 180)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self;
        _tabela.dataSource = self;
        _tabela.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_container addSubview:_tabela];

        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 230, 350, 30)];
        _fovSlider.minimumValue = 50; _fovSlider.maximumValue = 400;
        [_fovSlider addTarget:self action:@selector(fovUpdate:) forControlEvents:64];
        _fovSlider.hidden = YES;
        [_container addSubview:_fovSlider];
    }
    return self;
}

// Lógica de FOV e Tabela mantida igual para estabilidade
- (void)fovUpdate:(UISlider *)s {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:s.value startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = p.CGPath;
}

- (void)mudouSwitch:(UISwitch *)sender {
    if ([self.itens[sender.tag] isEqualToString:@"ATIVAR FOV"]) {
        _fovCircle.hidden = !sender.on; _fovSlider.hidden = !sender.on;
        [self fovUpdate:_fovSlider];
    }
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.itens.count; }
- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:@"c"] ?: [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"c"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.itens[i.row];
    c.textLabel.textColor = [UIColor whiteColor];
    UISwitch *s = [[UISwitch alloc] init];
    s.tag = i.row; [s addTarget:self action:@selector(mudouSwitch:) forControlEvents:64];
    c.accessoryView = s;
    return c;
}
@end
