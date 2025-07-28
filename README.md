# 🏎️ Formula 1 Data Analysis Case Study using SQL

## 📌 Overview
This case study dives deep into the world of **Formula One (F1)** using structured **SQL analysis**. It leverages a comprehensive dataset covering over **70+ years of F1 history (1950–2023)**, including data on races, drivers, constructors, circuits, lap times, pit stops, and championships.

The project answers **30+ real-world F1 business questions**, offering insights into driver performance, constructor dominance, podium finishes, race history, and much more.

## 📂 Dataset Source
- 🔗 [Formula 1 World Championship Dataset (Kaggle)](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020?resource=download)

## 🧠 Tools & Tech Stack
- **SQL** (PostgreSQL)
- ER Diagram Tool: dbdiagram.io
- Dataset Cleanup: CSV files imported into PostgreSQL
- IDE: DBeaver / pgAdmin

  ## 🧠 SQL Concepts Used

- `JOIN` (inner, left)
- `GROUP BY`, `HAVING`, `ORDER BY`
- `CASE WHEN`, `IF`, and Boolean flags
- `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`
- **Window Functions**: `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`
- **Common Table Expressions** (`WITH`)
- Subqueries

## 📊 Key Insights Uncovered
Here are a few example questions solved in this project:

1. 🏁 Which country produced the most F1 drivers?
2. 🌍 What country has hosted the most circuits?
3. 📅 Race count per year, and first & last races each season
4. 🧓 Youngest vs. oldest F1 drivers
5. 🏟️ Most raced circuit with location
6. 🏆 All-time F1 champions & constructors' championship stats
7. 🔁 Drivers who’ve won races with multiple teams
8. ⛔ Constructors with 0 points & their race counts
9. 🏎️ Race winners and podiums in the 2022 season
10. ⚡ Average lap time per circuit ranked by speed
