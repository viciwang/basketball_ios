//
//  BBNetworkAddress.h
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#ifndef BBNetworkAddress_h
#define BBNetworkAddress_h

//#define DEBUG_LOCAL_HOST "如果想要用localhost作为baseUrl，就注释掉这一行"

#ifdef DEBUG_LOCAL_HOST
  #define kApiBaseUrl @"http://192.168.1.103:8081"
#else
  #define kApiBaseUrl @"http://localhost:8081"
#endif

#define kApiTestAddress @"test.json"

#define kApiGamesScoreAddress @"gamescoremanager/getgamescore"

#define kApiUserLogin @"user/login"

#define kApiUserLogout @"user/logout"

#define kApiUserRegister @"user/register"

#define kApiUserResetPassword @"user/resetPassword"

#define kApiUserGetVerifyCode @"user/getVerifyCode"

#define kApiUserupDateHeadImageUrl @"user/updateHeadImageUrl"

#define kApiUserUpdateInfo @"user/updateInfo"

#define kApiUserResetPassword @"user/resetPassword"

#define kArticleParseAPI @"articlemanager/articleParse"

#define kArticleSourceAddress @"articlemanager/articlesource"

#define kApiStepCountingAverage @"stepCounting/average"

#define kApiStepCountingHistory @"stepCounting/history"

#define kApiStepCountingRanking @"stepCounting/ranking"

#define kApiAddShare @"ShareManager/addShare"
#define kApiGetShare @"ShareManager/getShareInfo"

#endif /* BBNetworkAddress_h */
