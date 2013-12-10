//
//  PAViewController.m
//  PlaceAutocomplete
//
//  Created by Mars Lin on 2013/12/5.
//  Copyright (c) 2013年 marstudio. All rights reserved.
//

#import "PAViewController.h"
#import "PAPlaceTableViewDelegate.h"

@interface PAViewController ()

@property PAPlaceTableViewDelegate *placeTableViewDelegate;

@end

@implementation PAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.placeTableViewDelegate = [[PAPlaceTableViewDelegate alloc] initWithPlaceTextField:self.placeTextField
                                                                              andTableView:self.placeTableView];
    
    self.placeTableView.hidden = YES;
}

@end
