# 🏷️ Flutter Thermal Label Printing App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-orange.svg)](#)
[![Build](https://img.shields.io/github/actions/workflow/status/USERNAME/REPO/flutter-ci.yml?branch=main)](#)
[![Contributors](https://img.shields.io/github/contributors/USERNAME/REPO.svg)](#)
[![Issues](https://img.shields.io/github/issues/USERNAME/REPO.svg)](#)

--

## 📌 Overview

This Flutter application is designed for **local thermal label printing** using TSPL commands.  
It supports **TSC label printers** and allows users to design and print labels with dynamic data such as product name, price, quantity, and QR code.

--

## ✨ Features

- 🔍 **Printer Auto-Discovery** on Local Network (LAN)
- ➕ **Manual Printer Addition** (IP Address)
- 📦 **Local Product Database** (Preloaded from CSV/Excel)
- 🖨️ **Direct Local Printing** (TSPL commands)
- 📋 **Dynamic Label Templates**
- 🔎 **Search Products by ID or Name** (English/Marathi)
- ✏️ **Manual Price Input**
- 🔢 **Set Print Quantity** (Default 1)
- 👁️ **Print Preview** Before Sending Job
- ⚡ **Status Polling** to Confirm Print Success
- 💾 **Offline Printer Storage** in Local Database

--

## 📂 CSV Product Data Format

| Product ID | Product Name (EN) | Product Name (MR) | Unit |
|------------|-------------------|-------------------|------|
| 1001       | Sugar 1kg         | साखर १ किलो       | kg   |
| 1002       | Rice 5kg          | तांदूळ ५ किलो     | kg   |

--

## 🖼️ Screenshots

*(to be added app screenshots here)*

--

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Printing Protocol:** TSPL (TSC Printers)
- **Database:** SQLite (via sqflite package)
- **Networking:** mDNS, Socket Communication
- **CSV Parsing:** csv package

--

## 📑 Usage Workflow

1. Launch the app  
2. Detect printers automatically or manually add by IP  
3. Select **TSPL Template**  
4. Choose product from **Product List** (search or scroll)  
5. Enter **Price**  
6. Enter **Number of Labels** (default 1)  
7. Tap **Preview / Save** to generate TSPL print code  
8. Print directly to selected printer  

--

## 🔗 Useful Links

- [TSC TSPL Command Reference](https://medium.com/@zahidtekbas/using-tspl-commands-in-flutter-137ed8b8265f)
- [Using TSPL Commands in Flutter by Zahid Tekbaş](https://medium.com/@zahidtekbas/using-tspl-commands-in-flutter-137ed8b8265f)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
--

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

--

💡 **Tip:** Future versions will add **Cloud Printing Support**, **Multi-Template Support**, and **Advanced Label Designer**.
