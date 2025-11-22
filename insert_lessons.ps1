# Insert correct Vietnamese lessons for finance-basic
$mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
$password = "123456789"

$lessons = @(
    "Lộ trình xây dựng kiến thức tài chính",
    "Bài 1: Các thuật ngữ tài chính cơ bản cần biết",
    "Bài 2: Hiểu về thị trường tài chính",
    "Bài 3: Bản chất của tích lũy tiền bạc",
    "Bài 4: Tích lũy tiền như thế nào để đạt được hiệu quả nhất?",
    "Bài 5: Đầu tư từ A đến Z",
    "Bài 6: Phân biệt cổ phiếu và trái phiếu",
    "Bài 7: Nên vắng lý thuyết rồi mới đầu tư hay vừa học lý thuyết vừa đầu tư",
    "Bài 8: Thế nào là tiêu dùng đúng đắn?",
    "Bài 9: Phát triển các cấp độ tài chính để trở thành nhà đầu tư chuyên nghiệp",
    "Bài 10: 5 bí kíp quản lý tài chính sẽ thay đổi cuộc sống của bạn",
    "Bài 11: 5 kênh đầu tư tài chính bạn nên thử một lần trong đời",
    "Bài 12: Cách lập kế hoạch tài chính cá nhân từ con số 0 đến tự do tài chính"
)

$contents = @(
    "Nội dung bài học về lộ trình xây dựng kiến thức tài chính cơ bản",
    "Giới thiệu các thuật ngữ tài chính cơ bản mà mọi người cần nắm vững",
    "Khái niệm và cách thức hoạt động của thị trường tài chính",
    "Tìm hiểu về việc tích lũy tài sản và quản lý tiền bạc hiệu quả",
    "Các phương pháp và chiến lược tích lũy tiền hiệu quả",
    "Hướng dẫn cơ bản về đầu tư tài chính từ khái niệm đến thực hành",
    "Sự khác nhau giữa cổ phiếu và trái phiếu, ưu nhược điểm của từng loại",
    "Thảo luận về phương pháp học và thực hành đầu tư hiệu quả",
    "Nguyên tắc tiêu dùng hợp lý và quản lý chi tiêu cá nhân",
    "Hướng dẫn phát triển kỹ năng đầu tư từ cơ bản đến chuyên nghiệp",
    "5 bí quyết quản lý tài chính hiệu quả thay đổi cuộc sống",
    "Giới thiệu 5 kênh đầu tư tài chính phổ biến và hiệu quả",
    "Hướng dẫn lập kế hoạch tài chính cá nhân toàn diện"
)

for ($i = 0; $i -lt $lessons.Length; $i++) {
    $order = $i + 1
    $title = $lessons[$i]
    $content = $contents[$i]
    $query = "INSERT INTO lessons (course_id, section_id, lesson_title, lesson_content, video_url, duration, lesson_order, is_active) VALUES ('finance-basic', 1, '$title', '$content', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', '10:30', $order, true);"
    & $mysqlPath --default-character-set=utf8mb4 -u root "-p$password" -e "USE ptit_learning; $query"
}