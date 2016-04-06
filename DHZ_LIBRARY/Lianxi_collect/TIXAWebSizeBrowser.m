//
//  TIXAWebSizeBrowser.m
//  Lianxi
//
//  Created by tixa tixa on 12-12-19.
//  Copyright (c) 2012年 TIXA. All rights reserved.
//

#import "TIXAWebSizeBrowser.h"
#import "TIXAMediaPicker.h"
#import "PublishAllViewController.h"
#import "UIView+TIXACategory.h"
#import "PkPublishViewController.h"
#import "TIXABarButtonItem.h"


@interface TIXAWebSizeBrowser () <TIXAMediaPickerDelegate>
{
    UIToolbar               *_footToolBar;//底部工具栏
//    UIView                  *_fullscreenFootView;//全屏底部工具栏
    
    UIBarButtonItem         *_forwardItem; //向前
    UIBarButtonItem         *_backItem; //向后
    
    TIXAMediaPicker         *_mediaPicker;
    UIButton                *_footCloseButton;
    UIButton                *_footQuitButton;
    
    NSMutableArray *requestURLArray;//保存申请页面的网址
    
    
    NSString* h5URL;//1月21日添加，用于捕获h5app点击事件的功能
    NSMutableArray* parameterArray;//保存页面URL所需要的参数
    NSString* callbackUrl;//请求apptoken后参数中的请求url
    UIWebView* currentWebView;
}
@end

@implementation TIXAWebSizeBrowser

- (id)initWithURLPath:(NSString *)urlPath
{
    self = [super initWithURLPath:urlPath];
    if (self) {
        // Custom initialization
        self.title = @"浏览";
        requestURLArray = [NSMutableArray array];
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    self.navigationController.navigationBarHidden = YES;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
	// Do any additional setup after loading the view.
    _mediaPicker = [[TIXAMediaPicker alloc] init];
    _mediaPicker.delegate = self;
    
    //[self createFootToolBar]; //底部工具条
    [self addRightNavigationBarItem];
    
}

- (void)addRightNavigationBarItem
{
    TIXABarButtonItem *rightBarButtonItem = [[TIXABarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_item_more"]
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(more)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"brower_more"] style:UIBarButtonItemStyleDone target:self action:@selector(more)];
}

- (void)forward
{
    if (_contentWebView.canGoForward) {
        [_contentWebView goForward];
        _forwardItem.enabled = YES;
    }else {
        _forwardItem.enabled = NO;
    }
}

- (void)goBack
{
//    //获取当前WebView的URL
//    NSString *currentURL = [_contentWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//
//    if (requestURLArray.count > 0) {
//        if ([requestURLArray[0] isEqualToString:currentURL] || requestURLArray.count == 0 || [currentURL isEqualToString:@""]) {
//            [self quit];
//        } else {
//            if (requestURLArray.count > 1) {
//                [requestURLArray removeLastObject];
//            }
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestURLArray[requestURLArray.count-1]]];
//                [_contentWebView loadRequest:request];
//            });
//            [self quit];
//        }
//    } else if (requestURLArray.count == 0) {
//        [self quit];
//    }

    if (_contentWebView.canGoBack) {
        [_contentWebView goBack];
    } else {
        [self quit];
    }
}

- (void)quit
{
//    [self dismissViewControllerAnimated:YES compatibleCompletion:nil];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES];
    }
    
}

//全屏
- (void)enterFullscreen
{
    [UIView animateWithDuration:0.2 animations:^{
        float off = 20.0;
        float height = 44;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            off = 0.0;
            height = 64;
        }
        _isFullScreen = YES;
        //        _loadingView.transform = CGAffineTransformMakeTranslation(0.0, height);
        //        self.navigationBar.transform = CGAffineTransformMakeTranslation(0.0, -self.navigationBar.frame.size.height);
        self.navigationController.navigationBarHidden = YES;
        _contentWebView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
        _footToolBar.transform = CGAffineTransformMakeTranslation(0.0, _footToolBar.frame.size.height + height + off);
        _footCloseButton.transform = CGAffineTransformMakeTranslation(0.0, height);
        _footQuitButton.transform = CGAffineTransformMakeTranslation(0.0, height);
        //        _fullscreenFootView.hidden = NO;
    }];
}

//退出全屏
- (void)quitFullscreen
{
    [UIView animateWithDuration:0.2 animations:^{
        _loadingView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        _isFullScreen = NO;
        self.navigationBar.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        self.navigationController.navigationBarHidden = NO;
        _footToolBar.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
//        _fullscreenFootView.hidden = YES;
    }];
}

- (void)changeTool
{
    if (_contentWebView.canGoForward) {
        _forwardItem.enabled = YES;
    }else {
        _forwardItem.enabled = NO;
    }
    if (_contentWebView.canGoBack) {
        _backItem.enabled = YES;
    }else {
        _backItem.enabled = NO;
    }
}


/*****************************
 webView delegate
 *****************************/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL = request.URL;
    h5URL = request.URL.absoluteString;
    currentWebView = webView;
#if 0
    //1月21日增加，截获js页面点击事件
    NSArray* paraItemArray = [self achieveParameterWithH5URL:h5URL];
    NSLog(@"element string %@",paraItemArray);
    if (paraItemArray.count >= 2)
    {
        parameterArray = [[NSMutableArray alloc] init];
        for (int i=0; i<paraItemArray.count; i++)
        {
            NSString* item = paraItemArray[i];
            NSString* parameter = [item componentsSeparatedByString:@"="].lastObject;
            [parameterArray addObject:parameter];
        }
        [self captureH5EventActionName:parameterArray[0] callbackInfo:parameterArray[1]];
    }
    else
    {
        NSLog(@"JS传输参数格式错误！");
    }
#else
    //注入JS的代码
    [self infuseJScriptAndTakeAbsoluteString];
    
#endif
    if ([requestURL.scheme isEqualToString:@"lianxi"]) {
        NSString *founcName = [requestURL host];
        if ([founcName isEqualToString:@"enter.showContact"]) {
            NSString *spaceID = [requestURL.queryDictionary valueForKey:@"spaceId"];
            NSString *accountID = [requestURL.queryDictionary valueForKey:@"accountId"];
            [[ViewManager defaultManager] showContactBeforeDetailViewForHeadwithSpaceID:spaceID andContactID:accountID];
        }
        return NO;
    }
	if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {//截获链接点击事件
//        NSString *url = request.URL.absoluteString;
        NSURL *currentURL = request.URL;
        NSString *api = currentURL.path;
//        NSLog(@"----URL---%@",api);
        NSString *path = [api componentsSeparatedByString:@"/"].lastObject;
        NSDictionary *queryDictionary = currentURL.queryDictionary; //参数字典
        
        if ([path isEqualToString:@"enter.exit"]) {
            [self dismissViewControllerAnimated:YES compatibleCompletion:nil];
            return NO;
        } else if ([path isEqualToString:@"enter.cameraAndAlbum"]) {
            [_mediaPicker pickImage];
            return NO;
        } else if ([path isEqualToString:@"enter.camera"]) {
            [_mediaPicker pickImageFromCamera];
            return NO;
        } else if ([path isEqualToString:@"enter.album"]) {
            [_mediaPicker pickImageFromAlbum];
            return NO;
        } else if ([path isEqualToString:@"enter.chatShow.jsp"]) { //聊天
            NSString *accountId = [queryDictionary integerStringForKey:@"aid"];
            if (accountId.intValue != 0) {
                [[ViewManager defaultManager] showChatDetailViewWithSpaceID:[NSString stringWithFormat:@"%d", SpaceIdentifierDirect]
                                                                       type:LXChatTypeNormal
                                                                     dataID:accountId];
            }
            return NO;
        } else if ([path isEqualToString:@"enter.share"]) { //分享PK结果
            //截图
            UIImage *image = (UIImage *)[self.view screenshot];
            PkPublishViewController *pub = [[PkPublishViewController alloc] init];
            pub.imageArray = @[image];
            pub.showShareFunction = YES;
            [self.topViewController presentViewController:pub
                                     modalTransitionStyle:UIModalTransitionStyleCoverVertical
                                           wrapNavigation:YES
                                                 animated:YES
                                     compatibleCompletion:nil];
            return NO;
        } else if ([path isEqualToString:@"enter.alert.jsp"]) { //提示框
            NSString *title = [queryDictionary safeStringForKey:@"title"];
            NSString *message = [queryDictionary safeStringForKey:@"message"];
            [TIXAAlertView showAlertViewWithTitle:title message:message cancelButtonTitle:@"确定"];
            return NO;
        }
	}
    BOOL value = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
	return value;
}
- (void)infuseJScriptAndTakeAbsoluteString
{
    //getToken
    [currentWebView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');\
     script.text = 'var lxjs = {};' +\
     'lxjs.test = function(){' +\
     'alert(1)' +\
     '};' +\
     'lxjs.getToken = function(){' +\
     'alert(arguments[0]);' +\
     'alert(arguments[1]);' +\
     'alert(arguments[2]);' +\
     'window.location.href=\"?url=\"+arguments[0]+\"&params=\"+arguments[1]+\"&callback=\"+arguments[2];' +\
     '}';\
     document.querySelector('head').appendChild(script);"];
    
    NSLog(@"我是否可以监听到url的变化？%@",h5URL);
}

- (NSArray *)achieveParameterWithH5URL:(NSString *)h5url
{
    NSString* parameterSet = [h5url componentsSeparatedByString:@"?"].lastObject;
    NSArray* resultArray = [parameterSet componentsSeparatedByString:@"&"];
    return resultArray;
}


- (void)captureH5EventActionName:(NSString *)action callbackInfo:(NSString *)info
{
    NSLog(@"action=%@,callback=%@",action,info);
    
    if ([action isEqualToString:@"dataPicker"])
    {
        [[WebAppManager defaultManager] queryDateInfoSuccess:^(NSString *dateString) {
            
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            [dic setValue:@"123" forKey:@"horoscope"];
            [dic setValue:@"8888" forKey:@"birthday"];
            
            
            NSString* jsonback = [dic JSONRepresentation];
//            NSData* json_data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//            NSString* jsonback = [[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"jsonback %@",jsonback);
            
            NSString *action = [NSString stringWithFormat:@"%@('%@')", parameterArray[1],jsonback];
            [currentWebView stringByEvaluatingJavaScriptFromString:action];
            
            
        } failure:^(NSString *error) {
            
        }];
    }
    else if ([action isEqualToString:@"cityList"])
    {
        [[WebAppManager defaultManager] queryCityInfoSuccess:^(NSString *cityName, NSString *cityCode) {
            
        } failure:^(NSString *error) {
            
        }];
    }
    else if ([action isEqualToString:@"occupationList"])
    {
        [[WebAppManager defaultManager] queryIndustryInfoSuccess:^(NSString *cityName, NSString *cityCode) {
            
        } failure:^(NSString *error) {
            
        }];
    }
    else if ([action isEqualToString:@"getLocation"])
    {
        [[WebAppManager defaultManager] queryLocationInfoSuccess:^(NSString *address, double lat, double lng) {
            
            NSLog(@"address %@,lat %lf,lng %lf",address,lat,lng);
            
        } failure:^(NSString *error) {
            
            NSLog(@"定位失败！");
            
        }];
    }
    else if ([action isEqualToString:@"personalPage"])
    {
        //这里的ID？
        [[WebAppManager defaultManager] showContactDetailWithSpaceID:self.spaceID andContactID:parameterArray[2]];
    }
    else if ([action isEqualToString:@"goBackApp"])
    {
        [self goBack];
    }
    else if ([action isEqualToString:@"getToken"])
    {
        //callbackUrl = parameterArray[2];
        
        [[WebAppManager defaultManager] queryAppToken:self.spaceID andAppType:parameterArray[3] success:^(NSString *appToken) {
            
            
        } failure:^(NSString* error) {
            
        }];
    }
    else if ([action isEqualToString:@"request"])
    {
        
        [[WebAppManager defaultManager] doRequestWithUrlString:nil success:^(NSString *resultString) {
            
        } failure:^(NSString *error) {
            
        }];
    }
    else
    {
        
    }
}

- (void)createFootToolBar
{
    float height = 20.0;
    float tabHeight = 44.0;
    if (self.systemVersion >= 7.0) {
        height = 0.0;
        tabHeight = 64.0;
    }
    
    _footToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _mainRect.size.height - height - 44 - tabHeight, _mainRect.size.width, 44)];
    UIImage *backImage = [UIImage imageNamed:@"brower_previous"];
    UIImage *forwardImage = [UIImage imageNamed:@"brower_next"];
    UIImage *refreshImage = [UIImage imageNamed:@"brower_refresh"];
    UIImage *moreImage = [UIImage imageNamed:@"brower_more"];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:backImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [[UIButton alloc] init];
    [button setImage:forwardImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
    [button addTarget:self action:@selector(forward) forControlEvents:UIControlEventTouchUpInside];
    _forwardItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    button = [[UIButton alloc] init];
    [button setImage:refreshImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
    [button addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    //UIBarButtonItem *collectItem=[[UIBarButtonItem alloc] initWithImage:collectImage style:UIBarButtonItemStylePlain target:self action:@selector(collect)];
    
    
    button = [[UIButton alloc] init];
    [button setImage:moreImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
    [button addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
    NSArray *tabToolBarItemArray = [[NSArray alloc] initWithObjects: _backItem,spaceItem, _forwardItem, spaceItem,refreshItem,spaceItem,moreItem,nil];
    [_footToolBar setItems:tabToolBarItemArray];
    
    
    _footCloseButton=[[UIButton alloc] initWithFrame:CGRectMake(10, _mainRect.size.height - 40 - tabHeight, 30, 30)];
    [_footCloseButton setBackgroundImage:[UIImage imageNamed:@"brower_return.png"] forState:UIControlStateNormal];
    [_footCloseButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    
    _footQuitButton=[[UIButton alloc] initWithFrame:CGRectMake(280, _mainRect.size.height - 40 - tabHeight, 30, 30)];
    [_footQuitButton setBackgroundImage:[UIImage imageNamed:@"brower_fullscreen.png"] forState:UIControlStateNormal];
    [_footQuitButton addTarget:self action:@selector(quitFullscreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footCloseButton];
    [self.view addSubview:_footQuitButton];
    
    [self.view addSubview:_footToolBar];
    [self changeTool];
}


#pragma mark - TIXAMediaPicker Delegate

- (void)mediaPicker:(TIXAMediaPicker *)picker didFinishPickingImageWithData:(NSData *)imageData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:imageData];
    [self showLoadingView];
    
    TIXAWebSizeBrowser * __weak weakSelf = self;
    __block UIWebView * __weak weakWeb = _contentWebView;
    [[RequestCenter defaultCenter] uploadImageDatas:array mediaType:TIXAMediaTypeImage finish:^(NSString *path, NSArray *failImages, NSString *errorDescription) {
        NSString *action = [NSString stringWithFormat:@"postPhotoUrl('%@');", path];
        [weakWeb stringByEvaluatingJavaScriptFromString:action];
        [weakSelf hideLoadingView];
    }];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView//加载完成
//{
//    [super webViewDidFinishLoad:webView];
//    [self changeTool];
//}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"%s------->%@",__FUNCTION__,currentURL);
    if (![currentURL isEqualToString:[requestURLArray lastObject]]) {
        [requestURLArray addObject:currentURL];
    }
    if (_contentWebView.canGoBack) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        closeButton.frame = CGRectMake(0, 0, 44, 44);
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        closeButton.titleLabel.text = @"关闭";
        [closeButton setTitle:closeButton.titleLabel.text forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        [self setLeftBarButtonItems:@[[self defaultBackBarButtonItemWithTarget:self action:@selector(goBack)], close]];
    }

    //NSLog(@"%@",requestURLArray);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error//加载出错
{
    [super webView:webView didFailLoadWithError:error];
    //[self changeTool];
    
}

/***************
 scrollView delegate
 ***************/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //[self enterFullscreen];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y > 0) {
//        [self enterFullscreen];
//    } else {
//        [self quitFullscreen];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _forwardItem = nil;
    _backItem = nil;
    _footToolBar = nil;
//    _fullscreenFootView = nil;
}

@end
