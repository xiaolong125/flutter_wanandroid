plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle 插件必须放在 Android 和 Kotlin Gradle 插件之后应用。
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_wanandroid"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: 请替换为你自己的唯一 Application ID：
        // https://developer.android.com/studio/build/application-id.html
        applicationId = "com.example.flutter_wanandroid"
        // 你可以根据应用实际需求调整下面这些配置。
        // 更多说明见：https://flutter.dev/to/review-gradle-config
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: 请为 release 构建配置你自己的签名信息。
            // 当前先使用 debug 签名，确保 `flutter run --release` 可以运行。
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
