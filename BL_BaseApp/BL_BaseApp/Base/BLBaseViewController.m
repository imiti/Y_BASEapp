//
//  BLBaseViewController.m
//  BL_BaseApp
//
//  Created by 王印 on 16/7/22.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "BLBaseViewController.h"
#import "BLWebViewController.h"
@interface BLBaseViewController ()

@property(nonatomic,strong)UIView       *loadAnimationView;

@property(nonatomic,assign)NSInteger         fristLoad;
@end

@implementation BLBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navagationBarHeight = 44;
        self.fristLoad = 0;
    }
    return self;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoadFinish{
    if (self.fristLoad!=1) {
        return;
    }
}

- (UIView *)loadAnimationView{
    if (!_loadAnimationView) {
        _loadAnimationView = [[UIView alloc]initWithFrame:self.view.frame];
        _loadAnimationView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center = self.view.center;
        [activity startAnimating];
        [_loadAnimationView addSubview:activity];
        UILabel *  label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        label.textAlignment = 1;
        label.center =CGPointMake(activity.center.x, activity.center.y+40);
        label.textColor = [UIColor grayColor];
        label.text = @"正在加载...";
        label.font = [UIFont systemFontOfSize:13];
        [_loadAnimationView addSubview:label];
    }
    return _loadAnimationView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:44-self.navagationBarHeight forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.backBarButtonItem setBackgroundVerticalPositionAdjustment:44-self.navagationBarHeight forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.leftBarButtonItem setBackgroundVerticalPositionAdjustment:44-self.navagationBarHeight forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:44-self.navagationBarHeight forBarMetrics:UIBarMetricsDefault];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:)name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:)name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setRefreshView:(UIScrollView *)refreshView
{
    if (_refreshView!=refreshView) {
        _refreshView = refreshView;
        WEAKSELF
        refreshView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefreshRefreshView:refreshView];
        }];
        refreshView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefreshRefreshView:refreshView];
        }];
    }
}

- (void)textDidChange:(id)textView
{
    
}

//下拉刷新
- (void)headerRefreshRefreshView:(UIScrollView *)view{
    NSLog(@"刷新");
    [view.mj_header endRefreshing];
}
//上拉加载更多
- (void)footerRefreshRefreshView:(UIScrollView *)view{
    NSLog(@"加载更多");
}

- (void)showLoad{
    [self.loadAnimationView.layer removeFromSuperlayer];
    [self.view.layer addSublayer:self.loadAnimationView.layer];
}

- (void)hidenLoad{
    [self.loadAnimationView.layer removeFromSuperlayer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navagationBarLucency) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }else{
    
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (!self.navagationBarLucency) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //配置navagationbar的属性
    [self.navigationController setNavigationBarHidden:_navagationBarHiden animated:YES];
    self.navigationController.navigationBar.barTintColor = self.navagationBarColor?: [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor =self.navagationBarTextColor?: [UIColor blackColor];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:self.navagationBarTextColor?:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self _setNavagationBarHeight];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.fristLoad==0) {
        [self viewDidLoadFinish];
        
    }
    self.fristLoad+=1;
    [self _setNavagationBarHeight];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.backBarButtonItem setBackgroundVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.leftBarButtonItem setBackgroundVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
}


- (void)_setNavagationBarHeight
{
    if (self.navagationBarHeight!=44) {
        self.navigationController.navigationBar.clipsToBounds = NO;
    }
    
    CGRect rect = self . navigationController . navigationBar . frame ;
    self . navigationController . navigationBar . frame = CGRectMake ( rect . origin . x , rect . origin . y , rect . size . width , self.navagationBarHeight ) ;
    

    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:44-self.navagationBarHeight forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.backBarButtonItem setBackgroundVerticalPositionAdjustment:44-self.navagationBarHeight forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.leftBarButtonItem setBackgroundVerticalPositionAdjustment:44-self.navagationBarHeight forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:44-self.navagationBarHeight forBarMetrics:UIBarMetricsDefault];
}
- (void)setNavagationBarLucency:(BOOL)navagationBarLucency
{
    _navagationBarLucency = navagationBarLucency;
    if (navagationBarLucency) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }else{
        //配置navagationbar的属性
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (!_navagationBarLucency) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)setNavagationBarHiden:(BOOL)navagationBarHiden{
    _navagationBarHiden = navagationBarHiden;
    [self.navigationController setNavigationBarHidden:navagationBarHiden animated:YES];
}

//
- (void)pushPage:(UIViewController *)viewController Animated:(BOOL)animated{
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}

//
- (void)popAnimated:(BOOL)animated{
    if (self.navigationController&&self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

//
- (void)popToRootAnimated:(BOOL)animated{
    if (self.navigationController&&self.navigationController.viewControllers.count>1) {
        [self.navigationController popToRootViewControllerAnimated:animated];
    }
}

- (void)pushWeb:(NSString *)url HidenNavBar:(BOOL)hiden{
    BLWebViewController *web = [[BLWebViewController alloc] initWithUrl:url];
    web.hidesBottomBarWhenPushed = YES;
    web.navagationBarHiden = hiden;
    [self pushPage:web Animated:YES];
}

- (void)callPhone:(NSString *)phone{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
@end
