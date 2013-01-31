//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GIInjector.h"
#import "BagOfBalls.h"
#import "Ball.h"
#import "OtherBall.h"

SPEC_BEGIN(RobotlegsSpec)

        describe(@"Robotlegs", ^{

            __block GIInjector *injector;
            beforeEach(^{
                injector = [[GIInjector alloc] init];
            });

            it(@"instantiates an injector", ^{
                [[injector should] beKindOfClass:[GIInjector class]];
            });

            it(@"returns instance with custom initializer (flavour 1)", ^{
                [injector setDefaultInitializer:@selector(initAlternative) forClass:[Ball class]];
                Ball *ball = [injector getObject:[Ball class]];

                [[ball should] beKindOfClass:[Ball class]];
                [[ball.color should] equal:@"green"];
            });

            it(@"returns instance with custom initializer (flavour 2)", ^{
                Ball *ball = [injector getObject:[OtherBall class]];

                [[ball should] beKindOfClass:[OtherBall class]];
                [[ball.color should] equal:@"green"];
            });

            it(@"return object with custom args", ^{
//                [injector setDefaultInitializer:@selector(initWithColor:) forClass:[Ball class]];
//                Ball *ball = [injector getObjectWithArgs:[Ball class], @"red"];
//
//                [[ball.color should] equal:@"red"];
            });

            context(@"when class mapped", ^{

                beforeEach(^{
                    [injector map:[Ball class] to:[Ball class]];
                    [injector map:[OtherBall class] to:[OtherBall class]];
                });

                it(@"returns instance with custom initializer (flavour 1)", ^{
                    [injector setDefaultInitializer:@selector(initAlternative) forClass:[Ball class]];
                    Ball *ball = [injector getObject:[Ball class]];

                    [[ball should] beKindOfClass:[Ball class]];
                    [[ball.color should] equal:@"green"];
                });

                it(@"returns instance with custom initializer (flavour 2)", ^{
                    Ball *ball = [injector getObject:[OtherBall class]];

                    [[ball should] beKindOfClass:[OtherBall class]];
                    [[ball.color should] equal:@"green"];
                });

            });

        });

        SPEC_END