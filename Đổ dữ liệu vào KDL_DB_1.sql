
CREATE DATABASE KDL_DB_1;
go
USE KDL_DB_1;
GO
-- Thêm dữ liệu vào DimThoiGian cho 5 năm gần nhất
DECLARE @NamBatDau INT;
DECLARE @NamKetThuc INT;
DECLARE @NamHienTai INT;

SET @NamHienTai = YEAR(GETDATE());
SET @NamBatDau = @NamHienTai - 4; -- Tính từ 5 năm trước, bao gồm năm hiện tại
SET @NamKetThuc = @NamHienTai;

WHILE @NamBatDau <= @NamKetThuc
BEGIN
    DECLARE @Thang INT = 1;
    WHILE @Thang <= 12
    BEGIN
        DECLARE @Quy INT = (SELECT CASE
                                        WHEN @Thang BETWEEN 1 AND 3 THEN 1
                                        WHEN @Thang BETWEEN 4 AND 6 THEN 2
                                        WHEN @Thang BETWEEN 7 AND 9 THEN 3
                                        ELSE 4
                                    END);
        -- Kiểm tra xem bản ghi đã tồn tại chưa trước khi chèn
        IF NOT EXISTS (SELECT 1 FROM DimThoiGian WHERE thang = @Thang AND quy = @Quy AND nam = @NamBatDau)
        BEGIN
            INSERT INTO DimThoiGian (maThoiGian, thang, quy, nam)
            VALUES ((SELECT ISNULL(MAX(maThoiGian), 0) + 1 FROM DimThoiGian), @Thang, @Quy, @NamBatDau);
        END;
        SET @Thang = @Thang + 1;
    END;
    SET @NamBatDau = @NamBatDau + 1;
END;
GO

-- Hàm để lấy maThoiGian
CREATE FUNCTION dbo.GetMaThoiGian (@thang INT, @quy INT, @nam INT)
RETURNS INT
AS
BEGIN
    DECLARE @maThoiGian INT;

    SELECT @maThoiGian = maThoiGian
    FROM DimThoiGian
    WHERE thang = @thang AND quy = @quy AND nam = @nam;

    RETURN ISNULL(@maThoiGian, 0);
END;
GO

-- Tạo Stored Procedure để xử lý việc tạo mới maThoiGian và chuyển dữ liệu
CREATE PROCEDURE dbo.ProcessDataFromTICHHOP
AS
BEGIN
    -- Chuyển dữ liệu từ TICHHOP_DB.dbo.VanPhongDaiDien sang KDL_DB_1.dbo.DimVanPhongDaiDien
    INSERT INTO DimVanPhongDaiDien (maThanhPho, tenThanhPho, diaChiVanPhong, bang)
    SELECT maThanhPho, tenThanhPho, diaChiVP, bang
    FROM TICHHOP_DB.dbo.VanPhongDaiDien;

    -- Chuyển dữ liệu từ TICHHOP_DB.dbo.KhachHang sang KDL_DB_1.dbo.DimKhachHang
    INSERT INTO DimKhachHang (maKhachHang, tenKhachHang, loaiKhachHang)
    SELECT
    KH.maKhachHang,
    KH.tenKhachHang,
    CASE
        WHEN EXISTS (SELECT 1 FROM TICHHOP_DB.dbo.KhachHangDuLich WHERE maKhachHang = KH.maKhachHang)
        AND EXISTS (SELECT 1 FROM TICHHOP_DB.dbo.KhachHangBuuDien WHERE maKhachHang = KH.maKhachHang)
        THEN N'Du lịch, Bưu điện'
        WHEN EXISTS (SELECT 1 FROM TICHHOP_DB.dbo.KhachHangDuLich WHERE maKhachHang = KH.maKhachHang)
        THEN N'Du lịch'
        WHEN EXISTS (SELECT 1 FROM TICHHOP_DB.dbo.KhachHangBuuDien WHERE maKhachHang = KH.maKhachHang)
        THEN N'Bưu điện'
        ELSE N'Khác'
    END AS loaiKhachHang
    FROM TICHHOP_DB.dbo.KhachHang AS KH;

    -- Chuyển dữ liệu từ TICHHOP_DB.dbo.MatHang sang KDL_DB_1.dbo.DimMatHang
    INSERT INTO DimMatHang (maMatHang, moTa, kichCo, trongLuong, gia)
    SELECT maMatHang, moTa, kichCo, trongLuong, gia
    FROM TICHHOP_DB.dbo.MatHang;

    -- Chuyển dữ liệu từ TICHHOP_DB.dbo.CuaHang sang KDL_DB_1.dbo.DimCuaHang
    INSERT INTO DimCuaHang (maCuaHang, maThanhPho, soDienThoai)
    SELECT maCuaHang, maThanhPho, soDienThoai
    FROM TICHHOP_DB.dbo.CuaHang;

    -- Chuyển dữ liệu vào FactDoanhThu
    INSERT INTO FactDoanhThu (maMatHang, maThoiGian, maKhachHang, maThanhPho, tongSoLuong, tongDoanhThu)
    SELECT
        MDD.maMatHang AS maMatHang,
        dbo.GetMaThoiGian(MONTH(DDH.ngayDat), DATEPART(QUARTER, DDH.ngayDat), YEAR(DDH.ngayDat)) AS maThoiGian,
        DDH.maKhachHang AS maKhachHang,
        KH.maThanhPho AS maThanhPho,
        SUM(MDD.soLuongDat) AS tongSoLuong,
        SUM(MDD.giaDat * MDD.soLuongDat) AS tongDoanhThu
    FROM TICHHOP_DB.dbo.MatHangDuocDat AS MDD
    JOIN TICHHOP_DB.dbo.DonDatHang AS DDH ON MDD.maDon = DDH.maDon
    JOIN TICHHOP_DB_1.dbo.KhachHang AS KH ON DDH.maKhachHang = KH.maKhachHang
    GROUP BY MDD.maMatHang, DDH.maKhachHang, KH.maThanhPho, MONTH(DDH.ngayDat), DATEPART(QUARTER, DDH.ngayDat), YEAR(DDH.ngayDat);

    -- Chuyển dữ liệu vào FactTonKho
    INSERT INTO FactTonKho (maMatHang, maCuaHang, maThoiGian, soLuongTonKho)
    SELECT
        MDL.maMatHang,
        MDL.maCuaHang,
        dbo.GetMaThoiGian(MONTH(MDL.thoiDiemCapNhat), DATEPART(QUARTER, MDL.thoiDiemCapNhat), YEAR(MDL.thoiDiemCapNhat)) AS maThoiGian,
        MDL.soLuongTrongKho
    FROM TICHHOP_DB.dbo.MatHangDuocLuuTru AS MDL;
END;
GO

-- Thực thi stored procedure
EXEC dbo.ProcessDataFromTICHHOP;
GO
