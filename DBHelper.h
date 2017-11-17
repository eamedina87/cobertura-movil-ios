//
//  DBHelper.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 08/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "VelocidadTest.h"

@interface DBHelper : NSObject
{
    NSString *dbPath;
}
+ (DBHelper*) getSharedInstance;
- (BOOL) createDB;
- (BOOL) insertTest: (VelocidadTest*) test;
- (VelocidadTest *) getTestById: (int) testId;
- (NSMutableArray *) getAllTests;
@end
