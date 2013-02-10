//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import <Foundation/Foundation.h>

@interface OtherBall : NSObject
@property(nonatomic, copy) NSString *color;

- (id)initAlternative;
- (id)initWithColor:(NSString *)color;
@end