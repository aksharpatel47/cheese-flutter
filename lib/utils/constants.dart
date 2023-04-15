class ErrorMessages {
  static final networkFail = "You're offline. Please check your internet connection.";
  static final serverFail = "An unexpected server error occurred. Please try again later.";
  static final internalFail = "An unexpected error occurred. Please try again later.";
  static final somethingWrong = "Something went wrong. Please try again later.";
  static final dataFail = "An error occurred due to incorrect data format. Please try again later.";
  static final tokenExpiry = "Your login session has expired. Please login to continue.";
  static final userLogout = "Session cleared";
  static final noToken = "Please login to continue.";
  static final timeOut = "Something went wrong, server is busy. Please try again later.";
  static final support =
      "Please contact your center’s IT-applications support karyakar for further help or report this error at $supportUrl";
  static final supportUrl = "https://baps.sl/helpdesk";
}

class LogConstants {
  //print which api is called
  static final api = true; // default : true
  //print header(including token) with api. has no effect if api == false
  static final header = false; // default : false
  //print data fetched from local storage
  static final cacheData = false; // default : false
  //print api response data
  static final responseData = true; // default : true
  //print remote config data
  static final remoteConfig = false; //default : false
}
