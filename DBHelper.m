//
//  DBHelper.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 08/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import "DBHelper.h"
static DBHelper *sharedInstance = nil;
static sqlite3 *db = nil;
static sqlite3_stmt *st = nil;

@implementation DBHelper

+ (DBHelper *) getSharedInstance
{

    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

- (BOOL) createDB
{
    dbPath = [self getDBPath];
    BOOL isSuccess = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbPath] == NO)
    {
        const char *dbpath_char = [dbPath UTF8String];
        if (sqlite3_open(dbpath_char, &db) == SQLITE_OK)
        {
            char *errorMsg;
            const char *sql_stmt = "create table if not exists speedtests (speedtest_id integer primary key, date_time text, conexion integer, proveedor text, network_type integer, mcc integer, mnc integer, ping integer, download_speed double, upload_speed double, latitude double, longitude double, province text, city text, address text, status integer)";
            if (sqlite3_exec(db, sql_stmt, NULL, NULL, &errorMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"DB not created");
            }
            sqlite3_close(db);
            NSLog(@"DB created");
            return isSuccess;
        }
        else
        {
            isSuccess = NO;
            NSLog(@"Fallo al abrir/crear la DB");
        }
    }
    return isSuccess;
}

- (BOOL) insertTest:(VelocidadTest *)test
{
    bool returnBool = NO;
    dbPath = [self getDBPath];
    const char *dbpath_char = [dbPath UTF8String];
    if (sqlite3_open(dbpath_char, &db) == SQLITE_OK)
    {
        NSString *sqlInsert = [NSString stringWithFormat:@"insert into speedtests (date_time, conexion, proveedor, network_type, mcc, mnc, ping, download_speed, upload_speed, latitude, longitude, province, city, address, status) values (%@, %ld, \"%@\", %ld, %ld, %ld, %ld, %f, %f, %f, %f, \"%@\", \"%@\", \"%@\", %ld)", test.date_time, (long)test.conexion, test.proveedor, (long)test.network_type, (long)test.mcc, (long)test.mnc, (long)test.ping, test.downloadSpeed, test.uploadSpeed, test.latitude, test.longitude, test.province, test.city, test.address, (long)test.status];
        const char *sqlStatement = [sqlInsert UTF8String];
        sqlite3_prepare_v2(db, sqlStatement, -1, &st, NULL);
        if (sqlite3_step(st) == SQLITE_DONE)
        {
            returnBool = YES;
        }
        sqlite3_reset(st);
        sqlite3_close(db);
    }
    return returnBool;
}

- (NSMutableArray *) getAllTests
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    dbPath = [self getDBPath];
    const char *dbpath_char = [dbPath UTF8String];
    if (sqlite3_open(dbpath_char, &db) == SQLITE_OK )
    {
        NSString *querySQL = @"select * from speedtests order by date_time desc";
        const char *query_stmt = [querySQL UTF8String];
//        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        if (sqlite3_prepare_v2(db, query_stmt, -1, &st, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(st) == SQLITE_ROW)
            {
                VelocidadTest *tmp = [[VelocidadTest alloc] initWithId:sqlite3_column_int(st, 0) withDateTime:[[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(st, 1)] withConexion:sqlite3_column_int(st, 2) withProveedor:[[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(st, 3)] withNetworkType:sqlite3_column_int(st, 4) withMcc:sqlite3_column_int(st, 5) withMnc:sqlite3_column_int(st, 6) withPing:sqlite3_column_int(st, 7) withDownloadSpeed:sqlite3_column_double(st, 8) withUploadSpeed:sqlite3_column_double(st, 9) withLatitude:sqlite3_column_double(st, 10) withLongitude:sqlite3_column_double(st, 11) withProvince:[[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(st, 12)] withCity: [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(st, 13)] withAddress: [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(st, 14)] withStatus:sqlite3_column_int(st, 15)];
                [array addObject:tmp];
            }
            sqlite3_reset(st);
        }
        sqlite3_close(db);
    }
    return array;
}


- (NSString *) getDBPath
{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    //Build the path to the database file
    return [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"supertel.db"]];

}
@end
