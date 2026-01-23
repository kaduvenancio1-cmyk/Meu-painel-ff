#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <Foundation/Foundation.h>

@interface RickzzMenu : UIView
@property (nonatomic, strong) UIButton *btn;
@end

@implementation RickzzMenu

// INJEÇÃO SEGURA
__attribute__((constructor))
static void init_rickzz() {
    // Limpeza de rastros ao iniciar
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *spec = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword};
        SecItemDelete((__bridge CFDictionaryRef)spec);
        
        NSString *msdk = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/com.garena.msdk"];
        [[NSFileManager defaultManager] removeItemAtPath:msdk error:nil];
    });

    // Ativa o menu após 20 segundos para evitar o ban de 3 segundos
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    win = windowScene.windows.firstObject;
                    break;
                }
            }
        } else {
            win = [[UIApplication sharedApplication] keyWindow];
        }

        if (win) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzMenu class] action:@selector(toggle)];
            tap.numberOfTouchesRequired = 3;
            [win addGestureRecognizer:tap];
        }
    });
}

+ (void)toggle {
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *old = [win viewWithTag:777];
    if (old) {
        [old removeFromSuperview];
    } else {
        RickzzMenu *menu = [[RickzzMenu alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        menu.tag = 777;
        menu.center = win.center;
        [win addSubview:menu];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9];
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 1.5;
        self.layer.borderColor = [UIColor cyanColor].CGColor;

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
        title.text = @"RICKZZ CLONE - BYPASS V4";
        title.textColor = [UIColor cyanColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:title];

        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(40, 70, 240, 50);
        _btn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        _btn.layer.cornerRadius = 10;
        [_btn setTitle:@"PROTEÇÃO ATIVA" forState:0];
        [self addSubview:_btn];
    }
    return self;
}
@end
