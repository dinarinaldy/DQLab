/*
Dataset berasal dari DQLab. dataset berisikan transaksi dari tahun 2009 sampai dengan 2012

Data pada order_status dibedakan menjadi 'order finished', 'order returned',
dan 'order cancelled'

Dari project ini akan dilihat overal performance dan efektifitas efesiensi promosi yang
dilakukan oleh DQLab pada tahun 2009 - 2012.
*/

-- 1A
-- Overal Performance by year

select
    year(order_date) years,
    sum(sales) sales,
    count(order_id) number_of_order
from 
    dqlab_sales_store
where
    order_status = 'order finished'
group by
    years;

/*Data yang dihasilkan menunjukkan hasil yang fluktuatif dari hasil penjualan sales
dan jumlah order yang terjadi pada setiap tahunnya. Penjualan sales tertinggi terjadi
pada tahun 2009 dan mengalami penurunan yang signifikan pada tahun 2010.
penjualan kembali meningkat pada tahun 2011 dan 2012.*/

-- 1B
-- Overall Performance by Product Sub Category

select
    year(order_date) years,
    product_sub_category,
    sum(sales) sales
from
    dqlab_sales_store
where
    order_status = 'order finished'
    and year(order_date) in ('2011','2012')
group by
    years,
    product_sub_category
order by
    years,
    sales desc;
    
/*Dari data yang dihasilkan penjualan sales terbesar pada tahun 2011 terjadi
pada penjualan Chair & Chairmats, sedangkan pada tahun 2012 yaitu office machines.*/

-- 2A
-- Promotion Effectiveness and Efficiency by Years

select 
    year(order_date) years,
    sum(sales) sales,
    sum(discount_value) promotion_values,
    round(sum(discount_value) / sum(sales) *100,2) burn_rate_percentage
from
    dqlab_sales_store
where
    order_status = 'order finished'
group by
    years;
    
/*DQLab berharap burn_rate_percentage maksimum adalah 4.5% sedangkan dari data yang
didapat hasil burn_rate_percentage pada tahun 2009 sebesar 4.65% dan terus mengalami
kenaikan sampai dengan tahun 2011 yaitu sebesar 5.22%. DQLab diharuskan melakukan efesiensi
pengeluaran keuangan pada perusahaannya untuk mencapai target burn_rate_percentage
maksimum diangka 4.5%.*/

-- 2B
-- Promotion Effectiveness and Efficiency by Product Sub Category

select
    year(order_date) years,
    product_sub_category,
    product_category,
    sum(sales) sales,
    sum(discount_value) promotion_value,
    round(sum(discount_value) / sum(sales) * 100, 2) burn_rate_percentage
from
    dqlab_sales_store
where
    order_status = 'order finished'
    and year = '2012'
group by
    years,
    product_sub_category,
    product_category
order by
    sales desc;
    
/*Dari data yang didapat burn_rate_percentage terbesar terdapat pada bookcases
sebesar 6.27% dan terkecil pada rubber bands yaitu 3.06%. Sedangkan hasil penjualan
sales terbesar terjadi pada office machines. Diharapkan DQLab dapat melakukan
strategi yang lebih baik untuk promosi ditahun berikutnya agar meningkatkan
hasil penjualan yang akan menguntungkan perusahaan.*/

-- 3A
-- Customers Transactions per Year

select
    year(order_date) years,
    count(distinct customer) number_of_customer
from
    dqlab_sales_store
where
    order_status = 'Order Finished'
group by
    years;

/*Dari data yang didapat dari tahun 2009 - 2012 DQLab memiliki jumlah customer
yang fluktuatif untuk setiap tahunnya. diharapkan DQLab mdapat melakukan strategi
marketing dan promosi yang lebih baik lagi untuk menambah jumlah customer
yang akan bertransaksi di DQLab.*/

/*
kesimpulan
1. DQLab diharapkan melakukan efesiensi pengeluaran perusahaan untuk menekan
   angka burn_rate_percentage yang terjadi setiap tahunnya.
2. DQLab diharapkan melakukan strategi yang lebih baik dan bijak untuk promosi dan 
   marketing untuk menambah jumlah customer dan penjualan sales yang
   akan menguntungkan perusahaan.
*/