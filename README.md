# 🌐 Global Syndicate — Backend Engine & Cloud Architecture

> AAA Photorealistic, Viral-First Global Simulation Engine  
> Built with Godot Engine, Node.js/Express REST API, and Supabase Database Infrastructure.

---

## 🏗️ Repository Architecture & Files

This repository houses the core backend logic, relational schemas, and physics mechanics for *Global Syndicate*:

* **`server.js`** — Main Express/Node.js REST API entry point connecting Godot client requests to Supabase.
* **`utn_mechanics.gd`** — GDScript logic handling Undersea Transit Network (UTN) ocean toll deductions and high-speed tunnel propulsion physics.
* **`apex_tax_rules.sql`** — PostgreSQL trigger functions calculating and distributing Sovereign national tariffs into Apex Tower vaults.
* **`syndicate_ranks.sql`** — Database schema for the 5-tier syndicate player hierarchy, vault permissions, and allowances.
* **`vehicle_marketplace.sql`** — Catalog logic for vehicle classes, luxury tariffs, and impound insurance fees.
* **`social_media_strategy.md`** — Content execution blueprint for 9:16 vertical viral distribution across social channels.

---

## ⚡ Core Systems Overview

### 🏰 1. Apex Tower Infrastructure
* **Indestructible Unit Hardcap:** 1,000,000 structural units per sovereign nation.
* **National Tax Rate:** Automatic tariff collected on all in-region purchases and UTN ocean tunnel entries.
* **Vault Distribution:** Revenue split between automated defense grids, The Sovereign's offshore vault, and syndicate payouts.

### 🌊 2. Undersea Transit Network (UTN)
* Pressurized, transparent ocean tunnels connecting sovereign nations.
* Sub-oceanic propulsion boosters capping vehicle speeds at 450 KPH.
* Integrated toll gates linked directly to player `player_vaults`.

---

## 🚀 Setup & Deployment
1. Import SQL files (`.sql`) into the Supabase SQL Editor.
2. Attach `utn_mechanics.gd` to vehicle and transit scene nodes in Godot.
3. Configure environment variables in `.env` for Supabase API keys and database endpoints.
