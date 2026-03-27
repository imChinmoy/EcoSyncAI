import 'package:flutter/material.dart';

/// English / Hindi UI strings. Default locale is English.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  String _t(String key) {
    final code = locale.languageCode;
    return _strings[code]?[key] ?? _strings['en']![key]!;
  }

  // App
  String get appTitle => _t('app_title');

  // Bottom navigation
  String get navHome => _t('nav_home');
  String get navReport => _t('nav_report');
  String get navMap => _t('nav_map');
  String get navProfile => _t('nav_profile');

  // Profile
  String get profileTitle => _t('profile_title');
  String get profileSubtitle => _t('profile_subtitle');
  String get profileUserName => _t('profile_user_name');
  String get communityVolunteer => _t('community_volunteer');
  String get wardMonitor => _t('ward_monitor');
  String get editProfileSoon => _t('edit_profile_soon');
  String get statReports => _t('stat_reports');
  String get statScans => _t('stat_scans');
  String get statPoints => _t('stat_points');
  String get preferences => _t('preferences');
  String get pushNotifications => _t('push_notifications');
  String get pushNotificationsSubtitle => _t('push_notifications_subtitle');
  String get language => _t('language');
  String get languageEnglish => _t('language_english');
  String get languageHindi => _t('language_hindi');
  String get helpSupport => _t('help_support');
  String get helpSupportSubtitle => _t('help_support_subtitle');
  String get account => _t('account');
  String get privacyPolicy => _t('privacy_policy');
  String get clearSavedSession => _t('clear_saved_session');
  String get clearSavedSessionSubtitle => _t('clear_saved_session_subtitle');
  String get sessionCleared => _t('session_cleared');

  // Report
  String get reportIssueTitle => _t('report_issue_title');
  String get selectWard => _t('select_ward');
  String get selectedBin => _t('selected_bin');
  String get describeIssue => _t('describe_issue');
  String get issueHint => _t('issue_hint');
  String get addPhoto => _t('add_photo');
  String get submitComplaint => _t('submit_complaint');
  String get captureImageFirst => _t('capture_image_first');
  String get selectWardFirst => _t('select_ward_first');
  String get tapToTakePhoto => _t('tap_to_take_photo');
  String get retakePhoto => _t('retake_photo');

  // Map / home
  String get nearbyBins => _t('nearby_bins');
  String get wasteBins => _t('waste_bins');
  String get filtersActive => _t('filters_active');
  String get clear => _t('clear');
  String get filterBins => _t('filter_bins');
  String get status => _t('status');
  String get category => _t('category');
  String get applyFilters => _t('apply_filters');
  String get applyArrow => _t('apply_arrow');
  String get capacity => _t('capacity');
  String get percentFull => _t('percent_full');
  String get reportIssue => _t('report_issue');
  String get myLocation => _t('my_location');
  String get binsWord => _t('bins_word');
  String get labelFull => _t('label_full');
  String get labelFilling => _t('label_filling');
  String get labelEmpty => _t('label_empty');
  String get mapFillingRateBanner => _t('map_filling_rate_banner');
  String get addressLabel => _t('address_label');
  String get lastUpdatedLabel => _t('last_updated_label');
  String get confidenceLabel => _t('confidence_label');
  String get adviceLabel => _t('advice_label');
  String get mapNoBinsTitle => _t('map_no_bins_title');
  String get mapNoBinsSubtitle => _t('map_no_bins_subtitle');
  String get mapErrorGeneric => _t('map_error_generic');
  String get locationPermissionDenied => _t('location_permission_denied');

  // Home
  String get globalCitizen => _t('global_citizen');
  String get helloAlex => _t('hello_alex');
  String get diverted => _t('diverted');
  String get offset => _t('offset');
  String get nearbySchedules => _t('nearby_schedules');
  String get materialsSaved => _t('materials_saved');
  String get history => _t('history');
  String get identifySort => _t('identify_sort');
  String get sortCameraHint => _t('sort_camera_hint');
  String get launchAiScanner => _t('launch_ai_scanner');
  String get activeHubs => _t('active_hubs');
  String get biodegradable => _t('biodegradable');
  String get organicWaste => _t('organic_waste');
  String get recyclables => _t('recyclables');
  String get plasticPaper => _t('plastic_paper');
  String get eWaste => _t('e_waste');
  String get electronics => _t('electronics');
  String get success => _t('success');
  String get tracking => _t('tracking');
  String get ecoTierGold => _t('eco_tier_gold');
  String get pointsSuffix => _t('points_suffix');
  String get findDropoffNearby => _t('find_dropoff_nearby');
  String get recycleDay => _t('recycle_day');
  String get scheduleDaySample => _t('schedule_day_sample');

  // Scanner
  String get scanResult => _t('scan_result');
  String get itemLabel => _t('item_label');
  String get close => _t('close');

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'app_title': 'EcoSync AI',
      'nav_home': 'Home',
      'nav_report': 'Report',
      'nav_map': 'Map',
      'nav_profile': 'Profile',
      'profile_title': 'Profile',
      'profile_subtitle': 'Manage your account and preferences',
      'profile_user_name': 'EcoSync User',
      'community_volunteer': 'Community volunteer',
      'ward_monitor': 'Ward Monitor',
      'edit_profile_soon': 'Edit profile will be available soon.',
      'stat_reports': 'Reports',
      'stat_scans': 'Scans',
      'stat_points': 'Points',
      'preferences': 'Preferences',
      'push_notifications': 'Push Notifications',
      'push_notifications_subtitle':
          'Alerts for nearby full bins and updates',
      'language': 'Language',
      'language_english': 'English',
      'language_hindi': 'Hindi',
      'help_support': 'Help & Support',
      'help_support_subtitle': 'FAQs and contact options',
      'account': 'Account',
      'privacy_policy': 'Privacy Policy',
      'clear_saved_session': 'Clear Saved Session',
      'clear_saved_session_subtitle':
          'Removes local auth token from this device',
      'session_cleared': 'Saved session cleared.',
      'report_issue_title': 'Report Issue',
      'select_ward': 'Select Ward',
      'selected_bin': 'Selected Bin',
      'describe_issue': 'Describe the Issue',
      'issue_hint': 'e.g., Bin is overflowing...',
      'add_photo': 'Add Photo',
      'submit_complaint': 'Submit Complaint',
      'capture_image_first': 'Please capture an image before submitting.',
      'select_ward_first': 'Please select a ward first',
      'tap_to_take_photo': 'Tap to take a photo',
      'retake_photo': 'Retake Photo',
      'nearby_bins': 'Nearby Bins',
      'waste_bins': 'Waste Bins',
      'filters_active': 'Filters active',
      'clear': 'Clear',
      'filter_bins': 'Filter Bins',
      'status': 'Status',
      'category': 'Category',
      'apply_filters': 'Apply Filters',
      'apply_arrow': 'Apply →',
      'capacity': 'Capacity',
      'percent_full': '% Full',
      'report_issue': 'Report Issue',
      'my_location': 'My location',
      'bins_word': 'bins',
      'label_full': 'Full',
      'label_filling': 'Filling',
      'label_empty': 'Empty',
      'map_filling_rate_banner': 'High filling rate in Ward 2',
      'address_label': 'Address',
      'last_updated_label': 'Last Updated',
      'confidence_label': 'Confidence',
      'advice_label': 'Advice',
      'map_no_bins_title': 'No bins in this ward',
      'map_no_bins_subtitle': 'All clear — no bins to show.',
      'map_error_generic': 'Something went wrong',
      'location_permission_denied':
          'Location permission denied. Enable it to show your live position.',
      'global_citizen': 'GLOBAL CITIZEN',
      'hello_alex': 'Hello, Alex',
      'diverted': 'Diverted',
      'offset': 'Offset',
      'nearby_schedules': 'Nearby & Schedules',
      'materials_saved': 'Materials Saved',
      'history': 'HISTORY',
      'identify_sort': 'Identify & Sort',
      'sort_camera_hint':
          'Point your camera at any waste\nitem to get instant AI sorting\nadvice.',
      'launch_ai_scanner': 'Launch AI Scanner',
      'active_hubs': '3 ACTIVE HUBS',
      'biodegradable': 'Biodegradable',
      'organic_waste': 'Organic Waste',
      'recyclables': 'Recyclables',
      'plastic_paper': 'Plastic & Paper',
      'e_waste': 'E-Waste',
      'electronics': 'Electronics',
      'success': 'SUCCESS',
      'tracking': 'TRACKING',
      'eco_tier_gold': 'ECO TIER: GOLD',
      'points_suffix': ' pts',
      'find_dropoff_nearby': 'Find a drop-off point within 500m',
      'recycle_day': 'RECYCLE DAY',
      'schedule_day_sample': 'Tue 14',
      'scan_result': 'Scan Result',
      'item_label': 'Item',
      'close': 'Close',
    },
    'hi': {
      'app_title': 'इकोसिंक AI',
      'nav_home': 'होम',
      'nav_report': 'रिपोर्ट',
      'nav_map': 'मानचित्र',
      'nav_profile': 'प्रोफ़ाइल',
      'profile_title': 'प्रोफ़ाइल',
      'profile_subtitle': 'अपना खाता और वरीयताएँ प्रबंधित करें',
      'profile_user_name': 'इकोसिंक उपयोगकर्ता',
      'community_volunteer': 'सामुदायिक स्वयंसेवक',
      'ward_monitor': 'वार्ड मॉनिटर',
      'edit_profile_soon': 'प्रोफ़ाइल संपादन जल्द उपलब्ध होगा।',
      'stat_reports': 'रिपोर्ट',
      'stat_scans': 'स्कैन',
      'stat_points': 'अंक',
      'preferences': 'वरीयताएँ',
      'push_notifications': 'पुश सूचनाएँ',
      'push_notifications_subtitle':
          'निकट भरे डिब्बों और अपडेट के लिए अलर्ट',
      'language': 'भाषा',
      'language_english': 'अंग्रेज़ी',
      'language_hindi': 'हिंदी',
      'help_support': 'सहायता और समर्थन',
      'help_support_subtitle': 'अक्सर पूछे जाने वाले प्रश्न और संपर्क',
      'account': 'खाता',
      'privacy_policy': 'गोपनीयता नीति',
      'clear_saved_session': 'सहेजा सत्र साफ़ करें',
      'clear_saved_session_subtitle':
          'इस डिवाइस से स्थानीय प्रमाण पत्र हटाएँ',
      'session_cleared': 'सहेजा सत्र साफ़ कर दिया गया।',
      'report_issue_title': 'समस्या रिपोर्ट करें',
      'select_ward': 'वार्ड चुनें',
      'selected_bin': 'चयनित डिब्बा',
      'describe_issue': 'समस्या का वर्णन करें',
      'issue_hint': 'उदा., डिब्बा लबालब है...',
      'add_photo': 'फ़ोटो जोड़ें',
      'submit_complaint': 'शिकायत दर्ज करें',
      'capture_image_first': 'जमा करने से पहले कृपया एक छवि लें।',
      'select_ward_first': 'कृपया पहले वार्ड चुनें',
      'tap_to_take_photo': 'फ़ोटो लेने के लिए टैप करें',
      'retake_photo': 'फ़ोटो फिर से लें',
      'nearby_bins': 'निकट डिब्बे',
      'waste_bins': 'कचरा डिब्बे',
      'filters_active': 'फ़िल्टर सक्रिय',
      'clear': 'साफ़ करें',
      'filter_bins': 'डिब्बे फ़िल्टर करें',
      'status': 'स्थिति',
      'category': 'श्रेणी',
      'apply_filters': 'फ़िल्टर लागू करें',
      'apply_arrow': 'लागू करें →',
      'capacity': 'क्षमता',
      'percent_full': '% भरा',
      'report_issue': 'समस्या रिपोर्ट करें',
      'my_location': 'मेरा स्थान',
      'bins_word': 'डिब्बे',
      'label_full': 'पूर्ण',
      'label_filling': 'भर रहा',
      'label_empty': 'खाली',
      'map_filling_rate_banner': 'वार्ड 2 में उच्च भरण दर',
      'address_label': 'पता',
      'last_updated_label': 'अंतिम अपडेट',
      'confidence_label': 'विश्वास',
      'advice_label': 'सलाह',
      'map_no_bins_title': 'इस वार्ड में कोई डिब्बा नहीं',
      'map_no_bins_subtitle': 'सब साफ़ — दिखाने के लिए कोई डिब्बा नहीं।',
      'map_error_generic': 'कुछ गलत हो गया',
      'location_permission_denied':
          'स्थान अनुमति अस्वीकृत। अपनी लाइव स्थिति दिखाने के लिए इसे सक्षम करें।',
      'global_citizen': 'वैश्विक नागरिक',
      'hello_alex': 'नमस्ते, Alex',
      'diverted': 'विचलित',
      'offset': 'ऑफ़सेट',
      'nearby_schedules': 'निकट और समय सारणी',
      'materials_saved': 'बचाई गई सामग्री',
      'history': 'इतिहास',
      'identify_sort': 'पहचानें और छाँटें',
      'sort_camera_hint':
          'तुरंत AI छँटाई सलाह के लिए\nकैमरा किसी भी कचरे की वस्तु पर रखें।',
      'launch_ai_scanner': 'AI स्कैनर चालू करें',
      'active_hubs': '3 सक्रिय केंद्र',
      'biodegradable': 'जैविक अपघट्य',
      'organic_waste': 'जैविक कचरा',
      'recyclables': 'पुनर्चक्रण योग्य',
      'plastic_paper': 'प्लास्टिक और कागज़',
      'e_waste': 'ई-कचरा',
      'electronics': 'इलेक्ट्रॉनिक्स',
      'success': 'सफल',
      'tracking': 'ट्रैकिंग',
      'eco_tier_gold': 'इको स्तर: गोल्ड',
      'points_suffix': ' अंक',
      'find_dropoff_nearby': '500 मीटर के भीतर ड्रॉप-ऑफ़ बिंदु खोजें',
      'recycle_day': 'रीसाइकल दिवस',
      'schedule_day_sample': 'मंगल 14',
      'scan_result': 'स्कैन परिणाम',
      'item_label': 'वस्तु',
      'close': 'बंद करें',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales
          .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
