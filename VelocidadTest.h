//
//  VelocidadTest.h
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VelocidadTest : NSObject
@property NSInteger speedtest_id;
@property (strong, nonatomic) NSString *date_time;
@property NSInteger conexion;
@property (strong, nonatomic) NSString *proveedor;
@property NSInteger network_type;
@property NSInteger mcc;
@property NSInteger mnc;
@property NSInteger ping;
@property double downloadSpeed;
@property double uploadSpeed;
@property double latitude;
@property double longitude;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *address;
@property NSInteger status;

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *network;
@property (strong, nonatomic) NSString *network_typeString;
@property (strong, nonatomic) NSString *download_speed;
@property (strong, nonatomic) NSString *upload_speed;

- (id)initWithDate: (NSString *)date_ withTime: (NSString *)time_ withNetwork: (NSString *)network_ withNetworkType: (NSString *)network_type withDownloadSpeed: (NSString *)downloadSpeed_ withUploadSpeed: (NSString *)uploadSpeed_;
- (id) initWithId:(NSInteger)id_ withDateTime:(NSString *)datetime_ withConexion:(NSInteger)conexion_ withProveedor:(NSString *)proveedor_ withNetworkType:(NSInteger)networkType_ withMcc:(NSInteger)mcc_ withMnc:(NSInteger)mnc_ withPing:(NSInteger)ping_ withDownloadSpeed:(double)downloadspeed_ withUploadSpeed: (double)uploadSpeed_ withLatitude:(double)latitude_ withLongitude:(double)longitude_ withProvince:(NSString *)province_ withCity:(NSString *)city_ withAddress:(NSString *)address_ withStatus:(NSInteger)status_;
@end
