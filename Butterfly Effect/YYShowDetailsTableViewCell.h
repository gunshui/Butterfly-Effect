//
//  YYShowDetailsTableViewCell.h
//  Butterfly Effect
//
//  Created by lyan on 15/6/19.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYShowDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelWriter;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayNums;
@property (weak, nonatomic) IBOutlet UILabel *labelCollectionNums;
@property (weak, nonatomic) IBOutlet UILabel *labelYoulikeNums;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentNums;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescribe;



@end
