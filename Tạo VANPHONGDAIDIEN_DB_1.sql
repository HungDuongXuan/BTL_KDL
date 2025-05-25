create database VANPHONGDAIDIEN_DB_1;
go
USE VANPHONGDAIDIEN_DB_1;
go

-- Bảng KhachHang (thuộc tính chung)
CREATE TABLE KhachHang (
    maKhachHang VARCHAR(50) PRIMARY KEY,
    tenKhachHang NVARCHAR(255) NOT NULL,
    maThanhPho VARCHAR(50),
    ngayDatHangDauTien DATE
);

-- Bảng KhachHangBuuDien (thuộc tính riêng của khách hàng bưu điện)
CREATE TABLE KhachHangBuuDien (
    maKhachHang VARCHAR(50) PRIMARY KEY,
    diaChiBuuDien NVARCHAR(255) NOT NULL,
    thoiGian DATETIME,
    FOREIGN KEY (maKhachHang) REFERENCES KhachHang(maKhachHang)
);

-- Bảng KhachHangDuLich (thuộc tính riêng của khách hàng du lịch)
CREATE TABLE KhachHangDuLich (
    maKhachHang VARCHAR(50) PRIMARY KEY,
    huongDanVienDuLich NVARCHAR(255) NOT NULL,
    thoiGian DATETIME,
    FOREIGN KEY (maKhachHang) REFERENCES KhachHang(maKhachHang)
);
