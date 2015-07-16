//
//  ViewController.m
//  ImageScan
//
//  Created by Shipeng on 15/7/1.
//  Copyright (c) 2015年 zhdwl. All rights reserved.
//

#import "ViewController.h"
#import "ImageScanView.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *imageViewArr;
@property (strong, nonatomic) ImageScanView *scanView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageViewArr = [[NSMutableArray alloc]initWithCapacity:0];
    float w = (self.view.frame.size.width-80)/3;
    for (int i = 0; i < 5; i ++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(i%3*(w+20)+20, i/3*(w+20)+20, w, w)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",i+1]];
        image.userInteractionEnabled = YES;
        image.clipsToBounds = YES;
        image.tag = i + 1;
        image.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapImage:)];
        [image addGestureRecognizer:tap];
        [self.view addSubview:image];
        [_imageViewArr addObject:image];
    }
    _scanView = [[ImageScanView alloc]initWithImageArr:_imageViewArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击图片
- (void)onTapImage:(UITapGestureRecognizer *)tap
{
    [self.view addSubview:_scanView];
    [_scanView showImageWithPage:(int)tap.view.tag];
}

@end
