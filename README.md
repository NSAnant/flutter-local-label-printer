# 📦 Flutter Label Printing App

A **Flutter-based label printing application** designed for **TSC TE244** and other TSPL-compatible thermal printers.  
Supports **local network printing**, **printer discovery**, **manual printer addition**, **product list from Excel**,  
**TSPL template selection**, and **print preview**.  

## ✨ Features

- 📂 **TSPL Template Management** – User can select from multiple pre-saved TSPL templates.
- 📋 **Product List from Excel** – Loads products with:
  - Product ID
  - Product Name (English)
  - Product Name (Marathi)
- 🔍 **Product Search** – Search by product ID or product name.
- 💰 **Manual Price Entry** – User can set product price before printing.
- 🖨 **Printer Discovery (LAN)** – Auto-detect printers on the local network.
- ➕ **Manual Printer Addition** – Add printers by IP address and store locally.
- 🗄 **Local Database** – Caches printers and settings for offline use.
- 👁 **Print Preview** – Shows the final label before sending to the printer.
- ⚡ **Local Print Support** – Direct TSPL command printing to the selected printer.
- 📱 **Responsive UI** – Works on Android tablets and mobile devices.
- 🚫 **No Cloud Printing (this version)** – Cloud print to be added in the next release.

## 🛠 Tech Stack

- **Flutter** (Latest Stable)
- **Dart**
- **permission_handler** – For runtime permissions.
- **sqflite** – Local storage of printers and settings.
- **flutter_blue_plus / custom networking** – For printer discovery.
- **excel / csv** – Product list import.
- **custom_painter** – For print preview rendering.


