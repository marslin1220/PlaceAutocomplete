//
//  PAPlaceTableViewDelegate.m
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/5.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import "PAPlaceTableViewDelegate.h"
#import "PAPlaceApiManager.h"

@interface PAPlaceTableViewDelegate()

@property UITableView *placeTableView;
@property UITextField *placeTextField;
@property PAPlaceApiManager *placeApiManager;

@end

@implementation PAPlaceTableViewDelegate

- (PAPlaceTableViewDelegate *)initWithPlaceTextField:(UITextField *)textField andTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.placeTextField = textField;
        self.placeTextField.delegate = self;
        self.placeTableView = tableView;
        self.placeTableView.delegate = self;
        self.placeTableView.dataSource = self;
        self.placeApiManager = [[PAPlaceApiManager alloc] initWithDelegate:self];
    }
    
    return self;
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    if ([substring isEqualToString:@""]) {
        self.placeTableView.hidden = YES;
        
        return YES;
    }
    
    [self.placeApiManager predictionsWithInput:substring];
    
    return YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    return [self.predictions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    cell.textLabel.text = [[self.predictions objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.placeTextField.text = selectedCell.textLabel.text;
    
    self.placeTableView.hidden = YES;
    
    NSString *placeReference = [[self.predictions objectAtIndex:indexPath.row] objectForKey:@"reference"];
    [self.placeApiManager resultWithReference:placeReference];
}

#pragma mark PAPlaceApiDelegate methods

- (void)didFailWithError:(NSError *)error
{
    self.placeTableView.hidden = YES;
    NSLog(@"> %s error: %@", __PRETTY_FUNCTION__, error);
}

- (void)didReceivePredictions:(NSArray *)predictions
{
    NSLog(@"> %s", __PRETTY_FUNCTION__);
    
    self.predictions = predictions;
    
    if (self.predictions) {
        self.placeTableView.hidden = NO;
        [self.placeTableView reloadData];
    }
    else {
        self.placeTableView.hidden = YES;
    }
}

- (void)didReceiveResult:(NSDictionary *)result
{
    NSLog(@"> %s result: %@", __PRETTY_FUNCTION__, [result description]);
}

@end
