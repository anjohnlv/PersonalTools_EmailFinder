//
//  QueryViewModel.m
//  FindEmail
//
//  Created by wdwk on 2017/6/22.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "QueryViewModel.h"

@implementation QueryViewModel

-(void)queryFromURLString:(NSString *)urlString completion:(void (^)(URLEmail *))completion {
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *htmlSource = [self encode:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self findEmailFromSource:htmlSource completion:^(URLEmail *urlEmail){
                if (!data || [data isKindOfClass:[NSNull class]] || [data length]==0) {
                    urlEmail.state = QueryStateLoadFail;
                }
                urlEmail.urlString = urlString;
                if (completion) {
                    completion(urlEmail);
                }
            }];
        });
    });
}

-(NSString *)encode:(NSData *)data {
    //暴力编码
    NSString * htmlSource = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!htmlSource) {
        htmlSource = [[NSString alloc]initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    }
    return htmlSource;
}

-(void)findEmailFromSource:(NSString *)source completion:(void (^)(URLEmail *))completion {
    URLEmail *urlEmail = [URLEmail new];
    if (!source || [source isKindOfClass:[NSNull class]] || source.length == 0) {
        urlEmail.state = QueryStateEncodeFail;
    }else{
        NSArray *emails = [self arrayWithSouce:source byRegula:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
        urlEmail.emails = emails;
        NSArray *MOBILE = [self arrayWithSouce:source byRegula:@"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$"];
        NSArray *CM = [self arrayWithSouce:source byRegula:@"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$"];
        NSArray *CU = [self arrayWithSouce:source byRegula:@"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$"];
        NSArray *CT = [self arrayWithSouce:source byRegula:@"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$"];
        NSArray *phones = [[[MOBILE arrayByAddingObjectsFromArray:CM]arrayByAddingObjectsFromArray:CU]arrayByAddingObjectsFromArray:CT];
        urlEmail.phones = phones;
    }
    if (completion) {
        completion(urlEmail);
    }
}

-(NSArray *)arrayWithSouce:(NSString *)source byRegula:(NSString *)regulaStr {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    NSMutableArray *array = [NSMutableArray new];
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        NSString* substringForMatch = [source substringWithRange:match.range];
        NSLog(@"%@",substringForMatch);
        if (![array containsObject:substringForMatch]) {
            [array addObject:substringForMatch];
        }
    }
    return array;
}

@end
