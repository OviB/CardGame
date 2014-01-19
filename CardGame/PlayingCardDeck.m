//
//  PlayingCardDeck.m
//  CardGame
//
//  Created by Ovi Bortas on 1/16/14.
//  Copyright (c) 2014 Ovi Bortas. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // For each suit go through and create a card for it ("maxRank" is the number of cards per suit)
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc]init];
                card.rank = rank;
                card.suit = suit;
                [self addcard:card];
            }
        }
    }
    
    return self;
}

@end
