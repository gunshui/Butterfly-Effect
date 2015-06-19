//
//  YYBrandDetailsViewController.m
//  Butterfly Effect
//
//  Created by lyan on 15/6/19.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYBrandDetailsViewController.h"
#import "YYBrandContentViewController.h"

@interface YYBrandDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewBrandDetails;
- (IBAction)btnReview:(id)sender;
- (IBAction)btnLecturehall:(id)sender;
- (IBAction)btnShow:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelRedline;

@end

@implementation YYBrandDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //导航栏
    [self createNavigation];
    
    //TableView
    [self createTableView];
}

#pragma mark-HeaderTableView

- (IBAction)btnReview:(id)sender {
    NSLog(@"测评");
    
    [UIView animateWithDuration:0.2 animations:^{
        _labelRedline.frame=CGRectMake(0, 35, SCREEN_W/3, 2);
    }];
}

- (IBAction)btnLecturehall:(id)sender {
    NSLog(@"讲堂");
    
    [UIView animateWithDuration:0.2 animations:^{
        _labelRedline.frame=CGRectMake(SCREEN_W/3, 35, SCREEN_W/3, 2);
    }];
}

- (IBAction)btnShow:(id)sender {
    NSLog(@"秀场");
    
    [UIView animateWithDuration:0.2 animations:^{
        _labelRedline.frame=CGRectMake(2*SCREEN_W/3, 35, SCREEN_W/3, 2);
    }];
}

#pragma mark-TableView

-(void)createTableView{
    _tableViewBrandDetails.delegate=self;
    _tableViewBrandDetails.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    //橡皮糖刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableViewBrandDetails];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [_tableViewBrandDetails addFooterWithTarget:self action:@selector(footAction)];
}

-(void)footAction{
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [_tableViewBrandDetails footerEndRefreshing];
        
    });
    
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [refreshControl endRefreshing];
        
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 266;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*viewHeader=[[[NSBundle mainBundle]loadNibNamed:@"BrandDetailHeaderTableView" owner:self options:nil] lastObject];
    return viewHeader;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ident=@"CELL";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"QQShowTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    
    YYBrandContentViewController*brandContent=[[YYBrandContentViewController alloc]init];
    brandContent.strTitles=self.title;
    [self.navigationController pushViewController:brandContent animated:YES];
}

#pragma mark-导航栏

-(void)createNavigation{
    self.title=self.strTitle;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    
    //设置导航栏文本的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //返回
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:KRect(0, 0, 25, 25)];
    [btnLeft setImage:KImage(@"返回按钮") forState:0];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;
    //搜索
    UIButton*btnRight=[[UIButton alloc]initWithFrame:KRect(0, 0, 25, 25)];
    [btnRight setImage:KImage(@"搜索") forState:0];
//    [btnRight addTarget:self action:@selector(btnRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*barRight=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barRight;
}

-(void)btnLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Show_Tabbar" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
