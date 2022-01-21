select COUNT (*) from msgemail where ch_situac ='P'

select CAST((dh_msg)AS DATE),COUNT(*) from msgemail 
where ch_situac = 'P'
group by 1