# Jarkom-Modul-3-2026-K-47

| No | Nama | NRP |
|:---:|---|---|
| 1 | Elisabeth La Satta Sitorus | 5027251039 |
| 2 | Farrel Muhammad Athasyah Enrizy | 5027251100 |

Topologi jaringan:  
<img src="assets/Modul3_Topologi.png" width="450">

### Soal 1 (Elisabeth)
1. Konfigurasi Router Relay `jichi`:
   **Menambahkan DNS Resolver**:
   ```
   echo "nameserver 192.168.122.1" > /etc/resolv.conf
   ```
   **Mengaktifkan IP forwarding agar `jichi` berfungsi sebagai router**:
   ```
   echo 1 > /proc/sys/net/ipv4/ip_forward
   ```
   **Mengatur NAT Masquerade**:
   ```
   iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
   ```
   **Pengalokasian Alamat IP Gateway**: 
   ```
   ip addr add 10.87.1.1/24 dev eth1   # Network 1
   ip addr add 10.87.2.1/24 dev eth2   # Network 2
   ip addr add 10.87.3.1/24 dev eth3   # Network 3
   ip addr add 10.87.4.1/24 dev eth4   # Network 4 
   ```
   **Aktivasi Interface**: 
   ```
   ip link set eth1 up
   ip link set eth2 up
   ip link set eth3 up
   ip link set eth4 up
   ```
2. Konfigurasi Interface Clients:
   **Klien Network 1 & Network 4 (IP Statis)**:
   ```
   auto eth0
   iface eth0 inet static
     address 10.87.1.2
     netmask 255.255.255.0
     gateway 10.87.1.1
   ```
   **Klien Network 2 & Network 3 (DHCP Client)**:
   ```
   auto eth0
   iface eth0 inet dhcp
   ```

 Hasil:  
 <img src="assets/Modul3_1Tes.png" width="450">  
 <img src="assets/Modul3_1Tes2.png" width="450">  
 <img src="assets/Modul3_1Tes3.png" width="450">
  
### Soal 2 (Elisabeth)
1. Konfigurasi DNS & Instalasi Paket:
   `tengen`:  
   **Menambahkan nameserver ke dalam `/etc/resolv.conf`**:
   ```
   echo "nameserver 192.168.122.1" > /etc/resolv.conf
   ```
   **Melakukan update repository dan menginstal paket DHCP server**:
   ```
   DEBIAN_FRONTEND=noninteractive apt-get update
   DEBIAN_FRONTEND=noninteractive apt-get install -y isc-dhcp-server
   ```
2. Deklarasi Subnet pada `/etc/dhcp/dhcpd.conf`:
   **Menambahkan deklarasi Subnet Network 4 agar layanan DHCP berjalan tanpa pool dinamis**:
   ```
   subnet 10.87.4.0 netmask 255.255.255.0 {
   }
   ```
   **Menambahkan Scope DHCP untuk Network 2**:
   ```
   subnet 10.87.2.0 netmask 255.255.255.0 {
       range 10.87.2.100 10.87.2.200;
       option routers 10.87.2.1;
       option domain-name-servers 192.168.122.1;
   }
   ```
   **Menambahkan Scope DHCP untuk Network 3**:
   ```
   subnet 10.87.3.0 netmask 255.255.255.0 {
       range 10.87.3.100 10.87.3.200;
       option routers 10.87.3.1;
       option domain-name-servers 192.168.122.1;
   }
   ```
4. Menentukan Interface dan Aktivasi Layanan:
   **Mengedit file `/etc/default/isc-dhcp-server` untuk mendaftarkan `eth0` ke dalam parameter `INTERFACESv4`. Melakukan *restart* layanan dan mengecek statusnya**:  
   ```
   service isc-dhcp-server restart
   service isc-dhcp-server status
   ```

Hasil:  
<img src="assets/Modul3_2.png" width="450">
       
### Soal 3 (Elisabeth)
1. Instalasi DHCP Relay di Router `jichi`:
   **Melakukan update repositori dan menginstal paket relay**:
   ```
   apt-get update
   apt-get install -y isc-dhcp-relay
   ```
2. Konfigurasi Parameter Relay:
   **Mengedit file `/etc/default/isc-dhcp-relay` untuk mendefinisikan alamat server DHCP tujuan dan interface yang akan melayani relay**:
   ```
   SERVERS="10.87.4.10"
   INTERFACES="eth2 eth3 eth4"
   OPTIONS=""
   ```
3. Aktivasi Layanan Relay:
   **Melakukan *restart* pada layanan `isc-dhcp-relay` dan memverifikasi status *runnning* nya menggunakan `service isc-dhcp-relay status` serta `ps aux | grep dhcrelay`**.  
   <img src="assets/Modul3_3.png" width="450">
4. Pengujian Klien (`itadori` dan `ino`):
   **Meminta alokasi alamat IP secara dinamis melalui antarmuka `eth0` menggunakan perintah**:
   ```
   dhclient -v eth0
   ip a
   ```

Hasil:  
<img src="assets/Modul3_3Tes.png" width="450">  
<img src="assets/Modul3_3Tes2.png" width="450">

### Soal 4 (Elisabeth)
Catat MAC Address `itadori`, `fushiguro`, `maki`, `zenin` lalu,  
1. Deklarasi Kelas dan Subkelas Client:
   **Pada server `tengen`, edit `/etc/dhcp/dhcpd.conf`**:  
   Masukkan alamat MAC klien ke dalam kelompok `subclass` yang sesuai:
  ```
  nano /etc/dhcp/dhcpd.conf
  #ke ip 10.87.2.0
  # Deklarasi Kelas untuk Tim Dev (itadori & fushiguro)
  class "Dev" {
      match hardware;
  }
  subclass "Dev" 1:02:42:f7:f8:9b:00;
  subclass "Dev" 1:02:42:ed:4d:25:00;
  
  # Deklarasi Kelas untuk Tim Support (zenin & okkotsu)
  class "Support" {
      match hardware;
  }
  subclass "Support" 1:02:42:14:ef:e3:00;
  subclass "Support" 1:02:42:f5:2a:33:00;
  
  # Subnet Network 2 dengan pemisahan Pool
  subnet 10.87.2.0 netmask 255.255.255.0 {
      option routers 10.87.2.1;
      option domain-name-servers 192.168.122.1;
  
      # Pool 1 (Dev)
      pool {
          allow members of "Dev";
          range 10.87.2.10 10.87.2.35;
      }
  
      # Pool 2 (Support)
      pool {
          allow members of "Support";
          range 10.87.2.70 10.87.2.95;
      }
  }
  ```
2. Aktivasi Konfigurasi Server:
  ```
  service isc-dhcp-server restart
  service isc-dhcp-server status
  ```
3. Pembersihan Sesi dan Pengujian Client (`itadori`, `fushiguro`, `maki`, `zenin`):
   **Pada interface client, kosongkan sesi `ip addr flush dev eth0`**.
   **Bersihkan sisa data penyewaan IP melalui perintah `rm -f /var/lib/dhcp/dhclient*.leases` dan hapus file PID *dhclient* lama**.
   **Lakukan *restart node* lalu verifikasi perolehan IP baru menggunakan perintah `ip a`**.

Hasil:  
<img src="assets/Modul3_4Tes.png" width="450">  
<img src="assets/Modul3_4Tes2.png" width="450">  
<img src="assets/Modul3_4Tes3.png" width="450">  
<img src="assets/Modul3_4Tes4.png" width="450">

### Soal 5 (Elisabeth)
Catat MAC Address `ino`, `kusakabe`, `kugisaki`, `miwa` lalu,
1. Klasifikasi Client Berdasarkan MAC Address:
   **Buka file konfigurasi di server `tengen` menggunakan perintah nano /etc/dhcp/dhcpd.conf`**.
   ```
   # Kelas Short Lease untuk ino & kusakabe
    class "ShortLease" {
        match hardware;
    }
    subclass "ShortLease" 1:02:42:31:b0:31:00;
    subclass "ShortLease" 1:02:42:38:01:2b:00;
    
    # Kelas Long Lease untuk miwa
    class "LongLease" {
        match hardware;
    }
    subclass "LongLease" 1:02:42:0a:45:28:00;
    
    # Deklarasi Subnet Network 3 dengan Lease dan Options Khusus
    subnet 10.87.3.0 netmask 255.255.255.0 {
        option routers 10.87.3.1;
        option domain-name-servers 10.87.1.2, 10.87.1.3;
        option domain-search "K47.com";
    
        # Pool Short Lease (Durasi 30 menit / 1800 detik)
        pool {
            allow members of "ShortLease";
            range 10.87.3.10 10.87.3.89;
            default-lease-time 1800;
            max-lease-time 1800;
        }
    
        # Pool Long Lease (Durasi 12 jam / 43200 detik)[cite: 21]
        pool {
            allow members of "LongLease";
            range 10.87.3.100 10.87.3.199;
            default-lease-time 43200;
            max-lease-time 43200;
        }
    }
    ```
2. Aktivasi Konfigurasi dan Pengujian:
   **Terapkan layanan melalui `tengen` dengan perintah `service isc-dhcp-server restart` lalu pastikan beroperasi dengan baik lewat `service isc-dhcp-server status`**.
   **Lakukan *restart* pada semua *node*, tes `tengen` dengan `cat /var/lib/dhcp/dhcpd.leases`**.

Hasil:  
<img src="assets/Modul3_5DHCP.png" width="450">  
<img src="assets/Modul3_5Tes.png" width="450">  
<img src="assets/Modul3_5Tes2.png" width="450">  
<img src="assets/Modul3_5Tes3.png" width="450">

### Soal 6 (Elisabeth)
1. Konfigurasi Static Lease di Server `tengen`:
   **Buka file konfigurasi utama DHCP server menggunakan perintah `nano /etc/dhcp/dhcpd.conf`.
   **Tambahkan blok deklarasi `host` khusus untuk klien VIP (`kugisaki`) yang mengikat MAC Address perangkat (`02:42:d7:1d:92:00`) dengan alamat IP spesifik (`10.87.3.99`):
   ```
   # Konfigurasi Static Lease untuk Kugisaki (VIP)
       host kugisaki {
           hardware ethernet 02:42:d7:1d:92:00;
           fixed-address 10.87.3.99;
       }
   ```
    [cite: 34]

  2. Restart dan Verifikasi Layanan DHCP:
     **Terapkan konfigurasi baru dengan melakukan *restart* pada layanan `isc-dhcp-server` dan pastikan status layanannya kembali aktif (*running*):
     ```
     service isc-dhcp-server restart
     service isc-dhcp-server status
     ```

  3. Pengujian pada `kugisaki`:
     **Lakukan *restart* pada *node* client**.
     **Setelah *node* menyala kembali, jalankan perintah `ip a` untuk memverifikasi alamat antarmuka jaringan yang diperoleh dari server**.

Hasil:  
<img src="assets/Modul3_6.png" width="450">

### Soal 7 (Elisabeth)
1. Pengecekan Daftar Sewa IP (DHCP Leases):
   `tengen`  
   **Jalankan perintah berikut untuk melihat secara langsung riwayat dan daftar alokasi IP dinamis yang sedang disewakan kepada client**:
   ```
   cat /var/lib/dhcp/dhcpd.leases
   ```

  2. Pengecekan Konfigurasi Utama DHCP:
     **Jalankan perintah berikut untuk membaca dan memverifikasi kembali seluruh aturan *subnet*, *class*, *pool*, dan reservasi statis**:
     ```
     cat /etc/dhcp/dhcpd.conf
     ```

Hasil:  
<img src="assets/Modul3_7Te4.png" width="450">  
<img src="assets/Modul3_7Tes.png" width="450">  
<img src="assets/Modul3_7Tes2.png" width="450">  
<img src="assets/Modul3_7Tes3.png" width="450">

### Soal 8 (Elisabeth)
1. Monitoring Paket trafik di Server `tengen`:
   **Buka terminal pada server `tengen` dan gunakan `tcpdump` untuk memantau seluruh lalu lintas data yang masuk atau keluar melalui port DHCP (port 67 untuk server dan 68 untuk klien).
   ```
   tcpdump -i any -nn -v port 67 or port 68
   ```
   
2. Inisiasi Ulang Permintaan IP di `ino`:
   **Beralih ke terminal `ino`, kemudian matikan proses *client* DHCP yang mungkin masih berjalan di latar belakang menggunakan `pkill`**.
   ```
   pkill udhcpc
   udhcpc -i eth0 -n
   ```

Hasil:  
<img src="assets/Modul3_8.png" width="450">

### Soal 9 (Elisabeth)
1. Simulasi Kegagalan Relay di `jichi`:
   **Buka terminal router `jichi` dan matikan layanan DHCP Relay untuk mensimulasikan terjadinya gangguan**:
   ```
   service isc-dhcp-relay stop
   ```

2. Pengujian Permintaan IP saat Gangguan (`ino`):
   **Beralih ke terminal klien `ino` dan paksa client untuk meminta alokasi IP baru menggunakan parameter `-n` (agar langsung keluar/berhenti jika gagal)**:
   ```
   udhcpc -i eth0 -n
   ```
3. Pemulihan Layanan Relay di `jichi`:
   **Kembali ke terminal `jichi` dan hidupkan ulang layanan DHCP Relay agar jalur distribusi kembali normal**:
   ```
   service isc-dhcp-relay start
   ```

4. Pengujian Permintaan IP (`ino`):
   ```
   udhcpc -i eth0 -n
   ```

Hasil:  
<img src="assets/Modul3_9Tes.png" width="450">  
<img src="assets/Modul3_9Tes2.png" width="450">  
<img src="assets/Modul3_9Tes3.png" width="450">

### Soal 10 (Elisabeth)
1. Aktivasi Autostart Layanan:
   **Buka terminal pada server `tengen` dan atur agar layanan DHCP Server otomatis menyala**:
   ```
   update-rc.d isc-dhcp-server defaults
   update-rc.d isc-dhcp-server enable
   ```
   **Buka terminal pada router `jichi` dan atur autostart untuk layanan DHCP Relay**:
   ```
   update-rc.d isc-dhcp-relay defaults
   update-rc.d isc-dhcp-relay enable
   ```
2. Restart Node dan Verifikasi Status Layanan:
   **Lakukan *restart* pada node `tengen` dan `jichi`**.
   **Setelah menyala kembali, pastikan status kedua layanan sudah *running* secara otomatis tanpa dihidupkan manual**:
   Di `tengen`: `service isc-dhcp-server status`
   Di `jichi`: `service isc-dhcp-relay status`
3. Pengujian Network 2 & 3:
   **Pada client perwakilan (misal `ino` untuk Network 3 dan `itadori` untuk Network 2), tarik IP baru**:
   ```
   udhcpc -i eth0
   ip a
   ip route
   ```
   **Lakukan tes konektivitas (Ping) antar-klien dan ke arah Data Center**:
   ```
   ping -c 3 10.87.4.10
   ```

Hasil:  
<img src="assets/Modul3_10Cat.png" width="450">  
<img src="assets/Modul3_10Cat2.png" width="450">  
<img src="assets/Modul3_10IP.png" width="450">  
<img src="assets/Modul3_10IP2.png" width="450">  
<img src="assets/Modul3_10IP3.png" width="450">  
<img src="assets/Modul3_10Lease.png" width="450">  
<img src="assets/Modul3_10Lease2.png" width="450">  
<img src="assets/Modul3_10Restart.png" width="450">  
<img src="assets/Modul3_10Restart2.png" width="450">  
<img src="assets/Modul3_10Ping.png" width="450">  
<img src="assets/Modul3_10Ping2.png" width="450">  
<img src="assets/Modul3_10Ping3.png" width="450">  
<img src="assets/Modul3_10Ping4.png" width="450">  
