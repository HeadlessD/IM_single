#import <Foundation/Foundation.h>

@protocol IProcessor <NSObject>
@required
// $_FUNCTION_BEGIN ******************************
// NAME:    ProcessEvent
// PARAM:   NONE
// RETURN:  VOID
// DETAIL:  each processor need inherit this interface
// $_FUNCTION_END ********************************
-(void) processEvent;
@optional
@end
