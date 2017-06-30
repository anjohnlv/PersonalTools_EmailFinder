//
//  URLEmail.m
//  FindEmail
//
//  Created by wdwk on 2017/6/21.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "URLEmail.h"

@implementation URLEmail

-(instancetype)init {
    self = [super init];
    if (self) {
        _state = QueryStateNormal;
        _emails = [NSArray new];
    }
    return self;
}

@end
