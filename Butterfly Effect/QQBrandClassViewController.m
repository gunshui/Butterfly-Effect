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
#import "QQSearchViewController.h"

@interface QQBrandClassViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray*arrName;
    NSMutableArray*arrImage;
    NSMutableArray*arrPics;
    NSDictionary*dictScrollView;
    UIActivityIndicatorView*indicators;
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
    
    [self createActivity];
}

-(void)createActivity{
    indicators=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREEN_W/2-20, 150, 40, 40)];
    indicators.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicators];
    [indicators startAnimating];
}

#pragma mark-海报ScrollView

-(void)createScrollView{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*body=[NSString stringWithFormat:@"action=v1&typeid=8"];
        GetData*getData=[GetData getdataWithUrl:@"/document/show_slide.php" Body:body];
        dictScrollView=getData.dict;
//        NSLog(@"dictScrollView====%@",dictScrollView);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicators stopAnimating];
            
            _scrollViewBrandClass.delegate=self;
            _scrollViewBrandClass.showsHorizontalScrollIndicator=NO;
            _scrollViewBrandClass.showsVerticalScrollIndicator=NO;
            _scrollViewBrandClass.pagingEnabled=YES;
            _scrollViewBrandClass.contentSize=CGSizeMake(SCREEN_W*([[dictScrollView objectForKey:@"msg"] count]+2), 0);
            
            _pageControlBrandClass.numberOfPages=[[dictScrollView objectForKey:@"msg"] count];
            _pageControlBrandClass.currentPage=0;
            _pageControlBrandClass.pageIndicatorTintColor=[UIColor whiteColor];
            _pageControlBrandClass.currentPageIndicatorTintColor=[UIColor lightGrayColor];
            [_pageControlBrandClass addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventTouchUpInside];
            _pageControlBrandClass.backgroundColor=[UIColor clearColor];
            
            int count=(int)[[dictScrollView objectForKey:@"msg"] count];
            for (int i=0; i<([[dictScrollView objectForKey:@"msg"] count]+2); i++) {
                UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W*i, 0, SCREEN_W, self.scroll_height.constant)];
                btn.tag=i+2000;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [_scrollViewBrandClass addSubview:btn];
                if (i==0) {
                    [arrPics addObject:[[[dictScrollView objectForKey:@"msg"] objectAtIndex:count-1]objectForKey:@"slide_litpic"]];
                }else if (i==[[dictScrollView objectForKey:@"msg"] count]+2-1){
                    [arrPics addObject:[[[dictScrollView objectForKey:@"msg"] objectAtIndex:0]objectForKey:@"slide_litpic"]];
                }else{
                    [arrPics addObject:[[[dictScrollView objectForKey:@"msg"] objectAtIndex:(i-1)]objectForKey:@"slide_litpic"]];
                }
                
                UIImageView*imageClass=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H/3)];
                [imageClass setImageWithURL:[NSURL URLWithString:[arrPics objectAtIndex:i]] placeholderImage:nil];
                imageClass.clipsToBounds=YES;
                imageClass.contentMode=UIViewContentModeScaleAspectFill;
                [btn addSubview:imageClass];
            }
            _scrollViewBrandClass.contentOffset=CGPointMake(SCREEN_W, 0);
        });
    });
}

-(void)btnAction:(UIButton*)sender{
    NSLog(@"%ld",sender.tag-2000);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControlBrandClass.currentPage=_scrollViewBrandClass.contentOffset.x/SCREEN_W-1;
    if ((_scrollViewBrandClass.contentOffset.x/SCREEN_W)>[[dictScrollView objectForKey:@"msg"] count]) {
        _pageControlBrandClass.currentPage=0;
    }else if ((_scrollViewBrandClass.contentOffset.x/SCREEN_W)<=0) {
        _pageControlBrandClass.currentPage=[[dictScrollView objectForKey:@"msg"] count];
    }
    if (_scrollViewBrandClass.contentOffset.x<=0) {
        _scrollViewBrandClass.contentOffset=CGPointMake(SCREEN_W*[[dictScrollView objectForKey:@"msg"] count], 0);
    }
    if (_scrollViewBrandClass.contentOffset.x>SCREEN_W*[[dictScrollView objectForKey:@"msg"] count]) {
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
    //搜索
    UIButton*btnRight=[[UIButton alloc]initWithFrame:KRect(0, 0, 20, 20)];
    [btnRight setImage:KImage(@"搜索") forState:0];
    [btnRight addTarget:self action:@selector(btnRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*barRight=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem=barRight;
}

-(void)btnRightAction{
    QQSearchViewController*searchView=[[QQSearchViewController alloc]init];
    UINavigationController*nav_search=[[UINavigationController alloc]initWithRootViewController:searchView];
    [self presentViewController:nav_search animated:YES completion:^{
        
    }];
}

#pragma mark-色块数组

-(void)creataArr{
    //图片数组
    arrImage=[NSMutableArray arrayWithObjects:@"line6aaa",@"midiplusaaa",@"samsonaaa",@"arturiaaaa",@"333aaa",@"audientaaa",@"lividaaa",@"hartkeaaa", nil];
    //品牌名数组
    arrName=[NSMutableArray arrayWithObjects:@"LINE6",@"MIDIPLUS",@"SAMSON",@"ARTURIA",@"333",@"AUDIENT",@"LIVID",@"HARTKE", nil];
    
    arrPics=[[NSMutableArray alloc]init];
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
    if (indexPath.row==0) {
        brandDetails.prodID=@"65";
    }else if (indexPath.row==1){
        brandDetails.prodID=@"67";
    }else if (indexPath.row==2){
        brandDetails.prodID=@"69";
    }else if (indexPath.row==3){
        brandDetails.prodID=@"70";
    }else if (indexPath.row==4){
        brandDetails.prodID=@"111";
    }else if (indexPath.row==5){
        brandDetails.prodID=@"68";
    }else if (indexPath.row==6){
        brandDetails.prodID=@"66";
    }else if (indexPath.row==7){
        brandDetails.prodID=@"110";
    }
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
