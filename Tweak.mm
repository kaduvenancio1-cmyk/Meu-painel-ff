#import <UIKit/UIKit.h>
#import <Security/Security.h>

// Variáveis de controle com nomes falsos para camuflagem
static bool liga_puxada = false;
static bool liga_linha = false;

@interface RickzzMenu : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *fundo;
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *opcoes;
@end

@implementation RickzzMenu

// LIMPEZA AUTOMÁTICA DE REGISTROS
static void limparRastro() {
    NSString *caminho = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk/guest.dat"];
    [[NSFileManager defaultManager] removeItemAtPath:caminho error:nil];
    SecItemDelete((__bridge CFDictionaryRef)@{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword});
}

__attribute__((constructor))
static void inicializar_v23() {
    limparRastro();
    
    // DELAY DE 50 SEGUNDOS (O menu só nasce após você entrar no Contra Squad)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *janela = [[UIApplication sharedApplication] keyWindow];
        UILongPressGestureRecognizer *gesto = [[UILongPressGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(abrir:)];
        gesto.numberOfTouchesRequired = 3;
        gesto.minimumPressDuration = 2.0;
        [janela addGestureRecognizer:gesto];
    });
}

+ (void)abrir:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) [self alternar];
}

+ (void)alternar {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *antigo = [win viewWithTag:999];
    if (antigo) [antigo removeFromSuperview];
    else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:win.bounds];
        menu.tag = 999;
        [win addSubview:menu];
    }
}

// CORREÇÃO DO ERRO NS_DESIGNATED_INITIALIZER
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opcoes = @[@"Puxada Pro", @"Linha ESP", @"Tracer", @"Box 2D", @"Metros", @"Head", @"Chest", @"ATIVAR FOV"];
        
        _fundo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420, 260)];
        _fundo.center = self.center;
        _fundo.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.98];
        _fundo.layer.cornerRadius = 15;
        _fundo.layer.borderWidth = 1.0;
        _fundo.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:_fundo];

        // CORREÇÃO DA INICIALIZAÇÃO DA TABELA
        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(5, 40, 410, 180) style:UITableViewStylePlain];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self;
        _tabela.dataSource = self;
        _tabela.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_fundo addSubview:_tabela];
    }
    return self;
}

- (void)mudouSwitch:(UISwitch *)s {
    if (s.tag == 0) liga_puxada = s.on;
    if (s.tag == 1) liga_linha = s.on;
    // Outras funções ativam aqui
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s {
    return self.opcoes.count;
}

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)i {
    static NSString *cellId = @"OpcaoCell";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:cellId];
    if (!c) {
        c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.opcoes[i.row];
    c.textLabel.textColor = [UIColor whiteColor];
    
    UISwitch *sw = [[UISwitch alloc] init];
    sw.tag = i.row;
    [sw addTarget:self action:@selector(mudouSwitch:) forControlEvents:UIControlEventValueChanged];
    c.accessoryView = sw;
    
    return c;
}
@end
