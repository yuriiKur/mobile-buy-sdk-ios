//
//  NSDecimalNumber+BUYAdditions.m
//  Mobile Buy SDK
//
//  Created by Shopify on 2014-09-15.
//  Copyright (c) 2014 Shopify Inc. All rights reserved.
//

#import "NSDecimalNumber+BUYAdditions.h"

@implementation NSDecimalNumber (BUYAdditions)

+ (NSDecimalNumber*)buy_decimalNumberOrZeroWithString:(NSString*)string
{
	NSDecimalNumber *decimalNumber = nil;
	if (string) {
		decimalNumber = [NSDecimalNumber decimalNumberWithString:string];
	}
	
	if (decimalNumber == nil || decimalNumber == [NSDecimalNumber notANumber]) {
		decimalNumber = [NSDecimalNumber zero];
	}
	return decimalNumber;
}

+ (NSDecimalNumber*)buy_decimalNumberFromJSON:(id)valueFromJSON
{
	static NSDecimalNumberHandler *numberHandler;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		numberHandler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundBankers scale:12 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
	});
	
	NSDecimalNumber *decimalNumber = nil;
	if (valueFromJSON == nil || [valueFromJSON isKindOfClass:[NSNull class]]) {
		decimalNumber = nil;
	}
	else if ([valueFromJSON isKindOfClass:[NSString class]]) {
		decimalNumber = [NSDecimalNumber buy_decimalNumberOrZeroWithString:valueFromJSON];
	}
	else if ([valueFromJSON isKindOfClass:[NSDecimalNumber class]]) {
		decimalNumber = valueFromJSON;
	}
	else if ([valueFromJSON isKindOfClass:[NSNumber class]]) {
		NSDecimal decimal = [(NSNumber*)valueFromJSON decimalValue];
		decimalNumber = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	}
	else {
		decimalNumber = nil;
		NSLog(@"Could not create decimal value: %@", valueFromJSON);
	}
	
	return [decimalNumber decimalNumberByRoundingAccordingToBehavior:numberHandler];
}

- (NSDecimalNumber*)buy_decimalNumberAsNegative
{
	return [self decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:YES]];
}

@end
