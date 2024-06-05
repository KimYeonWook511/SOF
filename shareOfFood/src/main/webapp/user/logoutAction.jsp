<%@ page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 로그아웃 처리</title>
</head>
<body>
	<%
		if (session.getAttribute("userID") == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('현재 로그인 상태가 아닙니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
		else
		{
			PrintWriter script = response.getWriter();
			session.invalidate(); // 세션 종료	
			script.println("<script>");
			script.println("alert('로그아웃 되었습니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
	%>
</body>
</html>