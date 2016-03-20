//
//  LCFeedEntityPageViewModel.m
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCFeedEntityPageViewModel.h"

@interface LCFeedEntityPageViewModel ()
@property (nonatomic, strong) NSArray *privateModels;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL responedReloadFinishFunc;

@property (nonatomic, assign) BOOL privateCanSubscribeFeed;

@end

@implementation LCFeedEntityPageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentPage = 0;
    }
    return self;
}

- (void)setDelegate:(id<LCFeedEntityPageViewModelDelegate>)delegate {
    _delegate = delegate;
    _responedReloadFinishFunc = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(pageViewModel:didReloadDataFinish:)]) {
        _responedReloadFinishFunc = YES;
    }
}

- (void)setFeed:(WYFeed *)feed {
    _feed = feed;
}

- (BOOL)canSubscribeFeed {
    return _privateCanSubscribeFeed;
}

- (void)reloadData {
    
    [[WYFeedManager shareManager].store fetchFeedEntity:_feed atPage:_currentPage completion:^(id obj, BOOL success, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _models = obj;
            if(!_models.count) {
                if(!YES/**/) {
                    if (_responedReloadFinishFunc) {
                        [_delegate pageViewModel:self didReloadDataFinish:[NSError errorWithDomain:@"无网络连接，无法加载最新内容！" code:404 userInfo:nil]];
                    }
                    return;
                } else {
                    [[WYFeedManager shareManager] updateFeed:_feed completion:^(id obj, BOOL success, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            _models = obj;
                            if(success && _models.count) {
                                if (_responedReloadFinishFunc) {
                                    [_delegate pageViewModel:self didReloadDataFinish:nil];
                                }
                            }
                            else
                            {
                                [_delegate pageViewModel:self didReloadDataFinish:[NSError errorWithDomain:@"无内容！" code:404 userInfo:nil]];
                            }
                        });
                    }];
                }
            } else {
                if (_responedReloadFinishFunc) {
                    [_delegate pageViewModel:self didReloadDataFinish:nil];
                }
            }
        });
    }];
    
}

- (void)refreshData {
    
    [[WYFeedManager shareManager] updateFeed:_feed completion:^(id obj, BOOL success, NSError *error) {
        if(!success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate pageViewModel:self didRefreshDataFinish:error];
            });
            return;
        }
        if (![(NSArray *)obj count]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate pageViewModel:self didRefreshDataFinish:[NSError errorWithDomain:@"没有最新内容" code:304 userInfo:nil]];
            });
            return;
        }
        _currentPage = 0;
        [[WYFeedManager shareManager].store fetchFeedEntity:_feed atPage:_currentPage completion:^(id obj, BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _models = [obj mutableCopy];
                _currentPage = 0;
                [_delegate pageViewModel:self didRefreshDataFinish:nil];
            });
        }];
        
    }];
}

- (void)loadMoreData {
    
    [[WYFeedManager shareManager].store fetchFeedEntity:_feed atPage:_currentPage+1 completion:^(id obj, BOOL success, NSError *error) {
        if(!success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate pageViewModel:self didLoadMoreDataFinish:error];
            });
            return;
        }
        if (![(NSArray *)obj count]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate pageViewModel:self didLoadMoreDataFinish:[NSError errorWithDomain:@"没有更多内容" code:404 userInfo:nil]];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *allObjects = [NSMutableArray arrayWithArray:_models];
            [allObjects addObjectsFromArray:obj];
            _models = [allObjects copy];
            _currentPage += 1;
            [_delegate pageViewModel:self didLoadMoreDataFinish:nil];
        });
    }];
}

@end
