//
//  ViewController.m
//  curltest
//
//  Created by 小林 博久 on 2016/01/18.
//  Copyright © 2016年 hogelab.net. All rights reserved.
//

#import "ViewController.h"
#import "CurlHandler.h"
#import "curl.h"


static int curlDebugFunction(CURL *handle, curl_infotype type, char *data, size_t size, void *userptr);


@interface ViewController ()

- (void)appendInfo:(NSString *)info
            prefix:(NSString *)prefix
            suffix:(NSString *)suffix;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)onPerformButton:(id)sender {
    self.textView.text = @"";

    NSString *caInfoPath = [[NSBundle mainBundle] pathForResource:@"GTE_CyberTrust_Global_Root" ofType:@"pem"];

    CurlHandler *handler = [[CurlHandler alloc] init];
    [handler setDebugFunction:curlDebugFunction
                    debugData:(__bridge void *)self];
    [handler setIpResolve:CURL_IPRESOLVE_WHATEVER];
    [handler setCaInfo:caInfoPath];
    [handler setHttpProtocolVersion:CURL_HTTP_VERSION_1_1];
//    [handler setSslPort];
    [handler setUrl:@"http://www.google.com/"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [handler perform];
    });
}


- (void)appendInfo:(NSString *)info
            prefix:(NSString *)prefix
            suffix:(NSString *)suffix {

    dispatch_async(dispatch_get_main_queue(), ^{
        if (prefix != nil) {
            self.textView.text = [self.textView.text stringByAppendingString:prefix];
        }

        self.textView.text = [self.textView.text stringByAppendingString:info];

        if (suffix != nil) {
            self.textView.text = [self.textView.text stringByAppendingString:suffix];
        }

        // TODO: redraw?
    });
}

@end


static int curlDebugFunction(CURL *handle, curl_infotype type, char *data, size_t size, void *userptr)
{
    ViewController *viewController = (__bridge ViewController *)userptr;

    NSData *infoData = [NSData dataWithBytes:data length:size];
    NSString *info = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
    if (info) {
        switch (type) {
            case CURLINFO_DATA_IN:
                [viewController appendInfo:info
                                    prefix:@"<-"
                                    suffix:nil];
                break;

            case CURLINFO_DATA_OUT:
                [viewController appendInfo:info
                                    prefix:@"->"
                                    suffix:nil];
                break;

            case CURLINFO_HEADER_IN:
                [viewController appendInfo:info
                                    prefix:@"<H-"
                                    suffix:nil];
                break;

            case CURLINFO_HEADER_OUT:
                [viewController appendInfo:info
                                    prefix:@"-H>"
                                    suffix:nil];
                break;

            case CURLINFO_TEXT:
                [viewController appendInfo:info
                                    prefix:@"* "
                                    suffix:nil];
                break;

            default:
                NSLog(@"! curlDebugFunction unknown type:%lu, info:%@", (unsigned long)type, info);
                break;
        }
    }

    return 0;
}
