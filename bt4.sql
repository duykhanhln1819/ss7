
-- Bản chất: Toán tử = là toán tử so sánh đơn trị. Nó bắt buộc vế sau (Subquery) chỉ được trả về đúng 1 con số.

-- Nguyên nhân sập: Khi ông A có nhiều khóa học với nhiều mức giá khác nhau, Subquery trả về một tập hợp (nhiều dòng). Toán tử = không thể xử lý tập hợp nên báo lỗi.

SELECT title, price
FROM Courses
WHERE price IN (
    SELECT price 
    FROM Courses 
    WHERE instructor_id = 5
);