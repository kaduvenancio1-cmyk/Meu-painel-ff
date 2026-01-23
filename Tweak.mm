#import <UIKit/UIKit.h>

// Definições de Memória (Simuladas para estabilidade)
static bool ligar_aim = false;
static bool ligar_esp = false;
static float fov_dist = 100.0f;

@interface RickzzPainel : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tabelaMenu;
@property (nonatomic, strong) CAShapeLayer *circuloFOV;
@property (nonatomic, strong) NSArray *listaOpcoes;
@end

@implementation RickzzPainel

__attribute__((constructor))
static void principal() {
    // Delay de 15s para garantir que a engine do jogo já carregou
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        
        // GESTO: Toque rápido com 3 dedos para abrir/fechar
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzPainel class] action:@selector(mudarEstado:)];
        t.numberOfTouchesRequired = 3;
        [w addGestureRecognizer:t];
    });
}

+ (void)mudarEstado:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:777];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzPainel *p = [[RickzzPainel alloc] initWithFrame:w.bounds];
            p.tag = 777;
            [w addSubview:p];
        }
    }
}

// CORREÇÃO DO ERRO DESIGNATED INITIALIZER (Visto nos logs)
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.listaOpcoes = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;

        // CAMADA DO FOV (VISUAL)
        _circuloFOV = [CAShapeLayer layer];
        _circuloFOV.strokeColor = [UIColor cyanColor].CGColor;
        _circuloFOV.fillColor = [UIColor clearColor].CGColor;
        _circuloFOV.lineWidth = 2.0;
        _circuloFOV.hidden = YES;
        [self.layer addSublayer:_circuloFOV];

        // PAINEL DE CONTROLE
        UIView *fundo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 380, 250)];
        fundo.center = self.center;
        fundo.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        fundo.layer.cornerRadius = 15;
        fundo.layer.borderColor = [UIColor cyanColor].CGColor;
        fundo.layer.borderWidth = 1.5;
        [self addSubview:fundo];

        _tabelaMenu = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 370, 230) style:UITableViewStylePlain];
        _tabelaMenu.backgroundColor = [UIColor clearColor];
        _tabelaMenu.delegate = self;
        _tabelaMenu.dataSource = self;
        _tabelaMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
        [fundo addSubview:_tabelaMenu];
    }
    return self;
}

- (void)desenharFOV {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_dist startAngle:0 endAngle:2*M_PI clockwise:YES];
    _circuloFOV.path = path.CGPath;
}

- (void)acaoSwitch:(UISwitch *)s {
    if (s.tag == 0) ligar_aim = s.on;
    if (s.tag == 1) ligar_esp = s.on;
    if (s.tag == 7) { 
        _circuloFOV.hidden = !s.on;
        [self desenharFOV];
    }
}

- (void)acaoSlider:(UISlider *)sl {
    fov_dist = sl.value;
    [self desenharFOV];
}

// MÉTODOS DA TABELA
- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.listaOpcoes.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.listaOpcoes[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) { // SLIDER
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
        sl.minimumValue = 30; sl.maximumValue = 400; sl.value = fov_dist;
        [sl addTarget:self action:@selector(acaoSlider:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row;
        [sw addTarget:self action:@selector(acaoSwitch:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
