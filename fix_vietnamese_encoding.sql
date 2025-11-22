-- Fix Vietnamese encoding for finance-basic lessons
SET NAMES utf8mb4;
USE ptit_learning;

INSERT INTO lessons (course_id, section_id, lesson_title, lesson_content, video_url, duration, lesson_order, is_active) VALUES
('finance-basic', 1, 'Lộ trình xây dựng kiến thức tài chính', 'Nội dung bài học về lộ trình xây dựng kiến thức tài chính cơ bản', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '10:30', 1, true),
('finance-basic', 1, 'Bài 1: Các thuật ngữ tài chính cơ bản cần biết', 'Giới thiệu các thuật ngữ tài chính cơ bản mà mọi người cần nắm vững', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '15:20', 2, true),
('finance-basic', 1, 'Bài 2: Hiểu về thị trường tài chính', 'Khái niệm và cách thức hoạt động của thị trường tài chính', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '12:45', 3, true),
('finance-basic', 1, 'Bài 3: Bản chất của tích lũy tiền bạc', 'Tìm hiểu về việc tích lũy tài sản và quản lý tiền bạc hiệu quả', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '18:30', 4, true),
('finance-basic', 1, 'Bài 4: Tích lũy tiền như thế nào để đạt được hiệu quả nhất?', 'Các phương pháp và chiến lược tích lũy tiền hiệu quả', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '20:15', 5, true),
('finance-basic', 1, 'Bài 5: Đầu tư từ A đến Z', 'Hướng dẫn cơ bản về đầu tư tài chính từ khái niệm đến thực hành', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '25:00', 6, true),
('finance-basic', 1, 'Bài 6: Phân biệt cổ phiếu và trái phiếu', 'Sự khác nhau giữa cổ phiếu và trái phiếu, ưu nhược điểm của từng loại', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '16:40', 7, true),
('finance-basic', 1, 'Bài 7: Nên vắng lý thuyết rồi mới đầu tư hay vừa học lý thuyết vừa đầu tư', 'Thảo luận về phương pháp học và thực hành đầu tư hiệu quả', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '14:25', 8, true),
('finance-basic', 1, 'Bài 8: Thế nào là tiêu dùng đúng đắn?', 'Nguyên tắc tiêu dùng hợp lý và quản lý chi tiêu cá nhân', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '13:50', 9, true),
('finance-basic', 1, 'Bài 9: Phát triển các cấp độ tài chính để trở thành nhà đầu tư chuyên nghiệp', 'Hướng dẫn phát triển kỹ năng đầu tư từ cơ bản đến chuyên nghiệp', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '22:10', 10, true),
('finance-basic', 1, 'Bài 10: 5 bí kíp quản lý tài chính sẽ thay đổi cuộc sống của bạn', '5 bí quyết quản lý tài chính hiệu quả thay đổi cuộc sống', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '19:35', 11, true),
('finance-basic', 1, 'Bài 11: 5 kênh đầu tư tài chính bạn nên thử một lần trong đời', 'Giới thiệu 5 kênh đầu tư tài chính phổ biến và hiệu quả', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '21:55', 12, true),
('finance-basic', 1, 'Bài 12: Cách lập kế hoạch tài chính cá nhân từ con số 0 đến tự do tài chính', 'Hướng dẫn lập kế hoạch tài chính cá nhân toàn diện', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '28:20', 13, true);