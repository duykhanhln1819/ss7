-- ### 1. KHÁM NGHIỆM TỬ THI: CÁI BẪY LOGIC CỦA "NOT IN" VỚI NULL

-- * **Bản chất Boolean Logic:** Trong SQL, các phép so sánh với `NULL` không bao giờ trả về `TRUE` hoặc `FALSE`, mà trả về giá trị thứ ba gọi là **UNKNOWN**.
-- * **Phân tích biểu thức:** * Câu lệnh `id NOT IN (1, 2, NULL)` thực chất được SQL hiểu là: 
--         `NOT (id = 1 OR id = 2 OR id = NULL)`
--     * Theo quy tắc toán học SQL: `id = NULL` luôn là **UNKNOWN**.
--     * Do đó, toàn bộ biểu thức trở thành: `NOT (TRUE/FALSE OR UNKNOWN)`.
--     * Trong bảng chân trị (Three-valued logic), `NOT (UNKNOWN)` vẫn là **UNKNOWN**.
-- * **Kết quả:** Vì mệnh đề `WHERE` chỉ lọc những dòng có kết quả là `TRUE`, nên khi gặp giá trị `UNKNOWN`, MySQL sẽ loại bỏ dòng đó. Khi Subquery chứa dù chỉ một giá trị `NULL`, toàn bộ phép so sánh `NOT IN` sẽ trả về `UNKNOWN` cho mọi dòng, dẫn đến kết quả trả về rỗng (0 dòng).

-- ---

-- ### 2. GIẢI PHÁP KIẾN TRÚC

-- Để "sống sót" qua các đợt rác dữ liệu `NULL` mà vẫn muốn dùng `NOT IN`, bạn phải vá thêm mệnh đề **`IS NOT NULL`** vào ngay bên trong Subquery để lọc sạch giá trị rác trước khi đưa ra bảng ngoài so sánh.

-- ---

-- ### 3. THỰC THI (SQL FIX)

-- Tôi cung cấp cho bạn 2 phương án. Phương án dùng `NOT EXISTS` luôn được khuyến nghị vì độ an toàn tuyệt đối trước dữ liệu `NULL`.

-- CÁCH 1: Vá lỗi cho NOT IN (Thêm điều kiện lọc NULL)
SELECT * FROM Courses
WHERE id NOT IN (
    SELECT course_id 
    FROM Enrollments 
    WHERE course_id IS NOT NULL
);

-- CÁCH 2: Dùng NOT EXISTS (An toàn nhất, không sợ NULL, hiệu năng cao)
SELECT c.*
FROM Courses AS c
WHERE NOT EXISTS (
    SELECT 1 
    FROM Enrollments AS e 
    WHERE e.course_id = c.id
);

/* Lưu ý: Cách 2 (NOT EXISTS) là giải pháp triệt để nhất vì nó sử dụng 
Two-valued logic (chỉ quan tâm Tồn tại hay Không tồn tại), 
loại bỏ hoàn toàn rủi ro từ giá trị NULL.
*/