#import <UIKit/UIKit.h>
#import <Security/Security.h>
#include <substrate.h>

// Variáveis essenciais
static bool aim = false;
static bool byp_on = false;
static bool l_cache = false;

// Função de limpeza
void deep_clean_id() {
    NSDictionary *spec = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
    SecItemDelete((__bridge CFDictionaryRef)spec);
}

@interface RickzzMenu : UIView
@property (nonatomic, strong) UIView *bg;
@end

@implementation RickzzMenu
static RickzzMenu *inst;

// O SEGREDO: Construtor que força o compilador a incluir o código
__attribute__((constructor)) static void setup() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(toggle)];
        tap.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
    });
}

+ (void)toggle {
    if(!inst) {
        inst = [[RickzzMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[UIApplication sharedApplication].keyWindow addSubview:inst];
    } else {
        [inst removeFromSuperview];
        inst = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 250)];
        _bg.center = self.center;
        _bg.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9];
        _bg.layer.cornerRadius = 15;
        _bg.layer.borderColor = [UIColor greenColor].CGColor;
        _bg.layer.borderWidth = 2;
        [self addSubview:_bg];

        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 400, 30)];
        l.text = @"RICKZZ.XZ - INJECTED";
        l.textColor = [UIColor greenColor];
        l.textAlignment = NSTextAlignmentCenter;
        [_bg addSubview:l];

        [self bnt:@"BYPASS" y:60 var:&byp_on];
        [self bnt:@"LIMPEZA" y:110 var:&l_cache];
        [self bnt:@"AIMBOT" y:160 var:&aim];
    }
    return self;
}

- (void)bnt:(NSString*)t y:(int)y var:(bool*)v {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(50, y, 300, 40)];
    b.backgroundColor = [UIColor darkGrayColor];
    b.layer.cornerRadius = 8;
    [b setTitle:[NSString stringWithFormat:@"%@: %@", t, (*v ? @"ON" : @"OFF")] forState:0];
    b.accessibilityValue = [NSString stringWithFormat:@"%p", v];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [b addTarget:self action:@selector(act:) forControlEvents:64];
    [_bg addSubview:b];
}

- (void)act:(UIButton*)s {
    bool *v = (bool *)strtoull([s.accessibilityValue UTF8String], NULL, 16);
    *v = !(*v);
    NSString *title = [[s titleForState:0] componentsSeparatedByString:@":"][0];
    [s setTitle:[NSString stringWithFormat:@"%@: %@", title, (*v ? @"ON" : @"OFF")] forState:0];
    if (l_cache) deep_clean_id();
}
@end
