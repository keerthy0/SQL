SELECT DISTINCT sector_name
FROM endeavour.sector_lookup;

SELECT DISTINCT sector_name
FROM endeavour.sector_lookup
WHERE sector_name ilike '%health%';

SELECT *
FROM endeavour.sector_lookup
WHERE sector_name ILIKE '%health%';


SELECT *
FROM endeavour.sector_lookup
WHERE sector_name ilike '%technology%';

SELECT DISTINCT subsector_name
FROM endeavour.subsector_lookup
WHERE sector_name ilike '%health%';


select * from stock_fundamentals where sector_id = 37 limit 20 offset 9;  


select ticker_symbol, market_cap from stock_fundamentals
where market_cap = (select min(market_cap) from stock_fundamentals);

select * from sector_lookup 
order by sector_id desc;

select * from sector_lookup where sector_id between 30 and 40 order by sector_id desc;


SELECT *
FROM endeavour.stock_fundamentals
WHERE market_cap BETWEEN 1000000000 AND 100000000000
ORDER BY market_cap DESC;

select min(market_cap), max(market_cap) from stock_fundamentals;

select avg(market_cap) from stock_fundamentals;

select count(*) from stock_fundamentals;

select sum(market_cap) as addition from stock_fundamentals;

select count(*) as count, avg(market_cap) as average,
sum(current_ratio) from endeavour.stock_fundamentals where current_ratio > 3 and market_cap < 500000000; 

-- Query that returns 8 stocks which have the lowest non-null current ratio
select * from endeavour.stock_fundamentals where current_ratio is not null 
order by current_ratio ASC limit 8;

select min(trading_date) from stocks_price_history sph;

select * from stocks_price_history where trading_date = (select min(trading_date) from stocks_price_history sph);

-- --Find ticker symbol, sector id, current_ratio and market_cap where current ratio is the least
--in the table
select ticker_symbol, sector_id, current_ratio, market_cap from endeavour.stock_fundamentals
where current_ratio = ( select min(current_ratio) from endeavour.stock_fundamentals);

-- Get the price history of Visa for the last 30 days

select * from stocks_price_history where ticker_symbol = 'V' and trading_date > current_date -150;

-- Get the price history for Visa for Dec 16,2015, July 10, 2012 and Sept 16, 2023

select * from stocks_price_history where ticker_symbol = 'SUNS' and trading_date 
between to_date('2015-12-16', 'yyyy-MM-dd') and to_date('2024-09-16', 'yyyy-MM-dd');

--Get the price history for Visa where trades have been done specifically
--on Dec 16,2025, July 10, 2012 and Jan 27, 2025 and on 23 Jan, 2025
SELECT *
FROM stocks_price_history
WHERE ticker_symbol = 'V'
  AND trading_date IN (
      DATE '2012-07-10',
      DATE '2025-01-23',
      DATE '2025-01-27',
      DATE '2025-12-16'
  )
ORDER BY trading_date;


select distinct ticker_symbol from stocks_price_history where ticker_symbol like '%N';

-- Get the stock price history for Nvidia for July 2022

select * from stocks_price_history where ticker_symbol = 'NVDA' and 
extract(year from trading_date) = 2022 and extract(month from trading_date) = 07;

-- Homework

-- 1.⁠ ⁠Calculate the highest close price, lowest open price and average high_price for AMD stock in
-- Dec 2023
select 
    max(close_price) as highest_close_price,
    min(open_price) as lowest_open_price,
    avg(high_price) as average_high_price
from stocks_price_history
where ticker_symbol = 'AMD' and extract(year from trading_date) = 2023 and extract(month from trading_date) = 12;

-- 2. Count the number of stocks that traded in 1962

select count(*) from stocks_price_history 
where extract(year from trading_date) = 1962;

-- 3. For the year 2022, get the stock which had the biggest price drop and when the price drop happened

SELECT MAX(open_price - close_price) as price_drop
FROM stocks_price_history
WHERE EXTRACT(YEAR FROM trading_date) = 2022
ORDER BY price_drop DESC
LIMIT 1;

SELECT ticker_symbol, trading_date, (open_price - close_price) AS price_drop
FROM stocks_price_history
WHERE EXTRACT(YEAR FROM trading_date) = 2022
ORDER BY price_drop DESC
LIMIT 1;
-- 4. For each year, get the stock with highest close price. 

select max(close_price) as highest_close_price
from stocks_price_history
group by extract(year from trading_date)
	
-- 5. Get min, max, avg close price for each ticker for the year 2022"

select ticker_symbol,
	min(close_price),
	max(close_price),
	avg(close_price)
from stocks_price_history
where extract(year from trading_date) = 2022
group by ticker_symbol;

-- For each month of 2023, find the highest close price and the avg high price

select extract(month from sph.trading_date) as TRADING_MONTH, max(close_price) as MAX_CP,
avg(high_price) as AVG_HP from endeavour.stocks_price_history sph where
extract (year from sph.trading_date) = 2023
group by extract(month from sph.trading_date);


-- Find the number of subsectors in each sector of the economy Using the right table

SELECT 
    s.sector_name,
    COUNT(DISTINCT ss.subsector_id) AS subsector_count
FROM sector_lookup s
LEFT JOIN subsector_lookup ss 
    ON s.sector_id = ss.sector_id
GROUP BY s.sector_name
ORDER BY subsector_count DESC;


select sector_id , count(subsector_name) as sector_count from endeavour.subsector_lookup sl
group by sl.sector_id 
order by sector_count desc;

-- Calculate the number of trading days for each stock and show the results by the oldest stock first

select ticker_symbol,
    count(*) AS trading_days,
    min(trading_date) AS first_trading_date
from stocks_price_history
group by ticker_symbol
order by first_trading_date asc;

-- Find the stocks which are common in both the tables
select sl.ticker_symbol , sl.ticker_name from endeavour.stocks_lookup sl
inner join endeavour.total_market_stocks tms
on sl.ticker_symbol = tms.ticker_symbol ;

--fetch all the data from lookup table and the matching data from stocks_price_history

SELECT 
    s.*, 
    p.*
FROM stocks_lookup s
LEFT JOIN stocks_price_history p
    ON s.ticker_symbol = p.ticker_symbol;


select sl.ticker_symbol, sl.ticker_name from stocks_lookup sl 
left join stocks_price_history sph 
on sl.ticker_symbol = sph.ticker_symbol;

SELECT *
FROM endeavour.stocks_lookup sl
LEFT JOIN endeavour.stocks_price_history sph
ON sl.ticker_symbol = sph.ticker_symbol;

-- 

SELECT * 
FROM 
    endeavour.stocks_lookup l
RIGHT JOIN 
    endeavour.stocks_price_history p
ON 
    l.ticker_symbol = p.ticker_symbol;

--Can you tell me which stocks have never been traded

select sl.ticker_name, sl.ticker_symbol, sph.trading_date from stocks_price_history sph full join stocks_lookup sl
on sph.ticker_symbol=sl.ticker_symbol
where sph.trading_date is null;

--Get the sector name, Subsector name, Ticker Name for Apple and AMD Stock along with its Market Cap and Current Ratio

select sl.sector_name, ssl.subsector_name, sl1.ticker_name, sf.market_cap, sf.current_ratio
from stock_fundamentals sf
join sector_lookup sl on sf.sector_id = sl.sector_id
join subsector_lookup ssl on sf.subsector_id = ssl.subsector_id
join stocks_lookup sl1 on sf.ticker_symbol = sl1.ticker_symbol 
where sf.ticker_symbol in('AAPL','AMD');

--Get the price history for Jun 2023 for Microsoft, along with its ticker name, sector name and subsector Name

select sph.*,sl.ticker_name,sl1.sector_name,ssl.subsector_name
from stock_fundamentals sf
join stocks_price_history sph on sf.ticker_symbol = sph.ticker_symbol
join stocks_lookup sl on sf.ticker_symbol = sl.ticker_symbol
join sector_lookup sl1 on sf.sector_id = sl1.sector_id
join subsector_lookup ssl on sf.subsector_id = ssl.subsector_id
where sf.ticker_symbol = 'MSFT' and 
extract(year from sph.trading_date)= 2023 and
extract(month from sph.trading_date)=6;

--Calculate the count of stocks in each sector of the economy. Display the sector name

select sl.sector_name,count(ticker_symbol) from stock_fundamentals sf
join sector_lookup sl on sf.sector_id = sl.sector_id
group by sector_name;

--Get the Top 10 highest market cap stocks, with their Ticker names, Sector and Sub-Sector names

select sl1.ticker_name,sl.sector_name,ssl.subsector_name,sf.market_cap
from stock_fundamentals sf
join stocks_lookup sl1 on sf.ticker_symbol = sl1.ticker_symbol
join sector_lookup sl on sf.sector_id = sl.sector_id
join subsector_lookup ssl on sf.subsector_id = ssl.subsector_id 
order by sf.market_cap desc limit 10;


select * from endeavour.stock_fundamentals sf;

select * from sector_lookup sl;

--Calculate the count of stocks in each sector of the economy. Display the sector name

select sector_name, count(ticker_symbol) as total_stocks_per_sector 
from stock_fundamentals sf, sector_lookup sl where sf.sector_id= sl.sector_id
group by sl.sector_name order by sector_name; 

select * 
from stock_fundamentals sf
where market_cap >(select market_cap from stock_fundamentals where ticker_symbol = 'MSFT');

--Get the Stock Price History for Nov 2013 for all stocks whose current ratio is greater than 10
select * from endeavour.stocks_price_history sph
join endeavour.stock_fundamentals sf
on sph.ticker_symbol = sf.ticker_symbol
where extract(year from sph.trading_date ) = 2013 and extract(month from sph.trading_date ) = 11 and sf.current_ratio > 10;

--find two stocks that have the same current ratio
select sf1.ticker_symbol, sf2.ticker_symbol, sf1.current_ratio from stock_fundamentals sf1, stock_fundamentals sf2
where sf1.current_ratio = sf2.current_ratio
and sf1.ticker_symbol != sf2.ticker_symbol;

-- Find the combination of stocks which closed at the same price on the same day in 2022
--ticker_symbol1, ticker_symbol2, trading_date, closing price
select sph1.ticker_symbol as ticker_symbol1 , sph2.ticker_symbol as ticker_symbol2, sph1.trading_date, sph1.close_price from stocks_price_history sph1, stocks_price_history sph2
where sph1.close_price = sph2.close_price
and sph1.ticker_symbol != sph2.ticker_symbol
and sph1.trading_date = sph2.trading_date 
and extract(year from sph1.trading_date)=2022;

-- Get the records from the stocks look up talbe that are nt present in the Total Market table
select * from stocks_lookup sl where sl.ticker_symbol not in (select ticker_symbol from
total_market_stocks);

--find the second highest market cap
select sf.ticker_symbol, sf.market_cap from stock_fundamentals sf
where sf.market_cap < (select max(market_cap) from stock_fundamentals sf2)
order by sf.market_cap desc limit 1;

--find the fourth highest market cap
select sf.ticker_symbol, sf.market_cap from stock_fundamentals sf
where sf.market_cap < (select max(market_cap) from stock_fundamentals sf2)
order by sf.market_cap desc offset 3 limit 1;

select * from endeavour.stock_fundamentals
order by market_cap DESC
offset 3
limit 1;

select * from endeavour.stock_fundamentals
order by market_cap DESC
offset 4-1
limit 1;

select * from endeavour.stock_fundamentals
order by market_cap DESC
offset n-1
limit 1;

--Get the stock price history for Mar 2020 for the stocks for the second and third hightest market cap

select * from stocks_price_history sph 
join stock_fundamentals sf on sph.ticker_symbol = sf.ticker_symbol 
where extract(year from sph.trading_date) = 2020 and extract(month from sph.trading_date) = 03
order by sf.market_cap desc
offset 1 limit 2;







