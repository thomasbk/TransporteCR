//
//  SoinWS.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 20/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"

@protocol SoinWSDelegate<NSObject>
- (void)answerReceived:(NSDictionary *)result;
- (void)connectionFailed:(NSString *)errorDescription;
@end


@interface SoinWS : NSObject

@property (weak) id<SoinWSDelegate> delegate;

@property (strong) AFHTTPClient *resquestClient;


@property (copy)NSString*   methodName;
@property (copy)NSString*   params;
@property (copy)NSString*   host;
@property (copy)NSString*   servicePath;
@property BOOL doPost;

@property BOOL              isHttps;
//@property BOOL              doPost;
@property NSInteger         port;


//-(void) doPostRequest;
-(void) doGetXMLRequest;
-(void) doGetJSONRequest;

- (void) call;

- (void) callUploadImage:(UIImage *)image withParameters:(NSDictionary *)parameters;

- (void) callPostWithParameters:(NSDictionary *)parameters;

// No muestra el modal indicator
- (void) callSilent;

- (void) callWithIndicatorMessage:(NSString*)message;

@end
