//
//  Constants.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString * const SERVER_HOST = @"transporte.aresep.go.cr";
//NSString * const SERVER_HOST_NEW = @"novabnk.crnova.com/ARESEP.ServicioWebApi";
//NSString * const SERVER_HOST_NEW = @"dev.aresep.go.cr/WWW/ws.transporte";
NSString * const SERVER_HOST_NEW = @"apps.aresep.go.cr/ws.transporte";



NSString * const KEY64 = @"VDFDMDN4UHIzNTUwMjAxMg==";

NSString * const IMAGE_URL = @"cfmx/ICEPAD/documents/";




//NSString * const VERSION_FILE_PATH = @"http://www.pixel16.com/icepad/icepad.plist";
//
//NSString * const URL_TO_UPDATE = @"http://www.pixel16.com/icepad/index.html";

bool isHTTPS = NO;

bool const doPost = NO;

// Dev Port: 7005
// Prod Port: 80
// SSL Port: 443
//8301
//int const SERVER_PORT = 81;

//CJC Use analitycs
BOOL const USE_ANALYTICS = YES;

@end
