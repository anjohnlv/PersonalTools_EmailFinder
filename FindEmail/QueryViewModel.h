//
//  QueryViewModel.h
//  FindEmail
//
//  Created by wdwk on 2017/6/22.
//  Copyright © 2017年 anjohnlv. All rights reserved.
//

#import "BaseViewModel.h"
#import "URLEmail.h"

@interface QueryViewModel : BaseViewModel

-(void)queryFromURLString:(NSString *)urlString  completion:(void (^)(URLEmail *))completion;

@end
