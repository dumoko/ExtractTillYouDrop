//
//  SymbolReplacer.m
//  Pandora
//
//  Created by Olegas on 22/08/2015.
//  Copyright (c) 2015 SkyOffice. All rights reserved.
//

#import "SymbolReplacer.h"

@interface SymbolReplacer ()

@property (nonatomic, copy) NSString *stringToReplace;
//@property (nonatomic, copy) NSMutableArray *alreadyReplaced;
//@property (nonatomic, copy) NSRegularExpression *regex;

@end

@implementation SymbolReplacer

#pragma mark - Public Methods

- (instancetype)initWithStringToReplace:(NSString *)stringToReplace {
    self = [super init];
    if (self) {
        _stringToReplace = stringToReplace;
    }
    return self;
}

- (NSRegularExpression *)regex {
    NSString *pattern = @"\\$([a-z]{2})";
    
    return [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
}


- (NSString *)replace {
    return [self replaceAllOccurrencesInString:self.stringToReplace usingRegex:[self regex]];
}


#pragma mark - Private Methods

- (NSString *)replaceAllOccurrencesInString:(NSString *)string usingRegex:(NSRegularExpression *)regex {
    for (NSString *match in [self findMatchingResultsInString:string withRegex:regex]) {
        string = [self stringByReplacingAllInstancesOfMatch:match inString:string];
    }
    
    return string;
}


- (NSString *)stringByReplacingAllInstancesOfMatch:(NSString *)match inString:(NSString *)stringToReplace {
    NSMutableArray *matches = [[NSMutableArray alloc] init];
    if (![matches containsObject:match]) {
        [matches addObject:match];
        return [self stringByReplacingMatch:match inString:stringToReplace];
    }
    
    return stringToReplace;
}


- (NSArray *)findMatchingResultsInString:(NSString *)stringToFind withRegex:(NSRegularExpression *)regex {
    NSMutableArray *matches = [NSMutableArray array];
    for (NSTextCheckingResult *result in [self matchesInString:stringToFind usingRegex:regex]) {
        [matches addObject:[stringToFind substringWithRange:[self firstRangeFromTextCheckingResult:result]]];
    }
    
    return matches;
}


- (NSString *)stringByReplacingMatch:(NSString *)match inString:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:[self replaceTargetForMatch:match]
                                             withString:[self translate:match]];
}


- (NSString *)replaceTargetForMatch:(NSString *)match {
    return [NSString stringWithFormat:@"$%@", match];
}


- (NSArray *)matchesInString:(NSString *)string usingRegex:(NSRegularExpression *)regex {
    return [regex matchesInString:string
                          options:0
                            range:[self rangeOfString:string]];
}


- (NSRange)firstRangeFromTextCheckingResult:(NSTextCheckingResult *)result {
    return [result rangeAtIndex:1];
}


- (NSRange)rangeOfString:(NSString *)string {
    return NSMakeRange(0, string.length);
}


- (NSString *)translate:(NSString *)string {
    return [string uppercaseString];
}

@end
