#import <UIKit/UIKit.h>

// --- VARIÁVEIS DE CONTROLE ---
static bool aimbotAtivo = false;
static int alvoAimbot = 0; // 0 = Cabeça, 1 = Peito
static bool checkVisivel = true;
static bool espTracer = false;
static bool espBox = false;
static bool espSkeleton = false;

// --- BOTÃO FLUTUANTE ---
%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, 150, 50, 50);
        btn.backgroundColor = [UIColor redColor];
        btn.layer.cornerRadius = 25;
        [btn setTitle:@"K" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(abrirMenuKadu) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:btn];
    });
}

%new
- (void)abrirMenuKadu {
    UIAlertController *menu = [UIAlertController alertControllerWithTitle:@"KADU VIP FF" 
                                message:@"Configurações de Aimbot e ESP" 
                                preferredStyle:UIAlertControllerStyleActionSheet];

    // --- BOTÕES DE AIMBOT ---
    [menu addAction:[UIAlertAction actionWithTitle:(aimbotAtivo ? @"Aimbot: [LIGADO]" : @"Aimbot: [DESLIGADO]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        aimbotAtivo = !aimbotAtivo;
    }]];

    [menu addAction:[UIAlertAction actionWithTitle:(alvoAimbot == 0 ? @"Alvo: [CABEÇA]" : @"Alvo: [PEITO]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        alvoAimbot = (alvoAimbot == 0) ? 1 : 0;
    }]];

    // --- BOTÕES DE ESP ---
    [menu addAction:[UIAlertAction actionWithTitle:(espTracer ? @"ESP Tracer: ON" : @"ESP Tracer: OFF") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        espTracer = !espTracer;
    }]];

    [menu addAction:[UIAlertAction actionWithTitle:(espBox ? @"ESP Box 2D: ON" : @"ESP Box 2D: OFF") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        espBox = !espBox;
    }]];

    [menu addAction:[UIAlertAction actionWithTitle:(espSkeleton ? @"ESP Skeleton: ON" : @"ESP Skeleton: OFF") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        espSkeleton = !espSkeleton;
    }]];

    [menu addAction:[UIAlertAction actionWithTitle:@"FECHAR" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:menu animated:YES completion:nil];
}
%end

// --- LÓGICA DE VISIBILIDADE E GRUDE (SIMULADA) ---
// Aqui entrariam os Offsets para o Aimbot só grudar se "IsVisible" for true.
