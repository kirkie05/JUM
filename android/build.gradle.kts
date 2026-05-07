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
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    var extractedNamespace: String? = null
    val manifestFile = projectDir.resolve("src/main/AndroidManifest.xml")
    if (manifestFile.exists()) {
        val content = manifestFile.readText()
        val match = Regex("""package="([^"]*)"""").find(content)
        if (match != null) {
            extractedNamespace = match.groupValues[1]
        }
    }
    if (extractedNamespace == null && project.name == "flutter_paystack") {
        extractedNamespace = "co.paystack.flutterpaystack"
    }
    val targetNamespace = extractedNamespace ?: "com.example.${project.name.replace("-", "_").replace(".", "_")}"

    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.api.dsl.LibraryExtension> {
            if (namespace == null) {
                namespace = targetNamespace
            }
        }
    }
    plugins.withId("com.android.application") {
        extensions.configure<com.android.build.api.dsl.ApplicationExtension> {
            if (namespace == null) {
                namespace = targetNamespace
            }
        }
    }
    val stripManifestPackage = Action<Project> {
        if (manifestFile.exists()) {
            var content = manifestFile.readText()
            if (content.contains("package=")) {
                content = content.replace(Regex("""package="[^"]*""""), "")
                manifestFile.writeText(content)
            }
        }
    }
    if (state.executed) {
        stripManifestPackage.execute(this)
    } else {
        afterEvaluate(stripManifestPackage)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
