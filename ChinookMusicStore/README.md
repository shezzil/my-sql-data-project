# 🎵 Music Store Database Insights (SQL Project)

Welcome to the **Music Store Database Analysis** project! This project contains carefully crafted SQL queries that unlock powerful insights from a sample music database (like Chinook). Whether you're a data analyst, aspiring SQL expert, or music enthusiast, this project showcases how SQL can be used to answer real-world business questions in the entertainment industry.

---

## 📊 Project Overview

The database consists of:
- 🎤 Artists & Albums
- 🎧 Tracks & Genres
- 📀 Playlists
- 👨‍💼 Employees & Customers
- 🧾 Invoices & Invoice Lines
- 🌍 Global Customer Base

We explore questions that help:
- 🎯 Identify top-performing artists
- 🧠 Understand listener behavior
- 🎫 Plan events like concerts
- 🔎 Detect anomalies or data issues

---

## 🔍 Insights & SQL Queries

Below are the business questions, followed by SQL queries to solve them:

### 1️⃣ Most Productive Artist (by No. of Albums)
**Question**: Who has produced the most albums?
- 🎯 **Insight**: Useful for targeting high-contributing artists.
```sql
SELECT a.Name AS Artist, COUNT(al.AlbumId) AS Album_Count
FROM Artist a
JOIN Album al ON a.ArtistId = al.ArtistId
GROUP BY a.Name
ORDER BY Album_Count DESC
LIMIT 1;
