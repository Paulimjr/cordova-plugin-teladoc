#import <UIKit/UIKit.h>

@implementation UIColor (Utilities)

+(UIColor *)colorWithHexString:(NSString *)colorString
{
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@""];

    if (colorString.length == 3)
        colorString = [NSString stringWithFormat:@"%c%c%c%c%c%c",
        [colorString characterAtIndex:0], [colorString characterAtIndex:0],
        [colorString characterAtIndex:1], [colorString characterAtIndex:1],
        [colorString characterAtIndex:2], [colorString characterAtIndex:2]];

    if (colorString.length == 6)
    {
        int r, g, b;
        sscanf([colorString UTF8String], "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
    }
    return nil;
}

@end