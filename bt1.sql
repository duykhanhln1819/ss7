### 1. PHÂN TÍCH LỖI (BẢN CHẤT TOÁN HỌC)

-- *Bản chất toán tử `= `:** Trong SQL, toán tử `=` là một toán tử so sánh **vô hướng (scalar)**. Nó yêu cầu cả hai vế (trái và phải) phải là các giá trị đơn nhất. 
--     * Về mặt tập hợp: Toán tử `=` thực hiện phép so sánh $a = b$ khi $b$ là một phần tử duy nhất.
-- * **Nguyên nhân gây sập hệ thống:** * Khi ông A chỉ có 1 khóa học, Subquery trả về một tập hợp chỉ có 1 giá trị (ví dụ: $\{200\}$). Phép so sánh `price = 200` hoàn toàn hợp lệ.
--     * Khi ông A mở thêm khóa học với các mức giá khác nhau, Subquery trả về một **tập hợp nhiều giá trị** (ví dụ: $\{200, 300, 500\}$). 
--     * Lúc này, câu lệnh trở thành `price = {200, 300, 500}`. Về mặt logic toán học, một giá trị đơn (scalar) không thể so sánh "bằng" với một tập hợp (set) bằng toán tử vô hướng. Hệ thống sẽ báo lỗi: *"Subquery returns more than 1 row"* vì nó không biết phải so sánh giá trị `price` bên ngoài với giá trị nào trong tập hợp đó.

-- ---

### 2. THỰC THI (SQL FIX)

-- Để giải quyết vấn đề này, chúng ta cần thay thế toán tử so sánh vô hướng `=` bằng toán tử tập hợp `IN`. Toán tử `IN` cho phép kiểm tra xem một giá trị có nằm trong một danh sách/tập hợp các giá trị hay không.

-- Cách viết tối ưu để xử lý đa giá trị từ Subquery
SELECT 
    title, 
    price
FROM 
    Courses
WHERE 
    price IN (
        SELECT DISTINCT price 
        FROM Courses 
        WHERE instructor_id = 5
    );

/* Giải thích: 
- Sử dụng IN thay vì = để chấp nhận đầu ra là một danh sách.
- Thêm DISTINCT trong Subquery để loại bỏ các mức giá trùng lặp (giúp tối ưu hiệu năng).
- Dù ông A có 1 hay 100 khóa học với các mức giá khác nhau, câu lệnh vẫn hoạt động chính xác.
*/