//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>
#import "ExternalClass.h"

@interface ExternalSubClass : ExternalClass
@property(nonatomic, strong) Wheel *otherWheel;
@property(nonatomic) BOOL opened;
@end