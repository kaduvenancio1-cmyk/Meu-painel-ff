#import <UIKit/UIKit.h>

static bool aimAtivo = false;
static int alvo = 0; // 0: Cabeça, 1: Peito
static bool visCheck = true;
static bool eTracer = false;
static bool eBox = false;
static bool eSkel = false;

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIButton *kBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        kBtn.frame = CGRectMake(30, 150, 55, 55);
        kBtn.backgroundColor = [UIColor redColor];
        kBtn.layer.cornerRadius = 27.5;
        [kBtn setTitle:@"K" forState:UIControlStateNormal];
        [kBtn addTarget:self action:@selector(showKMenu) forControlEvents:UIControlEventTouchUpInside];
        
        // Linha corrigida para evitar o erro de 'keyWindow'
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:kBtn];
    });
}

%new
- (void)showKMenu {
    UIAlertController *m = [UIAlertController alertControllerWithTitle:@"KADU VIP" message:@"Menu Free Fire" preferredStyle:UIAlertControllerStyleActionSheet];

    [m addAction:[UIAlertAction actionWithTitle:(aimAtivo ? @"AIMBOT: [ON]" : @"AIMBOT: [OFF]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){ aimAtivo = !aimAtivo; }]];
    [m addAction:[UIAlertAction actionWithTitle:(alvo == 0 ? @"ALVO: [CABEÇA]" : @"ALVO: [PEITO]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){ alvo = (alvo == 0) ? 1 : 0; }]];
    [m addAction:[UIAlertAction actionWithTitle:(visCheck ? @"SÓ VISÍVEL: [ON]" : @"SÓ VISÍVEL: [OFF]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){ visCheck = !visCheck; }]];
    [m addAction:[UIAlertAction actionWithTitle:(eTracer ? @"TRACER: [ON]" : @"TRACER: [OFF]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){ eTracer = !eTracer; }]];
    [m addAction:[UIAlertAction actionWithTitle:(eBox ? @"BOX 2D: [ON]" : @"BOX 2D: [OFF]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){ eBox = !eBox; }]];
    [m addAction:[UIAlertAction actionWithTitle:(eSkel ? @"SKELETON: [ON]" : @"SKELETON: [OFF]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){ eSkel = !eSkel; }]];
    
    [m addAction:[UIAlertAction actionWithTitle:@"FECHAR" style:UIAlertActionStyleCancel handler:nil]];
    
    // Mostra o menu na tela principal
    [[[[UIApplication sharedApplication] windows] firstObject].rootViewController presentViewController:m animated:YES completion:nil];
}
%end
