# 💬 Pertanyaan dan Jawaban

**1. Mengapa diperlukan database master & replica (slave) dalam pengoperasian sistem di environment production? Jelaskan!**  
> Karena Master itu tempat nulis data, Replica itu tempat baca data Salinanya. Dengan begitu sistem jadi lebih cepat, aman, dan gak gampang Rusak. Kalau sewaktu waktu terjadi sesuatu yang ga di inginkan  dengan yang utama tinggal ambil aja salinanya.

---


**2. Mengapa diperlukan database master & replica (slave) dalam pengoperasian sistem di environment production? Jelaskan!**  
> Karena Master itu tempat nulis data, Replica itu tempat baca data Salinanya. Dengan begitu sistem jadi lebih cepat, aman, dan gak gampang Rusak. Kalau sewaktu waktu terjadi sesuatu yang ga di inginkan  dengan yang utama tinggal ambil aja salinanya.

---

**6. Menurut anda, manakah yang lebih baik diantara SQL dan NoSQL? Jelaskan alasannya.**  
> Menurutku dua dua nya bagus, tergantung situasi aja, kita pakai SQL, NO SQL  ? . Di project sebelumnya saya pakai Elastic Database karena Data social media biasanya JSON: misal tweet, komentar, post di Instagram → banyak field, nested misal (user, entities, hastag, url gambar, video dll)., jadi tinggal masukin aja  nested JSON, array, dan query di dalamnya gampang. .dan saya akan pakai SQL buat nyimpen transaksi, saldo, dan data uang Kenapa? Karena SQL itu kayak lemari yang rapi banget ,Semua datanya punya kotak, label, dan aturan jelas.
