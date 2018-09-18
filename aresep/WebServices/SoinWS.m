//
//  SoinWS.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 20/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "SoinWS.h"
#import "AFHTTPRequestOperation.h"
#import "EventMacros.h"
#import "JSONKit.h"
#import "NameUtils.h"
#import "NSString+Utils.h"

#define TIME_OUT 120

@interface SoinWS()
- (NSURL *)buildGetRequest;

- (NSURL *)buildUploadRequest;

- (NSURL *)buildPostRequest;
@end

@implementation SoinWS

@synthesize resquestClient  = _resquestClient;
@synthesize methodName  = _methodName;
@synthesize params      = _params;
@synthesize isHttps     = _isHttps;
@synthesize port        = _port;
@synthesize host        = _host;
@synthesize servicePath = _servicePath;
//@synthesize doPost      = _doPost;

@synthesize delegate;

- (id)init
{
    self = [super init];
    
    if (self) {
        self.resquestClient = nil;
    }
    
    return self;
}

- (NSURL *)buildGetRequest
{
    NSString *http = nil;
    
    if (self.isHttps) {
        http = @"https://";
    }
    else
    {
        http = @"http://";
    }
    
    NSString *request = [NSString stringWithFormat:@"%@%@%@?method=%@&%@",
                         http,self.host,self.servicePath,self.methodName,self.params];
    
    NSLog(@"Calling WS: %@", request);
    
    NSURL *url=  [NSURL URLWithString:request];
    return url;
}


- (NSURL *)buildUploadRequest
{
    NSString *http = nil;
    
    if (self.isHttps) {
        http = @"https://";
    }
    else
    {
        http = @"http://";
    }
    
    
    NSString *request = [NSString stringWithFormat:@"%@%@",
                         http,self.host];
    
    NSLog(@"Calling WS: %@", request);
    
    NSURL *url=  [NSURL URLWithString:request];
    return url;
}

- (NSURL *)buildPostRequest
{
    NSString *http = nil;
    
    if (self.isHttps) {
        http = @"https://";
    }
    else
    {
        http = @"http://";
    }
    
    
    NSString *request = [NSString stringWithFormat:@"%@%@",
                         http,self.host];
    
    NSLog(@"Calling WS: %@", request);
    
    NSURL *url=  [NSURL URLWithString:request];
    return url;
}


//- (NSURL *)buildRequestForPost
//{
//    NSString *http = nil;
//
//    if (self.isHttps) {
//        http = @"https://";
//    }
//    else
//    {
//        http = @"http://";
//    }
//
//    NSString *request = [NSString stringWithFormat:@"%@%@:%d%@",
//                         http,self.host,self.port,self.servicePath];
//
//    NSLog(@"Calling WS in Post: %@", request);
//
//    NSURL *url=  [NSURL URLWithString:request];
//    return url;
//}


//- (NSArray *)buildParamsForPost
//{
//    NSString * postData = @"";
//
//    if(self.params)
//    {
//        postData = [NSString stringWithFormat:@"method=%@&%@",self.methodName,self.params];
//    }
//    else
//    {
//        postData = [NSString stringWithFormat:@"method=%@",self.methodName];
//    }
//
//    NSLog(@"Params for post : %@", postData);
//
//    return [postData componentsSeparatedByString:@"&"];
//
//}


- (void)call
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_PROGRESS_INDICATOR object:nil];
    
    [self doGetJSONRequest];
    
}


- (void)callWithIndicatorMessage:(NSString*)message
{
    NSDictionary *messageDict = [NSDictionary dictionaryWithObjectsAndKeys:message,@"message",nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_PROGRESS_INDICATOR_WITH_TEXT  object:nil userInfo:messageDict];
    
    [self doGetJSONRequest];
    
}

- (void) callPostWithParameters:(NSDictionary *)parameters
{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_PROGRESS_INDICATOR object:nil];
    
    NSURL *url = [self buildUploadRequest];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = parameters;
    
    NSString *path = [NSString stringWithFormat:@"%@?method=%@",
                      self.servicePath,self.methodName];
    
    [httpClient postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [operation responseString];
        NSLog(@"response: [%@]",response);
        
        //TODO Use XMLDocument
        NSDictionary * dicResponse = [response objectFromJSONString];
        
        if(dicResponse)
        {
            [delegate answerReceived:dicResponse];
        }
        else
        {
            [delegate connectionFailed:@"Error en la respuesta del servidor"];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (delegate != nil && [delegate respondsToSelector:@selector(connectionFailed:)]) {
            
            NSLog(@"Error:%@",[error description]);
            NSLog(@"Error:%@",operation.description);
            
            [delegate connectionFailed:error.description];
        }
        
    }];
    
}


- (void) callUploadImage:(UIImage *)image withParameters:(NSDictionary *)parameters
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_PROGRESS_INDICATOR object:nil];
    
    
    NSURL *url = [self buildUploadRequest];
    
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    // Create the NSData object for the upload process
    NSData *dataToUpload = UIImageJPEGRepresentation(image, 0.5);
    
    NSString *path = [NSString stringWithFormat:@"%@?method=%@",
                      self.servicePath,self.methodName];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:dataToUpload name:@"Image" fileName:@"Image.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *response = [operation responseString];
         NSLog(@"response: [%@]",response);
         
         //TODO Use XMLDocument
         NSDictionary * dicResponse = [response objectFromJSONString];
         
         if(dicResponse)
         {
             [delegate answerReceived:dicResponse];
         }
         else
         {
             [delegate connectionFailed:@"Error en la respuesta del servidor"];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         //         if([operation.response statusCode] == 403){
         //             NSLog(@"Upload Failed");
         //             return;
         //         }
         //         NSLog(@"error: %@", [operation error]);
         
         if (delegate != nil && [delegate respondsToSelector:@selector(connectionFailed:)]) {
             
             NSLog(@"Error:%@",[error description]);
             NSLog(@"Error:%@",operation.description);
             
             [delegate connectionFailed:error.description];
         }
         
         
     }];
    
    [operation start];
    
}


- (void) callSilent
{
    [self doGetJSONRequest];
}


-(void) doGetJSONRequest
{
    NSURL *url = [self buildGetRequest];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIME_OUT];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON RESPONSE:%@",operation.responseString);
        
        if (delegate != nil && [delegate respondsToSelector:@selector(answerReceived:)])
        { //only trigger method IF delegate has been assigned and the method has been implemented into the target class
            
            //TODO Use XMLDocument
            NSDictionary * dicResponse = [operation.responseString objectFromJSONString];
            
            if(dicResponse)
            {
                [delegate answerReceived:dicResponse];
            }
            else
            {
                [delegate connectionFailed:@"Error en la respuesta del servidor"];
            }
        }
        
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error: %@",  operation.responseString);
                                          
                                          if (delegate != nil && [delegate respondsToSelector:@selector(connectionFailed:)]) {
                                              
                                              NSLog(@"Error:%@",[error description]);
                                              NSLog(@"Error:%@",operation.description);
                                              
                                              [delegate connectionFailed:error.description];
                                          }
                                          
                                      }
     ];
    
    //    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"text/plain", nil]];
    
    //    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    
    //        NSLog(@"JSON RESPONSE:%@",JSON);
    //
    //        if (delegate != nil && [delegate respondsToSelector:@selector(answerReceived:)])
    //        { //only trigger method IF delegate has been assigned and the method has been implemented into the target class
    //
    //            //TODO Use XMLDocument
    //            NSDictionary * dicResponse =JSON;
    //
    //            if(dicResponse)
    //            {
    //                [delegate answerReceived:dicResponse];
    //            }
    //            else
    //            {
    //                [delegate connectionFailed:@"Error en la respuesta del servidor"];
    //            }
    //        }
    
    
    //    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    //    {
    //
    //        if (delegate != nil && [delegate respondsToSelector:@selector(connectionFailed:)]) {
    //
    //            NSLog(@"Error:%@",[error description]);
    //            NSLog(@"Error:%@",response.description);
    //
    //            [delegate connectionFailed:error.description];
    //        }
    //
    //    }];
    
    [operation start];
    
    
    
    
    //    self.getRequest = [ASIHTTPRequest requestWithURL:url];
    //    [self.getRequest setDelegate:self];
    //    [self.getRequest startAsynchronous];
    
}


-(void) doGetXMLRequest
{
    //    NSURL *url = [self buildRequest];
    //
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //
    //    AFKissXMLRequestOperation *operation = [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument) {
    //
    //
    //        if (delegate != nil && [delegate respondsToSelector:@selector(answerReceived:)])
    //        { //only trigger method IF delegate has been assigned and the method has been implemented into the target class
    //
    //            //TODO Use XMLDocument
    ////            NSDictionary * dicResponse =[[request responseData] objectFromJSONData];
    ////            if(dicResponse){
    ////                [delegate answerReceived:dicResponse];
    ////            }
    ////            else
    ////            {
    ////                [delegate connectionFailed:@"Error en la respuesta del servidor"];
    ////            }
    //        }
    //
    //
    //    }
    //    failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , DDXMLDocument *XMLParse )
    //    {
    //
    //        if (delegate != nil && [delegate respondsToSelector:@selector(connectionFailed:)]) { //only trigger method IF delegate has been assigned and the method has been implemented into the target class
    //
    //            NSLog(@"Error:%@",[error description]);
    //            [delegate connectionFailed:error.description];
    //        }
    //
    //    }];
    //
    //    [operation start];
    
    //    self.getRequest = [ASIHTTPRequest requestWithURL:url];
    //    [self.getRequest setDelegate:self];
    //    [self.getRequest startAsynchronous];
    
}

//-(void) doPostRequest
//{
//
//    NSURL *url = [self buildRequestForPost];
//
//    self.postRequest = [ASIFormDataRequest requestWithURL:url];
//
//    NSArray *components = [self buildParamsForPost];
//
//    for (NSString * component in components)
//    {
//
//        NSUInteger indexOfEqualsSign = [component rangeOfString:@"="].location;
//        if (indexOfEqualsSign != NSNotFound) {
//            NSString* key = [component substringToIndex:indexOfEqualsSign];
//            NSString* value = [component substringFromIndex:indexOfEqualsSign+1];
//            [self.postRequest setPostValue:value forKey:key];
//        }
//
//        //NSString* key = [[query substringToIndex:indexOfEqualsSign] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        //NSString* value = [[query substringFromIndex:indexOfEqualsSign+1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        //NSArray *pair = [component componentsSeparatedByString:@"="];
//    }
//
//    [self.postRequest setDelegate:self];
//    [self.postRequest startAsynchronous];
//}


//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    // Use when fetching text data
//    NSString *responseString = [request responseString];
//
//    NSLog(@"WS Response: %@", responseString);
//
//    if (delegate != nil && [delegate respondsToSelector:@selector(answerReceived:)]) { //only trigger method IF delegate has been assigned and the method has been implemented into the target class
//
//        NSDictionary * dicResponse =[[request responseData] objectFromJSONData];
//        if(dicResponse){
//            [delegate answerReceived:dicResponse];
//        }
//        else
//        {
//            [delegate connectionFailed:@"Error en la respuesta del servidor"];
//        }
//    }
//}

//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSError *error = [request error];
//    
//    if (delegate != nil && [delegate respondsToSelector:@selector(connectionFailed:)]) { //only trigger method IF delegate has been assigned and the method has been implemented into the target class
//		
//        NSLog(@"Error:%@",[error description]);
//        [delegate connectionFailed:error.description];
//    }
//}



@end
