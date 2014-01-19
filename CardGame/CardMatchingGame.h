//
//  CardMatchingGame.h
//  CardGame
//
//  Created by Ovi Bortas on 1/16/14.
//  Copyright (c) 2014 Ovi Bortas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic,readonly) NSInteger score;
@property (nonatomic) NSUInteger gameType;

// Designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count fromDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

- (NSArray *)matchHistory;


@end
