abstract final class TelescopeUtils {
  static const String _equatorial = 'Equatorial';
  static const String _altazimuth = 'Altazimuth';
  static const String _refractor = 'Refractor';
  static const String _reflector = 'Reflector';
  static const String _catadioprtic = 'Catadioptric';
  static const _autoFocus = 'Auto Focus';
  static const _manualFocus = 'Manus Focus';
  static const _autoAndManualFocus = 'Auto & Manual Focus';
  static const mountList = [_equatorial, _altazimuth];
  static const typeList = [_refractor, _reflector, _catadioprtic];
  static const focusList = [_autoFocus, _manualFocus, _autoAndManualFocus];
}

const String telescopeImageDirectory = 'Telescopes/';
