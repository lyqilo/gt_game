//
//  IPV6DeCode.m
//  Unity-iPhone
//
//  Created by 2255 on 16/7/9.
//
//
#import <sys/socket.h>
#import <netdb.h>
#import <arpa/inet.h>
#import <err.h>
#include <netinet/in.h>
#include "CHKeychain.h"
#import <CoreLocation/CoreLocation.h>

#define MakeStringCopy( _x_ ) ( _x_ != NULL && [_x_ isKindOfClass:[NSString class]] ) ? strdup( [_x_ UTF8String] ) : NULL
extern "C"{
    const char* getIPv6(const char *mHost,const char *mPort)
    {
        if( nil == mHost )
            return NULL;
        Boolean result,bResolved;
        CFHostRef hostRef;
        CFArrayRef addresses = NULL;
        NSString * NewStr = NULL;
        char ipbuf[32];
        CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, mHost, kCFStringEncodingASCII);
        hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
        if (hostRef) {
            result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
            if (result == TRUE) {
                addresses = CFHostGetAddressing(hostRef, &result);
            }
        }
        bResolved = result == TRUE ? true : false;
        if(bResolved)
        {
            struct sockaddr_in* remoteAddr;
            struct sockaddr_in6* remoteAddr6;
            for(int i = 0; i < CFArrayGetCount(addresses); i++)
            {
                CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
                remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
                
                if(remoteAddr != NULL)
                {
                    //获取IP地址
                    char ip[16];
                    if(remoteAddr->sin_family==AF_INET6){
                        remoteAddr6 = (struct sockaddr_in6*)CFDataGetBytePtr(saData);
                        strcpy(ip,inet_ntop(AF_INET6, &remoteAddr6->sin6_addr,ipbuf, sizeof(ipbuf)));
                        NSString * TempA = [[NSString alloc] initWithCString:(const char*)ip
				                                  encoding:NSASCIIStringEncoding];
                        NSString * TempB = [NSString stringWithUTF8String:"&&ipv6"];
                        NewStr = [TempA stringByAppendingString: TempB];
                        break;
                    }else{
                        strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
                        NSString * TempA = [[NSString alloc] initWithCString:(const char*)ip
                                                                    encoding:NSASCIIStringEncoding];
                        NSString * TempB = [NSString stringWithUTF8String:"&&ipv4"];
                        NewStr = [TempA stringByAppendingString: TempB];
                    }
                }
            }
        }
        CFRelease(hostNameRef);
        CFRelease(hostRef);
        NSString * mIPaddr = NewStr;
        return MakeStringCopy(mIPaddr);

    }
	

	const char* getIosUUIDCode(const char *group){
		
		NSString *bundleid =  @"games.four.temp";
		NSString* KEY_USERNAME_PASSWORD=bundleid;
		const char *key = "3dyylGame.GroupKeyChain";
		NSString * keyValue = [[NSString alloc] initWithCString:(const char*)key
													   encoding:NSASCIIStringEncoding];
		
		NSString * groupName = [[NSString alloc] initWithCString:(const char*)group
														encoding:NSASCIIStringEncoding];
		
		NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD];
		NSString *oldName = [usernamepasswordKVPairs objectForKey:keyValue];
		if([oldName isEqualToString:@""] || oldName==nil || oldName==NULL){
			NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
			[usernamepasswordKVPairs setObject:groupName forKey:keyValue];
			[CHKeychain save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
			return MakeStringCopy(groupName);
		}
		return MakeStringCopy(oldName);
	}
	
    // const char* Distance(const char *sg,const char *sl,const char *og,const char *ol){
        // NSLog(@"come here");
        // NSString *selfLongitude = [[NSString alloc] initWithCString:(const char*)sg
                                                           // encoding:NSASCIIStringEncoding];
        // NSString *selfLatitude = [[NSString alloc] initWithCString:(const char*)sl
                                                          // encoding:NSASCIIStringEncoding];
        // NSString *otherLongitude = [[NSString alloc] initWithCString:(const char*)og
                                                            // encoding:NSASCIIStringEncoding];
        // NSString *otherLatitude = [[NSString alloc] initWithCString:(const char*)ol
                                                           // encoding:NSASCIIStringEncoding];
        // CLLocation *loc1=[[CLLocation alloc]initWithLatitude:[selfLatitude doubleValue] longitude:[selfLongitude doubleValue]];
        // CLLocation *loc2=[[CLLocation alloc]initWithLatitude:[otherLatitude doubleValue] longitude:[otherLongitude doubleValue]];
        // CLLocationDistance distance=[loc1 distanceFromLocation:loc2];
         // NSLog(@"come here->%f distace",distance);
        // NSString *dist=[NSString stringWithFormat:@"%f",distance];
        // return MakeStringCopy(dist);
    // }
    const BOOL install(const char *schemeurl){
        NSString * scheme = [[NSString alloc] initWithCString:(const char*)schemeurl
                                                    encoding:NSASCIIStringEncoding];
        NSLog(@"-->>%@",scheme);
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]){
            NSLog(@"Install");
            return YES;
        }else{
            return NO;
        }
    }
    const char* GetKeyChain(const char *key,const char *group){
        NSString * keyValue = [[NSString alloc] initWithCString:(const char*)key
                                                     encoding:NSASCIIStringEncoding];

        NSString * groupName = [[NSString alloc] initWithCString:(const char*)group
                                                     encoding:NSASCIIStringEncoding];
        NSMutableDictionary *usramepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:groupName];
        NSString*  returnString = [usramepasswordKVPairs objectForKey:keyValue];
        
        return MakeStringCopy(returnString);

        
    }
    const void CopyToClip(const char *str){
        NSString * content = [[NSString alloc] initWithCString:(const char*)str
                                                      encoding:NSUTF8StringEncoding];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = content;
    }
}