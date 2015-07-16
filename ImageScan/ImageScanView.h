//
//  ImageScanView.h
//  ImageScan
//
//  Created by Shipeng on 15/7/1.
//  Copyright (c) 2015年 zhdwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScanView : UIView

- (instancetype)initWithImageArr:(NSArray *)imageViewArr;
- (void)showImageWithPage:(int)page;

@end
