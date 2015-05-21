//
//  QRCodeBuilder.m
//  QR
//
//  Created by lijunjie on 5/21/15.
//  Copyright (c) 2015 itlijunjie. All rights reserved.
//

#import "QRCodeBuilder.h"
#include "qrencode.h"

#define qrMargin 5
@implementation QRCodeBuilder

+ (void)drawQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size {
    unsigned char *data = 0;
    int width;
    data = code->data;
    width = code->width;
    float zoom = (double)size / (code->width + 2.0 * qrMargin);
    CGRect rectDraw =CGRectMake(0, 0, zoom, zoom);
    
    CGContextSetFillColor(ctx,CGColorGetComponents([NSColor blackColor].CGColor));
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin =CGPointMake((j + qrMargin) * zoom,(i +qrMargin) * zoom);
                CGContextAddRect(ctx, rectDraw);
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
}

+ (NSImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size {
    if (![string length]) {
        return nil;
    }
    
    QRcode *code =QRcode_encodeString([string UTF8String], 0,QR_ECLEVEL_L, QR_MODE_8, 1);
    if (!code) {
        return nil;
    }
    
    // create context
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx =CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace,kCGImageAlphaPremultipliedLast);
    
    CGAffineTransform translateTransform =CGAffineTransformMakeTranslation(0, -size);
    CGAffineTransform scaleTransform =CGAffineTransformMakeScale(1, -1);
    CGContextConcatCTM(ctx,CGAffineTransformConcat(translateTransform, scaleTransform));
    
    // draw QR on this context
    [self drawQRCode:code context:ctx size:size];
    
    // get image
    CGImageRef qrCGImage =CGBitmapContextCreateImage(ctx);
    NSImage * qrImage = [[NSImage alloc] initWithCGImage:qrCGImage size:NSMakeSize(size, size)];
    
    // some releases
    CGContextRelease(ctx);
    CGImageRelease(qrCGImage);
    CGColorSpaceRelease(colorSpace);
    QRcode_free(code);
    
    return qrImage;
}

+ (void )saveImage:(NSImage *)image savePath:(NSString *)savePath
{
    [image lockFocus];
    //先设置 下面一个实例
    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc]initWithFocusedViewRect:NSMakeRect(0, 0, 300, 300)];        //138.32为图片的长和宽
    [image unlockFocus];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:NSImageCompressionFactor];
    NSData *imageData = [bits representationUsingType:NSPNGFileType properties:imageProps];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[savePath stringByDeletingLastPathComponent]]) {
        NSLog(@"路径%@不存在！",[savePath stringByDeletingLastPathComponent]);
    } else {
        BOOL y = [imageData writeToFile:[[NSString stringWithString:savePath] stringByExpandingTildeInPath] atomically:YES];
        NSLog(@"Save Image: %d", y);
    }
    
}

//+ (UIImage *)twoDimensionCodeImage:(UIImage *)twoDimensionCode withAvatarImage:(UIImage *)avatarImage {
//    // two-dimension code 二维码
//    CGSize size = twoDimensionCode.size;
//    CGSize size2 =CGSizeMake(1.0 / 5.5 * size.width, 1.0 / 5.5 * size.height);
//    
//    UIGraphicsBeginImageContext(size);
//    
//    [twoDimensionCode drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    [[self avatarImage:avatarImage] drawInRect:CGRectMake((size.width - size2.width) / 2.0, (size.height - size2.height) / 2.0, size2.width, size2.height)];
//    
//    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return resultingImage;
//}
//
//+ (UIImage *) avatarImage:(UIImage *)avatarImage{
//    UIImage * avatarBackgroudImage = [UIImage imageNamed:@"群主召唤"];
//    CGSize size = avatarBackgroudImage.size;
//    UIGraphicsBeginImageContext(size);
//    
//    [avatarBackgroudImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    [avatarImage drawInRect:CGRectMake(0, 0, size.width - 0, size.height - 0)];
//    
//    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return resultingImage;
//}

@end
