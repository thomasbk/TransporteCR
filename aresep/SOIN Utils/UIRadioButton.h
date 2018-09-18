

#import <UIKit/UIKit.h>

@interface UIRadioButton : UIView {

}

@property(nonatomic,copy)NSString *groupId;
@property(nonatomic,strong)UIButton * button;

-(id)initWithGroupId:(NSString*)groupId;

-(BOOL)selected;

-(void)selectButton;

@end
