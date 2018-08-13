#import <Foundation/Foundation.h>



@interface NIMEncodeDecode : NSObject {

}
+ (void) initialize;
+ (NSString*) encode:(NSData*) rawBytes;
+ (NSData*) decode:(NSString*) string;
@end
