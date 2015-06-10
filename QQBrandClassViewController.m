//
//  QQBrandClassViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/8.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQBrandClassViewController.h"

@interface QQBrandClassViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray*arrColor;
    NSMutableArray*arrName;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBrandClass;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewBrandClass;
@end

@implementation QQBrandClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationController.navigationBar setBackgroundImage:blank forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = blank;
    
    self.title=@"品牌荟";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:nil size:19]};
    
    //色块数组
    [self creataArr];
    
    //collectionView
    [self createCollectionView];
}

#pragma mark-色块数组

-(void)creataArr{
    arrColor=[NSMutableArray arrayWithObjects:[UIColor colorWithRed:231.0/255.0 green:59.0/255.0 blue:53.0/255.0 alpha:1],[UIColor colorWithRed:23.0/255.0 green:182.0/255.0 blue:154.0/255.0 alpha:1],[UIColor colorWithRed:117.0/255.0 green:53.0/255.0 blue:192.0/255.0 alpha:1],[UIColor colorWithRed:242.0/255.0 green:156.0/255.0 blue:7.0/255.0 alpha:1],[UIColor colorWithRed:218.0/255.0 green:0 blue:108.0/255.0 alpha:1],[UIColor colorWithRed:105.0/255.0 green:195.0/255.0 blue:73.0/255.0 alpha:1],[UIColor colorWithRed:86.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1],[UIColor colorWithRed:76.0/255.0 green:103.0/255.0 blue:175.0/255.0 alpha:1],[UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1],[UIColor colorWithRed:231.0/255.0 green:59.0/255.0 blue:53.0/255.0 alpha:1],[UIColor colorWithRed:23.0/255.0 green:182.0/255.0 blue:154.0/255.0 alpha:1],[UIColor colorWithRed:117.0/255.0 green:53.0/255.0 blue:192.0/255.0 alpha:1],[UIColor colorWithRed:242.0/255.0 green:156.0/255.0 blue:7.0/255.0 alpha:1],[UIColor colorWithRed:218.0/255.0 green:0 blue:108.0/255.0 alpha:1],[UIColor colorWithRed:105.0/255.0 green:195.0/255.0 blue:73.0/255.0 alpha:1],[UIColor colorWithRed:86.0/255.0 green:188.0/255.0 blue:226.0/255.0 alpha:1],[UIColor colorWithRed:76.0/255.0 green:103.0/255.0 blue:175.0/255.0 alpha:1],[UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1], nil];
    
    arrName=[NSMutableArray arrayWithObjects:@"Line6",@"Livid",@"ARTURIA",@"SAMSON",@"audient",@"MiDiPLus",@"333",@"Hartke", nil];
}

#pragma mark-CollectionView

-(void)createCollectionView{
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    [_collectionViewBrandClass setCollectionViewLayout:layout];
    _collectionViewBrandClass.delegate=self;
    _collectionViewBrandClass.dataSource=self;
    _collectionViewBrandClass.backgroundColor=[UIColor clearColor];
    [_collectionViewBrandClass registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _collectionViewBrandClass.contentInset=UIEdgeInsetsMake(0, 0, 80, 0);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*ident=@"CELL";
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    
    //品牌logo的imageview
    UIImageView*imageViewBK=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_W-30)/3-20, (SCREEN_W-30)/3-20)];
    imageViewBK.backgroundColor=[arrColor objectAtIndex:indexPath.row];
    imageViewBK.layer.cornerRadius=((SCREEN_W-30)/3-20)/2;
    imageViewBK.layer.masksToBounds=YES;
    imageViewBK.center=CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
    [cell.contentView addSubview:imageViewBK];
    imageViewBK.tag=1000;
    
    //品牌名字的label
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewBK.frame), CGRectGetMaxY(imageViewBK.frame), imageViewBK.frame.size.width, 30)];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor blackColor];
    label.text=[arrName objectAtIndex:indexPath.row];
    [cell.contentView addSubview:label];
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_W-30)/3, (SCREEN_W-30)/3+10);
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
    return 0.001;
}

//选中方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    NSLog(@"%@",[arrName objectAtIndex:indexPath.row]);
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
