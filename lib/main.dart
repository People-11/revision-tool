import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:revitool/l10n/generated/localizations.dart';
import 'package:revitool/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:revitool/theme.dart';
import 'package:revitool/utils.dart';
import 'package:system_theme/system_theme.dart';
import 'package:win32_registry/win32_registry.dart';
import 'package:window_plus/window_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // createRegistryKey(Registry.localMachine, r'SOFTWARE\Revision\Revision Tool');

  if (registryUtilsService.readString(RegistryHive.localMachine,
          r'SOFTWARE\Revision\Revision Tool', 'ThemeMode') ==
      null) {
    registryUtilsService.writeString(Registry.localMachine,
        r'SOFTWARE\Revision\Revision Tool', 'ThemeMode', ThemeMode.system.name);
    registryUtilsService.writeDword(Registry.localMachine,
        r'SOFTWARE\Revision\Revision Tool', 'Experimental', 0);
    registryUtilsService.writeString(Registry.localMachine,
        r'SOFTWARE\Revision\Revision Tool', 'Language', 'en_US');
  }
  final settingsController = AppTheme(SettingsService());
  await settingsController.loadSettings();
  await SystemTheme.accentColor.load();

  await WindowPlus.ensureInitialized(
    application: 'revision-tool',
    enableCustomFrame: true,
    enableEventStreams: false,
  );
  await WindowPlus.instance.setMinimumSize(const Size(515, 330));

  bool isSupported = false;

<<<<<<< HEAD
  if (buildNumber > 19043) {
      runApp(const MyApp(isSupported: true));
  }
  else {
      runApp(const MyApp(isSupported: false));
=======
  if (buildNumber > 19043) {
    isSupported = true;
>>>>>>> 7b55fac9006aee9c24e9afdc0dc3c709a4ac630f
  }

  runApp(MyApp(isSupported: isSupported));
}

class MyApp extends StatelessWidget {
  final bool isSupported;

  const MyApp({super.key, required this.isSupported});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(SettingsService()),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: 'Revision Tool',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            FluentLocalizations.delegate,
            ReviLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: Locale(appLanguage.split('_')[0], appLanguage.split('_')[1]),
          supportedLocales: ReviLocalizations.supportedLocales,
          themeMode: appTheme.themeMode,
          color: appTheme.color,
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            scaffoldBackgroundColor: const Color.fromARGB(255, 32, 32, 32),
            cardColor: const Color.fromARGB(255, 43, 43, 43),
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
            resources: const ResourceDictionary.dark(
              cardStrokeColorDefault: Color.fromARGB(255, 29, 29, 29),
            ),
          ),
          theme: FluentThemeData(
              accentColor: appTheme.color,
              visualDensity: VisualDensity.standard,
              scaffoldBackgroundColor: const Color.fromRGBO(243, 243, 243, 100),
              cardColor: const Color.fromARGB(255, 251, 251, 251),
              focusTheme: FocusThemeData(
                glowFactor: is10footScreen(context) ? 2.0 : 0.0,
              ),
              resources: const ResourceDictionary.light(
                  cardStrokeColorDefault: Color.fromARGB(255, 229, 229, 229))),
          home: isSupported ? const HomePage() : const UnsupportedError(),
        );
      },
    );
  }
}

class UnsupportedError extends StatelessWidget {
  const UnsupportedError({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: ContentDialog(
        title: const Text("Error"),
        content: const Text("Unsupported build detected"),
        actions: [
          Button(
            child: const Text('OK'),
            onPressed: () {
              WindowPlus.instance.close();
            },
          ),
        ],
      ),
    );
  }
}
