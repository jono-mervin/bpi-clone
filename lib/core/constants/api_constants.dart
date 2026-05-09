class ApiConstants {
  // Use the local IP address for physical devices, or 10.0.2.2 for Android emulator
  static const String baseUrl = 'http://10.0.2.2/neobank_ph/backend/api';
  
  // Auth Endpoints
  static const String login = '/auth/login.php';
  static const String register = '/auth/register.php';
  static const String verifyOtp = '/auth/otp.php';
  
  // Wallet Endpoints
  static const String balance = '/wallet/balance.php';
  static const String topup = '/wallet/topup.php';
  
  // Transaction Endpoints
  static const String transfer = '/transactions/transfer.php';
  static const String history = '/transactions/history.php';
}
