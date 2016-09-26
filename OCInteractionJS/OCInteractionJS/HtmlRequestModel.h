//
//  HtmlRequestModel.h
//  LoveStore
//
//  Created by Mr_Liu on 2016/9/26.
//  Copyright © 2016年 Mr_Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HtmlRequestModel : NSObject

+(void)webViewLoadHtml:(UIWebView *)webView
                htmlReuqstUrlStr:(NSString *)urlStr
                        paramStr:(NSString *)paramStr
               isFinishedRequest:(void (^) (id data))finished;

@end
