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
    [self normalTaskTest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)normalTaskTest {

    [[HttpClient sharedInstance]requestApiWithHttpRequestMode:RequestModelPOST(@"普通", @"http://localhost:8181/along/userLogin", (@{@"name":@"lixun",@"password":@"123456"})) Success:^(HttpRequest *request, HttpResponse *response) {

    } Failure:^(HttpRequest *request, HttpResponse *response) {
        
    } RequsetStart:nil ResponseEnd:nil];
    
}

- (void)uploadTaskTest {

    HttpRequestMode *requestMode1= [[HttpRequestMode alloc]init];
    requestMode1.SetName(@"普通").SetUrl(@"").SetIsGET(@(0)).SetParameters(@{@"":@""});
    
    [[HttpClient sharedInstance]requestApiWithHttpRequestMode:requestMode1 Success:^(HttpRequest *request, HttpResponse *response) {
        
        HttpRequestMode *requestMode2= [[HttpRequestMode alloc]init];
        requestMode2.SetName(@"上传获取目录").SetUrl(@"").SetIsGET(@(0)).SetParameters(@{@"":@"",@"":@"",@"":@"",@"":@"",@"":@""});
        
        [[HttpClient sharedInstance]requestApiCacheWithHttpRequestMode:requestMode2 Success:^(HttpRequest *request, HttpResponse *response) {
            
            
            HttpRequestMode *requestMode3= [[HttpRequestMode alloc]init];
            requestMode3.SetName(@"上传文件").SetUrl(@"").SetIsGET(@(0)).SetParameters(@{@"":@"",@"":self.paraString,@"":@""});
            requestMode3.uploadModels = self.photoArr;
            
            [[HttpClient sharedInstance] uploadPhotoWithHttpRequestMode:requestMode3 Progress:^(HttpFileLoadProgress *uploadProgress) {
                
            } Success:^(HttpRequest *request, HttpResponse *response) {
                
            } Failure:^(HttpRequest *request, HttpResponse *response) {
                
            } RequsetStart:nil ResponseEnd:^{
                
                [self.photoArr removeAllObjects];
                self.photoArr = nil;
            }];
            
            

        } Failure:^(HttpRequest *request, HttpResponse *response) {
            
        } RequsetStart:nil ResponseEnd:nil];
        
        
        
        
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        
    } RequsetStart:^{
        
    } ResponseEnd:^{
        
    }];

    
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
