//
//  JewishCalendar.m
//  KosherCocoaCommandLine
//
//  Created by Moshe Berman on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JewishCalendar.h"
#import "YomiCalculator.h"
#import "KCConstants.h"


@implementation JewishCalendar

//Initialize the calendar, default to diaspora, without showing modern holidays
- (id) init{
    self = [super init];
    
    if (self) {
        _inIsrael = NO;
        _useModernHolidays = NO;
    }
    
    return self;
}

//Returns the current Yom Tov Index
- (NSInteger) yomTovIndex{
    
    BOOL inIsrael = [self inIsrael];
    BOOL useModernHolidays = [self useModernHolidays];
    
    switch ([self currentHebrewMonth]) {
        case kNissan:
            if ([self currentHebrewDayOfMonth] == 14) {
                return kErevPesach;
            } else if ([self currentHebrewDayOfMonth] == 15 || [self currentHebrewDayOfMonth] == 21
                       || (!inIsrael && ([self currentHebrewDayOfMonth] == 16 || [self currentHebrewDayOfMonth] == 22))) {
                return kPesach;
            } else if (([self currentHebrewDayOfMonth] >= 17 && [self currentHebrewDayOfMonth] <= 20)
                       || ([self currentHebrewDayOfMonth] == 16 && inIsrael)) {
                return kCholHamoedPesach;
            }
            if (useModernHolidays
                && (([self currentHebrewDayOfMonth] == 26 && [self currentDayOfTheWeek] == 5)
                    || ([self currentHebrewDayOfMonth] == 28 && [self currentDayOfTheWeek] == 1)
                    || ([self currentHebrewDayOfMonth] == 27 && [self currentDayOfTheWeek] == 3) || ([self currentHebrewDayOfMonth] == 27 && [self currentDayOfTheWeek] == 5))) {
                    return kYomHashoah;
                }
            break;
        case kIyar:
            if (useModernHolidays
                && (([self currentHebrewDayOfMonth] == 4 && [self currentDayOfTheWeek] == 3)
                    || (([self currentHebrewDayOfMonth] == 3 || [self currentHebrewDayOfMonth] == 2) && [self currentDayOfTheWeek] == 4) || ([self currentHebrewDayOfMonth] == 5 && [self currentDayOfTheWeek] == 2))) {
                    return kYomHazikaron;
                }
            // if 5 Iyar falls on Wed Yom Haatzmaut is that day. If it falls on Friday or Shabbos it is moved back to
            // Thursday. If it falls on Monday it is moved to Tuesday
            if (useModernHolidays
                && (([self currentHebrewDayOfMonth] == 5 && [self currentDayOfTheWeek] == 4)
                    || (([self currentHebrewDayOfMonth] == 4 || [self currentHebrewDayOfMonth] == 3) && [self currentDayOfTheWeek] == 5) || ([self currentHebrewDayOfMonth] == 6 && [self currentDayOfTheWeek] == 3))) {
                    return kYomHaatzmaut;
                }
            if ([self currentHebrewDayOfMonth] == 14) {
                return kPesachSheni;
            }
            if (useModernHolidays && [self currentHebrewDayOfMonth] == 28) {
                return kYomHashoah;
            }
            break;
        case kSivan:
            if ([self currentHebrewDayOfMonth] == 5) {
                return kErevShavuos;
            } else if ([self currentHebrewDayOfMonth] == 6 || ([self currentHebrewDayOfMonth] == 7 && !inIsrael)) {
                return kShavuos;
            }
            break;
        case kTammuz:
            // push off the fast day if it falls on Shabbos
            if (([self currentHebrewDayOfMonth] == 17 && [self currentDayOfTheWeek] != 7)
                || ([self currentHebrewDayOfMonth] == 18 && [self currentDayOfTheWeek] == 1)) {
                return kSeventeenthOfTammuz;
            }
            break;
        case kAv:
            // if Tisha B'av falls on Shabbos, push off until Sunday
            if (([self currentDayOfTheWeek] == 1 && [self currentHebrewDayOfMonth] == 10) 
                || ([self currentDayOfTheWeek] != 7 && [self currentHebrewDayOfMonth] == 9)) {
                return kTishaBeav;
            } else if ([self currentHebrewDayOfMonth] == 15) {
                return kTuBeav;
            }
            break;
        case kElul:
            if ([self currentHebrewDayOfMonth] == 29) {
                return kErevRoshHashana;
            }
            break;
        case kTishrei:
            if ([self currentHebrewDayOfMonth] == 1 || [self currentHebrewDayOfMonth] == 2) {
                return kRoshHashana;
            } else if (([self currentHebrewDayOfMonth] == 3 && [self currentDayOfTheWeek] != 7)
                       || ([self currentHebrewDayOfMonth] == 4 && [self currentDayOfTheWeek] == 1)) {
                // push off Tzom Gedalia if it falls on Shabbos
                return kFastOfGedalya;
            } else if ([self currentHebrewDayOfMonth] == 9) {
                return kErevYomKippur;
            } else if ([self currentHebrewDayOfMonth] == 10) {
                return kYomKippur;
            } else if ([self currentHebrewDayOfMonth] == 14) {
                return kErevSuccos;
            }
            if ([self currentHebrewDayOfMonth] == 15 || ([self currentHebrewDayOfMonth] == 16 && !inIsrael)) {
                return kSuccos;
            }
            if (([self currentHebrewDayOfMonth] >= 17 && [self currentHebrewDayOfMonth] <= 20) || ([self currentHebrewDayOfMonth] == 16 && inIsrael)) {
                return kCholHamoedSuccos;
            }
            if ([self currentHebrewDayOfMonth] == 21) {
                return kHoshanaRabba;
            }
            if ([self currentHebrewDayOfMonth] == 22) {
                return kSheminiAtzeres;
            }
            if ([self currentHebrewDayOfMonth] == 23 && !inIsrael) {
                return kSimchasTorah;
            }
            break;
        case kKislev: //no yomtov in CHESHVAN
            if ([self currentHebrewDayOfMonth] == 24) {
                return kErevChanukah;
            } else
                if ([self currentHebrewDayOfMonth] >= 25) {
                    return kChanukah;
                }
            break;
        case kTeves:
            if ([self currentHebrewDayOfMonth] == 1 || [self currentHebrewDayOfMonth] == 2
                || ([self currentHebrewDayOfMonth] == 3 && [self isKislevShort])) {
                return kChanukah;
            } else if ([self currentHebrewDayOfMonth] == 10) {
                return kTenthOfTeves;
            }
            break;
        case kShevat:
            if ([self currentHebrewDayOfMonth] == 15) {
                return kTuBeshvat;
            }
            break;
        case kAdar:
            if (![self isCurrentlyHebrewLeapYear]) {
                // if 13th Adar falls on Friday or Shabbos, push back to Thursday
                if ((([self currentHebrewDayOfMonth] == 11 || [self currentHebrewDayOfMonth] == 12) && [self currentDayOfTheWeek] == 5)
                    || ([self currentHebrewDayOfMonth] == 13 && !([self currentDayOfTheWeek] == 6 || [self currentDayOfTheWeek] == 7))) {
                    return kFastOfEsther;
                }
                if ([self currentHebrewDayOfMonth] == 14) {
                    return kPurim;
                } else if ([self currentHebrewDayOfMonth] == 15) {
                    return kShushanPurim;
                }
            } else { // else if a leap year
                if ([self currentHebrewDayOfMonth] == 14) {
                    return kPurimKatan;
                }
            }
            break;
        case kAdar_II:
            // if 13th Adar falls on Friday or Shabbos, push back to Thursday
            if ((([self currentHebrewDayOfMonth] == 11 || [self currentHebrewDayOfMonth] == 12) && [self currentDayOfTheWeek] == 5)
                || ([self currentHebrewDayOfMonth] == 13 && !([self currentDayOfTheWeek] == 6 || [self currentDayOfTheWeek] == 7))) {
                return kFastOfEsther;
            }
            if ([self currentHebrewDayOfMonth] == 14) {
                return kPurim;
            } else if ([self currentHebrewDayOfMonth] == 15) {
                return kShushanPurim;
            }
            break;
    }
    // if we get to this stage, then there are no holidays for the given date return -1
    return -1;
}


//Returns true if the current day is Yom Tov. The method 
//returns false for Chanukah, Erev Yom tov and fast days.
- (BOOL)isYomTov{
    NSInteger holidayIndex = [self yomTovIndex];

    if ([self isErevYomTov] || holidayIndex == kChanukah || ([self isTaanis] && holidayIndex != kYomKippur)) {
        return false;
    }
    return [self yomTovIndex] != -1;    
}

//Returns true if the current day is Chol Hamoed of Pesach or Succos.
- (BOOL) isCholHamoed{
    NSInteger holidayIndex = [self yomTovIndex];
    return (holidayIndex == kCholHamoedPesach || holidayIndex == kCholHamoedSuccos);
}

//Returns true if the current day is Chol Hamoed of Succos.
- (BOOL) isCholHamoedSuccos{
    return ([self currentHebrewDayOfMonth] >= 17 && [self currentHebrewDayOfMonth] <= 20) || ([self currentHebrewDayOfMonth] == 16 && inIsrael);
}

//Returns true if the current day is Chol Hamoed of Pesach.
- (BOOL) isCholHamoedPesach{
    return [self currentHebrewMonth] == kNissan && [self isCholHamoed];
}

//Returns true if the current day is erev Yom Tov. The method returns true
//for Erev - Pesach, Shavuos, Rosh Hashana, Yom Kippur and Succos.
- (BOOL) isErevYomTov{
    NSInteger holidayIndex = [self yomTovIndex];
    return holidayIndex == kErevPesach || holidayIndex == kErevShavuos || holidayIndex == kErevRoshHashana
    || holidayIndex == kErevYomKippur || holidayIndex == kErevSuccos;    
}

// Returns true if the current day is Erev Rosh 
// Chodesh. Returns false for Erev Rosh Hashana
- (BOOL) isErevRoshChodesh{
    return ([self currentHebrewDayOfMonth] == 29 && [self currentHebrewMonth] != kElul);
}

//Return true if the day is a Taanis (fast day). Return true for 
//17 of Tammuz, Tisha B'Av, Yom Kippur, Fast of Gedalyah, 10 of
//Teves and the Fast of Esther
- (BOOL) isTaanis{
    NSInteger holidayIndex = [self yomTovIndex];
    return holidayIndex == kSeventeenthOfTammuz || holidayIndex == kTishaBeav || holidayIndex == kYomKippur
    || holidayIndex == kFastOfGedalya || holidayIndex == kTenthOfTeves || holidayIndex == kFastOfEsther;    
}

//Returns the day of Chanukah or -1 if it is not Chanukah.
- (NSInteger) dayOfChanukah{
    if ([self isChanukah]) {
        if ([self currentHebrewMonth] == kKislev) {
            return [self currentHebrewDayOfMonth] - 24;
        } else { // teves
            return [self isKislevShort] ? [self currentHebrewDayOfMonth] + 5 : [self currentHebrewDayOfMonth] + 6;
        }
    } else {
        return -1;
    }
}

//Returns if a given day is chanukah
- (BOOL) isChanukah{
    return [self yomTovIndex] == kChanukah;
}

// Returns if a given day is purim
- (BOOL) isPurim{
    return [self yomTovIndex] == kPurim;
}

//Returns if the day is Rosh Chodesh. Rosh Hashana will return false
- (BOOL)isRoshChodesh{
    return ([self currentHebrewDayOfMonth] == 1 && [self currentHebrewMonth] != kTishrei) || [self currentHebrewDayOfMonth] == 30;    
}

//returns if a given day is pesach
- (BOOL) isPesach{
    return [self yomTovIndex] == kPesach;
}

//Returns if a given day is shavuos
- (BOOL) isShavuos{
    return [self yomTovIndex] == kShavuos;
}

//Returns if a given day is succos
- (BOOL) isSuccos{
    return [self yomTovIndex] == kSuccos;
}

//Returns if a given day is simchat torah
- (BOOL) isSimchasTorah{
    if ([self currentHebrewMonth] == kTishrei) {
        if(([self currentHebrewDayOfMonth] == 22 && !inIsrael) || [self currentHebrewDayOfMonth] == 21){
            return YES;
        }
    }
    
    return NO;
}

//Returns if a given day is Shmini Atzeres
- (BOOL) isShminiAtzeres{
    return ([self currentHebrewMonth] == kTishrei && [self currentHebrewDayOfMonth] == 22);
}

#pragma mark - Kiddush Levana Code.

- (NSDate *) moladTohuAsDate{
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *tohuComponents = [[NSDateComponents alloc] init];
    [tohuComponents setCalendar:gregorianCalendar];
    [tohuComponents setYear:-3760];
    [tohuComponents setMonth:9];
    [tohuComponents setDay:6];
    [tohuComponents setHour:5];
    [tohuComponents setMinute:0];
    [tohuComponents setSecond:204*3.5];
    
    NSDate *tohu = [gregorianCalendar dateFromComponents:tohuComponents];
    
    return tohu;
}

- (NSDate *) moladByAddingMonthsToTohu:(NSInteger)numberOfMonths{
    
    NSDate *tohu = [self moladTohuAsDate];
    
    
    //
    //  For each month, add 1 day 12 hours 793 chalakim
    //
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger componentTypes = (NSYearCalendarUnit | NSMonthCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit);
    
    NSDateComponents *components = [gregorianCalendar components:componentTypes fromDate:tohu];

    NSInteger day = [components day] + (1*numberOfMonths);
    NSInteger hour = [components hour] + (12*numberOfMonths);
    NSInteger seconds = [components second] + (793*3.5*numberOfMonths);
    
    [components setDay:day];
    [components setHour:hour];
    [components setSecond:seconds];
    
    NSDate *newMolad = [gregorianCalendar dateFromComponents:components];
    
    return newMolad;
}

- (NSInteger) numberOfMonthsBetweenMoladTohuAndDate:(NSDate *)date{
    
    NSDate *tohu = [self moladTohuAsDate];
    
    NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    
    NSDateComponents *comps = [hebrewCalendar components:NSMonthCalendarUnit fromDate:tohu toDate:date options:0];
    
    return [comps month];
}

- (NSDate *)moladForDate:(NSDate*)date{
    NSUInteger monthDifference = [self numberOfMonthsBetweenMoladTohuAndDate:date];
    return [self moladByAddingMonthsToTohu:monthDifference];
}

//  Returns the molad in Standard Time in Yerushalayim as an NSDate.
//  The traditional calculation uses local time. This
//  method subtracts 20.94 minutes (20 minutes and 56.496 seconds)
//  from the local time (Har Habayis with a longitude
//  of 35.2354&deg; is 5.2354&deg; away from the %15 timezone longitude) 
//  to get to standard time. This method
//  intentionally uses standard time and not daylight savings time. 
//  Java will implicitly format the time to the default (or set) Timezone.
//
//  The Java version of this method expects 1 for Nissan and 13 for Adar II. Use the constants to avoid 
//  any confusion. Objective-C handles this differently though... Read on: 
//  
//  Objective-C uses 1 for Tishri and *8* for Nissan. Adar is 6 and 7 during a regular year. 
//  During a leap year, 7 is Adar II.
//
//

- (NSDate *) moladAsDateForMonth:(NSInteger)month ofYear:(NSInteger)year{
    NSDate *dateFromMonthAndYear = [NSDate dateWithHebrewMonth:month andDay:1 andYear:year];
    return [self moladForDate:dateFromMonthAndYear];
}

//Returns the earliest time of Kiddush Levana calculated as 3 days after the molad. 
//TODO: Currently returns the time even if it is during the day. It should return 
//the 72 Minute Tzais after to the time if the zman is between Alos and Tzais.

- (NSDate *) tchilasZmanKidushLevana3DaysForDate:(NSDate *)date{
    NSDate *molad = [self moladForDate:date];
    
    [molad dateByAddingTimeInterval:kSecondsInADay * 3];
    
    return [self moladForDate:molad];
}

//  This method exists only for KosherJava compatibility
- (NSDate *) tchilasZmanKidushLevana3DaysForMonth:(NSInteger)month ofYear:(NSInteger)year{
    NSDate *dateFromMonthAndYear = [NSDate dateWithHebrewMonth:month andDay:1 andYear:year];
    
    return [self tchilasZmanKidushLevana3DaysForDate:dateFromMonthAndYear];
}

//Returns the earliest time of Kiddush Levana calculated as 7 days after the molad. 
//TODO: Currently returns the time even if it is during the day. It should return 
//the 72 Minute Tzais after to the time if the zman is between Alos and Tzais.

- (NSDate *) tchilasZmanKidushLevana7DaysForDate:(NSDate *)date{
    NSDate *molad = [self moladForDate:date];
    
    [molad dateByAddingTimeInterval:kSecondsInADay * 7];
    
    return [self moladForDate:molad];
}

//  This method exists only for KosherJava compatibility
- (NSDate *) tchilasZmanKidushLevana7DaysForMonth:(NSInteger)month ofYear:(NSInteger)year{
    
    NSDate *dateFromMonthAndYear = [NSDate dateWithHebrewMonth:month andDay:1 andYear:year];
    
    return [self tchilasZmanKidushLevana7DaysForDate:dateFromMonthAndYear];
}

//Returns the latest time of Kiddush Levana according to the 
//<a href="http://en.wikipedia.org/wiki/Yaakov_ben_Moshe_Levi_Moelin">Maharil's</a> opinion 
//that it is calculated as
//halfway between molad and molad. This adds half the 29 days, 12 hours and 793 chalakim 
//time between molad and
// molad (14 days, 18 hours, 22 minutes and 666 milliseconds) to the month's molad. 
//TODO:Currently returns the time even if it is during the day. 
//It should return the 72 Minute Alos
// prior to the time if the zman is between Alos and Tzais.

- (NSDate *) sofZmanKidushLevanaBetweenMoldosForDate:(NSDate *)date{
    
    //  Get the molad
    
    NSDate *molad = [self moladForDate:date];
    
    //
    //  Get an NSDate for one month later
    //
    
    NSCalendar *hebrewCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSHebrewCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    
    NSDate *nextMonth = [hebrewCalendar dateByAddingComponents:comps toDate:date options:0];
    
    //  Get the next molad
    
    NSDate *nextMolad = [self moladForDate:nextMonth];
    
    //
    //  Pull out the number of seconds in between the two moladot
    //
    
    NSDateComponents *secondsComps = [hebrewCalendar components:NSSecondCalendarUnit fromDate:molad toDate:nextMolad options:0];
    
    
    molad = [molad dateByAddingTimeInterval:[secondsComps second]];
    
    return molad;

    
}

//  This method exists only for KosherJava compatibility
- (NSDate *) sofZmanKidushLevanaBetweenMoldosForMonth:(NSInteger)month ofYear:(NSInteger)year{
    
    //
    //  Convert the month and day into an NSDate
    //
    
    NSDate *dateFromMonthAndYear = [NSDate dateWithHebrewMonth:month andDay:1 andYear:year];
    
    return [self sofZmanKidushLevanaBetweenMoldosForDate:dateFromMonthAndYear];
}

//Returns the latest time of Kiddush Levana calculated as 15 days after the molad. 
//  This is the opinion brought down
// in the Shulchan Aruch (Orach Chaim 426). It should be noted that some opinions hold that the
// <http://en.wikipedia.org/wiki/Moses_Isserles">Rema</a> who brings down the opinion of the <a
// href="http://en.wikipedia.org/wiki/Yaakov_ben_Moshe_Levi_Moelin">Maharil's</a> of calculating
// half way between molad and molad is of the opinion that the Mechaber agrees to his opinion.
//  Also see the Aruch Hashulchan. 
//  For additional details on the subject, See Rabbi
// Dovid Heber's very detailed writeup in Siman Daled (chapter 4) of <a
// href="http://www.worldcat.org/oclc/461326125">Shaarei Zmanim</a>. TODO: Currently returns the time even if it is
// during the day. It should return the  Alos prior to the
// time if the zman is between Alos and Tzais.

- (NSDate *) sofZmanKidushLevana15DaysForDate:(NSDate *)date{
    //  Get the molad
    
    NSDate *molad = [self moladForDate:date];
    
    
    return [molad dateByAddingTimeInterval:kSecondsInADay * 15];
}

//  This method exists only for KosherJava compatibility
- (NSDate *) sofZmanKidushLevana15DaysForMonth:(NSInteger)month ofYear:(NSInteger)year{
    
    //
    //  Convert the month and day into an NSDate
    //
    
    NSDate *dateFromMonthAndYear = [NSDate dateWithHebrewMonth:month andDay:1 andYear:year];
    
    return [self sofZmanKidushLevana15DaysForDate:dateFromMonthAndYear];

}

//Returns the Daf Yomi (Bavli) for the date that the calendar is set to.
- (Daf *)dafYomiBavli{
    YomiCalculator *calculator = [[YomiCalculator alloc] initWithDate:self.workingDate];
    return [calculator dafYomiBavliForDate:self.workingDate];

}

#pragma mark - Calendar Utility Methods

//Returns the current hebrew month
- (NSInteger) currentHebrewMonth{
    NSDate *now = [NSDate date];
    NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    return [[hebrewCalendar components:NSMonthCalendarUnit fromDate:now] month];
}

//Returns the day of the current hebrew month
- (NSInteger) currentHebrewDayOfMonth{
    NSDate *now = [NSDate date];
    NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    return [[hebrewCalendar components:NSDayCalendarUnit fromDate:now] day];    
}

//Returns the current day of the week
- (NSInteger) currentDayOfTheWeek{
    NSDate *now = [NSDate date];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [[gregorianCalendar components:NSWeekdayCalendarUnit fromDate:now] weekday];    
}

//Determine if the current year is a hebrew leap year
- (BOOL) isCurrentlyHebrewLeapYear{
    NSDate *now = [NSDate date];
    NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    NSInteger year = [[hebrewCalendar components:NSYearCalendarUnit fromDate:now] year];
    return [self isHebrewLeapYear:year];
}

//	Check if a given year is a leap year
- (BOOL) isHebrewLeapYear:(NSInteger)year{
	return ((7 * year + 1) % 19) < 7;
}
//Determine if kislev is short this year
- (BOOL) isKislevShort{
    return [self lengthOfYearForYear:[self currentHebrewYear]] % 10 == 3;
}

//Get the current hebrew year
- (NSInteger) currentHebrewYear{
    NSDate *now = [NSDate date];
    NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    return [[hebrewCalendar components:NSYearCalendarUnit fromDate:now] year];
}

#pragma mark - Year Length

- (NSInteger) lengthOfYearForYear:(NSInteger)year{
    
    //  Create a Hebrew calendar object.
	NSCalendar *hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
	
	//	Get the first day of the current hebrew year.
	NSDateComponents *roshHashanaComponents = [[NSDateComponents alloc] init];
	
    //
    //  Set the components to the 
    //  first day of this year.
    //
    
	[roshHashanaComponents setDay:1];
	[roshHashanaComponents setMonth:1];
	[roshHashanaComponents setYear:year];
	[roshHashanaComponents setHour:12];
	[roshHashanaComponents setMinute:0];
	[roshHashanaComponents setSecond:0];
	
    //
    //  Get an NSDate from the "roshHashanaComponents" object,
    //  using the NSHebrewCalendar which we set up earlier.
    //
    
	NSDate *roshHashanaDate = [hebrewCalendar dateFromComponents:roshHashanaComponents];
	
    //
	//	Now, convert that Hebrew date to a Gregorian date.
	//
    
	NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
    //
    //  Set up the date components to use with the length calculation
    //
    
	NSDateComponents *gregorianDayComponentsForRoshHashana = [gregorianCalendar components:NSWeekdayCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:roshHashanaDate];
	
    //
	//  Determine the day of the week of the first day of the current hebrew year
    //
    
	NSDate *oneTishreiAsGregorian = [gregorianCalendar dateFromComponents:gregorianDayComponentsForRoshHashana];
	
	//
	//	Then get the first day of the current hebrew year
	//
	
	NSDateComponents *roshHashanaOfNextYearComponents = [[NSDateComponents alloc] init];
	
    NSInteger tempYear = year+1;
    
    //
    //  Set the components to the 
    //  first day of next year.
    //
    
	[roshHashanaOfNextYearComponents setDay:1];
	[roshHashanaOfNextYearComponents setMonth:1];
	[roshHashanaOfNextYearComponents setYear:tempYear];
	[roshHashanaOfNextYearComponents setHour:12];
	[roshHashanaOfNextYearComponents setMinute:0];
	[roshHashanaOfNextYearComponents setSecond:0];
	
	NSDate *roshHashanaOfNextYearAsDate = [hebrewCalendar dateFromComponents:roshHashanaOfNextYearComponents];
    
    //
	//	Then convert that to 
    //  the Gregorian calendar.
	//
    
	NSDateComponents *gregorianDayComponentsForRoshHashanaOfNextYear = [gregorianCalendar components:NSWeekdayCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit fromDate:roshHashanaOfNextYearAsDate];
	
    
    //
	//  Determine the first day of the 
    //  week of the next hebrew year
	//
    
    NSDate *oneTishreiOfNextYearAsGregorian = [gregorianCalendar dateFromComponents:gregorianDayComponentsForRoshHashanaOfNextYear];
	
    //
	//	Length of this year 
    //  in days, as an NSTimeInterval
    //  which actually a double
    //
    
	NSTimeInterval totalDaysInTheYear = [oneTishreiOfNextYearAsGregorian timeIntervalSinceReferenceDate] - [oneTishreiAsGregorian timeIntervalSinceReferenceDate];
	
    //
    //  Here, we calculate the total 
    //  number of days in the year.
    //
    //  Fun Fact: There are 86,400 seconds in a day
    //
    
	totalDaysInTheYear = totalDaysInTheYear/kSecondsInADay;
    
    //
    //  This rounding may be unnecessary, 
    //  but I'm not ready to remove it.
    //
    //  I think this was a faux fix of an 
    //  earlier bug, which was the lack 
    //  of an NSDateComponents specefier.
    //
    
    //totalDaysInTheYear = round(totalDaysInTheYear);
    
    //
    //  Here, we convert the result
    //  into an integer, so that we
    //  can easily use the result
    //  later on, in the yeartype 
    //  dependent methods.
    //
    
    if(totalDaysInTheYear == 353 || totalDaysInTheYear == 383){
		totalDaysInTheYear = 0;
	}else if(totalDaysInTheYear == 354 || totalDaysInTheYear == 384){
		totalDaysInTheYear = 1;
	}else if(totalDaysInTheYear == 355 || totalDaysInTheYear == 385){
		totalDaysInTheYear = 2;
	}
    
    return totalDaysInTheYear;
}

#pragma mark - Molad Methods

//Converts the the Nissan based constants used by 
//this class to numeric month starting from Tishrei.
//This is required for Molad claculations.

- (NSInteger) adjustedMonthToStartFromTishreiForMonth:(NSInteger)month ofYear:(NSInteger)year{
    BOOL isLeapYear = [self isHebrewLeapYear:[self currentHebrewYear]];
    return (month + (isLeapYear ? 6 : 5)) % (isLeapYear ? 13 : 12) + 1;
}

- (NSInteger) chalakimSinceMoladTohuForMonth:(NSInteger)month andYear:(NSInteger)year{
    NSInteger monthOfYear = [self adjustedMonthToStartFromTishreiForMonth:month ofYear:year];
    NSInteger monthsElapsed = (235 * ((year - 1) / 19)) // Months in complete 19 year lunar (Metonic) cycles so far
    + (12 * ((year - 1) % 19)) // Regular months in this cycle
    + ((7 * ((year - 1) % 19) + 1) / 19) // Leap months this cycle
    + (monthOfYear - 1); // add elapsed months till the start of the molad of the month
    // return chalakim prior to BeHaRaD + number of chalakim since
    return kChalakimMoladTohu + (kChalakimPerMonth * monthsElapsed);    
}

//
//  Returns the friday following a given date
//

- (NSDate *) fridayFollowingDate:(NSDate *)workingDate{
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *gregorianDateComponents = [gregorianCalendar components:NSWeekdayCalendarUnit fromDate:workingDate];
 	
	int weekday = [gregorianDateComponents weekday];
    
    return [NSDate dateWithTimeInterval:(kSecondsInADay * (6-weekday)) sinceDate:workingDate];
    
}

@end