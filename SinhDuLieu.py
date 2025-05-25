# Mô tả: Tạo dữ liệu giả cho các cơ sở dữ liệu VANPHONGDAIDIEN_DB và BANHANG_DB.
# Sinh dữ liệu giả và tạo các câu lệnh SQL INSERT cho các cơ sở dữ liệu nguồn VANPHONGDAIDIEN_DB và BANHANG_DB.

import uuid
from faker import Faker
import random
from datetime import datetime, timedelta

# Khởi tạo Faker với locale tiếng Việt
fake = Faker('vi_VN')

# --- Cấu hình ---
# Định nghĩa các biến cấu hình để kiểm soát số lượng dữ liệu được tạo ra.
NUM_RECORDS = 100000
NUM_CITIES = 50
NUM_STORES_PER_CITY = 5
NUM_PRODUCTS = 1000
NUM_CUSTOMERS = 10000
NUM_ORDERS = 50000
MAX_ITEMS_PER_ORDER = 5

# --- Lưu trữ dữ liệu tạm thời ---
# Khai báo các list để lưu trữ dữ liệu giả trước khi tạo các câu lệnh SQL INSERT.
cities_data = []
stores_data = []
products_data = []
customers_data = []
orders_data = []
order_items_data = []
store_inventory_data = []

# --- Sinh dữ liệu ---
# Phần này chứa logic để tạo dữ liệu giả cho các bảng khác nhau trong cơ sở dữ liệu.
# Dữ liệu được tạo ra dựa trên các biến cấu hình và sử dụng thư viện Faker.

# 1. VanPhongDaiDien (cho BANHANG_DB)
# Tạo dữ liệu cho bảng VanPhongDaiDien trong cơ sở dữ liệu BANHANG_DB.
print("Đang sinh dữ liệu cho VanPhongDaiDien (dành cho BANHANG_DB)...")
vanphongdaidien_banhang_data = []
for i in range(NUM_CITIES):
    city_id = f"TP{i+1:03d}"
    city_name = fake.city()
    address = fake.street_address()
    state = fake.state()
    timestamp = (datetime.now() - timedelta(days=random.randint(2000, 2200))).date()
    vanphongdaidien_banhang_data.append((city_id, city_name, address, state, timestamp))

# 2. KhachHang (cho VANPHONGDAIDIEN_DB)
# Tạo dữ liệu cho bảng KhachHang trong cơ sở dữ liệu VANPHONGDAIDIEN_DB.
print("Đang sinh dữ liệu cho KhachHang (dành cho VANPHONGDAIDIEN_DB)...")
khachhang_vanphong_data = []
city_ids_banhang = [city[0] for city in vanphongdaidien_banhang_data]
for i in range(NUM_CUSTOMERS):
    customer_id = f"KH{i+1:05d}"
    customer_name = fake.name()
    assigned_city_id = random.choice(city_ids_banhang)
    first_order_date = fake.date_between(start_date='-5y', end_date='today')
    khachhang_vanphong_data.append((customer_id, customer_name, assigned_city_id, first_order_date))

# 3. KhachHangBuuDien (cho VANPHONGDAIDIEN_DB)
# Tạo dữ liệu cho bảng KhachHangBuuDien trong cơ sở dữ liệu VANPHONGDAIDIEN_DB.
print("Đang sinh dữ liệu cho KhachHangBuuDien...")
khachhangbuudien_vanphong_data = []
buudien_customers_vanphong = random.sample(khachhang_vanphong_data, k=min(int(NUM_CUSTOMERS * 0.3), NUM_CUSTOMERS))
for customer in buudien_customers_vanphong:
    customer_id = customer[0]
    address = fake.street_address() + ", " + fake.city()
    timestamp = (datetime.now() - timedelta(days=random.randint(10, 2000))).date()
    khachhangbuudien_vanphong_data.append((customer_id, address, timestamp))

# 4. KhachHangDuLich (cho VANPHONGDAIDIEN_DB)
# Tạo dữ liệu cho bảng KhachHangDuLich trong cơ sở dữ liệu VANPHONGDAIDIEN_DB.
print("Đang sinh dữ liệu cho KhachHangDuLich...")
khachhangdulich_vanphong_data = []
dulich_customers_vanphong = random.sample(khachhang_vanphong_data, k=min(int(NUM_CUSTOMERS * 0.2), len(khachhang_vanphong_data)*0.8))
for customer in dulich_customers_vanphong:
    customer_id = customer[0]
    tour_guide = fake.name()
    timestamp = (datetime.now() - timedelta(days=random.randint(10, 2000))).date()
    khachhangdulich_vanphong_data.append((customer_id, tour_guide, timestamp))

# 5. CuaHang (cho BANHANG_DB)
# Tạo dữ liệu cho bảng CuaHang trong cơ sở dữ liệu BANHANG_DB.
print("Đang sinh dữ liệu cho CuaHang (dành cho BANHANG_DB)...")
cuahang_banhang_data = []
for city_id, _, _, _, _ in vanphongdaidien_banhang_data:
    for i in range(NUM_STORES_PER_CITY):
        store_id = f"CH{city_id[2:]}{i+1:02d}"
        phone = fake.phone_number()
        timestamp = (datetime.now() - timedelta(days=random.randint(2000, 2200))).date()
        cuahang_banhang_data.append((store_id, phone, timestamp, city_id))

# 6. MatHang (cho BANHANG_DB)
# Tạo dữ liệu cho bảng MatHang trong cơ sở dữ liệu BANHANG_DB.
print("Đang sinh dữ liệu cho MatHang (dành cho BANHANG_DB)...")
mathang_banhang_data = []
for i in range(NUM_PRODUCTS):
    product_id = f"MH{i+1:05d}"
    description = fake.word().capitalize() + " " + fake.bs()
    size = random.choice(['Lon', 'Vua', 'Nho'])
    weight = round(random.uniform(0.1, 10.0), 2)
    price = round(random.uniform(10000, 500000), 2)
    stock_quantity = random.randint(0, 1000)
    timestamp = (datetime.now() - timedelta(days=random.randint(10, 2000)))
    mathang_banhang_data.append((product_id, description, size, weight, price, stock_quantity))

# 7. DonDatHang (cho BANHANG_DB)
# Tạo dữ liệu cho bảng DonDatHang trong cơ sở dữ liệu BANHANG_DB.
print("Đang sinh dữ liệu cho DonDatHang (dành cho BANHANG_DB)...")
dondathang_banhang_data = []
customer_ids_vanphong = [c[0] for c in khachhang_vanphong_data]
for i in range(NUM_ORDERS):
    order_id = f"DH{i+1:06d}"
    order_date = fake.date_between(start_date='-5y', end_date='today')
    customer_id = random.choice(customer_ids_vanphong)
    dondathang_banhang_data.append((order_id, order_date, customer_id))

# 8. MatHangDuocDat (cho BANHANG_DB)
# Tạo dữ liệu cho bảng MatHangDuocDat trong cơ sở dữ liệu BANHANG_DB.
print("Đang sinh dữ liệu cho MatHangDuocDat (dành cho BANHANG_DB)...")
mathangduocdat_banhang_data = []
product_ids_banhang = [p[0] for p in mathang_banhang_data]
for order_id, _, _ in dondathang_banhang_data:
    num_items = random.randint(1, MAX_ITEMS_PER_ORDER)
    selected_products = random.sample(product_ids_banhang, k=min(num_items, len(product_ids_banhang)))
    for product_id in selected_products:
        quantity = random.randint(1, 10)
        product_price = next(p[4] for p in mathang_banhang_data if p[0] == product_id)
        item_price = product_price
        timestamp = order_date
        mathangduocdat_banhang_data.append((order_id, product_id, quantity, item_price, timestamp))

# 9. MatHangDuocLuuTru (cho BANHANG_DB)
# Tạo dữ liệu cho bảng MatHangDuocLuuTru trong cơ sở dữ liệu BANHANG_DB.
print("Đang sinh dữ liệu cho MatHangDuocLuuTru (dành cho BANHANG_DB)...")
mathangduocluutru_banhang_data = []
store_ids_banhang = [s[0] for s in cuahang_banhang_data]
for store_id in store_ids_banhang:
    num_products_in_store = random.randint(50, 200)
    stocked_products = random.sample(product_ids_banhang, k=min(num_products_in_store, len(product_ids_banhang)))
    for product_id in stocked_products:
        stock_quantity = random.randint(10, 500)
        timestamp = datetime.now() - timedelta(days=random.randint(0, 30))
        mathangduocluutru_banhang_data.append((product_id, store_id, stock_quantity, timestamp))

# --- Sinh các câu lệnh SQL INSERT ---
# Hàm này sinh ra các câu lệnh SQL INSERT để chèn dữ liệu vào các bảng tương ứng.
def generate_insert_sql(table_name, columns, data):
    sql_statements = []
    column_names = ", ".join(columns)
    for row in data:
        formatted_values = []
        for value in row:
            if isinstance(value, str):
                escaped_value = value.replace("'", "''")
                formatted_values.append(f"N'{escaped_value}'")
            elif isinstance(value, datetime):
                formatted_values.append(f"'{value.strftime('%Y-%m-%d %H:%M:%S')}'")
            elif isinstance(value, (int, float, complex)):
                formatted_values.append(str(value))
            elif value is None:
                formatted_values.append("NULL")
            else:
                formatted_values.append(f"'{value}'")
        values = ", ".join(formatted_values)
        sql_statements.append(f"INSERT INTO {table_name} ({column_names}) VALUES ({values});")
    return sql_statements

print("\nĐang sinh các câu lệnh SQL INSERT...")

# Sinh các câu lệnh INSERT cho VANPHONGDAIDIEN_DB
vanphongdaidien_db_inserts = []
vanphongdaidien_db_inserts.extend(generate_insert_sql("KhachHang", ["maKhachHang", "tenKhachHang", "maThanhPho", "ngayDatHangDauTien"], khachhang_vanphong_data))
vanphongdaidien_db_inserts.extend(generate_insert_sql("KhachHangBuuDien", ["maKhachHang", "diaChiBuuDien", "thoiGian"], khachhangbuudien_vanphong_data))
vanphongdaidien_db_inserts.extend(generate_insert_sql("KhachHangDuLich", ["maKhachHang", "huongDanVienDuLich", "thoiGian"], khachhangdulich_vanphong_data))

# Sinh các câu lệnh INSERT cho BANHANG_DB
banhang_db_inserts = []
banhang_db_inserts.extend(generate_insert_sql("VanPhongDaiDien", ["maThanhPho", "tenThanhPho", "diaChiVP", "bang", "thoiGian"], vanphongdaidien_banhang_data))
banhang_db_inserts.extend(generate_insert_sql("CuaHang", ["maCuaHang", "soDienThoai", "thoiGian", "maThanhPho"], cuahang_banhang_data))
banhang_db_inserts.extend(generate_insert_sql("MatHang", ["maMatHang", "moTa", "kichCo", "trongLuong", "gia", "soLuong", "thoiGian"], mathang_banhang_data))
banhang_db_inserts.extend(generate_insert_sql("DonDatHang", ["maDon", "ngayDat", "maKhachHang"], dondathang_banhang_data))
banhang_db_inserts.extend(generate_insert_sql("MatHangDuocDat", ["maDon", "maMatHang", "soLuongDat", "giaDat", "thoiGian"], mathangduocdat_banhang_data))
banhang_db_inserts.extend(generate_insert_sql("MatHangDuocLuuTru", ["maMatHang", "maCuaHang", "soLuongTrongKho", "thoiGian"], mathangduocluutru_banhang_data))

# --- Xuất các câu lệnh SQL ra file ---
# Ghi các câu lệnh SQL INSERT vào các file .sql để có thể thực thi trên database server.
print("Đang ghi các câu lệnh SQL INSERT ra file...")

with open("vanphongdaidien_db_inserts.sql", "w", encoding="utf-8") as f:
    f.write("USE VANPHONGDAIDIEN_DB_1;\nGO\n\n")
    for statement in vanphongdaidien_db_inserts:
        f.write(statement + "\n")

with open("banhang_db_inserts.sql", "w", encoding="utf-8") as f:
    f.write("USE BANHANG_DB_1;\nGO\n\n")
    for statement in banhang_db_inserts:
        f.write(statement + "\n")

print("Hoàn thành sinh dữ liệu. Các file SQL đã được tạo: vanphongdaidien_db_inserts.sql, banhang_db_inserts.sql")
print(f"Đã sinh {len(khachhang_vanphong_data)} bản ghi cho KhachHang.")
print(f"Đã sinh {len(vanphongdaidien_banhang_data)} bản ghi cho VanPhongDaiDien.")
print(f"Đã sinh {len(cuahang_banhang_data)} bản ghi cho CuaHang.")
print(f"Đã sinh {len(mathang_banhang_data)} bản ghi cho MatHang.")
print(f"Đã sinh {len(dondathang_banhang_data)} bản ghi cho DonDatHang.")
print(f"Đã sinh {len(mathangduocdat_banhang_data)} bản ghi cho MatHangDuocDat.")
print(f"Đã sinh {len(mathangduocluutru_banhang_data)} bản ghi cho MatHangDuocLuuTru.")
