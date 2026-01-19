#import <UIKit/UIKit.h>

%hook UnityPlayer
- (void)update {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"MENU" forState:UIControlStateNormal];
        btn.frame = CGRectMake(100, 150, 80, 40);
        btn.backgroundColor = [UIColor redColor];
        btn.layer.cornerRadius = 10;
        [btn addTarget:self action:@selector(abrirPainel) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:btn];
    });
}

%new
- (void)abrirPainel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Painel" message:@"O menu abriu com sucesso!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
%end
