//
//  MReportIncident.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 04/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoinWS.h"
#import "ISerializable.h"

#define REPORT_INCIDENT_DONE_EVENT               @"ReportIncidentDoneEvent"
#define REPORT_INCIDENT_ERROR_EVENT              @"ReportIncidentErrorEvent"

@interface MReportIncident : NSObject <ISerializable, SoinWSDelegate>

@property (strong, nonatomic) SoinWS *soinWS;

- (void) reportIncidentWithName:(NSString*)aName
                             Id:(NSString*)anId
                          phone:(NSString*)aPhone
                          email:(NSString*)anEmail
                         amount:(NSString*)anAmount
                           date:(NSString*)aDate
                    plateNumber:(NSString*)aPlateNumber
                        routeId:(NSNumber*)aRouteId
                    routeName:(NSString*)aRouteName;

- (void) setupWS;

@end
