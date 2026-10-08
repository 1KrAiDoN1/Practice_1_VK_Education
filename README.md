# Практическая работа 1 по дисциплине "Основы теории информации"

Выполнил: Васильев Павел Александрович БИВТ-24-СП-3

Вариант 4 — Q16 «Parts/Supplier Relationship»
Что делает: сколько поставщиков у деталей (по брендам/типам/размерам), исключая поставщиков с жалобами.

Таблицы: part ⋈ partsupp (+ подзапрос по supplier).
```sql
SELECT
  p.brand,
  p.type,
  p.size,
  count(DISTINCT ps.suppkey) AS supplier_cnt
FROM tpch.sf1.partsupp AS ps
JOIN tpch.sf1.part AS p ON p.partkey = ps.partkey
WHERE p.brand <> 'Brand#45'
  AND p.type NOT LIKE 'MEDIUM POLISHED%'
  AND p.size IN (49, 14, 23, 45, 19, 3, 36, 9)
  AND ps.suppkey NOT IN (
    SELECT suppkey
    FROM tpch.sf1.supplier
    WHERE comment LIKE '%Customer%Complaints%'
  )
GROUP BY p.brand, p.type, p.size
ORDER BY supplier_cnt DESC, p.brand, p.type, p.size;
```
Подсказка для медальона: Bronze — сырые part, partsupp (и supplier для подзапроса); Silver — отфильтровать поставщиков с жалобами, джойн деталь↔поставка; Gold — brand, type, size, supplier_cnt.
