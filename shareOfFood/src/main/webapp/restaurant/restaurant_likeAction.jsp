<%@ page import="java.io.PrintWriter" %>
<%@ page import="restaurant.Restaurant" %>
<%@ page import="restaurant.RestaurantDAO" %>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SOF | 맛집 좋아요 처리</title>
</head>
<body>
	<%
		int no = 0;
		String userID = (String)session.getAttribute("userID");
		
		if (request.getParameter("no") != null)
		{
			no = Integer.parseInt(request.getParameter("no"));
		}
			
		RestaurantDAO restDAO = new RestaurantDAO();
			
		if (no == 0 || restDAO.getRestaurant(no) == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('등록되지 않은 음식점입니다.')");
			script.println("location.href = '/index.jsp'");
			script.println("</script>");
		}
		else if(userID == null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요한 기능입니다.')");
			script.println("location.href = '/user/loginForm.jsp'");
			script.println("</script>");
		}
		else
		{
			int result = restDAO.isLike(no, userID);
			
			if (result == 1) // 이미 좋아요 눌렀을 시
			{
				result = restDAO.deleteLike(no, userID);
				
				if (result == -1)
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('좋아요 취소 중 오류가 발생했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = '/restaurant/restaurant_view.jsp?no=" + no + "'");
					script.println("</script>");
				}
			}
			else if (result == 0) // 좋아요 안 눌렀을 시
			{
				result = restDAO.addLike(no, userID);
				
				if (result == -1)
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('좋아요 추가 중 오류가 발생했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = '/restaurant/restaurant_view.jsp?no=" + no + "'");
					script.println("</script>");
				}
			}
			else // 데이터베이스 에러
			{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('데이터베이스 에러')");
				script.println("history.back()");
				script.println("</script>");
			}
		}
	%>
</body>
</html>