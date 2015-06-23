//
//  YYShowDetailsViewController.m
//  Butterfly Effect
//
//  Created by lyan on 15/6/19.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYShowDetailsViewController.h"
#import "YYShowDetailsCollectionViewCell.h"

@interface YYShowDetailsViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewDetails;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDetails;
- (IBAction)btnDetails:(id)sender;
- (IBAction)btnYoulike:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelRedline2;
@property (weak, nonatomic) IBOutlet UILabel *labelRedline1;
@end

@implementation YYShowDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //导航栏
    [self createNavigation];
    
    //WebView
    [self createWebView];
    
    _labelRedline1.hidden=NO;
    _labelRedline2.hidden=YES;
    
    //TableView
    [self createTableView];
    
    //CollectionView
    [self createCollectionView];
    
    //注册xib文件
    [_collectionViewDetails registerNib:[UINib nibWithNibName:@"YYShowDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELLs"];
    
    _tableViewDetails.hidden=NO;
    _collectionViewDetails.hidden=YES;
}

#pragma mark-HeaderTableView

- (IBAction)btnDetails:(id)sender {
    NSLog(@"视频详情");
    
    _labelRedline1.hidden=NO;
    _labelRedline2.hidden=YES;
    _tableViewDetails.hidden=NO;
    _collectionViewDetails.hidden=YES;
}

- (IBAction)btnYoulike:(id)sender {
    NSLog(@"猜你喜欢");
    
    _labelRedline1.hidden=YES;
    _labelRedline2.hidden=NO;
    _tableViewDetails.hidden=YES;
    _collectionViewDetails.hidden=NO;
}

#pragma mark-CollectionView

-(void)createCollectionView{
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    [_collectionViewDetails setCollectionViewLayout:layout];
    _collectionViewDetails.delegate=self;
    _collectionViewDetails.dataSource=self;
    _collectionViewDetails.backgroundColor=[UIColor clearColor];
    [_collectionViewDetails registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELLs"];
    _collectionViewDetails.showsVerticalScrollIndicator=NO;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ident=@"CELLs";
    YYShowDetailsCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"YYBrandClassCollectionViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_W-30)/3, (SCREEN_W-30)/3-20);
}

////定义每个UICollectionView 的 margin,只执行一次
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

//行与行之间的距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//列与列之间的距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//选中方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
}

#pragma mark-TableView

-(void)createTableView{
    _tableViewDetails.delegate=self;
    _tableViewDetails.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableViewDetails.showsVerticalScrollIndicator=NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableViewDetails) {
        return 346;
    }
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_tableViewDetails) {
        static NSString*ident=@"CELL";
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"YYShowDetailsTableViewCell" owner:nil options:nil] lastObject];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString*ident=@"CELL";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
//        cell=[[[NSBundle mainBundle] loadNibNamed:@"YYShowDetailsTableViewCell" owner:nil options:nil] lastObject];
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark-WebView

-(void)createWebView{
    _webViewShowDetails.scrollView.scrollEnabled=NO;
    _webViewShowDetails.delegate=self;
    NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"http://m.imus.cn/cont_video_app.php?id=410"]];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [_webViewShowDetails loadRequest:request];
}

#pragma mark-导航栏

-(void)createNavigation{
    self.title=@"秀场内容页";
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
