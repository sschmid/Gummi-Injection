//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import <objc/runtime.h>
#import "Kiwi.h"
#import "GIReflector.h"
#import "Car.h"
#import "Wheel.h"
#import "Motor.h"

SPEC_BEGIN(GIReflectorSpec)

        describe(@"Reflection", ^{

            it(@"gets the type of a property class", ^{
                id class = [GIReflector getTypeForProperty:@"leftFrontWheel" ofClass:[Car class]];

                [[class should] equal:[Wheel class]];
            });

            it(@"gets the type of a property protocol", ^{
                id protocol = [GIReflector getTypeForProperty:@"motor" ofClass:[Car class]];

                [[protocol should] equal:@protocol(Motor)];
            });

            it(@"raises exeption for unknown property names", ^{
                [[theBlock(^{
                    [GIReflector getTypeForProperty:@"iDoNotExist" ofClass:[Car class]];
                }) should] raiseWithName:@"GIReflectorException"];
            });

            it(@"is a class", ^{
                id o = [Car class];

                [[theValue([GIReflector isClass:o]) should] beYes];
                [[theValue([GIReflector isProtocol:o]) should] beNo];
                [[theValue([GIReflector isInstance:o]) should] beNo];
            });

            it(@"is a protocol", ^{
                id o = @protocol(Vehicle);

                [[theValue([GIReflector isClass:o]) should] beNo];
                [[theValue([GIReflector isProtocol:o]) should] beYes];
                [[theValue([GIReflector isInstance:o]) should] beNo];
            });

            it(@"is an instance", ^{
                id o = [[Car alloc] init];

                [[theValue([GIReflector isClass:o]) should] beNo];
                [[theValue([GIReflector isProtocol:o]) should] beNo];
                [[theValue([GIReflector isInstance:o]) should] beYes];
            });

            it(@"nil is handled correctly", ^{
                id o = nil;

                [[theValue([GIReflector isClass:o]) should] beNo];
                [[theValue([GIReflector isProtocol:o]) should] beNo];
                [[theValue([GIReflector isInstance:o]) should] beNo];
            });

        });

        SPEC_END