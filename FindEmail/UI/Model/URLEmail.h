//
//  URLEmail.h
//  FindEmail
//
//  Created by wdwk on 2017/6/21.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSUInteger, QueryState) {
    QueryStateNormal,
    QueryStateLoadFail,
    QueryStateEncodeFail,
};

@interface URLEmail : BaseModel

@property(nonatomic, strong)NSString *urlString;
@property(nonatomic, strong)NSArray *emails;
@property(nonatomic, strong)NSArray *phones;
@property(nonatomic)QueryState state;

@end
