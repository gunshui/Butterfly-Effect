//
//  YYShowDetailsTableViewCell.h
//  Butterfly Effect
//
//  Created by lyan on 15/6/30.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYShowDetailsTableViewCell : UITableViewCell
@property(nonatomic,retain)UILabel*labelTitle;
@property(nonatomic,retain)UILabel*labelWriter;
@property(nonatomic,retain)UILabel*labelTime;
@property(nonatomic,retain)UIImageView*imageViewPlayNums;
@property(nonatomic,retain)UILabel*labelPlayNums;
@property(nonatomic,retain)UIImageView*imageViewCollectionNums;
@property(nonatomic,retain)UILabel*labelCollectionNums;
@property(nonatomic,retain)UIImageView*imageViewYoulikeNums;
@property(nonatomic,retain)UILabel*labelYoulikeNums;
@property(nonatomic,retain)UIImageView*imageViewCommentNums;
@property(nonatomic,retain)UILabel*labelCommentNums;
@property(nonatomic,retain)UILabel*labelDescribe;
@property(nonatomic,retain)UILabel*labels;
@end
