//
//  WYURLSessionManager.m
//  MicroReader
//
//  Created by yingwang on 15/12/8.
//  Copyright © 2015年 RR. All rights reserved.
//

#import "WYURLSessionManager.h"
#import "WYURLSessionTaskHandler.h"

@interface WYURLSessionManager ()<NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong) NSURLSession *session;
@property (nullable, nonatomic, strong) NSOperationQueue *sessionDelegateQueue;
@property (nonatomic, strong) NSMutableDictionary *taskHandlerDictionary;
@property (nonatomic, strong) dispatch_queue_t completionQueue;
@property (nonatomic, strong) dispatch_group_t completionGroup;
@end

@implementation WYURLSessionManager

+ (instancetype)manager {
    return [[[self class] alloc] initWithConfigation:[NSURLSessionConfiguration defaultSessionConfiguration]];
}
- (instancetype)initWithConfigation:(NSURLSessionConfiguration *)configuration {
    
    self = [super init];
    if (self) {
        
        _configuration = configuration;
        _sessionDelegateQueue = [[NSOperationQueue alloc] init];
        _taskHandlerDictionary = [NSMutableDictionary dictionary];
        _session = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:_sessionDelegateQueue];
        
        
        self.completionGroup = dispatch_group_create();
        self.completionQueue = dispatch_queue_create("com.oneinbest.WYKit.WYURLSessionManager.CompletionQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionBlock:(WYURLSessionCompletionBlock)block {
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request];
    [self addDataTaskHandlerForTask:dataTask completionBlock:block];
    return dataTask;
}

#pragma mark -

- (void)addDataTaskHandlerForTask:(NSURLSessionTask *)task completionBlock:(WYURLSessionCompletionBlock)block {

    WYURLSessionDataTaskHandler *handler = [[WYURLSessionDataTaskHandler alloc] initWithCompletionBlock:block];
    handler.completionQueue = self.completionQueue;
    handler.completionGroup = self.completionGroup;
    self.taskHandlerDictionary[@(task.taskIdentifier)] = handler;
}

- (WYURLSessionTaskHandler *)taskHandlerWithSessionTask:(NSURLSessionTask *)task {
    return self.taskHandlerDictionary[@(task.taskIdentifier)];
}

#pragma mark - NSURLSession Delegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    WYURLSessionDataTaskHandler *handler = (WYURLSessionDataTaskHandler *)[self taskHandlerWithSessionTask:task];
    [handler URLSession:session task:task didCompleteWithError:error];
}

#pragma mark - NSURLSession Data Task Delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"receive");
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    if (completionHandler) {
        completionHandler(disposition);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {

    WYURLSessionDataTaskHandler *handler = (WYURLSessionDataTaskHandler *)[self taskHandlerWithSessionTask:dataTask];
    [handler URLSession:session dataTask:dataTask didReceiveData:data];
}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler {
//}

#pragma mark - Download Task delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
}
@end
