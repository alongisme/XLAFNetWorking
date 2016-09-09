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
            UploadModel *model = [[UploadModel alloc]initWithUploadModelfileData:[[NSBundle mainBundle]pathForResource:@"test.jpg" ofType:@""] name:@"photoFile" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
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
//    [self uploadTaskTest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    HttpRequestMode *requestMode1= [[HttpRequestMode alloc]init];
    requestMode1.SetName(@"普通").SetUrl(@"http://test.3tichina.com:8023/aiya/m/picPath/findFirstLevelPicPathByUserId").SetIsGET(@(0)).SetParameters(@{@"userId":@"459"});
    
    [[HttpClient sharedInstance]requestApiWithHttpRequestMode:requestMode1 success:^(HttpRequest *request, HttpResponse *response) {
        
        NSArray *arr = [response.result objectForKey:@"object"];
        
        HttpRequestMode *requestMode2= [[HttpRequestMode alloc]init];
        requestMode2.SetName(@"上传获取目录").SetUrl(@"http://test.3tichina.com:8023/aiya/m/pics/getPicGroupForUpload").SetIsGET(@(0)).SetParameters(@{@"parentPicPathId":@"601",@"userId":@"459",@"patientId":@"1220",@"picCategory":@"0",@"groupName":@"aasdasd"});
        
        
        [[HttpClient sharedInstance]requestApiCacheWithHttpRequestMode:requestMode2 success:^(HttpRequest *request, HttpResponse *response) {
            
            
            HttpRequestMode *requestMode3= [[HttpRequestMode alloc]init];
            requestMode3.SetName(@"上传文件").SetUrl(@"http://test.3tichina.com:8023/aiya//m/pics/photosUpload").SetIsGET(@(0)).SetParameters(@{@"userId":@"459",@"relativeFilePaths":self.paraString,@"groupId":@"683"});
            requestMode3.uploadModels = self.photoArr;
            
            [[HttpClient sharedInstance] uploadPhotoWithHttpRequestMode:requestMode3 progress:^(HttpFileLoadProgress *uploadProgress) {
                
            } success:^(HttpRequest *request, HttpResponse *response) {
                
            } failure:^(HttpRequest *request, HttpResponse *response) {
                
            } requsetStart:nil responseEnd:^{
                
                [self.photoArr removeAllObjects];
                self.photoArr = nil;
            }];
            
            

        } failure:^(HttpRequest *request, HttpResponse *response) {
            
        } requsetStart:nil responseEnd:nil];
        
        
        
        
        
    } failure:^(HttpRequest *request, HttpResponse *response) {
        
    } requsetStart:^{
        
    } responseEnd:^{
        
    }];

    
//    HttpRequestMode *requestMode = [HttpRequestMode new];
//    requestMode.name = @"上传";
//    requestMode.url = @"http://test.3tichina.com:8023/aiya/m/userExtend/photoUpload";
//    UploadModel *model = [[UploadModel alloc]initWithUploadModelfileData:[[NSBundle mainBundle]pathForResource:@"test.jpg" ofType:@""] name:@"photoFile++" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
//
//    requestMode.uploadModels = @[model];
//    
//    [[HttpClient sharedInstance]uploadPhotoWithHttpRequestMode:requestMode progress:^(HttpFileLoadProgress *uploadProgress) {
//        
//    } success:^(HttpRequest *request, HttpResponse *response) {
//        
//    } failure:^(HttpRequest *request, HttpResponse *response) {
//        
//    } requsetStart:^{
//        
//    } responseEnd:^{
//        
//    }];
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
