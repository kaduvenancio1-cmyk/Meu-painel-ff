#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <dlfcn.h>

// Variáveis Globais
static bool menu_aberto = false;

@interface PainelRick : UIView
@end

@implementation PainelRick

// Isso injeta o menu no coração do jogo
__attribute__((constructor))
static void carregar_painel() {
    NSLog(@"[Rickzz] Injetado com sucesso!");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[PainelRick class] action:@selector(abrir)];
        tap.numberOfTouchesRequired = 3;
        [window addGestureRecognizer:tap];
    });
}

+ (void)abrir {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:999];
    if (old) {
        [old removeFromSuperview];
    } else {
        PainelRick *menu = [[PainelRick alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
        menu.tag = 999;
        menu.center = win.center;
        [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor greenColor].CGColor;

        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
        t.text = @"RICKZZ.XZ - V3 OFICIAL";
        t.textColor = [UIColor greenColor];
        t.textAlignment = NSTextAlignmentCenter;
        [self addSubview:t];

        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.frame = CGRectMake(60, 80, 200, 40);
        b.backgroundColor = [UIColor greenColor];
        [b setTitleColor:[UIColor blackColor] forState:0];
        [b setTitle:@"LIMPAR TUDO (ANTI-BAN)" forState:0];
        [b addTarget:self action:@selector(clean) forControlEvents:64];
        [self addSubview:b];
    }
    return self;
}

- (void)clean {
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)query);
    exit(0); // Fecha o jogo pra limpar
}
@end
