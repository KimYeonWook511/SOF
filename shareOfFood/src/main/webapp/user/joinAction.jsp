<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("utf-8"); %>
<!-- scope="page" : 현재의 페이지 안에서만 빈즈 사용 가능 -->
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="userID"/>
<jsp:setProperty name="user" property="userPassword"/>
<jsp:setProperty name="user" property="userName"/>
<jsp:setProperty name="user" property="userGender"/>
<jsp:setProperty name="user" property="userEmail"/>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 회원가입 처리</title>
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
	
		// null값 처리
		if (user.getUserID() == null) // 회원가입 아이디 입력란 null일때
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('아이디를 입력해 주세요.')");
			script.println("history.back()"); // 이전 페이지로 사용자 돌려보내기
			script.println("</script>");
		}
		else if (user.getUserPassword() == null) // 회원가입 비밀번호 입력란 null일때
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호를 입력해 주세요.')");
			script.println("history.back()"); // 이전 페이지로 사용자 돌려보내기
			script.println("</script>");
		}
		else if (user.getUserName() == null) // 회원가입 이름 입력란 null일때
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이름을 입력해 주세요.')");
			script.println("history.back()"); // 이전 페이지로 사용자 돌려보내기
			script.println("</script>");
		}
		else if (user.getUserGender() == null) // 회원가입 성별 선택란 null일때 (사실상 실행 안됨)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('성별을 선택해 주세요.')");
			script.println("history.back()"); // 이전 페이지로 사용자 돌려보내기
			script.println("</script>");
		}
		else if (user.getUserEmail() == null) // 회원가입 이메일 입력란 null일때
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이메일을 입력해 주세요.')");
			script.println("history.back()"); // 이전 페이지로 사용자 돌려보내기
			script.println("</script>");
		}
		else
		{
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user); // id가 user인 자바빈을 매개변수로 삽입
			
			if (result == -1) // mysql에서 userID가 PK이므로 아이디가 겹친 경우임
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()"); // 이전 페이지로 사용자 돌려보내기
				script.println("</script>");
			}
			else // 회원가입 성공
			{
				session.setAttribute("userID", user.getUserID()); // 회원가입 성공시 세션 생성			
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = '/index.jsp'");
				script.println("</script>");
			}
		}
	%>
</body>
</html>