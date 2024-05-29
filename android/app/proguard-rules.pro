# Flutter tarafından kullanılan FlutterEmbedding v1 ve v2 sınıflarını dahil edin
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Kullanılan bazı Flutter plugin'lerini koruma
-keep class io.flutter.view.FlutterMain { *; }
-keep class io.flutter.util.PathUtils { *; }

# Gson gibi bazı kütüphaneler için eklenebilir
-keep class com.google.gson.** { *; }
-keep class com.google.gson.annotations.** { *; }

# Retrofit ve OkHttp için kurallar
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }

# Glide için kurallar
-keep class com.bumptech.glide.** { *; }
-keep class com.bumptech.glide.annotation.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
