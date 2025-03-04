// Apply Kotlin Plugin for the entire project
plugins {
    kotlin("android")
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Define a new build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Clean Task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Firebase & Gradle Dependencies
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.1") // ✅ Updated Gradle Plugin
        classpath("com.google.gms:google-services:4.4.0") // ✅ Firebase Dependency
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.10") // ✅ Kotlin Gradle Plugin
    }
}
