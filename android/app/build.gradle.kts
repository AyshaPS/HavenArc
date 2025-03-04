// Apply Necessary Plugins
plugins {
    id("com.android.application") // Required for Android Apps
    id("kotlin-android") // Kotlin Support
    id("com.google.gms.google-services") // Firebase Services
}

android {
    namespace = "com.youractualpackage.havenarc" // ✅ Change to your actual package name
    compileSdk = 34 // ✅ Latest SDK version for stability

    defaultConfig {
        applicationId = "com.youractualpackage.havenarc" // ✅ Ensure this is correct
        minSdk = 21 // ✅ Minimum SDK level for Firebase
        targetSdk = 34 // ✅ Target latest Android version
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.10.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // Firebase Dependencies
    implementation(platform("com.google.firebase:firebase-bom:32.7.2")) // ✅ Firebase BOM (Keeps versions consistent)
    implementation("com.google.firebase:firebase-auth-ktx") // ✅ Firebase Authentication
    implementation("com.google.firebase:firebase-firestore-ktx") // ✅ Firestore
    implementation("com.google.firebase:firebase-messaging-ktx") // ✅ Firebase Cloud Messaging

    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
}
