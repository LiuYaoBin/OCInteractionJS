//
//  HtmlRequestModel.m
//  OCInteractionJS
//
//  Created by Mr_Liu on 2016/9/26.
//  Copyright © 2016年 Mr_Liu. All rights reserved.
//

#import "HtmlRequestModel.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>


@implementation HtmlRequestModel

/*
参数说明：
  webView ：要进行JS交互的网页
  urlStr ：本网页的网址url
  paramStr ： 与后台交互的标示
  finished ：block回调，成功后返回我们需要的数组valueArr
 
 */

+(void)webViewLoadHtml:(UIWebView *)webView htmlReuqstUrlStr:(NSString *)urlStr paramStr:(NSString *)paramStr isFinishedRequest:(void (^)(id))finished{
    
    JSContext *content=[webView valueForKeyPath:
                        @"documentView.webView.mainFrame.javaScriptContext"];
    
    content[paramStr]=^(){
        
        NSArray *args = [JSContext currentArguments];
        
        NSMutableArray *valueArr=[NSMutableArray new];
        
        for (JSValue *jsVal in args)
        {
            
            NSLog(@"--jsVal=%@",jsVal);
            
            [valueArr addObject:jsVal];
            
            
            @try {
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        
        if (finished)
        {
            
            finished(valueArr);
            
        }
    };
    
    
}


@end
