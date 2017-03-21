//
//  JASAPPURL.h
//  JasVisaApp
//
//  Created by Masum Chauhan on 30/08/16.
//  Copyright © 2016 Masum Chauhan. All rights reserved.
//

#ifndef JASAPPURL_h
#define JASAPPURL_h

#define JAS_BASEURL @"http://ws-srv-net.in.webmyne.com/Applications/dreamsdesign.us/JasWCF/Services/"

#define JAS_VISAURL @"Visa.svc/json/"

#define JAS_ACCOUNTURL @"Account.svc/json/"



/* JAS_VISAURL */

#define VISA_LIST @"GetVisaPackage"

#define VISA_PACKAGE_DETAIL @"GetVisaPackageInfo/"




/* JAS_ACCOUNTURL */

#define VISA_FOR_COUNTRY_NAME @"GetCountryServiceDetailIDWise/"

#define BOOKING_DETAILS @"GetBookingDetailUserIDWise/"

#define SUBMIT_FEEDBACK @"SubmitFeedback"

#define USER_LOGIN @"Login"

#define USER_RESTRATION @"Registration"

#define OTHER_PAGE_DETAIL @"GetOtherDetails/"

#define INSTANT_PAY @"InstantPay"

#define UPDATE_USER_SETTING @"UpdateUserSetting"

#define  UPDATE_USER_PROFILE @"UpdateUserProfile"

/*   FTP URL   */

#define FTP_URL @"ftp://192.168.1.131"

#define FTP_USERNAME @"test"

#define FTP_PASSWORD @"test"

/*  CONSTANTS  */

#define DEFAULT_COUNTRY_ID @"1"

#define DEFAULT_NATIONALITY_ID @"0"

#define DEFAULT_EXPECTED_DATE @"25-08-2016"

#define DEFAULT_VISA_TYPE_ID @"1"

#define DEFAULT_ABOUT_US @"1"
#define DEFAULT_TERMS_CONDITION @"2"

#define DEFAULT_SURCHARGE 3.00

#define DEFAULT_SIGNUP_FORM 1
#define DEFAULT_SIGNUP_SOCIAL 2

#endif /* JASAPPURL_h */
