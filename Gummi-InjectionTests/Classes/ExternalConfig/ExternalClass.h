//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@class Car;
@class Wheel;
@protocol Engine;

@interface ExternalClass : NSObject
@property(nonatomic, strong) Car *car;
@property(nonatomic, strong) Wheel *wheel;
@property(nonatomic) id <Engine> engine;
@end