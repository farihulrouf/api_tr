# 💬 Pertanyaan dan Jawaban

**1. Mengapa diperlukan database master & replica (slave) dalam pengoperasian sistem di environment production? Jelaskan!**  
> Karena Master itu tempat nulis data, Replica itu tempat baca data Salinanya. Dengan begitu sistem jadi lebih cepat, aman, dan gak gampang Rusak. Kalau sewaktu waktu terjadi sesuatu yang ga di inginkan  dengan yang utama tinggal ambil aja salinanya.

---

**2. Mengapa diperlukan database master & replica (slave) dalam pengoperasian sistem di environment production? Jelaskan!**  
> Karena Master itu tempat nulis data, Replica itu tempat baca data Salinanya. Dengan begitu sistem jadi lebih cepat, aman, dan gak gampang Rusak. Kalau sewaktu waktu terjadi sesuatu yang ga di inginkan  dengan yang utama tinggal ambil aja salinanya.

---

**5. Untuk menjaga high availability sistem, bagaimana cara anda melakukan deployment tanpa harus mengalami down server sama sekali?**  
> a-) BLUE -GREEN Deployment  
>    → Blue versi yang di pakai saat ini  
>    → Green versi yang akan di pasang  
>
> Alurnya saya pahami → Di pasang green dulu tapi tidak pakai user, jika Green Sudah oke, langsung alihkan semua user ke Green, dan seandainya ada masalah tinggal balik lagi saja yang BLUE.  
>
> Analogi saya seperti punya dua jalur jalan. Jalur lama itu tetep bisa di pakai, Nanti tinggal pidah aja mobilnya ke Jalur yang baru itu, kalau ada apa apa dengan jalur yg baru, mobil tetep bisa pakai jalur yg lama.  
>
> b-) Rooling Deployment  
>  → Update sedikit sedikit, tidak sekaligus  
>  → Yang belum di update tetep jalan  
>  Simple nya Seperti Ganti lampu jalan raya satu persatu, sehingga tetep bisa di lalui Mobil  
>
> c-) Canary Deployment  
>    → Dari segi user misal terapkan beberapa user / data yg di coba dulu versi baru  
>    → JIka aman, Baru semua data pindahkan  
>
> d-) Pakai Load Balancer  
>    → Load balancer membagi traffic ke beberapa server  
>    → BIsa tambah server baru versi baru, turunkan server lama pelan pelan  
>    → Jadi User tidak merakasan Downtime  
>     Simple nya tidak mengganti semua Sekaligus, Perlahan lahan atau sekaligus tapi aman dan tentu saja selalu cek kalau server baru sudah siap

---

**6. Menurut anda, manakah yang lebih baik diantara SQL dan NoSQL? Jelaskan alasannya.**  
> Menurutku dua dua nya bagus, tergantung situasi aja, kita pakai SQL, NO SQL  ? . Di project sebelumnya saya pakai Elastic Database karena Data social media biasanya JSON: misal tweet, komentar, post di Instagram → banyak field, nested misal (user, entities, hastag, url gambar, video dll)., jadi tinggal masukin aja  nested JSON, array, dan query di dalamnya gampang. .dan saya akan pakai SQL buat nyimpen transaksi, saldo, dan data uang Kenapa? Karena SQL itu kayak lemari yang rapi banget ,Semua datanya punya kotak, label, dan aturan jelas.
