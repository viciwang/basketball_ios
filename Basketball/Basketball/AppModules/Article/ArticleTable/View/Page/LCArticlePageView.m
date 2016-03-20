//
//  LCArticlePageView.m
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCArticlePageView.h"
#import "LCArticleTextBoxView.h"
#import "LCArticleImageBoxView.h"
#import "LCArticlePageView+Style.h"
#import "TimeFormatterTransform.h"

@interface LCArticlePageView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *imageBoxView;
@property (strong, nonatomic) LCArticleImageBoxView *imageBoxContentView;

@property (weak, nonatomic) IBOutlet UIView *textBox1;
@property (weak, nonatomic) IBOutlet UIView *textBox2;
@property (weak, nonatomic) IBOutlet UIView *textBox3;
@property (weak, nonatomic) IBOutlet UIView *textBox4;
@property (weak, nonatomic) IBOutlet UIView *textBox5;

// view array
@property (strong, nonatomic) NSArray *views;
@end
@implementation LCArticlePageView

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture {
    NSMutableArray *viewArray = [NSMutableArray arrayWithArray:_views];
    [viewArray addObject:_imageBoxView];
    [viewArray enumerateObjectsUsingBlock:^(UIView*  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint curPoint = [gesture locationInView:view];
        if ([view pointInside:curPoint withEvent:nil] && view.tag>=360) {
            id model = _models[view.tag-360];
            if (_delegate && [_delegate respondsToSelector:@selector(articlePageView:didSelectedCellAtIndex:withObject:)]) {
                [_delegate articlePageView:self didSelectedCellAtIndex:view.tag withObject:model];
            }
        }
    }];
}
- (void)awakeFromNib {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tap];
    [self setupContent];
}
- (void)setupContent {
    
    NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:6];
    NSArray *array = _pageStyle == kLCArticlePageViewStyleA? @[_imageBoxView,_textBox1,_textBox2,_textBox3,_textBox4,_textBox5]
                                                            :@[_textBox1,_textBox2,_textBox3,_imageBoxView,_textBox4,_textBox5];
    for (int i=0; i<6; ++i) {
        if (array[i] == _imageBoxView) {
            _imageBoxContentView = [LCArticleImageBoxView loadFromNibGeneral];
            _imageBoxContentView.frame = _imageBoxView.bounds;
            [_imageBoxView addSubview:_imageBoxContentView];
            [viewsArray addObject:_imageBoxContentView];
        } else {
            LCArticlePageView *view = [LCArticleTextBoxView loadFromNibGeneral];
            [viewsArray addObject:view];
            
            UIView *parentView = array[i];
            CGRect frame = parentView.bounds;
            view.frame = frame;
            [parentView addSubview:view];
        }
    }
    _views = [NSArray arrayWithArray:viewsArray];
}

-(void)reloadData {
    if (_feed && [_feed isKindOfClass:[WYFeed class]]) {
        _titleLabel.text = ((WYFeed *)_feed).name;
    }
    if (_models.count) {
        [self configContentText];
    }
    [self layoutIfNeeded];
    [_views enumerateObjectsUsingBlock:^(UIView*  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.frame = view.superview.bounds;
        if (idx>_models.count-1) {
            view.hidden = YES;
        }
    }];
    [self setNeedsDisplay];
}
- (void)configContentText {
    
    // 交换没有图片的新闻
    __block NSInteger imgIdx = 0;
    [_models enumerateObjectsUsingBlock:^(WYFeedEntity*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.thumbnail) {
            imgIdx = idx;
            *stop = YES;
        }
    }];
    NSInteger rigionIdx = _pageStyle == kLCArticlePageViewStyleA?0:3;
    if (_pageStyle == kLCArticlePageViewStyleB && _models.count<4) {
        rigionIdx = imgIdx;
    }
    
    [_models enumerateObjectsUsingBlock:^(WYFeedEntity*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx==imgIdx) {
            idx = rigionIdx;
        } else if(idx == rigionIdx) {
            idx = imgIdx;
        }
        if ([_views[idx] isKindOfClass:[LCArticleImageBoxView class]]) {
            _imageBoxContentView.titleLabel.text = obj.title;
            [_imageBoxContentView.imageView sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail]
                                                   placeholderImage:[UIImage imageNamed:@"article_thumbnail.png"]];
            _imageBoxContentView.tag = 360+idx;
        } else {
            LCArticleTextBoxView *view = _views[idx];
            view.titleLabel.text = obj.title;
            view.sourceLabel.text = obj.sourceName;
            view.timeLabel.text = [TimeFormatterTransform transformCSTTimeToDateStringFromString:obj.publishDate];
            view.tag = 360+idx;
        }
    }];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    UITouch *touch = [touches anyObject];
//    NSMutableArray *viewArray = [NSMutableArray arrayWithArray:_views];
//    [viewArray addObject:_imageBoxView];
//    [viewArray enumerateObjectsUsingBlock:^(UIView*  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGPoint curPoint = [touch locationInView:view];
//        if ([view pointInside:curPoint withEvent:event]) {
//            id model = _models[view.tag];
//            if (_delegate && [_delegate respondsToSelector:@selector(articlePageView:didSelectedCellAtIndex:withObject:)]) {
//                //[_delegate articlePageView:self didSelectedCellAtIndex:view.tag withObject:model];
//            }
//        }
//    }];
//}

@end
