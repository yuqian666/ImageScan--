//
//  ImageScanView.m
//  ImageScan
//
//  Created by Shipeng on 15/7/1.
//  Copyright (c) 2015年 zhdwl. All rights reserved.
//

#import "ImageScanView.h"

#define WINDOW_FRAME [UIScreen mainScreen].bounds
#define WINDOW_SIZE [UIScreen mainScreen].bounds.size
#define IMAGE_TAG 1000

@interface ImageScanView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *imageViewArr;
@property (assign, nonatomic) CGRect oldFrame;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) UILabel *pageLabel;

@end

@implementation ImageScanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithImageArr:(NSArray *)imageViewArr
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapView)];
        self.backgroundColor = [UIColor blackColor];
        [self addGestureRecognizer:tap];
        _scrollView = [[UIScrollView alloc]initWithFrame:WINDOW_FRAME];
        _scrollView.contentSize = CGSizeMake(WINDOW_SIZE.width*3, WINDOW_SIZE.height);
        _scrollView.contentOffset = CGPointMake(WINDOW_SIZE.width, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        _imageViewArr = imageViewArr;
        //左中右各放一个scrollView,分别显示前一张，当前，后一张图片
        for (int i = 0; i < 3; i ++) {
            UIScrollView *oneScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(WINDOW_SIZE.width*i, 0, WINDOW_SIZE.width, WINDOW_SIZE.height)];
            oneScrollView.tag = i + 1;
            [_scrollView addSubview:oneScrollView];
            oneScrollView.delegate = self;
            oneScrollView.maximumZoomScale = 3;
            UIImageView *oneImage = [[UIImageView alloc]initWithFrame:WINDOW_FRAME];
            oneImage.contentMode = UIViewContentModeScaleAspectFit;
            oneImage.backgroundColor = [UIColor blackColor];
            oneImage.tag = IMAGE_TAG;
            [oneScrollView addSubview:oneImage];
        }
        //显示页数
        _pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WINDOW_SIZE.height-60, WINDOW_SIZE.width, 24)];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.hidden = YES;
        [self addSubview:_pageLabel];
    }
    return self;
}

//是页面显示第n张图片
- (void)showImageWithPage:(int)page
{
    _page = page;
    _pageLabel.text = [NSString stringWithFormat:@"%d/%d",_page,(int)_imageViewArr.count];
    self.frame = ((UIImageView *)_imageViewArr[page-1]).frame;
    CGPoint imageCenter = [self showImagePage:page];
    UIImageView *oneImage = (UIImageView *)[[self viewWithTag:2] viewWithTag:IMAGE_TAG];
    oneImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = WINDOW_FRAME;
        float r = oneImage.image.size.height/oneImage.image.size.width;
        oneImage.bounds = CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.width*r);
        oneImage.center = imageCenter;
    }];
}

//将第n张图片放中间
- (CGPoint)showImagePage:(int)page
{
    UIImageView *centerImage = (UIImageView *)[[_scrollView viewWithTag:2] viewWithTag:IMAGE_TAG];
    UIImageView *leftImage = (UIImageView *)[[_scrollView viewWithTag:1] viewWithTag:IMAGE_TAG];
    UIImageView *rightImage = (UIImageView *)[[_scrollView viewWithTag:3] viewWithTag:IMAGE_TAG];
    
    centerImage.image = ((UIImageView *)_imageViewArr[page-1]).image;

    
    if (page == 1) {
        leftImage.image = ((UIImageView *)[_imageViewArr lastObject]).image;
    }else
        leftImage.image = ((UIImageView *)_imageViewArr[page-2]).image;
    
    if (page == _imageViewArr.count) {
        rightImage.image = ((UIImageView *)[_imageViewArr firstObject]).image;
    }else
        rightImage.image = ((UIImageView *)_imageViewArr[page]).image;
    
    
    NSArray *imageArr = @[leftImage,centerImage,rightImage];
    
    for (int i = 0; i < imageArr.count; i ++) {
        UIImageView *oneImage = imageArr[i];
        float r = oneImage.image.size.height/oneImage.image.size.width;
        oneImage.bounds = CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.width*r);
        UIScrollView *oneScrollView = (UIScrollView *)[oneImage superview];
        oneScrollView.zoomScale = 1;
        float w = WINDOW_SIZE.width/2;
        float h = WINDOW_SIZE.height/2;
        if (w < oneScrollView.contentSize.width/2) {
            w = oneScrollView.contentSize.width/2;
        }
        if (h < oneScrollView.contentSize.height/2) {
            h = oneScrollView.contentSize.height/2;
        }
        oneImage.center = CGPointMake(w, h);
    }
    

    return centerImage.center;
}

//点击页面退出显示
- (void)onTapView
{
    CGRect frame = ((UIImageView *)_imageViewArr[_page-1]).frame;

    //退出浏览动画
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation1.toValue = @(frame.size.width/WINDOW_SIZE.width);

    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation2.toValue = @(frame.size.height/WINDOW_SIZE.height);
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation3.fromValue = 0;
    NSLog(@"%f",frame.origin.x-(WINDOW_SIZE.width/2-frame.size.width/2));
    animation3.toValue = @(frame.origin.x-(WINDOW_SIZE.width/2-frame.size.width/2));
    
    CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation4.fromValue = 0;
    animation4.toValue = [NSNumber numberWithFloat:frame.origin.y-(WINDOW_SIZE.height/2-frame.size.height/2)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.5;
//    group.fillMode = kCAFillModeForwards;
//    group.removedOnCompletion = NO;
    group.animations = @[animation3,animation4,animation1,animation2];
    [self.layer addAnimation:group forKey:nil];

    [self performSelector:@selector(removeScanView) withObject:nil afterDelay:0.49];
}

- (void)removeScanView
{
    [self removeFromSuperview];
    UIScrollView *centerScroll = (UIScrollView *)[_scrollView viewWithTag:2];
    centerScroll.zoomScale = 1;
}

#pragma mark - UIScrollViewDelegate
//开始拽，显示页数
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_imageViewArr.count > 1) {
        _pageLabel.hidden = NO;
        [UIView cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(pageLabelHidden) withObject:nil afterDelay:2];
    }
}

//隐藏页数
- (void)pageLabelHidden
{
    _pageLabel.hidden = YES;
}

//拖拽图片
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        if (scrollView.contentOffset.x ==0||scrollView.contentOffset.x==WINDOW_SIZE.width*2) {
            int n;
            if (scrollView.contentOffset.x<10) {
                n = 1;
                _page --;
                if (_page < 1) {
                    _page = (int)_imageViewArr.count;
                }
            }else
            {
                n = -1;
                _page ++;
                if (_page > _imageViewArr.count) {
                    _page = 1;
                }
            }
            //有页面变化时，将当前显示图片放在中间的scrollView上，将中间的scrollView显示出来，这是循环浏览的关键！
            [self showImagePage:_page];
            _pageLabel.text = [NSString stringWithFormat:@"%d/%d",_page,(int)_imageViewArr.count];
            NSLog(@"%f",WINDOW_SIZE.width);
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+n*WINDOW_SIZE.width, 0);
        }
    }else
    {
        NSLog(@"哈哈哈");
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}

//图片缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *image = (UIImageView *)[scrollView viewWithTag:IMAGE_TAG];
    return image;
}

//图片缩放时调用该方法
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    /*
        此处scrollView.contentSize与scrollView中原有的子视图占有的大小有关
    */
    NSLog(@"%@",NSStringFromCGSize(scrollView.contentSize));
    float w = WINDOW_SIZE.width/2;
    float h = WINDOW_SIZE.height/2;
    if (w<scrollView.contentSize.width/2) {
        w = scrollView.contentSize.width/2;
    }
    if (h < scrollView.contentSize.height/2) {
        h = scrollView.contentSize.height/2;
    }
    UIImageView *imageview = (UIImageView *)[scrollView viewWithTag:IMAGE_TAG];
    imageview.center = CGPointMake(w, h);
}

@end
