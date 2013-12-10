//
//  PAPlaceApiManager.m
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/5.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import "PAPlaceApiManager.h"
#import "PAPlaceJsonParser.h"

#define PLACE_AUTOCOMPLETE @"https://maps.googleapis.com/maps/api/place/autocomplete/json"
#define PLACE_DETAILS @"https://maps.googleapis.com/maps/api/place/details/json"
#define API_KEY @""

@interface PAPlaceApiManager()

@property NSMutableData *responseData;

@end

@implementation PAPlaceApiManager

- (PAPlaceApiManager *)initWithDelegate:(id<PAPlaceApiDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.responseData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)predictionsWithInput:(NSString *)input
{
    [self requestForPlaceAutoCompleteWithInput:input];
}

- (void)requestForPlaceAutoCompleteWithInput:(NSString *)input
{
    NSURL *placeQueryUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?input=%@&key=%@", PLACE_AUTOCOMPLETE, input, API_KEY]];
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
    NSLog(@"> %s", __PRETTY_FUNCTION__);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"> %s data: %@", __PRETTY_FUNCTION__, [[NSString alloc] initWithData:data
                                                                       encoding:NSUTF8StringEncoding]);
    
    if (data) {
        [self.responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"> %s", __PRETTY_FUNCTION__);
    
    NSArray *predictions = [PAPlaceJsonParser predistionsWithResponseData:self.responseData];
    if (predictions) {
        [self.delegate didReceivePredictions:predictions];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"> %s error: %@", __PRETTY_FUNCTION__, error);
    
    [self.delegate didFailWithError:error];
}

@end
