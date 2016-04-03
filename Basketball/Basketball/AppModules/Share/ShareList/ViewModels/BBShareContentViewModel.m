//
//  BBShareContentViewModel.m
//  Basketball
//
//  Created by yingwang on 16/3/28.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareContentViewModel.h"
#import "WYShare.h"
#import "WYShareComment.h"
#import "WYStore+WYShare.h"

@interface BBShareContentViewModel ()

@property (nonatomic, strong) NSMutableArray *pCommentArray;
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation BBShareContentViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _pCommentArray = [NSMutableArray array];
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}

- (NSArray *)commentArray {
    return _pCommentArray;
}

- (void)loadCommentData {
    
    NSDictionary *paraDictionary = @{@"pageIdx":@(0),@"shareId":_shareEntity.shareId};
    [self GET:kApiGetShareComment parameters:paraDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            NSArray *resultArray = responseObject[@"data"];
            NSArray *commentArray = [[WYFeedManager shareManager].store numbersOfTemporaryShareCommentEntity:resultArray.count];
            NSInteger idx = 0;
            for (WYShareComment *comment in commentArray) {
                comment.commentId = resultArray[idx][@"commentId"];
                comment.userId = resultArray[idx][@"userId"];
                comment.shareId = resultArray[idx][@"shareId"];
                comment.publicDate = [_formatter dateFromString:resultArray[idx][@"publicDate"]];
                comment.content = resultArray[idx][@"content"];
                comment.isReply = @([resultArray[idx][@"isReply"] boolValue]);
                comment.replyUserId = resultArray[idx][@"replyUserId"];
                comment.replyUserName = resultArray[idx][@"replyUserName"];
                comment.nikcName = resultArray[idx][@"nickName"];
                comment.headImageUrl = resultArray[idx][@"headImageUrl"];
                ++idx;
            }
            _pCommentArray = [NSMutableArray array];
            [_pCommentArray addObjectsFromArray:commentArray];
        }
        if ([_delegate respondsToSelector:@selector(viewModel:getShareCommentFinish:)]) {
            [_delegate viewModel:self getShareCommentFinish:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)addComment:(NSString *)content replyUserId:(NSString *)replyUserId userName:(NSString *)userName {
    
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionaryWithDictionary:@{@"shareId":_shareEntity.shareId,
                                                                                          @"publicDate":[_formatter stringFromDate:[NSDate date]],
                                                                                          @"content":content}];
    if (replyUserId) {
        postDictionary[@"isReply"] = @(1);
        postDictionary[@"replyUserId"] = replyUserId;
        postDictionary[@"replyUserName"] = userName;
    } else {
        postDictionary[@"isReply"] = @(0);
    }
    [self POST:kApiAddShareComment parameters:postDictionary progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if ([_delegate respondsToSelector:@selector(viewModel:addShareCommentFinish:)]) {
               [_delegate viewModel:self addShareCommentFinish:nil];
           }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([_delegate respondsToSelector:@selector(viewModel:addShareCommentFinish:)]) {
            [_delegate viewModel:self addShareCommentFinish:error];
        }
    }];
}

@end
