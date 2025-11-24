-- Drop existing view if exists
DROP VIEW IF EXISTS pending_changes_view;

-- Create comprehensive pending_changes_view with all required columns
CREATE VIEW pending_changes_view AS
SELECT 
    o.order_id AS change_id,
    o.user_id AS teacher_id,
    u.fullname AS teacher_name,
    u.email AS teacher_email,
    'order' AS change_type,
    oi.course_id AS target_id,
    CONCAT('Order for course: ', c.course_name, ', Amount: ', o.total_amount, 'đ, Payment: ', COALESCE(o.payment_method, 'N/A')) AS change_data,
    o.status,
    o.created_at,
    NULL AS reviewed_at,
    NULL AS reviewed_by,
    NULL AS reviewer_name,
    o.order_note AS review_note
FROM orders o
LEFT JOIN users u ON o.user_id = u.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN courses c ON oi.course_id = c.course_id;

-- Verify view
SELECT * FROM pending_changes_view LIMIT 5;
