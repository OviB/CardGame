//
//  PlayingCard.h
//  CardGame
//
//  Created by Ovi Bortas on 1/16/14.
//  Copyright (c) 2014 Ovi Bortas. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic,strong) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
