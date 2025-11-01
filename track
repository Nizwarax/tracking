#!/usr/bin/python3
import json
import requests
import time
import os
import threading
import socket
import subprocess
import urllib.request
from sys import stderr

try:
    import phonenumbers
    from phonenumbers import carrier, geocoder, timezone
    from flask import Flask, request, redirect
except ImportError:
    print("Menginstal dependensi...")
    os.system('pip install flask phonenumbers requests')
    print("Silakan jalankan ulang script.")
    exit()

# --- WARNA ---
Bl = '\033[30m'
Re = '\033[1;31m'
Gr = '\033[1;32m'
Ye = '\033[1;33m'
Blu = '\033[1;34m'
Mage = '\033[1;35m'
Cy = '\033[1;36m'
Wh = '\033[1;37m'

# --- DATA HASIL PELACAKAN ---
captured_data = []

# --- FLASK APP ---
app = Flask(__name__)

@app.route('/')
def track():
    ip = request.headers.get('X-Forwarded-For', request.remote_addr)
    ua = request.headers.get('User-Agent', 'Unknown')
    ref = request.referrer or 'Direct'
    lang = request.headers.get('Accept-Language', 'en').split(',')[0]
    platform = request.headers.get('Sec-Ch-Ua-Platform', 'Unknown').strip('"')

    data = {
        "ip": ip,
        "user_agent": ua,
        "referrer": ref,
        "language": lang,
        "platform": platform,
        "time": time.strftime("%Y-%m-%d %H:%M:%S")
    }
    captured_data.append(data)

    print(f"\n{Gr}[+] TARGET MENGAKSES LINK!{Wh}")
    print(f"{Wh}IP           : {Gr}{ip}")
    print(f"{Wh}Platform     : {Gr}{platform}")
    print(f"{Wh}Browser      : {Gr}{ua[:60]}...")
    print(f"{Wh}Bahasa       : {Gr}{lang}")
    print(f"{Wh}Waktu        : {Gr}{data['time']}")
    print(f"{Wh}{'-'*50}")

    return redirect("https://google.com", code=302)

# --- UTILITIES ---
def is_option(func):
    def wrapper(*args, **kwargs):
        run_banner()
        func(*args, **kwargs)
    return wrapper

def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except:
        return "127.0.0.1"

def start_flask():
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False)

def start_ngrok():
    try:
        proc = subprocess.Popen(['ngrok', 'http', '5000'],
                               stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        time.sleep(2)
        with urllib.request.urlopen("http://localhost:4040/api/tunnels") as resp:
            tunnels = json.loads(resp.read())
            for t in tunnels['tunnels']:
                if t['proto'] == 'https':
                    return t['public_url']
    except Exception as e:
        print(f"{Re}Ngrok error: {e}")
    return None

# --- MENU FUNGSI ---
@is_option
def IP_Track():
    ip = input(f"{Wh}\n Masukan IP Target : {Gr}")
    try:
        r = requests.get(f"http://ipwho.is/{ip}", timeout=10)
        d = r.json()
        if not d.get("success", True):
            print(f"{Re}IP tidak valid.")
            return
        print(f"\n{Wh}Negara  : {Gr}{d.get('country')}")
        print(f"{Wh}Kota    : {Gr}{d.get('city')}")
        print(f"{Wh}ISP     : {Gr}{d.get('connection', {}).get('isp')}")
        lat, lon = d.get('latitude'), d.get('longitude')
        if lat and lon:
            print(f"{Wh}Maps    : {Gr}https://google.com/maps/@{lat},{lon},8z")
    except Exception as e:
        print(f"{Re}Error: {e}")

@is_option
def phoneGW():
    num = input(f"\n {Wh}Nomor (+62...) : {Gr}")
    try:
        p = phonenumbers.parse(num, "ID")
        if phonenumbers.is_valid_number(p):
            print(f"{Wh}Negara   : {Gr}{geocoder.description_for_number(p, 'id')}")
            print(f"{Wh}Provider : {Gr}{carrier.name_for_number(p, 'en') or 'N/A'}")
            print(f"{Wh}Valid    : {Gr}Ya")
        else:
            print(f"{Re}Nomor tidak valid!")
    except Exception as e:
        print(f"{Re}Error: {e}")

@is_option
def TrackLu():
    u = input(f"\n {Wh}Username : {Gr}")
    sites = {
        "GitHub": f"https://github.com/{u}",
        "Instagram": f"https://instagram.com/{u}",
        "Twitter": f"https://twitter.com/{u}",
        "TikTok": f"https://tiktok.com/@{u}",
        "LinkedIn": f"https://linkedin.com/in/{u}"
    }
    print(f"\n{Wh}Mengecek {len(sites)} platform...")
    for name, url in sites.items():
        try:
            r = requests.get(url, timeout=5)
            status = f"{Gr}✓ Ada" if r.status_code == 200 else f"{Ye}✗ Tidak"
        except:
            status = f"{Re}Error"
        print(f"{Wh}[{Gr}+{Wh}] {name:<10}: {status}")

@is_option
def showIP():
    try:
        ip = requests.get('https://api.ipify.org').text
        print(f"\n{Wh}IP Publik Anda: {Gr}{ip}")
    except:
        print(f"{Re}Gagal.")

@is_option
def local_tracker():
    captured_data.clear()
    ip = get_local_ip()
    print(f"\n{Wh}Link LAN: {Cy}http://{ip}:5000")
    print(f"{Ye}Hanya untuk perangkat dalam jaringan yang sama.")
    threading.Thread(target=start_flask, daemon=True).start()
    try:
        while True: time.sleep(1)
    except KeyboardInterrupt:
        print(f"\n{Wh}Kembali ke menu...")

@is_option
def remote_tracker():
    captured_data.clear()
    print(f"\n{Wh}Memulai server + ngrok...")
    threading.Thread(target=start_flask, daemon=True).start()
    time.sleep(1)
    url = start_ngrok()
    if not url:
        print(f"{Re}Gagal membuat link publik. Pastikan ngrok terinstal & terautentikasi.")
        input("\nTekan Enter...")
        return
    print(f"\n{Gr}✅ LINK GLOBAL SIAP!")
    print(f"{Wh}Kirim ke siapa saja di dunia:")
    print(f"{Cy}{url}")
    print(f"\n{Ye}Data muncul otomatis di sini saat dibuka.")
    try:
        while True: time.sleep(1)
    except KeyboardInterrupt:
        print(f"\n{Wh}Menghentikan...")

# --- MENU UTAMA ---
options = [
    {'num': 1, 'text': 'Lacak IP', 'func': IP_Track},
    {'num': 2, 'text': 'IP Saya', 'func': showIP},
    {'num': 3, 'text': 'Lacak Nomor HP', 'func': phoneGW},
    {'num': 4, 'text': 'Cari Username', 'func': TrackLu},
    {'num': 5, 'text': 'Pelacak LAN', 'func': local_tracker},
    {'num': 6, 'text': 'Pelacak Internet (Ngrok)', 'func': remote_tracker},
    {'num': 0, 'text': 'Keluar', 'func': exit}
]

def clear():
    os.system('cls' if os.name == 'nt' else 'clear')

def run_banner():
    clear()
    stderr.write(f"""{Wh}
         .-.
       .'   `.          {Wh}--------------------------------
       :g g   :         {Wh}| {Gr}ULTIMATE TRACKER PRO {Wh}|
       : o    `.        {Wh}|    {Gr}Powered by Dark   {Wh}|
      :         ``.     {Wh}--------------------------------
     :             `.
    :  :         .   `.
    :   :          ` . `.
     `.. :            `. ``;
        `:;             `:'
           :              `.
            `.              `.     .
              `'`'`'`---..,___`;.-'
    """)

def main():
    while True:
        clear()
        print(f"""
  _______             _    _             _____                 
 |__   __|           | |  (_)           |  __ \\                
    | |_ __ __ _  ___| | ___ _ __   __ _| |  | | _____   ______
    | | '__/ _` |/ __| |/ / | '_ \\ / _` | |  | |/ _ \\ \\ / /_  /
    | | | | (_| | (__|   <| | | | | (_| | |__| |  __/\\ V / / / 
    |_|_|  \\__,_|\\___|_|\\_\\_|_| |_|\\__, |_____/ \\___| \\_/ /___|
                                    __/ |                      
                                   |___/                       
{Wh}Developed Mod by Deki_niswara | https://t.me/Drk_System2x
        """)
        for opt in options:
            print(f"{Wh}[{opt['num']}] {opt['text']}")
        try:
            c = int(input(f"\n{Wh}[+]{Gr} Pilih: {Wh}"))
            for opt in options:
                if opt['num'] == c:
                    opt['func']()
                    input(f"\n{Wh}Tekan Enter untuk kembali...")
                    break
            else:
                if c != 0:
                    print(f"{Re}Pilihan tidak valid!")
                    time.sleep(1)
        except (ValueError, EOFError):
            print(f"{Re}Masukkan angka!")
            time.sleep(1)
        except KeyboardInterrupt:
            print(f"\n{Gr}Keluar...")
            break

if __name__ == '__main__':
    main()
