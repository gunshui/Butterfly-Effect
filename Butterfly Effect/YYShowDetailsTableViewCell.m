//  YYShowDetailsTableViewCell.m
//  Butterfly Effect
//
//  Created by lyan on 15/6/30.
//  Copyright (c) 2015年 digime. All rights reserved.
//

#import "YYShowDetailsTableViewCell.h"

@implementation YYShowDetailsTableViewCell
@synthesize labelDescribe,labelYoulikeNums,labelCollectionNums,labelCommentNums,labelPlayNums,labels,labelTime,labelTitle,labelWriter,imageViewYoulikeNums,imageViewCollectionNums,imageViewCommentNums,imageViewPlayNums;
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
        //标题
        labelTitle=[[UILabel alloc]init];
        labelTitle.frame=CGRectMake(20, 10, SCREEN_W-40, 20);
        [self.contentView addSubview:labelTitle];
        
        //作者
        labelWriter=[[UILabel alloc]init];
        labelWriter.frame=CGRectMake(20, CGRectGetMaxY(labelTitle.frame), 50, 15);
        [self.contentView addSubview:labelWriter];
        
        //发表时间
        labelTime=[[UILabel alloc]init];
        labelTime.frame=CGRectMake(CGRectGetMaxX(labelWriter.frame), CGRectGetMaxY(labelTitle.frame), 100, 15);
        [self.contentView addSubview:labelTime];
        
        //播放数
        imageViewPlayNums=[[UIImageView alloc]init];
        imageViewPlayNums.frame=CGRectMake(20, CGRectGetMaxY(labelWriter.frame), 15, 15);
        imageViewPlayNums.image=KImage(@"收看数");
        [self.contentView addSubview:imageViewPlayNums];
        
        labelPlayNums=[[UILabel alloc]init];
        labelPlayNums.frame=CGRectMake(CGRectGetMaxX(imageViewPlayNums.frame), CGRectGetMaxY(labelWriter.frame), 25, 15);
        [self.contentView addSubview:labelPlayNums];
        
        //收藏数
        imageViewCollectionNums=[[UIImageView alloc]init];
        imageViewCollectionNums.frame=CGRectMake(CGRectGetMaxX(labelPlayNums.frame), CGRectGetMaxY(labelWriter.frame), 15, 15);
        imageViewCollectionNums.image=KImage(@"喜欢数");
        [self.contentView addSubview:imageViewCollectionNums];
        
        labelCollectionNums=[[UILabel alloc]init];
        labelCollectionNums.frame=CGRectMake(CGRectGetMaxX(imageViewCollectionNums.frame), CGRectGetMaxY(labelWriter.frame), 25, 15);
        [self.contentView addSubview:labelCollectionNums];
        
        //喜欢数
        imageViewYoulikeNums=[[UIImageView alloc]init];
        imageViewYoulikeNums.frame=CGRectMake(CGRectGetMaxX(labelCollectionNums.frame), CGRectGetMaxY(labelWriter.frame), 15, 15);
        imageViewYoulikeNums.image=KImage(@"收藏数");
        [self.contentView addSubview:imageViewYoulikeNums];
        
        labelYoulikeNums=[[UILabel alloc]init];
        labelYoulikeNums.frame=CGRectMake(CGRectGetMaxX(imageViewYoulikeNums.frame), CGRectGetMaxY(labelWriter.frame), 25, 15);
        [self.contentView addSubview:labelYoulikeNums];
        
        //评论数
        imageViewCommentNums=[[UIImageView alloc]init];
        imageViewCommentNums.frame=CGRectMake(CGRectGetMaxX(labelYoulikeNums.frame), CGRectGetMaxY(labelWriter.frame), 15, 15);
        imageViewCommentNums.image=KImage(@"评论数");
        [self.contentView addSubview:imageViewCommentNums];
        
        labelCommentNums=[[UILabel alloc]init];
        labelCommentNums.frame=CGRectMake(CGRectGetMaxX(imageViewCommentNums.frame), CGRectGetMaxY(labelWriter.frame), 25, 15);
        [self.contentView addSubview:labelCommentNums];
        
        //视频描述
        labels=[[UILabel alloc]init];
        labels.frame=CGRectMake(20, CGRectGetMaxY(imageViewPlayNums.frame)+10, 50, 15);
        labels.text=@"视频描述:";
        labelDescribe.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:labels];
        
        //视频描述内容
        labelDescribe=[[UILabel alloc]init];
        labelDescribe.frame=CGRectMake(20, CGRectGetMaxY(labels.frame), SCREEN_W-40, 15);
        [self.contentView addSubview:labelDescribe];
    }
    return self;
}

@end
