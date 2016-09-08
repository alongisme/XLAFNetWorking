//
//  ViewController.m
//  XLAFNetworking
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 along. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"


@interface ViewController () {
    UITextView *textView;
}

@end

@implementation ViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self normalTaskTest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    textView = [[UITextView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:textView];
    [self normalTaskTest];
}

- (void)normalTaskTest {
    HttpRequestMode *requestMode = [[HttpRequestMode alloc]init];
    requestMode.SetName(@"普通").SetUrl(@"http://test.3tichina.com:8023/aiya/m/patient/findPatientList").SetIsGET(@(0)).SetParameters(@{@"nextPage":@"0",@"pageSize":@"10",@"status":@"1",@"sortData":@"",@"jsonFilter":@"{}"});
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
