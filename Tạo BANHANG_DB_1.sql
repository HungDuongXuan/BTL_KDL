
create database BANHANG_DB_1;
go
use BANHANG_DB_1;
go 

-- Tạo bảng DonDatHang
CREATE TABLE DonDatHang (
    maDon VARCHAR(50) PRIMARY KEY,
    ngayDat DATE,
    maKhachHang VARCHAR(50) -- Khóa ngoại tham chiếu đến bảng KhachHang (nếu có)
);

-- Tạo bảng MatHang
CREATE TABLE MatHang (
    maMatHang VARCHAR(50) PRIMARY KEY,
    moTa NVARCHAR(255),
    kichCo VARCHAR(50),
    trongLuong DECIMAL(10, 2),
    gia DECIMAL(10, 2),
    soLuong INT,
	thoiGian Datetime
);

-- Tạo bảng MatHangDuocDat (bảng giao nhau giữa DonDatHang và MatHang)
CREATE TABLE MatHangDuocDat (
    maDon VARCHAR(50),
    maMatHang VARCHAR(50),
    soLuongDat INT,
    giaDat DECIMAL(10, 2),
    thoiGian DATETIME,
    PRIMARY KEY (maDon, maMatHang),
    FOREIGN KEY (maDon) REFERENCES DonDatHang(maDon),
    FOREIGN KEY (maMatHang) REFERENCES MatHang(maMatHang)
);

-- Tạo bảng VanPhongDaiDien
CREATE TABLE VanPhongDaiDien (
    maThanhPho VARCHAR(50) PRIMARY KEY,
    tenThanhPho NVARCHAR(255),
    diaChiVP NVARCHAR(255),
    bang NVARCHAR(255),
    thoiGian DATETIME
);

-- Tạo bảng CuaHang (khóa ngoại quản lý từ VanPhongDaiDien)
CREATE TABLE CuaHang (
    maCuaHang VARCHAR(50) PRIMARY KEY,
    soDienThoai VARCHAR(20),
    thoiGian DATETIME,
    maThanhPho VARCHAR(50), -- Khóa ngoại tham chiếu đến VanPhongDaiDien
    FOREIGN KEY (maThanhPho) REFERENCES VanPhongDaiDien(maThanhPho)
);

-- Tạo bảng MatHangDuocLuuTru (bảng giao nhau giữa MatHang và CuaHang)
CREATE TABLE MatHangDuocLuuTru (
    maMatHang VARCHAR(50),
    maCuaHang VARCHAR(50),
    soLuongTrongKho INT,
    thoiGian DATETIME,
    PRIMARY KEY (maMatHang, maCuaHang),
    FOREIGN KEY (maMatHang) REFERENCES MatHang(maMatHang),
    FOREIGN KEY (maCuaHang) REFERENCES CuaHang(maCuaHang)
);
