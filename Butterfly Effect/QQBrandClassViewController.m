//
//  QQBrandClassViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/8.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQBrandClassViewController.h"
#import "YYBrandClassCollectionViewCell.h"
#import "YYBrandDetailsViewController.h"

@interface QQBrandClassViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray*arrName;
    NSMutableArray*arrImage;
    NSMutableArray*arrPic;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scroll_height;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBrandClass;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewBrandClass;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlBrandClass;

@end

@implementation QQBrandClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"QQBrandClassViewController");
    // Do any additional setup after loading the view from its nib.
    
   
    
    //导航栏
    [self createNavigation];
    
    //色块数组
    [self creataArr];
    
    //海报scrollView
    [self createScrollView];
    
    //collectionView
    [self createCollectionView];
    
    //注册xib文件
    [self.collectionViewBrandClass registerNib:[UINib nibWithNibName:@"YYBrandClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
}

#pragma mark-海报ScrollView

-(void)createScrollView{
    _scrollViewBrandClass.delegate=self;
    _scrollViewBrandClass.showsHorizontalScrollIndicator=NO;
    _scrollViewBrandClass.showsVerticalScrollIndicator=NO;
    _scrollViewBrandClass.pagingEnabled=YES;
    _scrollViewBrandClass.contentSize=CGSizeMake(SCREEN_W*4, 0);
    
    _pageControlBrandClass.numberOfPages=2;
    _pageControlBrandClass.currentPage=0;
    _pageControlBrandClass.pageIndicatorTintColor=[UIColor whiteColor];
    _pageControlBrandClass.currentPageIndicatorTintColor=[UIColor lightGrayColor];
    [_pageControlBrandClass addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
    _pageControlBrandClass.backgroundColor=[UIColor clearColor];
    
    for (int i=0; i<4; i++) {
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*i, 0, SCREEN_W, self.scroll_height.constant)];
        btn.tag=i+2000;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollViewBrandClass addSubview:btn];
        if (i==0) {
            [btn setImage:[UIImage imageNamed:[arrPic objectAtIndex:1]] forState:0];
        }else if (i==3) {
            [btn setImage:[UIImage imageNamed:[arrPic objectAtIndex:0]] forState:0];
        }else{
            [btn setImage:[UIImage imageNamed:[arrPic objectAtIndex:i-1]] forState:0];
        }
    }
    _scrollViewBrandClass.contentOffset=CGPointMake(SCREEN_W, 0);
}

-(void)btnAction:(UIButton*)sender{
    NSLog(@"%ld",sender.tag-2000);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControlBrandClass.currentPage=_scrollViewBrandClass.contentOffset.x/SCREEN_W-1;
    if ((_scrollViewBrandClass.contentOffset.x/SCREEN_W)>2) {
        _pageControlBrandClass.currentPage=0;
        
    }else if ((_scrollViewBrandClass.contentOffset.x/SCREEN_W)<=0) {
        _pageControlBrandClass.currentPage=1;
    }
    
    if (_scrollViewBrandClass.contentOffset.x<=0) {
        _scrollViewBrandClass.contentOffset=CGPointMake(SCREEN_W*2, 0);
        
    }
    if (_scrollViewBrandClass.contentOffset.x>SCREEN_W*2) {
        _scrollViewBrandClass.contentOffset=CGPointMake(SCREEN_W, 0);
    }
}

-(void)pageAction:(id)sender{
    _scrollViewBrandClass.contentOffset=CGPointMake(SCREEN_W*_pageControlBrandClass.currentPage, 0);
}

#pragma mark-导航栏

-(void)createNavigation{
    
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    //设置导航栏文本的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //分类
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:KRect(0, 0, 30, 30)];
    [btnLeft setImage:KImage(@"分类") forState:0];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;
    //搜索
    UIButton*btnRight=[[UIButton alloc]initWithFrame:KRect(0, 0, 25, 25)];
    [btnRight setImage:KImage(@"搜索") forState:0];
    UIBarButtonItem*barRight=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barRight;
}

#pragma mark-色块数组

-(void)creataArr{
    //图片数组
    arrImage=[NSMutableArray arrayWithObjects:@"line6",@"midiplus",@"samson",@"arturia",@"333",@"audient",@"livid",@"hartke", nil];
    //品牌名数组
    arrName=[NSMutableArray arrayWithObjects:@"LINE6",@"MIDIPLUS",@"SAMSON",@"HARTKE",@"333",@"AUDIENT",@"LIVID",@"ARTURIA", nil];
    
    arrPic=[NSMutableArray arrayWithObjects:@"品牌广告",@"2", nil];
}

#pragma mark-CollectionView

-(void)createCollectionView{
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    [_collectionViewBrandClass setCollectionViewLayout:layout];
    _collectionViewBrandClass.delegate=self;
    _collectionViewBrandClass.dataSource=self;
    _collectionViewBrandClass.backgroundColor=[UIColor clearColor];
    [_collectionViewBrandClass registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    _collectionViewBrandClass.showsVerticalScrollIndicator=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    _collectionViewBrandClass.contentInset=UIEdgeInsetsMake(0, 0, 50, 0);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ident=@"CELL";
    YYBrandClassCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"YYBrandClassCollectionViewCell" owner:nil options:nil] lastObject];
    }
    cell.imageViewBrandClassCollecctionViewCell.image=[UIImage imageNamed:[arrImage objectAtIndex:indexPath.row]];
    cell.labelBrandClassCollectionViewCell.text=[arrName objectAtIndex:indexPath.row];
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_W-30)/3, (SCREEN_W-30)/3);
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
    NSLog(@"%@",[arrName objectAtIndex:indexPath.row]);
    
    YYBrandDetailsViewController*brandDetails=[[YYBrandDetailsViewController alloc]init];
    brandDetails.strTitle=[arrName objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:brandDetails animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Hidden_Tabbar" object:nil userInfo:nil];
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
