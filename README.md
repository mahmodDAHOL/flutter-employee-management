## 📌 Overview

**e_card** is an employee information management system designed for ease of use and flexibility. It supports:
- Dynamic form fields
- Image handling for employees
- Quick access to employee data via QR codes

All text in the app is localized in **Arabic**, making it ideal for Arabic-speaking organizations.



## 🧩 Key Features

### 1. **Dynamic Form System**
- Easily customize form fields by editing a simple JSON file: `assets/fields.json`.
- Supports multiple field types (text, number, date, dropdown, etc.).
- No need to recompile or modify Dart code when updating form structure.

> Example:
```json
[
  {"fieldName": "id", "type": "id", "label": "الرقم الذاتي"},
  {"fieldName": "name", "type": "text", "label": "الاسم الكامل"},
  {"fieldName": "birthDate", "type": "date", "label": "تاريخ الميلاد"},
  {"fieldName": "gender", "type": "select", "label": "الجنس", "options": ["Male", "Female", "Other"]},
  {"fieldName": "email", "type": "text", "label": "الايميل"},
  {"fieldName": "image", "type": "image", "label": "صورة"}
]
```
### 2. **Image Upload Support** 

- Employees can have profile images associated with their records.
- Users can upload or update images directly from the app using Gallery
- Selected images are previewed and saved along with the employee’s information.
     

    This feature makes it easy to maintain visual identification of employees within the system.

### 3. **QR Code Integration**

- Each employee gets a unique QR code  upon creation.
- Use the integrated QR scanner to quickly retrieve and edit employee information.
- Ideal for fast identification without manual searching.
- When a QR code is scanned, the app retrieves the corresponding employee record and opens it for viewing or editing.

## 🛠️ Setup Instructions 

Prerequisites 

 - Flutter SDK installed
 - Android Studio
     

Installation Steps 

#### 1. Clone the repository:
```bash
https://github.com/mahmodDAHOL/flutter-employee-management.git
```
#### 2. Install dependencies:

```bash
flutter pub get
```
#### 3. Run the app:
```bash
flutter run
```

### 📦 Build APK 

To build a release APK: 
```bash
flutter build apk --split-per-abi
```
APKs will be generated at:
build\app\outputs\flutter-apk

🤝 Contributing 

Contributions are welcome! If you'd like to improve this app or add new features, feel free to open an issue or submit a pull request. 

### 📬 Contact 

For questions or suggestions, contact us at: mahmodaldahol010@gmail.com 
