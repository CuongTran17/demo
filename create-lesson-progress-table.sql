-- Tạo bảng lesson_progress để track tiến độ từng bài học theo user
CREATE TABLE IF NOT EXISTS lesson_progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id VARCHAR(100) NOT NULL,
    lesson_id VARCHAR(100) NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    completed_at DATETIME,
    UNIQUE KEY unique_progress (user_id, course_id, lesson_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Xóa tất cả tiến độ học tập hiện tại
DELETE FROM lesson_progress;

-- Reset tiến độ course về 0%
UPDATE course_progress SET progress_percentage = 0, total_hours = 0, status = 'not_started';
