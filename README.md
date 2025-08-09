# event_uas

Aplikasi **Event UAS** adalah aplikasi mobile berbasis Flutter yang digunakan untuk:
- Melihat daftar event
- Registrasi user
- Login user
- Menambahkan event baru (dengan autentikasi token API)

Aplikasi ini menggunakan API dari: [http://103.160.63.165/api-docs-interactive](http://103.160.63.165/api-docs-interactive)

---

## 📌 Fitur
- **Register User** – Membuat akun baru
- **Login User** – Menggunakan token JWT dari API
- **List Event** – Menampilkan daftar event dari server
- **Tambah Event** – Mengirim data event baru ke API (hanya jika login)

---

## 🚀 Instalasi & Menjalankan
1. **Clone repository**
   ```bash
   git clone https://github.com/rikofebriyan/event_uas.git
   cd event_uas
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi (mode debug)**
   ```bash
   flutter run
   ```

---

## 📦 Build APK
Untuk membuat APK release:
```bash
flutter build apk --release
```

Lokasi file APK:
```
build/app/outputs/flutter-apk/app-release.apk
```

Jika ingin ukuran APK lebih kecil (split per ABI):
```bash
flutter build apk --split-per-abi
```

---

## 📂 Struktur Project
```
lib/
├── main.dart               # Entry point aplikasi
├── login.dart              # Halaman login
├── register.dart           # Halaman registrasi
├── get_events.dart         # Halaman daftar event
├── add_event.dart          # Halaman tambah event
└── services/
    └── api_service.dart    # Service untuk request API
```

---

## 🔗 API
Dokumentasi API:  
[http://103.160.63.165/api-docs-interactive](http://103.160.63.165/api-docs-interactive)

---

## 🛠️ Teknologi
- **Flutter**
- **Dart**
- **HTTP package** untuk request API

---

## 📜 Lisensi
Proyek ini menggunakan lisensi MIT. Silakan digunakan dan dimodifikasi sesuai kebutuhan.
