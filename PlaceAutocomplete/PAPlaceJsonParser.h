//
//  PAPlaceJsonParser.h
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/6.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAPlaceJsonParser : NSObject

+ (NSDictionary *)jsonWithResponseData:(NSData *)data;

@end
