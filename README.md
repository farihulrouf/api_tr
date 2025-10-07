
# 💬 Pertanyaan dan Jawaban

**Ruby On rails saya coba run di http://141.11.25.96:3000/**  
**1. Mengapa diperlukan database master & replica (slave) dalam pengoperasian sistem di environment production? Jelaskan!**  
> Karena Master itu tempat nulis data, Replica itu tempat baca data Salinanya. Dengan begitu sistem jadi lebih cepat, aman, dan gak gampang Rusak. Kalau sewaktu waktu terjadi sesuatu yang ga di inginkan  dengan yang utama tinggal ambil aja salinanya.

---

**2. Gambarkan menggunakan TRD/ERD struktur table yang efektif dan efisien untuk sistem wallet pada aplikasi anda dengan requirement sebagai berikut:**  
> a. Aplikasi ini memiliki beberapa currency, jadi pengguna bisa punya saldo IDR, USD, BTC, dll.  
> b. Setiap perubahan saldo milik pengguna harus tercatat sehingga memudahkan tracking.  
> c. Berapa field dan table yang dibutuhkan bebas tapi disesuaikan dengan mendekati kenyataan.

> ![Infrastruktur Aplikasi](assets/pic_1.png)


**3. Dari struktur table yang sudah anda buat pada pertanyaan sebelumnya, buatlah query yang efektif dan efisien (SQL atau ActiveRecord Ruby boleh) untuk mendapatkan data-data ini:**  
> a. Top 10 pengguna yang penambahan saldo BTC-nya terbanyak pada minggu ini..  
> b. Berapa selisih jumlah pengguna yang hold/punya saldo IDR diatas 0 dan USD diatas 0?.  
> c. Pada hari apa paling banyak terjadi perubahan saldo IDR?

---

**a. Source Code untuk menampilkan Top 10 Pengguna dengan Penambahan Saldo BTC Minggu Ini**
```ruby
# Tentukan periode minggu lalu
start_date = 1.week.ago.to_date.beginning_of_week
end_date   = 1.week.ago.to_date.end_of_week

# Jalankan query yang sama dengan ReportsController#top_crypto_users
transactions = WalletTransaction
  .joins(wallet: [:currency, :user])
  .where(currencies: { code: 'BTC' }, tx_type: 'topup')
  .where(created_at: start_date.beginning_of_day..end_date.end_of_day)

top_users = transactions
  .group('users.name')
  .sum(:amount)
  .sort_by { |_, total| -total }
  .first(10)

puts "📅 Periode: #{start_date} - #{end_date}"
puts "🏆 Top 10 Pengguna dengan Penambahan Saldo BTC (tx_type='topup') Minggu Lalu:"
puts "---------------------------------------------------------------"
top_users.each_with_index do |(user_name, total_amount), i|
  puts "#{i + 1}. #{user_name.ljust(25)} | #{total_amount.round(8)} BTC"
end
puts "---------------------------------------------------------------"

```

```
📅 Periode: 2025-09-29 s.d. 2025-10-05
🏆 Top 10 Pengguna dengan Penambahan Saldo BTC (tx_type = 'topup') Minggu Lalu
=================================================================
 No | Nama Pengguna              | Total Penambahan (BTC)
-----------------------------------------------------------------
  1 | Damaris Wunsch             | 0.16568
  2 | Alberta Stoltenberg        | 0.15375
  3 | Cary Hyatt                 | 0.13987
  4 | Dr. Leilani Carroll        | 0.12892
  5 | Gaston Hudson              | 0.12346
  6 | Lenore Kulas               | 0.11915
  7 | Aracely Runolfsson         | 0.11553
  8 | Conrad Kiehn               | 0.11282
  9 | Rufus Bednar               | 0.11272
 10 | Rep. Dale Hermann          | 0.10971
-----------------------------------------------------------------
```
`a`**🔍 Cek via REST API**

**Contoh Request API ke server, top 10 pengguna dengan Bearer Token (menggunakan cURL):**
```bash
curl -X GET "http://141.11.25.96:3000/reports/top_crypto_users?currency=BTC&start_date=2025-09-29&end_date=2025-10-05" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.0JsA7s0F251ERbLdyNgVMpppI6iv8sH52Lj4wDpP4fI" \
  -H "Content-Type: application/json"

```

```bash
{
  "currency": "BTC",
  "period": "2025-09-29 to 2025-10-05",
  "top_users": [
    { "user": "Damaris Wunsch", "total_amount": 0.16568 },
    { "user": "Alberta Stoltenberg", "total_amount": 0.15375 },
    { "user": "Cary Hyatt", "total_amount": 0.13987 },
    { "user": "Dr. Leilani Carroll", "total_amount": 0.12892 },
    { "user": "Gaston Hudson", "total_amount": 0.12346 },
    { "user": "Lenore Kulas", "total_amount": 0.11915 },
    { "user": "Aracely Runolfsson", "total_amount": 0.11553 },
    { "user": "Conrad Kiehn", "total_amount": 0.11282 },
    { "user": "Rufus Bednar", "total_amount": 0.11272 },
    { "user": "Rep. Dale Hermann", "total_amount": 0.10971 }
  ]
}

```

**b. selisih jumlah pengguna yang hold/punya saldo IDR diatas 0 dan USD diatas 0?**
```ruby
# Jalankan di Rails Console (rails c)
idr_users = Wallet.joins(:currency)
                  .where(currencies: { code: 'IDR' })
                  .where('wallets.balance > 0')
                  .distinct
                  .count(:user_id)

usd_users = Wallet.joins(:currency)
                  .where(currencies: { code: 'USD' })
                  .where('wallets.balance > 0')
                  .distinct
                  .count(:user_id)

selisih = idr_users - usd_users

puts "💵 Pengguna saldo IDR > 0 : #{idr_users}"
puts "💵 Pengguna saldo USD > 0 : #{usd_users}"
puts "📊 Selisih                : #{selisih}"

```

```
Output
💵 Pengguna saldo IDR > 0 : 53
💵 Pengguna saldo USD > 0 : 50
📊 Selisih                 : 3
```

`b`**🔍 Cek via REST API**

***Contoh Request API ke server selisih jumlah pengguna yang hold, dengan Bearer Token (menggunakan cURL):**
```bash
curl -X GET "http://141.11.25.96:3000/reports/balance_comparison?currency1=IDR&currency2=USD" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.0JsA7s0F251ERbLdyNgVMpppI6iv8sH52Lj4wDpP4fI" \
  -H "Content-Type: application/json"

```





**c. Source Pada hari apa paling banyak terjadi perubahan saldo IDR??**
```ruby
# Jalankan di Rails Console (rails c)
result = WalletTransaction
           .joins(wallet: :currency)
           .where(currencies: { code: 'IDR' })
           .group("DATE(wallet_transactions.created_at)")
           .sum(:amount)
           .max_by { |_, total| total }

puts "📆 Hari dengan total perubahan saldo IDR terbesar:"
puts "📅 #{result[0]} => 💰 #{result[1].round(2)}"


```

```
Output
📆 Hari dengan total perubahan saldo IDR terbesar:
📅 2025-10-03  =>  💰 26851498.0

```

`c`**🔍 Cek via REST API**

**Contoh Request API ke server hari apa paling banyak terjadi perubahan saldo dengan Bearer Token (menggunakan cURL):**
```bash
curl -X GET "http://141.11.25.96:3000/reports/top_balance_change_day?currency=IDR" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.0JsA7s0F251ERbLdyNgVMpppI6iv8sH52Lj4wDpP4fI" \
  -H "Content-Type: application/json"

```


**4. Gambarkan infrastruktur yang terbaik menurut anda agar aplikasi web/API bisa berjalan dengan efektif, aman, dan baik untuk scale up?**  
> ![Infrastruktur Aplikasi](assets/pic_2.png)
>
---



**5. Untuk menjaga high availability sistem, bagaimana cara anda melakukan deployment tanpa harus mengalami down server sama sekali?**  
> a-) BLUE -GREEN Deployment  
>    → Blue versi yang di pakai saat ini  
>    → Green versi yang akan di pasang  
>
> Alur yang saya pahami → Di pasang green dulu tapi tidak pakai user, jika Green Sudah oke, langsung alihkan semua user ke Green, dan seandainya ada masalah tinggal balik lagi saja yang BLUE.  
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
> Pakai Load Balancer  
>    → Load balancer membagi traffic ke beberapa server  
>    → BIsa tambah server baru versi baru, turunkan server lama pelan pelan  
>    → Jadi User tidak merakasan Downtime  
>     Simple nya tidak mengganti semua Sekaligus, Perlahan lahan atau sekaligus tapi aman dan tentu saja selalu cek kalau server baru sudah siap

---

**6. Menurut anda, manakah yang lebih baik diantara SQL dan NoSQL? Jelaskan alasannya.**  
> Menurutku dua dua nya bagus, tergantung situasi aja, kita pakai SQL, NO SQL  ? . Di project sebelumnya saya pakai Elastic Database karena Data social media biasanya JSON: misal tweet, komentar, post di Instagram → banyak field, nested misal (user, entities, hastag, url gambar, video dll)., jadi tinggal masukin aja  nested JSON, array, dan query di dalamnya gampang. .jika kasusnya transasi crypto saya akan pakai SQL buat nyimpen transaksi, saldo, dan data uang Kenapa? Karena SQL itu kayak lemari yang rapi banget ,Semua datanya punya kotak, label, dan aturan jelas.

---

**7. Bagaimana Anda mendesain sistem logging yang efisien dan mudah ditelusuri?**  
> a-) Catat yg penting penting saja, misal ada masalah (ERROR), Peringatan (WARNING), atau kejadian penting. TIdak di catat semua biar ga penuh  
> b-)Pakai FOrmat yg sama tiap catatan supaya gampang di baca dan di cari  
> c-)Bedakan Bersarkan jenis INFO (info biasa aja), WARNING (Perlu di perhatikan), ERROR (Ada masalah serius)  
> d-)Simpan di tempat yag mudah di cari, bisa bikin file txt di folder khusus bisa, di simpan ke db juga bisa  
> e-)Tambhakan id, dan waktu biar gampang nanti carinya  
> f-)Bersihkan Log biar ga numpuk  
> g-)JIka perlu kesepakatan kirim ke whatsapp Group yang terdiri dari Team Backend, jadi setiap orang bisa saling pantau (Di tempat kerja saya dulu saya bikin group WA nanti klo Log serius Ngirim ke Wa group)

---

**8. Jelaskan cara Anda menangani memory leak atau thread leak dalam aplikasi backend.**  
> a-)Pantau penggunaan memori bisa pakai top, htop dan lainya di linux  
> b-)kalau di codingan pastikan tidak ada variabel global yag gak di pakai  
> c-)Jangan biarin cache / pool tumbuh tanpa batas, pakai size limit atau eviction policy.  
> d-)Setiap thread selesai, harus dihentikan / dilepas  
> e-)intinya pantau, batasi, bersihkan, gunakan pool / garbage collector.

---

**9. Bagaimana Anda membagi tugas dan tanggung jawab dalam tim backend?**  
> a -) Berdasarkan tugas dan modul misal modul Auth (Bikin login, Jwt dll) , API bisnis Logic (ngurusin API), Monitoring Performance (yang cek log, metrics, alert dll) . jadi setiap orang saya fokuskan ke 1 modul dlu atau bisa memungkinkan lebih dari 2 tergantung Prioritas, waktu, kondisi  
> b- )Koordinasi (bisa daily standup, diskusi dll) atau penggunaan tools seperti JIra, Notion untuk asign tugas  
> c- )Evaluasi berkala: lihat progres, bantu yang kesulitan

---

**10. Bagaimana Anda memastikan kualitas kode di tim backend Anda?**  
> a-) Di cek temen tim → Code Review  
> b-) Sesuaikan Standard -> Style guide & linting  
> c-) Diuji -> Unit & Integration test  
> d-) Jaga permforma dengan monitoring dan logging  
> e-) Dicatat atau di dokumentasi  
> f-) Di perbaharui codinganya (refactoring)
