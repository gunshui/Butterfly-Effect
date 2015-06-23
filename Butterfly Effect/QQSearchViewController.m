//
//  QQSearchViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/19.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQSearchViewController.h"

@interface QQSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>

{
    UISearchBar*aSearchBar;
    UISearchDisplayController*searchDisplay;
}
@property (weak, nonatomic) IBOutlet UITableView *tableviewSearch;

@end

@implementation QQSearchViewController
@synthesize tableviewSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //导航栏
    [self createNavigation];
    
    //搜索栏
    [self createSearch];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
   
}
-(void)createSearch{
//    aSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
//    aSearchBar.placeholder=@"请输入歌曲名";
//    //拿到textField
//    UITextField*textField=[[[[aSearchBar subviews]objectAtIndex:0] subviews] lastObject];
//    NSMutableAttributedString*attStr=[[NSMutableAttributedString alloc]initWithString:@"请输入关键字" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:14]}];
//    textField.attributedPlaceholder=attStr;
//    tableviewSearch.tableHeaderView=aSearchBar;
//    tableviewSearch.sectionHeaderHeight=100;
//    
//    aSearchBar.delegate=self;
//    searchDisplay=[[UISearchDisplayController alloc]initWithSearchBar:aSearchBar contentsController:self];
//    //    searchDisplay.searchResultsTableView.separatorStyle=UITableViewce
//    searchDisplay.searchResultsDataSource=self;
//    searchDisplay.searchResultsDelegate=self;

    UISearchController*searchController=[[UISearchController alloc]initWithSearchResultsController:self];
    //设置显示搜索结果的控制器
    searchController.searchResultsUpdater=self;
//    设置开始搜索时背景显示与否
    searchController.dimsBackgroundDuringPresentation=NO;
    searchController.hidesNavigationBarDuringPresentation = NO;
    
    searchController.searchBar.frame = CGRectMake(searchController.searchBar.frame.origin.x, searchController.searchBar.frame.origin.y, searchController.searchBar.frame.size.width, 44.0);
    //设置searchBar位置自适应
    [searchController.searchBar sizeToFit];
//
    tableviewSearch.tableFooterView =searchController.searchBar;
//
    
    
    

}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [aSearchBar setHidden:NO];
    //    NSLog(@"begin");
    searchBar.showsCancelButton=YES;
    for (id aa in [aSearchBar subviews])
    {
        for (id bb in [aa subviews])
        {
            if ([bb isKindOfClass:[UIButton class]])
            {
                UIButton*cancer=(UIButton*)bb;
                //cancer.frame=aCGRect;
                [cancer setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
    
}

-(void)createNavigation{
    self.title=@"搜索";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
    
    //设置导航栏文本的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //返回
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:KRect(0, 0, 20, 20)];
    [btnLeft setImage:KImage(@"返回按钮") forState:0];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;
    

}
-(void)btnLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
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
