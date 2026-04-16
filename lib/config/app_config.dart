// Basic app-level configuration
class AppConfig {
  // Example configuration fields
  final String apiBaseUrl;
  final bool enableLogging;

  const AppConfig({
    this.apiBaseUrl = 'https://api.feeeasy.com',
    this.enableLogging = true,
  });
}
