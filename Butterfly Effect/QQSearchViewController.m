//
//  QQSearchViewController.m
//  Butterfly Effect
//
//  Created by digime on 15/6/19.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "QQSearchViewController.h"
#import "YYShowDetailsViewController.h"
#import "YYBrandContentViewController.h"
#import "QQSearchTableViewCell.h"
#import "QQSearchDetailController.h"

@interface QQSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>

{
    UISearchBar*aSearchBar;
    UISearchDisplayController*searchDisplay;
    NSDictionary*dictSearch;
    int numSearch;
    NSDictionary*dict;
}
@property (weak, nonatomic) IBOutlet UITableView *tableviewSearch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicators;

@end

@implementation QQSearchViewController
@synthesize tableviewSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableviewSearch.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableviewSearch.backgroundColor=[UIColor whiteColor];
    //导航栏
    [self createNavigation];
    
    //搜索栏
    [self createSearch];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self createRequest];
    
    //加载中
    [self createActivity];
    
}

-(void)createActivity{
    _indicators.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
}

-(void)createRequest{
    
    [_indicators startAnimating];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        GetData*getData=[GetData getdataWithUrl:@"/search/list.php" Body:@"action=v1&page=1&maxsize=10&sort="];
        NSLog(@"searchs-----%@",getData.dict);
        dict=getData.dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableviewSearch reloadData];
            [_indicators stopAnimating];
            _indicators.hidden=YES;
        });
        
    });
    
}

-(void)createSearch{
    aSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    aSearchBar.placeholder=@"请输入关键字";
    //拿到textField
    UITextField*textField=[[[[aSearchBar subviews]objectAtIndex:0] subviews] lastObject];
    NSMutableAttributedString*attStr=[[NSMutableAttributedString alloc]initWithString:@"请输入关键字" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:14]}];
    textField.attributedPlaceholder=attStr;
    tableviewSearch.tableHeaderView=aSearchBar;
    tableviewSearch.sectionHeaderHeight=100;
    
    aSearchBar.delegate=self;
    searchDisplay=[[UISearchDisplayController alloc]initWithSearchBar:aSearchBar contentsController:self];
    searchDisplay.searchResultsDataSource=self;
    searchDisplay.searchResultsDelegate=self;
    searchDisplay.searchResultsTableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);

    UILabel*hotLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 30)];
//    hotLable.textColor=[UIColor colorWithRed:88.0/255.0 green:85.0/255.0 blue:182.0/255.0 alpha:1];
    hotLable.textColor=[UIColor grayColor];
    hotLable.text=@"热门搜索:";
    hotLable.font=[UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:15];
    [tableviewSearch addSubview:hotLable];

}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [aSearchBar setHidden:NO];
    searchBar.showsCancelButton=YES;
    for (id aa in [aSearchBar subviews])
    {
        for (id bb in [aa subviews])
        {
            if ([bb isKindOfClass:[UIButton class]])
            {
                UIButton*cancer=(UIButton*)bb;
                [cancer setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString*strBody=[NSString stringWithFormat:@"action=v2&maxsize=10&page=1&keyword=%@&classid=",searchBar.text];
        GetData*getData=[GetData getdataWithUrl:@"/document/list_search.php" Body:strBody];
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
    if ([[dict objectForKey:@"status"] isEqualToString:@"ok"]) {
        return [[dict objectForKey:@"msg"] count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==searchDisplay.searchResultsTableView) {
        return 0.001;
    }
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==searchDisplay.searchResultsTableView) {
        return 50;
    }
    return 42;
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
    
    
    NSString*identifier=@"search";
    QQSearchTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"QQSearchTableViewCell" owner:self options:nil] lastObject];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.labelTitle.text=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"keyword"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==searchDisplay.searchResultsTableView)
    {
        if ([[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"class"] isEqualToString:@"5"]) {
            YYShowDetailsViewController*showDetails=[[YYShowDetailsViewController alloc]init];
            [self.navigationController pushViewController:showDetails animated:YES];
            showDetails.strID=[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"];
            showDetails.typeID=[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"typeid"];
            
        }else{
            YYBrandContentViewController*brandContent=[[YYBrandContentViewController alloc]init];
            [self.navigationController pushViewController:brandContent animated:YES];
            brandContent.strID=[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"id"];
            brandContent.strTitles=[[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"productInfo"] objectForKey:@"typename"];
        }
    }
    
    if (tableView==tableviewSearch) {
        QQSearchDetailController*detail=[[QQSearchDetailController alloc]init];
        detail.keyword=[[[dict objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"keyword"];
        
        [self.navigationController pushViewController:detail animated:YES];
        
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
