//
//  CSqliteDatabase_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on Tue Apr 27 2004.
//  Copyright 2004 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CSqliteDatabase_Extensions.h"

#import "CSqliteStatement.h"
#import "CSqliteRow.h"

@implementation CSqliteDatabase (CSqliteDatabase_Extensions)

- (BOOL)executeExpression:(NSString *)inExpression error:(NSError **)outError
    {
    CSqliteStatement *theStatement = [self statementWithString:inExpression];
    return([theStatement execute:outError]);
    }

- (NSEnumerator *)enumeratorForExpression:(NSString *)inExpression error:(NSError **)outError
    {
    CSqliteStatement *theStatement = [self statementWithString:inExpression];
    return([theStatement enumerator]);
    }

- (NSArray *)rowsForExpression:(NSString *)inExpression error:(NSError **)outError
    {
    CSqliteStatement *theStatement = [self statementWithString:inExpression];
    return([theStatement rows:outError]);
    }

- (CSqliteRow *)rowForExpression:(NSString *)inExpression error:(NSError **)outError
    {
    CSqliteStatement *theStatement = [self statementWithString:inExpression];
    [theStatement step:outError];
    CSqliteRow *theRow = [theStatement row:outError];
    return(theRow);
    }

- (NSArray *)valuesForExpression:(NSString *)inExpression error:(NSError **)outError
    {
    CSqliteRow *theRow = [self rowForExpression:inExpression error:outError];
    return([theRow allValues]);
    }

- (id)valueForExpression:(NSString *)inExpression error:(NSError **)outError
    {
    NSArray *theValues = [self valuesForExpression:inExpression error:outError];
    // TODO -- check only 1 object is returned?
    return([theValues lastObject]);
    }

@end
