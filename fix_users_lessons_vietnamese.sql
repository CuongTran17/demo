-- Fix Vietnamese for users and lessons
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

USE ptit_learning;

-- Fix users
UPDATE users SET fullname = 'Trần Đức Cường' WHERE user_id = 8;
UPDATE users SET fullname = 'Trần Thị Mai' WHERE user_id = 9;

-- Fix lessons
UPDATE lessons SET lesson_title = 'LẬP TRÌNH XÂY DỰNG KIẾN THỨC TÀI CHÍNH', lesson_content = 'Nội dung bài học về lập trình xây dựng kiến thức tài chính cơ bản' WHERE lesson_id = 1;
UPDATE lessons SET lesson_title = 'BÀI 1: CÁC THUẬT NGỮ TÀI CHÍNH CƠ BẢN CẦN BIẾT', lesson_content = 'Giới thiệu các thuật ngữ tài chính cơ bản mà mọi người cần nắm vững' WHERE lesson_id = 2;
UPDATE lessons SET lesson_title = 'BÀI 2: HIỂU VỀ THỊ TRƯỜNG TÀI CHÍNH', lesson_content = 'Khái niệm về cách thức hoạt động của thị trường tài chính' WHERE lesson_id = 3;
UPDATE lessons SET lesson_title = 'BÀI 3: BẢN CHẤT CỦA TÍCH LŨY TIỀN BẠC', lesson_content = 'Tìm hiểu về việc tích lũy tài sản và quản lý tiền bạc hiệu quả' WHERE lesson_id = 4;
UPDATE lessons SET lesson_title = 'BÀI 4: TÍCH LŨY TIỀN NHƯ THẾ NÀO ĐỂ ĐẠT HIỆU QUẢ NHẤT?', lesson_content = 'Các phương pháp và chiến lược tích lũy tiền hiệu quả' WHERE lesson_id = 5;
UPDATE lessons SET lesson_title = 'BÀI 5: QUẢN LÝ NGÂN SÁCH HÀNG NGÀY', lesson_content = 'Kỹ năng quản lý ngân sách cá nhân hàng ngày' WHERE lesson_id = 6;
UPDATE lessons SET lesson_title = 'BÀI 6: ĐẦU TƯ AN TOÀN CHO NGƯỜI MỚI', lesson_content = 'Hướng dẫn đầu tư an toàn dành cho người mới bắt đầu' WHERE lesson_id = 7;
UPDATE lessons SET lesson_title = 'BÀI 7: PHÂN TÍCH RỦI RO TRONG ĐẦU TƯ', lesson_content = 'Cách đánh giá và phân tích rủi ro khi đầu tư' WHERE lesson_id = 8;
UPDATE lessons SET lesson_title = 'BÀI 8: XÂY DỰNG DANH MỤC ĐẦU TƯ', lesson_content = 'Chiến lược xây dựng danh mục đầu tư đa dạng' WHERE lesson_id = 9;
UPDATE lessons SET lesson_title = 'BÀI 9: THEO DÕI VÀ ĐÁNH GIÁ HIỆU SUẤT', lesson_content = 'Cách theo dõi và đánh giá hiệu suất đầu tư' WHERE lesson_id = 10;
UPDATE lessons SET lesson_title = 'GIỚI THIỆU VỀ PYTHON', lesson_content = 'Khái niệm cơ bản về ngôn ngữ lập trình Python' WHERE lesson_id = 11;
UPDATE lessons SET lesson_title = 'CÀI ĐẶT MÔI TRƯỜNG PYTHON', lesson_content = 'Hướng dẫn cài đặt Python và môi trường phát triển' WHERE lesson_id = 12;
UPDATE lessons SET lesson_title = 'BIẾN VÀ KIỂU DỮ LIỆU CƠ BẢN', lesson_content = 'Tìm hiểu về biến và các kiểu dữ liệu trong Python' WHERE lesson_id = 13;

SELECT 'HOÀN THÀNH SỬA USERS VÀ LESSONS!' as status;