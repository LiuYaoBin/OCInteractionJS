//
//  ViewController.m
//  OCInteractionJS
//
//  Created by  Mr_Liu on 2016/9/26.
//  Copyright © 2016年 Mr_Liu. All rights reserved.
//

#import "ViewController.h"
#import "HtmlRequestModel.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface ViewController ()<UIWebViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    NSString *type;
    NSDictionary *parasDic;
    NSString *phoneNum;
    NSString *urlStr;
}

@property(nonatomic,strong)UIWebView *DetailWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    /*
     本demo提供OC月JS交互的一个思路；
     若想查看效果，需要与自己公司后台对接
     */
    
    /*
     self.superWebview为父类中webview公用方法的封装（根据自己需要进行封装）
     */
//    self.superWebview=self.DetailWebView;
    
    [self createUI];
    
}


-(UIWebView *)DetailWebView{
    
    if (!_DetailWebView) {
        _DetailWebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
        _DetailWebView.delegate=self;
        _DetailWebView.scalesPageToFit=YES;
    }
    return _DetailWebView;
    
}

-(void)createUI{
    
//    NSURL *webPageUrl=[Utility requestWebPageURLWithAction:[NSString stringWithFormat:@"/item/detail/%ld",(long)_itemListModel1.ItmId]];
    
    //webPageUrl为webView的地址（根据后台接口文档对接）
    NSString *urlStr1=@"";
    
    NSURL *webPageUrl=[NSURL URLWithString: urlStr1];

    [_DetailWebView loadRequest:[NSURLRequest requestWithURL:webPageUrl]];
    
    [self.view addSubview:_DetailWebView];
    
}


#pragma mark -
#pragma mark webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HtmlRequestModel webViewLoadHtml:_DetailWebView htmlReuqstUrlStr:urlStr paramStr:@"axd" isFinishedRequest:^(id valueArr) {
        NSLog(@"valueArr=%@",valueArr);
        
        type=[valueArr[0] toString];
        
        parasDic=[[NSDictionary alloc]init];
        
        JSValue *jsVal=valueArr[1];
        
        NSString *str11=[NSString stringWithFormat:@"%@",jsVal];
        
        parasDic=[self dictionaryWithJsonString:str11];//解析成字典
        
        [self chooseWhichWayToGo];//选择调用点击的哪个方法
        
        NSLog(@"-----");
        
    }];
    self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //判断是否是单击
//    if (navigationType == UIWebViewNavigationTypeLinkClicked)
//    {
//        NSURL *url = [request URL];
//        if([[UIApplication sharedApplication]canOpenURL:url])
//        {
//            [[UIApplication sharedApplication]openURL:url];
//        }
//        return NO;
//    }
    NSString *path=[[request URL] absoluteString];
    urlStr=[[request URL] parameterString];
    
    NSLog(@"webview path：%@",path);
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"test" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil]];
    
    return YES;
}

#pragma mark -
#pragma mark 根据类型进行相应的操作
-(void)chooseWhichWayToGo{
    if ([type isEqual:@"3"])
    {
        NSLog(@"结束前提醒设置-->跳原生");
//        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"RemindStoryboard" bundle:nil];
//        RemindViewController *vc=sb.instantiateInitialViewController;
//        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([type isEqual:@"4"])
    {
        phoneNum=[parasDic objectForKey:@"value"];
        NSLog(@"调起打电话：value电话号");
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:
                                @"联系客服" message:phoneNum delegate:self cancelButtonTitle:
                                @"取消" otherButtonTitles:
                                @"拨打", nil];
        alertView.delegate=self;
        alertView.tag=1001;
        [alertView show];
    }
}

#pragma mark alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1001:
            switch (buttonIndex) {
                case 1:
                    NSLog(@"dialing phone call... phone num=%@",phoneNum);
                    if (phoneNum != nil && ![phoneNum isEqualToString:@""])
                    {
                        NSString *telUrl = [NSString stringWithFormat:
                                            @"tel://%@",phoneNum];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
                        
                    }
                    else
                    {
                        NSLog(@"呼叫失败,稍后重试！");
                    }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}


-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
