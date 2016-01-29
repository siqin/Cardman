//
//  CLPerson.m
//  Cardman
//
//  Created by Jason Lee on 16/1/25.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import "CLPerson.h"
#import "CLCardman.h"

@implementation CLPerson

+ (CLPerson *)personFromABRecordRef:(ABRecordRef)abRecordRef {
    CLPerson *clPerson = [CLPerson new];
    
    clPerson.recordId = @(ABRecordGetRecordID(abRecordRef));
    
    NSData *data = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(abRecordRef, kABPersonImageFormatThumbnail);
    if (data) clPerson.avatar = [UIImage imageWithData:data scale:UIScreen.mainScreen.scale];
    
    [CLPerson extractNameFromABRecordRef:abRecordRef intoCLPerson:clPerson];
    
    [CLPerson extractPhonesFromABRecordRef:abRecordRef intoCLPerson:clPerson];
    
    [CLPerson extractRecordDateFromABRecordRef:abRecordRef intoCLPerson:clPerson];
    
    return clPerson;
}

#pragma mark - getter for lazy load

- (NSDate *)birthday {
    if (!_birthday) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        _birthday = [CLPerson readDateProperty:kABPersonBirthdayProperty fromABRecordRef:abRecrodRef];
    }
    return _birthday;
}

- (NSString *)note {
    if (!_note) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        _note = [CLPerson readStringProperty:kABPersonNoteProperty fromABRecordRef:abRecrodRef];
    }
    return _note;
}

- (CLJob *)job {
    if (!_job) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        _job = [CLJob new];
        _job.organization = [CLPerson readStringProperty:kABPersonOrganizationProperty fromABRecordRef:abRecrodRef];
        _job.department = [CLPerson readStringProperty:kABPersonDepartmentProperty fromABRecordRef:abRecrodRef];
        _job.title = [CLPerson readStringProperty:kABPersonJobTitleProperty fromABRecordRef:abRecrodRef];
    }
    return _job;
}

- (NSArray <CLAddress *> *)addresses {
    if (!_addresses) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractAddressesFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _addresses;
}

- (NSArray <CLEmail *> *)emails {
    if (!_emails) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractEmailsFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _emails;
}

- (NSArray <NSString *> *)websites {
    if (!_websites) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractWebsitesFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _websites;
}

- (NSArray <CLPersonDate *> *)dates {
    if (!_dates) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractDatesFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _dates;
}

- (NSArray <CLSocialProfile *> *)socialProfiles {
    if (!_socialProfiles) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractSocialProfilesFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _socialProfiles;
}

- (NSArray <CLInstantMessage *> *)IMAccounts {
    if (!_IMAccounts) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractIMAccountsFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _IMAccounts;
}

- (NSArray <CLRelatedName *> *)relatedNames {
    if (!_relatedNames) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractRelatedNamesFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _relatedNames;
}

- (NSArray <NSNumber *> *)linkedRecordIDs {
    if (!_linkedRecordIDs) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractLinkedRecordIdsFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _linkedRecordIDs;
}

- (CLRecordSource *)source {
    if (!_source) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractRecordSourceFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _source;
}

- (CLAlternateBirthday *)alternateBirthday {
    if (!_alternateBirthday) {
        ABRecordRef abRecrodRef = ABAddressBookGetPersonWithRecordID([CLCardman sharedInstance].abRef, self.recordId.intValue);
        [CLPerson extractAlternateBirthdayFromABRecordRef:abRecrodRef intoCLPerson:self];
    }
    return _alternateBirthday;
}

#pragma mark - extract properties

+ (void)extractNameFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    clPerson.name = [CLName new];
    
    clPerson.name.firstName = [CLPerson readStringProperty:kABPersonFirstNameProperty fromABRecordRef:abRecordRef];
    clPerson.name.lastName = [CLPerson readStringProperty:kABPersonLastNameProperty fromABRecordRef:abRecordRef];
    clPerson.name.middleName = [CLPerson readStringProperty:kABPersonMiddleNameProperty fromABRecordRef:abRecordRef];
    
    clPerson.name.compositeName =  (__bridge_transfer NSString *)ABRecordCopyCompositeName(abRecordRef);
    clPerson.name.nickname =  [CLPerson readStringProperty:kABPersonNicknameProperty fromABRecordRef:abRecordRef];
    
    clPerson.name.prefix =  [CLPerson readStringProperty:kABPersonPrefixProperty fromABRecordRef:abRecordRef];
    clPerson.name.suffix =  [CLPerson readStringProperty:kABPersonSuffixProperty fromABRecordRef:abRecordRef];
    
    clPerson.name.firstNamePhonetic = [CLPerson readStringProperty:kABPersonFirstNamePhoneticProperty fromABRecordRef:abRecordRef];
    clPerson.name.lastNamePhonetic = [CLPerson readStringProperty:kABPersonLastNamePhoneticProperty fromABRecordRef:abRecordRef];
    clPerson.name.middleNamePhonetic = [CLPerson readStringProperty:kABPersonMiddleNamePhoneticProperty fromABRecordRef:abRecordRef];
}

+ (void)extractPhonesFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLPhone *> *phones = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonPhoneProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLPhone *clPhone = [CLPhone new];
            
            clPhone.number = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            clPhone.originalLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
            clPhone.localizedLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(clPhone.originalLabel));
            
            [phones addObject:clPhone];
        }
        CFRelease(multiValue);
    }
    
    clPerson.phones = phones.count > 0 ? phones : nil;
}

+ (void)extractRecordDateFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    CLRecordDate *clRecordDate = [CLRecordDate new];
    
    clRecordDate.createDate = [self readDateProperty:kABPersonCreationDateProperty fromABRecordRef:abRecordRef];
    clRecordDate.modifyDate = [self readDateProperty:kABPersonModificationDateProperty fromABRecordRef:abRecordRef];
    
    clPerson.recordDate = clRecordDate;
}

+ (void)extractAddressesFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLAddress *> *addresses = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonPhoneProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLAddress *clAddress = [CLAddress new];
            
            clAddress.originalLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
            clAddress.localizedLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(clAddress.originalLabel));
            
            NSDictionary *dict = (__bridge NSDictionary *)(ABMultiValueCopyValueAtIndex(multiValue, i));
            clAddress.street = dict[(__bridge NSString *)kABPersonAddressStreetKey];
            clAddress.city = dict[(__bridge NSString *)kABPersonAddressCityKey];
            clAddress.state = dict[(__bridge NSString *)kABPersonAddressStateKey];
            clAddress.zip = dict[(__bridge NSString *)kABPersonAddressZIPKey];
            clAddress.country = dict[(__bridge NSString *)kABPersonAddressCountryKey];
            clAddress.countryCode = dict[(__bridge NSString *)kABPersonAddressCountryCodeKey];
            
            [addresses addObject:clAddress];
        }
        CFRelease(multiValue);
    }
    
    clPerson.addresses = addresses.count > 0 ? addresses : nil;
}

+ (void)extractEmailsFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLEmail *> *emails = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonEmailProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLEmail *clEmail = [CLEmail new];
            
            clEmail.address = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            clEmail.originalLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
            clEmail.localizedLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(clEmail.originalLabel));
            
            [emails addObject:clEmail];
        }
        CFRelease(multiValue);
    }
    
    clPerson.emails = emails.count > 0 ? emails : nil;
}

+ (void)extractWebsitesFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <NSString *> *websites = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonPhoneProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            NSString *website = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            [websites addObject:website];
        }
        CFRelease(multiValue);
    }
    
    clPerson.websites = websites.count > 0 ? websites : nil;
}

+ (void)extractDatesFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLPersonDate *> *dates = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonDateProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLPersonDate *date = [CLPersonDate new];
            date.date = (__bridge_transfer NSDate *)ABMultiValueCopyValueAtIndex(multiValue, i);
            date.originalLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
            date.localizedLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(date.originalLabel));
            [dates addObject:date];
        }
        CFRelease(multiValue);
    }
    
    clPerson.dates = dates.count > 0 ? dates : nil;
}

+ (void)extractSocialProfilesFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLSocialProfile *> *profiles = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonSocialProfileProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLSocialProfile *profile = [CLSocialProfile new];
            NSDictionary *dictionary = (__bridge_transfer NSDictionary *)ABMultiValueCopyValueAtIndex(multiValue, i);
            profile.type = [CLSocialProfile typeFromSocialServiceKey:dictionary[(__bridge NSString *)kABPersonSocialProfileServiceKey]];
            profile.url = dictionary[(__bridge NSString *)kABPersonSocialProfileURLKey];
            profile.username = dictionary[(__bridge NSString *)kABPersonSocialProfileUsernameKey];
            profile.userIdentifier = dictionary[(__bridge NSString *)kABPersonSocialProfileUserIdentifierKey];
            [profiles addObject:profile];
        }
        CFRelease(multiValue);
    }
    
    clPerson.socialProfiles = profiles.count > 0 ? profiles : nil;
}

+ (void)extractIMAccountsFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLInstantMessage *> *accounts = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonSocialProfileProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLInstantMessage *im = [CLInstantMessage new];
            NSDictionary *dictionary = (__bridge_transfer NSDictionary *)ABMultiValueCopyValueAtIndex(multiValue, i);
            im.type = [CLInstantMessage typeFromIMServiceKey:dictionary[(__bridge NSString *)kABPersonInstantMessageServiceKey]];
            im.username = dictionary[(__bridge NSString *)kABPersonInstantMessageUsernameKey];
            [accounts addObject:im];
        }
        CFRelease(multiValue);
    }
    
    clPerson.IMAccounts = accounts.count > 0 ? accounts : nil;
}

+ (void)extractRelatedNamesFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableArray <CLRelatedName *> *names = [[NSMutableArray alloc] init];
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonEmailProperty);
    if (multiValue) {
        CFIndex count = ABMultiValueGetCount(multiValue);
        for (CFIndex i = 0; i < count; i++) {
            CLRelatedName *name = [CLRelatedName new];
            
            name.name = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            name.originalLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
            name.localizedLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(name.originalLabel));
            
            [names addObject:name];
        }
        CFRelease(multiValue);
    }
    
    clPerson.relatedNames = names.count > 0 ? names : nil;
}

+ (void)extractLinkedRecordIdsFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    NSMutableOrderedSet *linkedRecordIDs = [[NSMutableOrderedSet alloc] init];
    CFArrayRef linkedPeopleRef = ABPersonCopyArrayOfAllLinkedPeople(abRecordRef);
    CFIndex count = CFArrayGetCount(linkedPeopleRef);
    NSNumber *contactRecordID = @(ABRecordGetRecordID(abRecordRef));
    for (CFIndex i = 0; i < count; i++) {
        ABRecordRef linkedRecordRef = CFArrayGetValueAtIndex(linkedPeopleRef, i);
        NSNumber *linkedRecordID = @(ABRecordGetRecordID(linkedRecordRef));
        if (![linkedRecordID isEqualToNumber:contactRecordID]) {
            [linkedRecordIDs addObject:linkedRecordID];
        }
    }
    CFRelease(linkedPeopleRef);
    clPerson.linkedRecordIDs = linkedRecordIDs.array;
}

+ (void)extractRecordSourceFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    ABRecordRef sourceRef = ABPersonCopySource(abRecordRef);
    if (sourceRef) {
        CLRecordSource *source = [[CLRecordSource alloc] init];
        source.sourceType = [self readStringProperty:kABSourceNameProperty fromABRecordRef:abRecordRef];
        source.sourceID =  @(ABRecordGetRecordID(sourceRef));
        clPerson.source = source;
        
        CFRelease(sourceRef);
    }
}

+ (void)extractAlternateBirthdayFromABRecordRef:(ABRecordRef)abRecordRef intoCLPerson:(CLPerson *)clPerson {
    ABMultiValueRef multiValue = ABRecordCopyValue(abRecordRef, kABPersonAlternateBirthdayProperty);
    if (multiValue) {
        CLAlternateBirthday *birthday = [CLAlternateBirthday new];
        NSDictionary *dictionary = (__bridge_transfer NSDictionary *)multiValue;
        // kCFChineseCalendar
        birthday.calendarIdentifier = dictionary[(__bridge NSString *)kABPersonAlternateBirthdayCalendarIdentifierKey];
        birthday.era = [dictionary[(__bridge NSString *)kABPersonAlternateBirthdayEraKey] integerValue];
        birthday.year = [dictionary[(__bridge NSString *)kABPersonAlternateBirthdayYearKey] integerValue];
        birthday.month = [dictionary[(__bridge NSString *)kABPersonAlternateBirthdayMonthKey] integerValue];
        birthday.day = [dictionary[(__bridge NSString *)kABPersonAlternateBirthdayDayKey] integerValue];
        birthday.isLeapMonth = [dictionary[(__bridge NSString *)kABPersonAlternateBirthdayIsLeapMonthKey] boolValue];
        clPerson.alternateBirthday = birthday;
        
        CFRelease(multiValue);
    }
}

#pragma mark -

+ (NSString *)readStringProperty:(ABPropertyID)propertyId fromABRecordRef:(ABRecordRef)abRecordRef {
    CFTypeRef valueRef = (ABRecordCopyValue(abRecordRef, propertyId));
    return (__bridge_transfer NSString *)valueRef;
}

+ (NSDate *)readDateProperty:(ABPropertyID)propertyId fromABRecordRef:(ABRecordRef)abRecordRef {
    CFDateRef dateRef = ABRecordCopyValue(abRecordRef, propertyId);
    return (__bridge_transfer NSDate *)dateRef;
}

@end
