// Conditional import for the GoogleSignInButton

export 'google_sign_in/stub.dart'
    if (dart.library.js_util) 'google_sign_in/web.dart'
    if (dart.library.io) 'google_sign_in/native.dart';
