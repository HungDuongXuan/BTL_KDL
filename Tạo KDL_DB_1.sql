

-- Tạo database
CREATE DATABASE KDL_DB_1;
go


USE KDL_DB_1;
GO



-- Tạo bảng chiều thời gian
CREATE TABLE DimThoiGian (
    maThoiGian int PRIMARY KEY,
    thang INT,
    quy INT,
    nam INT
);

-- Tạo bảng chiều khách hàng
CREATE TABLE DimKhachHang (
    maKhachHang VARCHAR(50) PRIMARY KEY,
    tenKhachHang NVARCHAR(255),
    loaiKhachHang NVARCHAR(255)
);

-- Tạo bảng chiều mặt hàng
CREATE TABLE DimMatHang (
    maMatHang VARCHAR(50) PRIMARY KEY,
    moTa NVARCHAR(255),
    kichCo NVARCHAR(255),
    trongLuong FLOAT,
    gia FLOAT
);


-- Tạo bảng Văn Phòng Đại Diện
CREATE TABLE DimVanPhongDaiDien (
    maThanhPho VARCHAR(50) PRIMARY KEY,
    tenThanhPho NVARCHAR(255),
    diaChiVanPhong NVARCHAR(255),
    bang NVARCHAR(255)
);

-- Tạo bảng chiều cửa hàng
CREATE TABLE DimCuaHang (
    maCuaHang VARCHAR(50) PRIMARY KEY,
    maThanhPho VARCHAR(50),
    soDienThoai VARCHAR(20),
    FOREIGN KEY (maThanhPho) REFERENCES DimVanPhongDaiDien(maThanhPho)
    --Không có quan hệ ràng buộc với bảng VanPhongDaiDien
);



-- Tạo bảng fact doanh thu
CREATE TABLE FactDoanhThu (
    maMatHang VARCHAR(50),
    maThoiGian int,
    maKhachHang VARCHAR(50),
    maThanhPho VARCHAR(50),
    tongSoLuong FLOAT,
    tongDoanhThu FLOAT,
    PRIMARY KEY (maMatHang, maThoiGian, maKhachHang, maThanhPho),
    FOREIGN KEY (maMatHang) REFERENCES DimMatHang(maMatHang),
    FOREIGN KEY (maThoiGian) REFERENCES DimThoiGian(maThoiGian),
    FOREIGN KEY (maKhachHang) REFERENCES DimKhachHang(maKhachHang),
    FOREIGN KEY (maThanhPho) REFERENCES DimVanPhongDaiDien(maThanhPho)
);

-- Tạo bảng fact tồn kho
CREATE TABLE FactTonKho (
    maMatHang VARCHAR(50),
    maCuaHang VARCHAR(50),
    maThoiGian int,
    soLuongTonKho FLOAT,
    PRIMARY KEY (maMatHang, maCuaHang, maThoiGian),
    FOREIGN KEY (maMatHang) REFERENCES DimMatHang(maMatHang),
    FOREIGN KEY (maCuaHang) REFERENCES DimCuaHang(maCuaHang),
    FOREIGN KEY (maThoiGian) REFERENCES DimThoiGian(maThoiGian)
);
