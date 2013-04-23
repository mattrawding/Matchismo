//
//  PlayingCard.m
//  Matchismo
//
//  Created by Matthew Rawding on 4/11/13.
//  Copyright (c) 2013 Matthew Rawding. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        // two card mode
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    } else if ([otherCards count] == 2) {
        // three card mode
        BOOL suitMatch = YES;
        BOOL rankMatch = YES;
        
        for (PlayingCard *otherCard in otherCards) {
            if (![otherCard.suit isEqualToString:self.suit]) {
                suitMatch = NO;
            }
            if (otherCard.rank != self.rank) {
                rankMatch = NO;
            }
        }
        
        if (rankMatch) {
            score = 100;
        } else if (suitMatch) {
            score = 5;
        }
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter AND getter + (NSArray *)validSuits { ￼ }

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank {
    return [self rankStrings].count-1;
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *)description
{
    return self.contents;
}

@end
