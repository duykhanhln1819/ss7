### 1. BẢO VỆ QUAN ĐIỂM: TẠI SAO NOT EXISTS CHIẾN THẮNG?

-- Dưới góc độ Tech Lead xử lý Big Data (5 triệu users), việc chọn `NOT EXISTS` của bạn B là quyết định tối ưu vì những lý do sau:

-- * **Cơ chế Short-circuit (Dừng sớm):** * `EXISTS` hoạt động theo nguyên lý logic: Nó không quan tâm có bao nhiêu dòng khớp, nó chỉ quan tâm "có ít nhất một dòng tồn tại hay không". 
--     * Ngay khi tìm thấy **dòng đầu tiên** thỏa mãn điều kiện trong Subquery, nó sẽ lập tức trả về `TRUE` và dừng quét các dòng còn lại của user đó. Điều này tiết kiệm tài nguyên CPU và I/O cực lớn khi bảng `Payments` có hàng triệu bản ghi.
-- * **Vấn đề của NOT IN (Vùng nguy hiểm):**
--     * `NOT IN` sẽ quét toàn bộ danh sách ID từ Subquery và nạp vào bộ nhớ (hoặc file tạm) để so sánh. Với 5 triệu users, danh sách này có thể gây tràn bộ nhớ.
--     * **Rủi ro NULL:** Nếu trong bảng `Payments` có bất kỳ dòng nào có `student_id` là `NULL`, toán tử `NOT IN` sẽ trả về kết quả rỗng (không có data) cho toàn bộ câu truy vấn do cơ chế so sánh 3 trị (Three-valued logic) của SQL. `NOT EXISTS` không bị ảnh hưởng bởi lỗi logic này.
-- * **Hiệu năng:** `NOT EXISTS` kết hợp với Index trên cột `student_id` của bảng `Payments` sẽ biến phép kiểm tra thành một thao tác Index Seek cực nhanh thay vì phải quét toàn bảng (Full Table Scan).

-- ---

### 2. THỰC THI (SQL VỚI CORRELATED SUBQUERY)

-- Đây là câu lệnh tối ưu nhất để lấy danh sách Email học viên "ngủ đông" trong năm 2024:


SELECT 
    s.email
FROM 
    Students AS s
WHERE NOT EXISTS (
    -- Truy vấn lồng tương quan (Correlated Subquery)
    SELECT 1 
    FROM Payments AS p 
    WHERE p.student_id = s.id 
      AND p.payment_date >= '2024-01-01' 
      AND p.payment_date <= '2024-12-31'
);

-- /* Giải thích kỹ thuật:
-- 1. Alias 's' và 'p' giúp truy vấn tường minh.
-- 2. SELECT 1: Được dùng vì EXISTS chỉ kiểm tra sự tồn tại, không cần lấy dữ liệu cột cụ thể, giúp tối ưu nhẹ.
-- 3. Mối tương quan 'p.student_id = s.id' đảm bảo hệ thống quét từng user và dừng sớm ngay khi thấy 1 giao dịch trong năm 2024.
-- */