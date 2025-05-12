# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Dart code
-keep class **.modelobject.** { *; }
-keep class **.entity.** { *; }
-keep class **.data.** { *; }

# Prevent obfuscation of types which use @JsonObjectMapper annotation or have it included
-keep class ** extends com.bluelinelabs.logansquare.JsonObject { *; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep SafeArgs classes
-keep class ** extends androidx.navigation.NavArgs { *; }

# JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**

# Platform calls Class.forName on types which do not exist on Android to determine platform.
-dontnote retrofit2.Platform
-dontwarn retrofit2.Platform$Java8
-keepattributes Signature
-keepattributes Exceptions

# A resource is loaded with a relative path so the package of this class must be preserved.
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

# OkHttp platform used only on JVM and when Conscrypt dependency is available.
-dontwarn okhttp3.internal.platform.ConscryptPlatform
-dontwarn org.conscrypt.ConscryptHostnameVerifier

# Animal Sniffer compileOnly dependency to ensure APIs are compatible with older versions of Java.
-dontwarn org.codehaus.mojo.animal_sniffer.*

# Suppress warnings
-dontwarn android.databinding.**
-dontwarn org.xmlpull.v1.**
-dontwarn com.google.errorprone.annotations.** 