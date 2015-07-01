//
//  QQMyselfTableViewCell.h
//  Butterfly Effect
//
//  Created by digime on 15/6/17.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQMyselfTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lableTitle;
@property (weak, nonatomic) IBOutlet UILabel *lableSee;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPic;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSee;

@property (weak, nonatomic) IBOutlet UILabel *labelHeart;

@property (weak, nonatomic) IBOutlet UILabel *labelCollection;

@property (weak, nonatomic) IBOutlet UILabel *labelComment;

@property (weak, nonatomic) IBOutlet UILabel *labelBrand;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width_distance;

@end
