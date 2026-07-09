allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// isar_flutter_libs 3.1.0+1 predates AGP's mandatory namespace requirement;
// inject it here (before evaluation) so the plugin still builds against modern AGP.
subprojects {
    if (project.name == "isar_flutter_libs") {
        plugins.withId("com.android.library") {
            extensions.configure(com.android.build.gradle.LibraryExtension::class.java) {
                namespace = "dev.isar.isar_flutter_libs"
            }
        }
        afterEvaluate {
            extensions.configure(com.android.build.gradle.LibraryExtension::class.java) {
                compileSdk = 36
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
