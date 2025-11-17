<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userFullname = (String) session.getAttribute("userFullname");
    String orderId = request.getParameter("orderId");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công - PTIT LEARNING</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        body {
            background: #f5f5f5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .success-main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        
        .success-container {
            max-width: 600px;
            width: 100%;
            padding: 50px 40px;
            text-align: center;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        
        .success-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 25px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 50px;
            color: white;
            animation: scaleIn 0.5s ease-out;
        }
        
        @keyframes scaleIn {
            from {
                transform: scale(0);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        .success-title {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
        }
        
        .success-message {
            font-size: 16px;
            color: #6c757d;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .order-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 25px;
            border-radius: 12px;
            margin: 30px 0;
            border: 1px solid #dee2e6;
        }
        
        .order-info p {
            margin: 12px 0;
            font-size: 15px;
            color: #495057;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .order-info strong {
            color: #2c3e50;
            font-weight: 600;
        }
        
        .order-status {
            color: #28a745 !important;
            font-weight: 600;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 35px;
            flex-wrap: wrap;
        }
        
        .btn-primary, .btn-secondary {
            padding: 14px 32px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }
        
        .btn-secondary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        footer {
            background: #2c3e50;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: auto;
        }
        
        @media (max-width: 640px) {
            .success-container {
                padding: 40px 25px;
            }
            
            .success-title {
                font-size: 26px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-primary, .btn-secondary {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/includes/header.jsp" %>

    <!-- Success Content -->
    <main class="success-main">
        <div class="success-container">
            <div class="success-icon">✓</div>
            <h1 class="success-title">Thanh toán thành công!</h1>
            <p class="success-message">
                Cảm ơn bạn đã mua khóa học tại PTIT LEARNING.<br>
                Đơn hàng của bạn đã được xử lý thành công.
            </p>
            
            <div class="order-info">
                <p><strong>Mã đơn hàng:</strong> <span>#<%= orderId %></span></p>
                <p><strong>Trạng thái:</strong> <span class="order-status">Hoàn thành</span></p>
                <p><strong>Email:</strong> <span><%= userEmail %></span></p>
            </div>
            
            <p class="success-message">
                Bạn có thể bắt đầu học ngay bây giờ!
            </p>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/account" class="btn-primary">
                    📚 Xem khóa học của tôi
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn-secondary">
                    🛒 Tiếp tục mua sắm
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer>
        <p>&copy; 2024 PTIT LEARNING. All rights reserved.</p>
    </footer>
</body>
</html>
