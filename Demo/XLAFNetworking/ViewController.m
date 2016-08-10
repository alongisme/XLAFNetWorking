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
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)normalTaskTest {
    //POST/GET请求 传参
    [[HttpClient sharedInstance]testApiWithnextPage:@"0" pageSize:@"10" status:@"1" sortData:@"[{property:'createTime',direction:'DESC'}]" jsonFilter:@"{}" success:^(HttpRequest *request, HttpResponse *response) {
        
    } failure:^(HttpRequest *request, HttpResponse *response) {
        
    } requsetStart:^{
        
    } responseEnd:^{
        
    }];
}

- (void)uploadTaskTest {
    //上传请求 文件模型
    UploadModel *upload = [[UploadModel alloc]initWithUploadModelfileData:[[NSBundle mainBundle]pathForResource:@"test" ofType:@".jpg"] name:@"photoFile" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
    
    [[HttpClient sharedInstance]uploadPhotoWithPhotoFile:@[upload] progress:^(HttpFileLoadProgress *uploadProgress) {
        
    } success:^(HttpRequest *request, HttpResponse *response) {
        
    } failure:^(HttpRequest *request, HttpResponse *response) {
        
    }requsetStart:^{
        
    } responseEnd:^{
        
    }];
}

- (void)downloadTaskTest {
    
    //下载请求
    [[HttpClient sharedInstance] downloadPhotoWithprogress:^(HttpFileLoadProgress *uploadProgress) {
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径 nil则默认给一个路径
        return nil;
    } success:^(HttpRequest *request, HttpResponse *response) {
        
        
    } failure:^(HttpRequest *request, HttpResponse *response) {
        
    }requsetStart:^{
        
    } responseEnd:^{
        
    } ];
    
  
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[HttpClient sharedInstance]checkNetworkingStatus:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
