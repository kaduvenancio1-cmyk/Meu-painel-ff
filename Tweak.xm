#import <UIKit/UIKit.h>
#import <Security/Security.h>

// Variáveis
static bool aim = false;
static bool bypass = false;

// Menu
@interface RickMenu : UIView
@end

@implementation RickMenu

static RickMenu *inst;

// ISSO É O QUE FAZ O MENU APARECER
__attribute__((constructor))
static void inicializar() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIApplication *app = [UIApplication sharedApplication];
        UIWindow *win = app.keyWindow;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickMenu class] action:@selector(abrir)];
        tap.numberOfTouchesRequired = 3;
        [win addGestureRecognizer:tap];
    });
}

+ (void)abrir {
    if (!inst) {
        inst = [[RickMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[UIApplication sharedApplication].keyWindow addSubview:inst];
    } else {
        [inst removeFromSuperview];
        inst = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        bg.center = self.center;
        bg.backgroundColor = [UIColor blackColor];
        bg.layer.cornerRadius = 10;
        bg.layer.borderColor = [UIColor greenColor].CGColor;
        bg.layer.borderWidth = 2;
        [self addSubview:bg];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 30)];
        title.text = @"RICKZZ - V3";
        title.textColor = [UIColor greenColor];
        title.textAlignment = NSTextAlignmentCenter;
        [bg addSubview:title];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50, 70, 200, 40);
        btn.backgroundColor = [UIColor darkGrayColor];
        [btn setTitle:@"LIMPAR BAN" forState:0];
        [btn addTarget:self action:@selector(limpar) forControlEvents:64];
        [bg addSubview:btn];
    }
    return self;
}

- (void)limpar {
    NSDictionary *s = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)s);
    printf("Ban Limpo\n");
}
@end
