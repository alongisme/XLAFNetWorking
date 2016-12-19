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
@property (nonatomic,strong) NSMutableArray *photoArr;
@property (nonatomic,strong) NSMutableString *paraString;

@end

@implementation ViewController

- (NSMutableArray *)photoArr {
    if(_photoArr == nil) {
        _photoArr = [NSMutableArray array];
        
        for (unsigned int i = 0; i < 50; i++) {
            UploadModel *model = [[UploadModel alloc]initWithUploadModelFileData:[[NSBundle mainBundle]pathForResource:@"test.jpg" ofType:@""] Name:@"photoFile" FileName:@"filename.jpg" MimeType:@"image/jpeg"];
            [_photoArr addObject:model];
        }
        
    }
    return _photoArr;
}

- (NSMutableString *)paraString {
    if(_paraString == nil) {
        _paraString = [[NSMutableString alloc]init];
        for (unsigned int i = 0; i < 50; i++) {
            if(i != 49) {
                [_paraString appendString:[NSString stringWithFormat:@"%dfdgdfg",i]];
                [_paraString appendString:@","];
            }else {
                [_paraString appendString:[NSString stringWithFormat:@"%dfdgdfg",i]];
            }
        }
    }
    return _paraString;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self uploadTaskTest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)normalTaskTest {

    [[HttpClient sharedInstance]requestApiCacheWithHttpRequestMode:RequestModelPOST(@"普通", @"http://localhost:8181/along/userLogin", (@{@"name":@"lixun",@"password":@"123456"})) Success:^(HttpRequest *request, HttpResponse *response) {
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        
    } RequsetStart:nil ResponseEnd:nil];
    
}

- (void)uploadTaskTest {

    HttpRequestMode *requestMode1= [[HttpRequestMode alloc]init];
    requestMode1.SetName(@"普通").SetUrl(@"").SetIsGET(@(0)).SetParameters(@{@"":@""});
    
    NSData *data =  [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"]];

    [[HttpClient sharedInstance]uploadPhotoWithHttpRequestMode:RequestModelFilePOST(@"上传", @"http://localhost:8181/along/upload", nil, @[CreateUploadModel(data,@"上传",@"fileName",@"image/jpeg")]) Progress:^(HttpFileLoadProgress *uploadProgress) {
        
    } Success:^(HttpRequest *request, HttpResponse *response) {
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        
    } RequsetStart:nil ResponseEnd:nil];

    
}

- (void)downloadTaskTest {
    
    HttpRequestMode *requestMode = [HttpRequestMode new];
  
    requestMode.SetName(@"下载").SetUrl(@"asd").SetParameters(@{@"a":@"b"});
    
    [[HttpClient sharedInstance]downloadPhotoWithHttpRequestMode:requestMode Progress:^(HttpFileLoadProgress *uploadProgress) {
        
    } Destination:nil Success:^(HttpRequest *request, HttpResponse *response) {
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        
    } RequsetStart:^{
        
    } ResponseEnd:^{
        
    }];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
