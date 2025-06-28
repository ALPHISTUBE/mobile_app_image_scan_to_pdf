
# 📄 PaperSnap

_A simple Flutter app to scan handwritten exam papers, input student info, and generate a printable PDF for online submission._

![App Icon](assets/icon/icon.png)

---

## 🚀 Download

**[⬇️ Download Latest Release (APK)](https://github.com/ALPHISTUBE/mobile_app_image_scan_to_pdf/releases/download/v0.2.0/PaperSnap_0_2_beta.apk)**

---

## 🧠 Features

- 📸 Scan handwritten pages using the camera or from the gallery
- 📝 Input or auto-load student info (Name, Roll, Batch)
- 🖨️ Generate and save PDF instantly
- 📁 Choose where to save your file
- 🔄 View saved PDFs on the home screen

---

## 📦 Dependencies

| Package                  | Purpose                                 |
|--------------------------|------------------------------------------|
| `cunning_document_scanner` | Scan or pick images for PDF              |
| `pdf`                    | Generate custom PDF                      |
| `printing`              | PDF preview or printing (future use)    |
| `path_provider`         | Access local storage                     |
| `permission_handler`    | Request Android permissions              |
| `file_picker`           | Let user select save location            |
| `shared_preferences`    | Save student data and PDF paths locally  |

---

## 🔐 Permissions Used

| Permission          | Reason                                             |
|---------------------|----------------------------------------------------|
| `CAMERA`            | To scan handwritten papers using the device camera |
| `STORAGE`           | To read/write scanned PDFs on local storage        |
| `GALLERY` (optional)| To import existing images for the assignment       |

You will be asked for relevant permissions only when needed.

---

## ⚙️ Installation

```bash
git clone https://github.com/yourname/papersnap.git
cd papersnap
flutter pub get
flutter run
```

> 📌 **Android SDK Note**: Use NDK version `27.0.12077973` for compatibility with scanning and file picker plugins. Add the following in `android/app/build.gradle.kts`:
```kotlin
android {
    ndkVersion = "27.0.12077973"
}
```

---

## ✨ App Name & Package

- App Name: **PaperSnap**
- Package ID: `com.tjm.papersnap`

---

## 🧪 How to Use

1. 🔧 Click the ✏️ icon on the home screen to set your name, roll & batch.
2. 📷 Click ➕ to start scanning your paper or pick from gallery.
3. 📝 Fill in or edit details on the finalize screen, add subject.
4. 📄 Tap **Generate and Save PDF**.
5. ✅ The PDF will be saved in Downloads and shown in the home screen list.

---
