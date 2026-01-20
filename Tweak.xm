#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// --- CONFIGURAÇÕES DE OFFSETS (VERSÃO 1.120.8) ---
// Nota: Estes valores precisam ser atualizados conforme a versão do jogo
#define OFF_AIMBOT 0x42B8A10 
#define OFF_FOV 0x3F9A1B0

@interface KaduMenu : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *btnToggle;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UISlider *fovSlider;
@end

@implementation KaduMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 1. Botão de Minimizar/Maximizar (+/-)
        self.btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnToggle.frame = CGRectMake(0, 0, 40, 40);
        [self.btnToggle setTitle:@"+" forState:UIControlStateNormal];
        self.btnToggle.backgroundColor = [UIColor blackColor];
        self.btnToggle.layer.cornerRadius = 20;
        self.btnToggle.layer.borderWidth = 1;
        self.btnToggle.layer.borderColor = [UIColor redColor].CGColor;
        [self.btnToggle addTarget:self action:@selector(actionToggle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnToggle];

        // 2. Painel Principal (Retângulo Preto)
        self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 220, 320)];
        self.container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
        self.container.layer.cornerRadius = 8;
        self.container.hidden = YES; // Começa fechado
        [self addSubview:self.container];

        // 3. ScrollView interna
        self.scroll = [[UIScrollView alloc] initWithFrame:self.container.bounds];
        self.scroll.contentSize = CGSizeMake(220, 550);
        [self.container addSubview:self.scroll];

        [self carregarOpcoes];
        
        // Fazer o menu ser arrastável pela tela
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)carregarOpcoes {
    CGFloat y = 15;

    // ORDEM DAS OPÇÕES
    [self criarSwitch:@"AIMBOT" naPos:&y];
    [self criarSwitch:@"ESP INIMIGO" naPos:&y];
    [self criarSwitch:@"ATIVAR FOV" naPos:&y];
    
    // Slider do FOV
    UILabel *lblFov = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 180, 20)];
    lblFov.text = @"TAMANHO DO FOV:"; lblFov.textColor = [UIColor whiteColor];
    lblFov.font = [UIFont systemFontOfSize:12];
    [self.scroll addSubview:lblFov]; y += 25;

    self.fovSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, y, 190, 30)];
    self.fovSlider.minimumValue = 0; self.fovSlider.maximumValue = 180;
    [self.scroll addSubview:self.fovSlider]; y += 40;

    // Seleção de Alvo
    [self criarSwitch:@"CABEÇA" naPos:&y];
    [self criarSwitch:@"PEITO" naPos:&y];
    [self criarSwitch:@"PÉ" naPos:&y];

    // BOTÃO BYPASS (ÚLTIMO)
    UIButton *btnBypass = [UIButton buttonWithType:UIButtonTypeSystem];
    btnBypass.frame = CGRectMake(10, y + 10, 200, 40);
    [btnBypass setTitle:@"ATIVAR BYPASS & SAIR" forState:UIControlStateNormal];
    [btnBypass setBackgroundColor:[UIColor darkGrayColor]];
    [btnBypass setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [btnBypass addTarget:self action:@selector(ativarBypassTotal) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:btnBypass];
}

- (void)actionToggle {
    self.container.hidden = !self.container.hidden;
    [self.btnToggle setTitle:self.container.hidden ? @"+" : @"-" forState:UIControlStateNormal];
}

- (void)ativarBypassTotal {
    // 1. Desativa logicamente as funções (Simulação)
    // 2. Esconde o painel permanentemente
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview]; // Remove o menu até reiniciar o jogo
    }];
}

// Helper para criar botões rápido
- (void)criarSwitch:(NSString *)nome naPos:(CGFloat *)y {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, *y, 140, 30)];
    lab.text = nome; lab.textColor = [UIColor whiteColor];
    [self.scroll addSubview:lab];
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(160, *y, 50, 30)];
    [self.scroll addSubview:s];
    *y += 45;
}

- (void)handlePan:(UIPanGestureRecognizer *)p {
    CGPoint loc = [p locationInView:self.superview];
    self.center = loc;
}
@end

// --- INICIALIZADOR (O QUE SEGURA O MENU NA GARENA) ---
static void __attribute__((constructor)) inicializar() {
    // Espera 7 segundos para garantir que a tela da Garena passou e o jogo carregou
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        KaduMenu *menu = [[KaduMenu alloc] initWithFrame:CGRectMake(50, 100, 220, 370)];
        [win addSubview:menu];
    });
}
