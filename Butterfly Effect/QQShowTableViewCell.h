//
//  QQShowTableViewCell.h
//  Butterfly Effect
//
//  Created by digime on 15/6/15.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *imaeViewBK;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelDescribe;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPic;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayNums;
@property (weak, nonatomic) IBOutlet UILabel *labelCollectionNums;
@property (weak, nonatomic) IBOutlet UILabel *labelLikeNums;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentNums;

@end
