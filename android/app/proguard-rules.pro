# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }

# Modelo Viewer
-keep class com.google.android.filament.** { *; }
-keep class com.google.android.filament.android.** { *; }

# Para evitar problemas con Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**

# Para model_viewer_plus
-keepattributes *Annotation*
-dontwarn dalvik.**
-dontwarn com.google.android.filament.**