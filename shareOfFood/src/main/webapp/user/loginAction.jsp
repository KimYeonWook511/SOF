<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("utf-8"); %>
<!-- scope="page" : 현재의 페이지 안에서만 빈즈 사용 가능 -->
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="userID"/>
<jsp:setProperty name="user" property="userPassword"/>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 로그인 처리</title>
</head>
<body>
	<%	
		if (session.getAttribute("userID") != null) // 세션이 존재할 때 (userID값을 확인)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인 중입니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
		
		UserDAO userDAO = new UserDAO();
		
		// getter를 이용하여 userID와 userPassword를 가져와 매개변수로 삽입
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		
		if (result == 1) // 로그인 성공
		{
			session.setAttribute("userID", user.getUserID());
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
		else if (result == 0) // 비밀번호 불일치
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')");
			script.println("history.back()"); // 이전 페이지로 사용자 돌려보내기
			script.println("</script>");
		}
		else if (result == -1) // 아이디 존재하지 않음
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')");
			script.println("history.back()"); // 이전 페이지로 사용자 돌려보내기
			script.println("</script>");
		}
		else if (result == -2) // 데이터 베이스 오류
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()"); // 이전 페이지로 사용자 돌려보내기
			script.println("</script>");
		}
	%>
</body>
</html>