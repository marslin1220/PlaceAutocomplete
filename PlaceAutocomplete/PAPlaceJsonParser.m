//
//  PAPlaceJsonParser.m
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/6.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import "PAPlaceJsonParser.h"

@implementation PAPlaceJsonParser

+ (NSArray *)predistionsWithResponseData:(NSData *)data
{
    NSMutableArray *predictions = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    return predictions;
}

@end
