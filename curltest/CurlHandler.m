//
//  CurlHandler.m
//  curltest
//
//  Created by 小林 博久 on 2016/01/18.
//  Copyright © 2016年 hogelab.net. All rights reserved.
//

#import "CurlHandler.h"


@interface CurlHandler ()

@property (assign, nonatomic) CURL *curl_handle;

@end


@implementation CurlHandler

- (id)init {
    self = [super init];
    if (self != nil) {
        _curl_handle = [self createHandle];
    }

    return self;
}

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if (self != nil) {
        _curl_handle = [self createHandle];
    }

    return self;
}

- (void)dealloc {
    [self cleanupHandle];
}


- (CURL *)createHandle {
    CURL *handle = curl_easy_init();
    if (handle != NULL) {
        CURLcode res = curl_easy_setopt(handle, CURLOPT_USERAGENT , "curltest/1.0");
        NSLog(@"curl_easy_setopt(CURLOPT_USERAGENT) returned: %ld", (long)res);

        res = curl_easy_setopt(handle, CURLOPT_VERBOSE, 1L);
        NSLog(@"curl_easy_setopt(CURLOPT_VERBOSE) returned: %ld", (long)res);
    }

    return handle;
}

- (void)cleanupHandle {
    if (self.curl_handle != NULL) {
        curl_easy_cleanup(self.curl_handle);
    }
}

- (void)setDebugFunction:(curl_debug_callback)debugFunction
               debugData:(void *)debugData {

    if (self.curl_handle != NULL) {
        CURLcode res = curl_easy_setopt(self.curl_handle, CURLOPT_DEBUGFUNCTION, debugFunction);
        NSLog(@"curl_easy_setopt(CURLOPT_DEBUGFUNCTION) returned: %ld", (long)res);

        if (debugData != NULL) {
            res = curl_easy_setopt(self.curl_handle, CURLOPT_DEBUGDATA, debugData);
            NSLog(@"curl_easy_setopt(CURLOPT_DEBUGDATA) returned: %ld", (long)res);
        }
    }
}

- (void)setIpResolve:(int)ipResolve {
    if (self.curl_handle != NULL) {
        CURLcode res = curl_easy_setopt(self.curl_handle, CURLOPT_IPRESOLVE, ipResolve);
        NSLog(@"curl_easy_setopt(CURLOPT_IPRESOLVE) returned: %ld", (long)res);
    }
}

- (void)setCaInfo:(NSString *)caInfoPath {
    if (self.curl_handle != NULL) {
        CURLcode res = curl_easy_setopt(self.curl_handle, CURLOPT_SSL_VERIFYPEER, 1L);
        NSLog(@"curl_easy_setopt(CURLOPT_SSL_VERIFYPEER) returned: %ld", (long)res);

        res = curl_easy_setopt(self.curl_handle, CURLOPT_SSL_VERIFYHOST, 2L);
        NSLog(@"curl_easy_setopt(CURLOPT_SSL_VERIFYHOST) returned: %ld", (long)res);

        res = curl_easy_setopt(self.curl_handle, CURLOPT_CAINFO , [caInfoPath cStringUsingEncoding:NSUTF8StringEncoding]);
        NSLog(@"curl_easy_setopt(CURLOPT_CAINFO) returned: %ld", (long)res);
    }
}

- (void)setHttpProtocolVersion:(int)protocolVersion {
    if (self.curl_handle != NULL) {
        CURLcode res = curl_easy_setopt(self.curl_handle, CURLOPT_HTTP_VERSION, protocolVersion);
        NSLog(@"curl_easy_setopt(CURLOPT_HTTP_VERSION) returned: %ld", (long)res);
    }
}

- (void)setSslPort {
    if (self.curl_handle != NULL) {
        CURLcode res = curl_easy_setopt(self.curl_handle, CURLOPT_PORT, 443L);
        NSLog(@"curl_easy_setopt(CURLOPT_PORT) returned: %ld", (long)res);
    }
}

- (void)setUrl:(NSString *)url {
    if (self.curl_handle != NULL) {
        CURLcode res = curl_easy_setopt(self.curl_handle, CURLOPT_URL, [url cStringUsingEncoding:NSUTF8StringEncoding]);
        NSLog(@"curl_easy_setopt(CURLOPT_URL) returned: %ld", (long)res);
    }
}

- (void)perform {
    if (self.curl_handle != NULL) {
        CURLcode res = curl_easy_perform(self.curl_handle);
        NSLog(@"curl_easy_perform returned: %ld", (long)res);
    }
}


@end
