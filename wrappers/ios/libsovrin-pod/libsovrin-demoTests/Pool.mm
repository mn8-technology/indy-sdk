//
//  Pool.m
//  libsovrin-demo
//
//  Created by Anastasia Tarasova on 05.06.17.
//  Copyright © 2017 Kirill Neznamov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XCTest/XCTest.h>
#import "PoolUtils.h"
#import "TestUtils.h"
#import "WalletUtils.h"
#import <libsovrin/libsovrin.h>
#import "NSDictionary+JSON.h"

@interface Pool : XCTestCase

@end

@implementation Pool

- (void) testCreatePoolLedgerConfigWorks
{
    [TestUtils cleanupStorage];
    
    NSString *res = nil;
    res = [[PoolUtils sharedInstance] createPoolConfig:@"pool_create"];
    
    XCTAssertNotNil(res, @"Pool config is nil!");
    
    [TestUtils cleanupStorage];
};

- (void) testOpenPoolLedgerWorks
{
    [TestUtils cleanupStorage];
    
    NSString *name = @"pool_open";
    
    NSError *ret = [[PoolUtils sharedInstance] createPoolLedgerConfig:name];
    XCTAssertEqual(ret.code, Success, @"PoolUtils::createPoolLedgerConfig() failed!");
    
    //SovrinHandle poolHandle = 0;
   // openPoolLedger
    XCTAssertEqual(ret.code, Success, @"PoolUtils::openPoolLedger() failed!");
    
    [TestUtils cleanupStorage];
}

- (void)testOpenPoolLedgerWorksForTwice
{
    [TestUtils cleanupStorage];
    NSString *poolName = @"pool_open_twice";
    
    NSError *ret = [[PoolUtils sharedInstance] createPoolLedgerConfig:poolName];
    XCTAssertEqual(ret.code, Success, @"PoolUtils::createPoolLedgerConfig() failed!");
    
    // open_pool_ledger ... twice
    
    [TestUtils cleanupStorage];
}

- (void) testSovrinSubmitRequestWorks
{
    [TestUtils cleanupStorage];
    NSString *poolName = @"test_submit_tx";
    
    NSError *ret = [[PoolUtils sharedInstance] createPoolLedgerConfig:poolName];
    XCTAssertEqual(ret.code, Success, @"PoolUtils::createPoolLedgerConfig() failed!");
    
    SovrinHandle poolHandle = 0;
    // open pool
    
    NSString *request = [NSString stringWithFormat:@"{"\
                         "\"reqId\":\"1491566332010860\"," \
                         "\"identifier\":\"Th7MpTaRZVRYnPiabds81Y\"," \
                         "\"operation\":{"\
                                "\"type\":\"105\","\
                                "\"dest\":\"FYmoFw55GeQH7SRFa37dkx1d2dZ3zUF8ckg7wmL7ofN4\"},"\
                         "\"signature\":\"4o86XfkiJ4e2r3J6Ufoi17UU3W5Zi9sshV6FjBjkVw4sgEQFQov9dxqDEtLbAJAWffCWd5KfAk164QVo7mYwKkiV\"" \
                         "}"];
    
    NSString *responseJson;
    ret = [[PoolUtils sharedInstance] sendRequest:poolHandle
                                          request:request
                                         response:&responseJson];
    XCTAssertEqual(ret.code, Success, @"PoolUtils::sendRequest() failed!");
    NSLog(@"responseJson: %@", responseJson);
    
    NSDictionary *actualReply = [NSDictionary fromString:responseJson];
    
    // Configure expected reply
    NSMutableDictionary *expecredReply = [NSMutableDictionary new];
    expecredReply[@"op"] = @"REPLY"; // "REPLY".to_string(),
    
    NSMutableDictionary *replyResult = [NSMutableDictionary new];
    replyResult[@"req_id"] = @"1491566332010860";
    replyResult[@"data"] = [NSString stringWithFormat:@"{"\
                            "\"dest\":\"FYmoFw55GeQH7SRFa37dkx1d2dZ3zUF8ckg7wmL7ofN4\"," \
                            "\"identifier\":\"GJ1SzoWzavQYfNL9XkaJdrQejfztN4XqdsiV4ct3LXKL\"," \
                            "\"role\":\"2\"," \
                            "\"verkey\":null" \
                            "}"];
    replyResult[@"identifier"] = @"Th7MpTaRZVRYnPiabds81Y";
    
    // Actual reply
    XCTAssertEqual(actualReply, expecredReply, @"replies are not equal!");
 
    [TestUtils cleanupStorage];
}

@end
