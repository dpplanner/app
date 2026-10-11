# OkHttp가 선택적으로 참조하는 TLS 구현체(앱에 포함되지 않음).
# R8가 생성한 missing_rules.txt 그대로 적용.
-dontwarn org.conscrypt.Conscrypt$Version
-dontwarn org.conscrypt.Conscrypt
-dontwarn org.conscrypt.ConscryptHostnameVerifier
-dontwarn org.openjsse.javax.net.ssl.SSLParameters
-dontwarn org.openjsse.javax.net.ssl.SSLSocket
-dontwarn org.openjsse.net.ssl.OpenJSSE

# 네이버 로그인 SDK(com.navercorp.nid:oauth 5.10.0)는 AAR에 ProGuard 규칙이 없다.
# release(R8)에서 응답 모델(NidOAuthResponse, NidProfileResponse 등)이 난독화되면
# 토큰 응답 파싱이 실패해 네이버 로그인이 조용히 실패한다 (debug에서는 정상).
-keep class com.navercorp.nid.** { *; }
-keepattributes Signature, *Annotation*, InnerClasses, EnclosingMethod

# 네이버 SDK가 쓰는 Retrofit 2.9.0은 R8 full mode(AGP 8 기본값)에서 suspend API의
# 제네릭 정보가 지워져 실패한다(SDK 오류: no_catagorized_error). Retrofit 2.10+ 공식 규칙을 옮김.
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations, AnnotationDefault
-keepclassmembers,allowshrinking,allowobfuscation interface * { @retrofit2.http.* <methods>; }
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>
-if interface * { @retrofit2.http.* public *** *(...); }
-keep,allowoptimization,allowshrinking,allowobfuscation class <3>
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*
# Gson(TypeToken)·Moshi(kotlin-reflect)가 응답 모델을 읽을 수 있게
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep class kotlin.Metadata { *; }
