CREATE DATABASE QLBH
USE QLBH
/* I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language) */

/*Tạo bảng khách hàng */
CREATE TABLE KHACHHANG
(
	MAKH char(4) CONSTRAINT PK_KH PRIMARY KEY,
	HOTEN varchar(40),
	DCHI varchar(50),
	SODT varchar(20),
	NGSINH smalldatetime,
	DOANHSO money,
	NGDK smalldatetime
)

/* Tạo bảng nhân viên */
CREATE TABLE NHANVIEN
(
	MANV char(4) CONSTRAINT PK_NV PRIMARY KEY,
	HOTEN varchar(40),
	NGVL smalldatetime,
	SODT varchar(20)
)

/* Tạo bảng sản phẩm */
CREATE TABLE SANPHAM
(
	MASP char(4) CONSTRAINT PK_SP PRIMARY KEY,
	TENSP varchar(40),
	DVT varchar(20),
	NUOCSX varchar(40),
	GIA money
)

/* Tạo bảng hóa đơn */
CREATE TABLE HOADON
(
	SOHD int CONSTRAINT PK_HD PRIMARY KEY,
	NGHD smalldatetime,
	MAKH char(4) CONSTRAINT FK_HD_KH FOREIGN KEY REFERENCES KHACHHANG(MAKH),  /* Khóa ngoại*/
	MANV char(4) CONSTRAINT FK_HD_NV FOREIGN KEY REFERENCES NHANVIEN(MANV),   /* Khóa ngoại*/
	TRIGIA money
)

--Dữ liệu đã được insert đầy đủ
/* III. Ngôn ngữ truy dữ liệu */

/*1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất*/
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

/*2. 2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen” */
SELECT MASP, TENSP
FROM SANPHAM
WHERE DVT IN('cay', 'quyen')

/*3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”*/
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE ('B_01')

/*4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000*/
SELECT MASP, TENSP
FROM SANPHAM
WHERE (NUOCSX = 'Trung Quoc') AND (GIA BETWEEN 30000 AND 40000)

/*5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ
30.000 đến 40.000 */
SELECT MASP, TENSP, NUOCSX
FROM SANPHAM
WHERE (NUOCSX IN('Trung Quoc', 'Thai Lan')) AND (GIA BETWEEN 30000 AND 40000)

/*6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007*/
SET DATEFORMAT DMY

SELECT SOHD,TRIGIA
FROM HOADON
WHERE NGHD IN('1/1/2007', '2/1/2007')

/*7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần)*/
SELECT SOHD, TRIGIA
FROM HOADON
WHERE MONTH(NGHD) = 1 AND YEAR(NGHD) = 2007
ORDER BY NGHD ASC, TRIGIA DESC

/*8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007*/
SELECT KH.MAKH, HOTEN
FROM KHACHHANG KH, HOADON HD
WHERE (KH.MAKH = HD.MAKH) 
	  AND NGHD = '1/1/2007'

/*9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006*/
SELECT SOHD, TRIGIA
FROM HOADON HD, NHANVIEN NV
WHERE (HD.MANV = NV.MANV) 
	  AND (HOTEN = 'Nguyen Van B') AND (NGHD = '28/10/2006')

/*10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006*/
SELECT SP.MASP,TENSP
FROM HOADON HD, KHACHHANG KH, CTHD, SANPHAM SP
WHERE (HD.MAKH = KH.MAKH) AND (CTHD.SOHD = HD.SOHD) AND (CTHD.MASP = SP.MASP)
	  AND (HOTEN = 'Nguyen Van A') AND (MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006)

/*11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”*/
SELECT DISTINCT SOHD
FROM CTHD
WHERE (MASP = 'BB01') OR (MASP = 'BB02')

/*12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số
lượng từ 10 đến 20*/
SELECT SOHD
FROM CTHD
WHERE CTHD.MASP = 'BB01' AND (SL BETWEEN 10 AND 20)
UNION
SELECT SOHD
FROM CTHD
WHERE CTHD.MASP = 'BB02' AND (SL BETWEEN 10 AND 20)

/*13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với
số lượng từ 10 đến 20*/
SELECT SOHD
FROM CTHD
WHERE CTHD.MASP = 'BB01' AND (SL BETWEEN 10 AND 20)
INTERSECT
SELECT SOHD
FROM CTHD
WHERE CTHD.MASP = 'BB02' AND (SL BETWEEN 10 AND 20)

/*14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được
bán ra trong ngày 1/1/2007*/
SELECT DISTINCT SP.MASP, TENSP
FROM (HOADON HD JOIN CTHD ON HD.SOHD = CTHD.SOHD) 
	 RIGHT JOIN SANPHAM SP ON CTHD.MASP = SP.MASP
WHERE ((NUOCSX = 'Trung Quoc' OR NGHD = '1/1/2007'))

/*15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được*/
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT
SELECT SP.MASP, TENSP
FROM SANPHAM SP, CTHD
WHERE CTHD.MASP = SP.MASP

/*16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006*/
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT
SELECT SP.MASP,TENSP
FROM SANPHAM SP, CTHD, HOADON HD
WHERE (CTHD.MASP = SP.MASP) AND (HD.SOHD = CTHD.SOHD) AND (YEAR(NGHD) = 2006)

/*17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006*/
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
EXCEPT
SELECT SP.MASP, TENSP
FROM SANPHAM SP, CTHD, HOADON HD
WHERE (CTHD.MASP = SP.MASP) AND (HD.SOHD = CTHD.SOHD) AND (YEAR(NGHD)=2006) AND (NUOCSX = 'Trung Quoc')

/*18. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất*/
SELECT SOHD
FROM HOADON HD
WHERE (YEAR(NGHD) = 2006 AND NOT EXISTS
							(SELECT *
							 FROM SANPHAM
							 WHERE NUOCSX = 'Singapore' AND MASP NOT IN									
																(SELECT MASP
																FROM CTHD 
																WHERE SOHD = HD.SOHD)))

/*19. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?*/
SELECT COUNT(*) AS NOTTV
FROM HOADON
WHERE MAKH IS NULL

/*20. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006*/
SELECT  COUNT(DISTINCT(MASP)) 
FROM HOADON HD JOIN CTHD ON HD.SOHD = CTHD.SOHD
WHERE YEAR(NGHD) = 2006

/*21. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?*/
SELECT MAX(TRIGIA) AS 'Trị giá cao nhất', MIN(TRIGIA) AS 'Trị giá thấp nhất'
FROM HOADON

/*22. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?*/
SELECT AVG(TRIGIA) 'Trị giá trung bình năm 2006'	
FROM HOADON
WHERE YEAR(NGHD) = 2006

/*23. Tính doanh thu bán hàng trong năm 2006*/
SELECT SUM(TRIGIA) AS 'Doanh thu bán hàng năm 2006'
FROM HOADON
WHERE YEAR(NGHD) = 2006

/*24. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.*/
SELECT SOHD
FROM HOADON HD1
WHERE HD1.TRIGIA >= ALL(SELECT HD2.TRIGIA
					   FROM HOADON HD2
					   WHERE YEAR(HD2.NGHD) = 2006) AND YEAR(HD1.NGHD) = 2006

/*25. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006*/
SELECT HOTEN
FROM KHACHHANG KH JOIN HOADON HD ON KH.MAKH = HD.MAKH
WHERE SOHD = (SELECT SOHD
			  FROM HOADON H1
			  WHERE H1.TRIGIA >= ALL(SELECT H2.TRIGIA
									 FROM HOADON H2
									 WHERE YEAR(H2.NGHD) = 2006) AND YEAR(H1.NGHD) = 2006)

/*26. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất*/ 
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC

/*27. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất*/
SELECT MASP,TENSP
FROM SANPHAM
WHERE GIA IN(SELECT GIA
			 FROM SANPHAM
			 WHERE GIA = ANY(SELECT DISTINCT TOP 3 GIA
							 FROM SANPHAM
							 ORDER BY GIA DESC))

/*28. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức
giá cao nhất (của tất cả các sản phẩm)*/
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN(SELECT GIA
			 FROM SANPHAM
			 WHERE GIA = ANY(SELECT DISTINCT TOP 3 GIA
							 FROM SANPHAM
							 ORDER BY GIA DESC)) AND NUOCSX = 'Thai Lan'

/*29. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức
giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất)*/
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN(SELECT GIA
			 FROM SANPHAM
			 WHERE GIA = ANY(SELECT DISTINCT TOP 3 GIA
							 FROM SANPHAM
							 WHERE NUOCSX='Trung Quoc'
							 ORDER BY GIA DESC )) 
				   AND NUOCSX ='Trung Quoc'

/*30 * In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).*/
SELECT TOP 3 MAKH, HOTEN, RANK() OVER(ORDER BY DOANHSO DESC) AS 'Xếp hạng'
FROM KHACHHANG

/*31. Tính tổng số sản phẩm do “Trung Quoc” sản xuất*/
SELECT COUNT(MASP) 'Tổng sản phẩm Trung Quốc sản xuất'
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

/*32. Tính tổng số sản phẩm của từng nước sản xuất.*/
SELECT NUOCSX, COUNT(MASP) 'Tổng sản phẩm'
FROM SANPHAM
GROUP BY NUOCSX

/*33. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm*/
SELECT NUOCSX, MAX(GIA) AS 'Giá lớn nhất', MIN(GIA) AS 'Giá nhỏ nhất', AVG(GIA) AS 'Trung bình giá'
FROM SANPHAM
GROUP BY NUOCSX

/*34. Tính doanh thu bán hàng mỗi ngày*/
SELECT NGHD AS 'Ngày bán', SUM(TRIGIA) AS 'Doanh thu'
FROM HOADON
GROUP BY NGHD

/*35. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006*/
SELECT MASP, SUM(SL) 'Tổng số lượng sản phẩm'
FROM HOADON HD JOIN CTHD ON HD.SOHD = CTHD.SOHD
WHERE MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006
GROUP BY MASP

/*36. Tính doanh thu bán hàng của từng tháng trong năm 2006*/
SELECT MONTH(NGHD) AS 'Tháng', SUM(TRIGIA) AS 'Doanh thu'
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)

/*37. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau*/
SELECT SOHD, COUNT(DISTINCT MASP) AS 'Số sản phẩm'
FROM CTHD
GROUP BY SOHD
HAVING COUNT(DISTINCT MASP) >= 4

/*38. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau)*/
SELECT SOHD, COUNT(DISTINCT CTHD.MASP) AS 'Số sản phẩm'
FROM CTHD JOIN SANPHAM SP ON CTHD.MASP = SP.MASP
WHERE NUOCSX = 'Viet Nam'
GROUP BY SOHD
HAVING COUNT(DISTINCT CTHD.MASP) > = 3

/*39. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất*/
SELECT  DISTINCT HOTEN 'Họ và tên', COUNT(SOHD) AS 'Số lần mua'
FROM KHACHHANG KH JOIN HOADON ON KH.MAKH = HOADON.MAKH
GROUP BY HOTEN
HAVING COUNT(SOHD) >= ALL(SELECT  DISTINCT COUNT(SOHD) AS HOADONKH
					      FROM KHACHHANG KH JOIN HOADON HD ON KH.MAKH = HD.MAKH
						  GROUP BY HOTEN)

/*40. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất?*/
SELECT MONTH(NGHD) AS 'Tháng', SUM(TRIGIA) AS 'Doanh thu'
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
HAVING SUM(TRIGIA) >=ALL (SELECT SUM(TRIGIA) AS DOANHTHU
						  FROM HOADON
						  WHERE YEAR(NGHD) = 2006
						  GROUP BY MONTH(NGHD))

/*41. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.*/
SELECT SP.MASP, TENSP, SUM(SL) AS TONGSL
FROM (HOADON HD JOIN CTHD ON CTHD.SOHD = HD.SOHD) JOIN SANPHAM SP ON CTHD.MASP = SP.MASP
WHERE YEAR(NGHD)=2006
GROUP BY SP.MASP, TENSP
HAVING SUM(SL)<=ALL(SELECT SUM(SL)
					FROM CTHD JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
					WHERE YEAR(NGHD) =2006
					GROUP BY MASP)

/*42. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất*/
SELECT MASP, TENSP
FROM SANPHAM S1
WHERE GIA IN (SELECT MAX(GIA)
			  FROM SANPHAM S2
			  WHERE S2.NUOCSX = S1.NUOCSX)
GROUP BY NUOCSX, MASP, TENSP, GIA

/*43. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau*/ 
SELECT NUOCSX, COUNT(DISTINCT GIA) 'Số sản phẩm có giá khác nhau'
FROM SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3

/*44. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất*/
SELECT HOADON.MAKH, HOTEN, COUNT(SOHD) AS SOHD
FROM (SELECT TOP 10 DOANHSO, MAKH, HOTEN
	  FROM KHACHHANG
	  ORDER BY DOANHSO DESC) AS TOP10, HOADON
	  WHERE TOP10.MAKH = HOADON.MAKH
	  GROUP BY HOADON.MAKH,HOTEN
	  HAVING COUNT(SOHD) >= ALL(SELECT COUNT(SOHD)
								FROM (SELECT TOP 10 DOANHSO, MAKH,HOTEN
									  FROM KHACHHANG
									  ORDER BY DOANHSO DESC) AS TOP10, HOADON
									  WHERE TOP10.MAKH = HOADON.MAKH
									  GROUP BY HOADON.MAKH)



