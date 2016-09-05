//
//  ViewController.m
//  XLAFNetworking
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 along. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"


@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self normalTaskTest];
}

- (void)normalTaskTest {
    HttpRequestMode *requestMode = [[HttpRequestMode alloc]init];
//    requestMode.SetName(@"普通").SetUrl(@"asd").SetIsGET(@(0)).SetParameters(@{@"a":@"b"});
    
    
    [[HttpClient sharedInstance]requestApiWithHttpRequestMode:requestMode success:^(HttpRequest *request, HttpResponse *response) {
        
    } failure:^(HttpRequest *request, HttpResponse *response) {
        
    } requsetStart:^{
        
    } responseEnd:^{
        
    }];
}

- (void)uploadTaskTest {

    HttpRequestMode *requestMode = [HttpRequestMode new];
    requestMode.name = @"上传";
    requestMode.url = @"";
    UploadModel *model = [[UploadModel alloc]initWithUploadModelfileData:[[NSBundle mainBundle]pathForResource:@"" ofType:@""] name:@"" fileName:@"" mimeType:@""];

    requestMode.uploadModels = @[model];
    
    [[HttpClient sharedInstance]uploadPhotoWithHttpRequestMode:requestMode progress:^(HttpFileLoadProgress *uploadProgress) {
        
    } success:^(HttpRequest *request, HttpResponse *response) {
        
    } failure:^(HttpRequest *request, HttpResponse *response) {
        
    } requsetStart:^{
        
    } responseEnd:^{
        
    }];
}

- (void)downloadTaskTest {
    
    
    
    HttpRequestMode *requestMode = [HttpRequestMode new];
  
    requestMode.SetName(@"下载").SetUrl(@"asd").SetParameters(@{@"a":@"b"});
    
    [[HttpClient sharedInstance]downloadPhotoWithHttpRequestMode:requestMode progress:^(HttpFileLoadProgress *uploadProgress) {
        
    } destination:nil success:^(HttpRequest *request, HttpResponse *response) {
        
    } failure:^(HttpRequest *request, HttpResponse *response) {
        
    } requsetStart:^{
        
    } responseEnd:^{
        
    }];
  
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[HttpClient sharedInstance]checkNetworkingStatus:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
