//
//  GetData.h
//  Digital Music
//
//  Created by digime on 14-12-11.
//  Copyright (c) 2014年 com.longjianchuanmei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetData : NSObject
@property(nonatomic,retain)NSDictionary*dict;
+(GetData*)getdataWithUrl:(NSString*)urlString Body:(NSString*)bodyStr;
+(GetData *)getdataWithGUNSHUIUrl:(NSString *)urlString Body:(NSString *)bodyStr;
@end
