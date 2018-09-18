#import <Foundation/Foundation.h>


@interface UIPlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, strong) UILabel  *placeHolderLabel;
@property (nonatomic, strong)   NSString *placeholder;
@property (nonatomic, strong) UIColor  *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

-(void)addBorder;

@end