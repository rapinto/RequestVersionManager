//
//  AppVersionManager.m
//
//
//  Created by Raphaël Pinto on 07/08/2015.
//
// The MIT License (MIT)
// Copyright (c) 2015 Raphael Pinto.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.



#import "RequestVersionManager.h"
#import "RPOperationManager.h"
#import "RPRequestOperation.h"
#import "VersionManager.h"



@implementation RequestVersionManager



#pragma mark -
#pragma mark Singleton Methods



static RequestVersionManager* sharedInstance = nil;



+ (RequestVersionManager*)sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[RequestVersionManager alloc] init];
    }
    
    return sharedInstance;
}



#pragma mark -
#pragma mark Operation Manager Delegate Methods



- (void)operationManager:(RPOperationManager*)operationManager
     didSucceedOperation:(RPRequestOperation*)operation
      withResponseObject:(id)responseObject
{
    [self checkUpdateInHeaders:operation.response.allHeaderFields];
}


- (void)operationManager:(RPOperationManager*)operationManager
        didFailOperation:(RPRequestOperation*)operation
               withError:(NSError*)error
{
    [self checkUpdateInHeaders:operation.response.allHeaderFields];
}



#pragma mark -
#pragma mark Data Management Methods



- (void)checkUpdateInHeaders:(NSDictionary*)_Headers
{
    float lMinimumAllowedVersion, lLastAvailableVersion;
    
    if ([_Headers objectForKey:@"App_Versions"] && [[_Headers objectForKey:@"App_Versions"] isKindOfClass:[NSString class]])
    {
        NSString* lAppVersions = (NSString*)[_Headers objectForKey:@"App_Versions"];
        
        
        NSArray* lVersion = [lAppVersions componentsSeparatedByString:@"|"];
        
        if ([lVersion count] != 2)
        {
            return;
        }
        else
        {
            lMinimumAllowedVersion = [[lVersion objectAtIndex:0] floatValue];
            lLastAvailableVersion = [[lVersion objectAtIndex:1] floatValue];
        }
    }
    else
    {
        return;
    }
    
    
    [VersionManager setMinimumAllowedVersion:lMinimumAllowedVersion lastAvailableVersion:lLastAvailableVersion];
}


@end
