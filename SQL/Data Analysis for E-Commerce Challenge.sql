/*
The dataset used is data from the DQLab Store which is an e-commerse where users can be
both buyer and seller. So, users can buy goods from other users who sell.
*/

/*
There are 4 tables used in this dataset
1. users table, consists of user_id, nama_user, kodepos and email.
2. products table, consists of product_id, desc_product, category and base_price.
3. orders table, consists of order_id, seller_id, buyer_id, kodepos, subtotal, discount, total,
   created_at, paid_at and delivery_at.
4. order_details table, consists of order_detail, order_id, product_id, price and quantity.   
*/

-- 1. The 10 highest transactions of users 12476
select
    seller_id,
    buyer_id, total nilai_transaksi,
    created_at tanggal_transaksi
from
    orders
where 
    buyer_id = 12476
order by 
    3 desc
limit 10;

-- 2. Transactions per month in 2020
select 
    EXTRACT(year_month from created_at) tahun_bulan,
    count(1) jumlah_transaksi,
    sum(total) total_nilai_transaksi
from 
    orders
where 
    created_at>='2020-01-01'
group by 1
order by 1;

-- 3. Buyer with the highest average transaction in January 2020
select
    buyer_id,
    count(1) jumlah_transaksi,
    avg(total) avg_nilai_transaksi
from 
    orders
where 
    created_at between '2020-01-01' and '2020-02-01'
group by 1
having
    count(1)>= 2 
order by 3 desc
limit 10;

-- 4. Big transaction in December 2019
select
    nama_user nama_pembeli,
    total nilai_transaksi,
    created_at tanggal_transaksi
from
    orders
    inner join users on buyer_id = user_id
where
    created_at between '2019-12-01' and '2020-01-01'
    and total >= 20000000
order by 1;

-- 5. Best seller product category in 2020
select
    category,
    sum(quantity) total_quantity,
    sum(price) total_price
from
    orders
    inner join order_details using(order_id)
    inner join products using(product_id)
where
    created_at>='2020-01-01'
    and delivery_at IS NOT NULL
group by 1
order by 2 desc
limit 5;

-- 6. Buyer with high value
select
    nama_user nama_pembeli,
    count(1) jumlah_transaksi,
    sum(total) total_nilai_transaksi,
    min(total) min_nilai_transaksi
from 
    orders
    inner join users on buyer_id = user_id
group by
    user_id,
    nama_user
having
    count(1)> 5
    and min(total) > 2000000
order by 3 desc;

-- 7. Dropshipper
select
    nama_user nama_pembeli,
    count(1) jumlah_transaksi,
    count(distinct orders.kodepos) distinct_kodepos,
    sum(total) total_nilai_transaksi,
    avg(total) avg_nilai_transaksi
from 
    orders
    inner join users on buyer_id = user_id
group by 
    user_id,
    nama_user
having 
    count(1) >= 10
    and count(1) = count(distinct orders.kodepos)
order by 2 desc;

-- 8. Offline reseller
select
    nama_user nama_pembeli,
    count(1) jumlah_transaksi,
    sum(total) total_nilai_transaksi,
    avg(total) avg_nilai_transaksi,
    avg(total_quantity) avg_quantity_per_transaksi
from
    orders
    inner join users on buyer_id = user_id
    inner join (
        select
            order_id,
            sum(quantity) total_quantity
        from
            order_details
        group by 1
    ) summary_order using(order_id)
where
    orders.kodepos = users.kodepos
group by
    user_id,
    nama_user
having
    count(1) >= 8
    and avg(total_quantity) > 10
order by 3 desc;

-- 9. Users who are buyer and seller at once
select
    nama_user nama_pengguna,
    jumlah_transaksi_beli,
    jumlah_transaksi_jual
from
    users
    inner join (
        select
            buyer_id,
            count(1) jumlah_transaksi_beli
        from
            orders
        group by 1
    ) buyer on buyer_id = user_id
    inner join (
        select
            seller_id,
            count(1) jumlah_transaksi_jual
        from
            orders
        group by
            1
    ) seller on seller_id = user_id
where
    jumlah_transaksi_beli >= 7
order by 1;

-- 10. Transaction time
select
    EXTRACT(year_month from created_at) tahun_bulan,
    count(1) jumlah_transaksi,
    avg(DATEDIFF(paid_at, created_at)) avg_lama_dibayar,
    min(DATEDIFF(paid_at, created_at)) min_lama_dibayar,
    max(DATEDIFF(paid_at, created_at)) max_lama_dibayar
from
    orders
where
    paid_at IS NOT NULL
group by 1
order by 1;
