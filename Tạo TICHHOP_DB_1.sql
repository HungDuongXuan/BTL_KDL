
create database TICHHOP_DB_1;
go
use TICHHOP_DB_1;
go


-- Tạo bảng Văn Phòng Đại Diện
CREATE TABLE VanPhongDaiDien (
    maThanhPho VARCHAR(50) PRIMARY KEY,
    tenThanhPho NVARCHAR(255),
    diaChiVP NVARCHAR(255),
    bang NVARCHAR(255),
    ngayThanhLap DATE
);

-- Tạo bảng Khách Hàng


-- Tạo bảng Cửa Hàng
CREATE TABLE CuaHang (
    maCuaHang VARCHAR(50) PRIMARY KEY,
    maThanhPho VARCHAR(50),
    soDienThoai VARCHAR(20),
    ngayMoCuaHang DATE,
    FOREIGN KEY (maThanhPho) REFERENCES VanPhongDaiDien(maThanhPho)
);

-- Tạo bảng Mặt Hàng
CREATE TABLE MatHang (
    maMatHang VARCHAR(50) PRIMARY KEY,
    moTa NVARCHAR(255),
    kichCo VARCHAR(50),
    trongLuong DECIMAL(10, 2),
    gia DECIMAL(10, 2),
    ngayThemMatHang DATE
);

-- Tạo bảng Mặt Hàng Lưu Trữ (bảng giao nhau giữa Cửa Hàng và Mặt Hàng)
CREATE TABLE MatHangDuocLuuTru (
    maCuaHang VARCHAR(50),
    maMatHang VARCHAR(50),
    soLuongTrongKho INT,
    thoiDiemCapNhat DATETIME,
    PRIMARY KEY (maCuaHang, maMatHang),
    FOREIGN KEY (maCuaHang) REFERENCES CuaHang(maCuaHang),
    FOREIGN KEY (maMatHang) REFERENCES MatHang(maMatHang)
);





CREATE TABLE KhachHang (
    maKhachHang VARCHAR(50) PRIMARY KEY,
	maThanhPho VARCHAR(50),
    tenKhachHang NVARCHAR(255),
    ngayDatHangDauTien DATE,
    FOREIGN KEY (maThanhPho) REFERENCES VanPhongDaiDien(maThanhPho)
);



-- Tạo bảng Khách Hàng Du Lịch
CREATE TABLE KhachHangDuLich (
    maKhachHang VARCHAR(50) PRIMARY KEY,
    huongDanVienDuLich NVARCHAR(255),
    thoiDiemDuLich DATE,
    FOREIGN KEY (maKhachHang) REFERENCES KhachHang(maKhachHang)
);

-- Tạo bảng Khách Hàng Bưu Điện
CREATE TABLE KhachHangBuuDien (
    maKhachHang VARCHAR(50) PRIMARY KEY,
    diaChiBuuien NVARCHAR(255),
    ngayMoTaiKhoan DATE,
    FOREIGN KEY (maKhachHang) REFERENCES KhachHang(maKhachHang)
);


-- Tạo bảng Đơn Đặt Hàng
CREATE TABLE DonDatHang (
    maDon VARCHAR(50) PRIMARY KEY,
    ngayDat DATE,
    maKhachHang VARCHAR(50),
    FOREIGN KEY (maKhachHang) REFERENCES KhachHang(maKhachHang)
);

-- Tạo bảng Mặt Hàng Được Đặt (bảng giao nhau giữa Đơn Đặt Hàng và Mặt Hàng)
CREATE TABLE MatHangDuocDat (
    maDon VARCHAR(50),
    maMatHang VARCHAR(50),
    soLuongDat INT,
    giaDat DECIMAL(10, 2),
    PRIMARY KEY (maDon, maMatHang),
    FOREIGN KEY (maDon) REFERENCES DonDatHang(maDon),
    FOREIGN KEY (maMatHang) REFERENCES MatHang(maMatHang)
);

