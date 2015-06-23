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
    NSDictionary*dictSearch;
    int numSearch;
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
    aSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    aSearchBar.placeholder=@"请输入歌曲名";
    //拿到textField
    UITextField*textField=[[[[aSearchBar subviews]objectAtIndex:0] subviews] lastObject];
    NSMutableAttributedString*attStr=[[NSMutableAttributedString alloc]initWithString:@"请输入关键字" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:14]}];
    textField.attributedPlaceholder=attStr;
    tableviewSearch.tableHeaderView=aSearchBar;
    tableviewSearch.sectionHeaderHeight=100;
    
    aSearchBar.delegate=self;
    searchDisplay=[[UISearchDisplayController alloc]initWithSearchBar:aSearchBar contentsController:self];
    //    searchDisplay.searchResultsTableView.separatorStyle=UITableViewce
    searchDisplay.searchResultsDataSource=self;
    searchDisplay.searchResultsDelegate=self;
    searchDisplay.searchResultsTableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);

    
    UILabel*hotLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 30)];
    hotLable.textColor=[UIColor colorWithRed:88.0/255.0 green:85.0/255.0 blue:182.0/255.0 alpha:1];
    hotLable.text=@"热门搜索:";
    hotLable.font=[UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:15];
    [tableviewSearch addSubview:hotLable];

//    UISearchController*searchController=[[UISearchController alloc]initWithSearchResultsController:self];
//    //设置显示搜索结果的控制器
//    searchController.searchResultsUpdater=self;
////    设置开始搜索时背景显示与否
//    searchController.dimsBackgroundDuringPresentation=NO;
//    searchController.hidesNavigationBarDuringPresentation = NO;
//    
//    searchController.searchBar.frame = CGRectMake(searchController.searchBar.frame.origin.x, searchController.searchBar.frame.origin.y, searchController.searchBar.frame.size.width, 44.0);
//    //设置searchBar位置自适应
//    [searchController.searchBar sizeToFit];
////
//    tableviewSearch.tableFooterView =searchController.searchBar;
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
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*strBody=[NSString stringWithFormat:@"action=v1&page=1&maxsize=20&mid=&sort=&isanswer=&aid=0&keyword=%@",searchBar.text];
        GetData*getData=[GetData getdataWithUrl:@"/ask/list.php" Body:strBody];
        NSLog(@"search====%@",getData.dict);
        dictSearch=getData.dict;
        if ([[dictSearch objectForKey:@"status"]isEqualToString:@"ok"]) {
            numSearch=(int)[[dictSearch objectForKey:@"msg"] count];
        }else{
            numSearch=0;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchDisplay.searchResultsTableView reloadData];
        });
        
    });
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}
-(void)createNavigation{
    self.title=@"搜索";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
     self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
//    //设置导航栏文本的颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //返回
    UIButton*btnLeft=[[UIButton alloc]initWithFrame:KRect(0, 0, 20, 20)];
    [btnLeft setImage:KImage(@"返回按钮") forState:0];
    [btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*barLeft=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=barLeft;
    

}
-(void)btnLeftAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //搜索页面
    if (tableView==searchDisplay.searchResultsTableView)
    {
        return numSearch;
    }
  
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==searchDisplay.searchResultsTableView) {
        return 0.001;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==searchDisplay.searchResultsTableView) {
        return 50;
    }
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //搜索页面
    if(tableView==searchDisplay.searchResultsTableView){
        UITableViewCell*searchCell=[tableView dequeueReusableCellWithIdentifier:@"search"];
        if (searchCell==nil) {
            searchCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
        }
        searchCell.textLabel.text=[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"title"];
        searchCell.textLabel.font=[UIFont fontWithName:FONTNAME size:13];
        searchCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return searchCell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==searchDisplay.searchResultsTableView)
    {
        
       
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
