//
//  LCArticleContentViewModel.m
//  LazyCat
//
//  Created by yingwang on 16/3/11.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCArticleContentViewModel.h"
#import "WYFeedEntity+ValidateArticle.h"

@interface LCArticleContentViewModel()
{
    NSArray *_privateImages;
    NSData *_privateContent;
}

@property (nonatomic, assign) BOOL responedToFinishFunc;

@end

@implementation LCArticleContentViewModel

- (NSArray *)images {
    return _privateImages;
}
- (NSData *)content {
    return _privateContent;
}

- (void)setDelegate:(id<LCArticleContentViewModelDelegate>)delegate {
    _delegate = delegate;
    if (!_delegate) {
        return;
    }
    
    _responedToFinishFunc = NO;
    if ([_delegate respondsToSelector:@selector(articleContentViewModel:didLoadDataFinishWithError:)]) {
        _responedToFinishFunc = YES;
    }
}

- (void)reloadData {
    
    if (!_article)
        return;
    if ([_article isArticleContentValid]) {
        _privateImages = _article.imageArray;
        _feed.imageURL = _article.thumbnail;
        _privateContent = [_article.feedDescription dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_responedToFinishFunc) {
                [_delegate articleContentViewModel:self didLoadDataFinishWithError:nil];
            }
        });
        return;
    }
    if (!_article.link) {
        if (_responedToFinishFunc) {
            NSError *error = [NSError errorWithDomain:@"article info is NULL" code:404 userInfo:nil];
            [_delegate articleContentViewModel:self didLoadDataFinishWithError:error];
            return;
        }
    }
    
    [self GET:kArticleParseAPI
   parameters:@{@"link":_article.link}
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          NSDictionary *info = responseObject[@"data"];
          if (info) {
              NSLog(@"%@",info[@"content"]);
              _privateContent = [info[@"content"] dataUsingEncoding:NSUTF8StringEncoding];
              _privateImages = info[@"images"];
              _article.imageArray = _privateImages;

              // 如果有图片且feed的展示图为空，那么设置为其展示图
              
              _feed.imageURL = _article.thumbnail;
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (_responedToFinishFunc) {
                      [_delegate articleContentViewModel:self didLoadDataFinishWithError:nil];
                  }
              });
          }
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"error : %@", error.description);
      }];
}



@end
