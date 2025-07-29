Running Gradle task 'assembleDebug'...
Your project is configured with Android NDK 26.3.11579264, but the following plugin(s) depend on a different Android NDK version:
- cloud_firestore requires Android NDK 27.0.12077973
- firebase_auth requires Android NDK 27.0.12077973
- firebase_core requires Android NDK 27.0.12077973
- path_provider_android requires Android NDK 27.0.12077973
- pdf_render requires Android NDK 27.0.12077973
- permission_handler_android requires Android NDK 27.0.12077973
- printing requires Android NDK 27.0.12077973
- share_plus requires Android NDK 27.0.12077973
Fix this issue by using the highest Android NDK version (they are backward compatible).
Add the following to C:\sexto_semestre\fineTunedEnglish\fine-tuned-english\FineTunedEnglish\app\android\app\build.gradle.kts:

android {
    ndkVersion = "27.0.12077973"
    ...
}