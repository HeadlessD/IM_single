//
//  NIMAppARCDefines.h
//  QianbaoIM
//
//  Created by fengsh on 7/4/15.
//  Copyright (c) 2015年 fengsh. All rights reserved.
//
/**
 *  对ARC与非ARC进行处理。主要是过滤老代码用，新开发代码统一使用ARC编译就不需要进行宏处理了。
 */

#ifndef QianbaoIM_NIMAppARCDefines_h
#define QianbaoIM_NIMAppARCDefines_h

#define RELEASE_SAFELY(__POINTER) do{  __POINTER = nil; } while(0)
#define INVALIDATE_TIMER(__TIMER) do{ [__TIMER invalidate]; RELEASE_SAFELY(__TIMER); } while(0)
#define RELEASE_SUPER_DEALLOC     do{  } while(0)

#define RELEASE_SAFELY_NILDELEGATE(__POINTER__) \
do{  \
if([__POINTER__ respondsToSelector:@selector(delegate)])\
{\
[__POINTER__ performSelector:@selector(setDelegate:) withObject:nil];\
}\
RELEASE_SAFELY(__POINTER__);\
} while(0)

///ARC
#if __has_feature(objc_arc)
    #define _IM_RETAIN(x) (x)
    #define _IM_RELEASE(x)
    #define _IM_RELEASE_SAFELY(__POINTER) do{ __POINTER = nil; } while(0)
    #define _IM_INVALIDATE_TIMER(__TIMER) do{ [__TIMER invalidate]; __TIMER = nil; } while(0)
    #define _IM_AUTORELEASE(x) (x)
    #define _IM_BLOCK_COPY(x) (x)
    #define _IM_BLOCK_RELEASE(x)
    #define _IM_SUPER_DEALLOC()
    #define _IM_AUTORELEASE_POOL_START() @autoreleasepool {
    #define _IM_AUTORELEASE_POOL_END() }
#else
    #define _IM_RETAIN(x) ([(x) retain])
    #define _IM_RELEASE(x) ([(x) release])
    #define _IM_RELEASE_SAFELY(__POINTER) do{ [__POINTER release]; __POINTER = nil; } while(0)
    #define _IM_INVALIDATE_TIMER(__TIMER) do{ [__TIMER invalidate];[__TIMER release]; __TIMER = nil; } while(0)
    #define _IM_AUTORELEASE(x) ([(x) autorelease])
    #define _IM_SUPER_DEALLOC() ([super dealloc])
    #define _IM_AUTORELEASE_POOL_START() NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    #define _IM_AUTORELEASE_POOL_END() [pool release];
#endif

#ifndef _IM_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define _IM_INSTANCETYPE instancetype
#else
#define _IM_INSTANCETYPE id
#endif
#endif

#ifndef _IM_STRONG
#if __has_feature(objc_arc)
#define _IM_STRONG strong
#else
#define _IM_STRONG retain
#endif
#endif


#define _PROPERTY_NONATOMIC_RETAIN(__class__, __property__)\
@property (nonatomic, _IM_STRONG)__class__  * __property__;

#define _PROPERTY_NONATOMIC_READONLY(__class__, __property__)\
@property(nonatomic, readonly)__class__   __property__;

#define _PROPERTY_NONATOMIC_ASSIGN(__class__, __property__)\
@property (nonatomic, assign)__class__  __property__;

#define _PROPERTY_NONATOMIC_COPY(__class__, __property__)\
@property (nonatomic, copy)__class__  *__property__;

#define _PROPERTY_NONATOMIC_WEAK(__class__, __property__)\
@property (nonatomic, weak)__class__  *__property__;

#define _PROPERTY_NONATOMIC_STRINGSTRONG(__property__)\
@property (nonatomic, _IM_STRONG) NSString *__property__;

#endif


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
