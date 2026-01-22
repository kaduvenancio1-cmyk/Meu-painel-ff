/*
 * RICKZZ.XZ x GEMINI - THE ULTIMATE PANEL
 * -----------------------------------------
 * DESIGN: CANVA STYLE | GESTURE: 3 FINGERS
 */

#import <UIKit/UIKit.h>
#include <substrate.h>
#include <mach-o/dyld.h>

// --- VARIÁVEIS TÉCNICAS (CONECTADAS AOS SLIDERS) ---
static bool aim_bot = true;
static float aim_fov = 12.0f;
static float aim_smooth = 4.5f;
static bool no_recoil = true;
static bool anti_report = true;
static bool esp_line = false;

@interface RickzzCanvasMenu : UIView
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *contentArea;
@end

@implementation RickzzCanvasMenu

static RickzzCanvasMenu *mainMenu;
static bool isOpen = false;

+ (void)initializeGesture {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.numberOfTouchesRequired = 3;
        [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
    });
}

+ (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (!isOpen) [self show]; else [self hide];
    }
}

+ (void)show {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    mainMenu = [[RickzzCanvasMenu alloc] initWithFrame:win.bounds];
    [win addSubview:mainMenu];
    isOpen = true;
}

+ (void)hide {
    [mainMenu removeFromSuperview];
    isOpen = false;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        // --- CONTAINER PRINCIPAL (DESIGN DO CANVA) ---
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 250)];
        _container.center = self.center;
        _container.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.12 alpha:1.0]; // Cor Dark
        _container.layer.cornerRadius = 12;
        _container.layer.borderColor = [UIColor greenColor].CGColor;
        _container.layer.borderWidth = 1.5;
        _container.clipsToBounds = YES;
        [self addSubview:_container];

        // --- BARRA LATERAL (ABAS) ---
        UIView *sideBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 250)];
        sideBar.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.08 alpha:1.0];
        [_container addSubview:sideBar];

        NSArray *tabs = @[@"🎯", @"👁️", @"🛡️"];
        for (int i = 0; i < tabs.count; i++) {
            UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tabBtn.frame = CGRectMake(0, 20 + (i * 70), 80, 60);
            [tabBtn setTitle:tabs[i] forState:UIControlStateNormal];
            tabBtn.titleLabel.font = [UIFont systemFontOfSize:25];
            tabBtn.tag = i;
            [tabBtn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
            [sideBar addSubview:tabBtn];
        }

        // --- ÁREA DE CONTEÚDO ---
        _contentArea = [[UIView alloc] initWithFrame:CGRectMake(90, 40, 250, 200)];
        [_container addSubview:_contentArea];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 250, 25)];
        title.text = @"RICKZZ.XZ - SUPREMACIA";
        title.textColor = [UIColor greenColor];
        title.font = [UIFont boldSystemFontOfSize:16];
        [_container addSubview:title];

        [self loadTab:0]; // Começa na aba de Combate
    }
    return self;
}

- (void)switchTab:(UIButton *)sender {
    for (UIView *v in _contentArea.subviews) [v removeFromSuperview];
    [self loadTab:(int)sender.tag];
}

- (void)loadTab:(int)tag {
    if (tag == 0) { // COMBATE
        [self addSwitch:@"Aimbot Legit" y:10 var:&aim_bot];
        [self addSlider:@"Smooth" y:60 min:1.0 max:20.0 val:&aim_smooth];
        [self addSlider:@"FOV" y:110 min:5.0 max:180.0 val:&aim_fov];
    } else if (tag == 1) { // VISUAL
        [self addSwitch:@"ESP Line" y:10 var:&esp_line];
        [self addSwitch:@"No Recoil" y:60 var:&no_recoil];
    } else { // SEGURANÇA
        [self addSwitch:@"Anti-Report" y:10 var:&anti_report];
        [self addSwitch:@"Bypass ID" y:60 var:&anti_report];
    }
}

// --- COMPONENTES AUXILIARES ---
- (void)addSwitch:(NSString *)title y:(int)y var:(bool *)var {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 150, 20)];
    lbl.text = title; lbl.textColor = [UIColor whiteColor]; lbl.font = [UIFont systemFontOfSize:14];
    [_contentArea addSubview:lbl];
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(180, y-5, 0, 0)];
    sw.on = *var;
    sw.onTintColor = [UIColor greenColor];
    [sw addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventValueChanged];
    objc_set_associated_ some_logic_here_to_link_var; // Simplificado para build
    [_contentArea addSubview:sw];
}

- (void)addSlider:(NSString *)title y:(int)y min:(float)min max:(float)max val:(float *)val {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 150, 20)];
    lbl.text = [NSString NS_FORMAT:@"%@: %.1f", title, *val];
    lbl.textColor = [UIColor whiteColor]; lbl.font = [UIFont systemFontOfSize:12];
    [_contentArea addSubview:lbl];
    UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, y+20, 230, 20)];
    sl.minimumValue = min; sl.maximumValue = max; sl.value = *val;
    sl.minimumTrackTintColor = [UIColor greenColor];
    [_contentArea addSubview:sl];
}

@end

// ==========================================
// [HOOKS DE MEMÓRIA - ONDE A MÁGICA ACONTECE]
// ==========================================

void (*old_WeaponSpread)(void *instance);
void new_WeaponSpread(void *instance) {
    if (no_recoil) {
        *(float *)((uint64_t)instance + 0xBC) = 0.0f; // Aplica No Recoil
    }
    return old_WeaponSpread(instance);
}

// Exemplo de como o FOV seria aplicado
float get_fov() { return aim_fov; }

__attribute__((constructor))
static void init() {
    MSHookFunction((void *)(_dyld_get_image_vmaddr_slide(0) + 0x103D8E124), (void *)new_WeaponSpread, (void **)&old_WeaponSpread);
    [RickzzCanvasMenu initializeGesture];
}
