//
//  WYTeleTextView.m
//  WYKitTDemo
//
//  Created by yingwang on 16/3/1.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYTeleTextView.h"
#import "WYTextContainer.h"
#import "SDWebImageManager.h"

NSString const * WYTeleTextViewMSYHFontType = @"MicrosoftYaHei";
NSString const * WYTeleTextViewSongFontType = @"经典宋体简";
NSString const * WYTeleTextViewKaiFontType = @"KaiTi_GB2312";

#define kWYTeleTextViewDefaultPadding 10
#define isDevicePad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kMainNewsViewFontSizePara  @"kMainNewsViewFontSizePara"
#define NEWS_FONT_STYTLE @"NEWS_FONT_STYTLE"

static CGFloat convertFontSize(WYTeleTextViewFontSize size) {
    
    CGFloat fontSize;
    switch (size) {
        case WYTeleTextViewFontSizeExtraSmall:
            fontSize = 10;
            break;
        case WYTeleTextViewFontSizeSmall:
            fontSize = 13;
            break;
        case WYTeleTextViewFontSizeMiddle:
            fontSize = 15;
            break;
        case WYTeleTextViewFontSizeLarge:
            fontSize = 17;
            break;
        case WYTeleTextViewFontSizeExtraLarge:
            fontSize = 19;
            break;
        default:
            fontSize = 13;
            break;
    }
    return isDevicePad?fontSize*1.5:fontSize;
}

@interface WYTeleTextImageInfomation : NSObject

@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSRange uuidRange;

@end
@implementation WYTeleTextImageInfomation
@end



@interface WYTeleTextHeaderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *pubDataLabel;

@property (nonatomic, strong) NSString *fontStyle;

@end
@implementation WYTeleTextHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-10, height*0.8)];
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, height*0.75, width/3, height*0.2)];
        _pubDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2-20, height*0.75, width/2, height*0.2)];
    
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.numberOfLines = 0;
        
        _sourceLabel.textColor = [UIColor grayColor];
        _pubDataLabel.textColor = [UIColor grayColor];
        _pubDataLabel.textAlignment = NSTextAlignmentRight;
        
        UIView *decorateLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-5, 0.2*CGRectGetHeight(frame), 3, 0.65*CGRectGetHeight(frame))];
        decorateLine.backgroundColor = [UIColor orangeColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), CGRectGetWidth(frame), 0.6)];
        line.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        line.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        line.layer.shadowOffset = CGSizeMake(-0.6, -0.6);
        
        [self addSubview:decorateLine];
        [self addSubview:line];
        [self addSubview:_titleLabel];
        [self addSubview:_sourceLabel];
        [self addSubview:_pubDataLabel];
    }
    return self;
}

- (void)setFontStyle:(NSString *)fontStyle {
    
    _fontStyle = fontStyle;
    
    CGFloat titleFontSize = convertFontSize(WYTeleTextViewFontSizeExtraLarge);
    CGFloat sourceFontSize = convertFontSize(WYTeleTextViewFontSizeExtraSmall);
    
    _titleLabel.font = [UIFont fontWithName:_fontStyle size:titleFontSize];
    _sourceLabel.font = [UIFont fontWithName:_fontStyle size:sourceFontSize];
    _pubDataLabel.font = [UIFont fontWithName:_fontStyle size:sourceFontSize];
}

@end

@interface WYTeleTextView () <NSLayoutManagerDelegate,SDWebImageManagerDelegate>
{
}

@property (nonatomic, strong) NSString *documentType;

// TextKit
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSMutableArray *textContainers;

// text data
@property (nonatomic, strong) NSData *originTextData;
@property (nonatomic, strong) NSData *convertedTextData;

// header view
@property (nonatomic, strong) WYTeleTextHeaderView *headerView;

// page size
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) CGSize originSize;

// image manager
@property (nonatomic, strong) SDWebImageManager *imageManager;

// serial queue
@property (nonatomic, strong) NSOperationQueue *privateQueue;

@property (nonatomic, strong) NSMutableArray *imageRects;

@end



@implementation WYTeleTextView

- (instancetype)initWithFrame:(CGRect)frame textData:(NSData *)textData images:(NSArray *)images documentType:(NSString *)docType {
    
    self = [super initWithFrame:frame];
    if (self) {
        _documentType = docType;
        
        _originSize = frame.size;
        if (CGRectGetWidth(frame)>CGRectGetHeight(frame)) {
            _originSize.width /= 2;
            
        }
        
        _fontType = WYTeleTextViewMSYHFontType;
        _fontSize = WYTeleTextViewFontSizeMiddle;
        self.backgroundColor = [UIColor whiteColor];
        
        _imagePrefix = @"imgOfLazyCat";
        
        self.leftPadding = kWYTeleTextViewDefaultPadding;
        self.rightPadding = kWYTeleTextViewDefaultPadding;
        self.topPadding = kWYTeleTextViewDefaultPadding;
        self.bottomPadding = kWYTeleTextViewDefaultPadding;
        
        // queue config
        _privateQueue = [[NSOperationQueue alloc] init];
        _privateQueue.maxConcurrentOperationCount = 1;
        
        //temp end
        
        _imageManager = [[SDWebImageManager alloc] init];
        _imageManager.delegate = self;
        
        self.images = [images mutableCopy];
        _originTextData = textData;
        _convertedTextData = [self convertOriginTextToRegularyText:_originTextData];
    }
    return self;
}

- (void)setImages:(NSArray *)images {
    
    _images = [NSMutableArray array];
    for (NSString *link in images) {
        WYTeleTextImageInfomation *info = [[WYTeleTextImageInfomation alloc] init];
        info.link = link;
        info.image = [UIImage imageNamed:@"article_thumbnail.png"];
        CGFloat height = (_pageSize.width-20)*5/8;
        info.frame = CGRectMake(10, 0, _pageSize.width-20, height);
        [self.images addObject:info];
    }
    // download image
    [self loadImage];
}


- (void)setLeftPadding:(CGFloat)leftPadding {
    _leftPadding = calculatePadding(leftPadding);
    _pageSize.width = _originSize.width-(_leftPadding+_rightPadding);
}
- (void)setRightPadding:(CGFloat)rightPadding {
    _rightPadding = calculatePadding(rightPadding);
    _pageSize.width = _originSize.width-(_leftPadding+_rightPadding);
}
- (void)setTopPadding:(CGFloat)topPadding {
    _topPadding = calculatePadding(topPadding);
    _pageSize.height = _originSize.height-(_topPadding+_bottomPadding);
}
- (void)setBottomPadding:(CGFloat)bottomPadding {
    _bottomPadding = calculatePadding(bottomPadding);
    _pageSize.height = _originSize.height-(_topPadding+_bottomPadding);
}

- (id)text {
    if (_textStorage) {
        return _textStorage.string;
    }
    return nil;
}

static CGFloat calculatePadding(CGFloat padding) {
    
    padding = padding>0?padding:0;
    if (isDevicePad) {
        padding *= 2;
    }
    return padding;
}

- (void)reloadData {
    
    __weak typeof(self) weakSelf = self;
    if (_privateQueue.operationCount >= 2) {
        return;
    }
    NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        static NSInteger reloadTimes = 0;
        NSLog(@"reloadtimes = %lu, start op count = %lu,  thread = %@", reloadTimes,weakSelf.privateQueue.operationCount, [NSThread currentThread].description);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf configHeaderView];
        });
        

        //    dispatch_async(_privateQueue, ^{
        
        [weakSelf configTextView];
        
        if (weakSelf.images.count) {
            [weakSelf insertImages];
        }
        
        CGRect rect = weakSelf.frame;
        rect.size = CGSizeMake(_textContainers.count*_originSize.width, _originSize.height);
        weakSelf.frame = rect;

        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"ww text frame = %@",NSStringFromCGRect(self.frame));
            if (_layoutDelegate && [_layoutDelegate respondsToSelector:@selector(teleTextView:configContentSize:)]) {
                [_layoutDelegate teleTextView:weakSelf configContentSize:rect.size];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(reloadComplishOnTeleTextView:)]) {
                [_delegate reloadComplishOnTeleTextView:weakSelf];
            }
            [weakSelf setNeedsDisplay];
        });
        NSLog(@"reloadtimes = %lu, end op count = %lu,  thread = %@", reloadTimes++,weakSelf.privateQueue.operationCount, [NSThread currentThread].description);
    }];
    
    if (_privateQueue.operations.count!=0) {
        [op addDependency:_privateQueue.operations.lastObject];
    }
    [_privateQueue addOperation:op];
}

- (NSData *)convertOriginTextToRegularyText:(NSData *)originData {
    unichar c = 0xFFFC;
    NSString *locChar = [NSString stringWithCharacters:&c length:1];
    //NSLog(@"%@ length = %lu", ss, ss.length);
    _textStorage = [self createTextStorageWithText:originData];
    NSString *replacedImageNameText = [_textStorage.string copy];
    NSString *originReplaceText = [[NSString alloc] initWithData:originData encoding:NSUTF8StringEncoding];
    for (int idx = 0; idx < self.images.count; idx++) {
        
        WYTeleTextImageInfomation *imageInfo = _images[idx];
        NSString *uuid = [NSString stringWithFormat:@"%@%i", _imagePrefix,idx];
        NSRange range = [replacedImageNameText rangeOfString:uuid];
        replacedImageNameText = [replacedImageNameText stringByReplacingCharactersInRange:range withString:locChar];
        imageInfo.uuidRange = NSMakeRange(range.location, 1);
        
        range = [originReplaceText rangeOfString:uuid];
        originReplaceText = [originReplaceText stringByReplacingCharactersInRange:range withString:locChar];
    }
    NSData *textData = [originReplaceText dataUsingEncoding:NSUTF8StringEncoding];
    return textData;
}
- (void)configTextView {
    
    _textContainers = [NSMutableArray array];
    _layoutManager = [[NSLayoutManager alloc] init];
    _layoutManager.delegate = self;
    _textStorage = [self createTextStorageWithText:_convertedTextData];
    if ([[NSThread currentThread] isMainThread]) {
        [_textStorage addLayoutManager:_layoutManager];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_textStorage addLayoutManager:_layoutManager];
        });
    }
    
//    for (NSInteger i = 0; i < _images.count; ++i) {
//        WYTeleTextImageInfomation *img = _images[i];
////        NSLog(@"rangeOfString idx = %lu : %@  loc = %lu", i, [_textStorage.string substringWithRange:NSMakeRange(img.uuidRange.location, 1)],img.uuidRange.location);
//    }
    
    NSInteger allTextLength = _textStorage.string.length;
    NSInteger idx = 0;
    
    while (allTextLength > 0) {
        
        WYTextContainer *container = [[WYTextContainer alloc] initWithSize:_pageSize];
        container.rect = CGRectMake(_leftPadding+idx*(_leftPadding+_rightPadding+_pageSize.width), _topPadding, _pageSize.width, _pageSize.height);
//        NSLog(@"bounds = %@",NSStringFromCGRect(self.bounds));
        if (!idx) {
            container.size = CGSizeMake(_pageSize.width, _pageSize.height-CGRectGetHeight(_headerView.frame));
            container.rect = CGRectMake(_leftPadding+idx*(_leftPadding+_rightPadding+_pageSize.width),
                                        _topPadding+CGRectGetHeight(_headerView.frame),
                                        _pageSize.width,
                                        _pageSize.height-CGRectGetHeight(_headerView.frame));
        }
        
        [_layoutManager addTextContainer:container];

        [_textContainers addObject:container];
        
        NSRange range = [_layoutManager glyphRangeForTextContainer:container];
        container.textRange = range;
        allTextLength -= range.length;
        
        idx++;
    }
}

- (NSTextStorage *)createTextStorageWithText:(NSData *)text {
    
    static NSInteger c = 1;
    NSLog(@"attribute string create times = %lu",c++);
    NSTextStorage *textStorage;
    
    //@autoreleasepool {
        if ([text isKindOfClass:[NSString class]]) {
            text = [(NSString *)text dataUsingEncoding:NSUTF8StringEncoding];
        }
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithData:text
                                                                                             options:@{@"CharacterEncoding":@(NSUTF8StringEncoding),
                                                                                                       NSDocumentTypeDocumentAttribute:_documentType}
                                                                                  documentAttributes:nil
                                                                                               error:nil];
        _fontType = [[NSUserDefaults standardUserDefaults] objectForKey:NEWS_FONT_STYTLE];
        _fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:kMainNewsViewFontSizePara] integerValue];
        UIFont *font = [UIFont fontWithName:_fontType size:convertFontSize(_fontSize)];
    NSDictionary *attri = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        [attributeString setAttributes:attri range:NSMakeRange(0, attributeString.length)];
        textStorage = [[NSTextStorage alloc] initWithAttributedString:attributeString];
    //}
    
    return textStorage;
}

- (void)configHeaderView {

    CGRect headerRect = CGRectMake(_leftPadding+10, 0, _pageSize.width-20, _pageSize.height*0.25);
    _headerView = _headerView?_headerView:[[WYTeleTextHeaderView alloc] initWithFrame:headerRect];
    _headerView.titleLabel.text = _title;
    _headerView.sourceLabel.text = _source;
    _headerView.pubDataLabel.text = _pubData;
    _headerView.fontStyle = _fontType;
    
    [self addSubview:_headerView];
}

- (void)insertImages {
    
    _imageRects = [NSMutableArray array];
    for (int idx = 0; idx < self.images.count; idx++) {
        
        WYTeleTextImageInfomation *imageInfo = _images[idx];
        NSString *uuid;
        uuid = [NSString stringWithFormat:@"%@%i", _imagePrefix,idx];

        NSRange range = imageInfo.uuidRange;//[_textStorage.string rangeOfString:uuid];
        WYTextContainer *container;
        // find container for image
        NSUInteger indexOfContainer = 0;
        for (int i = 0;i < _textContainers.count;i++) {
            WYTextContainer *tc = _textContainers[i];
            if (tc.textRange.location<=range.location
                && (tc.textRange.location+tc.textRange.length)>range.location) {
                container = tc;
                indexOfContainer = i;
                break;
            }
        }
        // calculate image rect size
        //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_images[idx]]]];
        CGSize imageSize = imageInfo.frame.size;
        imageSize.width = _pageSize.width;
        // calculate glyph rect
        CGRect glyphRect = [_layoutManager boundingRectForGlyphRange:range inTextContainer:container];
        //glyphRect.origin.y += CGRectGetHeight(glyphRect);
        // 第一个container有标题，所以container的坐标和后面的不一样，所有图片相对位置要改变
        if (!indexOfContainer) {
            glyphRect.origin.y += CGRectGetMinY(container.rect);
        }
        
        // 图片水平方向的间隔
        CGFloat imageVerticleMargging = 10;//CGRectGetHeight(glyphRect);
        // 图片的坐标相对于总的view， 而占位rect坐标相对于单个container
        // 而要想画出所有占位rect，由于是相对于总的view，故其坐标和相对于container时不一样
        CGRect rectOfImage;
        rectOfImage.size = imageSize;
        // 占位框上下各增大面积一行
        rectOfImage.size.height += 2*imageVerticleMargging;
        // 占位框的y坐标开始于占位符之下
        rectOfImage.origin = CGPointMake(0, CGRectGetMaxY(glyphRect));
        // 图片的坐标， 为占位框各个方向减去间隔
        imageInfo.frame = CGRectMake(CGRectGetMinX(container.rect)+10, rectOfImage.origin.y+imageVerticleMargging, CGRectGetWidth(imageInfo.frame), CGRectGetHeight(imageInfo.frame));
        // if image heigher than the space, put it on the next container
        // 如果剩下的container面积不够放图片，那么放到下一个container
        if (CGRectGetMinY(rectOfImage)+CGRectGetHeight(rectOfImage) > CGRectGetMinY(container.rect) + CGRectGetHeight(container.rect)) {
            //在下一个container中放在最上方
            CGRect realBound = rectOfImage;
            realBound.origin = CGPointMake(0, 0);
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:realBound];
            // if current container is the lastest one, create new one
            // 如果当前的container是最后一个，那么增加一个
            if (indexOfContainer == _textContainers.count-1) {
                WYTextContainer *container = [[WYTextContainer alloc] initWithSize:_pageSize];
                container.rect = CGRectMake(_leftPadding+(indexOfContainer+1)*(_leftPadding+_rightPadding+_pageSize.width), _topPadding, _pageSize.width, _pageSize.height);
                [_layoutManager addTextContainer:container];
                [_textContainers addObject:container];
            }
            WYTextContainer *nextContainer = _textContainers[indexOfContainer+1];
            // 图片的坐标位于新的container中
            imageInfo.frame = CGRectMake(CGRectGetMinX(nextContainer.rect)+10, imageVerticleMargging, CGRectGetWidth(imageInfo.frame), CGRectGetHeight(imageInfo.frame));
            
            CGRect newr = realBound;
            newr.origin.x = CGRectGetMinX(nextContainer.rect);
            [_imageRects addObject:NSStringFromCGRect(newr)];
            
            NSMutableArray *currentExclusionPaths = [NSMutableArray arrayWithArray:nextContainer.exclusionPaths];
            [currentExclusionPaths addObject:path];
            [nextContainer setExclusionPaths:currentExclusionPaths];
            // 图片放在新的container之后，前一个container要腾出剩余所有空位
            rectOfImage.size.height = CGRectGetMaxY(container.rect) - CGRectGetMinY(rectOfImage);
        }
        // set normal exclusion
        if (!indexOfContainer) {
            rectOfImage.origin.y -= CGRectGetMinY(container.rect);
        }
        NSMutableArray *currentExclusionPaths = [NSMutableArray arrayWithArray:container.exclusionPaths];
//        // 如果单个contaniner 已经有图片， 图片向下移出间隔
//        if (currentExclusionPaths.count) {
//            rectOfImage.origin.y += 20;
//        }
        
        CGRect newr = rectOfImage;
        newr.origin.x = CGRectGetMinX(container.rect);
        [_imageRects addObject:NSStringFromCGRect(newr)];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rectOfImage];
        
        [currentExclusionPaths addObject:path];
//        dispatch_sync(dispatch_get_main_queue(), ^{
            [container setExclusionPaths:currentExclusionPaths];
//        });
        
        // remove the uuid string
        //_textStorage.string = [_textStorage.string stringByReplacingCharactersInRange:range withString:@""];
        [self recalculateContainerRange];
    }

}



- (void)recalculateContainerRange {
    
    NSInteger allTextLength = _textStorage.string.length;
    
    for(WYTextContainer *tc in _textContainers) {
        
        NSRange range = [_layoutManager glyphRangeForTextContainer:tc];
        tc.textRange = range;
    }
    
    WYTextContainer *lastContainer = [_textContainers lastObject];
    allTextLength -= (lastContainer.textRange.location+lastContainer.textRange.length);
    // container not engouh, add more
    NSInteger idx = _textContainers.count;
    
    while (allTextLength > 0) {
        
        WYTextContainer *container = [[WYTextContainer alloc] initWithSize:_pageSize];
        container.rect = CGRectMake(_leftPadding+idx*(_leftPadding+_rightPadding+_pageSize.width), _topPadding, _pageSize.width, _pageSize.height);
        
        [_layoutManager addTextContainer:container];
        
        [_textContainers addObject:container];
        
        NSRange range = [_layoutManager glyphRangeForTextContainer:container];
        container.textRange = range;
        allTextLength -= range.length;
        
        idx++;
    }
}

#pragma mark - image manager
- (CGSize)calculateImageRectSizeWithImage:(UIImage *)image {
    
    CGSize imageSize = _pageSize;
    imageSize.width -= 20;
    CGSize originImageSize = image.size;
    CGFloat imageHeight = (imageSize.width*originImageSize.height)/originImageSize.width;
    
    if (imageHeight > _pageSize.height) {
        
        imageSize.height = _pageSize.height;
    }
    
    imageSize.height = imageHeight;
    
    return imageSize;
}

- (void)loadImage {

    __weak WYTeleTextView *weakSelf = self;
    for (WYTeleTextImageInfomation *info in _images) {
        NSURL *imageURL = [NSURL URLWithString:info.link];
        NSLog(@"img url = %@",imageURL.absoluteString);
        if (imageURL) {
            [_imageManager downloadImageWithURL:imageURL
                                        options:SDWebImageCacheMemoryOnly
                                       progress:nil
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                          
                                          if (!finished) {
                                              return ;
                                          }
//                                          NSData *data = UIImageJPEGRepresentation(image, 1.0);
//                                          while (data.length > 1024*100) {
//                                              data = UIImageJPEGRepresentation(image, 0.5);
//                                              image = [UIImage imageWithData:data];
//                                          }
                                          static NSInteger count = 1;
                                          NSLog(@"img count = %lu, size = %lu", count++, UIImageJPEGRepresentation(image, 1).length);
                                          info.image = image;
                                          CGSize size = [weakSelf calculateImageRectSizeWithImage:image];
                                          info.frame = CGRectMake(0, 0, size.width, size.height);
                                          [weakSelf reloadData];
                                          
                                      }];
        }
    }
}
#pragma mark - SDWebImage Manager delegate
//- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL {
//    //@autoreleasepool {
//        
//        NSData *data = UIImageJPEGRepresentation(image, 1.0);
//        while (data.length > 1024*10) {
//            NSLog(@"before data length : %lu",data.length);
//            data = UIImageJPEGRepresentation(image, 0.1);
//            //NSLog(@"after data length : %lu",data.length);
//            image = [UIImage imageWithData:data];
//        }
//    //}
//    //NSLog(@"%@",[NSThread currentThread].description);
//    return image;
//}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
//    if (![[NSThread currentThread] isMainThread]) {
         //NSLog(@"drawRect thread : %@",[NSThread currentThread].description);
//    }
   
    for (int idx = 0; idx < _textContainers.count; idx++) {
        
        CGPoint point = CGPointMake(idx*_pageSize.width, _topPadding);
        if (!idx) {
            point.y += CGRectGetHeight(_headerView.frame);
        }
        
        WYTextContainer *container = _textContainers[idx];
        CGSize size = container.size;
        NSRange range = [_layoutManager glyphRangeForTextContainer:container];
        [_layoutManager drawBackgroundForGlyphRange:range atPoint:container.rect.origin];
        [_layoutManager drawGlyphsForGlyphRange:range atPoint:container.rect.origin];
    }
    
     //画出图片占位框，用于调试
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, 3);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    for (NSString *rectStr in _imageRects) {
//        CGContextAddRect(ctx, CGRectFromString(rectStr));
//    }
//    CGContextStrokePath(ctx);
    for (WYTeleTextImageInfomation *imageInfo in _images) {
        if (imageInfo.image) {
            [imageInfo.image drawInRect:imageInfo.frame];
        }
    }
}

#pragma mark - layout manager delegate
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    
    return 5;
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    
    return 10;
}

@end
