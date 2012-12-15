//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <Foundation/Foundation.h>


@interface SDInjector : NSObject
- (id)getObject:(id)classOrProtocol;
- (void)injectIntoObject:(id)object;
- (void)map:(id)whenAskedFor to:(id)use;

@end