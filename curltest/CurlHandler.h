//
//  CurlHandler.h
//  curltest
//
//  Created by 小林 博久 on 2016/01/18.
//  Copyright © 2016年 hogelab.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "curl.h"


@interface CurlHandler : NSObject

- (id)initWithUrl:(NSString *)url;

- (void)setDebugFunction:(curl_debug_callback)debugFunction
               debugData:(void *)debugData;

- (void)setIpResolve:(int)ipResolve;

- (void)setCaInfo:(NSString *)caInfoPath;

// CURL_HTTP_VERSION_1_0, CURL_HTTP_VERSION_1_1, CURL_HTTP_VERSION_2_0
- (void)setHttpProtocolVersion:(int)protocolVersion;

- (void)setSslPort;

- (void)setUrl:(NSString *)url;


- (void)perform;

@end
