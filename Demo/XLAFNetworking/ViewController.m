//
//  ViewController.m
//  XLAFNetworking
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 along. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"
#import "UploadModel.h"

@interface ViewController () 
@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self normalTaskTest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)normalTaskTest {

    [[HttpClient sharedInstance] requestWithHttpRequestMode:^(HttpRequestMode *request) {
        //...
        request
        .SetName(@"普通")
        .SetUrl(@"");
        
        [request complete];
    } Success:^(HttpRequest *request, HttpResponse *response) {
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        
    } RequsetStart:nil ResponseEnd:nil];
    
    [[HttpClient sharedInstance] requestWithHttpRequestMode:^(HttpRequestMode *request) {
        //...
        request
        .SetName(@"普通")
        .SetUrl(@"");
        
        [request complete];
    } Success:^(HttpRequest *request, HttpResponse *response) {
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        
    } RequsetStart:nil ResponseEnd:nil];
    

    
}

- (void)uploadTaskTest {

    HttpRequestMode *requestMode1= [[HttpRequestMode alloc]init];
    requestMode1.SetName(@"普通").SetUrl(@"").SetIsGET(@(0)).SetParameters(@{@"":@""});
    
    NSData *data =  [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"]];


    [[HttpClient sharedInstance] uploadPhotoWithHttpRequestMode:^(HttpRequestMode *request) {
        request
        .SetName(@"上传")
        .SetUrl(@"")
        .SetHeaderValue(@{@"asd":@"sss"})
        .SetUploadModels(@[CreateUploadModel(data,@"upload",@"fileName",@"image/jpeg")]);
        
        [request complete];
    } Progress:^(HttpFileLoadProgress *uploadProgress) {
        
    } Success:^(HttpRequest *request, HttpResponse *response) {
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        
    } RequsetStart:nil ResponseEnd:nil];
    
}

- (void)downloadTaskTest {
    
    [[HttpClient sharedInstance]downloadPhotoWithHttpRequestMode:^(HttpRequestMode *request) {
        request
        .SetName(@"下载")
        .SetUrl(@"http://pic1.win4000.com/wallpaper/b/5861fa39ee373.jpg");
        
        [request complete];
    } Progress:^(HttpFileLoadProgress *uploadProgress) {
        
    } Destination:nil Success:^(HttpRequest *request, HttpResponse *response) {
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        
    } RequsetStart:nil ResponseEnd:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
