# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep all networking related classes
-keep class dio.** { *; }
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# Keep JSON serialization classes
-keepattributes Signature
-keepattributes *Annotation*
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep environment configuration
-keep class **EnvironmentService { *; }
-keep class **NetworkService { *; }
-keep class **ConnectivityService { *; }

# Keep model classes (add your specific model package path)
-keep class com.nomadnest.app.models.** { *; }
-keep class com.nomadnest.app.data.** { *; }

# Preserve line number information for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile