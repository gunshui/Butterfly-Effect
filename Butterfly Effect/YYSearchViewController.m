//
//  YYSearchViewController.m
//  Butterfly Effect
//
//  Created by lyan on 15/6/18.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYSearchViewController.h"

@interface YYSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchBar*_searchBars;
    UISearchDisplayController*_searchDisplay;
    NSDictionary*dictHot;
    NSDictionary*dictSearch;
    int numSearch;
    int maxSize;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearch;
@end

@implementation YYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=[UIColor redColor];
    
    maxSize=20;
    
    //导航栏
    [self createNavigation];
    
    //返回--导航栏按钮
    [self createLeftBar_Back];
    
    [self createTableView];
    
    [self createRequestHot];
}

-(void)createRequestHot{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        GetData*getData=[GetData getdataWithUrl:@"/document/list.php" Body:@"action=v1&page=1&maxsize=10&typeid=72&sort=time&isTop=yes"];
        NSLog(@"hot---%@",getData.dict);
        dictHot=getData.dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableViewSearch reloadData];
            
        });
    });
}

-(void)createLeftBar_Back{
    //返回
    UIButton*backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:0];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*bar=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=bar;
}

-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createNavigation{
    self.title=@"搜索";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONTNAME3 size:19]};
}

-(void)createTableView{
    _tableViewSearch.delegate=self;
    _tableViewSearch.dataSource=self;
    _tableViewSearch.backgroundColor=[UIColor blueColor];
    _tableViewSearch.showsVerticalScrollIndicator=NO;
    
    _searchBars=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, _tableViewSearch.frame.size.width, 44)];
    _searchBars.placeholder=@"请输入要搜索的内容";
    //拿到textField
    UITextField*textField=[[[[_searchBars subviews] objectAtIndex:0] subviews] lastObject];
    NSMutableAttributedString*attStr=[[NSMutableAttributedString alloc]initWithString:@"请输入要搜索的内容" attributes:@{NSFontAttributeName:[UIFont fontWithName:FONTNAME size:14]}];
    textField.attributedPlaceholder=attStr;
    
    _tableViewSearch.tableHeaderView=_searchBars;
    
    _searchBars.delegate=self;
    _searchDisplay=[[UISearchDisplayController alloc]initWithSearchBar:_searchBars contentsController:self];
    _searchDisplay.delegate=self;
    _searchDisplay.searchResultsDataSource=self;
    _searchDisplay.searchResultsDelegate=self;
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"------%@",searchBar.text);
        NSString*strBody=[NSString stringWithFormat:@"action=v2&maxsize=%d&page=1&keyword=%@&classid=0",maxSize,searchBar.text];
        GetData*getData=[GetData getdataWithUrl:@"/document/list_search.php" Body:strBody];
        NSLog(@"search====%@",getData.dict);
        dictSearch=getData.dict;
        if ([[dictSearch objectForKey:@"status"]isEqualToString:@"ok"]) {
            numSearch=(int)[[dictSearch objectForKey:@"msg"] count];
        }else{
            numSearch=0;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_searchDisplay.searchResultsTableView reloadData];
        });
    });
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [_searchBars setHidden:NO];
    NSLog(@"begin");
    searchBar.showsCancelButton=YES;
    for (id aa in [_searchBars subviews])
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (tableView==_searchDisplay.searchResultsTableView) {
//        return 70;
//    }
//    if (SCREEN_W>320) {
//        return 78;
//    }else{
//        return 0;
//    }
    return 0;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView==_searchDisplay.searchResultsTableView) {
//        return 50;
//    }
//    if (SCREEN_W>320) {
//        return 35;
//    }else{
//        return 32;
//    }
//    return 0;
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_searchDisplay.searchResultsTableView)
    {
        return numSearch;
    }
    if ([[dictHot objectForKey:@"status"]isEqualToString:@"ok"]) {
        return [[dictHot objectForKey:@"msg"] count];
    }else{
        return 0;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==_searchDisplay.searchResultsTableView){
        UITableViewCell*searchCell=[tableView dequeueReusableCellWithIdentifier:@"search"];
        if (searchCell==nil) {
            searchCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
        }
        searchCell.textLabel.text=[[[dictSearch objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"title"];
        searchCell.textLabel.font=[UIFont fontWithName:FONTNAME size:13];
        
        searchCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return searchCell;
    }
    
    static NSString*ident=@"CELL";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.textLabel.text=[[[dictHot objectForKey:@"msg"] objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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
