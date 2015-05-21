//
//  main.m
//  QRGenerator
//
//  Created by lijunjie on 5/21/15.
//  Copyright (c) 2015 itlijunjie. All rights reserved.
//

#define kQRParamHelp @"-help"
#define kQRParamContent @"-content"
#define kQRParamOutpath @"-outpath"

#import <Foundation/Foundation.h>
#import "QRCodeBuilder.h"

void help()
{
    NSLog(@"简单的命令行工具：实例./QRGenerator -outpath ~/Desktop/test.png -content http://www.baidu.com");
}

BOOL isCommandParam(NSString *param)
{
    BOOL res = NO;
    if ([param isEqualToString:kQRParamHelp]){
        res = YES;
    } else if([param isEqualToString:kQRParamContent]) {
        res = YES;
    } else if([param isEqualToString:kQRParamOutpath]) {
        res = YES;
    }
    return res;
}

BOOL isNotValuePatam(NSString *param)
{
    BOOL res = NO;
    if ([param isEqualToString:kQRParamHelp]) {
        res = YES;
    }
    return res;
}

void error()
{
    NSLog(@"参数错误！");
    help();
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            help();
            return 0;
        }
        
        NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < argc; i++) {
            if (i == 0) {
                continue;
            }
            NSString *str = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
            if (isCommandParam(str)) {
                if (isNotValuePatam(str)) {
                    [args setObject:@"" forKey:str];
                } else {
                    if ((i + 1) < argc) {
                        NSString *value = [NSString stringWithCString:argv[i + 1] encoding:NSUTF8StringEncoding];
                        if (isCommandParam(value)) {
                            error();
                            return 0;
                        } else {
                            [args setObject:[NSString stringWithCString:argv[i + 1] encoding:NSUTF8StringEncoding] forKey:str];
                        }
                    } else {
                        error();
                        return 0;
                    }
                }
            }
        }
        
        if ([args count] == 1) {
            if ([args objectForKey:kQRParamHelp]) {
                help();
                return 0;
            } else {
                error();
                return 0;
            }
        }
        
        NSString *outpath = [args objectForKey:kQRParamOutpath];
        NSString *content = [args objectForKey:kQRParamContent];
        if (outpath && content) {
            NSImage *res = [QRCodeBuilder qrImageForString:content imageSize:300];
            [QRCodeBuilder saveImage:res savePath:outpath];
        } else {
            NSLog(@"参数错误！");
            help();
            return 0;
        }
    }
    return 0;
}
