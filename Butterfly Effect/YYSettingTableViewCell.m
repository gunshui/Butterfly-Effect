//
//  QQFindTableViewCell.m
//  Gunshui
//
//  Created by digime on 15-3-11.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYSettingTableViewCell.h"

@implementation YYSettingTableViewCell
@synthesize imageViewPic,lableClass;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        //图片
//        imageViewPic=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 28, 28)];
//        [self.contentView addSubview:imageViewPic];
        
        lableClass=[[UILabel alloc]initWithFrame:CGRectMake(13, 10, 150, 30)];
        //类型
        lableClass.textAlignment=NSTextAlignmentLeft;
        lableClass.textColor=[UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1];
        lableClass.font=[UIFont fontWithName:FONTNAME3 size:16];
        [self.contentView addSubview:lableClass];
    }
    return self;
}
@end
