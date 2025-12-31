SELECT schemaname, tablename	
FROM pg_tables
ORDER BY schemaname, tablename;

select * from endeavour.company_locations;

select address, city, state, zip, country from endeavour.company_locations;

select distinct city from endeavour.company_locations;

select distinct state from endeavour.company_locations cl ;

select count(distinct state) from endeavour.company_locations cl ;

select count(distinct city) from endeavour.company_locations cl ;

select distinct city, state from endeavour.company_locations cl ;

select count(distinct(city, state)) from endeavour.company_locations cl ;

select * from endeavour.company_locations cl where city = 'Santa Clara' and state = 'CA';

select * from endeavour.company_locations cl where city = 'Santa Clara';

select * from endeavour.company_locations cl where city like '%South%';

select * from endeavour.company_locations cl where city ilike '%south%';

select * from endeavour.company_locations cl where city like 'South%';

select * from endeavour.company_locations cl where state not like 'C_';

select distinct sector_name from endeavour.sector_lookup sl ;

select sector_name from endeavour.sector_lookup sl where sl.sector_name ilike 'health%';

select sector_name from endeavour.sector_lookup sl where sl.sector_name ilike 'technology';

select * from endeavour.subsector_lookup sl where sl.sector_id = '34';

select * from endeavour.stock_fundamentals sf where sf.sector_id = '37';

set search_path to endeavour, public;









