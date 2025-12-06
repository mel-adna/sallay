mixin AppLocale {
  static const String title = 'title';
  static const String nextPrayer = 'next_prayer';
  static const String allDone = 'all_done';
  static const String fajr = 'fajr';
  static const String dhuhr = 'dhuhr';
  static const String asr = 'asr';
  static const String maghrib = 'maghrib';
  static const String isha = 'isha';
  static const String fajrTomorrow = 'fajr_tomorrow';
  static const String unknown = 'unknown';
  static const String settings = 'settings';
  static const String general = 'general';
  static const String language = 'language';
  static const String calculationMethod = 'calculation_method';
  static const String notifications = 'notifications';
  static const String enableNotifications = 'enable_notifications';
  static const String preAlert = 'pre_alert';
  static const String dataPrivacy = 'data_privacy';
  static const String backupData = 'backup_data';
  static const String resetData = 'reset_data';
  static const String privacyPolicy = 'privacy_policy';
  static const String iPrayed = 'i_prayed';
  static const String skip = 'skip';
  static const String next = 'next';
  static const String getStarted = 'get_started';
  static const String welcomeTitle = 'welcome_title';
  static const String welcomeDesc = 'welcome_desc';
  static const String stayOnTimeTitle = 'stay_on_time_title';
  static const String stayOnTimeDesc = 'stay_on_time_desc';
  static const String privacyFirstTitle = 'privacy_first_title';
  static const String privacyFirstDesc = 'privacy_first_desc';

  static const String stats = 'stats';
  static const String weeklyProgress = 'weekly_progress';
  static const String totalPrayers = 'total_prayers';
  static const String minutes = 'minutes';
  static const String syncToCloud = 'sync_to_cloud';
  static const String mwl = 'mwl';
  static const String egyptian = 'egyptian';
  static const String karachi = 'karachi';
  static const String ummAlQura = 'umm_al_qura';
  static const String dubai = 'dubai';
  static const String qatar = 'qatar';
  static const String kuwait = 'kuwait';
  static const String singapore = 'singapore';
  static const String turkey = 'turkey';
  static const String tehran = 'tehran';
  static const String northAmerica = 'north_america';
  static const String other = 'other';
  static const String qibla = 'qibla';
  static const String qiblaDirection = 'qibla_direction';
  static const String setLocation = 'set_location';
  static const String enterCityName = 'enter_city_name';
  static const String useGps = 'use_gps';
  static const String save = 'save';
  static const String currentStreak = 'current_streak';
  static const String exportData = 'export_data';
  static const String importData = 'import_data';
  static const String success = 'success';
  static const String error = 'error';
  static const String dataExported = 'data_exported';
  static const String dataImported = 'data_imported';
  static const String cancel = 'cancel';
  static const String darkMode = 'dark_mode';
  static const String retry = 'retry';
  static const String locationDisabled = 'location_disabled';
  static const String locationDisabledDesc = 'location_disabled_desc';
  static const String openSettings = 'open_settings';
  static const String privacyPolicyContent = 'privacy_policy_content';
  static const String close = 'close';
  static const String resetDataConfirm = 'reset_data_confirm';
  static const String dataResetSuccess = 'data_reset_success';
  static const String locationSetupTitle = 'location_setup_title';
  static const String locationSetupDesc = 'location_setup_desc';
  static const String useGpsButton = 'use_gps_button';
  static const String enterManuallyButton = 'enter_manually_button';
  static const String detectingLocation = 'detecting_location';
  static const String locationSetSuccess = 'location_set_success';
  static const String usingOfflineLocation = 'using_offline_location';
  static const String timeForPrayer = 'time_for_prayer';
  static const String upcomingPrayer = 'upcoming_prayer';
  static const String prayerInMinutes = 'prayer_in_minutes';

  static const Map<String, dynamic> en = {
    title: 'Sallay',
    stats: 'Stats',
    weeklyProgress: 'Weekly Progress',
    totalPrayers: 'Total Prayers',
    nextPrayer: 'Next Prayer',
    allDone: 'All Done',
    fajr: 'Fajr',
    dhuhr: 'Dhuhr',
    asr: 'Asr',
    maghrib: 'Maghrib',
    isha: 'Isha',
    fajrTomorrow: 'Fajr (Tomorrow)',
    unknown: 'Unknown',
    settings: 'Settings',
    general: 'General',
    language: 'Language',
    calculationMethod: 'Calculation Method',
    notifications: 'Notifications',
    enableNotifications: 'Enable Notifications',
    preAlert: 'Pre-Alert',
    dataPrivacy: 'Data & Privacy',
    backupData: 'Backup Data',
    resetData: 'Reset Data',
    privacyPolicy: 'Privacy Policy',
    iPrayed: 'I Prayed',
    skip: 'Skip',
    next: 'Next',
    getStarted: 'Get Started',
    welcomeTitle: 'Welcome to Sallay',
    welcomeDesc: 'Your companion for daily prayers.',
    stayOnTimeTitle: 'Stay on Time',
    stayOnTimeDesc: 'Get accurate prayer times and notifications.',
    privacyFirstTitle: 'Privacy First',
    privacyFirstDesc: 'Your data stays on your device.',
    minutes: 'minutes',
    syncToCloud: 'Sync to cloud (Optional)',
    mwl: 'Muslim World League',
    egyptian: 'Egyptian',
    karachi: 'Karachi',
    ummAlQura: 'Umm Al-Qura',
    dubai: 'Dubai',
    qatar: 'Qatar',
    kuwait: 'Kuwait',
    singapore: 'Singapore',
    turkey: 'Turkey',
    tehran: 'Tehran',
    northAmerica: 'North America',
    other: 'Other',
    qibla: 'Qibla Compass',
    qiblaDirection: 'Qibla Direction',
    setLocation: 'Set Location',
    enterCityName: 'Enter city name',
    useGps: 'Use GPS',
    save: 'Save',
    currentStreak: 'Current Streak',
    exportData: 'Export Data',
    importData: 'Import Data',
    success: 'Success',
    error: 'Error',
    dataExported: 'Data exported successfully',
    dataImported: 'Data imported successfully',
    cancel: 'Cancel',
    darkMode: 'Dark Mode',
    retry: 'Retry',
    locationDisabled: 'Location Services Disabled',
    locationDisabledDesc:
        'Please enable location services or set your location manually.',
    openSettings: 'Open Settings',
    privacyPolicyContent:
        'Sallay is a privacy-first app.\n\n'
        '1. No Data Collection: We do not collect or share your personal data.\n'
        '2. Local Storage: All data is stored locally on your device.\n'
        '3. Location: Used only for prayer time calculation locally.\n\n'
        'Your data stays with you.',
    close: 'Close',
    resetDataConfirm:
        'Are you sure you want to delete all prayer logs and settings? This action cannot be undone.',
    dataResetSuccess: 'All data reset successfully',
    locationSetupTitle: 'Set Your Location',
    locationSetupDesc: 'We need your location to show accurate prayer times',
    useGpsButton: 'Use GPS',
    enterManuallyButton: 'Enter Manually',
    detectingLocation: 'Detecting your location...',
    locationSetSuccess: 'Location set successfully!',
    usingOfflineLocation: 'Using offline location',
    timeForPrayer: 'It is time for %s prayer',
    upcomingPrayer: 'Upcoming Prayer: %s',
    prayerInMinutes: '%s will be in %s minutes',
  };

  static const Map<String, dynamic> ar = {
    title: 'صلاي',
    stats: 'الإحصائيات',
    weeklyProgress: 'التقدم الأسبوعي',
    totalPrayers: 'مجموع الصلوات',
    nextPrayer: 'الصلاة القادمة',
    allDone: 'أتممت صلواتك',
    fajr: 'الفجر',
    dhuhr: 'الظهر',
    asr: 'العصر',
    maghrib: 'المغرب',
    isha: 'العشاء',
    fajrTomorrow: 'الفجر (غداً)',
    unknown: 'غير معروف',
    settings: 'الإعدادات',
    general: 'عام',
    language: 'اللغة',
    calculationMethod: 'طريقة الحساب',
    notifications: 'الإشعارات',
    enableNotifications: 'تفعيل الإشعارات',
    preAlert: 'تنبيه قبل الصلاة',
    dataPrivacy: 'البيانات والخصوصية',
    backupData: 'نسخ احتياطي',
    resetData: 'إعادة تعيين البيانات',
    privacyPolicy: 'سياسة الخصوصية',
    iPrayed: 'صليت',
    skip: 'تخطي',
    next: 'التالي',
    getStarted: 'ابدأ',
    welcomeTitle: 'مرحباً بك في صلاي',
    welcomeDesc: 'رفيقك للمحافظة على صلواتك.',
    stayOnTimeTitle: 'حافظ على وقتك',
    stayOnTimeDesc: 'احصل على مواقيت دقيقة وتنبيهات للصلوات.',
    privacyFirstTitle: 'الخصوصية أولاً',
    privacyFirstDesc: 'بياناتك تبقى على جهازك.',
    minutes: 'دقيقة',
    syncToCloud: 'مزامنة سحابية (اختياري)',
    mwl: 'رابطة العالم الإسلامي',
    egyptian: 'الهيئة المصرية العامة للمساحة',
    karachi: 'جامعة العلوم الإسلامية بكراتشي',
    ummAlQura: 'جامعة أم القرى',
    dubai: 'دائرة الشؤون الإسلامية والعمل الخيري بدبي',
    qatar: 'وزارة الأوقاف والشؤون الإسلامية بقطر',
    kuwait: 'وزارة الأوقاف والشؤون الإسلامية بالكويت',
    singapore: 'المجلس الإسلامي السنغافوري',
    turkey: 'رئاسة الشؤون الدينية التركية',
    tehran: 'جامعة طهران',
    northAmerica: 'الجمعية الإسلامية لأمريكا الشمالية',
    other: 'أخرى',
    qibla: 'بوصلة القبلة',
    qiblaDirection: 'اتجاه القبلة',
    setLocation: 'تحديد الموقع',
    enterCityName: 'أدخل اسم المدينة',
    useGps: 'استخدام GPS',
    save: 'حفظ',
    currentStreak: 'أيام متتالية',
    exportData: 'تصدير البيانات',
    importData: 'استيراد البيانات',
    success: 'تم بنجاح',
    error: 'خطأ',
    dataExported: 'تم تصدير البيانات بنجاح',
    dataImported: 'تم استيراد البيانات بنجاح',
    cancel: 'إلغاء',
    darkMode: 'الوضع الليلي',
    retry: 'إعادة المحاولة',
    locationDisabled: 'خدمات الموقع معطلة',
    locationDisabledDesc: 'يرجى تفعيل خدمات الموقع أو تحديد موقعك يدوياً.',
    openSettings: 'فتح الإعدادات',
    privacyPolicyContent:
        'صلاي هو تطبيق يضع الخصوصية أولاً.\n\n'
        '1. لا نجمع البيانات: نحن لا نجمع أو نشارك بياناتك الشخصية.\n'
        '2. تخزين محلي: جميع البيانات مخزنة محلياً على جهازك.\n'
        '3. الموقع: يستخدم فقط لحساب مواقيت الصلاة محلياً.\n\n'
        'بياناتك تبقى معك.',
    close: 'إغلاق',
    resetDataConfirm:
        'هل أنت متأكد من حذف جميع سجلات الصلوات والإعدادات؟ لا يمكن التراجع عن هذا الإجراء.',
    dataResetSuccess: 'تم إعادة تعيين جميع البيانات بنجاح',
    locationSetupTitle: 'حدد موقعك',
    locationSetupDesc: 'نحتاج إلى موقعك لعرض أوقات الصلاة الدقيقة',
    useGpsButton: 'استخدام GPS',
    enterManuallyButton: 'إدخال يدوي',
    detectingLocation: 'جاري تحديد موقعك...',
    locationSetSuccess: 'تم تعيين الموقع بنجاح!',
    usingOfflineLocation: 'استخدام الموقع غير المتصل',
    timeForPrayer: 'حان وقت صلاة %s',
    upcomingPrayer: 'صلاة قادمة: %s',
    prayerInMinutes: 'متبقي على صلاة %s %s دقيقة',
  };
}
