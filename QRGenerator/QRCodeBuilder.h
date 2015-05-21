//
//  QRCodeBuilder.h
//  QR
//
//  Created by lijunjie on 5/21/15.
//  Copyright (c) 2015 itlijunjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface QRCodeBuilder : NSObject

+ (NSImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;
//+ (UIImage *)twoDimensionCodeImage:(UIImage *)twoDimensionCode withAvatarImage:(UIImage *)avatarImage;

+ (void )saveImage:(NSImage *)image savePath:(NSString *)savePath;

@end
