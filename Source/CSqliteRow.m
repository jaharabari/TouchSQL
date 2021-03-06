//
//  CSqliteRow.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY 2011 TOXICSOFTWARE.COM ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 2011 TOXICSOFTWARE.COM OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of 2011 toxicsoftware.com.

#import "CSqliteRow.h"

#import "CSqliteStatement.h"

@interface CSqliteRow ()
@property (readonly, nonatomic, weak) CSqliteStatement *statement;
@property (readonly, nonatomic, strong) NSArray *allValues;
@end

#pragma mark -

@implementation CSqliteRow

@synthesize statement;
@synthesize count;
@synthesize allValues;

- (id)initWithStatement:(CSqliteStatement *)inStatement
    {
    if ((self = [super init]) != NULL)
        {
        statement = inStatement;
        NSError *theError = NULL;
        count = [statement columnCount:&theError];
        }
    return self;
    }


- (NSString *)description
    {
    return([NSString stringWithFormat:@"%@ %@", [super description], [[self asDictionary] description]]);
    }


- (NSString *)debugDescription
    {
    return([NSString stringWithFormat:@"%@ %@", [super description], [[self asDictionary] description]]);
    }

- (NSArray *)allValues
    {
    if (allValues == NULL)
        {
        NSError *theError = NULL;

        NSMutableArray *theRow = [NSMutableArray arrayWithCapacity:self.count];
        for (NSUInteger N = 0; N != self.count; ++N)
            {
            id theValue = [self.statement columnValueAtIndex:N error:&theError];
            if (theValue)
                {
                [theRow addObject:theValue];
                }
            }
        allValues = [theRow copy];
        }
    return(allValues);
    }

- (id)valueForKey:(NSString *)aKey
    {
    return([self objectForKey:aKey]);
    }

#pragma mark -

- (BOOL)captureValues:(NSError **)outError;
    {
    [self allValues];
    return(YES);
    }

- (id)objectAtIndex:(NSUInteger)inIndex;
    {
    if (allValues != NULL)
        {
        return([self.allValues objectAtIndex:inIndex]);
        }
    else
        {
        NSError *theError = NULL;
        id theValue = [self.statement columnValueAtIndex:inIndex error:&theError];
        return(theValue);
        }
    }

- (id)objectForKey:(id)aKey
    {
    NSInteger theIndex = [self.statement.columnNames indexOfObject:aKey];
    id theValue = [self objectAtIndex:theIndex];
    if (theValue == [NSNull null])
        {
        theValue = NULL;
        }

    return(theValue);
    }

- (NSArray *)allKeys
    {
    return(self.statement.columnNames);
    }

- (NSDictionary *)asDictionary;
    {
    return([NSDictionary dictionaryWithObjects:self.allValues forKeys:self.allKeys]);
    }

@end
