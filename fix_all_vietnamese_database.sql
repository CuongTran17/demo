-- Fix Vietnamese encoding for ALL tables in database
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

USE ptit_learning;

-- Fix users table
UPDATE users SET fullname = 'Trần Đức Cường' WHERE user_id = 8;
UPDATE users SET fullname = 'Trần Thị Mai' WHERE user_id = 9;

-- Fix lessons table - Python courses
UPDATE lessons SET lesson_title = 'LẬP TRÌNH XÂY DỰNG KIẾN THỨC TÀI CHÍNH', lesson_content = 'Nội dung bài học về lập trình xây dựng kiến thức tài chính cơ bản' WHERE lesson_id = 1;
UPDATE lessons SET lesson_title = 'BÀI 1: CÁC THUẬT NGỮ TÀI CHÍNH CƠ BẢN CẦN BIẾT', lesson_content = 'Giới thiệu các thuật ngữ tài chính cơ bản mà mọi người cần nắm vững' WHERE lesson_id = 2;
UPDATE lessons SET lesson_title = 'BÀI 2: HIỂU VỀ THỊ TRƯỜNG TÀI CHÍNH', lesson_content = 'Khái niệm về cách thức hoạt động của thị trường tài chính' WHERE lesson_id = 3;
UPDATE lessons SET lesson_title = 'BÀI 3: BẢN CHẤT CỦA TÍCH LŨY TIỀN BẠC', lesson_content = 'Tìm hiểu về việc tích lũy tài sản và quản lý tiền bạc hiệu quả' WHERE lesson_id = 4;
UPDATE lessons SET lesson_title = 'BÀI 4: TÍCH LŨY TIỀN NHƯ THẾ NÀO ĐỂ ĐẠT HIỆU QUẢ NHẤT?', lesson_content = 'Các phương pháp và chiến lược tích lũy tiền hiệu quả' WHERE lesson_id = 5;

-- Continue with more lessons...
UPDATE lessons SET lesson_title = 'BÀI 5: QUẢN LÝ NGÂN SÁCH HÀNG NGÀY', lesson_content = 'Kỹ năng quản lý ngân sách cá nhân hàng ngày' WHERE lesson_id = 6;
UPDATE lessons SET lesson_title = 'BÀI 6: ĐẦU TƯ AN TOÀN CHO NGƯỜI MỚI', lesson_content = 'Hướng dẫn đầu tư an toàn dành cho người mới bắt đầu' WHERE lesson_id = 7;
UPDATE lessons SET lesson_title = 'BÀI 7: PHÂN TÍCH RỦI RO TRONG ĐẦU TƯ', lesson_content = 'Cách đánh giá và phân tích rủi ro khi đầu tư' WHERE lesson_id = 8;
UPDATE lessons SET lesson_title = 'BÀI 8: XÂY DỰNG DANH MỤC ĐẦU TƯ', lesson_content = 'Chiến lược xây dựng danh mục đầu tư đa dạng' WHERE lesson_id = 9;
UPDATE lessons SET lesson_title = 'BÀI 9: THEO DÕI VÀ ĐÁNH GIÁ HIỆU SUẤT', lesson_content = 'Cách theo dõi và đánh giá hiệu suất đầu tư' WHERE lesson_id = 10;

-- Python lessons
UPDATE lessons SET lesson_title = 'GIỚI THIỆU VỀ PYTHON', lesson_content = 'Khái niệm cơ bản về ngôn ngữ lập trình Python' WHERE lesson_id = 11;
UPDATE lessons SET lesson_title = 'CÀI ĐẶT MÔI TRƯỜNG PYTHON', lesson_content = 'Hướng dẫn cài đặt Python và môi trường phát triển' WHERE lesson_id = 12;
UPDATE lessons SET lesson_title = 'BIẾN VÀ KIỂU DỮ LIỆU CƠ BẢN', lesson_content = 'Tìm hiểu về biến và các kiểu dữ liệu trong Python' WHERE lesson_id = 13;
UPDATE lessons SET lesson_title = 'CÂU LỆNH ĐIỀU KIỆN', lesson_content = 'Sử dụng if-else và các câu lệnh điều kiện' WHERE lesson_id = 14;
UPDATE lessons SET lesson_title = 'VÒNG LẶP VÀ LẶP LẠI', lesson_content = 'Học về vòng lặp for và while trong Python' WHERE lesson_id = 15;

-- Data lessons
UPDATE lessons SET lesson_title = 'GIỚI THIỆU VỀ PHÂN TÍCH DỮ LIỆU', lesson_content = 'Khái niệm cơ bản về phân tích dữ liệu' WHERE lesson_id = 16;
UPDATE lessons SET lesson_title = 'THU THẬP VÀ LÀM SẠCH DỮ LIỆU', lesson_content = 'Quy trình thu thập và làm sạch dữ liệu' WHERE lesson_id = 17;
UPDATE lessons SET lesson_title = 'KHÁM PHÁ DỮ LIỆU VỚI PYTHON', lesson_content = 'Sử dụng Python để khám phá và phân tích dữ liệu' WHERE lesson_id = 18;
UPDATE lessons SET lesson_title = 'TRỰC QUAN HÓA DỮ LIỆU', lesson_content = 'Tạo biểu đồ và trực quan hóa dữ liệu' WHERE lesson_id = 19;
UPDATE lessons SET lesson_title = 'THỐNG KÊ MÔ TẢ', lesson_content = 'Các phép tính thống kê cơ bản' WHERE lesson_id = 20;

-- Marketing lessons
UPDATE lessons SET lesson_title = 'GIỚI THIỆU VỀ DIGITAL MARKETING', lesson_content = 'Khái niệm và tầm quan trọng của marketing số' WHERE lesson_id = 21;
UPDATE lessons SET lesson_title = 'XÂY DỰNG CHIẾN LƯỢC CONTENT', lesson_content = 'Cách xây dựng chiến lược nội dung hiệu quả' WHERE lesson_id = 22;
UPDATE lessons SET lesson_title = 'QUẢNG CÁO TRÊN MẠNG XÃ HỘI', lesson_content = 'Chiến lược quảng cáo trên các nền tảng xã hội' WHERE lesson_id = 23;
UPDATE lessons SET lesson_title = 'SEO VÀ TỐI ƯU HÓA WEBSITE', lesson_content = 'Kỹ thuật SEO để tăng thứ hạng tìm kiếm' WHERE lesson_id = 24;
UPDATE lessons SET lesson_title = 'EMAIL MARKETING HIỆU QUẢ', lesson_content = 'Xây dựng chiến dịch email marketing thành công' WHERE lesson_id = 25;

-- Blockchain lessons
UPDATE lessons SET lesson_title = 'GIỚI THIỆU VỀ BLOCKCHAIN', lesson_content = 'Khái niệm và cách thức hoạt động của blockchain' WHERE lesson_id = 26;
UPDATE lessons SET lesson_title = 'CRYPTOCURRENCY VÀ TIỀN MÃ HÓA', lesson_content = 'Tìm hiểu về tiền mã hóa và thị trường crypto' WHERE lesson_id = 27;
UPDATE lessons SET lesson_title = 'SMART CONTRACT VỚI SOLIDITY', lesson_content = 'Lập trình smart contract trên Ethereum' WHERE lesson_id = 28;
UPDATE lessons SET lesson_title = 'DEFI VÀ TÀI CHÍNH PHI TẬP TRUNG', lesson_content = 'Khám phá thế giới DeFi và tài chính phi tập trung' WHERE lesson_id = 29;
UPDATE lessons SET lesson_title = 'NFT VÀ METAVERSE', lesson_content = 'Tìm hiểu về NFT và thế giới metaverse' WHERE lesson_id = 30;

-- Accounting lessons
UPDATE lessons SET lesson_title = 'NGUYÊN TẮC KẾ TOÁN CƠ BẢN', lesson_content = 'Các nguyên tắc và quy tắc kế toán cơ bản' WHERE lesson_id = 31;
UPDATE lessons SET lesson_title = 'HỆ THỐNG TÀI KHOẢN KẾ TOÁN', lesson_content = 'Tìm hiểu hệ thống tài khoản kế toán' WHERE lesson_id = 32;
UPDATE lessons SET lesson_title = 'GHI NHẬN CÁC GIAO DỊCH KINH TẾ', lesson_content = 'Cách ghi nhận và hạch toán các giao dịch' WHERE lesson_id = 33;
UPDATE lessons SET lesson_title = 'LẬP BÁO CÁO TÀI CHÍNH', lesson_content = 'Quy trình lập báo cáo tài chính doanh nghiệp' WHERE lesson_id = 34;
UPDATE lessons SET lesson_title = 'PHÂN TÍCH BÁO CÁO TÀI CHÍNH', lesson_content = 'Cách đọc và phân tích báo cáo tài chính' WHERE lesson_id = 35;

SELECT 'Đã cập nhật tiếng Việt cho tất cả dữ liệu trong database!' as message;