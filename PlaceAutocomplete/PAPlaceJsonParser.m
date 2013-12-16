//
//  PAPlaceJsonParser.m
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/6.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import "PAPlaceJsonParser.h"

@implementation PAPlaceJsonParser

+ (NSDictionary *)jsonWithResponseData:(NSData *)data
{
    NSLog(@"> %s", __PRETTY_FUNCTION__);
    
    if (!data) {
        NSLog(@"> %s !data", __PRETTY_FUNCTION__);
        return nil;
    }
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    
    if (error) {
        NSLog(@"> %s error: %@", __PRETTY_FUNCTION__, error);
        return nil;
    }
    
    if (![NSJSONSerialization isValidJSONObject:jsonObject]) {
        return nil;
    }
    
    if (![[jsonObject objectForKey:@"status"] isEqualToString:@"OK"]) {
        NSLog(@"> %s status: %@", __PRETTY_FUNCTION__, [jsonObject objectForKey:@"status"]);
        
        return nil;
    }
    
    return jsonObject;
}

@end
