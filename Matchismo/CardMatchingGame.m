//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Matthew Rawding on 4/14/13.
//  Copyright (c) 2013 Matthew Rawding. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString *status;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    self.status = @"New game started";
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    //NSLog(@"%@", [@"three card matching: " stringByAppendingString:(self.isThreeCardMatch ? @"TRUE" : @"FALSE")]);
    
    Card *card = [self cardAtIndex:index];
    if (card && !card.isUnplayable) {
        
        BOOL otherCardsFlipped = NO;
        
        if (!card.isFaceUp) {
            // only look for a match when we are flipping the card to face up
    
            // Build an array of other face up cards
            // used in 2 card and 3 card match mode
            NSMutableArray *faceUpCards = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if ( otherCard.isFaceUp && !otherCard.isUnplayable) {
                    otherCardsFlipped = YES;
                    [faceUpCards addObject:otherCard];
                }
            }
            
            if (self.isThreeCardMatch) {
                // 3 card match mode
                // only look for a match when this is the 3rd card we're flipping
                if ([faceUpCards count] == 2) {
                    NSLog(@"%@", [NSString stringWithFormat:@"Checking for 3 card match"]);
                    
                    int matchScore = [card match:faceUpCards];
                    if (matchScore) {
                        card.unplayable = YES;
                        for (Card *otherCard in faceUpCards) {
                            otherCard.unplayable = YES;
                        }
                        self.score += matchScore * MATCH_BONUS;
                        
                        [faceUpCards addObject:card];
                        self.status = [@"Match!: " stringByAppendingString:[faceUpCards componentsJoinedByString:@" "]];
                    } else {
                        for (Card *otherCard in faceUpCards) {
                            otherCard.faceUp = NO;
                        }
                        self.score -= MISMATCH_PENALTY;
                        
                        [faceUpCards addObject:card];
                        self.status = [@"No match: " stringByAppendingString:[faceUpCards componentsJoinedByString:@" "]];
                    }
                }
            } else {
                // 2 card match mode
                
                if ([faceUpCards count] == 1) {
                    Card *otherCard = [faceUpCards lastObject];
                    
                    int matchScore = [card match:faceUpCards];
                    if (matchScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.status = [@[@"Matched", card.contents, @"&", otherCard.contents, @"for", [NSString stringWithFormat:@"%i", matchScore * MATCH_BONUS], @"points"] componentsJoinedByString:@" "];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.status = [@[card.contents, @"and", otherCard.contents, @"don't match!", [NSString stringWithFormat:@"%i", MISMATCH_PENALTY], @"point penalty!"] componentsJoinedByString:@" "];
                    }
                }
            }
            self.score -= FLIP_COST;
            
            if (!otherCardsFlipped || (self.isThreeCardMatch && [faceUpCards count] == 1)){
                self.status = [@"Flipped up " stringByAppendingString:card.contents];
            }
        } else {
            // we are turning the card face down
            self.status = [@"Flipped down " stringByAppendingString:card.contents];
        }
        
        card.faceUp = !card.isFaceUp;
    }
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

@end
