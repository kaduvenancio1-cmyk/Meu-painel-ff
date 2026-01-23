#import <UIKit/UIKit.h>

// Variáveis Globais
static bool liga_aim = false;
static bool liga_esp = false;
static float fov_raio = 100.0f;

@interface RickzzPainel : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tabela;
@property (nonatomic, strong) NSArray *opcoes;
@property (nonatomic, strong) CAShapeLayer *camadaFOV;
@end

@implementation RickzzPainel

__attribute__((constructor))
static void init_v26() {
    // Delay de 15 segundos para injetar após o motor gráfico
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *win = [[UIApplication sharedApplication] keyWindow];
        
        // GESTO: Toque rápido com 3 dedos (Sem segurar)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:[RickzzPainel class] action:@selector(mudarMenu:)];
        tap.numberOfTouchesRequired = 3;
        [win addGestureRecognizer:tap];
    });
}

+ (void)mudarMenu:(UITapGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        UIView *v = [w viewWithTag:999];
        if (v) v.hidden = !v.hidden;
        else {
            RickzzPainel *m = [[RickzzPainel alloc] initWithFrame:w.bounds];
            m.tag = 999;
            [w addSubview:m];
        }
    }
}

// SOLUÇÃO PARA O ERRO NS_DESIGNATED_INITIALIZER
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opcoes = @[@"Aimbot Pro", @"ESP Line", @"ESP Box", @"Tracer", @"Distancia", @"Head", @"Chest", @"ATIVAR FOV", @"Ajustar FOV"];
        
        // Camada Visual do FOV
        _camadaFOV = [CAShapeLayer layer];
        _camadaFOV.strokeColor = [UIColor cyanColor].CGColor;
        _camadaFOV.fillColor = [UIColor clearColor].CGColor;
        _camadaFOV.lineWidth = 2.0;
        _camadaFOV.hidden = YES;
        [self.layer addSublayer:_camadaFOV];

        // Design do Painel
        UIView *fundo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 380, 260)];
        fundo.center = self.center;
        fundo.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        fundo.layer.cornerRadius = 12;
        fundo.layer.borderWidth = 1.5;
        fundo.layer.borderColor = [UIColor cyanColor].CGColor;
        [self addSubview:fundo];

        // Tabela corrigida para não dar erro de build
        _tabela = [[UITableView alloc] initWithFrame:CGRectMake(5, 10, 370, 240) style:UITableViewStylePlain];
        _tabela.backgroundColor = [UIColor clearColor];
        _tabela.delegate = self;
        _tabela.dataSource = self;
        _tabela.separatorStyle = UITableViewCellSeparatorStyleNone;
        [fundo addSubview:_tabela];
    }
    return self;
}

- (void)desenharFOV {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:self.center radius:fov_raio startAngle:0 endAngle:2*M_PI clockwise:YES];
    _camadaFOV.path = p.CGPath;
}

- (void)swMudou:(UISwitch *)s {
    if (s.tag == 0) liga_aim = s.on;
    if (s.tag == 1) liga_esp = s.on;
    if (s.tag == 7) { 
        _camadaFOV.hidden = !s.on;
        [self desenharFOV];
    }
}

- (void)slMudou:(UISlider *)sl {
    fov_raio = sl.value;
    [self desenharFOV];
}

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)s { return self.opcoes.count; }

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)p {
    static NSString *cellID = @"id_cell";
    UITableViewCell *c = [t dequeueReusableCellWithIdentifier:cellID];
    if (c == nil) {
        c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    c.backgroundColor = [UIColor clearColor];
    c.textLabel.text = self.opcoes[p.row];
    c.textLabel.textColor = [UIColor whiteColor];
    c.selectionStyle = UITableViewCellSelectionStyleNone;

    if (p.row == 8) { // SLIDER
        UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 110, 20)];
        sl.minimumValue = 50; sl.maximumValue = 350; sl.value = fov_raio;
        [sl addTarget:self action:@selector(slMudou:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sl;
    } else {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = p.row;
        [sw addTarget:self action:@selector(swMudou:) forControlEvents:UIControlEventValueChanged];
        c.accessoryView = sw;
    }
    return c;
}
@end
