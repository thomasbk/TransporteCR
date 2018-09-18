//
//  RadioButton.m
//  RadioButton
//
//  Created by ohkawa on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIRadioButton.h"
#import "EventMacros.h"
#import "NotificationUtil.h"

@interface UIRadioButton()

-(void)handleButtonTap:(id)sender;

-(void)otherRadioPressed:(NSNotification *)notification;

@end

@implementation UIRadioButton

@synthesize groupId = _groupId;
@synthesize button = _button;

static const NSUInteger kRadioButtonWidth=22;
static const NSUInteger kRadioButtonHeight=22;

#pragma mark - Object Lifecycle

-(id)initWithGroupId:(NSString*)groupId{
    self = [self init];
    
    if (self) {
        self.groupId = groupId;
        
        // Setup container view
        self.frame = CGRectMake(0, 0, kRadioButtonWidth, kRadioButtonHeight);
        
        // Customize UIButton
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0,kRadioButtonWidth, kRadioButtonHeight);
        self.button.adjustsImageWhenHighlighted = NO;
        
        [self.button setImage:[UIImage imageNamed:@"RadioButtonOff"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"RadioButtonOn"] forState:UIControlStateSelected];
        
        [self.button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [NotificationUtil connectNotification:@selector(otherRadioPressed:) toObject:self withNotificationName:RADIO_PRESSED_EVENT];
        
        [self addSubview:self.button];
        
    }
    return  self;
}


- (void)dealloc
{
    
    [NotificationUtil disconectNotification:self withNotificationName:RADIO_PRESSED_EVENT];
     
    
}


- (void)otherRadioPressed:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    NSString * groupId = [dict objectForKey:@"groupId"];
    
    if([groupId isEqualToString:self.groupId])
    {
        [self.button setSelected:false];
    }
}


-(BOOL)selected
{
    return self.button.selected;
}

#pragma mark - Tap handling

-(void)selectButton
{
    [self handleButtonTap:self];
}

-(void)handleButtonTap:(id)sender
{
    NSDictionary *groupIDDict = [NSDictionary dictionaryWithObjectsAndKeys:self.groupId,@"groupId",nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:RADIO_PRESSED_EVENT object:nil userInfo:groupIDDict];
    
    [self.button setSelected:YES];
}

@end
