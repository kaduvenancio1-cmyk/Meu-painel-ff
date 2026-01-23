#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <mach-o/dyld.h>
#import <substrate.h>

// --- ENDEREÇOS DE MEMÓRIA (OFFSETS) FF 1.120.11 ---
// Nota: Esses endereços são para a libunity.so / libil2cpp.so
#define OFFSET_AIMBOT 0x1A2B3C4  // Exemplo para versão 1.120.11
#define OFFSET_ESP 0x2B3C4D5     // Exemplo para versão 1.120.11

uintptr_t get_lib_base() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// Variáveis Globais
bool ligaAim = false;
bool ligaESP = false;
int ondeAtirar = 0; // 0=Cabeça, 1=Peito

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *itens;
@property (nonatomic, strong) UISlider *fovSlider;
@property (nonatomic, strong) CAShapeLayer *fovCircle;
@end

@implementation RickzzMenu

// LIMPEZA DE GUEST (MUITO IMPORTANTE PARA CONTA NOVA)
static void limpar_tudo() {
    NSString *doc = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:doc error:nil];
    SecItemDelete((__bridge CFDictionaryRef)@{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword});
}

__attribute__((constructor))
static void carregar_v15() {
    limpar_tudo();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *gesto = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(abrir:)];
        gesto.numberOfTouchesRequired = 3;
        gesto.minimumPressDuration = 2.0;
        [win addGestureRecognizer:gesto];
    });
}

+ (void)abrir:(UILongPressGestureRecognizer *)s {
    if (s.state == UIGestureRecognizerStateBegan) [self toggle];
}

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:999];
    if (old) [old removeFromSuperview];
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 999;
        menu.layer.zPosition = 9999;
        [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itens = @[@"Aimbot Pro", @"ESP Line", @"Tracer", @"Caixa 2D", @"Distancia", @"Cabeça", @"Peito", @"ATIVAR FOV"];
        
        _fovCircle = [CAShapeLayer layer];
        _fovCircle.strokeColor = [UIColor cyanColor].CGColor;
        _fovCircle.fillColor = [UIColor clearColor].CGColor;
        _fovCircle.lineWidth = 1.0;
        _fovCircle.hidden = YES;
        [self.layer addSublayer:_fovCircle];

        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 450, 260)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
        _container.layer.cornerRadius = 15;
        _container.layer.borderWidth = 1.0;
        _container.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_container];

        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(10, 35, 430, 170)];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self; _tabela.dataSource = self;
        _tabela.separatorStyle = 0;
        [_container addSubview:_tabela];

        _fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 215, 350, 30)];
        _fovSlider.minimumValue = 50; _fovSlider.maximumValue = 350;
        [_fovSlider addTarget:self action:@selector(mudarFOV:) forControlEvents:64];
        _fovSlider.hidden = YES;
        [_container addSubview:_fovSlider];
    }
    return self;
}

- (void)mudarFOV:(UISlider *)s {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:s.value startAngle:0 endAngle:2*M_PI clockwise:YES];
    _fovCircle.path = p.CGPath;
}

- (void)mudouSwitch:(UISwitch *)sender {
    NSString *opt = self.itens[sender.tag];
    
    // AQUI O CÓDIGO CONECTA COM A MEMÓRIA DO JOGO
    if ([opt isEqualToString:@"Aimbot Pro"]) ligaAim = sender.on;
    if ([opt containsString:@"ESP"] || [opt isEqualToString:@"Tracer"]) ligaESP = sender.on;
    
    if ([opt isEqualToString:@"Cabeça"] && sender.on) { ondeAtirar = 0; [self desmarcar:6]; }
    if ([opt isEqualToString:@"Peito"] && sender.on) { ondeAtirar = 1; [self desmarcar:5]; }

    if ([opt isEqualToString:@"ATIVAR FOV"]) {
        _fovCircle.hidden = !sender.on;
        _fovSlider.hidden = !sender.on;
        [self mudarFOV:_fovSlider];
    }
}

- (void)desmarcar:(int)idx {
    UITableViewCell *c = [self.tabela cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    if (c) [(UISwitch *)c.accessoryView setOn:NO animated:YES];
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
