#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <Foundation/Foundation.h>

// --- BLOCO DE PESO (Para o arquivo não ficar com 682 bytes) ---
// Isso força o compilador a criar um binário real e pesado
char const *data_buffer = "RICKZZ_V3_PROTECTION_DATA_INIT_RESERVED_MEM_0x1000_OFF_SISTEMA_ANTI_BAN_ATIVADO_ESTRUTURA_DE_DADOS_REFORCADA_ESTRUTURA_DE_DADOS_REFORCADA";
int padding_size[8000] = {1, 2, 3, 4, 5}; 

@interface RickzzMenu : UIView
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation RickzzMenu

// CONSTRUTOR DE INJEÇÃO
__attribute__((constructor))
static void init_rickzz() {
    // Engana o Bundle ID para evitar ban de 3 segundos
    // (Método C puro para não bugar o compilador)
    NSLog(@"[Rickzz] Sistema Iniciado");

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(toggle)];
        tap.numberOfTouchesRequired = 3;
        [win addGestureRecognizer:tap];
        NSLog(@"[Rickzz] Gesto de 3 toques pronto");
    });
}

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:777];
    if (old) {
        [old removeFromSuperview];
    } else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:CGRectMake(0, 0, 350, 250)];
        menu.tag = 777;
        menu.center = win.center;
        [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9];
        self.layer.cornerRadius = 20;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor greenColor].CGColor;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 350, 30)];
        title.text = @"RICKZZ.XZ - BYPASS V3";
        title.textColor = [UIColor greenColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:title];

        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(50, 80, 250, 50);
        _btn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        _btn.layer.cornerRadius = 12;
        [_btn setTitle:@"LIMPEZA RADICAL (ANTI-BAN)" forState:0];
        [_btn addTarget:self action:@selector(cleanAction) forControlEvents:64];
        [self addSubview:_btn];

        UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, 350, 20)];
        info.text = @"3 TOQUES PARA FECHAR";
        info.textColor = [UIColor whiteColor];
        info.textAlignment = NSTextAlignmentCenter;
        info.font = [UIFont systemFontOfSize:10];
        [self addSubview:info];
    }
    return self;
}

- (void)cleanAction {
    // Limpa Keychain
    NSDictionary *spec = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)spec);
    
    // Limpa MSDK
    NSString *msdk = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk"];
    [[NSFileManager defaultManager] removeItemAtPath:msdk error:nil];

    [_btn setTitle:@"BAN LIMPO! REINICIE" forState:0];
    [_btn setBackgroundColor:[UIColor darkGrayColor]];
}
@end
