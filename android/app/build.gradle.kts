import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties().apply {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.reader().use { reader ->
            load(reader)
        }
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("keystore/key.properties")
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { load(it) }
        println("=== Keystore Properties Debug Info ===")
        println("keyAlias: ${getProperty("keyAlias")}")
        println("keyPassword: ${getProperty("keyPassword")?.replace(Regex("."), "*")}")
        println("storeFile exists: ${getProperty("storeFile")?.let { file(it).exists() }}")
        println("storeFile path: ${getProperty("storeFile")}")
        println("storePassword: ${getProperty("storePassword")?.replace(Regex("."), "*")}")
        println("======================================")
    } else {
        println("=== Keystore Properties Debug Info ===")
        println("key.properties file does not exist at: ${keystorePropertiesFile.absolutePath}")
        println("======================================")
    }
}

android {
    namespace = "com.moneta.knifehit"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.moneta.knifehit"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        ndkVersion = "27.0.12077973"
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }

    flavorDimensions += "flavor-type"
    productFlavors {
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.moneta.knifehit.staging"
        }
    }
}

flutter {
    source = "../.."
}
