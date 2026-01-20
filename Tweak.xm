#import <UIKit/UIKit.h>

static bool aim = false;
static bool bypassAtivo = false;
static bool antibanAtivo = false;

%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50, 150, 55, 55);
        btn.backgroundColor = [UIColor redColor];
        btn.layer.cornerRadius = 27.5;
        [btn setTitle:@"K" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(abrirKaduMenu) forControlEvents:UIControlEventTouchUpInside];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (!window && [[UIApplication sharedApplication] windows].count > 0) {
            window = [[UIApplication sharedApplication] windows][0];
        }
        [window addSubview:btn];
    });
}

%new
- (void)abrirKaduMenu {
    UIAlertController *m = [UIAlertController alertControllerWithTitle:@"KADU VIP FF" message:@"Proteção & Funções" preferredStyle:UIAlertControllerStyleActionSheet];

    [m addAction:[UIAlertAction actionWithTitle:(bypassAtivo ? @"BYPASS: [ATIVO]" : @"BYPASS: [OFF]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){ bypassAtivo = !bypassAtivo; }]];
    [m addAction:[UIAlertAction actionWithTitle:(antibanAtivo ? @"ANTI-BAN: [ON]" : @"ANTI-BAN: [OFF]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){ antibanAtivo = !antibanAtivo; }]];
    [m addAction:[UIAlertAction actionWithTitle:(aim ? @"AIMBOT: [ON]" : @"AIMBOT: [OFF]") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a){ aim = !aim; }]];
    
    [m addAction:[UIAlertAction actionWithTitle:@"FECHAR" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:m animated:YES completion:nil];
}
%end
