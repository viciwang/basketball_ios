//
//  BBNetworkAddress.h
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#ifndef BBNetworkAddress_h
#define BBNetworkAddress_h

#define DEBUG_LOCAL_HOST "如果想要用localhost作为baseUrl，就注释掉这一行"

#ifdef DEBUG_LOCAL_HOST
  #define kApiBaseUrl @"http://192.168.184.229:8000"
#else
  #define kApiBaseUrl @"http://localhost:8000"
#endif

#define kApiTestAddress @"test.json"

#define kApiGamesScoreAddress @"gamescoremanager/getgamescore"

#define kApiUserLogin @"user/login"

#define kApiUserLogout @"user/logout"

#define kApiUserRegister @"user/register"

#define kApiUserGetVerifyCode @"user/getVerifyCode"

#define kApiUserUploadHeadImage @"user/uploadHeadImage"

#define kApiUserUpdateInfo @"user/updateInfo"

#define kApiUserResetPassword @"user/resetPassword"

#define kArticleParseAPI @"articlemanager/articleParse"

#define kArticleSourceAddress @"articlemanager/articlesource"

#define kApiStepCountingAverage @"stepCounting/average"

#define kApiStepCountingHistory @"stepCounting/history"

#define kApiStepCountingRanking @"stepCounting/ranking"

#endif /* BBNetworkAddress_h */
