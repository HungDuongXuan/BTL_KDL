


USE TICHHOP_DB_1;
go
-- Chuyển dữ liệu từ VANPHONGDAIDIEN_DB_1.dbo.VanPhongDaiDien
INSERT INTO VanPhongDaiDien (maThanhPho, tenThanhPho, diaChiVP, bang, ngayThanhLap)
SELECT maThanhPho, tenThanhPho, diaChiVP, bang, CONVERT(DATE, thoiGian)
FROM BANHANG_DB_1.dbo.VanPhongDaiDien;

-- Chuyển dữ liệu từ VANPHONGDAIDIEN_DB_1.dbo.KhachHang
INSERT INTO KhachHang (maKhachHang, tenKhachHang, maThanhPho, ngayDatHangDauTien)
SELECT maKhachHang, tenKhachHang, maThanhPho, ngayDatHangDauTien
FROM VANPHONGDAIDIEN_DB_1.dbo.KhachHang;

-- Chuyển dữ liệu từ VANPHONGDAIDIEN_DB_1.dbo.KhachHangBuuDien
INSERT INTO KhachHangBuuDien (maKhachHang, diaChiBuuien, ngayMoTaiKhoan)
SELECT maKhachHang, diaChiBuuDien, CONVERT(DATE, thoiGian)
FROM VANPHONGDAIDIEN_DB_1.dbo.KhachHangBuuDien;

-- Chuyển dữ liệu từ VANPHONGDAIDIEN_DB_1.dbo.KhachHangDuLich
INSERT INTO KhachHangDuLich (maKhachHang, huongDanVienDuLich, thoiDiemDuLich)
SELECT maKhachHang, huongDanVienDuLich, CONVERT(DATE, thoiGian)
FROM VANPHONGDAIDIEN_DB_1.dbo.KhachHangDuLich;

-- Chuyển dữ liệu từ BANHANG_DB_1.dbo.CuaHang
INSERT INTO CuaHang (maCuaHang, maThanhPho, soDienThoai, ngayMoCuaHang)
SELECT maCuaHang, maThanhPho, soDienThoai, CONVERT(DATE, thoiGian)
FROM BANHANG_DB_1.dbo.CuaHang;

-- Chuyển dữ liệu từ BANHANG_DB_1.dbo.MatHang
INSERT INTO MatHang (maMatHang, moTa, kichCo, trongLuong, gia, ngayThemMatHang)
SELECT maMatHang, moTa, kichCo, trongLuong, gia, CONVERT(DATE, thoiGian)
FROM BANHANG_DB_1.dbo.MatHang;

-- Chuyển dữ liệu từ BANHANG_DB_1.dbo.MatHangDuocLuuTru
INSERT INTO MatHangDuocLuuTru (maCuaHang, maMatHang, soLuongTrongKho, thoiDiemCapNhat)
SELECT maCuaHang, maMatHang, soLuongTrongKho, thoiGian
FROM BANHANG_DB_1.dbo.MatHangDuocLuuTru;

-- Chuyển dữ liệu từ BANHANG_DB_1.dbo.DonDatHang
INSERT INTO DonDatHang (maDon, ngayDat, maKhachHang)
SELECT maDon, ngayDat, maKhachHang
FROM BANHANG_DB_1.dbo.DonDatHang;

-- Chuyển dữ liệu từ BANHANG_DB_1.dbo.MatHangDuocDat
INSERT INTO MatHangDuocDat (maDon, maMatHang, soLuongDat, giaDat)
SELECT maDon, maMatHang, soLuongDat, giaDat
FROM BANHANG_DB_1.dbo.MatHangDuocDat;

