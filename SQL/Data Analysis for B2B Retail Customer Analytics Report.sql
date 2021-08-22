/*
Database didapat dari DQLab. Database berasal dari perusahaan rintisan B2B yaitu xyz.com yang menjual
berbagai produk tidak langsung kepada end user tetapi ke perusahaan lainnya.

Tabel yang terdapat di database terdapat tiga tabel, yaitu
1. Transaksi penjualan quarter 1 (januari-maret) = orders_1
2. Transaksi penjualan quarter 2 (april-juni) = orders_2
3. Data profil customer
*/

/*
Dari project ini akan dilihat performa yang dimiliki perushaan xyz.com
pada quarter 1 dan quarter2 dan melihat bagaimana minat customer yang 
melakukan transaksi di perushaan retail B2B ini
*/
-- Total penjualan dan revenue pada quarter 1 dan orders_2

select
    sum(quantity) total_penjualan,
    sum(quantity*priceEach) revenue
from
    orders_1
where
    status = "Shipped";

select
    sum(quantity) total_penjualan,
    sum(quantity*priceeach) revenue
from
    orders_2
where
    status = "Shipped";

/*Dari hasil yang terlihat, total penjualan dan revenue pada quarter 1 lebih besar 
dari pada penjualan di quarter 2.*/

-- Menghitung persentasi keseluruhan penjualan

select
    quarter,
    sum(quantity) total_penjualan,
    sum(quantity*priceeach) revenue
from
    (
        select
            orderNumber,
            status,
            quantity,
            priceeach,
            '1' quarter
        from
            orders_1
        union
        select
            orderNumber,
            status,
            quantity,
            priceeach,
            '2' quarter
        from
            orders_2
    ) tabel_a
where
    status = "Shipped"
group by
    quarter;

/*Dari presentasi keseluruhan penjualan dan revenue quarter 1 lebih tinggi dibandingkan
quarter 2*/

-- Apakah jumlah customers xyz.com semakin bertambah?

select
    quarter,
    count(distinct customerID) total_customers
from
    (
        select
            customerID,
            createDate,
            quarter(createDate) quarter
        from
            customer
        where
            createDate between '2004-01-01'
            and '2004-06-30'
    ) as tabel_b
group by
    quarter;
    
-- jumlah customer lebih tinggi pada quarter 1 yaitu 43 sedangkan 35 customer pada quarter 2

-- Seberapa banyak customers tersebut yang sudah melakukan transaksi?

select
    quarter,
    count(distinct customerID) total_customers
from
    (
        select
            customerID,
            createDate,
            quarter(createDate) quarter
        from
            customer
        where
            createDate between '2004-01-01'
            and '2004-06-30'
    ) tabel_b
where
    customerID in (
        select
            distinct customerID
        from
            orders_1
        union
        select
            distinct customerID
        from
            orders_2
    )
group by
    quarter;
    
/* total customer yang telah bertransaksi pada quarter 1 sebanyak 25 customer sendangkan
terdapat 19 customer pada quarter 2.*/

-- Category produk apa saja yang paling banyak diorder oleh customers di quarter 2?

select
    *
from
    (
        select
            categoryID,
            count(distinct orderNumber) total_order,
            sum(quantity) total_penjualan
        from
            (
                select
                    productCode,
                    orderNumber,
                    quantity,
                    status,
                    left(productCode, 3) categoryID
                from
                    orders_2
                where
                    status = "Shipped"
            ) tabel_c
        group by
            categoryID
    ) a
order by
    total_order desc;
    
-- categoryID S18 memiliki total order dan total penjualan tertinggi pada quarter 2 

-- Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?

select
    count(distinct customerID) total_customers
from
    orders_1;

-- output = 25

select
    '1' quarter,
    (count(distinct customerID)*100)/25 q2
from
    orders_1
where
    customerID in(
        select
            distinct customerID
        from
            orders_2
    );

/* untuk mengetahui seberapa banyak customer yang aktif melakukan transaksi di quarter 1
dan quarter 2 di lakukan perhitungan retention cohort. Hasil retention cohort yang didapat
yaitu sebesar 24%.*/

/*
Kesimpulan
1. perusahaan retail B2B xyz.com mengalami penurunan performa di quarter 2.
2. ketertarikan customer untuk melakukan transaksi masih terbilang kurang.
3. retention cohort yang dimiliki yaitu sebesar 24% dimana terdapat banyak customer
   yang tidak melakukan transaksi di quarter 2 setelah bertransaksi di quarter 1.
4. nilai retention cohort yang rendah  yang dimiliki perusahaan xyz.com dapat dijadikan 
   masukan agar perusahaan retail b2b ini melakukan promosi untuk menarik customer baru atau 
   membuat customer di quarter 1 agar tetap loyal dan selalu bertransaksi di perusahaan xyz.com.
*/