//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


#import <objc/runtime.h>
#import "Kiwi.h"
#import "SDReflector.h"
#import "Car.h"
#import "Wheel.h"
#import "Motor.h"

SPEC_BEGIN(SDReflectorSpec)

        describe(@"Reflection", ^{

            it(@"gets the type of a property class", ^{
                id class = [SDReflector getTypeForProperty:@"frontLeftWheel" ofClass:[Car class]];

                [[class should] equal:[Wheel class]];
            });

            it(@"gets the type of a property protocol", ^{
                id protocol = [SDReflector getTypeForProperty:@"motor" ofClass:[Car class]];

                [[protocol should] equal:@protocol(Motor)];
            });

            it(@"raises exeption for unknown property names", ^{
                [[theBlock(^{
                    [SDReflector getTypeForProperty:@"iDoNotExist" ofClass:[Car class]];
                }) should] raiseWithName: @"SDReflectorException"];
            });

            it(@"is a class", ^{
                id o = [Car class];

                [[theValue([SDReflector isClass:o]) should] beYes];
                [[theValue([SDReflector isProtocol:o]) should] beNo];
                [[theValue([SDReflector isInstance:o]) should] beNo];
            });

            it(@"is a protocol", ^{
                id o = @protocol(Vehicle);

                [[theValue([SDReflector isClass:o]) should] beNo];
                [[theValue([SDReflector isProtocol:o]) should] beYes];
                [[theValue([SDReflector isInstance:o]) should] beNo];
            });

            it(@"is an instance", ^{
                id o = [[Car alloc] init];

                [[theValue([SDReflector isClass:o]) should] beNo];
                [[theValue([SDReflector isProtocol:o]) should] beNo];
                [[theValue([SDReflector isInstance:o]) should] beYes];
            });

            it(@"nil is handled correctly", ^{
                id o = nil;

                [[theValue([SDReflector isClass:o]) should] beNo];
                [[theValue([SDReflector isProtocol:o]) should] beNo];
                [[theValue([SDReflector isInstance:o]) should] beNo];
            });

        });

        SPEC_END