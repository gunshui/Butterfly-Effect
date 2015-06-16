//
//  GetData.m
//  Digital Music
//
//  Created by digime on 14-12-11.
//  Copyright (c) 2014年 com.longjianchuanmei. All rights reserved.
//

#import "GetData.h"

@implementation GetData
@synthesize dict;

//-(NSDictionary*)createRequestWith:(NSString*)urlString Body:(NSString*)bodyStr
//{
//    
//  
//        //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]);
//        NSString*urlStr=[NSString stringWithFormat:@"%@%@",GUNSHUI,urlString];
//        NSURL*url=[NSURL URLWithString:urlStr];
//        //创建可变链接请求
//        NSMutableURLRequest*request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
//        //设置http请求方式
//        [request setHTTPMethod:@"POST"];
//        //设置http请求body
//        NSData*body=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:body];
//        NSHTTPURLResponse*response=nil;
//        NSError*error=nil;
//        NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        NSString*strData=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//       NSDictionary *dictJson=[strData objectFromJSONString];
//        NSLog(@"strData=%@",dictJson);
////      NSLog(@"nimeide====%@",[[[[[dictJson objectForKey:@"msg"] objectForKey:@"body"] objectAtIndex:0] objectForKey:@"message"] objectForKey:@"message"]);
//    
//        
//    return dictJson;
//    
//}
+(GetData *)getdataWithUrl:(NSString *)urlString Body:(NSString *)bodyStr{
    GetData*getdata=[[GetData alloc]init];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ID"]);
        NSString*urlStr=[NSString stringWithFormat:@"%@%@",GUNSHUI,urlString];
        NSURL*url=[NSURL URLWithString:urlStr];
        //创建可变链接请求
        NSMutableURLRequest*request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        //设置http请求方式
        [request setHTTPMethod:@"POST"];
        //设置http请求body
        NSData*body=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
        NSHTTPURLResponse*response=nil;
        NSError*error=nil;
        NSData*data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString*strData=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dictJson=[strData objectFromJSONString];
//        NSLog(@"strData=%@",dictJson);
        //      NSLog(@"nimeide====%@",[[[[[dictJson objectForKey:@"msg"] objectForKey:@"body"] objectAtIndex:0] objectForKey:@"message"] objectForKey:@"message"]);
        getdata.dict=dictJson;
//    });
   
    
    return getdata;
}
@end
