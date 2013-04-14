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
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (card && !card.isUnplayable) {
        // loop through all other cards looking for any others that are
        // face up and still playable
        for (Card *otherCard in self.cards) {
            if (otherCard.isFaceUp && otherCard.isUnplayable) {
                int matchScore = [card match:@[otherCard]];
                if (matchScore) {
                    card.unplayable = YES;
                    otherCard.unplayable = YES;
                    self.score += matchScore * MATCH_BONUS;
                } else {
                    card.faceUp = NO;
                    otherCard.faceUp = NO;
                    self.score -= MISMATCH_PENALTY;
                }
                break;
            }
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
