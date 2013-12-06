//
//  PAPlaceApiManager.m
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/5.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import "PAPlaceApiManager.h"
#import "PAPlaceJsonParser.h"

#define PLACE_AUTOCOMPLETE @"https://maps.googleapis.com/maps/api/place/autocomplete"
#define PLACE_DETAILS @"https://maps.googleapis.com/maps/api/place/details"

@interface PAPlaceApiManager()

@property NSData *responseData;

@end

@implementation PAPlaceApiManager

- (void)predictionsWithInput:(NSString *)input
{
    [self requestForPlaceAutoCompleteWithInput:input];
}

- (void)requestForPlaceAutoCompleteWithInput:(NSString *)input
{
    NSURL *placeQueryUrl = [NSURL URLWithString:PLACE_AUTOCOMPLETE];
    NSURLRequest *request = [NSURLRequest requestWithURL:placeQueryUrl];
    NSURLConnection *connnection = [NSURLConnection connectionWithRequest:request
                                                                 delegate:self];
    
    if (!connnection) {
        NSLog(@"Can not create connection!");
    }
}

#pragma mark Implement NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.responseData = data;
    NSArray *predictions = [PAPlaceJsonParser predistionsWithResponseData:self.responseData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

@end
