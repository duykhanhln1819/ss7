### 1. KIẾN TRÚC DỮ LIỆU: DERIVED TABLE (BẢNG DẪN XUẤT)

-- * **Định nghĩa:** Derived Table là một bảng ảo được tạo ra từ kết quả của một câu lệnh `SELECT` nằm bên trong mệnh đề `FROM`. Nó chỉ tồn tại tạm thời trong phạm vi thực thi của câu lệnh SQL đó.
-- * **Tại sao bắt buộc phải có Alias (Bí danh)?**
--     * **Tính định danh:** Trong SQL, mọi bảng dữ liệu xuất hiện ở mệnh đề `FROM` đều phải có một cái tên để hệ thống có thể tham chiếu. Vì Derived Table không tồn tại vật lý trong cơ sở dữ liệu, nó cần một Alias để đóng vai trò là "tên biến" đại diện.
--     * **Tránh xung đột:** Nếu bạn thực hiện `JOIN` giữa một bảng thực và một bảng dẫn xuất, hoặc giữa hai bảng dẫn xuất, SQL engine cần Alias để biết chính xác một cột (column) đang được truy xuất từ bảng nào.
--     * **Nguyên tắc cấu trúc:** Chuẩn SQL coi kết quả của Subquery trong `FROM` là một quan hệ (relation). Một quan hệ vô danh sẽ khiến các mệnh đề bên ngoài (như `SELECT` hay `WHERE` của câu lệnh cha) không có điểm tựa để gọi tên các trường dữ liệu.

---

-- ### 2. THỰC THI (SQL FIX)

-- Để sửa lỗi này, chúng ta chỉ cần thêm từ khóa `AS` kèm theo một tên đại diện (ví dụ: `vip_students`) ngay sau dấu đóng ngoặc của Subquery.

-- Câu lệnh SQL đã sửa lỗi Syntax
SELECT 
    SUM(vip_students.total_spent) AS grand_total_vip
FROM (
    SELECT 
        student_id, 
        SUM(amount) AS total_spent
    FROM 
        Payments
    GROUP BY 
        student_id
    HAVING 
        SUM(amount) > 10000000
) AS vip_students;

/* Ghi chú: 
- 'AS vip_students' chính là Alias giúp MySQL định danh được bảng tạm này.
- 'grand_total_vip' là Alias cho cột kết quả cuối cùng để báo cáo trông chuyên nghiệp hơn.
*/