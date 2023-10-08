import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/app_colors.dart';
import 'preferences_keys.dart';

/// The theme manager.
class ThemeManager extends GetxController {
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;

  /// Retrieve the theme mode.
  ThemeMode get themeMode => _themeMode.value;

  /// Constructs a new [ThemeManager].
  ThemeManager() {
    _initCurrentThemeMode();
  }

  /// Initializes the current theme mode.
  void _initCurrentThemeMode() async {
    final instance = await SharedPreferences.getInstance();

    final _currentThemeMode =
        instance.getString(PreferencesKeys.currentThemeData);

    switch (_currentThemeMode) {
      case 'light':
        _themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        _themeMode.value = ThemeMode.dark;
        break;
      default:
        await instance.setString(
            PreferencesKeys.currentThemeData, ThemeMode.light.name);
        _themeMode.value = ThemeMode.light;
    }
    Get.changeThemeMode(
      _themeMode.value == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light,
    );
  }

  ///
  void updateCurrentTheme(ThemeMode themeMode) {
    unawaited(Future.microtask(() async {
      final instance = await SharedPreferences.getInstance();
      await instance.setString(
        PreferencesKeys.currentThemeData,
        themeMode.name,
      );
    }));

    _themeMode.value = themeMode;
    Get.changeThemeMode(
      themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

/// The dark theme.
ThemeData darkTheme() => FlexThemeData.dark(
      scheme: FlexScheme.deepPurple,
      colors: const FlexSchemeColor(
        primary: AppColors.purple,
        primaryContainer: Color(0xff7b008f),
        secondary: Color(0xffe0b6ff),
        secondaryContainer: Color(0xff6b00af),
        tertiary: Color(0xffffb59f),
        tertiaryContainer: Color(0xff76331d),
        appBarColor: Color(0xff6b00af),
        error: Color(0xffcf6679),
      ),
      subThemesData: const FlexSubThemesData(
        interactionEffects: false,
        tintedDisabledControls: false,
        useTextTheme: true,
        textButtonSchemeColor: SchemeColor.tertiary,
        filledButtonRadius: 8.0,
        elevatedButtonRadius: 8.0,
        outlinedButtonRadius: 8.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimary,
        toggleButtonsSchemeColor: SchemeColor.onPrimary,
        inputDecoratorIsFilled: false,
        inputDecoratorRadius: 40.0,
        inputDecoratorUnfocusedHasBorder: false,
        inputDecoratorFocusedHasBorder: false,
        fabUseShape: true,
        fabAlwaysCircular: true,
        chipSelectedSchemeColor: SchemeColor.primary,
        chipRadius: 40.0,
        tooltipRadius: 4,
        tooltipSchemeColor: SchemeColor.inverseSurface,
        tooltipOpacity: 0.9,
        useInputDecoratorThemeInDialogs: true,
        snackBarElevation: 6,
        snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
        navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedLabel: false,
        navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedIcon: false,
        navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationBarIndicatorOpacity: 1.00,
        navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedLabel: false,
        navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedIcon: false,
        navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationRailIndicatorOpacity: 1.00,
        navigationRailBackgroundSchemeColor: SchemeColor.surface,
        navigationRailLabelType: NavigationRailLabelType.none,
      ),
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
        keepPrimary: true,
        keepSecondary: true,
        keepTertiary: true,
        keepPrimaryContainer: true,
        keepSecondaryContainer: true,
      ),
      tones:
          FlexTones.material(Brightness.dark).onMainsUseBW().onSurfacesUseBW(),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: false,
    );

/// The light theme.
ThemeData lightTheme() => FlexThemeData.light(
      scheme: FlexScheme.deepPurple,
      colors: const FlexSchemeColor(
        primary: Color(0xff000000),
        primaryContainer: Color(0xffffd6fe),
        secondary: Color(0xff090d0d),
        secondaryContainer: Color(0xfff2daff),
        tertiary: Color(0xff8a3293),
        tertiaryContainer: Color(0xffffdbd0),
        appBarColor: Color(0xfff2daff),
        error: Color(0xffb00020),
      ),
      subThemesData: const FlexSubThemesData(
        interactionEffects: false,
        tintedDisabledControls: false,
        blendOnColors: false,
        useTextTheme: true,
        elevatedButtonRadius: 19.0,
        textButtonSchemeColor: SchemeColor.tertiary,
        filledButtonRadius: 8.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimary,
        outlinedButtonRadius: 8.0,
        toggleButtonsSchemeColor: SchemeColor.onPrimary,
        inputDecoratorIsFilled: false,
        inputDecoratorRadius: 40.0,
        inputDecoratorUnfocusedHasBorder: false,
        inputDecoratorFocusedHasBorder: false,
        fabUseShape: true,
        fabAlwaysCircular: true,
        chipSelectedSchemeColor: SchemeColor.primary,
        chipRadius: 40.0,
        tooltipRadius: 4,
        tooltipSchemeColor: SchemeColor.inverseSurface,
        tooltipOpacity: 0.9,
        useInputDecoratorThemeInDialogs: true,
        snackBarElevation: 6,
        snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
        navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedLabel: false,
        navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedIcon: false,
        navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationBarIndicatorOpacity: 1.00,
        navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedLabel: false,
        navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedIcon: false,
        navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationRailIndicatorOpacity: 1.00,
        navigationRailBackgroundSchemeColor: SchemeColor.surface,
        navigationRailLabelType: NavigationRailLabelType.none,
      ),
      keyColors: const FlexKeyColors(
        useSecondary: true,
        useTertiary: true,
        keepPrimary: true,
        keepSecondary: true,
        keepTertiary: true,
        keepPrimaryContainer: true,
      ),
      tones: FlexTones.material(Brightness.light)
          .onMainsUseBW()
          .onSurfacesUseBW()
          .surfacesUseBW(),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: false,
    );
