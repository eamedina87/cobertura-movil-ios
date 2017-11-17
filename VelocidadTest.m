//
//  VelocidadTest.m
//  CoberturaMovilIOS
//
//  Created by Supertel on 06/10/14.
//  Copyright (c) 2014 Superintendencia de Telecomunicaciones. All rights reserved.
//

#import "VelocidadTest.h"

@implementation VelocidadTest

- (id) initWithDate:(NSString *)date_ withTime:(NSString *)time_ withNetwork:(NSString *)network_ withNetworkType:(NSString *)network_type withDownloadSpeed:(NSString *)downloadSpeed_ withUploadSpeed:(NSString *)uploadSpeed_{
    self = [super init];
    if (self){
        self.date = date_;
        self.time = time_;
        self.network = network_;
        self.network_typeString = network_type;
        self.download_speed = downloadSpeed_;
        self.upload_speed = uploadSpeed_;
        
        self.speedtest_id = -1;
        self.date_time = @"-1";
        self.conexion = -1;
        self.proveedor = @"default";
        self.network_type = -1;
        self.mcc = -1;
        self.mnc = -1;
        self.downloadSpeed = -1.0;
        self.uploadSpeed = -1.0;
        self.latitude = 900;
        self.longitude = 900;
        self.province = @"default";
        self.city = @"default";
        self.address = @"default";
        self.status = 0;
    }
    return self;
}

- (id) initWithId:(NSInteger)id_ withDateTime:(NSString *)datetime_ withConexion:(NSInteger)conexion_ withProveedor:(NSString *)proveedor_ withNetworkType:(NSInteger)networkType_ withMcc:(NSInteger)mcc_ withMnc:(NSInteger)mnc_ withPing:(NSInteger)ping_ withDownloadSpeed:(double)downloadspeed_ withUploadSpeed: (double)uploadSpeed_ withLatitude:(double)latitude_ withLongitude:(double)longitude_ withProvince:(NSString *)province_ withCity:(NSString *)city_ withAddress:(NSString *)address_ withStatus:(NSInteger)status_{
    self = [super init];
    if (self){
        self.speedtest_id = id_;
        self.date_time = datetime_;
        self.conexion = conexion_;
        self.proveedor = proveedor_;
        self.network_type = networkType_;
        self.mcc = mcc_;
        self.mnc = mnc_;
        self.ping = ping_;
        self.downloadSpeed = downloadspeed_;
        self.uploadSpeed = uploadSpeed_;
        self.latitude = latitude_;
        self.longitude = longitude_;
        self.province = province_;
        self.city = city_;
        self.address = address_;
        self.status = status_;
    }
    return self;
}

@end
