//
//  MReportIncident.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 04/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "MReportIncident.h"
#import "Constants.h"
#import "EventMacros.h"
#import "TypeUtil.h"
#import "NSString+Utils.h"

#define HOST                        SERVER_HOST
//#define SERVICE_PATH                @"/service/complaintservice.svc/json/SendComplaint"
#define SERVICE_PATH                @"/ComplaintService/ComplaintService.svc/json/SendComplaint"
//#define PORT                        SERVER_PORT
#define METHOD_REPORT_INCIDENT      @"iPhone"

//http://transporte.aresep.go.cr/ComplaintService/ComplaintService.svc/json/


@implementation MReportIncident

@synthesize valid = _valid;

- (id) init
{
    self = [super init];
    
    return self;
}

- (void)setupWS
{
    if (self.soinWS == nil)
    {
        _soinWS                 = [[SoinWS alloc] init];
        self.soinWS.delegate    = self;
        self.soinWS.isHttps     = isHTTPS;
        self.soinWS.host        = HOST;
       // self.soinWS.port        = PORT;
        self.soinWS.servicePath = SERVICE_PATH;
        
    }
}



- (void) reportIncidentWithName:(NSString*)aName
                             Id:(NSString*)anId
                          phone:(NSString*)aPhone
                          email:(NSString*)anEmail
                         amount:(NSString*)anAmount
                           date:(NSString*)aDate
                    plateNumber:(NSString*)aPlateNumber
                        routeId:(NSNumber *)aRouteId
                      routeName:(NSString*)aRouteName
{
    [self setupWS];
    self.soinWS.methodName = METHOD_REPORT_INCIDENT;
    self.soinWS.params = [NSString stringWithFormat: @"name=%@&idNumber=%@&phone=%@&amountCharged=%@&eventDate=%@&plateNumber=%@&routeID=%d&email=%@&routeName=%@",[aName urlEncodeUsingEncoding:NSUTF8StringEncoding],anId,aPhone,anAmount, [aDate urlEncodeUsingEncoding:NSUTF8StringEncoding],[aPlateNumber urlEncodeUsingEncoding:NSUTF8StringEncoding],[aRouteId intValue],[anEmail urlEncodeUsingEncoding:NSUTF8StringEncoding], [aRouteName urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    
    [self.soinWS call];
    
    
}

- (void)desSerialize:(NSDictionary *)jsonResult
{
    
    if ([self.soinWS.methodName isEqualToString:METHOD_REPORT_INCIDENT])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:HIDE_PROGRESS_INDICATOR object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:REPORT_INCIDENT_DONE_EVENT object:self];
    }
}

- (NSString*)serialize
{
    return @"";
}

- (void)answerReceived:(NSDictionary *)result
{
     NSString *reponse = [TypeUtil toString:[result objectForKey:@"d"]];
    
    if ([reponse isEqualToString:@"success"])
    {
        [self desSerialize:result];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:HIDE_PROGRESS_INDICATOR object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:REPORT_INCIDENT_ERROR_EVENT object:self];
    }
    
    
}

- (void) connectionFailed:(NSString *)errorDescription
{
    // Notify the observers about the connection problem
    [[NSNotificationCenter defaultCenter]postNotificationName:CONNECTION_ERROR_EVENT object:nil];
}

@end
